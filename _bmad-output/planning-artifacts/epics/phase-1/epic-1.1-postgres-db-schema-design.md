---
type: 'Epic'
description: 'User outcome: ctam-reference-data is scaffolded as the first CTAM Pathfinder domain service, and the tier-(a) upstream JOH/MRD Postgres schema (15 jo_* tables + ctam_sync_status) is designed with enforced single-writer ownership — ready for the JOH eLinks (Epic 1.2) and MRD (Epic 1.3) ETL processes to populate it.'
resource: 'epics/phase-1/epic-1.1-postgres-db-schema-design.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-06-17'
parent: 'epics/phase-1/index.md'
epic: 1.1
title: 'Postgres reference-data schema is designed and scaffolded'
storyCount: 2
repo: ctam-reference-data
depends_on: [epic-1.0, epic-1.9]            # needs the estate + the shared config baseline (was arch-baseline)
---

# Epic 1.1: Postgres reference-data schema is designed and scaffolded

> **Split 2026-08-20 (SCP 2026-08-20b):** this epic was narrowed from "Upstream JOH/MRD reference data is ingested" (4 stories) to just the scaffold + schema-design stories. The two ETL stories that used to live here (the JOH eLinks nightly sync and the MRD weekly ingestion) are now their own epics — **[Epic 1.2](epic-1.2-joh-reference-data-etl-process.md)** and **[Epic 1.3](epic-1.3-mrd-reference-data-etl-process.md)** — each depending on this epic. Story numbers 0.1.1 and 0.1.2 are unchanged. Renamed `ctam-postgres-db-schema-design` → **`postgres-db-schema-design`** shortly after the split.

**User outcome:** `ctam-reference-data` is scaffolded as the **first** CTAM Pathfinder domain service, and the tier-(a) upstream-sourced Postgres schema — 15 `jo_*` tables plus `ctam_sync_status` (the CTAM-internal ingestion run log) — is designed with enforced single-writer ownership, so that the JOH eLinks (Epic 1.2) and MRD (Epic 1.3) ETL processes have a schema to populate. This is the platform's foundational data layer: every downstream consumer of JOH identity and reference data depends on this schema existing correctly before any data can flow into it.

**Hosting:** the schema and its future ingestion both live in-process inside `ctam-reference-data` — no separate `ctam-integrations` repo. `ctam-reference-data` is the first **domain** service scaffolded; it deploys onto the shared Azure estate provisioned in **Epic 1.0** (`ctam-shared-infrastructure`) and carries only its **own** per-repo Terraform (Key Vault namespace; MRD storage — Epic 1.3, Story 1.3.1).

**Vertical slice:**
- **GitHub manual-setup runbook** at `ctam-architecture/runbooks/github-setup.md` (the `gh` CLI is **not** available — all GitHub admin operations are manual via the web UI; `ctam-scaffold.sh` handles only local scaffolding + `git push` to a pre-created remote)
- **First scaffolded backend service: `ctam-reference-data`** (HMCTS Crime SpringBoot template + `ctam-scaffold.sh` conventions per AR2–AR4)
- **Consumes the shared Azure estate** (AKS, shared global PostgreSQL Flexible Server + per-service DB roles, ACR, APIM, App Insights, Key Vault) **provisioned in Epic 1.0** per AR53 (revised — dedicated `ctam-shared-infrastructure`)
- Shared `ctam_configuration_values` Liquibase baseline changelog established by `ctam-architecture` ahead of `ctam-reference-data` (FR8); SELECT-granted to every service role
- Tier-(a) upstream-sourced tables: 15 `jo_*` + `ctam_sync_status` (CTAM-internal ingestion run log), service-owned Liquibase changelogs (AR18–AR20), tier-(a) write-protection (only `ctam_reference_data` holds INSERT/UPDATE — AR49, FR6)

**FRs covered:** FR6 tier-(a) (the schema + write-protection rule), FR7 tier-(a) grants, FR8 (shared `ctam_configuration_values` baseline first lands here), FR59 (structured logging first exercised at scaffold).

