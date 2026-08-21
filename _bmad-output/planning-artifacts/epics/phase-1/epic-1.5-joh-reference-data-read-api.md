---
type: 'Epic'
description: "CTAM's own reference data (regions, offices, calendar and financial-year boundaries, and the standard operational vocabularies used across the programme) is created, pre-populated with real values, and kept up to date by database administrators following a written runbook. Together with the judge and tribunal-member data already brought in from the JOH data source, all of it can be looked up, read-only, through a single versioned API that automatically filters what each caller sees to their own jurisdiction. Reference data sourced from the separate MRD feed is covered by its own piece of work."
resource: 'epics/phase-1/epic-1.5-joh-reference-data-read-api.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-06-17'
parent: 'epics/phase-1/index.md'
epic: 1.5
title: 'JOH and CTAM-owned reference data is served read-only via a versioned, jurisdiction-filtered API'
storyCount: 2
repo: ctam-reference-data
depends_on: [epic-1.1, epic-1.2, epic-1.4]  # the read API needs the reference-data service, the JOH data sync, and jurisdiction-aware authentication to exist first
---

# Epic 1.5: JOH and CTAM-owned reference data is served read-only via a versioned, jurisdiction-filtered API

> This piece of work originally covered all reference data read access. It was later narrowed to just the data CTAM owns outright and the judge/tribunal-member data from the JOH data source; the separate MRD-sourced lookup (JOH Specialisations) was split out into its own piece of work, [Epic 1.6](epic-1.6-mrd-reference-data-read-api.md), which builds on top of the API published here.

**Business Goal:** Every service in the CTAM Pathfinder programme needs one trustworthy place to look up shared reference information — which regions and offices exist, what the current court calendar looks like, and the standard lists (roles, ticket types, session types, and so on) used throughout the system — as well as the judge and tribunal-member data already brought in from the JOH data source. Building a single, well-governed, read-only API for all of this now means every feature built afterwards can rely on consistent, jurisdiction-appropriate data instead of each team re-inventing its own lookup logic. It also lets the programme prove out its approach to building APIs — how they're versioned, how errors are reported, how an endpoint gets retired — on a low-risk, read-only surface before those standards are relied on by higher-stakes features.

**What this covers:** This is two related pieces of work. The first is creating and populating the reference tables that CTAM owns outright — the ones that don't come from any upstream system at all, such as regions, offices, and calendar boundaries — and writing down exactly how database administrators keep them up to date day to day. The second is building the read-only API that exposes both that CTAM-owned data and the judge/tribunal-member data already synced in from the JOH data source, filtered so each caller only sees the entries relevant to their own jurisdiction, and built to the programme's emerging standards for how an API should look, version itself, and report errors.

**Outcome:** CTAM's own reference data — regions, offices, calendar and financial-year boundaries, and the standard operational vocabularies used across the programme — exists, is pre-populated with real values, and is kept up to date by database administrators following a written runbook. Together with the judge and tribunal-member data already brought in from the JOH data source by the earlier data-sync work, all of this becomes queryable, read-only, through a single versioned API on `ctam-reference-data`, with every response automatically filtered to the requester's jurisdiction. There is no admin screen for managing this data in this phase, and the judge and tribunal-member data is never edited by hand inside CTAM in any phase — corrections happen at the original source system and flow through automatically on the next sync.

**What's included:**
- The 15 reference tables CTAM owns outright (`ctam_regions`, `ctam_offices`, `ctam_calendar_periods`, plus 12 operational vocabulary tables including `ctam_joh_types` and `ctam_joh_fee_entitlements`), added through the `ctam-reference-data` service's own database change scripts — the service itself was already set up in an earlier piece of work
- Seed data for those tables, loaded through the same database change-script mechanism, plus a written runbook for database administrators covering how to make a change to this data
- The standard pattern of giving every service read-only database access to the reference tables it needs, completed for direct SQL reads
- A read-only reference data API — `GET` endpoints over both the CTAM-owned data and the judge/tribunal-member data from the JOH data source — with every response filtered to show only the entries relevant to the caller's jurisdiction, for use by the CTAM user interface, other CTAM services, and any client generated from its published API specification. There are deliberately no endpoints to create, update, or delete data through this API: the judge/tribunal-member data is only ever written by the automated data sync, and the CTAM-owned data is only ever changed by database administrators following the runbook
- The programme's first full run-through of its standards for read-only APIs: web addresses that carry a version number (`/v1/reference-data/...`), a published machine-readable API specification, error responses in a standard "problem details" format, and standard signals for marking an endpoint as being phased out (`Deprecation` and `Sunset` response headers)
- The programme's first Postman collection, published at `postman/ctam-reference-data-phase0.postman_collection.json`, for automated end-to-end checks of the API

