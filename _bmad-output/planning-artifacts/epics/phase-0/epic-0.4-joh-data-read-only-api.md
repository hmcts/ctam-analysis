---
type: 'Epic'
description: "User outcome: Tier-(b) CTAM-owned reference data (Regions, Offices, calendar / financial-year boundaries, operational vocabularies) exists, is seeded, and is maintainable by DBAs via direct SQL per…; JOH data (tier-(a) + tier-(b)) is served read-only, open (no auth in Phase 0 scope)."
resource: 'epics/phase-0/epic-0.4-joh-data-read-only-api.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-25'
parent: 'epics/phase-0/index.md'
epic: 0.4
title: 'JOH data is served read-only via a versioned API'
storyCount: 2
repo: ctam-reference-data
depends_on: [epic-0.3]
---

# Epic 0.4: JOH data is served read-only via a versioned API

> **Split note** *(SCP 2026-08-25c)*: this epic was "Reference data is served read-only via a versioned, jurisdiction-filtered API" — retitled and narrowed to **JOH data** (tier-(a) JOH eLinks data + tier-(b) CTAM-owned vocab, which it always covered). MRD-sourced data (`mrd_specialisms`) was briefly split into its own Epic 0.10; that epic — along with MRD ingestion, auth, notification, and user bootstrap — was **removed from Phase 0 scope entirely** (SCP 2026-08-25d). *(Also renumbered from 0.9 to 0.4 via SCP 2026-08-25c.)*

> **Scope reduction — auth removed** *(SCP 2026-08-25d)*: the epic this API depended on for `JWTFilter` and jurisdiction resolution (formerly Epic 0.7, User authenticates) is **removed from Phase 0**. This epic's endpoints are therefore **open / unauthenticated and unfiltered by jurisdiction** for now — every consumer sees all rows. Auth-protection and jurisdiction-filtering are deferred until an auth epic re-enters the plan; re-adding them is additive (a `JWTFilter` + a jurisdiction predicate on each query), not a redesign.

**User outcome:** Tier-(b) CTAM-owned reference data (Regions, Offices, calendar / financial-year boundaries, operational vocabularies) exists, is seeded, and is maintainable by DBAs via direct SQL per operational runbook[^d10]. **JOH data** — both the upstream-sourced tier-(a) tables ingested in Epic 0.3 and the tier-(b) tables created here — is queryable read-only via `ctam-reference-data`'s versioned REST API. **No admin UI is in scope for MVP**; tier-(a) data is never hand-edited in CTAM in any phase (corrections at source per FR6).

**Vertical slice:**
- Tier-(b) CTAM-owned tables (15: `ctam_regions`, `ctam_offices`, `ctam_calendar_periods` + 12 operational vocabularies incl. `ctam_joh_types`, `ctam_joh_fee_entitlements`) with service-owned Liquibase changelogs (per AR18–AR20) — the `ctam-reference-data` service itself was scaffolded in Story 0.3.1
- Tier-(b) seed data via a Liquibase seed changeset + the DBA maintenance runbook (D10 operating model)
- Per-service `SELECT` grants pattern completed for direct-SQL reads across both tiers (per FR7 / Principle 2)
- JOH data **read-only** REST API: `GET` endpoints over tier-(a) JOH data + tier-(b) vocab, for consumption by downstream services and OpenAPI clients. **No `POST`/`PUT`/`DELETE` endpoints** — tier (a) is written only by the Epic 0.3 ingestion mechanisms; tier (b) by DBAs via SQL per runbook
- First end-to-end exercise of API-as-Product **read-side** standards: URL versioning (`/v1/reference-data/...`), OpenAPI 3.x spec published (by Gradle `maven-publish`) as a Maven-format artefact, RFC 9457 problem-details errors, RFC 9745 `Deprecation` + RFC 8594 `Sunset` deprecation signalling (FR58)
- First Postman collection for Phase 0 published under `postman/ctam-reference-data-phase0.postman_collection.json` (NFR42 first instance)

**FRs covered:** FR6 (tier-(b) maintenance per runbook; JOH read API over both tiers), FR7 (direct-SQL read pattern + writes-follow-the-tier), FR58 (versioned read API contract), FR59 (structured logs)

**FRs partially covered / deferred:**
- **FR6 tier-(b) maintenance UI** — post-MVP `ctam-admin-ui`[^d10]; MVP maintenance is DBA-via-SQL per runbook
- **FR2 (jurisdiction/Region-Area scoping on responses)** — deferred with auth removal (SCP 2026-08-25d); not implemented while there is no authorisation context to scope by
- **FR4** — admin UI for role / jurisdiction / Region-Area assignment updates is post-MVP

