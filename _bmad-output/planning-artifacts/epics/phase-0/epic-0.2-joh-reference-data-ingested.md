---
type: 'Epic'
description: 'User outcome: Judicial-holder reference data flows into CTAM Pathfinder from its upstream source of truth — the JOH eLinks API (15 jo_ entities, nightly) — so that jo_people exists and is current…'
resource: 'epics/phase-0/epic-0.2-joh-reference-data-ingested.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-06-17'
parent: 'epics/phase-0/index.md'
epic: 0.2
title: 'Upstream JOH reference data is ingested'
storyCount: 3
---

# Epic 0.2: Upstream JOH reference data is ingested

**User outcome:** Judicial-holder reference data flows into CTAM Pathfinder from its upstream source of truth — the **JOH eLinks API** (15 `jo_*` entities, nightly) — so that `jo_people` exists and is current, `jo_jurisdictions` is available as the first-class jurisdiction dimension (D8), and judicial-holder reference data is authoritative in CTAM **without any legacy migration** (revised D3, NFR24). This is the platform's foundational data layer: every downstream consumer of JOH identity and reference data depends on it, and JOH sign-in (Epic 0.4) is impossible until `jo_people` — the identity-lookup target — is populated.

**Hosting:** the ingestion runs in-process inside `ctam-reference-data` — no separate `ctam-integrations` repo. `ctam-reference-data` is the first **domain** service scaffolded; it deploys onto the shared Azure estate provisioned in **Epic 0.0** (`ctam-shared-infrastructure`) and carries only its **own** per-repo Terraform — Key Vault namespace, its own APIM API definition + per-API policy, and later the MRD storage account (Epic 0.3, Story 0.3.1).

**Upstream stand-in:** the real JOH eLinks contract is **unconfirmed** (gaps.md **G8.1**, a wave-1 blocker), so this epic is built and demoed against **`ctam-joh-mock`** — the contract-shaped, deployable stand-in delivered in **Epic 0M.1** ([Phase 0-Mock](../phase-0-mock/index.md)), serving all 15 `jo_*` entities from a version-tagged ET-flavoured fixture set with on-demand fault injection. Epic 0.2's `depends_on` therefore names Epic 0M.1. Cutting over to real eLinks is a **configuration change** (base URL + Key Vault credential), mirroring the `ctam-mock-auth` → HMCTS IdP pattern; **G8.1 closes only when this sync has run against real upstream data**, not when it passes against the mock.

**Prerequisites in `ctam-architecture`:** the **GitHub manual-setup runbook** and **`ctam-scaffold.sh`** this epic's first story invokes are delivered in **[Epic 0.A](epic-0.A-architecture-context-bus-and-scaffolding.md)** (Stories 0.A.3 and 0.A.2); the shared **`ctam_configuration_values` baseline and this service's `ctam_reference_data` DB role** in **[Epic 0.B](epic-0.B-shared-db-baseline-and-service-roles.md)** (Story 0.B.1). Both appear in this epic's `depends_on`.

**Vertical slice:**
- **First scaffolded backend service: `ctam-reference-data`** (HMCTS Crime SpringBoot template + `ctam-scaffold.sh` conventions per AR2–AR4 — the script itself is Story 0.A.2; this epic is its first real invocation)
- **Consumes the shared Azure estate** (AKS, shared global PostgreSQL Flexible Server + per-service DB roles, ACR, APIM, App Insights, Key Vault) **provisioned in Epic 0.0** per AR53 (revised — dedicated `ctam-shared-infrastructure`)
- Consumes the shared `ctam_configuration_values` Liquibase baseline and the per-service DB roles established by `ctam-architecture` in **Epic 0.B** (FR8) — this service's role holds SELECT on the baseline table
- Tier-(a) upstream-sourced tables: 15 `jo_*` + `ctam_sync_status` (CTAM-internal ingestion run log — shared with the MRD ingestion in Epic 0.3), service-owned Liquibase changelogs (AR18–AR20), tier-(a) write-protection (only `ctam_reference_data` holds INSERT/UPDATE — AR49, FR6)
- **JOH eLinks nightly in-process `@Scheduled` sync** (AR46, AR48) — each run is a three-stage pipeline: **cleanse** the raw JSON payload (reject/quarantine malformed records, normalise/type-coerce fields, de-duplicate natural keys), **transform** cleansed JSON entities into the relational `jo_*` table shape (per `architecture/data-tables.md`), **persist** via full-refresh-upsert to the shared PostgreSQL instance