**Key expectations:**
- The controlled vocabulary tables contain no case or financial data by design, since they're built entirely from a fixed, agreed list of values
- The service can be deployed on its own, independently of every other CTAM service
- A Postman collection exists so the API's behaviour is checked automatically, every time
- Since no user interface is being built for this data in this phase, accessibility standards for screens don't apply yet — they come back into play once a maintenance screen is built after MVP

**Explicitly out of scope (deferred post-MVP or to another piece of work):**
- A maintenance screen for RSU staff to manage the CTAM-owned data, and an admin screen for managing role, jurisdiction, and region-area assignments — both are planned for the admin user interface after MVP; until then, everything is managed by database administrators via direct SQL, following the runbook
- The reference data endpoint sourced from the separate MRD feed (JOH Specialisations) — that's a later piece of work that builds on top of the API published here rather than standing up its own
- Any endpoints to create, update, or delete the CTAM-owned data through the API
- A reference-data maintenance module in the admin user interface
- There is no legacy-data migration and no git-based sign-off workflow for this data — the judge and tribunal-member data arrives entirely through the earlier data-sync work's own ingestion mechanism

---

## Story 1.5.1: Tier-(b) CTAM-owned reference tables, seed data, and the DBA maintenance runbook

As a **platform engineer** (and the database administrators who look after reference data during MVP),
I want the 15 CTAM-owned reference tables created, pre-populated with data, and covered by a written maintenance runbook,
So that **reference data CTAM owns outright — because it doesn't come from any upstream system, like regions, offices, and calendar boundaries — is available to every service and can be kept up to date safely, without ever being overwritten by the upstream data sync**.

**Acceptance Criteria:**

**Given** `ctam-reference-data` has already been set up and carries the judge/tribunal-member tables from an earlier piece of work,
**When** the engineer adds the database change script that creates the CTAM-owned tables,
**Then** the 15 tables exist with the schemas documented in the architecture's data-tables reference: `ctam_regions`, `ctam_offices`, `ctam_calendar_periods`, plus the 12 operational vocabulary tables (`ctam_joh_types`, `ctam_work_types`, `ctam_court_types`, `ctam_ticket_types`, `ctam_session_types`, `ctam_absence_types`, `ctam_working_pattern_types`, `ctam_booking_statuses`, `ctam_sitting_outcomes`, `ctam_joh_fee_entitlements`, `ctam_payment_lifecycle_statuses`, `ctam_reconciliation_statuses`),
**And** the `ctam_reference_data` database role owns these tables,
**And** every current and planned service has been granted read-only (SELECT) access to them,
**And** an automated check confirms both that the tables are owned correctly and that the upstream data-sync code path cannot write to any of these tables, keeping CTAM-owned data and synced data cleanly separated,
**And** the three tables that currently overlap with the JOH data source (`ctam_joh_types`, `ctam_court_types`, `ctam_ticket_types`) carry a note in their schema explaining that each may be retired in favour of its JOH-sourced equivalent, once the JOH data source's contract is fully confirmed.

**Given** the engineer adds the database change script that seeds the CTAM-owned data,
**When** that change script runs,
**Then** `ctam_regions`, `ctam_offices`, `ctam_calendar_periods`, and all 12 vocabulary tables are populated with the documented, agreed values, matching the architecture's data-tables reference,
**And** the seeded values include the entries expected to matter for the Employment Tribunals wave-1 rollout (for example, the session and work types used in Employment Tribunal sittings), flagged as needing confirmation once the detailed Employment Tribunals as-is analysis is complete,
**And** development and CI environments get exactly the same seed data through the same standard change-script mechanism — there is no separate way of seeding this data for testing.

**Given** the DBA maintenance runbook is written and published in the architecture repository,
**When** a change to the CTAM-owned data is needed during MVP (for example, adding a new office or a new vocabulary value),
**Then** the runbook documents who needs to request the change and why, the SQL pattern to use for that table, how to verify the change worked, and how to undo it if needed,
**And** the runbook states clearly that the judge and tribunal-member data is never hand-edited inside CTAM — corrections happen at the original source and arrive automatically on the next sync,
**And** the runbook is linked from the service's own README.

