---
project_name: 'ctam-analysis (CTAM Pathfinder)'
user_name: 'Ramnish'
date: '2026-08-19'
sections_completed: ['technology_stack', 'delivery_discipline', 'backend', 'data_persistence', 'api_formats', 'frontend', 'testing', 'workflow_enforcement', 'critical_dont_miss']
existing_patterns_found: 40
status: 'complete'
rule_count: 49
optimized_for_llm: true
---

# Project Context for AI Agents

_This file contains critical rules and patterns that AI agents must follow when implementing code in this project. Focus on unobvious details that agents might otherwise miss._

> **Scope note:** `ctam-analysis` is the planning/architecture hub — it holds no runtime code. These rules govern the **CTAM Pathfinder service code** the agents implement in the polyrepo (`ctam-reference-data`, `ctam-authorisation`, … `ctam-ui`, `ctam-admin-ui`). This file is the lean, LLM-optimised distillation of `conventions.md` + `architecture.md` + `repo-structure.md` + `delivery-operating-model.md`; those remain authoritative.

---

## Technology Stack & Versions

- **Backend:** Java 25 (LTS) · Spring Boot 4 · Gradle **Groovy** DSL + Wrapper · scaffold from `hmcts/service-hmcts-crime-springboot-template`
- **Data:** PostgreSQL 17 (Azure Flexible Server; 16 acceptable) · **Liquibase** (CTAM standard — the template ships Flyway; **do not use Flyway**)
- **Frontend:** React 18.x · TypeScript 5.x · Vite 5.x · GOV.UK Design System (**no Tailwind**) · TanStack Query · React Hook Form + Zod · axe-core
- **Platform:** AKS (UK South, multi-AZ) · Helm · Terraform · APIM · Azure Key Vault · OpenTelemetry → App Insights · TLS 1.3 min (1.2 fallback)
- **Libraries:** Lombok · MapStruct · OWASP Java Encoder · JaCoCo · CycloneDX · Swagger Core

## Critical Implementation Rules

### Delivery & repo discipline (polyrepo)

- **No shared runtime library** — duplication is accepted; consistency is enforced by CI / ArchUnit / Spectral / Pact / review, never a lib. Never introduce a shared code module.
- Each service = own repo, pipeline, release cadence. Cross-service work goes via **API contracts, not shared code**.
- **Reference Data is read directly via JPA** from the shared schema — there is **no `ReferenceDataClient`**. Other services are called via typed clients.
- **Contracts are producer-owned:** each service generates its OpenAPI (Swagger Core) and publishes by Gradle `maven-publish` as a Maven-format artefact (`uk.gov.hmcts.ctam:api-ctam-{service}:{version}`); consumers pin the version. `ctam-architecture` holds a **read-only mirror only**.
- Implementation output lands in the **target repo**; the planning repo is never written to. **Work on a feature branch and push it; `main` is protected and the PR is the human gate** — never commit/push to `main`, force-push, tag, or use `gh`.

### Backend (Java / Spring Boot)

- Package `uk.gov.hmcts.ctam.{service}.{layer}` (controller/service/repository/domain/dto/client/config/error/exception).
- **Per-request auth:** custom `JWTFilter` validates JWT vs IdP JWKS → `POST /authz/check` → populates request-scoped `AuthDetails` (roles + jurisdiction + Region/Area scope + activation flag). CTAM variance from the template's claims-only approach (FR2/FR57). Every service implements it; no shared lib.
- **Errors:** per-service `@ControllerAdvice` → RFC 9457 `application/problem+json`. Fixed exception→status map (validation 422, authorisation 403, business-rule 409/422, dependency 502, concurrency 409, unexpected 500).
- **Retry/concurrency = native PostgreSQL + JPA only:** unique constraints (dup-create → 409), optimistic locking, pessimistic row locks. **No idempotency-key tables, no IdempotencyFilter.**
- **Inter-service:** typed client per callee in `client/`, wrapping Spring Boot 4 `RestClient` with JWT-propagation + correlation-ID interceptors; **domain-language method names**, not HTTP verbs. Two auth modes: JWT propagation (user flows) vs OAuth `client_credentials` (batch, e.g. `ctam-payment-batch`).

