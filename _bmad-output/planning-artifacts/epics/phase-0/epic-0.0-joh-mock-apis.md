---
type: 'Epic'
description: 'User outcome: a local mock of the upstream JOH eLinks People API (v5) is available for development and testing, so ctam-reference-data can build and test its ingestion sync (Epic 1.1) against a realistic, stable contract ahead of the real eLinks API being confirmed (gap G8.1).'
resource: 'epics/phase-0/epic-0.0-joh-mock-apis.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-24'
parent: 'epics/phase-0/index.md'
epic: 0.0
title: 'JOH Mock APIs — local eLinks mock server'
storyCount: 2
repo: ctam-jomockapi
depends_on: []
---

# Epic 0.0: JOH Mock APIs — local eLinks mock server

> **Dev/integration-only, like `ctam-mock-auth`** — never deployed to production, not one of the 11 production services. Existed and ran independently (`/Users/shivakumar/MOJ/ctam-jomockapi`) before this epic was written; this epic documents it in the planning pack and wires it into Phase 1's ingestion work, it does not build it from scratch. Precedes Phase 1 numerically because it is a prerequisite dev aid, not a phase of the product itself — the real Foundations phase (Reference Data, Authorisation, Notification, etc.) is Phase 1, unaffected by this epic.

**User outcome:** `ctam-reference-data`'s upstream ingestion sync (Epic 1.1) can be built and tested end-to-end against a realistic, stable stand-in for the **Judiciary E-links People API (v5)** — the upstream source of truth for `jo_people` and the other 14 `jo_*` reference-data entities — before the real API's contract is confirmed with Judicial Office (gap **G8.1**). Removes "wait for the real eLinks contract" from Epic 1.1's critical path.

**What it is:** a local Node.js/Express server (`ctam-jomockapi`, package name `jo-mock-api`) built from the real Swagger UI export (`docs/Swagger UI.pdf`) and complete example payloads (`docs/apiresponses.docx`, since several PDF-exported examples were truncated). It is **not** a hand-written stub — every endpoint, parameter, and response shape is grounded in the documented contract, and reference-data responses are served from the **real production reference-data exports** (`docs/ReferenceData/*.csv|json` — `locations`: 2000 rows, `base_locations`: 1462, `appointment_titles`: 194, `judiciary_roles`: 164, `tickets`: 159, `ticket_categories`: 54, plus the smaller fixed vocabularies `genders`/`contract_types`/`location_types`/`ticket_category_types`/`jurisdictions`).

**Vertical slice:**
- Express server (`server.js`) mounted at both the bare path and `/elinks` (the swagger doc names the server base path `/elinks`, but every real request example in `apiresponses.docx` is against a bare `/api/v5/...` path — the mock accepts both so it matches whichever base a client expects)
- Bearer-token auth middleware (`src/middleware/auth.js`) on every People/Reference Data route, matching the documented `401 Unauthorized. Invalid or missing token.` behaviour — the mock accepts any non-empty token (no real credential to check) so callers can exercise both the happy path and the documented 401 path
- `GET /api/v5/reference_data/:attribute_name` (list) and `.../:attribute_name/:reference_id` (single, wrapped in `results: [...]`), covering all 15 `jo_*` reference vocabularies plus their deprecated singular aliases
- `GET /api/v5/people/:id` (full profile, `?include_previous_appointments=true`) and `GET /api/v5/people` (the change-feed shape — **required** `?updated_since=YYYY-MM-DD`, plus `per_page`/`page`)
- `GET /api/v5/leavers` and `GET /api/v5/deleted` (both **require** their respective `*_since` date filter, plus pagination)
- `GET /` and `GET /api/v5/healthcheck` public (no auth), per the swagger doc
- 100 generated JOH people (`src/lib/personGenerator.js`, fixed random seed via `src/lib/rng.js` so ids/values are stable across restarts) with appointments, judiciary roles, and authorisations built by **joining against the real reference data**, so names/ids are realistic and internally consistent (~85% `active`, ~10% `leaver`, ~5% `deleted`)
- `GET /api/v5/people` change-feed mixes full profiles (active) with the compact `LeaverResponse`/`DeletedResponse` stubs for leavers/deleted, matching the documented shape; `GET /api/v5/people/:id` always returns a full profile (404 once deleted)
- 100 leaver records and 100 deleted records (`src/lib/leaverDeletedGenerator.js`), each seeded from the corresponding people plus independent historical padding so each endpoint has its own 100-record history
- An interactive `/docs` console (`public/docs.html`) that lists every endpoint and can call the auth-protected ones from the browser (plain links can't send the `Authorization` header)

**Known, documented deviations from the swagger doc** (all deliberate, all recorded in the sibling repo's own README — carried here so this epic doesn't silently duplicate or contradict them): the generic `ReferenceDataResponse` schema in the swagger doc only lists `id, updated_at, created_at, start_date, end_date`, but the mock returns the **full real column set** per attribute (e.g. `name`, `jurisdiction_id`, `type_id`) since that's what the actual reference data contains; `appointments` is always an array (the swagger doc's single-person example showed a single object, but the list example and the `AppointmentsResponse` schema both treat it as a collection — matching a person holding multiple appointments in reality); `include_previous_appointments` is implemented by including a person's ended appointments in the same `appointments` array (there's no separate field for it in the documented schema).

