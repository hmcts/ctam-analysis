---
type: 'Epic'
description: 'User outcome: CTAM Pathfinder''s two user populations — JOH users (resolved via jo_people → personnel_number → CTAM JOH UUID in ctam_joh_identities) and HMCTS admin staff (resolved via ctam_auth_staff_identities → CTAM-assigned UUID) — have…'
resource: 'epics/phase-0/epic-0.7-user-populations-bootstrapped.html'
tags: [ctam-pathfinder, epics, phase-0, employment-tribunals]
timestamp: '2026-06-17'
parent: 'epics/phase-0/index.md'
epic: 0.7
title: 'Both user populations are bootstrapped and verifiable against the IdP'
storyCount: 1
---

# Epic 0.7: Both user populations are bootstrapped and verifiable against the IdP

**User outcome:** CTAM Pathfinder's two user populations[^d9] — **JOH users** (resolved via `jo_people` → `personnel_number` → CTAM JOH UUID in `ctam_joh_identities`) and **HMCTS admin staff** (resolved via `ctam_auth_staff_identities` → CTAM-assigned UUID) — have authorisation records (roles, jurisdiction, Region/Area scope, all-FALSE activation flags) in place: seeded by scripts in dev/CI, bootstrapped by programme-management mechanisms in production (outside the PRD's scope), and **verifiable** by a bootstrap-verification job that confirms every user maps to a real IdP principal before any wave cutover. Epic 0.4's sign-in works against this data.

**No legacy user migration of any kind**[^d3]: no APEX user dump, no IdP reconciliation ETL, no unmatched-record CSV workflow — none of these exist or will exist. **No admin UI in MVP**[^d10] — operational user/role/scope maintenance happens via direct SQL by DBAs; an admin UI surface is on the post-MVP roadmap.

**Cross-repo shape — read this before implementing.** The scripts and the verification job live in **`ctam-architecture`**, but they **write into tables owned by two other services**: `ctam_auth_*` (owned by `ctam-authorisation`) and the `jo_*` fixtures (owned by `ctam-reference-data`). That is deliberate — bootstrap is a programme operation, not a service feature, and neither service exposes a write API for it (admin writes are post-MVP[^d10]). It has two consequences this epic must honour: the scripts run under the **documented bootstrap role from Epic 0.B, Story 0.B.1** (not as a service role, not as a shared admin account), and they **must not** create or alter any table — every table already exists from its owning service's Liquibase changelog. Ownership of the schema stays with the owning service; only the data load is here.

**Vertical slice:**
- Dev/CI seed scripts (one-off, per AR52) populating **both populations**: `jo_*` fixtures (where no live eLinks connection exists), `ctam_auth_staff_identities` rows, `ctam_auth_users` (with `principal_kind` + jurisdiction), `ctam_auth_user_roles`, `ctam_auth_user_region_scopes`, `ctam_auth_user_activation_flags` (all FALSE, keyed by (jurisdiction, region) per FR57) — mirroring `ctam-mock-auth`'s test-user roster (AR35)
- **Bootstrap-verification job**: confirms every `ctam_auth_users` row (both populations) resolves to an IdP principal — by email against the IdP directory (mock in Phase 0–8; real HMCTS IdP at the pre-Phase-9 cutover per G1.3) — and produces a verification report; failures block the wave gate
- **Production bootstrap runbook** at `ctam-architecture/runbooks/identity-bootstrap.md`: documents what programme management must supply (the staff identity list, role/jurisdiction/scope assignments), the SQL load pattern, the verification-job invocation, and the FR4 maintenance pattern (DBA-via-SQL[^d10])

**FRs covered (Phase 0 surface):**
- **FR1** — the data both identity-lookup paths resolve against
- **FR4** — MVP data-layer success criterion ("an authorised DBA can update role / jurisdiction / scope per the operational runbook")
- **FR57** — initial all-FALSE flag state at bootstrap; cutover flips per (jurisdiction, region) in Phase 9+

**FRs deferred to post-MVP:**
- **FR4 admin UI surface** (`ctam-admin-ui` Users & Roles module — D10)

