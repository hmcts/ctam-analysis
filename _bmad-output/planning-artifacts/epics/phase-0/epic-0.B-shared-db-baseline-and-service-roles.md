---
type: 'Epic'
description: 'User outcome: the shared ctam_configuration_values baseline table exists and every per-service PostgreSQL role exists with the documented grants convention — so the first table-creating story can grant to roles that are actually there…'
resource: 'epics/phase-0/epic-0.B-shared-db-baseline-and-service-roles.html'
tags: [ctam-pathfinder, epics, phase-0, data, platform]
timestamp: '2026-08-18'
parent: 'epics/phase-0/index.md'
epic: 0.B
title: 'Shared database baseline and per-service DB roles are established'
storyCount: 1
---

# Epic 0.B: Shared database baseline and per-service DB roles are established

**User outcome:** The shared **`ctam_configuration_values`** infrastructure table exists on the Epic 0.0 PostgreSQL server, managed by `ctam-architecture`'s Liquibase baseline changelog (FR8); **every per-service PostgreSQL role exists** — `ctam_reference_data`, `ctam_authorisation`, `ctam_notification`, `ctam_mock_auth`, plus the forward-declared roles for Phases 1–8 — each `SELECT`-granted on the baseline table; and the **grants convention** (who may grant what, in whose changelog) is written down. So that **the first table-creating story can grant privileges to roles that actually exist**, and the DB-level write boundaries the architecture depends on are real from the first `liquibase update` rather than retrofitted.

**Hosting:** `ctam-architecture` — the baseline changelog and the role-provisioning changeset are bus-owned, not service-owned (per FR8, AR19, `architecture/data-tables.md` → *Shared infrastructure*). No deployable workload; this epic owns exactly one shared table.

**Why this is its own epic:** the work is `ctam-architecture`-owned like [Epic 0.A](epic-0.A-architecture-context-bus-and-scaffolding.md), but it **cannot run until Epic 0.0 Story 0.0.3 has provisioned the PostgreSQL server**, whereas Epic 0.A must precede Epic 0.0 Story 0.0.1. Splitting them keeps the dispatch graph acyclic: **0.A → 0.0 → 0.B → 0.1 → …**

**Why it is not simply part of Epic 0.0:** Story 0.0.3 provisions the *server*; this epic establishes the *shared schema baseline and access model* on it. Story 0.0.3 excludes both explicitly, and `ctam-shared-infrastructure` is Terraform-only — it holds no Liquibase changelog and owns no table.

**The gap this closes.** Story 0.2.2 asserts *"the `ctam_reference_data` DB role owns the tables"*, *"SELECT grants exist for `ctam_authorisation`"* and *"placeholder roles for future services"*; Story 0.5.1 asserts *"SELECT grants exist for every current and placeholder service DB role"*; Stories 0.2.1, 0.4.1 and 0.8.1 each assert their service's role *"has SELECT on `ctam_configuration_values`"*. Nothing created those roles. `architecture.md` says grants live in the table-owning service's Liquibase changelog and are worth *"~10 minutes/role on Day 1"* — but never says **whose** Day 1. This epic is that Day 1.

**Vertical slice:**
- `ctam-architecture`'s **Liquibase baseline changelog** creating `ctam_configuration_values` (FR8, AR19) on the Epic 0.0 server, conforming to the schema design published in **Epic 0.1** where the two overlap — note the deliberate ordering: the baseline lands **before** Epic 0.1 in the graph, so this epic's own table is reviewed against `architecture/conventions.md` directly and re-checked by Story 0.1.2's fitness function once that exists
- **Per-service PostgreSQL role provisioning** for all 15 role names in the programme (11 services + `ctam_mock_auth` + the two mocks that need no role, documented as such), each with the documented baseline grants
- The **grants convention** documented in `ctam-architecture/runbooks/` and enforced by the fitness function: a grant lives in the **table-owning** service's changelog; tier-(a) `jo_*`/`mrd_*` tables are INSERT/UPDATE-able by `ctam_reference_data` only (AR49); every other role gets at most SELECT

**FRs covered:** **FR8** (shared cross-service configuration values — the table, its Liquibase management, and the SELECT grant to every service role). Enablement for FR6/FR7 tier ownership across every table-creating epic.

**Key NFRs first exercised here:** NFR11 (the first data at rest on the shared server), NFR15 (change trail — every role and grant change arrives as a reviewed Liquibase changeset, never ad-hoc SQL).

**Architecture requirements:** AR18 (single shared schema, per-service roles with explicit grants), AR19 (`ctam-architecture` owns the baseline changelog), AR22 (SELECT on `ctam_configuration_values` for every service role), AR49 (tier-(a) write protection); `architecture/data-tables.md` → *Shared infrastructure*; gaps.md **G6.4** (grant-maintenance model).

**Out of scope (explicitly):** provisioning the PostgreSQL server (Epic 0.0, Story 0.0.3). The canonical schema design and its CI fitness function (**Epic 0.1**). Creating any **service-owned** table — each service's own changelog creates its own tables (0.2.2 `jo_*`, 0.3.1 `mrd_*`, 0.4.3 `ctam_auth_*`, 0.5.1 tier-(b), 0.8.1 `ctam_notification_dispatches`). Seeding identity or reference data (Stories 0.5.1, 0.7.1). Any admin API or UI over configuration values (there is none, in any phase — updates are Liquibase-or-admin-SQL per FR8).

