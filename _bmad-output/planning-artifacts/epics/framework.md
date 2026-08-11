---
type: 'Framework'
title: 'Phase × Area Framework'
description: 'CTAM Pathfinder is built in 10 sequential phases (0–9+) per the PRD''s Phase-by-Phase Journey Mapping and the architecture''s Repository Strategy:'
resource: 'epics/framework.html'
tags: [ctam-pathfinder, epics, sscs]
timestamp: '2026-06-11'
parent: 'epics/index.md'
purpose: 'Phase × Area architectural framework — the spine that organises concrete epics across 10 sequential phases'
---

# Phase × Area Framework

CTAM Pathfinder is built in **10 sequential phases (0–9+)** per the PRD's Phase-by-Phase Journey Mapping and the architecture's Repository Strategy:

- **Phase 0** is cross-cutting foundations (multiple parallel areas).
- **Phases 1–8** each deliver one service end-to-end (backend + UI module).
- **Phase 9+** is the jurisdiction-first wave rollout[^d8][^d11]: wave 1 = the **SSCS jurisdiction** (replacing ListAssist; GAPS case management retained); waves 2+ = Courts jurisdictions per-region (replacing APEX/JI).

The first level of grouping below is **Phase** (delivery sequence); the second level is **Area** (the capability or cross-cutting concern that anchors the epic). Within each Area, concrete epics with stories and Gherkin acceptance criteria live in the per-phase folders (e.g. [phase-0/](phase-0/index.md)).

## Epic Phase × Area Summary

| Phase | Area | Component(s) | Primary FR/NFR coverage |
|---|---|---|---|
| **0** | Platform & DevEx | `ctam-architecture` (scaffolding), GitHub Actions, APIM, AKS, Application Insights, shared `ctam_configuration_values` | FR8, FR58, FR59, NFR25–NFR28, NFR40, NFR42 |
| **0** | Identity & Authorisation | `ctam-mock-auth`, `ctam-authorisation` (two-population identity resolution; jurisdiction-aware) | FR1–FR4, FR57 *(flag surface)*, NFR12, NFR13 |
| **0** | Upstream Reference-Data Ingestion | `ctam-reference-data` in-process eLinks sync + MRD blob ingestion (tier (a): `jo_*`, `mrd_*`, `ctam_sync_status`) | FR6 *(tier a)*, FR7, NFR24 |
| **0** | Reference Data (tier (b) + read API) | `ctam-reference-data` (backend); maintenance UI post-MVP in `ctam-admin-ui`[^d10] | FR6, FR7 |
| **0** | Notification | `ctam-notification` | FR9, NFR22 |
| **0** | Identity Bootstrap & Verification | seed scripts + bootstrap-verification job + runbook (`ctam-architecture`) | FR1 *(data)*, FR4 *(data layer)*, FR57 *(initial flags)* |
| **0** | Business UI Foundation | `ctam-ui` (shell, auth, design system) | FR55 *(shell)*, FR56 *(stack)*, NFR17 |
| **0 → post-MVP** | Admin UI Foundation *(post-MVP[^d10])* | `ctam-admin-ui` (shell, auth, design system, tier-(b) Reference Data maintenance, User & Role admin) | FR4 *(UI surface)*, FR6 *(tier-(b) UI surface)*, FR56 *(stack)*, NFR17 |
| **1** | JOH Records & Working Patterns | `ctam-joh` + UI module | FR10–FR18 |
| **2** | Absence Workflow | `ctam-absence` + UI module | FR19–FR22 |
| **3** | Vacancy & Cover | `ctam-vacancy` + UI module | FR23–FR28 |
| **4** | Booking Management | `ctam-booking` + UI module | FR29–FR34 |
| **5** | Sitting Management | `ctam-sitting` + UI module | FR35–FR40 |
| **6** | Payment Processing & Reconciliation | `ctam-payment` + UI module | FR41 *(part)*, FR44, FR46, FR47, NFR21, NFR35 |
| **6** | Payment Batch | `ctam-payment-batch` (scheduled) | FR42, FR43, FR45 |
| **7** | Itineraries Read Model | `ctam-itinerary` *(no own tables)* + UI views | FR48–FR52, NFR8, NFR37 |
| **8** | MI Feed & Reporting | `ctam-mi-feed` *(no own tables)* + Reports UI module | FR53, FR54, NFR23 |
| **9+** | Wave Rollout (jurisdiction-first) | per-(jurisdiction, region) activation, incumbent-experienced manual UAT, rollback playbook, SSCS-cohort readiness gate | FR57 *(activation)*, FR60, NFR36, NFR38, NFR41 |