**Key NFRs first exercised here:** NFR10 (TLS at APIM), NFR11 (data-at-rest), NFR15 (change trails), NFR16 (Key Vault), NFR25–NFR28 (structured logs + Application Insights ingestion + liveness/readiness probes), NFR31 (Azure UK South data residency), NFR40 (per-service deployable on Kubernetes), NFR42 (Postman collections).

**Out of scope (explicitly):** The JOH eLinks nightly sync (**Epic 1.2**) and MRD weekly ingestion (**Epic 1.3**) — this epic creates the schema and write-protection only; population of the tables happens downstream. The read-only Reference Data API + jurisdiction filtering (Epic 1.5, Story 1.5.2 — downstream of auth). Tier-(b) CTAM-owned reference tables (Epic 1.5, Story 1.5.1). All authentication / authorisation / UI (Epic 1.4). Hand-editing of tier-(a) data in CTAM (never, in any phase — corrections at source per FR6).

---

## Story 1.1.1: Scaffold `ctam-reference-data` from the HMCTS starter (onto the Epic 1.0 estate)

As a **platform engineer**,
I want to scaffold the **first** CTAM Pathfinder backend service — `ctam-reference-data` — from the HMCTS Crime SpringBoot template using `ctam-scaffold.sh`, and to deploy it onto the shared Azure estate provisioned in Epic 1.0,
So that **subsequent services follow a consistent, version-pinned, supply-chain-secured baseline**, and the team can demonstrate the deployment pipeline end-to-end against the already-verified platform estate before any domain logic is written.

**Acceptance Criteria:**

**Given** the engineer has performed the GitHub manual-setup checklist (`ctam-architecture/runbooks/github-setup.md`) **before** running the scaffold:
  - Created an empty private GitHub repo `ctam-reference-data` under the HMCTS org **via the GitHub web UI**
  - Enabled branch protection on `main` via Settings → Branches (require PR review, require status checks, require linear history)
  - Note: the `gh` CLI is **NOT** available in the engineering environment — all GitHub admin config (repo creation, branch protection, team access) happens manually via the web UI per the runbook,
**And** the engineer has a clean local development environment with Java 25, Gradle Wrapper, and Docker,
**When** the engineer runs `ctam-scaffold.sh ctam-reference-data` from `ctam-architecture/scaffolding/`,
**Then** the script scaffolds a Spring Boot 4.0.x project **locally** from `https://github.com/hmcts/service-hmcts-crime-springboot-template`, then commits and pushes to the pre-created remote on a feature branch via plain `git` (no `gh` CLI invocation),
**And** the project contents include a Spring Boot 4.0.x scaffold from `https://github.com/hmcts/service-hmcts-crime-springboot-template`,
**And** Gradle build uses Groovy DSL with Spring Boot Gradle plugin 4.1.0 and `io.spring.dependency-management:1.1.7` (per AR5),
**And** Group ID is `uk.gov.hmcts.ctam`, artefact is `ctam-reference-data`, base package is `uk.gov.hmcts.ctam.referencedata`, default port is 8082 (per AR3),
**And** initial commit message is exactly *"Scaffold CTAM Pathfinder reference-data from HMCTS starter"* (per AR4),
**And** Lombok 1.18.46 + MapStruct 1.6.3 are configured (per AR6),
**And** JJWT 0.13.0 + OWASP Encoder 1.4.0 are on the classpath (per AR7),
**And** springdoc-openapi is configured for OpenAPI 3.x generation (per AR8),
**And** JaCoCo, CycloneDX SBOM, gradle-git-properties, gradle-versions, and gradle-docker-compose plugins are configured (per AR9–AR13),
**And** Spring Boot Test with JUnit 5 (`junit-bom:6.0.3`), Testcontainers PostgreSQL 1.21.4, Spring Boot Testcontainers 4.1.0, and spring-boot-starter-webmvc-test are configured (per AR14–AR15),
**And** Spectral, ArchUnit, Spotless, and Checkstyle are configured (per AR17),
**And** a Helm chart skeleton exists at `charts/ctam-reference-data/` with `values-dev.yaml`, `values-staging.yaml`, `values-production.yaml` overlays (per AR24),
**And** a `terraform/` directory exists with per-environment stacks (`dev` / `staging` / `production`) holding **only this service's own resources** (Key Vault namespace; the MRD storage added in Epic 1.3, Story 1.3.1) — the shared estate lives in `ctam-shared-infrastructure` (Epic 1.0), per AR53 (revised),
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