**Not covered — out of scope for this epic:** the real Judiciary eLinks API's actual behaviour where it differs from its own documentation (unknowable until G8.1 closes); the MRD weekly Excel feed (a separate upstream integration, unrelated to eLinks); any production deployment of `ctam-jomockapi` (it is a local dev tool, run with `npm start`, never containerised or given a Helm chart).

**FRs covered:** none directly — this is a dev/test aid, not a product capability. Supports FR1 (the `jo_people` lookup target) and FR6/FR7 tier-(a) indirectly, by giving Epic 1.1's ingestion sync something real to build against.

**References:** `architecture/gaps.md` G8.1 (JOH eLinks API contract unconfirmed); `epics/phase-1/epic-1.1-upstream-reference-data-ingested.md` (the consumer of this mock).

---

## Story 0.0.1: Stand up `ctam-jomockapi` for local development

As a **backend engineer building `ctam-reference-data`**,
I want a documented, runnable local mock of the JOH eLinks People API,
So that **I can develop and manually exercise the ingestion sync against a realistic contract without depending on the real upstream API being available**.

**Acceptance Criteria:**

**Given** the `ctam-jomockapi` repo (`npm install && npm start`),
**When** the server starts,
**Then** it listens on `http://localhost:3000` and logs a ready message,
**And** `GET /api/v5/healthcheck` returns `200 { "message": "Service is healthy" }` with no auth required.

**Given** the server is running,
**When** a request to any People or Reference Data endpoint omits the `Authorization` header (or sends a malformed one),
**Then** the response is `401 Unauthorized. Invalid or missing token.`, matching the documented real-API behaviour,
**And** the same request with any non-empty `Bearer` token succeeds.

**Given** a request to `GET /api/v5/reference_data/jurisdictions` (or any of the other 14 `jo_*` attribute names, including their deprecated singular aliases),
**When** the request is authenticated,
**Then** the response returns the real reference-data rows loaded from `docs/ReferenceData/*.csv|json` at startup, not fabricated placeholder values.

**Given** a request to `GET /api/v5/people?updated_since=2020-01-01`,
**When** the request is authenticated,
**Then** the response returns the documented change-feed shape — full profiles for active people, `LeaverResponse`/`DeletedResponse` stubs for leavers/deleted — paginated per `per_page`/`page`.

## Story 0.0.2: Wire `ctam-reference-data`'s ingestion sync against the mock

As a **backend engineer implementing Epic 1.1's JOH eLinks sync**,
I want the nightly ingestion job's eLinks client configurable to point at `ctam-jomockapi` in dev/CI,
So that **the full sync path — fetch, upsert on natural key, soft-deactivation — is exercised end-to-end before the real eLinks contract is confirmed**.

**Acceptance Criteria:**

**Given** `ctam-jomockapi` is running and reachable from the `ctam-reference-data` dev/CI environment,
**When** the eLinks client's base URL is set to it via Spring profile (dev/CI only — never `production`),
**Then** the nightly sync job runs against it exactly as it would against the real API, using the same `/api/v5/...` paths and bearer-auth header.

**Given** the sync job runs a full cycle against the mock,
**When** it completes,
**Then** all 15 `jo_*` reference-data entities and `jo_people` are populated in `ctam-reference-data`'s tables from the mock's real reference-data values and generated people,
**And** `ctam_sync_status` records a successful run.

**Given** the mock's stable random seed keeps ids/values consistent across restarts,
**When** the sync job runs twice in a row (e.g. in CI),
**Then** the second run's upsert-on-natural-key logic is provably idempotent — no duplicate rows, only updated timestamps where the mock's data hasn't changed.

**Given** gap G8.1 is later closed (real eLinks contract confirmed),
**When** any documented deviation between the mock and the real API surfaces (see this epic's "Known, documented deviations" section),
**Then** the ingestion mapping is re-validated against the real contract per G8.1's existing closure criteria — this story does not close G8.1 itself, it only removes the mock's absence as a blocker to building and testing the sync.
