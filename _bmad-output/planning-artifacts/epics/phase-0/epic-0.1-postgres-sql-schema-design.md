---
type: 'Epic'
description: "User outcome: ctam-joh's own PostgreSQL domain schema - 5 tables (working patterns, ticket/location overlays, jurisdictional splits) - is designed with the same rigor as the JOH eLinks integration schema (explicit design-decisions doc, ER diagram, column-level spec, data-warnings/open-questions doc) and implemented via Liquibase, so later Phase 1 behavioral epics have a schema to build against. Schema only - no business logic."
resource: 'epics/phase-0/epic-0.1-postgres-sql-schema-design.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-25'
parent: 'epics/phase-0/index.md'
epic: 0.1
title: 'JOH domain schema is designed and implemented in PostgreSQL'
storyCount: 4
repo: ctam-joh
depends_on: [epic-0.0, epic-0.3]
---

# Epic 0.1: JOH domain schema is designed and implemented in PostgreSQL

> **Design-rigor note** *(SCP 2026-08-25j)*: this epic's schema-design process — a written design-decisions doc, an ER diagram, an explicit column-level spec, and a companion data-warnings/open-questions doc — follows the documentation pattern set by the JOH eLinks integration schema (Confluence JUDIT space, `3.2.1.1 CTAM JO Schema` and `3.2.1.2 CTAM Schema and Source Mapping`). That pair documents the **tier-(a) `jo_*` schema owned by `ctam-reference-data` / Epic 0.3** — a different table set, in a different repo, from this epic's 5 CTAM-owned tier-(b) overlay tables. No `jo_*` table content is duplicated into this epic; only the documentation *pattern* (design decisions → ER diagram → column spec → data warnings/open questions) is adopted here. Epic 0.3 Story 0.3.2 and `architecture/data-tables.md`'s `jo_*` section still hold table-name-only definitions with no column-level detail — they remain candidates for an equivalent follow-up pass, **tracked but not actioned by this SCP** (see the SCP's Impact Analysis). *(A local distilled copy of the two Confluence pages was archived to `_bmad-output/source-docs/joh-schema-confluence/` by this SCP; relocated out of the repo to a local, non-versioned path on 2026-08-25, SCP 2026-08-25m — the Confluence source itself is unaffected.)*

**User outcome:** `ctam-joh`'s own PostgreSQL domain schema — the 5 CTAM-owned overlay tables (`ctam_working_patterns`, `ctam_working_pattern_days`, `ctam_joh_ticket`, `ctam_joh_location`, `ctam_jurisdictional_splits` — per `architecture/data-tables.md`) — is **designed explicitly** (naming/FK conventions, an ER diagram, a full column-level spec, and documented data warnings/open questions — the same rigor the JOH eLinks schema gives its own tables) and **implemented via Liquibase**, each keyed by `joh_id` → `ctam_joh_identities.id`, so that later Phase 1 epics (working-pattern management, overlay maintenance, jurisdictional-split workflow — FR12, FR15b, FR16, FR17) have both working DDL and a readable design reference to build against. **Schema only** — no business logic, no API, no UI in this epic.

**Hosting:** `ctam-joh` is the **second** domain service scaffolded (after `ctam-reference-data`, Epic 0.3); it deploys onto the shared Azure estate provisioned in **Epic 0.0** and carries only its own per-repo Terraform. This epic does not build `ctam-joh`'s API or any working-pattern/overlay business logic — those are later Phase 1 epics, run via `bmad-create-epics-and-stories` once Phase 1 is fully decomposed.

