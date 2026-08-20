---
type: 'Phase Index'
title: 'Phase 0 — Foundations'
description: 'User outcome: Judicial-holder reference data flows into CTAM from its upstream sources of truth — the JOH eLinks API (15 jo_ entities, nightly in-process sync, Epic 0.7 Story 0.7.1) and the MRD weekly Excel…'
resource: 'epics/phase-0/index.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-06-17'
parent: 'epics/index.md'
phase: 0
phaseName: 'Foundations'
---

# Phase 0 — Foundations

> Phase 0 is sequenced **platform-then-integrations-first**: Epic 0.0 platform estate → Epic 0.1 schema/scaffold → Epics 0.7/0.8 ingestion → Epic 0.2 auth + UI → Epic 0.3 read API → Epic 0.4 bootstrap → Epic 0.5 notification. The shared Azure estate stands up and is independently verified first (Epic 0.0, `ctam-shared-infrastructure`); the ingestion then runs in-process inside `ctam-reference-data` — there is no `ctam-integrations` repo.

> Phase 0 is the platform smoke-test (per PRD Key Characteristic 4). All API-as-Product standards (versioning, OpenAPI, [RFC 9457](https://datatracker.ietf.org/doc/html/rfc9457), `Deprecation`/`Sunset`) are exercised on Authorisation lookups and Reference Data **reads** before any domain service is built.
>
> The Phase 0 areas in [../framework.md](../framework.md) are an **architectural map**. The five concrete user-value epics below are the **implementation plan** — each delivers a demoable user outcome and consolidates the supporting technical work as stories within the epic.

## Phase 0 scope model

- **No legacy data migration**[^d3][^d13] — no data migrates from any incumbent (`[ET-INCUMBENT-TBD]`, ListAssist, APEX), ever. Judicial-holder reference data is **ingested from upstream sources of truth**: the JOH eLinks API (nightly in-process sync) and MRD (weekly Excel via blob drop). Historical data stays in each jurisdiction's incumbent system.
- **Platform estate is Epic 0.0 — the first deliverable**: the shared Azure estate (AKS, PostgreSQL, ACR, APIM, App Insights, Key Vault) is provisioned via Terraform in the dedicated `ctam-shared-infrastructure` repo and independently verified layer-by-layer (AR53 revised, HMCTS CNP `{product}-shared-infrastructure` standard).
- **Upstream schema design is Epic 0.1, ingestion is Epics 0.7/0.8 — the first domain deliverables**: `ctam-reference-data` is the first domain service scaffolded and deploys onto the Epic 0.0 estate; the tier-(a) schema is designed in Epic 0.1, then the eLinks sync (Epic 0.7, Story 0.7.1) and MRD ingestion (Epic 0.8, Story 0.8.1) populate it. In-process — **no `ctam-integrations` repo**.
- **Two user populations**[^d9]: JOH users resolve IdP email → `jo_people` → `personnel_number` → CTAM JOH UUID (`ctam_joh_identities`); HMCTS admin staff resolve via `ctam_auth_staff_identities` → CTAM-assigned UUID. Both share one authorisation model and both key on a CTAM-assigned UUID.
- **Jurisdiction is first-class**[^d8]: authz responses carry roles + jurisdiction + Region/Area scope; reference-data API responses are jurisdiction-filtered; activation flags key on the (jurisdiction, region) tuple (FR57).
- **Admin UI is post-MVP**[^d10]: tier-(b) reference data and user/role/scope maintenance are DBA-via-SQL per runbook.

## Epics

| Epic | Title | Stories | Status |
|---|---|---|---|
| [0.0](epic-0.0-platform-estate-provisioned.md) | Platform estate is provisioned, verifiable, and CNP-compliant | 5 | 🟡 Planned |
| [0.1](epic-0.1-postgres-db-schema-design.md) | Postgres reference-data schema is designed and scaffolded | 2 | 🟡 Planned |
| [0.2](epic-0.2-user-authenticates.md) | User authenticates and lands on a role-scoped Home page | 5 | 🟡 Planned |
| [0.3](epic-0.3-reference-data-read-only-api.md) | Reference data is served read-only via a versioned, jurisdiction-filtered API | 2 | 🟡 Planned |
| [0.4](epic-0.4-user-populations-bootstrapped.md) | Both user populations are bootstrapped and verifiable against the IdP | 1 | 🟡 Planned |
| [0.5](epic-0.5-system-dispatches-emails.md) | Notification service is scaffolded and contractually ready | 2 | 🟡 Planned |
| [0.6](epic-0.6-context-bus-and-shared-baseline.md) | Context bus is published and the shared configuration baseline exists | 2 | 🟢 In progress |
| [0.7](epic-0.7-joh-reference-data-etl-process.md) | JOH reference data flows into CTAM via the nightly eLinks ETL process | 1 | 🟡 Planned |
| [0.8](epic-0.8-mrd-reference-data-etl-process.md) | MRD reference data flows into CTAM via the weekly Excel ETL process | 1 | 🟡 Planned |
| **Total** | | **21 stories** | |

## Epic summaries

### Epic 0.0: Platform estate is provisioned, verifiable, and CNP-compliant (5 stories)

**User outcome:** The shared Azure estate — AKS, PostgreSQL Flexible Server, ACR, APIM, Application Insights, Key Vault — is stood up via **Terraform** in its own dedicated repo, **`ctam-shared-infrastructure`** (HMCTS CNP `{product}-shared-infrastructure` standard, AR53 revised), provisioned **layer-by-layer with each layer independently verified at deploy time**, so every Phase 0 service has a tested platform to deploy onto. Precedes Epic 0.1. Stories: 0.0.1 repo + Terraform foundation (state backend, plan/apply CI); 0.0.2 network + AKS (verified via `kubectl get nodes` + hello pod); 0.0.3 PostgreSQL + Key Vault (TLS-only connect, plaintext refused, secret round-trip); 0.0.4 ACR + observability (image pull, test trace lands); 0.0.5 APIM + smoke API (gateway → echo 200 over TLS).

**FRs covered:** none (foundational platform infrastructure). **NFRs:** NFR10, NFR11, NFR16, NFR25–NFR28, NFR31. **ARs:** AR53 (revised), A34, G9.

→ [Full epic with stories](epic-0.0-platform-estate-provisioned.md)

### Epic 0.1: Postgres reference-data schema is designed and scaffolded (2 stories)

**User outcome:** `ctam-reference-data` is the first domain service scaffolded (Story 0.1.1) and deploys onto the shared estate provisioned in **Epic 0.0**; the tier-(a) upstream-sourced Postgres schema — 15 `jo_*` tables + `ctam_sync_status` — is designed with enforced single-writer ownership (Story 0.1.2). This is the platform's foundational data layer; the JOH eLinks (**Epic 0.7**) and MRD (**Epic 0.8**) ETL processes populate it once it exists.

**FRs covered:** FR6 tier-(a), FR7 tier-(a) grants, FR8 (shared config baseline first lands); FR59 (structured logs first exercised)

→ [Full epic with stories](epic-0.1-postgres-db-schema-design.md)

### Epic 0.2: User authenticates and lands on a role-scoped Home page (5 stories)

**User outcome:** A user from **either identity population** — JOH (Judge, Tribunal Judge, Tribunal Member) or HMCTS admin staff (RSU, Court user, Tribunal Caseworker, Finance, MI) — signs in via SSO, has their canonical identity resolved (CTAM JOH UUID via the eLinks-synced `jo_people` → `personnel_number` → `ctam_joh_identities`; staff UUID via `ctam_auth_staff_identities`), and lands on a role-scoped Home page. Depends on Epic 0.1 (`jo_people` populated) and consumes the shared estate provisioned in Epic 0.0.

**FRs covered:** FR1, FR2, FR3, FR55, FR56 (business stack); FR57 (activation surface), FR58 (Authorisation read API)

→ [Full epic with stories](epic-0.2-user-authenticates.md)

### Epic 0.3: Reference data is served read-only via a versioned, jurisdiction-filtered API (2 stories)

**User outcome:** Tier-(b) CTAM-owned reference data (regions, offices, calendar, operational vocabularies) is created, seeded, and DBA-maintained per runbook[^d10] (Story 0.3.1); all reference data — both tiers — is served by the versioned **read-only**, **jurisdiction-filtered** REST API (Story 0.3.2). Sequenced after Epic 0.2 (depends on `JWTFilter` + `authz/check`).

**FRs covered (Phase 0 surface):** FR6 (tier-(b) maintenance + read API over both tiers), FR7, FR58

→ [Full epic with stories](epic-0.3-reference-data-read-only-api.md)

### Epic 0.4: Both user populations are bootstrapped and verifiable against the IdP (1 story)

**User outcome:** Authorisation records for both populations exist (seeded in dev/CI; programme-bootstrapped in production per the runbook) with all-FALSE (jurisdiction, region) activation flags, and a re-runnable **bootstrap-verification job** proves every user maps to an IdP principal — a standing wave-cutover gate artefact (also used at the pre-Phase-9 IdP cutover per G1.3).

**FRs covered (Phase 0 surface):** FR1 (lookup data), FR4 (MVP data-layer criterion), FR57 (initial flag state)

→ [Full epic with stories](epic-0.4-user-populations-bootstrapped.md)

### Epic 0.5: Notification service is scaffolded and contractually ready (2 stories)

**User outcome:** `ctam-notification` is deployed with its API contract published, the `ctam_notification_dispatches` delivery-log table created, SMTP integration configured, and `POST /v1/notifications/send` working. The contract is consumable from Phase 2+ via **user-JWT propagation**. Integration testing in MVP happens via Postman — **no admin UI**.

**FRs covered:** FR9

→ [Full epic with stories](epic-0.5-system-dispatches-emails.md)

### Epic 0.6: Context bus is published and the shared configuration baseline exists (2 stories)

**User outcome:** every service repo can pin one published, versioned copy of the architecture (`arch-vN`, consumed as the `_arch/` submodule), and every service can read cross-service policy values from the shared `ctam_configuration_values` table it does not own. Both exist before the first domain service is scaffolded.

**Runs between 0.0 and 0.1** — the number is not the order; see `depends_on` in its frontmatter. Promoted from the `arch-baseline` dispatch-graph node (SCP 2026-08-19d) so BMad tracks it.

**FRs covered:** FR8

→ [Full epic with stories](epic-0.6-context-bus-and-shared-baseline.md)

### Epic 0.7: JOH reference data flows into CTAM via the nightly eLinks ETL process (1 story)

**User outcome:** An in-process nightly `@Scheduled` sync (Story 0.7.1) pulls the **JOH eLinks API** (15 `jo_*` entities) and full-refresh-upserts them into the tier-(a) schema designed in **Epic 0.1**, so `jo_people` exists and is current — the precondition for JOH sign-in (Epic 0.2). Split out of the former Epic 0.1 (was Story 0.1.3) 2026-08-20.

**FRs covered:** FR1 (the `jo_people` lookup target), FR6 tier-(a), FR7; NFR24

→ [Full epic with stories](epic-0.7-joh-reference-data-etl-process.md)

### Epic 0.8: MRD reference data flows into CTAM via the weekly Excel ETL process (1 story)

**User outcome:** A weekly Azure Blob drop + scheduled pick-up (Story 0.8.1) ingests the MRD team's Excel workbook into its own small `mrd_*` schema, making supplementary judicial reference data (notably JOH Specialisations) available without waiting for MRD's public APIs. Split out of the former Epic 0.1 (was Story 0.1.4) 2026-08-20.

**FRs covered:** FR6 tier-(a), FR7; NFR24

→ [Full epic with stories](epic-0.8-mrd-reference-data-etl-process.md)

## Phase 0 Epic Stories Summary

| Epic | Stories | FRs covered | Phase 0 demo |
|---|---|---|---|
| 0.0 | 5 stories (0.0.1–0.0.5) | none (platform infra); NFR10, NFR11, NFR16, NFR25–NFR28, NFR31 | Each Terraform layer stands up and is verified as deployed — `kubectl get nodes` Ready across AZs, PostgreSQL TLS-only (plaintext refused), Key Vault secret round-trip, ACR image pull, APIM smoke API → 200 over TLS |
| 0.1 | 2 stories (0.1.1–0.1.2) | FR6 tier (a), FR7 tier (a), FR8, FR59 | `ctam-reference-data` scaffolded onto the Epic 0.0 estate; tier-(a) `jo_*` schema + `ctam_sync_status` exist with write protection (verified via ArchUnit grants fitness function) |
| 0.7 | 1 story (0.7.1) | FR1 (`jo_people` target), FR6 tier (a), FR7; NFR24 | JOH reference data flows in nightly from eLinks → `jo_people` current (verified via `ctam_sync_status` + CI WireMock stub) |
| 0.8 | 1 story (0.8.1) | FR6 tier (a), FR7; NFR24 | MRD weekly Excel workbook flows in via blob drop → `mrd_*` current (verified via `ctam_sync_status`) |
| 0.2 | 5 stories (0.2.1–0.2.5) | FR1, FR2, FR3, FR55, FR56, FR57 (activation surface), FR58 | User (either population) signs in via mock-auth → `ctam-authorisation` resolves identity/roles/jurisdiction → role-scoped Home renders |
| 0.3 | 2 stories (0.3.1–0.3.2) | FR6 (tier b + read API), FR7, FR58 | Jurisdiction-filtered Reference Data API serves both tiers read-only |
| 0.4 | 1 story (0.4.1) | FR1 (lookup data), FR4 (data layer), FR57 (flag bootstrap) | Seeded users across both populations verified against the IdP; Epic 0.2 sign-in works against them |
| 0.6 | 2 stories (0.6.1–0.6.2) | FR8; NFR16, NFR40 | A service repo pins `arch-v1.0` and resolves `_arch/`; a service role SELECTs from `ctam_configuration_values` and is refused a write |
| 0.5 | 2 stories (0.5.1–0.5.2) | FR9 | `POST /v1/notifications/send` works end-to-end via Postman against Mailpit |
| **Total** | **16 stories** | | The eight demos chain together for the Phase 0 stakeholder walkthrough — starting with the verified platform estate (Epic 0.0's 5 stories are the platform smoke-test that precedes this table, not counted here) |

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
