---
type: 'Phase Index'
title: 'Phase 0 — Foundations'
description: 'User outcome: The shared Postgres schema is designed and CI-enforced, then judicial-holder reference data flows into CTAM from its upstream sources of truth — the JOH eLinks API (nightly) and the MRD weekly Excel feed…'
resource: 'epics/phase-0/index.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-18'
parent: 'epics/index.md'
phase: 0
phaseName: 'Foundations'
---

# Phase 0 — Foundations

> Phase 0 is sequenced **enablement-then-platform-then-design-then-mock-then-integrations-first**: **Epic 0.A context bus + scaffolding + runbooks** → Epic 0.0 platform estate → **Epic 0.B shared DB baseline + service roles** → Epic 0.1 Postgres schema design → **Epic 0M.1 JOH mock source** → Epic 0.2 JOH ingestion → **Epic 0M.2 MRD mock source** → Epic 0.3 MRD ingestion → Epic 0.4 auth + UI → Epic 0.5 JOH+tier-(b) read API → Epic 0.6 MRD read API → Epic 0.7 bootstrap → Epic 0.8 notification.
>
> **Epics 0.A and 0.B are lettered, not numbered** (SCP 2026-08-18e). Both are `ctam-architecture` enablement epics that eight other stories already assumed: 0.A delivers the `arch-v1.0` bus tag, `ctam-scaffold.sh` and the GitHub/Terraform runbooks and therefore **precedes Epic 0.0**; 0.B delivers the `ctam_configuration_values` baseline **and the per-service DB roles** and therefore **follows** it (the roles need the Story 0.0.3 server). Lettering kept all 23 pre-existing Phase 0 story ids stable — the same convention the `0M.` tier uses. As always, **the graph is the order, not the identifier**. The shared Azure estate stands up and is independently verified first (Epic 0.0, `ctam-shared-infrastructure`); the relational schema design is finalized and CI-enforced next (Epic 0.1); JOH and MRD each get their own ingestion epic (0.2/0.3) and their own read-API epic (0.5/0.6) — same service (`ctam-reference-data`), two independently demoable API surfaces per upstream source. There is no `ctam-integrations` repo.
>
> **Epics 0M.1 and 0M.2 are not Phase 0 epics** — they live in [**Phase 0-Mock**](../phase-0-mock/index.md), a pre-Phase-0 tier that stands up contract-shaped stand-ins for both upstream sources (gaps.md **G8.1**) before the ingestion epics consume them. They appear in the arrow order above because Epic 0.2 and Epic 0.3 each `depends_on` one of them, but they are counted in Phase 0-Mock's totals, not Phase 0's. [`../../delivery/dispatch-graph.yaml`](../../delivery/dispatch-graph.yaml) is the single authority on order; its topological sort is the arrow order above.

