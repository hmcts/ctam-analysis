---
type: 'Epic'
description: "User outcome: mrd_specialisms (ingested by Epic 0.8) is queryable read-only via ctam-reference-data's versioned REST API, jurisdiction-filtered, so Phase 1+ services can read JOH Specialisations without direct SQL access. Split out of Epic 0.4 (SCP 2026-08-25c) as new scope - no MRD read endpoint existed before this epic."
resource: 'epics/phase-0/epic-0.10-mrd-data-read-only-api.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-25'
parent: 'epics/phase-0/index.md'
epic: 0.10
title: 'MRD data is served read-only via a versioned, jurisdiction-filtered API'
storyCount: 1
repo: ctam-reference-data
depends_on: [epic-0.7, epic-0.8]
---

# Epic 0.10: MRD data is served read-only via a versioned, jurisdiction-filtered API

**User outcome:** `mrd_specialisms` (ingested by Epic 0.8's weekly MRD Excel pick-up) is queryable **read-only** via `ctam-reference-data`'s versioned REST API, **jurisdiction-filtered**[^d8], so Phase 1+ services can read JOH Specialisations at runtime instead of needing direct SQL access. **Split out of Epic 0.4** (SCP 2026-08-25c) — this is genuinely new scope: no endpoint over `mrd_*` data existed before this epic (Epic 0.4's read API only ever covered tier-(b) vocab and tier-(a) JOH data).

**Vertical slice:**
- Reference Data **read-only** REST API extended with an MRD-sourced resource: `GET /v1/reference-data/specialisms`, jurisdiction-filtered
- Same API-as-Product read-side standards as Epic 0.4: URL versioning, OpenAPI 3.x (springdoc, Spectral-linted), RFC 9457 problem-details, RFC 9745 `Deprecation` + RFC 8594 `Sunset` headers
- Postman collection coverage added to the existing `ctam-reference-data-phase0.postman_collection.json`
- **No write endpoints** — `mrd_*` is tier-(a), corrections happen at source (MRD team), never hand-edited in CTAM (FR6)

**FRs covered:** FR6 (read surface over tier-(a) MRD data), FR7, FR58 (versioned read API contract), FR59 (structured logs).

**Key NFRs:** NFR14 (no forbidden data), NFR40 (per-service deployable), NFR42 (Postman collection).

**Out of scope (explicitly):** JOH data and tier-(b) vocab endpoints — Epic 0.4 (unchanged, already shipped there). Write endpoints for `mrd_*` (never, in any phase). MRD API integration replacing the Excel blob-drop reader (post-MVP, per Epic 0.8).

---

## Story 0.10.1: MRD data read-only REST API with jurisdiction filtering, versioning, OpenAPI, RFC 9457 errors

As an **API consumer** (downstream services from Phase 1+; `ctam-ui`),
I want a versioned **read-only** endpoint over MRD-sourced supplementary reference data (JOH Specialisations), with jurisdiction-filtered responses, full OpenAPI spec, and RFC 9457 error envelopes,
So that **Phase 1+ services can query JOH Specialisations at runtime, scoped to the requester's jurisdiction, without direct SQL access to `ctam-reference-data`'s schema** — closing the gap Epic 0.4's read API left over MRD data.

**Acceptance Criteria:**

**Given** `ctam-reference-data` carries `mrd_specialisms` (Epic 0.8, Story 0.8.1), and `JWTFilter` + jurisdiction resolution are available (Epic 0.7),
**When** the engineer implements the endpoint,
**Then** `GET /v1/reference-data/specialisms` returns `200 OK` with structured JSON,
**And** the endpoint is protected by `JWTFilter` (any authenticated principal can read; per NFR13),
**And** **responses are filtered by the requester's jurisdiction** resolved from `AuthDetails` (D8/FR2) — a specialism record's jurisdiction is resolved via its JOH's `personnel_number` → `jo_people` → `jo_jurisdictions`,
**And** **no write endpoints** (`POST`/`PUT`/`PATCH`/`DELETE`) are implemented — the controller rejects with `405 Method Not Allowed` and an RFC 9457 problem-details body pointing to "corrections at source" (MRD team, per FR6).

**Given** the engineer implements pagination + filtering,
**When** a consumer queries `GET /v1/reference-data/specialisms?personnelNumber=...&page=1&size=50`,
**Then** the response uses the same paginated envelope as Epic 0.4's endpoints (`{items, page, size, totalElements, totalPages}`),
**And** invalid query parameters return `400 Bad Request` with RFC 9457 problem-details.

**Given** the OpenAPI spec is regenerated and Spectral lint runs in CI,
**When** the spec is built,
**Then** it passes Spectral lint, and the `specialisms` resource is documented alongside the existing Epic 0.4 endpoints in the same published `api-ctam-reference-data` artefact (no separate spec — one service, one contract),
**And** `Deprecation`/`Sunset` headers are wired the same way as Epic 0.4's mechanism (none flagged deprecated at Phase 0).

**Given** the existing Phase 0 Postman collection (`postman/ctam-reference-data-phase0.postman_collection.json`, first published in Epic 0.4),
**When** the collection is extended,
**Then** it exercises the new endpoint: happy path + jurisdiction filtering + 400 (invalid query) + 401 (unauthenticated) + 405 (write attempt), per NFR42 — the same collection file, not a new one (one service, one collection).

**References:** FR6 (read surface over `mrd_*`), FR7, FR58, FR59; NFR12, NFR13, NFR14, NFR39, NFR42; AR8, AR17, AR27, AR33, AR37, AR38, AR39, AR41; D8; depends on Epic 0.7 (auth) and Epic 0.8 (`mrd_specialisms` exists).

**Explicitly NOT in scope:**
- JOH data / tier-(b) vocab endpoints — Epic 0.4 (already shipped there)
- Admin write endpoints for `mrd_*` (never, in any phase)
- MRD API integration replacing the blob-drop reader (post-MVP, per Epic 0.8)

[^d8]: D8 — rollout is jurisdiction-first, then per-region; jurisdiction is a first-class hierarchical attribute.
