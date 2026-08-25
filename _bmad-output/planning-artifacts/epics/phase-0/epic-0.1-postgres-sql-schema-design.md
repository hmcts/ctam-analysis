---
type: 'Epic'
description: "User outcome: ctam-joh's own PostgreSQL domain schema - 5 tables (working patterns, ticket/location overlays, jurisdictional splits) - is designed and implemented via Liquibase, so later Phase 1 behavioral epics have a schema to build against. Schema only - no business logic."
resource: 'epics/phase-0/epic-0.1-postgres-sql-schema-design.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-25'
parent: 'epics/phase-0/index.md'
epic: 0.1
title: 'JOH domain schema is designed and implemented in PostgreSQL'
storyCount: 2
repo: ctam-joh
depends_on: [epic-0.0, epic-0.3]
---

# Epic 0.1: JOH domain schema is designed and implemented in PostgreSQL

**User outcome:** `ctam-joh`'s own PostgreSQL domain schema — the 5 CTAM-owned overlay tables (`ctam_working_patterns`, `ctam_working_pattern_days`, `ctam_joh_ticket`, `ctam_joh_location`, `ctam_jurisdictional_splits` — per `architecture/data-tables.md`) — is designed and implemented via Liquibase, each keyed by `joh_id` → `ctam_joh_identities.id`, so that later Phase 1 epics (working-pattern management, overlay maintenance, jurisdictional-split workflow — FR12, FR15b, FR16, FR17) have a schema to build against. **Schema only** — no business logic, no API, no UI in this epic.

**Hosting:** `ctam-joh` is the **second** domain service scaffolded (after `ctam-reference-data`, Epic 0.3); it deploys onto the shared Azure estate provisioned in **Epic 0.0** and carries only its own per-repo Terraform. This epic does not build `ctam-joh`'s API or any working-pattern/overlay business logic — those are later Phase 1 epics, run via `bmad-create-epics-and-stories` once Phase 1 is fully decomposed.