> Phase 0 is the platform smoke-test (per PRD Key Characteristic 4). All API-as-Product standards (versioning, OpenAPI, [RFC 9457](https://datatracker.ietf.org/doc/html/rfc9457), `Deprecation`/`Sunset`) are exercised on Authorisation lookups and Reference Data **reads** before any domain service is built.
>
> The Phase 0 areas in [../framework.md](../framework.md) are an **architectural map**. The eleven epics below are the **implementation plan** — each delivers a demoable user outcome and consolidates the supporting technical work as stories within the epic.

## Phase 0 scope model

- **No legacy data migration**[^d3][^d13] — no data migrates from any incumbent (`[ET-INCUMBENT-TBD]`, ListAssist, APEX), ever. Judicial-holder reference data is **ingested from upstream sources of truth**: the JOH eLinks API (nightly in-process sync) and MRD (weekly Excel via blob drop). Historical data stays in each jurisdiction's incumbent system.
- **Enablement is Epic 0.A — genuinely first**: the context bus (`arch-v1.0`), `ctam-scaffold.sh` + the starter overlay (gaps.md G1.4a/G1.4b), and the `runbooks/github-setup.md` (AR51) + `runbooks/terraform.md` (G9.1/G10.1/G10.2) that Story 0.0.1 and five scaffold stories open by citing. Previously an undecomposed `arch-baseline` dispatch node with no stories and no owner.
- **Platform estate is Epic 0.0 — the first *provisioning* deliverable**: the shared Azure estate (AKS, PostgreSQL, ACR, APIM, App Insights, Key Vault) is provisioned via Terraform in the dedicated `ctam-shared-infrastructure` repo and independently verified layer-by-layer (AR53 revised, HMCTS CNP `{product}-shared-infrastructure` standard).
- **The shared DB baseline and every per-service DB role are Epic 0.B**: `ctam_configuration_values` (FR8) plus the `ctam_reference_data` / `ctam_authorisation` / `ctam_notification` / `ctam_mock_auth` roles and the forward-declared Phase 1–8 roles, with the grants convention. Stories 0.2.2 and 0.5.1 grant privileges to these roles; nothing previously created them.
- **Schema design is Epic 0.1 — before any table is created**: the relational schema for every Phase 0 table is finalized in `architecture/data-tables.md` and enforced by a CI fitness function, so every service creates tables against one agreed, reviewed shape from the start.
- **Upstream ingestion is split into two independently-demoable epics**: JOH eLinks sync (Epic 0.2) and MRD Excel ingestion (Epic 0.3) — different format (JSON API vs Excel workbook), cadence (nightly vs weekly), and delivery mechanism (API pull vs Blob drop). `ctam-reference-data` is the first domain service scaffolded (Epic 0.2, Story 0.2.1) and deploys onto the Epic 0.0 estate; Epic 0.3 adds the MRD ingestion mechanism onto the same service. In-process — **no `ctam-integrations` repo**.
- **Both upstream sources are mocked first — in [Phase 0-Mock](../phase-0-mock/index.md), before Phase 0's ingestion epics**: neither upstream contract is confirmed (gaps.md **G8.1**, a wave-1 blocker), so each gets a deployable, contract-shaped stand-in *before* its ingestion epic — **`ctam-joh-mock`** (Epic 0M.1: all 15 `jo_*` entities as JSON, ET-flavoured fixtures, fault injection) and **`ctam-mrd-mock`** (Epic 0M.2: conformant and deliberately-malformed workbooks published into a configurable blob container). This is the same mock-first play `ctam-mock-auth` runs for the HMCTS IdP: it turns an external-team dependency into a **configuration cutover**. Both are dev/CI/integration-only and **never deploy to production** (AR55, AR56). **Neither closes G8.1** — the mocks encode CTAM's *written expectation* of each contract, so the real contract arrives as a diff rather than a discovery; G8.1 closes only when each ingestion has run against real upstream data. Full detail: [Phase 0-Mock](../phase-0-mock/index.md).
- **The read-only Reference Data API is likewise split by upstream source**: Epic 0.5 serves JOH tier-(a) data + all tier-(b) CTAM-owned data (none of which is MRD-sourced); Epic 0.6 serves MRD tier-(a) data (Specialisations) on its own API surface. Same deployable (`ctam-reference-data`), same OpenAPI artefact, two documented resource groups — the ownership boundary between JOH and MRD stays visible at the API layer, not just in the ingestion mechanism.
- **Two user populations**[^d9]: JOH users resolve IdP email → `jo_people` → `personnel_number` → CTAM JOH UUID (`ctam_joh_identities`); HMCTS admin staff resolve via `ctam_auth_staff_identities` → CTAM-assigned UUID. Both share one authorisation model and both key on a CTAM-assigned UUID.
- **Jurisdiction is first-class**[^d8]: authz responses carry roles + jurisdiction + Region/Area scope; reference-data API responses are jurisdiction-filtered; activation flags key on the (jurisdiction, region) tuple (FR57).
- **Admin UI is post-MVP**[^d10]: tier-(b) reference data and user/role/scope maintenance are DBA-via-SQL per runbook.

## Epics

| Epic | Title | Repo | Stories | Status |
|---|---|---|---|---|
| [0.A](epic-0.A-architecture-context-bus-and-scaffolding.md) | Context bus published, scaffolding toolchain built, and platform runbooks written *(precedes 0.0)* | `ctam-architecture` | 3 | 🟡 Planned |
| [0.0](epic-0.0-platform-estate-provisioned.md) | Platform estate is provisioned, verifiable, and CNP-compliant | `ctam-shared-infrastructure` | 6 | 🟡 Planned |
| [0.B](epic-0.B-shared-db-baseline-and-service-roles.md) | Shared database baseline and per-service DB roles are established *(follows 0.0)* | `ctam-architecture` | 1 | 🟡 Planned |
| [0.1](epic-0.1-postgres-schema-design.md) | Shared PostgreSQL schema design is established and CI-enforced | `ctam-analysis` + `ctam-architecture` | 2 | 🟡 Planned |
| [0.2](epic-0.2-joh-reference-data-ingested.md) | Upstream JOH reference data is ingested | `ctam-reference-data` | 3 | 🟡 Planned |
| [0.3](epic-0.3-mrd-reference-data-ingested.md) | Upstream MRD reference data is ingested | `ctam-reference-data` | 1 | 🟡 Planned |
| [0.4](epic-0.4-user-authenticates.md) | User authenticates and lands on a role-scoped Home page | `ctam-authorisation` + `ctam-mock-auth` + `ctam-ui` | 5 | 🟡 Planned |
| [0.5](epic-0.5-joh-reference-data-read-only-api.md) | JOH and tier-(b) reference data served read-only via a versioned, jurisdiction-filtered API | `ctam-reference-data` | 2 | 🟡 Planned |
| [0.6](epic-0.6-mrd-reference-data-read-only-api.md) | MRD reference data served read-only via a versioned, jurisdiction-filtered API | `ctam-reference-data` | 1 | 🟡 Planned |
| [0.7](epic-0.7-user-populations-bootstrapped.md) | Both user populations are bootstrapped and verifiable against the IdP | `ctam-architecture` | 1 | 🟡 Planned |
| [0.8](epic-0.8-system-dispatches-emails.md) | Notification service is scaffolded and contractually ready | `ctam-notification` | 2 | 🟡 Planned |
| **Total** | **11 epics** | **9 repos + the control plane** | **27 stories** | |

### Repo coverage at a glance

Phase 0 + [Phase 0-Mock](../phase-0-mock/index.md) touch **9 of the 18 product repos**, plus `ctam-analysis` (the control plane, which holds no runtime code):

| Repo | Epics landing in it | Stories |
|---|---|---|
| `ctam-architecture` | 0.A, 0.B, 0.1 *(story 0.1.2)*, 0.7 | 6 |
| `ctam-reference-data` | 0.2, 0.3, 0.5, 0.6 | 7 |
| `ctam-shared-infrastructure` | 0.0 | 6 |
| `ctam-ui` | 0.4 *(0.4.4, 0.4.5)* | 2 |
| `ctam-authorisation` | 0.4 *(0.4.1, 0.4.3)* | 2 |
| `ctam-notification` | 0.8 | 2 |
| `ctam-joh-mock` | 0M.1 | 2 |
| `ctam-mrd-mock` | 0M.2 | 2 |
| `ctam-mock-auth` | 0.4 *(0.4.2)* | 1 |
| `ctam-analysis` | 0.1 *(story 0.1.1)* | 1 |

**Untouched until Phase 1+:** `ctam-joh` (1), `ctam-absence` (2), `ctam-vacancy` (3), `ctam-booking` (4), `ctam-sitting` (5), `ctam-payment` (6), `ctam-itinerary` (7), `ctam-mi-feed` (8), `ctam-admin-ui` (post-MVP[^d10]).

**Two repos carry four epics each and need care:** `ctam-reference-data` (0.2 → 0.3 → 0.5 → 0.6) and `ctam-architecture` (0.A → 0.B → 0.1.2 → 0.7). Their epics are **not** safe to parallelise even where the dependency graph permits it — Epics 0.5 and 0.6 rewrite the same OpenAPI artefact and the same Postman collection. The ordering is recorded in [`../../delivery/dispatch-graph.yaml`](../../delivery/dispatch-graph.yaml) → `repo_serialisation`.

**Six stories land an artefact in a second repo** (ledger `touches:`): 0.1.1 → the bus · 0.2.2, 0.3.1, 0.4.3, 0.8.1 → `architecture/data-tables.md` in `ctam-analysis` · 0.5.1 → both (`runbooks/reference-data-maintenance.md` in `ctam-architecture` **and** `data-tables.md`). Dispatch packets must cover both diffs; see [`../../delivery/ledger/README.md`](../../delivery/ledger/README.md).

> **Prerequisite from another phase:** Epic 0.2 additionally depends on **Epic 0M.1** and Epic 0.3 on **Epic 0M.2**, both in [Phase 0-Mock](../phase-0-mock/index.md) (4 stories, counted there).

## Epic summaries

### Epic 0.A: Context bus published, scaffolding toolchain built, and platform runbooks written (3 stories)

**User outcome:** `ctam-architecture` exists and is published as the **version-pinned context bus** tagged **`arch-v1.0`** (the `bus_version` every ledger shard already records); **`ctam-scaffold.sh`** assembles a conformant service repo from the deliberately-minimal HMCTS starter, including the ~9 capabilities the base omits and every CI gate the programme enforces; and the two platform runbooks eight other stories cite — **`runbooks/github-setup.md`** (AR51) and **`runbooks/terraform.md`** (gaps.md G9.1, G10.1, G10.2) — are written. **Precedes Epic 0.0**, whose Story 0.0.1 opens with the GitHub checklist. Stories: 0.A.1 bus publish + `arch-v1.0` tag; 0.A.2 `ctam-scaffold.sh` + starter overlay + CI ruleset wiring; 0.A.3 the GitHub-setup and Terraform-conventions runbooks.

**FRs covered:** none (programme enablement). **NFRs:** none newly introduced — the scaffold is where NFR25–NFR28/NFR39/NFR40 become repeatable. **ARs:** AR2–AR17, AR24, AR28–AR32, AR41, AR51, AR53; gaps.md G1.4, G1.4a, G1.4b, G4.4, G4.5, G9.1, G10.1, G10.2.

→ [Full epic with stories](epic-0.A-architecture-context-bus-and-scaffolding.md)

### Epic 0.0: Platform estate is provisioned, verifiable, and CNP-compliant (6 stories)

**User outcome:** The shared Azure estate — AKS, PostgreSQL Flexible Server, ACR, APIM, Application Insights, Key Vault — is stood up via **Terraform** in its own dedicated repo, **`ctam-shared-infrastructure`** (HMCTS CNP `{product}-shared-infrastructure` standard, AR53 revised), provisioned **layer-by-layer with each layer independently verified at deploy time**, so every Phase 0 service has a tested platform to deploy onto. Precedes Epic 0.1. Stories: 0.0.1 repo + Terraform foundation (state backend, plan/apply CI); 0.0.2 network + AKS (verified via `kubectl get nodes` + hello pod); 0.0.3 PostgreSQL + Key Vault (TLS-only connect, plaintext refused, secret round-trip); 0.0.4 ACR + observability (image pull, test trace lands); 0.0.5 APIM + smoke API (gateway → echo 200 over TLS); 0.0.6 network perimeter hardening (NSGs, private endpoints, WAF, DDoS protection — verified via isolation + blocked-attack smoke tests).

**FRs covered:** none (foundational platform infrastructure). **NFRs:** NFR10, NFR11, NFR15, NFR16, NFR25–NFR28, NFR31. **ARs:** AR53 (revised), AR54 (new), A34, G9, G10.

→ [Full epic with stories](epic-0.0-platform-estate-provisioned.md)

### Epic 0.B: Shared database baseline and per-service DB roles are established (1 story)

**User outcome:** The shared **`ctam_configuration_values`** table exists on the Epic 0.0 server, managed by `ctam-architecture`'s Liquibase baseline (FR8); **every per-service PostgreSQL role exists** with its baseline grants — the four Phase 0 service roles plus the forward-declared Phase 1–8 roles — and the grants convention is documented. Follows Epic 0.0 (it needs the Story 0.0.3 server) and precedes Epic 0.1. Closes a real gap: Stories 0.2.2 and 0.5.1 grant privileges to roles that nothing previously created, and Story 0.0.3 excludes role creation explicitly.

**FRs covered:** FR8. **NFRs:** NFR11, NFR15, NFR16. **ARs:** AR18, AR19, AR22, AR49; gaps.md G6.4.

→ [Full epic with stories](epic-0.B-shared-db-baseline-and-service-roles.md)

### Epic 0.1: Shared PostgreSQL schema design is established and CI-enforced (2 stories)

**User outcome:** The relational schema design for every Phase 0 table — tier-(a) upstream (`jo_*`, `mrd_*`), tier-(b) CTAM-owned, and each service's own domain tables — is authored, reviewed, and published in `architecture/data-tables.md` (Story 0.1.1), together with a CI-enforced fitness function checking naming/PK/FK/timestamp/tier-prefix conventions on every service's Liquibase changelog (Story 0.1.2). Precedes every table-creating epic (0.2 onward) so no service invents its own schema conventions.

**FRs covered:** none (foundational data-design infrastructure — enablement for FR6/FR7 tier ownership + grants across every table-creating epic).

→ [Full epic with stories](epic-0.1-postgres-schema-design.md)

### Epic 0.2: Upstream JOH reference data is ingested (3 stories)

**User outcome:** Judicial-holder reference data flows into CTAM from its upstream source of truth — the **JOH eLinks API** (15 `jo_*` entities, nightly in-process sync, Story 0.2.3) — so `jo_people` exists and is current. This is the platform's foundational data layer. `ctam-reference-data` is the first domain service scaffolded (Story 0.2.1) and deploys onto the shared estate provisioned in **Epic 0.0**, conforming to the schema design in **Epic 0.1**; tier-(a) `jo_*` tables + `ctam_sync_status` + write protection are Story 0.2.2.

**FRs covered:** FR1 (the `jo_people` lookup target), FR6 tier-(a), FR7 tier-(a) grants, FR8 (shared config baseline first lands); NFR24, FR59 (structured logs first exercised)

→ [Full epic with stories](epic-0.2-joh-reference-data-ingested.md)

### Epic 0.3: Upstream MRD reference data is ingested (1 story)

**User outcome:** Supplementary judicial reference data not present in JOH eLinks — notably JOH Specialisations — flows into CTAM from the **MRD** team's weekly Excel feed (`mrd_*`, Story 0.3.1), without waiting for MRD's public APIs. A separate upstream source from JOH eLinks (different format, cadence, and delivery mechanism), split into its own epic so each ingestion mechanism is independently demoable. Depends on **Epic 0.1** (schema design) and **Epic 0.2** (the scaffolded repo + shared `ctam_sync_status` run log).

**FRs covered:** FR6 tier-(a), FR7 tier-(a) grants; NFR24

→ [Full epic with stories](epic-0.3-mrd-reference-data-ingested.md)

### Epic 0.4: User authenticates and lands on a role-scoped Home page (5 stories)

**User outcome:** A user from **either identity population** — JOH (Judge, Tribunal Judge, Tribunal Member) or HMCTS admin staff (RSU, Court user, Tribunal Caseworker, Finance, MI) — signs in via SSO, has their canonical identity resolved (CTAM JOH UUID via the eLinks-synced `jo_people` → `personnel_number` → `ctam_joh_identities`; staff UUID via `ctam_auth_staff_identities`), and lands on a role-scoped Home page. Depends on Epic 0.2 (`jo_people` populated), Epic 0.1 (schema design), and consumes the shared estate provisioned in Epic 0.0.

**FRs covered:** FR1, FR2, FR3, FR55, FR56 (business stack); FR57 (activation surface), FR58 (Authorisation read API)

→ [Full epic with stories](epic-0.4-user-authenticates.md)

### Epic 0.5: JOH and tier-(b) reference data served read-only via a versioned, jurisdiction-filtered API (2 stories)

**User outcome:** Tier-(b) CTAM-owned reference data (regions, offices, calendar, operational vocabularies) is created, seeded, and DBA-maintained per runbook[^d10] (Story 0.5.1); tier-(b) plus JOH tier-(a) data (sourced from Epic 0.2) is served by the versioned **read-only**, **jurisdiction-filtered** REST API (Story 0.5.2). Sequenced after Epic 0.4 (depends on `JWTFilter` + `authz/check`). MRD reads are a separate API — **Epic 0.6** — since none of the 15 tier-(b) tables are MRD-sourced.

**FRs covered (Phase 0 surface):** FR6 (tier-(b) maintenance + read API over tier (a) JOH + tier (b)), FR7, FR58

→ [Full epic with stories](epic-0.5-joh-reference-data-read-only-api.md)

### Epic 0.6: MRD reference data served read-only via a versioned, jurisdiction-filtered API (1 story)

**User outcome:** MRD-sourced supplementary judicial reference data — notably JOH Specialisations, ingested in **Epic 0.3** — is queryable read-only via `ctam-reference-data`'s versioned REST API, **jurisdiction-filtered**, on its own API surface separate from Epic 0.5. Same service, same OpenAPI artefact, distinct resource group — the MRD ownership boundary stays visible at the API layer, not just in the ingestion mechanism. Sequenced after Epic 0.4 (depends on `JWTFilter` + `authz/check`).

**FRs covered (Phase 0 surface):** FR6 (read API over MRD tier (a)), FR7, FR58

→ [Full epic with stories](epic-0.6-mrd-reference-data-read-only-api.md)

### Epic 0.7: Both user populations are bootstrapped and verifiable against the IdP (1 story)

**User outcome:** Authorisation records for both populations exist (seeded in dev/CI; programme-bootstrapped in production per the runbook) with all-FALSE (jurisdiction, region) activation flags, and a re-runnable **bootstrap-verification job** proves every user maps to an IdP principal — a standing wave-cutover gate artefact (also used at the pre-Phase-9 IdP cutover per G1.3).

**FRs covered (Phase 0 surface):** FR1 (lookup data), FR4 (MVP data-layer criterion), FR57 (initial flag state)

→ [Full epic with stories](epic-0.7-user-populations-bootstrapped.md)

### Epic 0.8: Notification service is scaffolded and contractually ready (2 stories)

**User outcome:** `ctam-notification` is deployed with its API contract published, the `ctam_notification_dispatches` delivery-log table created (conforming to the Epic 0.1 schema design), SMTP integration configured, and `POST /v1/notifications/send` working. The contract is consumable from Phase 2+ via **user-JWT propagation**. Integration testing in MVP happens via Postman — **no admin UI**.

**FRs covered:** FR9

→ [Full epic with stories](epic-0.8-system-dispatches-emails.md)

## Phase 0 Epic Stories Summary

| Epic | Stories | FRs covered | Phase 0 demo |
|---|---|---|---|
| 0.A | 3 stories (0.A.1–0.A.3) | none (programme enablement); gaps G1.4a/G1.4b/G4.4/G4.5/G9.1/G10.1/G10.2 | `arch-v1.0` tagged and consumable as a submodule; a throwaway `ctam-scaffold.sh` run produces a repo that builds, passes every wired CI gate and serves `/actuator/health`; both runbooks followed end-to-end by someone other than their author |
| 0.0 | 6 stories (0.0.1–0.0.6) | none (platform infra); NFR10, NFR11, NFR15, NFR16, NFR25–NFR28, NFR31 | Each Terraform layer stands up and is verified as deployed — `kubectl get nodes` Ready across AZs, PostgreSQL TLS-only (plaintext refused), Key Vault secret round-trip, ACR image pull, APIM smoke API → 200 over TLS, network perimeter hardened (private-endpoint-only data plane, WAF blocks a CRS test payload, DDoS plan attached) |
| 0.B | 1 story (0.B.1) | FR8; NFR11, NFR15, NFR16 | `ctam_configuration_values` exists; every service role exists; `ctam-reference-data` connects as its own role, reads the table, and is **refused** on write |
| 0.1 | 2 stories (0.1.1–0.1.2) | none (foundational data design) | `architecture/data-tables.md` finalized and reviewed; a Liquibase changeset violating the naming/PK/FK/tier-prefix conventions fails CI via the fitness function |
| 0.2 | 3 stories (0.2.1–0.2.3) | FR1 (`jo_people` target), FR6 tier (a), FR7 tier (a), FR8, FR59; NFR24 | JOH reference data flows in from eLinks → `jo_people` current (verified via `ctam_sync_status`, against the deployed `ctam-joh-mock` stand-in from Epic 0M.1) |
| 0.3 | 1 story (0.3.1) | FR6 tier (a), FR7 tier (a); NFR24 | MRD Specialisations flow in from the weekly Excel feed → `mrd_specialisms` current (verified via `ctam_sync_status`) |
| 0.4 | 5 stories (0.4.1–0.4.5) | FR1, FR2, FR3, FR55, FR56, FR57 (activation surface), FR58 | User (either population) signs in via mock-auth → `ctam-authorisation` resolves identity/roles/jurisdiction → role-scoped Home renders |
| 0.5 | 2 stories (0.5.1–0.5.2) | FR6 (tier b + JOH tier-a read API), FR7, FR58 | Jurisdiction-filtered Reference Data API serves JOH + tier-(b) data read-only |
| 0.6 | 1 story (0.6.1) | FR6 (MRD tier-a read API), FR7, FR58 | Jurisdiction-filtered Reference Data API serves MRD Specialisations read-only, on its own resource group |
| 0.7 | 1 story (0.7.1) | FR1 (lookup data), FR4 (data layer), FR57 (flag bootstrap) | Seeded users across both populations verified against the IdP; Epic 0.4 sign-in works against them |
| 0.8 | 2 stories (0.8.1–0.8.2) | FR9 | `POST /v1/notifications/send` works end-to-end via Postman against Mailpit |
| **Total** | **27 stories** | | The eleven demos chain together for the Phase 0 stakeholder walkthrough — starting with the scaffolding toolchain and the verified platform estate. The two [Phase 0-Mock](../phase-0-mock/index.md) demos slot in immediately before the ingestion epics that consume them (0M.1 → 0.2, 0M.2 → 0.3) |

**Cross-cutting NFRs verified across Phase 0 stories:** NFR10 (TLS), NFR11 (data-at-rest), NFR12 (JWT propagation), NFR13 (authz enforcement incl. jurisdiction), NFR14 (no forbidden data), NFR15 (change trails per runbooks + delivery log), NFR16 (Key Vault incl. eLinks credential), NFR17–NFR19 (business UI WCAG — admin UI deferred), NFR20 (HMCTS IdP integration via mock), NFR22 (HMCTS email), NFR24 (JOH eLinks + MRD MVP integrations), NFR25–NFR28 (observability), NFR31 (Azure UK South), NFR39 (API-as-Product — including the two upstream stand-ins, which publish versioned contracts like every other CTAM API), NFR40 (per-service deployable), NFR42 (Postman collections).

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

**Retirement path for the upstream stand-ins** is recorded in [Phase 0-Mock](../phase-0-mock/index.md): neither mock is retired at cutover. One post-MVP item belongs on this roadmap, though — a `ctam-mrd-mock` extension standing in for MRD's **public APIs** rather than the workbook drop, reserved for whenever those ship (the blob-drop seam is the documented upgrade point per AR47).

Not post-MVP (lands in a later MVP phase): **OAuth `client_credentials` flow** for batch / scheduled callers — Phase 6 alongside `ctam-payment-batch`. *(The eLinks sync and MRD pick-up need no service identity — they run in-process inside `ctam-reference-data`.)*

## Validation

- Phase 0 awaits validation via the **ET-cohort implementation-readiness assessment**[^d13]. *(The SSCS-cohort assessment becomes a wave-2 gate.)*

[^d3]: Revised D3 (2026-06-10) — no data migration from any legacy system; judicial-holder reference data is ingested from the JOH eLinks API and MRD.
[^d8]: D8 — rollout is jurisdiction-first, then per-region; jurisdiction is a first-class hierarchical attribute.
[^d9]: Restructured D9 (2026-06-10; refined 2026-07-09 per SCP) — two user populations. JOHs resolve IdP email → `jo_people` → `personnel_number` → a **CTAM-assigned JOH UUID** (`ctam_joh_identities`); HMCTS admin staff via a CTAM-internal identity table. Both key on a CTAM-assigned UUID; `personnel_number` is the upstream link only. No legacy user migration.
[^d10]: D10 (2026-05-15) — admin UI is post-MVP; MVP admin operations are DBA-via-SQL per operational runbooks.
[^d11]: D11 (2026-06-10, amended 2026-06-18; **superseded by D13 2026-08-07 for wave ordering**) — SSCS pilot wave: CTAM Pathfinder replaces **ListAssist** (the SSCS judicial-scheduling tool); **GAPS (SSCS case management) is retained, not replaced**. Per D13 the SSCS wave is **wave 2**.

[^d13]: D13 (2026-08-07, supersedes D11) — ET-first pilot: wave 1 = the **Employment Tribunals (ET)** jurisdiction (scheduling incumbent `[ET-INCUMBENT-TBD]` — unidentified, gap G8.4); wave 2 = **SSCS** (replaces **ListAssist**; **GAPS**, SSCS case management, is retained); waves 3+ = Courts jurisdictions per HMCTS judicial region (replacing JI/APEX).
