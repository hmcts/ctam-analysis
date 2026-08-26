---
type: 'Phase Index'
title: 'Phase 0 — Foundations'
description: 'User outcome: Judicial-holder reference data flows into CTAM from its upstream source of truth — the JOH eLinks API (15 jo_ entities, nightly in-process sync, Story 0.3.3). Phase 0 narrowed to epics 0.0-0.4 (SCP 2026-08-25d): auth, notification, MRD, and bootstrap removed for now.'
resource: 'epics/phase-0/index.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-25'
parent: 'epics/index.md'
phase: 0
phaseName: 'Foundations'
---

# Phase 0 — Foundations

> **Scope reduction 2026-08-25 (SCP 2026-08-25d)** — Phase 0 is narrowed to **epics 0.0–0.4**. Removed from the plan for now: Notification (was 0.5), Context bus (was 0.6 — **folded into Epic 0.0** as Stories 0.0.6–0.0.7, not deleted), User authenticates (was 0.7), MRD ingestion (was 0.8), User populations bootstrapped (was 0.9), MRD data read API (was 0.10). Two real dependency edges into removed epics were resolved: Epic 0.1/0.3's dependency on the context bus now points at Epic 0.0 (where it's folded in); Epic 0.4's read API, which needed `JWTFilter`/jurisdiction-filtering from the removed auth epic, is **simplified to an open, unauthenticated API** for this scope. See the epic files' own scope-reduction notes for full detail, and `sprint-change-proposal-2026-08-25.md#sprint-change-proposal-2026-08-25d` for the complete before/after.

> **Further scope reduction 2026-08-25 (SCP 2026-08-25f)** — Epic 0.2 (JOH eLinks mock API) no longer deploys anywhere: `ctam-jomockapi` runs **locally via Docker Compose** only, alongside a locally-run `ctam-reference-data`. `depends_on` drops to `[]` (it never needed the estate for anything but that deployment). Every "demoable in dev/staging" claim tied to this mock (NFR24, gaps.md G8.1) is narrowed to "demoable locally" — see the epic files' own scope-reduction notes.

> Phase 0 is sequenced **platform-then-JOH-data-pipeline**: Epic 0.0 platform estate (+ context bus) → Epic 0.1 JOH schema / Epic 0.2 JOH mock API (parallel, no epic dependency) → Epic 0.3 JOH ETL ingestion → Epic 0.4 JOH data read API. The shared Azure estate stands up and is independently verified first (Epic 0.0, `ctam-shared-infrastructure`); the ingestion then runs in-process inside `ctam-reference-data` — there is no `ctam-integrations` repo.

