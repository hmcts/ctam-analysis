---
type: 'Epic'
description: 'User outcome: The shared relational schema design for every Phase 0 table — tier-(a) upstream (jo_*, mrd_*), tier-(b) CTAM-owned, and each service domain table — is authored, reviewed, and published as the canonical reference…'
resource: 'epics/phase-0/epic-0.1-postgres-schema-design.html'
tags: [ctam-pathfinder, epics, phase-0, data]
timestamp: '2026-08-15'
parent: 'epics/phase-0/index.md'
epic: 0.1
title: 'Shared PostgreSQL schema design is established and CI-enforced'
storyCount: 2
---

# Epic 0.1: Shared PostgreSQL schema design is established and CI-enforced

**User outcome:** The shared relational schema design for every Phase 0 table — tier-(a) upstream-sourced (`jo_*`, `mrd_*`), tier-(b) CTAM-owned, and each service's own domain tables — is authored, reviewed, and published as the canonical reference (`architecture/data-tables.md`), together with a machine-checked convention fitness function (naming, PK/FK/timestamp, tier-prefix rules) that every subsequent service's Liquibase changelog must pass in CI. So that every Phase 0 service creates tables against one agreed, enforced shape from the start, rather than drifting per-service and being reconciled later.

**Hosting — two repos.** This is a design-and-tooling epic, not a service. **Story 0.1.1** lands in this control-plane repo (`ctam-analysis`: `architecture/data-tables.md`, already the canonical source per `CLAUDE.md`) and is published to the bus. **Story 0.1.2** lands in **`ctam-architecture`**, where the ruleset lives; **`ctam-scaffold.sh` (Epic 0.A, Story 0.A.2) wires it into every repo it creates**, so no per-service adoption story is needed and a repo scaffolded in Phase 3 picks up the same gate as `ctam-reference-data`. No new deployable, no new repo.