**Vertical slice:**
- **Second scaffolded backend service: `ctam-joh`** (HMCTS Crime SpringBoot template + `ctam-scaffold.sh` conventions per AR2–AR4, same pattern as Epic 0.3 Story 0.3.1)
- **Consumes the shared Azure estate** provisioned in Epic 0.0
- A written schema design-decisions doc (`architecture/ctam-joh-schema-design.md`) — naming/PK/FK conventions, the jurisdictional-split invariant strategy, the tier-(b)-vocabulary FK verification gate, and the tier-ownership/grant model
- An ER diagram (D2 + ELK, native `sql_table` shapes, the house standard per `CLAUDE.md`) covering all 5 tables
- The 5 domain tables, service-owned Liquibase changelog (AR18–AR20), keyed by `joh_id` → `ctam_joh_identities.id` (Epic 0.3), with a full column-level spec
- A data-warnings / open-questions doc for the schema, mirroring the JOH eLinks schema's own §5–6
- Tier ownership: only the `ctam_joh` DB role holds INSERT/UPDATE on its own tables; SELECT-granted to `ctam_reference_data` for JOH profile-view composition (per `data-tables.md`'s explicit note)

**FRs covered:** none behaviourally — **schema groundwork only** for FR12 (working patterns), FR15b (ticket overlay), FR16 (jurisdictional split), FR17 (location overlay). Full behavioral coverage is later Phase 1 epics.

**Key NFRs first exercised here (for `ctam-joh`):** NFR10 (TLS at APIM), NFR11 (data-at-rest), NFR25–NFR28 (structured logs + observability), NFR31 (Azure UK South), NFR40 (per-service deployable).

**Out of scope (explicitly):** Working-pattern generation / forward-sitting generation (FR13). Ticket/location overlay CRUD business logic. Jurisdictional-split validation workflow. JOH profile *view* composition itself (only the SELECT grant enabling it is this epic's concern). `ctam-joh`'s REST API. `ctam-ui`'s `joh/` module. Column-level documentation of the tier-(a) `jo_*` schema (Epic 0.3's own tables) — flagged as a follow-up in the SCP, not actioned here. All of these are future Phase 1 epics or a separate epic's concern.

---

## Story 0.1.1: Scaffold `ctam-joh` from the HMCTS starter (onto the Epic 0.0 estate)

As a **platform engineer**,
I want to scaffold `ctam-joh` — the second CTAM Pathfinder backend service — from the HMCTS Crime SpringBoot template using `ctam-scaffold.sh`, and deploy it onto the shared Azure estate provisioned in Epic 0.0,
So that **the JOH domain schema (Stories 0.1.2–0.1.4) has a service to live in**, following the same proven scaffold pattern Epic 0.3 established for `ctam-reference-data`.

**Acceptance Criteria:**

**Given** the engineer has performed the GitHub manual-setup checklist (`ctam-architecture/runbooks/github-setup.md`) **before** running the scaffold (repo `ctam-joh` created via the GitHub web UI; branch protection on `main`; no `gh` CLI, per D10),
**When** the engineer runs `ctam-scaffold.sh ctam-joh` from `ctam-architecture/scaffolding/`,
**Then** the script scaffolds a Spring Boot 4.0.x project locally from `https://github.com/hmcts/service-hmcts-crime-springboot-template`, commits, and pushes to the pre-created remote on a feature branch via plain `git`,
**And** Group ID is `uk.gov.hmcts.ctam`, artefact is `ctam-joh`, base package is `uk.gov.hmcts.ctam.joh`, default port is **8083** (per AR3 — distinct from `ctam-reference-data`'s 8082 so the two can run side by side without colliding),
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
**And** its own service-owned Liquibase changelog directory exists but is empty (the 5 domain tables' DDL is created in Story 0.1.3).

**References:** AR2–AR17, AR23–AR32, AR41, AR53 (revised); D10; depends on Epic 0.0 (shared estate + context bus + config baseline, Stories 0.0.6–0.0.7).

**Explicitly NOT in scope:**
- Schema design decisions & conventions — Story 0.1.2
- The 5 domain tables' column-level schema, ER diagram, and tier ownership/grants — Story 0.1.3
- Data-warnings / open-questions companion doc — Story 0.1.4
- Any `ctam-joh` API, business logic, or UI — future Phase 1 epics

---

## Story 0.1.2: Schema design decisions are documented for `ctam-joh`'s domain schema

As a **CTAM Pathfinder platform engineer** (and every future Phase 1 story that builds on this schema),
I want the design decisions behind `ctam-joh`'s 5 domain tables written down explicitly — naming/PK/FK conventions, the cross-row invariant strategy for jurisdictional splits, the tier-(b)-vocabulary FK verification gate, and the tier-ownership/grant model — using the same structured "design decisions" approach the JOH eLinks integration schema uses for its own tables,
So that **Story 0.1.3's DDL is built from an explicit, reviewable design rather than decided ad hoc inside a Liquibase changeset, and Phase 1 engineers inherit the same "why" the JOH eLinks schema gives its own consumers.**

**Acceptance Criteria:**

**Given** the JOH eLinks integration schema's design-decisions pattern (`3.2.1.2 CTAM Schema and Source Mapping` §1 — naming, lifecycle, deprecated-attribute exclusion, sync metadata as a separate side table, FK strategy, special cases, constraints/warnings),
**When** the engineer authors `architecture/ctam-joh-schema-design.md` (a new architecture shard, added to the `NAV` list in `scripts/python/build_html.py` per house convention, and linked from `architecture.md`),
**Then** it documents, for each of the 5 `ctam-joh` tables, the same category of decision the JOH eLinks doc makes for its own tables: naming (`ctam_` prefix rationale, table/column names), PK strategy (`id uuid`, never bigint, never a bare source id — house convention, distinct from the JOH eLinks schema's own integer-PK choice for its upstream tables), FK strategy (`joh_id uuid` → `ctam_joh_identities.id`, never a bare `personnel_number` — per AR22), and the audit-column convention (`created_at`/`updated_at timestamptz NOT NULL`).

**Given** `ctam_jurisdictional_splits`' percentages must total 100% per JOH (FR16) — a **cross-row** invariant a single-row Postgres `CHECK` constraint cannot express,
**When** the engineer designs this table's enforcement,
**Then** the chosen mechanism (a trigger, application-level validation, or an equivalent) is decided and explicitly justified in `ctam-joh-schema-design.md` — not deferred to a Liquibase changeset's inline comments — this AC exists precisely so the choice is made deliberately, not defaulted to "no enforcement."

**Given** any of the 5 tables needs a foreign key into a tier-(b) vocabulary table owned by `ctam-reference-data` (e.g. a working-pattern-type reference into `ctam_working_pattern_types`),
**When** the engineer designs that column,
**Then** the referenced vocabulary table's existence and shape is verified against `data-tables.md` and Epic 0.4's landing status **before** the FK is added, and the verification outcome is recorded in `ctam-joh-schema-design.md` — an unmapped or not-yet-landed vocabulary table raises an architectural PR rather than being assumed (cite-or-ask; mirrors `gaps.md` G8.1's "unmapped upstream structure raises an architectural PR" pattern).

**Given** the tier-ownership model already fixed by `architecture/data-tables.md` (`ctam_joh` DB role owns all 5 tables; `ctam_reference_data` holds `SELECT` for JOH profile-view composition),
**When** `ctam-joh-schema-design.md` is authored,
**Then** it restates this grant model explicitly against the concrete 5-table list — not just "per `data-tables.md`" — so Story 0.1.3's Liquibase grants have a single written source of truth to implement against.

**References:** FR12, FR15b, FR16, FR17; AR18–AR20, AR22; `architecture/data-tables.md` §"JOH service (`ctam-joh`) — 5 tables"; design pattern: `3.2.1.2 CTAM Schema and Source Mapping` §1; depends on Story 0.1.1 (repo exists to hold the doc — no code dependency).

**Explicitly NOT in scope:**
- The actual column-level DDL / Liquibase changeset — Story 0.1.3
- The ER diagram — Story 0.1.3
- Data warnings / open questions — Story 0.1.4

---

## Story 0.1.3: The 5 `ctam-joh` domain tables are designed (ER diagram + column-level spec) and implemented via Liquibase

As a **CTAM Pathfinder platform** (and every future Phase 1 story that builds on this schema),
I want the 5 CTAM-owned `ctam-joh` overlay tables created via Liquibase from a documented ER diagram and a full column-level spec — mirroring the rigor of the JOH eLinks schema's own ER diagrams and per-table column-mapping tables — with tier ownership and cross-service SELECT grants in place,
So that **later Phase 1 epics have both working DDL and a readable per-column reference to build behavior against, and `ctam-reference-data` can compose JOH profile views without a shared code dependency**.

**Acceptance Criteria:**

**Given** the design decisions recorded in Story 0.1.2,
**When** the engineer authors the ER diagram,
**Then** it is written in D2 with the ELK layout engine using native `sql_table` shapes (house standard for new schema diagrams per `CLAUDE.md`), committed as `architecture/diagrams/ctam-joh-schema.d2` and rendered to `architecture/diagrams/ctam-joh-schema.png` via `scripts/render_diagram.sh`,
**And** it shows all 5 tables with their columns and PK/FK markers, the FK edges into `ctam_joh_identities` (drawn as an external reference node, not redefined), and any tier-(b) vocabulary tables verified in Story 0.1.2.

**Given** `ctam-joh` is scaffolded per Story 0.1.1, and `ctam_joh_identities` exists (Epic 0.3, Story 0.3.2),
**When** the engineer adds the Liquibase changeset `db/changelog/001-init-joh-domain-tables.sql` (formatted-SQL, included from `db.changelog-master.yaml`),
**Then** the 5 tables exist per `architecture/data-tables.md`'s "JOH service (`ctam-joh`) — 5 tables" section and Story 0.1.2's design doc:
  - `ctam_working_patterns` — per-JOH working-pattern definition (target sit %, active period; FR12)
  - `ctam_working_pattern_days` — per-day work-type breakdown within a working pattern (FR12)
  - `ctam_joh_ticket` — CTAM-overlay tickets layered on the upstream `jo_tickets` set (FR15 layer (b))
  - `ctam_joh_location` — JOH base-location changes recorded in CTAM, not propagated upstream (FR17)
  - `ctam_jurisdictional_splits` — per-JOH jurisdictional split percentages (FR16)
**And** every table has `id uuid PK`, `joh_id uuid` FK → `ctam_joh_identities.id` (never a bare `personnel_number`), and `created_at`/`updated_at timestamptz NOT NULL`, per house convention,
**And** `ctam_working_pattern_days` FKs to its parent `ctam_working_patterns.id`.

**Given** the cross-row invariant mechanism decided in Story 0.1.2 for `ctam_jurisdictional_splits`,
**When** the changeset is implemented,
**Then** that exact mechanism (trigger, application-level validation, or equivalent) is present and verified by a test — the design decision from Story 0.1.2 is not silently dropped or substituted at implementation time.

**Given** the tables are created,
**When** grants are configured per the model documented in Story 0.1.2,
**Then** the `ctam_joh` DB role owns all 5 tables and holds INSERT/UPDATE on them; **no other role holds INSERT/UPDATE** (mirrors AR49's tier-ownership pattern, now for `ctam-joh`'s own tier rather than tier (a)),
**And** `ctam_reference_data`'s DB role holds `SELECT` on all 5 tables (per `data-tables.md`: "the overlay tables are SELECT-granted to `ctam_reference_data`" for JOH profile-view composition),
**And** the ArchUnit/grants fitness function in CI verifies this write-protection + grant rule.

**Given** the ER diagram and Liquibase changeset are both authored,
**When** the engineer documents the schema,
**Then** a column-level reference exists — either inline in the changeset's header comment block or as a table in `ctam-joh-schema-design.md` — listing, per column: name, type, nullability, PK/FK designation, and description/example, the same five attributes the JOH eLinks schema's own column-mapping tables carry (CTAM column / Type / PK-FK / Source attribute / Description-Notes-example), minus "source attribute" — these are CTAM-native tables with no upstream source to map from.

**References:** FR12, FR15b, FR16, FR17; NFR15; AR18–AR20, AR22; `CLAUDE.md`'s D2+ELK diagram-rendering standard; `architecture/data-tables.md` §"JOH service (`ctam-joh`) — 5 tables"; design pattern: `3.2.1.1 CTAM JO Schema` (ER diagrams), `3.2.1.2 CTAM Schema and Source Mapping` §3 (column mappings); depends on Epic 0.3 Story 0.3.2 (`ctam_joh_identities`) and Story 0.1.2 (design decisions).

**Explicitly NOT in scope:**
- Working-pattern generation / forward-sitting generation (FR13) — future Phase 1 epic
- Ticket/location overlay CRUD, jurisdictional-split validation workflow — future Phase 1 epics
- JOH profile view composition (only the SELECT grant enabling it is here) — future Phase 1 epic
- `ctam-joh`'s REST API — future Phase 1 epic

---

## Story 0.1.4: Data warnings and open design questions are documented for `ctam-joh`'s domain schema

As a **CTAM Pathfinder platform engineer** (and every Phase 1 consumer of this schema),
I want the known behavioural limitations and unresolved design questions about `ctam-joh`'s 5 tables written down in one place — mirroring the JOH eLinks schema's "Data warnings" and "Open questions" sections — so that Phase 1 engineers inherit known gotchas instead of rediscovering them mid-implementation,
So that **the schema's rough edges are visible and tracked before Phase 1 behavioral work starts building on top of them.**

**Acceptance Criteria:**

**Given** the JOH eLinks schema's "Data warnings" pattern (`3.2.1.2 CTAM Schema and Source Mapping` §5: `#` / Warning / Affected fields / CTAM's behaviour),
**When** the engineer adds a "Data warnings" section to `architecture/ctam-joh-schema-design.md`,
**Then** it covers, at minimum:
  - What happens to a `ctam_joh_ticket` / `ctam_joh_location` overlay row when the underlying `jo_people` row is marked `leaver` or `deleted` upstream (soft-delete parity — overlay rows are never hard-deleted, mirroring the JOH eLinks schema's own leaver/deleted soft-delete pattern per `3.2.1.2` §1.2),
  - Whether `ctam_jurisdictional_splits` percentages are re-validated on read or only on write, and what happens to a JOH whose splits were valid at write time but whose upstream appointment set has since changed,
  - Whether `ctam_joh_ticket` / `ctam_joh_location` overlays are ever reconciled or expired against the tier-(a) baseline (`jo_tickets`, `jo_base_locations`), or persist independently once written.

**Given** the JOH eLinks schema's "Open questions" pattern (`3.2.1.2` §6: numbered, dated, Status-tracked Open/Closed, with Comments),
**When** the engineer adds an "Open questions" section to `architecture/ctam-joh-schema-design.md`,
**Then** it captures, at minimum, any of the three data-warning items above that cannot be closed by this story, plus any other question raised while drafting Stories 0.1.2–0.1.3, each with a date-added and a status.

**Given** both sections exist,
**When** the epic is reviewed,
**Then** this epic's own "Out of scope" section and Story 0.1.3's References line both cross-link to `ctam-joh-schema-design.md`'s Data warnings / Open questions sections, so Phase 1 story authors are pointed at them rather than needing to rediscover them.

**References:** FR12, FR15b, FR16, FR17; design pattern: `3.2.1.2 CTAM Schema and Source Mapping` §5–6; depends on Stories 0.1.2 and 0.1.3.

**Explicitly NOT in scope:**
- Resolving the open questions themselves where they require a product decision — those are logged as `gaps.md` entries or routed to a future SCP, not force-closed here.
