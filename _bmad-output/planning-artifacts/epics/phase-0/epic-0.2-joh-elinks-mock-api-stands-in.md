---
type: 'Epic'
description: "User outcome: ctam-reference-data's nightly eLinks sync runs end-to-end against a locally-run, schema-faithful mock of the JOH eLinks People API v5 - built as a Java/Spring Boot service like every other CTAM Pathfinder repo, not the original Node/Express implementation - so Phase 0 has a demoable ingestion pipeline in local development before the real eLinks contract (gaps.md G8.1) is confirmed."
resource: 'epics/phase-0/epic-0.2-joh-elinks-mock-api-stands-in.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-25'
parent: 'epics/phase-0/index.md'
epic: 0.2
title: 'JOH eLinks mock API stands in for the unconfirmed upstream contract'
storyCount: 3
repo: ctam-jomockapi
depends_on: []
---

# Epic 0.2: JOH eLinks mock API stands in for the unconfirmed upstream contract

> **Scope reduction** *(SCP 2026-08-25f)*: this epic no longer deploys to any shared dev/staging environment. `ctam-jomockapi` runs **locally via Docker Compose** during development — the service being ingested from (`ctam-reference-data`) is likewise run locally in this scope. `depends_on` drops the estate dependency entirely (`[]`); the Key Vault / AKS / APIM deployment stories are replaced with local-only equivalents.
>
> **Stack change** *(SCP 2026-08-25g)*: `ctam-jomockapi` is no longer built as a standalone Node.js/Express service. It is **scaffolded from the same HMCTS Crime SpringBoot template as every other CTAM Pathfinder service** (`ctam-scaffold.sh`, AR2–AR9) and the existing Node/Express reference implementation's documented eLinks v5 contract — endpoints, fixed-seed data, auth behaviour — is **faithfully ported to Java/Spring Boot**, not redesigned. This removes the stack deviation gaps.md/assumptions.md previously recorded for it (A38, revised).

**User outcome:** `ctam-reference-data`'s nightly JOH eLinks sync (Story 0.3.3) runs **end-to-end against a locally-running mock** of the eLinks People API v5 — not just a CI-only WireMock stub — so Phase 0 has a genuine, demoable ingestion pipeline in local development while the real eLinks API contract remains unconfirmed (gaps.md G8.1). `ctam-jomockapi` is onboarded as CTAM Pathfinder's 17th repo, non-production-only, in the same category as `ctam-mock-auth` (repository-strategy.md) — and, as of this scope, built with the **same Java/Spring Boot stack as every other repo**.

**Hosting:** `ctam-jomockapi` is scaffolded like every other CTAM Pathfinder backend service — HMCTS Crime SpringBoot template + `ctam-scaffold.sh` conventions (AR2–AR9) — **no stack deviation**. It runs locally via Docker Compose only in this scope — no shared-estate deployment.

**Vertical slice:**
- Scaffold `ctam-jomockapi` from the HMCTS Crime SpringBoot template (`ctam-scaffold.sh`, same pattern as `ctam-reference-data`/`ctam-joh`), per the manual GitHub-setup runbook (D10 — no `gh` CLI)
- Port the existing Node/Express reference implementation's documented contract — `/people` change-feed, `/leavers`, `/deleted`, 11 `/reference_data/*` vocabularies, `/healthcheck`, bearer-token handling, fixed-seed deterministic data generation — to Java/Spring Boot controllers/services: a **faithful reimplementation**, not a redesign
- CI: Gradle build + JUnit test suite (ported from the existing `test/` suite, behaviour-equivalent assertions) + lint gates; confirm the container image builds (no registry push — nothing deploys from it in this scope)
- A `docker-compose.yml` service definition for local bring-up of `ctam-jomockapi` alongside `ctam-reference-data`
- A local mock bearer credential set via `application-dev.yml`/`.env` (non-secret — the mock accepts any non-empty token); no Key Vault involved
- `ctam-reference-data`'s eLinks sync (Story 0.3.3) points its **local** base URL at the docker-compose `ctam-jomockapi` service instead of a placeholder

**FRs covered:** none directly (infrastructure/tooling, not a product feature). **Supports:** FR1, FR6 tier-(a), FR7 tier-(a), NFR24 (exercised end-to-end locally, pre-contract).

**Key NFRs first exercised here:** none — this epic runs entirely in local development; NFR16 (Key Vault), NFR31 (Azure UK South) and NFR40 (per-service deployable) are **not** exercised here since nothing is deployed to the shared estate. They remain open for whichever epic first deploys `ctam-reference-data`'s eLinks integration to a shared environment.

