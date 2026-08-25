---
type: 'Phase Index'
title: 'Phase 0 — Foundations'
description: 'User outcome: Judicial-holder reference data flows into CTAM from its upstream sources of truth — the JOH eLinks API (15 jo_ entities, nightly in-process sync, Story 0.3.3) and the MRD weekly Excel…'
resource: 'epics/phase-0/index.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-25'
parent: 'epics/index.md'
phase: 0
phaseName: 'Foundations'
---

# Phase 0 — Foundations

> **Epics renumbered 2026-08-25 (SCP 2026-08-25b)** — a minimal 5-epic swap: JOH domain schema (was 0.9) → **0.1**; JOH eLinks mock API (was 0.7) → **0.2**; JOH reference-data ETL process (was 0.1) → **0.3**; User authenticates (was 0.2) → **0.7**; Reference data read-only API (was 0.3) → **0.9**. Relabeling only — every epic's real technical dependencies are unchanged, just rewired to point at the new ids.

> **Read API split, and a second renumber (SCP 2026-08-25c)** — the reference-data read API is split by upstream source: **JOH data → Epic 0.4** (was 0.9; retitled from "Reference data..." to "JOH data..."); **MRD data → new Epic 0.10** (genuinely new scope — no MRD read endpoint existed before). Placing the JOH-data epic at 0.4 displaced "User populations bootstrapped" to **Epic 0.9** (the vacated slot). Epics 0.0, 0.2, 0.3, 0.5, 0.6, 0.7, 0.8 are untouched by this second change.

> Phase 0 is sequenced **platform-then-integrations-first**: Epic 0.0 platform estate → Epic 0.3 JOH ETL ingestion → Epic 0.7 auth + UI → Epic 0.4 JOH read API → Epic 0.9 bootstrap → Epic 0.5 notification. The shared Azure estate stands up and is independently verified first (Epic 0.0, `ctam-shared-infrastructure`); the ingestion then runs in-process inside `ctam-reference-data` — there is no `ctam-integrations` repo.