### Data & persistence

- Single shared schema; per-service DB roles enforce writes. **Whoever writes the Liquibase changelog owns the table.**
- **Prefix = ownership:** `ctam_` (CTAM-owned, entity-plural) · `jo_`/`mrd_` (upstream tier-a, **read-only in CTAM**, written only by `ctam-reference-data` ingestion) · `mock_` (dev-only, never prod). No `_overlays` suffix (use `ctam_joh_ticket`).
- **PK `id uuid` (never bigint).** FKs `{entity_singular}_id`; **JOH refs use `joh_id` (uuid) → `ctam_joh_identities`** (CTAM-assigned JOH id); `personnel_number` is the upstream link to `jo_people`, held only on `ctam_joh_identities`, never a domain FK. `created_at`/`updated_at timestamptz NOT NULL` on every table.
- **Liquibase for DDL only** (`src/main/resources/db/changelog/NNN-name.sql`) — not for loading upstream data. Cross-table grants are explicit in the owning service's changelog (tier-a: only `ctam_reference_data` writes; others SELECT at most).

### API & formats

- `/v1/` prefix; plural-noun resources (`/v1/johs`, `/v1/bookings`); actions as URL segments (`POST /v1/absences/{id}/approve`) — **never RPC route names**.
- Path vars/query params `camelCase`; JOH resources keyed on `{johId}` (CTAM UUID; `?personnelNumber=` filter). Headers `Title-Kebab-Case`, no `X-` prefix (`Correlation-Id`, `Idempotency-Key`, `Deprecation`, `Sunset`).
- **JSON `camelCase` everywhere** (DB `snake_case` → API `camelCase` via JPA/Jackson). Success = bare resource (**no `{data,error}` wrapper**). Booleans `true/false` (no 0/1, Y/N). **Timestamps ISO 8601 UTC always (`Z`)**; UI converts to UK local for display only.
- Pagination: cursor-based for large/chronological lists; offset for small filtered lists. Rate limiting at APIM, not in-service.

### Frontend (React / TypeScript)

- React 18 + TS 5 + Vite 5. GOV.UK Design System required for WCAG 2.2 AA — no Tailwind, no ad-hoc spinners (use GOV.UK loading patterns).
- **Module-per-domain** (`modules/{domain}/pages|components|hooks|api`), not by-type. Two UI repos (`ctam-ui` business, `ctam-admin-ui` admin) — no shared client lib between them.
- Server state: TanStack Query (`isLoading`/`isError` pattern). Forms: React Hook Form + Zod matching the OpenAPI shape. **Server is source of truth — UI validation is UX-only, never enforces a constraint the server doesn't.**
- API clients generated per backend service from its OpenAPI (`openapi-typescript-codegen`/`orval`), regenerated in the repo's own CI.

### Testing

- Unit `*Test.java` (mock deps) · Integration `*IT.java` (Testcontainers PostgreSQL) · Contract (Pact) — every commit. E2E (Playwright) one suite per phase as a gate.
- **TDD is mandatory and evidence-based** (agent-rules R2/T1): no edit to `src/main/**` without a test that was *run* and failed **on an assertion** first — a compile error is not a red test. Use `./scripts/red.sh <TestClass>`; paste red, then green.
- **Coverage target = behaviour coverage, not line coverage;** PRs justify behaviour, not coverage stats. **Backed by build-failing floors (2026-08-19):** JaCoCo **≥ 85% line / ≥ 75% branch** and PIT mutation **≥ 70%** on `service` + `domain` (`config`, `dto`, `*Application`, generated code excluded). Mutation score is the load-bearing number — **a test that asserts nothing is a rule breach, not a pass**.
- **Every AC maps to a named test** whose name states the behaviour; carry the AC id in `@DisplayName`. One behaviour per test; no logic in tests; no `@Disabled`; no `Thread.sleep`; no ambient clock (inject `java.time.Clock`). **Never H2** — Testcontainers PostgreSQL for every schema change.
- **Incumbent parity (`[ET-INCUMBENT-TBD]` ET wave 1 / ListAssist SSCS wave 2 / APEX Courts waves 3+) is MANUAL UAT** under `docs/uat/` per service — a wave-cutover sign-off gate, **not** a CI harness. No `*ApexParityTest.java`.