**Out of scope for Phase 0:**
- The production bootstrap mechanism itself (programme-management / operational, outside the PRD's scope[^d9] — CTAM provides the runbook and the verification job, not the source data)
- `ctam-authorisation` admin write endpoints, admin UI modules, activation toggle UI (post-MVP[^d10])
- *(There is no APEX Users/Roles ETL, IdP-reconciliation matching, or unmatched-record decisions CSV — revised D3 / restructured D9.)*

---

## Story 0.7.1: Identity seed scripts (both populations), bootstrap-verification job, and the production bootstrap runbook

As an **identity / HMCTS IT lead** (and the engineers who need working sign-in in every environment),
I want dev/CI seed scripts covering both identity populations, a re-runnable bootstrap-verification job proving every user maps to an IdP principal, and a production bootstrap runbook,
So that **Epic 0.4's two-population sign-in works end-to-end in every environment, and no wave cutover can proceed with unverifiable users** (restructured D9, AR52, G1.3).

**Acceptance Criteria:**

**Given** the engineer creates the dev/CI seed scripts (one-off scripts per AR52; not a runtime API, not Liquibase changesets),
**And** the scripts run under the documented **bootstrap DB role** from Epic 0.B, Story 0.B.1 — with INSERT on the tables it seeds and **no DDL privilege**, so a seed script cannot alter another service's schema,
**And** the identities they seed match the **shared identity set published by `ctam-joh-mock`** (Epic 0M.1, Story 0M.1.2) and therefore the `ctam-mock-auth` roster (Story 0.4.2) — one reference set across all four consumers, not three that need reconciling,
**When** the scripts run against a fresh dev/CI database,
**Then** they populate: representative `jo_*` fixtures (incl. `jo_people` rows whose emails match `ctam-mock-auth`'s JOH test users, with stable personnel numbers, a minted `ctam_joh_identities` UUID per JOH fixture, and `jo_jurisdictions` covering Tribunals/ET + Tribunals/SSCS + Courts examples) where no live eLinks connection exists,
**And** `ctam_auth_staff_identities` rows (CTAM-assigned UUIDs) whose emails match the mock-auth admin-staff test users (same shared identity set),
**And** `ctam_auth_users` rows for both populations with `principal_kind`, the link to `ctam_joh_identities.id` (JOH) or `ctam_auth_staff_identities.id` (staff), and a jurisdiction (FK → `jo_jurisdictions`),
**And** role assignments (`ctam_auth_user_roles`) and Region/Area scopes (`ctam_auth_user_region_scopes`) covering every documented role across both populations,
**And** `ctam_auth_user_activation_flags` rows keyed by (jurisdiction, region), **all FALSE** except designated test users flagged TRUE so the Epic 0.4 demo can show both the activated and non-activated paths (FR57),
**And** the scripts are idempotent (safe re-run on an already-seeded database).

**Given** the bootstrap-verification job is implemented (a re-runnable script/k8s Job owned by `ctam-architecture`),
**When** it runs against an environment,
**Then** for every `ctam_auth_users` row it verifies the principal resolves at the configured IdP — by email against the IdP directory (`ctam-mock-auth` roster in Phase 0–8; real HMCTS IdP principal export/query at the pre-Phase-9 cutover per gaps.md G1.3),
**And** it verifies referential integrity per population: every JOH `ctam_auth_users` row links to an existing `ctam_joh_identities` row whose `personnel_number` maps to an active `jo_people` row; every staff row links to an existing `ctam_auth_staff_identities` UUID,
**And** it produces a verification report (total users per population, verified count, failures with per-row reason),
**And** a non-empty failure list exits non-zero — wiring the job into the wave-cutover gate (the Phase 9+ rollout runbook and the pre-Phase-9 cutover checklist both require a clean run; per architecture *Wave rollout flow* gate 3),
**And** the job never modifies data — it is verification-only.

**Given** the production bootstrap runbook is written at `ctam-architecture/runbooks/identity-bootstrap.md`,
**When** programme management prepares a wave's users,
**Then** the runbook documents: the inputs programme management must supply (staff identity list with emails; role / jurisdiction / Region-Area assignments for both populations — JOH person data itself arrives via the eLinks sync, not via bootstrap),
**And** the SQL load pattern per table (DBA-operated,[^d10]), including the all-FALSE initial activation state (FR57),
**And** the verification-job invocation and the rule that a clean verification run is a precondition for the wave gate,
**And** the FR4 maintenance pattern: how a DBA updates a user's role / jurisdiction / scope per request, with the change-trail convention,
**And** the runbook states explicitly what is out of scope: no legacy-system user import exists or will exist[^d3]; the bootstrap data source is programme-management-owned.

**Given** the seeds have run in dev,
**When** the Epic 0.4 Playwright suite executes,
**Then** the JOH test user signs in and resolves to a CTAM JOH UUID, the admin-staff test user signs in and resolves to a staff UUID (Story 0.4.5),
**And** the bootstrap-verification job passes cleanly against the seeded environment in CI.

**References:** FR1, FR4 (MVP data-layer criterion), FR57 (initial flag state); NFR13, NFR15 (change trail per runbook), NFR16; AR18–AR20, AR34, AR35, AR52; restructured D9; gaps.md G1.3.

**Explicitly NOT in scope (deferred post-MVP or external):**
- Admin API / admin UI for user, role, jurisdiction, scope, or activation management[^d10]
- The production bootstrap mechanism's data sourcing (programme-management-owned, outside the PRD)
- *(No APEX user ETL, IdP-reconciliation matching, or unmatched-decisions CSV workflow exists — revised D3)*

[^d3]: Revised D3 (2026-06-10) — no data migration from any legacy system; judicial-holder reference data is ingested from the JOH eLinks API and MRD.
[^d9]: Restructured D9 (2026-06-10; refined 2026-07-09 per SCP) — two user populations. JOHs resolve IdP email → `jo_people` → `personnel_number` → a **CTAM-assigned JOH UUID** (`ctam_joh_identities`); HMCTS admin staff via a CTAM-internal identity table. Both key on a CTAM-assigned UUID; `personnel_number` is the upstream link only. No legacy user migration.
[^d10]: D10 (2026-05-15) — admin UI is post-MVP; MVP admin operations are DBA-via-SQL per operational runbooks.