**Out of scope (explicitly):**
- The real JOH eLinks API contract (gaps.md G8.1 remains open until Judicial Office confirms it; production cutover is gated on that, not on this epic)
- MRD ingestion (Story 0.8.1) — the mock covers eLinks only, not MRD's Excel feed
- **Any behaviour change to the mock's documented contract during the Java port** — endpoint shapes, seeded data, and auth handling are carried over unchanged; this is a stack port, not a redesign
- **A database of any kind** — the mock stays stateless, seeded from fixture data at startup (ported from the existing `ReferenceData/*.csv|json` files into the Java service's resources); no Liquibase, no Testcontainers PostgreSQL, unlike every domain service
- **Deployment of `ctam-jomockapi` to any shared environment (dev, staging, or production)** — local Docker Compose only, per SCP 2026-08-25f; a future epic can add shared-estate deployment if a demoable dev/staging pipeline is later needed

---

## Story 0.2.1: Scaffold `ctam-jomockapi` from the HMCTS starter and port the eLinks mock to Java/Spring Boot

As a **platform engineer**,
I want `ctam-jomockapi` scaffolded from the same HMCTS Crime SpringBoot template as every other CTAM Pathfinder service, with the existing Node/Express mock's documented eLinks v5 contract faithfully reimplemented in Java/Spring Boot,
So that **the mock is a tracked, reviewable, CI-gated Java/Spring Boot artifact like every other repo in the polyrepo** — no Node/Express stack deviation — while its endpoint behaviour, seeded data, and contract shape are unchanged from the existing reference implementation.

**Acceptance Criteria:**

**Given** the engineer has performed the GitHub manual-setup checklist (`ctam-architecture/runbooks/github-setup.md`) **before** running the scaffold,
**When** the engineer runs `ctam-scaffold.sh ctam-jomockapi` from `ctam-architecture/scaffolding/`,
**Then** the script scaffolds a Spring Boot 4.0.x project locally from `https://github.com/hmcts/service-hmcts-crime-springboot-template`, commits, and pushes to the pre-created remote on a feature branch via plain `git` (no `gh` CLI, per D10),
**And** Group ID is `uk.gov.hmcts.ctam`, artefact is `ctam-jomockapi`, base package is `uk.gov.hmcts.ctam.jomockapi`, default port is `8090` (chosen distinct from every other CTAM service's port to avoid collisions when run together via Docker Compose, per Story 0.2.2),
**And** Gradle build uses Groovy DSL with Spring Boot Gradle plugin 4.1.0 and `io.spring.dependency-management:1.1.7` (per AR5),
**And** Lombok, springdoc-openapi (OpenAPI 3.x generation for the mock's own contract), JaCoCo, gradle-git-properties, gradle-docker-compose plugin, Spotless, and Checkstyle are configured (per AR6, AR8–AR11, AR17),
**And** Spring Boot Test with JUnit 5 (`junit-bom:6.0.3`) is configured for unit/controller tests (per AR14),
**And** — **unlike every domain service** — **no** Liquibase, **no** Testcontainers PostgreSQL, and **no** MapStruct are configured: the mock is stateless, serving fixed-seed generated data with no database and no cross-object mapping need,
**And** a Helm chart skeleton and per-service `terraform/` directory are **not** created — this epic never deploys anywhere but a developer's machine (SCP 2026-08-25f), so neither applies,
**And** GitHub Actions workflow `.github/workflows/ci.yml` exists (no `deploy-*.yml` of any kind), `CODEOWNERS`, `PULL_REQUEST_TEMPLATE.md`, and a Postman collection skeleton exist (per AR28, AR29, AR41).

**Given** the existing Node/Express reference implementation's documented contract (the real `E-links API v5.0` Swagger doc, `apiresponses.docx`, and the `ReferenceData/*.csv|json` seed fixtures),
**When** the engineer ports it to Java/Spring Boot controllers and services,
**Then** every endpoint is reimplemented with an **identical** request/response shape:
- `GET /api/v5/people` — the change-feed, **requiring** `updated_since` (missing → `400` validation error, per the documented contract) plus optional `per_page` (default 50), `page` (default 1), and `include_previous_appointments`, paginated per the documented `PaginationResponse` shape (`pages`, `current_page`, `results_per_page`, `more_pages`),
- `GET /api/v5/people/{id}` — single-person lookup by id, with optional `include_previous_appointments` (a distinct endpoint from the change-feed, both present in the real contract),
- `GET /api/v5/leavers` — **requiring** `left_since`, optional `per_page`/`page`, paginated (100 records, independent of the 100 `/people` profiles),
- `GET /api/v5/deleted` — **requiring** `deleted_since`, optional `per_page`/`page`, paginated (100 records, independent of the 100 `/people` profiles),
- `GET /api/v5/reference_data/{attribute_name}` — the 11 vocabularies (`appointment_titles`, `base_locations`, `contract_types`, `genders`, `judiciary_roles`, `jurisdictions`, `location_types`, `locations`, `ticket_categories`, `ticket_category_types`, `tickets`), each also reachable via its documented deprecated singular alias (`appointment_title`, `base_location`, `contract_type`, `gender`, `judiciary_role`, `jurisdiction`, `location_type`, `location`, `ticket_category`, `ticket_category_type`, `ticket`) on the same `attribute_name` path parameter,
- `GET /api/v5/reference_data/{attribute_name}/{reference_id}` — single reference-data item lookup by id,
- `GET /api/v5/healthcheck`,

**And** the fixed-seed deterministic data generation is ported so IDs stay stable across restarts, exactly as the Node implementation behaves,
**And** the `ReferenceData/*.csv|json` fixture files are carried over into the Java service's `src/main/resources/` **unchanged in content** — only the loading mechanism changes (Node's file read → Spring's classpath resource loading),
**And** bearer-token handling is ported unchanged: any non-empty token is accepted, exercising the *wiring* the real eLinks credential will use, not an auth check.

**Given** the scaffolded and ported service runs locally via `./gradlew bootRun`,
**When** the engineer queries `http://localhost:8090/api/v5/healthcheck`,
**Then** the response matches the Node implementation's documented shape,
**And** structured JSON logs via Logstash Logback Encoder appear on stdout, consistent with every other CTAM service (per AR30) — an improvement over the Node original, not a behavioural contract change.

**Given** CI,
**When** `ci.yml` runs on a PR,
**Then** the Gradle build + the JUnit test suite (ported from the existing `test/` suite, with behaviour-equivalent assertions against the same fixtures) + Spotless + Checkstyle pass,
**And** the container image builds successfully (no registry push — this epic never deploys the image anywhere; Story 0.2.2 runs it locally via Docker Compose instead).

**Given** this is a non-production-only, local-only mock,
**When** the CI workflow is authored,
**Then** there is **no** `deploy-dev.yml`, **no** `deploy-staging.yml`, and **no** `deploy-production.yml` — this epic has no deployment workflow at all, mirroring `ctam-mock-auth`'s "never deployed to production" guard, taken one step further (never deployed anywhere but a developer's machine, in this scope).

**References:** repository-strategy.md (row revised — Java/Spring Boot, not Node); AR2–AR9, AR14, AR17, AR28, AR29, AR41; D10; gaps.md G8.1; assumptions.md A38 (revised — no longer a stack deviation); the real `E-links API v5.0` Swagger doc and June 2026 production reference-data exports, archived to `_bmad-output/source-docs/joh-elinks-api/` (SCP 2026-08-25k); this epic has no dependency on Epic 0.0 — Story 0.2.2 runs the mock locally, not on the shared estate.

**Explicitly NOT in scope:**
- Running the mock anywhere but locally — Story 0.2.2
- Any change to the mock's documented endpoint behaviour, seeded data, or auth handling during the port — faithful reimplementation only
- Adding a database, Liquibase changelog, or any persistence layer — the mock stays stateless
- Mounting routes under the real API's `/elinks` gateway-routing path segment (visible in the Swagger doc's `Servers` value) — that segment is production gateway routing, not part of the application contract, and this mock runs with no gateway in front of it locally; routes stay bare `/api/v5/...`

---

## Story 0.2.2: Run `ctam-jomockapi` locally via Docker Compose

As a **platform engineer**,
I want `ctam-jomockapi` runnable locally via Docker Compose, with its mock bearer credential set via a local environment file,
So that **it is reachable over the local Docker network by `ctam-reference-data`'s scheduled sync job during development**, not just runnable standalone via `./gradlew bootRun`.

**Acceptance Criteria:**

**Given** `ctam-jomockapi` is scaffolded and ported per Story 0.2.1,
**When** a `docker-compose.yml` service definition (`jomockapi`) is added,
**Then** `docker-compose up jomockapi` starts the mock reachable at a stable Docker-network hostname (e.g. `jomockapi:8090`) and, if published, `http://localhost:8090` on the host,
**And** liveness passes against `GET /api/v5/healthcheck` (public, no auth, per the mock's existing contract),
**And** the running container's logs confirm the mock data was generated with the documented fixed seed (ids stable across restarts).

**Given** the mock requires a bearer token (any non-empty value, per its existing auth behaviour),
**When** a mock credential is set via a local `.env` value (documented as a placeholder in `README.md`; not a secret, since the mock accepts any non-empty token and this never runs outside a developer's machine),
**Then** the credential is available to any local consumer without any Key Vault or cloud secret store involved.

**Given** the running local mock,
**When** an engineer curls `GET /api/v5/reference_data/jurisdictions` with the local token from the host or from another container on the same Docker network,
**Then** the response matches the documented `ReferenceDataResponse` shape and returns the real jurisdiction reference values.

**References:** NFR40 does not apply (no per-service Kubernetes deployment in this scope); no epic dependency (local only, no shared estate involved).

**Explicitly NOT in scope:**
- Wiring `ctam-reference-data`'s sync to this local instance — Story 0.2.3
- Deployment to any shared environment (dev, staging, or production) — not in this epic's scope at all, per its out-of-scope note

---

## Story 0.2.3: `ctam-reference-data`'s eLinks sync runs against the locally-running mock

As a **CTAM Pathfinder platform** (and every downstream consumer of JOH identity and reference data),
I want Story 0.3.3's nightly `@Scheduled` eLinks sync to run, during local development, against the `ctam-jomockapi` instance started in Story 0.2.2,
So that **the full ingestion pipeline — full-refresh-upsert, `ctam_joh_identities` minting, soft-deactivation of records absent upstream, `ctam_sync_status` logging — is demoable end-to-end locally before the real eLinks contract (G8.1) is confirmed.**

**Acceptance Criteria:**

**Given** `ctam-jomockapi` is running locally per Story 0.2.2, and the local mock credential is available to `ctam-reference-data`'s local process (via `application-dev.yml` / `.env`),
**When** `ctam-reference-data`'s local configuration sets the eLinks base URL to the docker-compose `ctam-jomockapi` service's Docker-network hostname instead of any unset/placeholder value,
**Then** the nightly (and manually-triggered) sync run in Story 0.3.3 completes successfully against it when both services are run locally together (`docker-compose up`),
**And** all 15 `jo_*` tables populate from the mock's `/people` change-feed and `/reference_data/*` responses,
**And** `jo_people.personnel_number` upserts correctly and mints `ctam_joh_identities` rows exactly as designed for a real upstream source.

**Given** the mock's `/leavers` and `/deleted` endpoints (100 records each, independent of the 100 `/people` profiles),
**When** the sync's soft-deactivation logic (rows absent upstream marked inactive, never hard-deleted, per AR46) is exercised against them,
**Then** the behaviour is verified against realistic leaver/deleted data — something the CI WireMock stub's canned fixtures don't exercise as thoroughly.

**Given** the CI-only WireMock/stub eLinks API (AR54) used by `ctam-reference-data`'s automated tests,
**When** this story lands,
**Then** the WireMock stub is **retained unchanged** for unit/integration tests — it and the locally-running `ctam-jomockapi` are complementary (fast, hermetic CI checks vs. a realistic local network target), not a replacement of one by the other.

**Given** the real JOH eLinks API contract is still unconfirmed (gaps.md G8.1),
**When** this story's ACs are met,
**Then** G8.1 is **not** closed by this story — it remains open until Judicial Office confirms the real contract and it is validated against the (by-then-live) ingestion mapping; this story closes the *local demonstrability* gap only, not the *contract-confirmation* gap, and does **not** demonstrate the pipeline in any shared (dev/staging) environment.

**References:** FR1, FR6 tier-(a), NFR24 (exercised locally only — not in a shared environment); gaps.md G8.1 (stays open); AR46, AR48, AR54; depends on Story 0.3.3 and Story 0.2.2.

**Explicitly NOT in scope:**
- Closing G8.1 — that needs the real contract from Judicial Office
- Demonstrating this pipeline in a shared dev/staging environment — this epic is local-only, per its scope-reduction note
- MRD ingestion (Story 0.8.1) — unaffected, no mock exists or is needed for MRD in this SCP