> Phase 0 is the platform smoke-test (per PRD Key Characteristic 4). API-as-Product standards (versioning, OpenAPI, [RFC 9457](https://datatracker.ietf.org/doc/html/rfc9457), `Deprecation`/`Sunset`) are exercised on Reference Data **reads** before any domain service is built. Authorisation lookups are **not** exercised in this reduced scope.
>
> The Phase 0 areas in [../framework.md](../framework.md) are an **architectural map** — including areas with no concrete epic right now (Identity & Authorisation, Notification, Identity Bootstrap & Verification, Business UI Foundation). The **five** concrete user-value epics below are the **implementation plan**.

## Phase 0 scope model

- **No legacy data migration**[^d3][^d13] — no data migrates from any incumbent (`[ET-INCUMBENT-TBD]`, ListAssist, APEX), ever. Judicial-holder reference data is **ingested from its upstream source of truth**: the JOH eLinks API (nightly in-process sync, the "ETL process" of Epic 0.3). Historical data stays in each jurisdiction's incumbent system. *(MRD ingestion is out of scope in this reduced plan.)*
- **Platform estate is Epic 0.0 — the first deliverable**: the shared Azure estate (AKS, PostgreSQL, ACR, APIM, App Insights, Key Vault) is provisioned via Terraform in the dedicated `ctam-shared-infrastructure` repo and independently verified layer-by-layer (AR53 revised, HMCTS CNP `{product}-shared-infrastructure` standard). It also carries the published context bus + shared config baseline (Stories 0.0.6–0.0.7, folded in 2026-08-25d).
- **Upstream ingestion is Epic 0.3 (JOH eLinks ETL process, Story 0.3.3) — the first domain deliverable**. `ctam-reference-data` is the first domain service scaffolded and deploys onto the Epic 0.0 estate. In-process — **no `ctam-integrations` repo**.
- **The read API (Epic 0.4) is open** — no authentication, no jurisdiction filtering — since the auth epic it depended on is out of scope. Re-adding auth later is additive, not a redesign.
- **Admin UI, notification, and user bootstrap are out of scope** for this reduced Phase 0 — their architectural design remains documented in `framework.md`, ready to re-enter the plan.

## Epics

| Epic | Title | Stories | Status |
|---|---|---|---|
| [0.0](epic-0.0-platform-estate-provisioned.md) | Platform estate is provisioned, verifiable, and CNP-compliant | 7 | 🟡 Planned |
| [0.1](epic-0.1-postgres-sql-schema-design.md) | JOH domain schema is designed and implemented in PostgreSQL | 4 | 🟡 Planned |
| [0.2](epic-0.2-joh-elinks-mock-api-stands-in.md) | JOH eLinks mock API stands in for the unconfirmed upstream contract | 3 | 🟡 Planned |
| [0.3](epic-0.3-joh-reference-data-etl-process.md) | JOH reference-data ETL process | 3 | 🟡 Planned |
| [0.4](epic-0.4-joh-data-read-only-api.md) | JOH data is served read-only via a versioned API | 2 | 🟡 Planned |
| **Total** | | **19 stories** | |

## Epic summaries

### Epic 0.0: Platform estate is provisioned, verifiable, and CNP-compliant (7 stories)

**User outcome:** The shared Azure estate — AKS, PostgreSQL Flexible Server, ACR, APIM, Application Insights, Key Vault — is stood up via **Terraform** in its own dedicated repo, **`ctam-shared-infrastructure`** (HMCTS CNP `{product}-shared-infrastructure` standard, AR53 revised), provisioned **layer-by-layer with each layer independently verified at deploy time**, so every Phase 0 service has a tested platform to deploy onto. The published context bus and shared config baseline (Stories 0.0.6–0.0.7, folded in from the former Epic 0.6, SCP 2026-08-25d) also live here. Precedes every other epic. Stories: 0.0.1 repo + Terraform foundation; 0.0.2 network + AKS; 0.0.3 PostgreSQL + Key Vault; 0.0.4 ACR + observability; 0.0.5 APIM + smoke API; 0.0.6 publish `ctam-architecture` as the context bus; 0.0.7 shared `ctam_configuration_values` baseline.

**FRs covered:** FR8 (shared config baseline, Story 0.0.7). **NFRs:** NFR10, NFR11, NFR16, NFR25–NFR28, NFR31, NFR40. **ARs:** AR53 (revised), A34, G9.

→ [Full epic with stories](epic-0.0-platform-estate-provisioned.md)

### Epic 0.1: JOH domain schema is designed and implemented in PostgreSQL (4 stories)

**User outcome:** `ctam-joh`'s 5 domain tables — working patterns, per-day pattern breakdown, ticket overlay, location overlay, jurisdictional splits — are **designed explicitly** (a written design-decisions doc, an ER diagram, a full column-level spec, and a data-warnings/open-questions doc — mirroring the documentation rigor of the JOH eLinks integration schema, `3.2.1.1`/`3.2.1.2`) and implemented via Liquibase, keyed by `joh_id` → `ctam_joh_identities.id`, with tier ownership and a cross-service SELECT grant to `ctam-reference-data`. **Schema only** — the behavioral stories that populate and maintain this schema are future Phase 1 epics. *(Added as Epic 1.1 via SCP 2026-08-24c, moved to Phase 0 as Epic 0.9 via SCP 2026-08-25, renumbered to Epic 0.1 via SCP 2026-08-25b; design-rigor expansion from 2 to 4 stories via SCP 2026-08-25j.)*

**FRs covered:** none behaviourally — schema groundwork for FR12, FR15b, FR16, FR17 (Phase 1 FRs).

→ [Full epic with stories](epic-0.1-postgres-sql-schema-design.md)

### Epic 0.2: JOH eLinks mock API stands in for the unconfirmed upstream contract (3 stories)

**User outcome:** `ctam-reference-data`'s nightly eLinks sync (Story 0.3.3) runs end-to-end against a locally-run, schema-faithful mock of the JOH eLinks People API v5 (`ctam-jomockapi`, CTAM Pathfinder's 17th repo, non-production-only — same category as `ctam-mock-auth`), so Phase 0 has a demoable ingestion pipeline in local development while the real eLinks contract (gaps.md G8.1) remains unconfirmed. *(New 2026-08-24 as Epic 0.7, SCP 2026-08-24; renumbered to Epic 0.2 via SCP 2026-08-25b; narrowed to local-only, no shared-estate deployment, via SCP 2026-08-25f.)*

**Has no epic dependency** — it never deploys to the shared estate (see its own scope-reduction note); `depends_on: []`.

**FRs covered:** none directly (infrastructure/tooling). **Supports:** FR1, FR6 tier-(a), FR7 tier-(a), NFR24 (exercised end-to-end pre-contract).

→ [Full epic with stories](epic-0.2-joh-elinks-mock-api-stands-in.md)

### Epic 0.3: JOH reference-data ETL process (3 stories)

**User outcome:** The JOH reference-data ETL process — extract nightly from the **JOH eLinks API**, transform into CTAM's tier-(a) schema, load via full-refresh upsert into the 15 `jo_*` entities (Story 0.3.3) — so `jo_people` exists and is current. This is the platform's foundational data layer. `ctam-reference-data` is the first domain service scaffolded (Story 0.3.1) and deploys onto the shared estate provisioned in **Epic 0.0**; tier-(a) tables + write protection are Story 0.3.2. *(Retitled 2026-08-24b — was "Upstream JOH/MRD reference data is ingested"; MRD ingestion split out to Epic 0.8, then removed from the plan entirely 2026-08-25d. Renumbered from Epic 0.1 to Epic 0.3 via SCP 2026-08-25b.)*

**FRs covered:** FR1 (the `jo_people` lookup target), FR6 tier-(a), FR7 tier-(a) grants, FR8 (shared config baseline first lands in Epic 0.0); NFR24 (JOH eLinks), FR59 (structured logs first exercised)

→ [Full epic with stories](epic-0.3-joh-reference-data-etl-process.md)

### Epic 0.4: JOH data is served read-only via a versioned API (2 stories)

**User outcome:** Tier-(b) CTAM-owned reference data (regions, offices, calendar, operational vocabularies) is created, seeded, and DBA-maintained per runbook[^d10] (Story 0.4.1); **JOH data** — both tiers — is served by a versioned **read-only** REST API (Story 0.4.2). **Open / unauthenticated in this scope** — the auth epic it depended on for `JWTFilter` and jurisdiction filtering was removed 2026-08-25d. *(Retitled from "Reference data..." to "JOH data..." and renumbered from Epic 0.9 to Epic 0.4 via SCP 2026-08-25c, when MRD's read surface briefly split into Epic 0.10; that epic was removed entirely 2026-08-25d.)*

**FRs covered (Phase 0 surface):** FR6 (tier-(b) maintenance + JOH read API over both tiers), FR7, FR58

→ [Full epic with stories](epic-0.4-joh-data-read-only-api.md)

## Phase 0 Epic Stories Summary

| Epic | Stories | FRs covered | Phase 0 demo |
|---|---|---|---|
| 0.0 | 7 stories (0.0.1–0.0.7) | FR8 (Story 0.0.7); NFR10, NFR11, NFR16, NFR25–NFR28, NFR31, NFR40 | Each Terraform layer stands up and is verified as deployed — `kubectl get nodes` Ready across AZs, PostgreSQL TLS-only, Key Vault secret round-trip, ACR image pull, APIM smoke API → 200 over TLS; `arch-v1.0` tagged and resolvable via `_arch/`; a service role SELECTs `ctam_configuration_values` and is refused a write |
| 0.1 | 4 stories (0.1.1–0.1.4) | none directly; schema groundwork for FR12, FR15b, FR16, FR17 | `ctam-joh` scaffolded; its schema design-decisions doc + ER diagram exist; its 5 domain tables exist via Liquibase, keyed to `ctam_joh_identities`, tier-owned + SELECT-granted to `ctam-reference-data`; data-warnings/open-questions doc exists |
| 0.2 | 3 stories (0.2.1–0.2.3) | none directly; supports FR1, FR6 tier (a), FR7 tier (a); NFR24 | `ctam-jomockapi` running locally via Docker Compose; Story 0.3.3's sync runs against it end-to-end locally |
| 0.3 | 3 stories (0.3.1–0.3.3) | FR1 (`jo_people` target), FR6 tier (a), FR7 tier (a), FR8, FR59; NFR24 | JOH eLinks ETL process flows data in → `jo_people` current (verified via `ctam_sync_status` + CI WireMock stub, and end-to-end locally against Epic 0.2's locally-run mock) |
| 0.4 | 2 stories (0.4.1–0.4.2) | FR6 (tier b + JOH read API), FR7, FR58 | Open, jurisdiction-unfiltered JOH data API serves both tiers read-only |
| **Total** | **19 stories** | | The five demos chain together for the Phase 0 stakeholder walkthrough — starting with the verified platform estate |

**Cross-cutting NFRs verified across Phase 0 stories:** NFR10 (TLS), NFR11 (data-at-rest), NFR14 (no forbidden data), NFR15 (change trails per runbooks), NFR16 (Key Vault incl. eLinks credential), NFR24 (JOH eLinks MVP integration), NFR25–NFR28 (observability), NFR31 (Azure UK South), NFR39 (API-as-Product), NFR40 (per-service deployable), NFR42 (Postman collections). *(NFR12, NFR13, NFR17–NFR20, NFR22 — JWT propagation, authz enforcement, business UI WCAG, HMCTS IdP, HMCTS email — are not exercised in this reduced scope; they return when auth/notification/UI are re-planned.)*

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

**Removed from the active plan 2026-08-25d, not post-MVP** (these are full PRD requirements, re-planned as a future epic if/when scope returns, not deferred features): Notification (FR9), User authentication + Authorisation (FR1–FR3, FR55, FR56, FR58 auth half), User-population bootstrap (FR4, FR57), MRD ingestion + MRD read API (FR6/FR7/NFR24 MRD half).

## Validation

- Phase 0 awaits validation via the **ET-cohort implementation-readiness assessment**[^d13]. *(The SSCS-cohort assessment becomes a wave-2 gate.)*

[^d3]: Revised D3 (2026-06-10) — no data migration from any legacy system; judicial-holder reference data is ingested from the JOH eLinks API and MRD.
[^d8]: D8 — rollout is jurisdiction-first, then per-region; jurisdiction is a first-class hierarchical attribute.
[^d9]: Restructured D9 (2026-06-10; refined 2026-07-09 per SCP) — two user populations. JOHs resolve IdP email → `jo_people` → `personnel_number` → a **CTAM-assigned JOH UUID** (`ctam_joh_identities`); HMCTS admin staff via a CTAM-internal identity table. Both key on a CTAM-assigned UUID; `personnel_number` is the upstream link only. No legacy user migration.
[^d10]: D10 (2026-05-15) — admin UI is post-MVP; MVP admin operations are DBA-via-SQL per operational runbooks.
[^d11]: D11 (2026-06-10, amended 2026-06-18; **superseded by D13 2026-08-07 for wave ordering**) — SSCS pilot wave: CTAM Pathfinder replaces **ListAssist** (the SSCS judicial-scheduling tool); **GAPS (SSCS case management) is retained, not replaced**. Per D13 the SSCS wave is **wave 2**.

[^d13]: D13 (2026-08-07, supersedes D11) — ET-first pilot: wave 1 = the **Employment Tribunals (ET)** jurisdiction (scheduling incumbent `[ET-INCUMBENT-TBD]` — unidentified, gap G8.4); wave 2 = **SSCS** (replaces **ListAssist**; **GAPS**, SSCS case management, is retained); waves 3+ = Courts jurisdictions per HMCTS judicial region (replacing JI/APEX).