**Vertical slice:**
- **Second scaffolded backend service: `ctam-joh`** (HMCTS Crime SpringBoot template + `ctam-scaffold.sh` conventions per AR2–AR4, same pattern as Epic 0.3 Story 0.3.1)
- **Consumes the shared Azure estate** provisioned in Epic 0.0
- The 5 domain tables, service-owned Liquibase changelog (AR18–AR20), keyed by `joh_id` → `ctam_joh_identities.id` (Epic 0.3)
- Tier ownership: only the `ctam_joh` DB role holds INSERT/UPDATE on its own tables; SELECT-granted to `ctam_reference_data` for JOH profile-view composition (per `data-tables.md`'s explicit note)

**FRs covered:** none behaviourally — **schema groundwork only** for FR12 (working patterns), FR15b (ticket overlay), FR16 (jurisdictional split), FR17 (location overlay). Full behavioral coverage is later Phase 1 epics.

**Key NFRs first exercised here (for `ctam-joh`):** NFR10 (TLS at APIM), NFR11 (data-at-rest), NFR25–NFR28 (structured logs + observability), NFR31 (Azure UK South), NFR40 (per-service deployable).

**Out of scope (explicitly):** Working-pattern generation / forward-sitting generation (FR13). Ticket/location overlay CRUD business logic. Jurisdictional-split validation workflow. JOH profile *view* composition itself (only the SELECT grant enabling it is this epic's concern). `ctam-joh`'s REST API. `ctam-ui`'s `joh/` module. All of these are future Phase 1 epics.

---

## Story 0.1.1: Scaffold `ctam-joh` from the HMCTS starter (onto the Epic 0.0 estate)

As a **platform engineer**,
I want to scaffold `ctam-joh` — the second CTAM Pathfinder backend service — from the HMCTS Crime SpringBoot template using `ctam-scaffold.sh`, and deploy it onto the shared Azure estate provisioned in Epic 0.0,
So that **the JOH domain schema (Story 0.1.2) has a service to live in**, following the same proven scaffold pattern Epic 0.3 established for `ctam-reference-data`.

**Acceptance Criteria:**

**Given** the engineer has performed the GitHub manual-setup checklist (`ctam-architecture/runbooks/github-setup.md`) **before** running the scaffold (repo `ctam-joh` created via the GitHub web UI; branch protection on `main`; no `gh` CLI, per D10),
**When** the engineer runs `ctam-scaffold.sh ctam-joh` from `ctam-architecture/scaffolding/`,
**Then** the script scaffolds a Spring Boot 4.0.x project locally from `https://github.com/hmcts/service-hmcts-crime-springboot-template`, commits, and pushes to the pre-created remote on a feature branch via plain `git`,
**And** Group ID is `uk.gov.hmcts.ctam`, artefact is `ctam-joh`, base package is `uk.gov.hmcts.ctam.joh`, default port is 8082 (per AR3),
**And** the same baseline dependency set as every other CTAM service is configured (Liquibase, Testcontainers PostgreSQL, MapStruct, OWASP encoder, docker-compose plugin, OpenAPI tooling, Helm chart, Key Vault, JaCoCo, CycloneDX SBOM — per AR5–AR17),
**And** a `terraform/` directory exists holding only `ctam-joh`'s own resources (Key Vault namespace) — the shared estate lives in `ctam-shared-infrastructure` (per AR53 revised),
**And** GitHub Actions workflows, `CODEOWNERS`, `PULL_REQUEST_TEMPLATE.md`, and a Postman collection skeleton exist (per AR28, AR29, AR41).

**Given** the shared Azure estate provisioned and independently verified in Epic 0.0,
**When** `ctam-joh`'s Helm chart is deployed to the dev AKS cluster,
**Then** the service reaches the shared cluster, database, registry, gateway, and observability estate (this story **consumes** the estate; it does not provision it),
**And** `GET /actuator/health` returns `200 OK`, liveness/readiness probes pass, and structured JSON logs with `correlationId` appear (per NFR25, NFR28, AR30, AR32).

**Given** the `ctam-architecture` Liquibase baseline and shared `ctam_configuration_values` table already exist (Epic 0.0, Stories 0.0.6–0.0.7),
**When** `ctam-joh` is scaffolded,
**Then** its DB role has `SELECT` on `ctam_configuration_values`,
**And** its own service-owned Liquibase changelog directory exists but is empty (the 5 domain tables are created in Story 0.1.2).

**References:** AR2–AR17, AR23–AR32, AR41, AR53 (revised); D10; depends on Epic 0.0 (shared estate + context bus + config baseline, Stories 0.0.6–0.0.7).

**Explicitly NOT in scope:**
- The 5 domain tables and tier ownership/grants — Story 0.1.2
- Any `ctam-joh` API, business logic, or UI — future Phase 1 epics

---

## Story 0.1.2: The 5 `ctam-joh` domain tables are designed and implemented

As a **CTAM Pathfinder platform** (and every future Phase 1 story that builds on this schema),
I want the 5 CTAM-owned `ctam-joh` overlay tables created via Liquibase, keyed by `joh_id` → `ctam_joh_identities.id`, with tier ownership and cross-service SELECT grants in place,
So that **later Phase 1 epics (working-pattern management, overlay maintenance, jurisdictional-split workflow) have a correctly-owned schema to build behavior against, and `ctam-reference-data` can compose JOH profile views without a shared code dependency**.

**Acceptance Criteria:**

**Given** `ctam-joh` is scaffolded per Story 0.1.1, and `ctam_joh_identities` exists (Epic 0.3, Story 0.3.2),
**When** the engineer adds the Liquibase changeset `db/changelog/001-init-joh-domain-tables.sql` (formatted-SQL, included from `db.changelog-master.yaml`),
**Then** the 5 tables exist per `architecture/data-tables.md`'s "JOH service (`ctam-joh`) — 5 tables" section:
  - `ctam_working_patterns` — per-JOH working-pattern definition (target sit %, active period; FR12)
  - `ctam_working_pattern_days` — per-day work-type breakdown within a working pattern (FR12)
  - `ctam_joh_ticket` — CTAM-overlay tickets layered on the upstream `jo_tickets` set (FR15 layer (b))
  - `ctam_joh_location` — JOH base-location changes recorded in CTAM, not propagated upstream (FR17)
  - `ctam_jurisdictional_splits` — per-JOH jurisdictional split percentages (FR16)
**And** every table has `id uuid PK`, `joh_id uuid` FK → `ctam_joh_identities.id` (never a bare `personnel_number`), and `created_at`/`updated_at timestamptz NOT NULL`, per house convention,
**And** `ctam_working_pattern_days` FKs to its parent `ctam_working_patterns.id`.

**Given** any of the 5 tables needs a foreign key into a tier-(b) vocabulary table owned by `ctam-reference-data` (e.g. a working-pattern-type reference into `ctam_working_pattern_types`),
**When** the engineer designs that column,
**Then** the referenced vocabulary table's existence and shape is verified against `data-tables.md` and Epic 0.4's landing status **before** the FK is added — an unmapped or not-yet-landed vocabulary table raises an architectural PR rather than being assumed (cite-or-ask; mirrors gaps.md G8.1's "unmapped upstream structure raises an architectural PR" pattern).

**Given** `ctam_jurisdictional_splits`' percentages must total 100% per JOH (FR16) — a **cross-row** invariant a single-row Postgres `CHECK` constraint cannot express,
**When** the engineer designs this table's enforcement,
**Then** the chosen mechanism (a trigger, application-level validation, or an equivalent) is explicit and justified in the migration's accompanying notes — this AC exists precisely so the choice is made deliberately, not defaulted to "no enforcement."

**Given** the tables are created,
**When** grants are configured,
**Then** the `ctam_joh` DB role owns all 5 tables and holds INSERT/UPDATE on them; **no other role holds INSERT/UPDATE** (mirrors AR49's tier-ownership pattern, now for `ctam-joh`'s own tier rather than tier (a)),
**And** `ctam_reference_data`'s DB role holds `SELECT` on all 5 tables (per `data-tables.md`: "the overlay tables are SELECT-granted to `ctam_reference_data`" for JOH profile-view composition),
**And** the ArchUnit/grants fitness function in CI verifies this write-protection + grant rule.

**References:** FR12, FR15b, FR16, FR17 (schema groundwork only — no behavior); NFR15; AR18–AR20, AR22; `architecture/data-tables.md` §"JOH service (`ctam-joh`) — 5 tables"; depends on Epic 0.3 Story 0.3.2 (`ctam_joh_identities`).

**Explicitly NOT in scope:**
- Working-pattern generation / forward-sitting generation (FR13) — future Phase 1 epic
- Ticket/location overlay CRUD, jurisdictional-split validation workflow — future Phase 1 epics
- JOH profile view composition (only the SELECT grant enabling it is here) — future Phase 1 epic
- `ctam-joh`'s REST API — future Phase 1 epic