**FRs covered:** FR1 (the identity-lookup *target* data — `jo_people` populated), FR6 tier-(a), FR7 tier-(a) grants, FR8 (shared `ctam_configuration_values` baseline first lands here); NFR24 (JOH eLinks MVP integration).

**Key NFRs first exercised here:** NFR10 (TLS at APIM), NFR11 (data-at-rest), NFR16 (Key Vault — incl. the eLinks API credential), NFR24 (JOH eLinks integration), NFR25–NFR28 (structured logs + Application Insights ingestion + liveness/readiness probes), NFR31 (Azure UK South data residency), NFR40 (per-service deployable on Kubernetes), NFR42 (Postman collections), NFR59 (structured logs first exercised at scaffold).

**Out of scope (explicitly):** the mock eLinks source itself — the `ctam-joh-mock` repo, its fixtures, and its fault-injection modes (**Epic 0M.1**). MRD supplementary reference data ingestion (**Epic 0.3** — a separate upstream source with its own format, cadence, and delivery mechanism). The read-only Reference Data API + jurisdiction filtering (Epic 0.5, Story 0.5.2 — downstream of auth). Tier-(b) CTAM-owned reference tables (Epic 0.5, Story 0.5.1). All authentication / authorisation / UI (Epic 0.4). Hand-editing of tier-(a) data in CTAM (never, in any phase — corrections at source per FR6).

---

## Story 0.2.1: Scaffold `ctam-reference-data` from the HMCTS starter (onto the Epic 0.0 estate)

As a **platform engineer**,
I want to scaffold the **first** CTAM Pathfinder backend service — `ctam-reference-data` — from the HMCTS Crime SpringBoot template using `ctam-scaffold.sh`, and to deploy it onto the shared Azure estate provisioned in Epic 0.0,
So that **subsequent services follow a consistent, version-pinned, supply-chain-secured baseline**, and the team can demonstrate the deployment pipeline end-to-end against the already-verified platform estate before any domain logic is written.

**Acceptance Criteria:**

**Given** the engineer has performed the GitHub manual-setup checklist (`ctam-architecture/runbooks/github-setup.md`, written in **Epic 0.A, Story 0.A.3**) **before** running the scaffold:
  - Created an empty private GitHub repo `ctam-reference-data` under the HMCTS org **via the GitHub web UI**
  - Enabled branch protection on `main` via Settings → Branches (require PR review, require status checks, require linear history)
  - Note: the `gh` CLI is **NOT** available in the engineering environment — all GitHub admin config (repo creation, branch protection, team access) happens manually via the web UI per the runbook,