**Key NFRs:** NFR14 (no forbidden data — vocabularies contain no case/bank data by construction), NFR40 (service independently deployable), NFR42 (Postman collection). **NFR12, NFR13 (JWT propagation, authz enforcement) do not apply in Phase 0** — no auth epic exists in scope; endpoints are open. **NFR17–NFR19 (accessibility) do not apply in Phase 0** because no UI surface for this domain is delivered.

**Out of scope for Phase 0 (deferred post-MVP, or removed from scope):**
- Admin-gated `POST/PUT/DELETE` endpoints on the read API (tier (b) only — tier (a) never gets a CTAM write surface)
- `ctam-admin-ui` Reference Data maintenance module
- Auth protection and jurisdiction filtering on the read API — removed with the auth epic (SCP 2026-08-25d); re-added if/when an auth epic returns
- MRD-sourced data (`mrd_specialisms`) read endpoints — removed from Phase 0 scope (SCP 2026-08-25d; was briefly Epic 0.10)
- *(There is no legacy-data ETL and no git-based sign-off workflow — revised D3. Upstream data arrives via Epic 0.3's ingestion mechanisms.)*

---

## Story 0.4.1: Tier-(b) CTAM-owned reference tables, seed data, and the DBA maintenance runbook

As a **platform engineer** (and the DBAs who operate reference data in MVP),
I want the 15 tier-(b) CTAM-owned reference tables created, seeded, and covered by an operational maintenance runbook,
So that **CTAM-owned reference data that does not exist upstream (Regions, Offices, calendar boundaries, operational vocabularies) is available to every service and maintainable[^d10] operating model** — never overwritten by the upstream sync.

**Acceptance Criteria:**

**Given** `ctam-reference-data` is scaffolded and carries the tier-(a) tables per Story 0.3.3,
**When** the engineer adds the Liquibase changeset `db/changelog/003-init-tier-b-ctam-owned-tables.sql`,
**Then** the 15 tier-(b) tables exist with schemas per `architecture/data-tables.md`: `ctam_regions`, `ctam_offices`, `ctam_calendar_periods`, plus the 12 operational vocabularies (`ctam_joh_types`, `ctam_work_types`, `ctam_court_types`, `ctam_ticket_types`, `ctam_session_types`, `ctam_absence_types`, `ctam_working_pattern_types`, `ctam_booking_statuses`, `ctam_sitting_outcomes`, `ctam_joh_fee_entitlements`, `ctam_payment_lifecycle_statuses`, `ctam_reconciliation_statuses`),
**And** the `ctam_reference_data` DB role owns the tables (per AR19),
**And** SELECT grants exist for every current and placeholder service DB role (per FR7, AR22),
**And** the ArchUnit/grants fitness function verifies ownership and that the upstream sync code paths **cannot write tier-(b) tables** (tier separation per FR6 — CTAM-owned data is never overwritten by sync),
**And** the three upstream-overlap candidates (`ctam_joh_types`, `ctam_court_types`, `ctam_ticket_types`) carry a schema comment referencing gaps.md G8.2 (each may retire in favour of its `jo_*` counterpart once the eLinks contract is confirmed).

**Given** the engineer adds the Liquibase seed changeset for tier-(b) data,
**When** Liquibase applies it,
**Then** `ctam_regions`, `ctam_offices`, `ctam_calendar_periods`, and all 12 vocabularies are populated with the documented controlled-list values (cross-referenced to the architecture's data-tables inventory),
**And** the seed values include the ET wave-1-relevant entries (e.g. session and work types applicable to Employment Tribunal sittings) flagged for confirmation against the **ET as-is pack** (gap G8.5)[^d13],
**And** dev/CI environments get the same seed via the standard Liquibase changelog path (no separate seeding mechanism for tier (b)).

**Given** the DBA maintenance runbook is written at `ctam-architecture/runbooks/reference-data-maintenance.md`,
**When** a tier-(b) change is needed in MVP (e.g. a new office, a vocabulary value),
**Then** the runbook documents: the change request trail (who asked, why), the SQL pattern per table, the verification query, and the rollback statement,
**And** the runbook states explicitly that tier-(a) `jo_*` tables are **never** hand-edited — corrections happen at source (Judicial Office) and arrive via the next sync (FR6),
**And** the runbook is referenced from the service README.

**References:** FR6 (tier (b)), FR7, FR59; NFR14, NFR40; AR18–AR20, AR22, AR49; D10, D11; gaps.md G8.2.

**Explicitly NOT in scope (deferred post-MVP):**
- RSU-facing maintenance UI in `ctam-admin-ui`[^d10]
- Write API endpoints for tier (b)

---

## Story 0.4.2: JOH data read-only REST API with versioning, OpenAPI, RFC 9457 errors

As an **API consumer** (downstream services in Phase 1+; external case-management systems from Phase 9[^d12]),
I want a versioned **read-only** API over JOH data (both ownership tiers) with a full OpenAPI spec, RFC 9457 error envelopes, and APIM-injected deprecation headers,
So that **Phase 1+ services can query controlled lists and JOH reference data at runtime**, and the API-as-Product read-side standards are validated on Reference Data before any domain service is built (per PRD Key Characteristic 4 / D1).

**Acceptance Criteria:**

**Given** `ctam-reference-data` carries both tiers (tier (a) per Story 0.3.3; tier (b) per Story 0.4.1),
**When** the engineer implements read endpoints,
**Then** `GET /v1/reference-data/regions`, `/offices`, `/calendar`, `/vocabularies/{list}` (tier b) and `GET /v1/reference-data/johs`, `/jurisdictions`, `/tickets` (tier a, composing `jo_*` data) return `200 OK` with structured JSON,
**And** the endpoints are **open — no authentication or authorisation check** (no auth epic exists in Phase 0 scope; see this epic's scope-reduction note) — every caller sees every row, unfiltered by jurisdiction,
**And** the API does not blend tier lineage — each resource documents which tier it serves (FR6),
**And** **no write endpoints** (`POST`, `PUT`, `PATCH`, `DELETE`) are implemented — controller layer rejects with `405 Method Not Allowed` and an RFC 9457 problem-details body explaining the tier-appropriate write path (tier (a): corrections at source; tier (b): DBA runbook in MVP),
**And** OpenAPI spec generated by springdoc lists all read endpoints with full request/response schemas.

**Given** the engineer implements pagination + filtering,
**When** a consumer queries `GET /v1/reference-data/offices?region=northern&page=2&size=50`,
**Then** the response includes paginated data with a standard envelope `{items, page, size, totalElements, totalPages}`,
**And** invalid query parameters return `400 Bad Request` with RFC 9457 problem-details (per AR37, NFR39).

**Given** the OpenAPI spec is generated and Spectral lint runs in CI,
**When** the spec is built,
**Then** the spec passes Spectral lint (per AR17),
**And** the spec is published by Gradle (`maven-publish`) to the internal Maven-format artefact repository as `uk.gov.hmcts.ctam:api-ctam-reference-data:1.0.0` (per AR8),
**And** Swagger UI is exposed for developer browsing (ops-restricted at APIM).

**Given** APIM is configured for `ctam-reference-data` per AR27 + AR39,
**When** a response leaves APIM to the client,
**Then** rate-limit headers are present per APIM policy,
**And** `Deprecation` (RFC 9745) and `Sunset` (RFC 8594) headers are injected on endpoints flagged in the OpenAPI spec as `deprecated: true` (none at Phase 0; mechanism verified by a test endpoint),
**And** `/actuator/*` paths are blocked at APIM (per AR33).

**Given** the engineer publishes the first Phase 0 Postman collection,
**When** the collection runs in CI,
**Then** `postman/ctam-reference-data-phase0.postman_collection.json` exercises every JOH read endpoint across both tiers,
**And** the collection covers happy path + 400 (invalid query) + 405 (write attempt) (per NFR42) — no 401 case, since the API is open in this scope,
**And** the collection is versioned alongside the service.

**References:** FR6 (read surface over both tiers), FR7, FR58, FR59; NFR14, NFR39, NFR42; AR8, AR17, AR27, AR33, AR34, AR37, AR38, AR39, AR41; D12.

**Explicitly NOT in scope (deferred post-MVP, or removed from scope):**
- Admin write endpoints (`POST/PUT/PATCH/DELETE`) for tier (b)
- Any write surface for tier (a) (never, in any phase)
- Auth protection and jurisdiction filtering — removed with the auth epic (SCP 2026-08-25d)
- MRD-sourced data (`mrd_specialisms`) read endpoints — removed from Phase 0 scope (SCP 2026-08-25d)

[^d10]: D10 (2026-05-15) — admin UI is post-MVP; MVP admin operations are DBA-via-SQL per operational runbooks.
[^d11]: D11 (2026-06-10, amended 2026-06-18; **superseded by D13 2026-08-07 for wave ordering**) — SSCS pilot wave: CTAM Pathfinder replaces **ListAssist** (the SSCS judicial-scheduling tool); **GAPS (SSCS case management) is retained, not replaced**. Per D13 the SSCS wave is **wave 2**.

[^d13]: D13 (2026-08-07, supersedes D11) — ET-first pilot: wave 1 = the **Employment Tribunals (ET)** jurisdiction (scheduling incumbent `[ET-INCUMBENT-TBD]` — unidentified, gap G8.4); wave 2 = **SSCS** (replaces **ListAssist**; **GAPS**, SSCS case management, is retained); waves 3+ = Courts jurisdictions per HMCTS judicial region (replacing JI/APEX).
[^d12]: D12 (2026-06-10) — CTAM is the system of record for JOH availability and scheduling only; case and hearing management live in external systems.