### Workflow & enforcement

- Scaffold every service from the HMCTS Crime SpringBoot template; Gradle Groovy DSL + Wrapper.
- **CI gates (fail build on violation):** Spotless+Checkstyle (Java), ESLint+Prettier (TS), SQLFluff (SQL), ArchUnit (package/naming/deps), Spectral (OpenAPI ruleset), Pact, JaCoCo coverage floor + PIT mutation threshold, CycloneDX SBOM, axe-core (UI). One command runs the lot: `./scripts/verify.sh`.
- **Agent delivery rules are binding** — `_arch/agent-rules/` on the context bus (`ctam-architecture`), installed per repo as a lean always-on `CLAUDE.md` plus on-demand rule files. Non-negotiables: **cite or ask** (every non-obvious decision names its authority), **unknown ⇒ stop** (never infer a business rule), **no unsanctioned surface** (no new dependency/table/endpoint/env var without a cited source), **nothing unfinished ships** (no TODO/stub/disabled test), **no success claim without pasted evidence**, **status `in-review`, never `done`**.
- **Hard modularity limits (build-failing):** method ≤ 30 lines · file ≤ 300 · params ≤ 4 · cyclomatic ≤ 8 · instance fields ≤ 8 · public methods ≤ 10 · one public type per file; `controller` → `service` → (`repository` | `client`), `domain` depends on none of them, entities never cross the API boundary, `@Transactional` on service methods only, constructor injection only. **When a limit blocks you, change the design — never raise the limit or add a suppression.**
- Git: branch `feature/{ticket}-{desc}`; Conventional Commits (`feat:`/`fix:`/`docs:`/`refactor:`/`test:`/`chore:`), imperative, ≤72-char subject; PRs → `main` (trunk-based). **An agent may commit and push its feature branch; it may never write to `main`, force-push, tag, or merge the PR** — that is the human gate.
- Pattern changes = PR against `architecture.md`/`conventions.md`; **existing services are not force-retrofitted** (no version cascade); new services adopt the new pattern.
- Logging: SLF4J per class (or Lombok `@Slf4j`); Logstash JSON encoder + OpenTelemetry trace context; `correlationId` in MDC on every line.

### Critical don't-miss / security

- **NEVER log** PII (judge data, payroll/personnel numbers), bank details, case-level identifiers, or raw request bodies.
- **NEVER store bank details** (NFR14); MI/read models hold **no case-level data** (NFR23).
- Timestamps stored UTC only. TLS 1.3 min (1.2 fallback). Secrets via Azure Key Vault (Spring Cloud Azure), never in code/repo.
- **Anti-patterns:** bigint PKs · `snake_case` JSON · success wrappers · custom error shapes · `200` with `success:false` · RPC-style routes · shared runtime library · `ReferenceDataClient` (read Reference Data via JPA) · Flyway · local-tz timestamps.

---

## Usage Guidelines

**For AI agents:**

- Read this file before implementing any code in a CTAM Pathfinder service repo — then read `_arch/agent-rules/00-core.md` (how to work) alongside it. This file says *what* to build; agent-rules says *how*.
- Follow ALL rules exactly; when in doubt, prefer the more restrictive option.
- This is a lean summary — `conventions.md`, `architecture.md`, `repo-structure.md`, and `delivery-operating-model.md` (via the `ctam-architecture` context bus) remain authoritative for detail.
- Do not run git write commands; surface the diff for the human to commit externally.

**For humans:**

- Keep this file lean and agent-focused; update when the tech stack or a convention changes (via a PR against `conventions.md`/`architecture.md` first).
- When the `ctam-architecture` context bus is stood up, this file seeds each service repo's `CLAUDE.md`; keep it in sync with the pinned bus version.
- Review periodically; remove rules that become obvious.

Last Updated: 2026-08-19