**And** the engineer has a clean local development environment with Java 25, Gradle Wrapper, and Docker,
**When** the engineer runs `ctam-scaffold.sh ctam-reference-data` from `ctam-architecture/scaffolding/` (the script and its overlay are delivered in **Epic 0.A, Story 0.A.2**),
**Then** the script scaffolds a Spring Boot 4.0.x project **locally** from `https://github.com/hmcts/service-hmcts-crime-springboot-template`, then commits and pushes to the pre-created remote on a feature branch via plain `git` (no `gh` CLI invocation),
**And** the project contents include a Spring Boot 4.0.x scaffold from `https://github.com/hmcts/service-hmcts-crime-springboot-template`,
**And** Gradle build uses Groovy DSL with Spring Boot Gradle plugin 4.1.0 and `io.spring.dependency-management:1.1.7` (per AR5),
**And** Group ID is `uk.gov.hmcts.ctam`, artefact is `ctam-reference-data`, base package is `uk.gov.hmcts.ctam.referencedata`, and the port is **8082** per the per-service port allocation in `architecture/conventions.md` (AR3's "default port 8082" is the template default; the allocation table is the authority — `ctam-reference-data` keeps 8082 as the first service scaffolded),
**And** initial commit message is exactly *"Scaffold CTAM Pathfinder reference-data from HMCTS starter"* (per AR4),
**And** Lombok 1.18.46 + MapStruct 1.6.3 are configured (per AR6),
**And** JJWT 0.13.0 + OWASP Encoder 1.4.0 are on the classpath (per AR7),
**And** springdoc-openapi is configured for OpenAPI 3.x generation (per AR8),
**And** JaCoCo, CycloneDX SBOM, gradle-git-properties, gradle-versions, and gradle-docker-compose plugins are configured (per AR9–AR13),
**And** Spring Boot Test with JUnit 5 (`junit-bom:6.0.3`), Testcontainers PostgreSQL 1.21.4, Spring Boot Testcontainers 4.1.0, and spring-boot-starter-webmvc-test are configured (per AR14–AR15),
**And** Spectral, ArchUnit, Spotless, and Checkstyle are configured (per AR17), **together with SQLFluff and the schema-convention fitness function** the scaffold wires in from the bus (Epic 0.1 Story 0.1.2 authors the rules; Epic 0.A Story 0.A.2 wires them) — so a non-conformant changeset fails CI from this repo's first PR onward,
**And** a Helm chart skeleton exists at `charts/ctam-reference-data/` with `values-dev.yaml`, `values-staging.yaml`, `values-production.yaml` overlays (per AR24),
**And** a `terraform/` directory exists with per-environment stacks (`dev` / `staging` / `production`) holding **only this service's own resources** — its Key Vault namespace, **its own APIM API definition + per-API policy** (per `architecture/conventions.md` → *Per-service APIM registration ownership*), and later the MRD storage account (Epic 0.3, Story 0.3.1) — the shared estate and the APIM instance itself live in `ctam-shared-infrastructure` (Epic 0.0), per AR53 (revised),
**And** GitHub Actions workflows exist at `.github/workflows/ci.yml`, `deploy-dev.yml`, `deploy-staging.yml`, `deploy-production.yml` (per AR28),
**And** `CODEOWNERS` and `PULL_REQUEST_TEMPLATE.md` exist (per AR29),
**And** a Postman collection skeleton exists at `postman/ctam-reference-data-phase0.postman_collection.json` (per AR41).

**Given** the scaffolded service runs locally via `./gradlew bootRun` after a `docker-compose up postgres`,
**When** the engineer queries `http://localhost:8082/actuator/health`,
**Then** the response is `200 OK` with body `{"status":"UP"}`,
**And** `/actuator/info` returns Git metadata embedded by gradle-git-properties (per NFR28, AR11),
**And** `/actuator/readiness` returns `200 OK`,
**And** structured JSON logs via Logstash Logback Encoder 9.0 appear on stdout (per AR30, NFR25),
**And** logs include a `correlationId` populated by `CorrelationIdFilter` for each request (per AR32) — FR59 structured logging is first exercised here.

**Given** the shared Azure estate has been provisioned and independently verified in **Epic 0.0** (`ctam-shared-infrastructure`) — AKS, PostgreSQL Flexible Server, ACR, APIM + base policies, Application Insights / Log Analytics, Key Vault — all in UK South with the documented SKUs (per A34, gaps.md G9),
**When** `ctam-reference-data`'s Helm chart is deployed to the dev AKS cluster,
**Then** the service reaches the shared cluster, database, registry, gateway, and observability estate provisioned in Epic 0.0 (this story **consumes** the estate; it does not provision it — AR53 revised),
**And** the deployment fails fast with a clear diagnostic if any Epic 0.0 estate dependency is absent (making the Epic 0.0 → 0.1 sequencing explicit).

**Given** the `ctam-architecture` Liquibase baseline changelog and the per-service DB roles were applied in **Epic 0.B, Story 0.B.1** (it owns the shared infrastructure table and provisions every service role),
**When** this service connects,
**Then** the shared `ctam_configuration_values` infrastructure table exists (per FR8, AR19),
**And** the **`ctam_reference_data` DB role exists** and this service authenticates as it — not as a shared admin account — with its credential read from Key Vault (per NFR16),
**And** that role has `SELECT` on `ctam_configuration_values`, and an attempted write is refused by the database (per AR22),
**And** `ctam-reference-data`'s own service-owned Liquibase changelog directory (`src/main/resources/db/changelog/`, master `db.changelog-master.yaml`) exists but is empty (tier-(a) tables created in Story 0.2.2).

**Given** the shared APIM gateway (instance + base policies + WAF provisioned and TLS-verified in Epic 0.0, Stories 0.0.5/0.0.6),
**When** `ctam-reference-data` registers **its own API definition and per-API policy from this repo's `terraform/`** against that shared instance — using the cross-repo remote-state/data-source pattern recorded in `ctam-architecture/runbooks/terraform.md` (Story 0.A.3, gaps.md G10.2) — and an HTTP request reaches the gateway,
**Then** the service's API is reachable over TLS (the gateway TLS floor itself is verified in Epic 0.0 per NFR10),
**And** HTTP-only requests are rejected with a redirect to HTTPS,
**And** this repo's Terraform modifies **only** its own API and policy — the shared instance, base policies, WAF and rate-limit defaults stay owned by `ctam-shared-infrastructure` (`architecture/conventions.md`),
**And** because this is the **first** service to register, the pattern it uses is confirmed as reusable by Stories 0.4.1 and 0.8.1 rather than re-derived by each.

**Given** the shared PostgreSQL Flexible Server (provisioned + encryption/TLS-verified in Epic 0.0, Story 0.0.3),
**When** the Helm chart's `values-dev.yaml` is applied,
**Then** the database connection string references the shared Epic 0.0 PostgreSQL instance (storage-encrypted at rest per NFR11; TLS-only per NFR10 — both verified in Epic 0.0),
**And** `ctam-reference-data` connects successfully using its own DB role.

**Given** the shared Application Insights workspace (provisioned in Epic 0.0, Story 0.0.4, with the agreed retention policy),
**When** the deployed service emits telemetry,
**Then** `ctam-reference-data`'s structured logs and traces land in the shared workspace (retention is owned by Epic 0.0 per NFR26).

**Given** the engineer pushes the initial commit to a feature branch via `git push`,
**And** opens a Pull Request from that branch to `main` **manually via the GitHub web UI** (no `gh` CLI),
**When** the GitHub Actions `ci.yml` workflow runs,
**Then** the workflow runs build + test + Spectral lint + ArchUnit + Spotless + Checkstyle + Helm lint,
**And** all checks pass on the scaffolded baseline,
**And** code coverage report is produced by JaCoCo.

**Given** the PR is merged to `main` **via the GitHub web UI** (the engineer clicks "Merge pull request" after reviewer approval; no `gh` CLI),
**When** `deploy-dev.yml` triggers automatically,
**Then** the service deploys to the dev AKS cluster in UK South (per AR23, NFR31),
**And** the container image is pushed to Azure Container Registry,
**And** the deployed pod passes liveness + readiness probes (per NFR28),
**And** Azure Application Insights receives the first structured log entries via OpenTelemetry Collector (per AR31, NFR27).

**References:** FR8, FR58, FR59; NFR10, NFR11, NFR15, NFR16, NFR24, NFR25–NFR28, NFR31, NFR40, NFR42; AR2–AR17, AR23–AR32, AR41, AR53 (revised — estate provisioned in Epic 0.0); **D10** (`gh` CLI not available — manual GitHub web-UI setup per `ctam-architecture/runbooks/github-setup.md`); **depends on Epic 0.0** (shared estate).

> **Scaffolding note:** the HMCTS Crime SpringBoot template base is minimal; `ctam-scaffold.sh` assembles the remaining dependencies (Liquibase, Testcontainers, MapStruct, OWASP encoder, docker-compose plugin, OpenAPI tooling, Helm, Key Vault, the CI quality gates) from `hmcts/service-hmcts-springboot-demo` + CTAM conventions — inventory in `architecture/starter-template.md` §B (G1.4).

**Explicitly NOT in scope:**
- Tier-(a) `jo_*` tables and `ctam_sync_status` — Story 0.2.2
- The eLinks sync — Story 0.2.3
- MRD ingestion (its own tables, storage account, and mechanism) — Epic 0.3
- The `ctam-joh-mock` upstream stand-in (its own repo and scaffold) — Epic 0M.1
- Tier-(b) CTAM-owned tables + the read-only API — Epic 0.5
- **`ctam-scaffold.sh` itself, the GitHub-setup runbook, the `ctam_configuration_values` baseline and the DB roles** — Epics 0.A and 0.B; this story *consumes* all four

---

## Story 0.2.2: Tier-(a) upstream `jo_*` tables, `ctam_sync_status`, and tier-(a) write protection

As a **CTAM Pathfinder platform** (and every downstream consumer of JOH identity and reference data),
I want the 15 `jo_*` upstream-sourced tables and the `ctam_sync_status` run-log created with service-owned Liquibase changelogs and enforced single-writer ownership,
So that **`jo_people` and the rest of the tier-(a) surface exist with the correct schema and write protection before the eLinks sync populates them** (FR6 tier (a), AR49).

**Acceptance Criteria:**

**Given** `ctam-reference-data` is scaffolded per Story 0.2.1,
**When** the engineer adds the Liquibase changeset `db/changelog/001-init-tier-a-upstream-tables.sql` (formatted-SQL, included from `db.changelog-master.yaml`),
**Then** the 15 `jo_*` tables exist with schemas per `architecture/data-tables.md` (`jo_people`, `jo_appointments`, `jo_judiciary_role_assignments`, `jo_authorisations_with_dates`, `jo_appointment_titles`, `jo_base_locations`, `jo_contract_types`, `jo_genders`, `jo_judiciary_roles`, `jo_jurisdictions`, `jo_locations`, `jo_location_types`, `jo_tickets`, `jo_ticket_categories`, `jo_ticket_category_types`),
**And** `ctam_sync_status` exists (CTAM-internal ingestion run log — shared by the MRD ingestion in Epic 0.3, Story 0.3.1),
**And** `jo_people.personnel_number` is the upstream natural key, to which CTAM binds a stable `ctam_joh_identities.id` (UUID) — the CTAM-assigned canonical JOH identifier referenced by every downstream domain table (per AR22); `personnel_number` is the upstream link only,
**And** `jo_jurisdictions` preserves the upstream parent-child hierarchy shape (or establishes it on ingest)[^d8],
**And** the `ctam_reference_data` DB role owns the tables; **no other role holds INSERT/UPDATE on any `jo_*` table** (tier-(a) write protection per AR49, FR6),
**And** SELECT grants are made to `ctam_authorisation` (identity lookup, Epic 0.4) and to the forward-declared roles for future services — **all of which exist because Epic 0.B, Story 0.B.1 provisioned them**, so these grants apply rather than failing on an unknown role,
**And** the grants live in **this** service's changelog because it owns the tables (the grants convention documented in Story 0.B.1),
**And** the ArchUnit/grants fitness function in CI verifies the tier-(a) write-protection rule,
**And** `architecture/data-tables.md` is updated in `ctam-analysis` to match the as-created shape of all 16 tables — the design (Story 0.1.1) and the applied schema do not drift apart.

**References:** FR6 tier (a), FR7 (writes follow the tier); NFR15; AR18–AR20, AR22, AR49; D3 (revised), D8, D9 (restructured).

**Explicitly NOT in scope:**
- The eLinks sync that populates these tables — Story 0.2.3
- The `mrd_*` tables and their own Liquibase changeset — Epic 0.3, Story 0.3.1
- Tier-(b) CTAM-owned tables (regions, offices, vocabularies) — Epic 0.5, Story 0.5.1
- The read-only REST API — Epic 0.5, Story 0.5.2

---

## Story 0.2.3: JOH reference data flows into CTAM nightly from the JOH eLinks API

As a **CTAM Pathfinder platform** (and every downstream consumer of JOH identity and reference data),
I want an in-process scheduled sync that pulls the JOH eLinks API nightly and refreshes the tier-(a) `jo_*` tables,
So that **`jo_people` exists and is current — making JOH sign-in resolvable (FR1), jurisdiction available (`jo_jurisdictions`, D8), and judicial-holder reference data authoritative without any legacy migration** (revised D3, NFR24).

**Acceptance Criteria:**

**Given** the tier-(a) `jo_*` tables and `ctam_sync_status` exist per Story 0.2.2,
**When** the engineer implements the eLinks sync as an in-process `@Scheduled` task (per AR46 — no new deployable, no service principal),
**Then** the sync runs on its nightly schedule and pulls all 15 entities' JSON payloads from the JOH eLinks API using the outbound credential held in Azure Key Vault (per NFR16),
**And** a **cleansing stage** runs on each payload before any write: structurally malformed (non-parseable) JSON is rejected for that entity set; individual records with missing required fields, invalid types, or unresolvable enumerations are quarantined (skipped and logged) rather than silently written; string fields are trimmed and normalised; optional fields absent upstream are defaulted per the `jo_*` schema; records sharing the same natural key within one payload are de-duplicated (last-write-wins),
**And** a **transform stage** maps each cleansed JSON entity to its relational `jo_*` table shape per `architecture/data-tables.md` — including assembling `jo_jurisdictions`' parent-child hierarchy from the upstream structure (native or derived, per D8) — before any database write,
**And** a **persist stage** **full-refresh-upserts** the transformed rows into the `jo_*` tables keyed on the upstream natural key (`personnel_number` for `jo_people`), and mints a `ctam_joh_identities` row (a stable CTAM JOH UUID keyed to `personnel_number`) for any `jo_people` row lacking one,
**And** rows absent upstream after a successful cleanse+transform are **marked inactive — never hard-deleted** (FK protection per AR46),
**And** the run is recorded in `ctam_sync_status` with source, started/finished timestamps, outcome, per-entity row counts split by **cleansed / quarantined / persisted**, and error detail (per AR48),
**And** the sync is also manually triggerable by ops (e.g. an actuator-adjacent admin endpoint or k8s Job) for out-of-cycle refreshes.

**Given** the JOH eLinks API is unreachable or returns a structurally malformed payload (not valid JSON, or missing an entire expected entity block) mid-sync — reproducible on demand via `ctam-joh-mock`'s fault-injection modes (**Epic 0M.1**, Story 0M.1.2),
**When** the sync fails,
**Then** the previous good state remains fully in place (ingestion is transactional per entity set — never partially written, per AR48),
**And** the failure is recorded in `ctam_sync_status` and surfaced via structured logs with correlation ID for ops triage,
**And** reference data is at most one sync cycle stale.

**Given** a payload parses as valid JSON but contains individual non-conformant records (cleansing-stage quarantine, not a structural failure) — likewise reproducible via `ctam-joh-mock`'s fault-injection modes,
**When** the sync processes that entity set,
**Then** the conformant records still proceed through transform and persist for that run (a per-record quarantine does not fail the whole entity set),
**And** the quarantined records are counted and logged in `ctam_sync_status` for ops to escalate to the JOH eLinks team.

**Given** the sync has run successfully at least once in dev,
**When** `ctam-authorisation` (Epic 0.4, Story 0.4.3) looks up a seeded JOH email,
**Then** the lookup resolves against `jo_people` to a `personnel_number`, and via `ctam_joh_identities` to the CTAM JOH UUID,
**And** dev and CI run the sync against **`ctam-joh-mock`** (**Epic 0M.1**) — a deployed, contract-shaped stand-in reached over a real HTTP hop, not an in-process stub — so the whole cleanse/transform/persist path is exercised end-to-end while real eLinks access does not exist,
**And** the fixture version served by the mock is recorded against the run in `ctam_sync_status`, so a result can always be traced to the exact upstream payload set that produced it,
**And** switching to real eLinks changes **configuration only** — the base URL and the Key Vault credential — with no change to the sync code or its test suite.

**Given** the JOH eLinks API contract has not yet been confirmed (gaps.md G8.1),
**When** the contract lands,
**Then** the ingestion mapping is validated against it (every upstream field CTAM needs has a slot; the natural-key scheme holds; cadence/SLA workable),
**And** the comparison is made against **`ctam-joh-mock`'s published OpenAPI spec** — CTAM's written, executable expectation of the contract (**Epic 0M.1**) — so the exercise is a **diff**, not an open discovery,
**And** any unmapped upstream structure raises an architectural PR (per G8.1) — this AC is the story's external-dependency gate and is tracked explicitly in sprint planning,
**And** passing against the mock is explicitly **not** closure of G8.1.

**References:** FR1 (identity lookup target), FR6 tier (a), FR7 (writes follow the tier); NFR16, NFR24, NFR25–NFR28; AR46, AR48, AR49, **AR55**; gaps.md G8.1; D3 (revised), D8, D9 (restructured); **depends on Epic 0M.1** (`ctam-joh-mock`, Phase 0-Mock).

**Explicitly NOT in scope:**
- The `ctam-joh-mock` stand-in itself — Epic 0M.1
- MRD ingestion — Epic 0.3
- The read-only REST API — Epic 0.5, Story 0.5.2

[^d3]: Revised D3 (2026-06-10) — no data migration from any legacy system; judicial-holder reference data is ingested from the JOH eLinks API and MRD.
[^d8]: D8 — rollout is jurisdiction-first, then per-region; jurisdiction is a first-class hierarchical attribute.
[^d9]: Restructured D9 (2026-06-10; refined 2026-07-09 per SCP) — two user populations. JOHs resolve IdP email → `jo_people` → `personnel_number` → a **CTAM-assigned JOH UUID** (`ctam_joh_identities`); HMCTS admin staff via a CTAM-internal identity table. Both key on a CTAM-assigned UUID; `personnel_number` is the upstream link only. No legacy user migration.
[^d10]: D10 (2026-05-15) — admin UI is post-MVP; MVP admin operations are DBA-via-SQL per operational runbooks.