---

## Story 0.B.1: Shared `ctam_configuration_values` baseline, per-service DB roles, and the grants convention

As **every CTAM Pathfinder service** (and the DBAs who operate the shared database),
I want the shared configuration table created by `ctam-architecture`'s Liquibase baseline, every per-service DB role provisioned with its baseline grants, and the grants convention documented,
So that **the first service to create a table can grant to roles that exist**, cross-service reads work from Day 1, and the DB enforces the write boundaries the architecture relies on (FR8, AR18, AR22, AR49).

**Acceptance Criteria:**

**Given** the shared PostgreSQL Flexible Server is provisioned and TLS-verified per **Epic 0.0, Story 0.0.3**,
**And** `ctam-architecture` is published as the context bus per **Epic 0.A, Story 0.A.1**,
**When** the engineer adds the baseline Liquibase changelog to `ctam-architecture`,
**Then** the shared **`ctam_configuration_values`** table exists with the schema in `architecture/data-tables.md` → *Shared infrastructure* (per FR8, AR19),
**And** it conforms to the naming/typing rules in `architecture/conventions.md` — `id uuid` PK, `created_at`/`updated_at timestamptz NOT NULL`, `ctam_` prefix — reviewed directly here because this table lands **before** Epic 0.1's fitness function exists,
**And** the changelog is applied by a documented, repeatable mechanism (a pipeline job or k8s Job in `ctam-architecture`), **not** by hand from an engineer's laptop,
**And** writes to the table are **Liquibase-or-admin-SQL only** — there is no configuration API and no service holds INSERT/UPDATE (per FR8).

**Given** every service in the programme needs its own DB role (AR18, AR22),
**When** the engineer adds the role-provisioning changeset,
**Then** roles exist for the **four Phase 0 / Phase 0-Mock services that hold data or need a connection** — `ctam_reference_data`, `ctam_authorisation`, `ctam_notification`, `ctam_mock_auth` — and the remaining service roles are **forward-declared** so later grants resolve: `ctam_joh`, `ctam_absence`, `ctam_vacancy`, `ctam_booking`, `ctam_sitting`, `ctam_payment`, `ctam_payment_batch`, `ctam_itinerary`, `ctam_mi_feed`,
**And** `ctam-joh-mock` and `ctam-mrd-mock` are documented as holding **no role and no table** (they own nothing in the shared schema — AR55, AR56),
**And** every role is granted `SELECT` on `ctam_configuration_values` (per AR22) — satisfying the corresponding ACs in Stories 0.2.1, 0.4.1 and 0.8.1,
**And** no role is granted anything beyond that here — table-level grants arrive with the tables, in the owning service's changelog,
**And** role credentials are stored in **Azure Key Vault** (never in a repo, never in a Helm values file — NFR16), and the Key Vault path convention each service's `values-{env}.yaml` reads is documented.

**Given** cross-service grants must stay reviewable as the estate grows (gaps.md **G6.4**),
**When** the engineer documents the grants convention in `ctam-architecture/runbooks/`,
**Then** it states the ownership rule — **whoever writes the Liquibase changelog owns the table, and grants on that table live in that changelog** — with the worked example from `architecture.md` (`GRANT SELECT ON ctam_vacancies TO ctam_booking;` plus the column-scoped UPDATE),
**And** it states the **tier-(a) rule** verbatim: only `ctam_reference_data` holds INSERT/UPDATE on `jo_*`/`mrd_*`; every other role gets at most SELECT (AR49, FR6),
**And** it states the **Day-1 posture**: grants start broad and tighten as access patterns become visible (per `architecture.md` → *Data Architecture*), with the tightening recorded as changesets rather than a rewrite,
**And** the PR checklist item ("grants checklist") is added to the scaffold's `PULL_REQUEST_TEMPLATE.md` (Story 0.A.2) so every table-touching PR surfaces its grant changes.

**Given** the baseline and roles are in place,
**When** the first service connects (`ctam-reference-data`, Story 0.2.1),
**Then** it authenticates with **its own role** — not a shared admin account — over TLS to the Epic 0.0 server,
**And** `SELECT` on `ctam_configuration_values` succeeds,
**And** an attempted write to `ctam_configuration_values` is **refused by the database**,
**And** the same check is repeatable for `ctam_authorisation` (Story 0.4.1) and `ctam_notification` (Story 0.8.1) without new grant work.

**References:** **FR8**; NFR11, NFR15, NFR16; AR18, AR19, AR22, AR49; `architecture/data-tables.md` → *Shared infrastructure*; `architecture/conventions.md` (Data & persistence); gaps.md **G6.4**; **depends on Epic 0.0** (Story 0.0.3 — the server) and **Epic 0.A** (Story 0.A.1 — the repo).

**Explicitly NOT in scope:**
- Any service-owned table or its grants — the owning service's own story (0.2.2, 0.3.1, 0.4.3, 0.5.1, 0.8.1)
- The canonical schema design and the CI fitness function — Epic 0.1
- Seed data of any kind — Stories 0.5.1 (tier b) and 0.7.1 (identity)