**Given** the shared Azure estate has been provisioned and independently verified in **Epic 1.0** (`ctam-shared-infrastructure`) — AKS, PostgreSQL Flexible Server, ACR, APIM + base policies, Application Insights / Log Analytics, Key Vault — all in UK South with the documented SKUs (per A34, gaps.md G9),
**When** `ctam-reference-data`'s Helm chart is deployed to the dev AKS cluster,
**Then** the service reaches the shared cluster, database, registry, gateway, and observability estate provisioned in Epic 1.0 (this story **consumes** the estate; it does not provision it — AR53 revised),
**And** the deployment fails fast with a clear diagnostic if any Epic 1.0 estate dependency is absent (making the Epic 1.0 → 0.1 sequencing explicit).

**Given** the `ctam-architecture` Liquibase baseline changelog runs **before** `ctam-reference-data` (it owns the shared infrastructure table),
**When** the baseline is applied to the dev PostgreSQL instance,
**Then** the shared `ctam_configuration_values` infrastructure table exists (per FR8, AR19),
**And** `ctam-reference-data`'s DB role has `SELECT` on `ctam_configuration_values` (per AR22),
**And** `ctam-reference-data`'s own service-owned Liquibase changelog directory (`src/main/resources/db/changelog/`, master `db.changelog-master.yaml`) exists but is empty (tier-(a) tables created in Story 1.1.2).

**Given** the shared APIM gateway (provisioned + TLS-verified in Epic 1.0, Story 1.0.5),
**When** `ctam-reference-data` registers its API through APIM and an HTTP request reaches the gateway,
**Then** the service's API is reachable over TLS (the gateway TLS floor itself is verified in Epic 1.0 per NFR10),
**And** HTTP-only requests are rejected with a redirect to HTTPS.

**Given** the shared PostgreSQL Flexible Server (provisioned + encryption/TLS-verified in Epic 1.0, Story 1.0.3),
**When** the Helm chart's `values-dev.yaml` is applied,
**Then** the database connection string references the shared Epic 1.0 PostgreSQL instance (storage-encrypted at rest per NFR11; TLS-only per NFR10 — both verified in Epic 1.0),
**And** `ctam-reference-data` connects successfully using its own DB role.

**Given** the shared Application Insights workspace (provisioned in Epic 1.0, Story 1.0.4, with the agreed retention policy),
**When** the deployed service emits telemetry,
**Then** `ctam-reference-data`'s structured logs and traces land in the shared workspace (retention is owned by Epic 1.0 per NFR26).

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

**References:** FR8, FR58, FR59; NFR10, NFR11, NFR15, NFR16, NFR25–NFR28, NFR31, NFR40, NFR42; AR2–AR17, AR23–AR32, AR41, AR53 (revised — estate provisioned in Epic 1.0); **D10** (`gh` CLI not available — manual GitHub web-UI setup per `ctam-architecture/runbooks/github-setup.md`); **depends on Epic 1.0** (shared estate).

> **Scaffolding note:** the HMCTS Crime SpringBoot template base is minimal; `ctam-scaffold.sh` assembles the remaining dependencies (Liquibase, Testcontainers, MapStruct, OWASP encoder, docker-compose plugin, OpenAPI tooling, Helm, Key Vault, the CI quality gates) from `hmcts/service-hmcts-springboot-demo` + CTAM conventions — inventory in `architecture/starter-template.md` §B (G1.4).