**Explicitly NOT in scope (deferred post-MVP):**
- A maintenance screen for RSU staff, planned for the admin user interface after MVP
- Any API endpoints for writing to the CTAM-owned data

---

## Story 1.5.2: Reference Data read-only REST API with jurisdiction filtering, versioning, OpenAPI, RFC 9457 errors

As an **API consumer** (the CTAM user interface today; other CTAM services from Phase 1 onward; and, eventually, the external case-management systems that will start drawing on CTAM data once it manages more than judge availability and scheduling),
I want a versioned, **read-only** reference data API over both the CTAM-owned data and the judge/tribunal-member data from the JOH data source, with responses filtered to the caller's own jurisdiction, a full published API specification, standard "problem details" error responses, and automatic warnings when an endpoint is being phased out,
So that **every service built from this point on can look up controlled lists and judge/tribunal-member reference data at runtime, scoped to the jurisdiction the caller is working in, and the programme's approach to building read-only APIs is proven out on this low-risk service before it's relied on anywhere else**.

**Acceptance Criteria:**

**Given** `ctam-reference-data` carries both the CTAM-owned tables and their seed data, and the judge/tribunal-member data brought in by the earlier data-sync work,
**When** the engineer implements the read endpoints,
**Then** `GET /v1/reference-data/regions`, `/offices`, `/calendar`, and `/vocabularies/{list}` (serving the CTAM-owned data) and `GET /v1/reference-data/johs`, `/jurisdictions`, and `/tickets` (serving the JOH-sourced data) all return a `200 OK` response with structured JSON,
**And** every read endpoint requires the caller to be authenticated, though any authenticated caller may read from them,
**And** every response is automatically filtered to the caller's jurisdiction — for example, a caller scoped to Employment Tribunals only sees Tribunals/ET-relevant entries — using the jurisdiction hierarchy to correctly include or exclude parent and child jurisdictions,
**And** the API never mixes the two kinds of data in a single response — each resource clearly documents which one it serves,
**And** there are no endpoints for creating, changing, or deleting data (`POST`, `PUT`, `PATCH`, `DELETE`) — attempting one is rejected with a `405 Method Not Allowed` response, in the standard "problem details" error format, explaining the correct way to make that kind of change (corrections at source for judge/tribunal-member data; the DBA runbook for CTAM-owned data),
**And** a full, machine-readable API specification is automatically generated, documenting every read endpoint's requests and responses.

**Given** the engineer implements pagination and filtering,
**When** a consumer requests, for example, `GET /v1/reference-data/offices?region=northern&page=2&size=50`,
**Then** the response comes back in a standard paged format — an `items` list, plus `page`, `size`, `totalElements`, and `totalPages` — so consumers can page through large lists consistently,
**And** an invalid query parameter returns a `400 Bad Request` response in the standard "problem details" format.

**Given** the API specification is generated and automatically checked for quality,
**When** the specification is built,
**Then** it passes that automated quality check,
**And** it is published as a versioned package (`uk.gov.hmcts.ctam:api-ctam-reference-data:1.0.0`) to the programme's shared internal package repository, so other teams can pull in a matching client,
**And** a browsable version of the specification (Swagger UI) is made available for developers, restricted to internal use at the API gateway.

**Given** the API gateway is configured for `ctam-reference-data`,
**When** a response leaves the gateway on its way to the caller,
**Then** it carries standard rate-limit information in its headers,
**And** any endpoint flagged in the specification as being phased out automatically gets `Deprecation` and `Sunset` warning headers added (none are flagged yet at this stage of the programme; the mechanism itself is proven with a dedicated test endpoint),
**And** internal diagnostic (`/actuator/*`) addresses are blocked from outside access at the gateway.

**Given** the engineer publishes the programme's first Postman collection,
**When** that collection is run automatically as part of CI,
**Then** `postman/ctam-reference-data-phase0.postman_collection.json` exercises every read endpoint across both the CTAM-owned and JOH-sourced data,
**And** it checks: the normal successful case; that two callers in different jurisdictions see different results; an invalid query correctly returning a 400; an unauthenticated request correctly being rejected; and an attempted write correctly being rejected,
**And** the collection is version-controlled alongside the service.

**Explicitly NOT in scope (deferred post-MVP or to another piece of work):**
- The reference data endpoint sourced from the separate MRD feed — that's a later piece of work building on top of this API
- Admin write endpoints for the CTAM-owned data
- Any write surface at all for the judge/tribunal-member data — that never happens, in any phase