**Why this precedes ingestion:** Story 0.2.2 (JOH tier-(a) tables) and Story 0.3.1 (MRD tables) are the first Liquibase changesets written against this schema; Epic 0.4 (auth's `ctam_auth_*` tables) and Epic 0.5 (tier-(b) tables) follow. Making the design and its enforcement explicit and reviewed *before* any of those changesets are written means every table lands right the first time, rather than each service inventing its own PK/FK/naming pattern and drifting from `architecture/conventions.md`.

**Vertical slice:**
- Finalize and publish the canonical relational schema design in `architecture/data-tables.md`: every table's owning service, tier (a/b), PK/FK shape, and the naming/typing conventions already set out in `architecture/conventions.md` (Data & persistence)
- A schema-convention fitness function — a SQLFluff ruleset plus a naming/shape linter — packaged for every service repo's CI pipeline to run against its own Liquibase changelogs
- No new Azure resource, no new repo, no new service — this epic is documentation + shared tooling only, consumed by every table-creating story that follows

**FRs covered:** none — this is foundational data-design infrastructure with no functional-requirement surface of its own. It is the enablement layer for FR6/FR7 (tier ownership + grants) across every Phase 0 epic that creates tables.

**Key NFRs first exercised here:** none newly introduced; this epic operationalises the schema conventions already implied by `architecture/conventions.md` (Data & persistence) ahead of any table's creation.

**Architecture requirements:** `architecture/conventions.md` (Data & persistence — PK `id uuid`, FK `{entity_singular}_id`, `created_at`/`updated_at timestamptz NOT NULL`, tier-prefix rules); `architecture/data-tables.md` (the per-table ownership inventory this epic finalises and enforces).

**Out of scope (explicitly):** provisioning the PostgreSQL Flexible Server itself (Epic 0.0, Story 0.0.3 — this epic designs the schema that server will hold, not the server). Creating any actual table (Epic 0.2 Story 0.2.2 for `jo_*`, Epic 0.3 Story 0.3.1 for `mrd_*`, Epic 0.4 for `ctam_auth_*`, Epic 0.5 Story 0.5.1 for tier-(b)). The `ctam_configuration_values` shared infrastructure table baseline **and the per-service DB roles** — both `ctam-architecture`-owned and delivered in **[Epic 0.B](epic-0.B-shared-db-baseline-and-service-roles.md), Story 0.B.1**, which precedes this epic (they were previously the undecomposed `arch-baseline` dispatch node). A separate, narrower concern to this epic's general-purpose conventions.

---

## Story 0.1.1: Finalize and publish the canonical relational schema design

As the **CTAM Pathfinder platform** (and every service that will create a table),
I want the full relational schema design — every table's owning service, tier (a/b), PK/FK shape, and naming/typing conventions — finalized, reviewed, and published in `architecture/data-tables.md`,
So that **every subsequent Liquibase changeset is written against one agreed, reviewed design rather than being improvised per-service**.

**Acceptance Criteria:**

**Given** `architecture/conventions.md` already states the naming/typing rules (PK `id uuid` never bigint; FK `{entity_singular}_id`; `created_at`/`updated_at timestamptz NOT NULL` on every table; tier-prefix ownership `ctam_`/`jo_`/`mrd_`/`mock_`) and `architecture/data-tables.md` already inventories the 55-table shared schema,
**When** the schema design is reviewed and signed off ahead of Epic 0.2,
**Then** `architecture/data-tables.md` carries, for every table: owning service, tier (a/b), PK, every FK with its target table, and any unique/index constraint called out in the epics that create it,
**And** every table name and column name in the inventory conforms to the naming/typing rules in `architecture/conventions.md` — any exception is called out explicitly with its rationale, not silently inconsistent,
**And** the tier-(a) write-protection rule (only the owning service's DB role holds INSERT/UPDATE; every other role at most SELECT) is stated once, referenced by every table row rather than repeated per-table,
**And** the design is reviewed against every FR/NFR that names a specific table or column (e.g. FR47 no bank details, FR54 no case-level data) to confirm no table violates a forbidden-data rule.

**Given** the schema design is published,
**When** a new table is proposed by any later epic (e.g. Epic 0.4's `ctam_auth_*`, Epic 0.5's tier-(b) tables),
**Then** the epic's story references this design rather than redefining conventions inline — a new table is an addition to `architecture/data-tables.md`, not a fresh set of naming decisions.

**References:** `architecture/conventions.md` (Data & persistence); `architecture/data-tables.md`.

**Explicitly NOT in scope:**
- The CI-enforced linter that checks changesets against this design — Story 0.1.2
- Writing any actual Liquibase changeset — Epic 0.2 onward

---

## Story 0.1.2: Build the schema-convention CI fitness function

As the **CTAM Pathfinder platform** (and every service's CI pipeline),
I want a schema-convention fitness function — a SQLFluff ruleset plus a naming/shape linter — that runs against any service's Liquibase changelog,
So that **a changeset violating the agreed schema design (Story 0.1.1) fails CI before merge, rather than drifting into the shared database undetected**.

**Acceptance Criteria:**

**Given** the schema design published in Story 0.1.1,
**When** the fitness function is built and packaged in **`ctam-architecture`** (alongside the ArchUnit and Spectral rulesets the scaffold pulls in — Epic 0.A, Story 0.A.2),
**Then** it checks, for every table in a service's Liquibase changelog: a `uuid` primary key named `id` (never `bigint`/`serial`), FK columns named `{entity_singular}_id`, `created_at`/`updated_at timestamptz NOT NULL` present, and the table name prefixed per its tier/ownership (`ctam_` CTAM-owned, `jo_`/`mrd_` upstream tier-(a) — writable only by `ctam-reference-data`'s changelog, `mock_` dev-only),
**And** a changeset violating any rule fails the check with a specific, actionable message (which rule, which table/column) — not a generic lint failure,
**And** the SQLFluff configuration is the same one referenced in `project-context.md`'s CI-gates list, not a second, divergent linter.

**Given** the fitness function exists,
**When** it is wired into a service's CI pipeline (starting with `ctam-reference-data`, Epic 0.2 Story 0.2.1's scaffold),
**Then** the check runs on every PR touching `db/changelog/`, alongside the existing Spotless/Checkstyle/ArchUnit gates,
**And** the scaffold conventions (`ctam-scaffold.sh`) reference where the ruleset lives so every later service repo picks it up the same way, without re-deriving it.

**References:** `architecture/conventions.md`; `project-context.md` (CI gates); depends on Story 0.1.1 (the design it enforces).

**Explicitly NOT in scope:**
- The schema design itself — Story 0.1.1
- Enforcing runtime data-quality rules (that's the ingestion cleansing stage, Epic 0.2 Story 0.2.3 / Epic 0.3 Story 0.3.1) — this fitness function checks schema *shape*, not the data flowing through it