**Explicitly NOT in scope:**
- Tier-(a) `jo_*` tables and `ctam_sync_status` — Story 1.1.2
- The eLinks sync — Epic 1.2
- The MRD ingestion mechanism (and the `mrd_*` schema, owned by that epic) — Epic 1.3
- Tier-(b) CTAM-owned tables + the read-only API — Epic 1.5

---

## Story 1.1.2: Tier-(a) upstream `jo_*` tables, `ctam_sync_status`, and tier-(a) write protection

As a **CTAM Pathfinder platform** (and every downstream consumer of JOH identity and reference data),
I want the 15 `jo_*` upstream-sourced tables and the `ctam_sync_status` run-log created with service-owned Liquibase changelogs and enforced single-writer ownership,
So that **`jo_people` and the rest of the tier-(a) surface exist with the correct schema and write protection before the eLinks sync populates them** (FR6 tier (a), AR49).

**Acceptance Criteria:**

**Given** `ctam-reference-data` is scaffolded per Story 1.1.1,
**When** the engineer adds the Liquibase changeset `db/changelog/001-init-tier-a-upstream-tables.sql` (formatted-SQL, included from `db.changelog-master.yaml`),
**Then** the 15 `jo_*` tables exist with schemas per `architecture/data-tables.md` (`jo_people`, `jo_appointments`, `jo_judiciary_role_assignments`, `jo_authorisations_with_dates`, `jo_appointment_titles`, `jo_base_locations`, `jo_contract_types`, `jo_genders`, `jo_judiciary_roles`, `jo_jurisdictions`, `jo_locations`, `jo_location_types`, `jo_tickets`, `jo_ticket_categories`, `jo_ticket_category_types`),
**And** `ctam_sync_status` exists (CTAM-internal ingestion run log),
**And** `jo_people.personnel_number` is the upstream natural key, to which CTAM binds a stable `ctam_joh_identities.id` (UUID) — the CTAM-assigned canonical JOH identifier referenced by every downstream domain table (per AR22); `personnel_number` is the upstream link only,
**And** `jo_jurisdictions` preserves the upstream parent-child hierarchy shape (or establishes it on ingest)[^d8],
**And** the `ctam_reference_data` DB role owns the tables; **no other role holds INSERT/UPDATE on any `jo_*` table** (tier-(a) write protection per AR49, FR6),
**And** SELECT grants exist for `ctam_authorisation` (identity lookup, Epic 1.4) and placeholder roles for future services,
**And** the ArchUnit/grants fitness function in CI verifies the tier-(a) write-protection rule.

**References:** FR6 tier (a), FR7 (writes follow the tier); NFR15; AR18–AR20, AR22, AR49; D3 (revised), D8, D9 (restructured).

**Explicitly NOT in scope:**
- The eLinks sync that populates these tables — Epic 1.2, Story 1.2.1
- The `mrd_*` tables and their ingestion — Epic 1.3, Story 1.3.1
- Tier-(b) CTAM-owned tables (regions, offices, vocabularies) — Epic 1.5, Story 1.5.1
- The read-only REST API — Epic 1.5, Story 1.5.2

[^d3]: Revised D3 (2026-06-10) — no data migration from any legacy system; judicial-holder reference data is ingested from the JOH eLinks API and MRD.
[^d8]: D8 — rollout is jurisdiction-first, then per-region; jurisdiction is a first-class hierarchical attribute.
[^d9]: Restructured D9 (2026-06-10; refined 2026-07-09 per SCP) — two user populations. JOHs resolve IdP email → `jo_people` → `personnel_number` → a **CTAM-assigned JOH UUID** (`ctam_joh_identities`); HMCTS admin staff via a CTAM-internal identity table. Both key on a CTAM-assigned UUID; `personnel_number` is the upstream link only. No legacy user migration.
[^d10]: D10 (2026-05-15) — admin UI is post-MVP; MVP admin operations are DBA-via-SQL per operational runbooks.
