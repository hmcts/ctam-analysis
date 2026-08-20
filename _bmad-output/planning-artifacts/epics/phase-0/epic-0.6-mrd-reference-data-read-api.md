---
type: 'Epic'
description: 'User outcome: MRD-sourced supplementary reference data (JOH Specialisations, from mrd_specialisms) is exposed read-only, jurisdiction-filtered, through the already-published Reference Data API — extending its existing OpenAPI spec and Postman collection with one new endpoint rather than standing up a separate service surface.'
resource: 'epics/phase-0/epic-0.6-mrd-reference-data-read-api.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-20'
parent: 'epics/phase-0/index.md'
epic: 0.6
title: 'MRD reference data is served read-only via the Reference Data API'
storyCount: 1
repo: ctam-reference-data
depends_on: [epic-0.3, epic-0.5]  # needs MRD data to exist (eLinks-independent ETL) and the already-published read API + JWTFilter/jurisdiction-filtering infra
---

# Epic 0.6: MRD reference data is served read-only via the Reference Data API

> **Split from Epic 0.5 2026-08-20 (SCP 2026-08-20d):** the original Reference Data read API epic covered tier-(b) CTAM-owned data and tier-(a) JOH data only — no MRD-sourced endpoint was ever specified. This epic adds that missing endpoint as new content, not an extraction. It **extends** Epic 0.5's already-published OpenAPI spec (`api-ctam-reference-data`) and Postman collection with one more resource, rather than creating a new service, API version, or artefact.

**User outcome:** Supplementary MRD-sourced reference data — **JOH Specialisations**, held in `mrd_specialisms` (Epic 0.3) — is queryable read-only, **jurisdiction-filtered**[^d8], through the same versioned Reference Data API `ctam-ui` and downstream services already consume for tier-(b) and JOH tier-(a) data (Epic 0.5). Consumers see one coherent API surface; they don't need to know MRD is a separate upstream feed with its own ingestion cadence.

**Hosting:** same repo, same service, same OpenAPI artefact (`uk.gov.hmcts.ctam:api-ctam-reference-data`) as Epic 0.5 — this epic is additive, not a new deployable or a new API version.

**Vertical slice:**
- One new read endpoint over `mrd_specialisms`, jurisdiction-filtered via the JOH personnel-number → jurisdiction chain (same `AuthDetails`-driven filtering pattern as Epic 0.5, Story 0.5.2)
- Added to the existing OpenAPI spec (same artefact version bump, not a new spec) and the existing Postman collection

**FRs covered:** FR6 (read surface over tier (a) — MRD is tier (a), read-only in CTAM), FR7, FR58.

**Key NFRs:** NFR13 (authz enforcement incl. jurisdiction — reused, not reimplemented), NFR39 (API-as-Product consistency with the rest of the spec), NFR42 (Postman collection extended, not duplicated).

**Out of scope (explicitly):** MRD ingestion itself (Epic 0.3). Tier-(b) and JOH tier-(a) endpoints (Epic 0.5). Any write surface for MRD data (never, in any phase — tier (a), corrections at source per FR6). A separate API version or artefact for MRD (this epic extends Epic 0.5's existing one).

---

## Story 0.6.1: MRD reference data (JOH Specialisations) is exposed via the Reference Data read-only API

As an **API consumer** (`ctam-ui`; downstream services in Phase 1+ that need JOH Specialisations — e.g. Itineraries in Phase 7),
I want a versioned, **read-only**, jurisdiction-filtered endpoint over the MRD-sourced `mrd_specialisms` data, added to the existing Reference Data API,
So that **JOH Specialisations are queryable through the one API surface Phase 1+ services already integrate against**, without a second API to discover or a second Postman collection to run.

**Acceptance Criteria:**

**Given** `mrd_specialisms` exists and is populated per Epic 0.3, Story 0.3.1,
**And** the Reference Data API's read infrastructure (JWTFilter protection, jurisdiction-filtering from `AuthDetails`, RFC 9457 error envelopes, `/v1/reference-data/...` versioning) already exists per Epic 0.5, Story 0.5.2,
**When** the engineer adds `GET /v1/reference-data/johs/{johId}/specialisms`,
**Then** the endpoint returns `200 OK` with the JOH's specialisms, resolved via `ctam_joh_identities` → `personnel_number` → `mrd_specialisms`,
**And** the response is **jurisdiction-filtered** consistently with every other endpoint on this API — a requester outside the JOH's jurisdiction gets `403 Forbidden` with an RFC 9457 problem-details body, not a filtered-empty result,
**And** a JOH with no specialisms on record returns `200 OK` with an empty list, not `404`,
**And** **no write endpoints** are implemented — attempting `POST`/`PUT`/`PATCH`/`DELETE` returns `405 Method Not Allowed` with an RFC 9457 body explaining corrections happen at source (MRD team) and arrive via the next sync (FR6).

**Given** the OpenAPI spec is regenerated,
**When** the engineer publishes the updated artefact,
**Then** `uk.gov.hmcts.ctam:api-ctam-reference-data` bumps to the next version (not a new artefact coordinate) with the new endpoint documented alongside the existing ones,
**And** Spectral lint passes on the updated spec (per AR17).

**Given** the Phase 0 Postman collection,
**When** `postman/ctam-reference-data-phase0.postman_collection.json` runs in CI,
**Then** it gains a case for the new endpoint (happy path + jurisdiction-filtered 403 + empty-list 200 + 405 write attempt), alongside the existing tier-(b)/JOH cases from Epic 0.5 (per NFR42).

**References:** FR6 (MRD read surface, tier (a)), FR7, FR58; NFR13, NFR39, NFR42; AR8, AR17, AR34, AR37; D8.

**Explicitly NOT in scope:**
- MRD ingestion — Epic 0.3, Story 0.3.1
- Tier-(b) and JOH tier-(a) endpoints — Epic 0.5, Story 0.5.2
- Any write surface for MRD data (never, in any phase — tier (a) per FR6)

[^d8]: D8 — rollout is jurisdiction-first, then per-region; jurisdiction is a first-class hierarchical attribute.