> Phase 0 is the platform smoke-test (per PRD Key Characteristic 4). All API-as-Product standards (versioning, OpenAPI, [RFC 9457](https://datatracker.ietf.org/doc/html/rfc9457), `Deprecation`/`Sunset`) are exercised on Authorisation lookups and Reference Data **reads** before any domain service is built.
>
> The Phase 0 areas in [../framework.md](../framework.md) are an **architectural map**. The eleven concrete user-value epics below are the **implementation plan** — each delivers a demoable user outcome and consolidates the supporting technical work as stories within the epic.

## Phase 0 scope model

- **No legacy data migration**[^d3][^d13] — no data migrates from any incumbent (`[ET-INCUMBENT-TBD]`, ListAssist, APEX), ever. Judicial-holder reference data is **ingested from upstream sources of truth**: the JOH eLinks API (nightly in-process sync, the "ETL process" of Epic 0.3) and MRD (weekly Excel via blob drop, Epic 0.8). Historical data stays in each jurisdiction's incumbent system.
- **Platform estate is Epic 0.0 — the first deliverable**: the shared Azure estate (AKS, PostgreSQL, ACR, APIM, App Insights, Key Vault) is provisioned via Terraform in the dedicated `ctam-shared-infrastructure` repo and independently verified layer-by-layer (AR53 revised, HMCTS CNP `{product}-shared-infrastructure` standard).
- **Upstream ingestion is Epic 0.3 (JOH eLinks ETL process, Story 0.3.3) — the first domain deliverable — plus Epic 0.8 (MRD ingestion, Story 0.8.1)**, split out of Epic 0.3 (SCP 2026-08-24b, when it was numbered 0.1) so Phase 0's ETL epic stays focused on JOH data only. `ctam-reference-data` is the first domain service scaffolded and deploys onto the Epic 0.0 estate. In-process — **no `ctam-integrations` repo**.
- **The read API is split by upstream source**: **Epic 0.4** serves JOH data (tier-(a) + tier-(b)); **Epic 0.10** serves MRD data (`mrd_specialisms`) — split 2026-08-25c, mirroring the ingestion-side split.
- **Two user populations**[^d9]: JOH users resolve IdP email → `jo_people` → `personnel_number` → CTAM JOH UUID (`ctam_joh_identities`); HMCTS admin staff resolve via `ctam_auth_staff_identities` → CTAM-assigned UUID. Both share one authorisation model and both key on a CTAM-assigned UUID.
- **Jurisdiction is first-class**[^d8]: authz responses carry roles + jurisdiction + Region/Area scope; reference-data API responses are jurisdiction-filtered; activation flags key on the (jurisdiction, region) tuple (FR57).
- **Admin UI is post-MVP**[^d10]: tier-(b) reference data and user/role/scope maintenance are DBA-via-SQL per runbook.

## Epics

| Epic | Title | Stories | Status |
|---|---|---|---|
| [0.0](epic-0.0-platform-estate-provisioned.md) | Platform estate is provisioned, verifiable, and CNP-compliant | 5 | 🟡 Planned |
| [0.1](epic-0.1-postgres-sql-schema-design.md) | JOH domain schema is designed and implemented in PostgreSQL | 2 | 🟡 Planned |
| [0.2](epic-0.2-joh-elinks-mock-api-stands-in.md) | JOH eLinks mock API stands in for the unconfirmed upstream contract | 3 | 🟡 Planned |
| [0.3](epic-0.3-joh-reference-data-etl-process.md) | JOH reference-data ETL process | 3 | 🟡 Planned |
| [0.4](epic-0.4-joh-data-read-only-api.md) | JOH data is served read-only via a versioned, jurisdiction-filtered API | 2 | 🟡 Planned |
| [0.5](epic-0.5-system-dispatches-emails.md) | Notification service is scaffolded and contractually ready | 2 | 🟡 Planned |
| [0.6](epic-0.6-context-bus-and-shared-baseline.md) | Context bus is published and the shared configuration baseline exists | 2 | 🟢 In progress |
| [0.7](epic-0.7-user-authenticates.md) | User authenticates and lands on a role-scoped Home page | 5 | 🟡 Planned |
| [0.8](epic-0.8-mrd-supplementary-reference-data-ingested.md) | MRD supplementary reference data is ingested | 1 | 🟡 Planned |
| [0.9](epic-0.9-user-populations-bootstrapped.md) | Both user populations are bootstrapped and verifiable against the IdP | 1 | 🟡 Planned |
| [0.10](epic-0.10-mrd-data-read-only-api.md) | MRD data is served read-only via a versioned, jurisdiction-filtered API | 1 | 🟡 Planned |
| **Total** | | **27 stories** | |

## Epic summaries

### Epic 0.0: Platform estate is provisioned, verifiable, and CNP-compliant (5 stories)

**User outcome:** The shared Azure estate — AKS, PostgreSQL Flexible Server, ACR, APIM, Application Insights, Key Vault — is stood up via **Terraform** in its own dedicated repo, **`ctam-shared-infrastructure`** (HMCTS CNP `{product}-shared-infrastructure` standard, AR53 revised), provisioned **layer-by-layer with each layer independently verified at deploy time**, so every Phase 0 service has a tested platform to deploy onto. Precedes every other epic. Stories: 0.0.1 repo + Terraform foundation (state backend, plan/apply CI); 0.0.2 network + AKS (verified via `kubectl get nodes` + hello pod); 0.0.3 PostgreSQL + Key Vault (TLS-only connect, plaintext refused, secret round-trip); 0.0.4 ACR + observability (image pull, test trace lands); 0.0.5 APIM + smoke API (gateway → echo 200 over TLS).

**FRs covered:** none (foundational platform infrastructure). **NFRs:** NFR10, NFR11, NFR16, NFR25–NFR28, NFR31. **ARs:** AR53 (revised), A34, G9.

→ [Full epic with stories](epic-0.0-platform-estate-provisioned.md)

### Epic 0.1: JOH domain schema is designed and implemented in PostgreSQL (2 stories)

**User outcome:** `ctam-joh`'s 5 domain tables — working patterns, per-day pattern breakdown, ticket overlay, location overlay, jurisdictional splits — are designed and implemented via Liquibase, keyed by `joh_id` → `ctam_joh_identities.id`, with tier ownership and a cross-service SELECT grant to `ctam-reference-data`. **Schema only** — the behavioral stories that populate and maintain this schema are future Phase 1 epics. *(Added as Epic 1.1 via SCP 2026-08-24c, moved to Phase 0 as Epic 0.9 via SCP 2026-08-25, renumbered to Epic 0.1 via SCP 2026-08-25b.)*

**FRs covered:** none behaviourally — schema groundwork for FR12, FR15b, FR16, FR17 (Phase 1 FRs).

→ [Full epic with stories](epic-0.1-postgres-sql-schema-design.md)

### Epic 0.2: JOH eLinks mock API stands in for the unconfirmed upstream contract (3 stories)

**User outcome:** `ctam-reference-data`'s nightly eLinks sync (Story 0.3.3) runs end-to-end against a deployed, schema-faithful mock of the JOH eLinks People API v5 (`ctam-jomockapi`, CTAM Pathfinder's 17th repo, non-production-only — same category as `ctam-mock-auth`), so Phase 0 has a demoable ingestion pipeline in dev/staging while the real eLinks contract (gaps.md G8.1) remains unconfirmed. *(New 2026-08-24 as Epic 0.7, SCP 2026-08-24; renumbered to Epic 0.2 via SCP 2026-08-25b.)*

**Runs alongside Epic 0.0** — the number is not the order; see `depends_on` in its frontmatter (`[epic-0.0]` only — it doesn't need the context bus or config baseline).

**FRs covered:** none directly (infrastructure/tooling). **Supports:** FR1, FR6 tier-(a), FR7 tier-(a), NFR24 (exercised end-to-end pre-contract).

→ [Full epic with stories](epic-0.2-joh-elinks-mock-api-stands-in.md)

### Epic 0.3: JOH reference-data ETL process (3 stories)

**User outcome:** The JOH reference-data ETL process — extract nightly from the **JOH eLinks API**, transform into CTAM's tier-(a) schema, load via full-refresh upsert into the 15 `jo_*` entities (Story 0.3.3) — so `jo_people` exists and is current. This is the platform's foundational data layer. `ctam-reference-data` is the first domain service scaffolded (Story 0.3.1) and deploys onto the shared estate provisioned in **Epic 0.0**; tier-(a) tables + write protection are Story 0.3.2. *(Retitled 2026-08-24b — was "Upstream JOH/MRD reference data is ingested"; MRD ingestion split out to Epic 0.8 so this epic is JOH-eLinks-only. Renumbered from Epic 0.1 to Epic 0.3 via SCP 2026-08-25b.)*

**FRs covered:** FR1 (the `jo_people` lookup target), FR6 tier-(a), FR7 tier-(a) grants, FR8 (shared config baseline first lands); NFR24 (JOH eLinks half), FR59 (structured logs first exercised)

→ [Full epic with stories](epic-0.3-joh-reference-data-etl-process.md)

### Epic 0.4: JOH data is served read-only via a versioned, jurisdiction-filtered API (2 stories)

**User outcome:** Tier-(b) CTAM-owned reference data (regions, offices, calendar, operational vocabularies) is created, seeded, and DBA-maintained per runbook[^d10] (Story 0.4.1); **JOH data** — both tiers — is served by the versioned **read-only**, **jurisdiction-filtered** REST API (Story 0.4.2). Sequenced after Epic 0.7 (depends on `JWTFilter` + `authz/check`). *(Retitled from "Reference data..." to "JOH data..." and renumbered from Epic 0.9 to Epic 0.4 via SCP 2026-08-25c, when MRD's read surface split into new Epic 0.10; this placement displaced "User populations bootstrapped" to Epic 0.9.)*

**FRs covered (Phase 0 surface):** FR6 (tier-(b) maintenance + JOH read API over both tiers), FR7, FR58

→ [Full epic with stories](epic-0.4-joh-data-read-only-api.md)

### Epic 0.5: Notification service is scaffolded and contractually ready (2 stories)

**User outcome:** `ctam-notification` is deployed with its API contract published, the `ctam_notification_dispatches` delivery-log table created, SMTP integration configured, and `POST /v1/notifications/send` working. The contract is consumable from Phase 2+ via **user-JWT propagation**. Integration testing in MVP happens via Postman — **no admin UI**.

**FRs covered:** FR9

→ [Full epic with stories](epic-0.5-system-dispatches-emails.md)

### Epic 0.6: Context bus is published and the shared configuration baseline exists (2 stories)

**User outcome:** every service repo can pin one published, versioned copy of the architecture (`arch-vN`, consumed as the `_arch/` submodule), and every service can read cross-service policy values from the shared `ctam_configuration_values` table it does not own. Both exist before the first domain service is scaffolded.

**Runs between 0.0 and 0.3** — the number is not the order; see `depends_on` in its frontmatter. Promoted from the `arch-baseline` dispatch-graph node (SCP 2026-08-19d) so BMad tracks it.

**FRs covered:** FR8

→ [Full epic with stories](epic-0.6-context-bus-and-shared-baseline.md)

### Epic 0.7: User authenticates and lands on a role-scoped Home page (5 stories)

**User outcome:** A user from **either identity population** — JOH (Judge, Tribunal Judge, Tribunal Member) or HMCTS admin staff (RSU, Court user, Tribunal Caseworker, Finance, MI) — signs in via SSO, has their canonical identity resolved (CTAM JOH UUID via the eLinks-synced `jo_people` → `personnel_number` → `ctam_joh_identities`; staff UUID via `ctam_auth_staff_identities`), and lands on a role-scoped Home page. Depends on Epic 0.3 (`jo_people` populated) and consumes the shared estate provisioned in Epic 0.0. *(Renumbered from Epic 0.2 to Epic 0.7 via SCP 2026-08-25b.)*

**FRs covered:** FR1, FR2, FR3, FR55, FR56 (business stack); FR57 (activation surface), FR58 (Authorisation read API)

→ [Full epic with stories](epic-0.7-user-authenticates.md)

### Epic 0.8: MRD supplementary reference data is ingested (1 story)

**User outcome:** Supplementary judicial reference data not present in JOH eLinks (notably JOH Specialisations) is ingested from the MRD team's weekly Excel feed into the `mrd_*` tables (Story 0.8.1), inside the same `ctam-reference-data` repo as Epic 0.3's JOH ETL process, sharing its `ctam_sync_status` run-log and tier-(a) write-protection pattern. *(Split out of the JOH ETL epic — was Story 0.1.4, when that epic was numbered 0.1 — 2026-08-24b, so the ETL epic stays JOH-eLinks-only.)*

**FRs covered:** FR6 tier-(a), FR7 tier-(a) grants; NFR24 (MRD half — the JOH eLinks half is Epic 0.3)

→ [Full epic with stories](epic-0.8-mrd-supplementary-reference-data-ingested.md)

### Epic 0.9: Both user populations are bootstrapped and verifiable against the IdP (1 story)

**User outcome:** Authorisation records for both populations exist (seeded in dev/CI; programme-bootstrapped in production per the runbook) with all-FALSE (jurisdiction, region) activation flags, and a re-runnable **bootstrap-verification job** proves every user maps to an IdP principal — a standing wave-cutover gate artefact (also used at the pre-Phase-9 IdP cutover per G1.3). *(Renumbered from Epic 0.4 to Epic 0.9 via SCP 2026-08-25c — displaced to make room for the JOH data read-only API epic at 0.4.)*

**FRs covered (Phase 0 surface):** FR1 (lookup data), FR4 (MVP data-layer criterion), FR57 (initial flag state)

→ [Full epic with stories](epic-0.9-user-populations-bootstrapped.md)

### Epic 0.10: MRD data is served read-only via a versioned, jurisdiction-filtered API (1 story)

**User outcome:** `mrd_specialisms` (ingested by Epic 0.8) is queryable **read-only** via `ctam-reference-data`'s versioned REST API, jurisdiction-filtered, so Phase 1+ services can read JOH Specialisations without direct SQL access. **New scope, split out of Epic 0.4** (SCP 2026-08-25c) — no MRD read endpoint existed before this epic.

**FRs covered:** FR6 (read surface over `mrd_*`), FR7, FR58

→ [Full epic with stories](epic-0.10-mrd-data-read-only-api.md)

## Phase 0 Epic Stories Summary

| Epic | Stories | FRs covered | Phase 0 demo |
|---|---|---|---|
| 0.0 | 5 stories (0.0.1–0.0.5) | none (platform infra); NFR10, NFR11, NFR16, NFR25–NFR28, NFR31 | Each Terraform layer stands up and is verified as deployed — `kubectl get nodes` Ready across AZs, PostgreSQL TLS-only (plaintext refused), Key Vault secret round-trip, ACR image pull, APIM smoke API → 200 over TLS |
| 0.1 | 2 stories (0.1.1–0.1.2) | none directly; schema groundwork for FR12, FR15b, FR16, FR17 | `ctam-joh` scaffolded; its 5 domain tables exist via Liquibase, keyed to `ctam_joh_identities`, tier-owned + SELECT-granted to `ctam-reference-data` |
| 0.2 | 3 stories (0.2.1–0.2.3) | none directly; supports FR1, FR6 tier (a), FR7 tier (a); NFR24 | `ctam-jomockapi` deployed to dev/staging; Story 0.3.3's sync runs against it end-to-end (`ctam_sync_status` shows a successful run against the mock's `/people`, `/leavers`, `/deleted` feeds) |
| 0.3 | 3 stories (0.3.1–0.3.3) | FR1 (`jo_people` target), FR6 tier (a), FR7 tier (a), FR8, FR59; NFR24 (JOH half) | JOH eLinks ETL process flows data in → `jo_people` current (verified via `ctam_sync_status` + CI WireMock stub, and end-to-end in dev/staging against Epic 0.2's deployed mock) |
| 0.4 | 2 stories (0.4.1–0.4.2) | FR6 (tier b + JOH read API), FR7, FR58 | Jurisdiction-filtered JOH data API serves both tiers read-only |
| 0.5 | 2 stories (0.5.1–0.5.2) | FR9 | `POST /v1/notifications/send` works end-to-end via Postman against Mailpit |
| 0.6 | 2 stories (0.6.1–0.6.2) | FR8; NFR16, NFR40 | A service repo pins `arch-v1.0` and resolves `_arch/`; a service role SELECTs from `ctam_configuration_values` and is refused a write |
| 0.7 | 5 stories (0.7.1–0.7.5) | FR1, FR2, FR3, FR55, FR56, FR57 (activation surface), FR58 | User (either population) signs in via mock-auth → `ctam-authorisation` resolves identity/roles/jurisdiction → role-scoped Home renders |
| 0.8 | 1 story (0.8.1) | FR6 tier (a), FR7 tier (a); NFR24 (MRD half) | MRD weekly Excel workbook ingested into `mrd_*` tables (`ctam_sync_status` source = `mrd-excel`) |
| 0.9 | 1 story (0.9.1) | FR1 (lookup data), FR4 (data layer), FR57 (flag bootstrap) | Seeded users across both populations verified against the IdP; Epic 0.7 sign-in works against them |
| 0.10 | 1 story (0.10.1) | FR6 (MRD read surface), FR7, FR58 | Jurisdiction-filtered `GET /v1/reference-data/specialisms` serves `mrd_specialisms` read-only |
| **Total** | **27 stories** | | The eleven demos chain together for the Phase 0 stakeholder walkthrough — starting with the verified platform estate |

**Cross-cutting NFRs verified across Phase 0 stories:** NFR10 (TLS), NFR11 (data-at-rest), NFR12 (JWT propagation), NFR13 (authz enforcement incl. jurisdiction), NFR14 (no forbidden data), NFR15 (change trails per runbooks + delivery log), NFR16 (Key Vault incl. eLinks credential), NFR17–NFR19 (business UI WCAG — admin UI deferred), NFR20 (HMCTS IdP integration via mock), NFR22 (HMCTS email), NFR24 (JOH eLinks + MRD MVP integrations), NFR25–NFR28 (observability), NFR31 (Azure UK South), NFR39 (API-as-Product), NFR40 (per-service deployable), NFR42 (Postman collections).

## Post-MVP roadmap items

1. **`ctam-admin-ui` repo** — scaffolding + auth wrapper + GOV.UK Design System admin theme[^d10]
2. **Reference Data maintenance module** (tier (b) only) in `ctam-admin-ui`
3. **Users & Roles admin module** in `ctam-admin-ui` — search, edit roles / jurisdiction / Region-Area scope
4. **Reference Data API write endpoints** (tier (b) only) — `POST/PUT/PATCH/DELETE`, admin-gated
5. **`ctam-authorisation` admin write endpoints**
6. **Admin "Send Test Email" UI**
7. **Delivery-log viewer UI**
8. **Activation-flag toggle UI** (per (jurisdiction, region))

Tier-(a) reference data never gets a write surface in any phase (corrections at source per FR6), and there is no migration-reports surface — there is no migration to report on[^d3].

Not post-MVP (lands in a later MVP phase): **OAuth `client_credentials` flow** for batch / scheduled callers — Phase 6 alongside `ctam-payment-batch`. *(The eLinks sync and MRD pick-up need no service identity — they run in-process inside `ctam-reference-data`.)*

## Validation

- Phase 0 awaits validation via the **ET-cohort implementation-readiness assessment**[^d13]. *(The SSCS-cohort assessment becomes a wave-2 gate.)*

[^d3]: Revised D3 (2026-06-10) — no data migration from any legacy system; judicial-holder reference data is ingested from the JOH eLinks API and MRD.
[^d8]: D8 — rollout is jurisdiction-first, then per-region; jurisdiction is a first-class hierarchical attribute.
[^d9]: Restructured D9 (2026-06-10; refined 2026-07-09 per SCP) — two user populations. JOHs resolve IdP email → `jo_people` → `personnel_number` → a **CTAM-assigned JOH UUID** (`ctam_joh_identities`); HMCTS admin staff via a CTAM-internal identity table. Both key on a CTAM-assigned UUID; `personnel_number` is the upstream link only. No legacy user migration.
[^d10]: D10 (2026-05-15) — admin UI is post-MVP; MVP admin operations are DBA-via-SQL per operational runbooks.
[^d11]: D11 (2026-06-10, amended 2026-06-18; **superseded by D13 2026-08-07 for wave ordering**) — SSCS pilot wave: CTAM Pathfinder replaces **ListAssist** (the SSCS judicial-scheduling tool); **GAPS (SSCS case management) is retained, not replaced**. Per D13 the SSCS wave is **wave 2**.

[^d13]: D13 (2026-08-07, supersedes D11) — ET-first pilot: wave 1 = the **Employment Tribunals (ET)** jurisdiction (scheduling incumbent `[ET-INCUMBENT-TBD]` — unidentified, gap G8.4); wave 2 = **SSCS** (replaces **ListAssist**; **GAPS**, SSCS case management, is retained); waves 3+ = Courts jurisdictions per HMCTS judicial region (replacing JI/APEX).