Cross-cutting NFRs (performance NFR1–NFR9, security/data NFR10–NFR16, NFR30–NFR33, accessibility NFR17–NFR19, maintainability NFR39) are inherited by every phase; their architectural support lives in Phase 0 (Platform & DevEx) and is exercised in every domain phase.

## Phase 0 — Foundations

> Phase 0 is the platform smoke-test (per PRD Key Characteristic 4). All API-as-Product standards (versioning, OpenAPI, [RFC 9457](https://datatracker.ietf.org/doc/html/rfc9457), `Deprecation`/`Sunset`) are exercised on Reference Data reads and Authorisation lookups before any domain service is built.
>
> The Areas below are the **architectural map**. The **implementation plan** is the four concrete user-value epics in [phase-0/](phase-0/index.md).

### Phase 0 · Area: Platform & DevEx

**Scope**: **Terraform provisioning of the Azure estate** (HMCTS standard, per AR53 revised — shared estate in the dedicated `ctam-shared-infrastructure` repo, provisioned in Epic 0.0; per-service resources in each service's `terraform/`). Service scaffolding (`ctam-scaffold.sh` over HMCTS Crime SpringBoot template, incl. the per-repo `terraform/` skeleton), per-service GitHub Actions pipeline (`ci.yml` + `deploy-{env}.yml` + per-region per-wave gated production deploy), OpenAPI/Spectral/ArchUnit/Spotless/Checkstyle tooling, structured Logback JSON logging conventions, OpenTelemetry → Application Insights wiring, shared `ctam_configuration_values` infrastructure table managed by `ctam-architecture` Liquibase baseline changelog, Azure API Management at the edge (rate limits, deprecation headers, `/actuator/*` restriction), AKS UK South multi-AZ HA, Helm chart conventions, Azure Key Vault integration.

**Component(s)**: `ctam-architecture` (scaffolding script + ADRs), GitHub Actions workflows, shared Liquibase baseline changelog, APIM policies, Helm chart conventions.

**Primary FR/NFR coverage**: FR8, FR58, FR59, NFR25–NFR28, NFR40, NFR42; underpins every AR1–AR52.

### Phase 0 · Area: Identity & Authorisation

**Scope**: `ctam-mock-auth` OIDC issuer for non-prod (human users via `authorization_code` across **both identity populations**; batch components via `client_credentials`; refuses production profile). `ctam-authorisation` service owning the **6 auth tables** (`ctam_auth_users`, `ctam_auth_staff_identities`, `ctam_auth_roles`, `ctam_auth_user_roles`, `ctam_auth_user_region_scopes`, `ctam_auth_user_activation_flags` keyed by (jurisdiction, region)). **Two-population identity resolution**[^d9]: IdP email → `jo_people` → `personnel_number` → CTAM JOH UUID in `ctam_joh_identities` (JOH users); IdP email → `ctam_auth_staff_identities` → CTAM-assigned UUID (admin staff). Custom `JWTFilter` pattern in every service that validates JWT against JWKS and calls `POST /authz/check` to populate request-scoped `AuthDetails` with canonical id + roles + **jurisdiction** + Region/Area scope + activation flag. Per-user activation flags (FR57) wired to enable jurisdiction-first phased cutover.

**Component(s)**: `ctam-mock-auth`, `ctam-authorisation`.

**Primary FR/NFR coverage**: FR1, FR2, FR3, FR4, FR57 *(flags wired here; wave activation orchestrated in Phase 9+)*; NFR12, NFR13, NFR16, NFR20. *(FR5 is post-MVP; out of scope here.)*

### Phase 0 · Area: Reference Data

**Scope**: `ctam-reference-data` service owning **all 32 reference-data tables across two ownership tiers** (FR6/FR7): **tier (a) upstream-sourced** — 15 `jo_*` JOH eLinks entities + `mrd_*` MRD entities + `ctam_sync_status`, written only by the ingestion mechanisms, read-only in CTAM, corrections at source; **tier (b) CTAM-owned** — `ctam_regions`, `ctam_offices`, `ctam_calendar_periods` + 12 operational vocabularies, DBA-maintained per runbook in MVP[^d10]. **Read-only, jurisdiction-filtered** versioned REST API over both tiers[^d8]. Per-service DB SELECT grants for direct-SQL reads (per FR7 / Principle 2). API-as-Product standards exercised here first (versioning, OpenAPI, [RFC 9457](https://datatracker.ietf.org/doc/html/rfc9457), deprecation signalling).

**Ingestion (in Epic 0.1's vertical slice — sign-in depends on `jo_people`)**: nightly in-process `@Scheduled` eLinks sync (full-refresh upsert on upstream natural keys; soft-deactivation, never hard-delete; run log in `ctam_sync_status`) + weekly MRD Excel via Azure Blob drop (validate / upsert / archive; idempotent per file; reader swaps for the MRD API post-MVP). Per AR46–AR49.

**Component(s)**: `ctam-reference-data` (backend incl. ingestion tasks). The tier-(b) maintenance UI (FR6) is post-MVP `ctam-admin-ui`[^d10].

**Primary FR/NFR coverage**: FR6, FR7, NFR24 *(JOH eLinks + MRD are MVP integrations)*; cross-references NFR39 (API-as-Product), AR18, AR20, AR22, AR46–AR49; gaps.md G8.

### Phase 0 · Area: Notification

**Scope**: `ctam-notification` service. Outbound transactional email dispatch to HMCTS email infrastructure (SMTP). Delivery log with retry on transient failure. Consumed in Phase 1+ for booking acks (FR32), absence acks (FR20), and the Phase 6 payment-schedule dispatch (FR43).

**Component(s)**: `ctam-notification`.

**Primary FR/NFR coverage**: FR9, NFR22.

### Phase 0 · Area: Identity Bootstrap & Verification

**Scope**: No legacy data migration of any kind exists[^d3]. Reference data arrives via the Upstream Reference-Data Ingestion area (Epic 0.1). User/authorisation data is strictly CTAM-internal, bootstrapped by programme-management mechanisms outside the PRD's scope. CTAM owns: dev/CI **seed scripts** spanning both identity populations; the re-runnable **bootstrap-verification job** confirming every `ctam_auth_users` row (both populations) maps to a real IdP principal (the standing wave-cutover gate artefact, also used at the pre-Phase-9 IdP cutover per G1.3); and the **production bootstrap runbook** (`ctam-architecture/runbooks/identity-bootstrap.md`), which also carries the FR4 DBA-maintenance pattern.

**Component(s)**: `ctam-architecture` (seed scripts, verification job, runbook). Not a runtime service.

**Primary FR/NFR coverage**: FR1 *(lookup data)*, FR4 *(MVP data-layer criterion)*, FR57 *(initial all-FALSE flags keyed by (jurisdiction, region))*; AR52.

### Phase 0 · Area: Business UI Foundation

**Scope**: `ctam-ui` repo scaffolded (React + TypeScript + Vite + Vitest + Playwright). GOV.UK Design System base + HMCTS/CTAM Pathfinder extensions. OIDC client wrapper (`HmctsIdpProvider`, `ProtectedRoute`, `useAuth`). HTTP client with auth header attachment and RFC 9457 error handling. Business-user Home shell with role-scoped navigation and Region/Area selector (FR55). axe-core CI for WCAG 2.2 AA gate. Per-phase E2E test suite scaffolding under `tests/e2e/`. **Excludes admin workflows** — tier-(b) Reference Data maintenance (FR6) and User & Role admin (FR4) live in `ctam-admin-ui` (itself post-MVP[^d10]), never here.

**Component(s)**: `ctam-ui` (shared + business Home shell only — per-domain modules land in their respective phases).

**Primary FR/NFR coverage**: FR55 *(business Home shell)*, FR56 *(modern UI stack)*, NFR17, NFR18, NFR19.

### Post-MVP · Area: Admin UI Foundation *(post-MVP)*

**Scope** *(post-MVP[^d10])*: `ctam-admin-ui` repo scaffolded with the **same stack as `ctam-ui`** (React + TypeScript + Vite + Vitest + Playwright; GOV.UK Design System base; OIDC client wrapper; RFC 9457 error handling) but **deployed independently** to its own Static Web App / CDN on a distinct hostname (e.g. `admin.ctam.hmcts.gov.uk`). Distinct accent in the header/nav to make the admin surface visually unambiguous.[^d10]

**Post-MVP admin modules (none built in MVP — in MVP these operations are DBA-via-SQL per runbook):**

- **Reference Data maintenance** (FR6, **tier (b) only** — tier (a) never gets a CTAM write surface) — list/edit/create flows for Regions, Offices, operational vocabularies, calendar / financial-year boundaries. Calls `ctam-reference-data` API (write endpoints also post-MVP).
- **User & Role admin** (FR4) — list and search users across both populations, edit role / jurisdiction / Region-Area scope assignments, view per-user effective permissions. Calls `ctam-authorisation` API (write endpoints also post-MVP).

**Further surfaces reserved as module placeholders only:**

- `modules/activation/` — per-(jurisdiction, region) activation flag dashboard (FR57 admin side)
- `modules/audit/` — post-MVP user-action audit viewer (D7 roadmap)

*(The previously-reserved `modules/migration-reports/` placeholder is retired — there is no migration to report on[^d3].)*

**Why a separate repo, not just a separate route inside `ctam-ui`:**

1. **Audience separation** — admin role is a system administrator, not RSU/Court/Judge/Finance/MI. Different mental model, different training, different way of managing change.
2. **Independent rollout** — admin surface changes (e.g. adding a new vocabulary table) can deploy without touching the business surface or vice versa.
3. **CODEOWNERS** — distinct review teams.
4. **No accidental nav-leakage** — admin-only screens cannot accidentally appear in a business user's navigation via misconfiguration. Authorisation gating is enforced server-side too, but the repo-level boundary is defence-in-depth.
5. **Consistency with backend polyrepo discipline** — same logic as the per-service backend repos: minimise shared code, accept duplication, gain independence.

**Component(s)**: `ctam-admin-ui` (post-MVP repo: shared + Reference Data tier-(b) module + User & Role module).

**Primary FR/NFR coverage**: FR4 *(UI surface)*, FR6 *(tier-(b) UI surface)*, FR56 *(stack)*, NFR17, NFR18, NFR19. Also AR42–AR45b. All post-MVP[^d10].

→ **Phase 0 concrete epics + stories:** [phase-0/](phase-0/index.md)

## Phase 1 — JOH

### Phase 1 · Area: JOH Records & Working Patterns

**Scope**: `ctam-joh` backend service + `joh/` UI module in `ctam-ui`. JOH profile **views** composing tier-(a) `jo_*` data with `ctam-joh`'s CTAM-owned overlays keyed by `joh_id` → `ctam_joh_identities` (FR10 search/filter; FR11 view — the upstream person record is `jo_people`, no profile CRUD in CTAM). Working Patterns (None / Daily / Weekly) with target sit %, jurisdictional split (100% sum constraint), per-day work-type pattern — CTAM-owned operational state. Forward-sitting generation up to next 31st March from working pattern, preserving prior absences. Ticket overlays layered over upstream `jo_tickets` (FR15). Full-time / part-time status **displayed from upstream** `jo_contract_types` — conversions happen upstream and arrive at the next sync (FR14). Same-Region base-location switching as CTAM-owned overlay (cross-Region is out-of-system). Off-circuit / cross-Region JOH linking for booking purposes (e.g. tribunal panels with members from other regions). Demo: Journey *(stakeholder per-module demo of JOH management)*.

**Component(s)**: `ctam-joh`, `ctam-ui/src/modules/joh/`.

**Primary FR/NFR coverage**: FR10, FR11, FR12, FR13, FR14, FR15, FR16, FR17, FR18.

## Phase 2 — Absence

### Phase 2 · Area: Absence Workflow

**Scope**: `ctam-absence` backend + `absence/` UI module. Absence recording (start/end date, partial-day, type from controlled list, NTBF flag). Auto-confirmed (judicial team) vs confirmation-required (Court / judge) distinction; confirmation can trigger acknowledgement email via Notification. Sickness extension (no new record) vs non-sickness (new record required). NTBF and *needs fee-paid cover* flags. Hook to Vacancy auto-creation (Vacancy itself lives in Phase 3 — Phase 2 stubs the call; Phase 3 wires it).

**Component(s)**: `ctam-absence`, `ctam-ui/src/modules/absence/`.

**Primary FR/NFR coverage**: FR19, FR20, FR21, FR22.

## Phase 3 — Vacancy

### Phase 3 · Area: Vacancy & Cover

**Scope**: `ctam-vacancy` backend + `vacancy/` UI module. Auto-creation from approved absence with cover (R4, pre-populated with JOH type, work type, ticket, dates). Standalone vacancies. Per-day breakdown editing (cancel individual days with captured reason; extend / shorten period). `markFilled` endpoint called by Booking (Phase 4) — implemented as a direct DB UPDATE per architecture Principle 1 with explicit cross-service grants. Vacancy days locked once a booking is recorded. Fee-paid JOH filter as advertising hint (advertising itself is out-of-system; allocation decisions are recorded in CTAM by admin staff[^d12]). Cancel / close.

**Component(s)**: `ctam-vacancy`, `ctam-ui/src/modules/vacancy/`.

**Primary FR/NFR coverage**: FR23, FR24, FR25, FR26, FR27, FR28.

## Phase 4 — Booking

### Phase 4 · Area: Booking Management

**Scope**: `ctam-booking` backend + `booking/` UI module. Fee-paid booking creation (linked to vacancy or standalone), capturing JOH (by `joh_id` → `ctam_joh_identities`), court / tribunal, date, session type, booking type, work type. Same-transaction `Vacancy.markFilled` orchestration (R5, Principle 1 — in-process direct DB UPDATE via per-service grant). Status tracking (planned / provisional / confirmed / cancelled / rejected) with cancellation reason. Booking acknowledgement emails to fee-paid JOHs (batched overnight or *Create and Email Now*). Y/N answer at booking time when a JOH's fee entitlement is *Ask when booking*. Double-booking prevention via DB unique constraints over overlapping sessions (FR34).

**Component(s)**: `ctam-booking`, `ctam-ui/src/modules/booking/`.

**Primary FR/NFR coverage**: FR29, FR30, FR31, FR32, FR33, FR34.

## Phase 5 — Sitting

### Phase 5 · Area: Sitting Management

**Scope**: `ctam-sitting` backend + `sitting/` UI module. Planned-sitting generation from working patterns (court, date, work type). Region/Office/JOH-type/JOH/date-range filtering. Confirmation (took-place / cancelled / rejected) with actual work-type recording. AM/PM session split within a single day (different work types). Ad-hoc sittings for salaried JOHs (including DJ(MC)s and Legal Advisers in County Courts — Courts-cohort-specific examples). Verifier sign-off; once verified, data is read-only. Post-verification amendment via a UI **re-open** action gated by RBAC (RSU Admin only at MVP, distinct from confirmer and from standard Verifier) with mandatory justification and full audit — no external RFC ticketing.

**Component(s)**: `ctam-sitting`, `ctam-ui/src/modules/sitting/`.

**Primary FR/NFR coverage**: FR35, FR36, FR37, FR38, FR39, FR40.

> **End-of-Phase-5 demo gate**: Journey 3 (Court daily sitting confirmation) becomes demoable.

## Phase 6 — Payment

### Phase 6 · Area: Payment Processing & Reconciliation

**Scope**: `ctam-payment` synchronous backend + `payment/` UI module. Authorised users list confirmed bookings and salaried sittings filterable by Region/Office/judge/date range/lifecycle status. Generated schedule review (pre/post dispatch). Reconciliation marking (Finance / RSU) with notes for mismatches; once fully reconciled, payment cannot be re-requested. Versioned content-type API for the payment schedule (`application/vnd.hmcts.jfeps+json` vs `+xlsx`). Hard architectural constraints: **no bank details** (FR47), **no case-level data**.

**Component(s)**: `ctam-payment` (sync API), `ctam-ui/src/modules/payment/`.

**Primary FR/NFR coverage**: FR41 *(list/review surface)*, FR44, FR46, FR47, NFR21, NFR35.

### Phase 6 · Area: Payment Batch

**Scope**: `ctam-payment-batch` scheduled component (configurable cron; typically end-of-week). Authenticates via OAuth `client_credentials` against `ctam-mock-auth` (non-prod) — production service-principal issuer deferred per gaps.md G7.1 (default recommendation: Azure Workload Identity). SQL JOIN over confirmed bookings + sittings without an existing payment record. Generates JFEPS-compatible Excel and dispatches to Payment Authoriser via `ctam-notification` (using its service-principal token). Natural-key uniqueness on `(payment_cycle_id, booking_id)` for idempotent re-runs. No user interaction. Operational contingency to fall back to manual handling within a payment cycle if CTAM Pathfinder is unavailable.

**Component(s)**: `ctam-payment-batch` (deployed alongside `ctam-payment`).

**Primary FR/NFR coverage**: FR42, FR43, FR45.

> **End-of-Phase-6 demo gate**: Journey 2 (RSU cover-creation through payment — the canonical Courts operational cycle) and Journey 1 (SSCS Tribunal Caseworker panel coverage — same service chain with SSCS roles) become demoable.

## Phase 7 — Itineraries

### Phase 7 · Area: Itineraries Read Model

**Scope**: `ctam-itinerary` backend + Itinerary UI views in `ctam-ui`. **No own tables** — SQL JOINs across `jo_people` (+ `ctam-joh` operational-state tables), `ctam_absences`, `ctam_vacancies`, `ctam_bookings`, `ctam_sittings`. Court Itinerary (monthly / annual for Office + Financial Year + Month). Judge Itinerary scoped by Authorisation per R2 (judges see only their own; courts see their office; RSU sees their region). Forward Look across Region with paged / filtered access. Clickable drill into underlying record (Sitting, Absence, Vacancy, Booking). Copy / export to Excel and PDF. Strategy A degraded-mode contract: if NFR8 (≤ 30 s p95) is breached, fall back to Strategy C cached projection (designed but not built unless Phase 7 measurement shows the breach).

**Component(s)**: `ctam-itinerary`, `ctam-ui/src/modules/itinerary/`.

**Primary FR/NFR coverage**: FR48, FR49, FR50, FR51, FR52, NFR8, NFR37.

> **End-of-Phase-7 demo gate**: Journey 4 (Judge views itinerary) becomes demoable.

## Phase 8 — MI Feed & Reporting

### Phase 8 · Area: MI Feed & Reporting

**Scope**: `ctam-mi-feed` backend + Reports UI module in `ctam-ui`. **No own tables** — SQL JOINs over the shared schema. Fixed catalogue of standard Reports (weekly sitting projections, weekly vacancies, absence analysis, vacancy by court, confirmed sittings/bookings by judge or judge type, judge utilisation, jurisdictional split, summary by court / work type) with parameter filters per report and same parameter shape as APEX. MI Feed REST API for external consumers (DA&I post-MVP, future programmes; external case-management systems consume CTAM's APIs from Phase 9[^d12] — read-only, no reverse write). **Aggregate-only by contract** (FR54, NFR23) — no case-level data in any read model or report under any consumer authorisation.

**Component(s)**: `ctam-mi-feed`, `ctam-ui/src/modules/reports/`.

**Primary FR/NFR coverage**: FR53, FR54, NFR23.

> **End-of-Phase-8 demo gate**: Journey 5 (DA&I MI Feed API consumer) becomes demoable post-MVP onboarding.

## Phase 9+ — Wave Rollout (jurisdiction-first)

### Phase 9+ · Area: Wave Rollout

**Scope**: Jurisdiction-first phased activation — **wave 1 = the SSCS jurisdiction** (replacing ListAssist; GAPS case management retained; all in-jurisdiction applicable roles in one wave); **waves 2+ = Courts jurisdictions per-region** (replacing APEX/JI). Activation flips `ctam_auth_user_activation_flags` per (jurisdiction, region) tuple (FR57) via DBA SQL per the rollout runbook once that wave's feature-parity gate is passed. Manual UAT execution per role per wave (FR60): **jurisdiction-incumbent-experienced users** — ListAssist-experienced (RTJ, Tribunal Judges, Tribunal Members, Caseworkers, Finance, MI) for wave 1; APEX-experienced (RSU, Court, Judge, Judges' Clerks, Finance/Payment Authoriser, MI) for waves 2+ — walk per-service UAT scripts (under `docs/uat/` in each domain service repo) side-by-side against the incumbent; sign-off per role per wave is the wave-cutover gate. **Wave-1 additional gates**[^d11]: the SSCS-cohort implementation-readiness assessment signed off; the SSCS as-is analysis pack complete. Data-readiness gate per wave: reference data current per `ctam_sync_status` + the bootstrap-verification job passing for the wave's users (Epic 0.4). Per-wave rollback playbook (NFR36): documented path returning the wave to its incumbent within one operational cycle if the gate is breached post-cutover. Cross-region manual coordination during partial rollout (Risk #1 mitigation; operational, not application-level). Wave 1 is the Pilot; subsequent waves run until all jurisdictions are on CTAM Pathfinder and the incumbents are retired[^d8][^d11].

**Component(s)**: Programme-level (manual UAT scripts, runbooks, activation orchestration). Cross-region edge case (Journey 6) handled out-of-system per Risk #1 — no application capability built.

**Primary FR/NFR coverage**: FR57 *(activation orchestration)*, FR60, NFR36, NFR38, NFR41. Closes the MVP.

[^d3]: Revised D3 (2026-06-10) — no data migration from any legacy system; judicial-holder reference data is ingested from the JOH eLinks API and MRD.
[^d8]: D8 — rollout is jurisdiction-first, then per-region; jurisdiction is a first-class hierarchical attribute.
[^d9]: Restructured D9 (2026-06-10; refined 2026-07-09 per SCP) — two user populations. JOHs resolve IdP email → `jo_people` → `personnel_number` → a **CTAM-assigned JOH UUID** (`ctam_joh_identities`); HMCTS admin staff via a CTAM-internal identity table. Both key on a CTAM-assigned UUID; `personnel_number` is the upstream link only. No legacy user migration.
[^d10]: D10 (2026-05-15) — admin UI is post-MVP; MVP admin operations are DBA-via-SQL per operational runbooks.
[^d11]: D11 (2026-06-10, amended 2026-06-18) — SSCS-first pilot: wave 1 replaces **ListAssist** (the SSCS judicial-scheduling tool); **GAPS (SSCS case management) is retained, not replaced**; waves 2+ replace JI/APEX per Courts region.
[^d12]: D12 (2026-06-10) — CTAM is the system of record for JOH availability and scheduling only; case and hearing management live in external systems.
