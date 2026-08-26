---
type: 'Sprint Change Proposal'
description: 'Splits Epic 0.9 ("Reference data is served read-only...") into Epic 0.9 (JOH data read-only API - keeps tier-a JOH + tier-b vocab) and a new Epic 0.10 (MRD data read-only API - new scope, since no MRD read endpoint exists today).'
resource: 'sprint-change-proposal-2026-08-25c.html'
tags: [ctam-pathfinder, sprint-change-proposal]
timestamp: '2026-08-25'
title: 'Sprint Change Proposal — 2026-08-25c'
status: 'proposed'
---

# Sprint Change Proposal — 2026-08-25c

> **Addendum (approved in the same turn):** the user additionally asked to place the JOH-data read-only API epic at **Epic 0.4** instead of keeping it at 0.9. Epic 0.4 was already occupied ("Both user populations are bootstrapped and verifiable against the IdP") — resolved as a minimal 2-way swap, consistent with this session's established pattern for numbering collisions (see SCP 2026-08-25b): **JOH data read-only API → Epic 0.4**; **User populations bootstrapped → Epic 0.9** (the slot the JOH-data epic vacates). The MRD-data-read-only-api epic is unaffected by this — it lands at **Epic 0.10** exactly as designed below. Every mention of "Epic 0.9" below that refers to the JOH-data-API epic should be read as **Epic 0.4** in the final implementation, and "Epic 0.4" (bootstrap) as **Epic 0.9** — this addendum is the authoritative numbering; the body below is kept as originally drafted/approved for the record rather than rewritten line-by-line.

**Trigger:** *"split epic-0.9 into 2 epics joh-data-read-only-api and mrd-data-read-only-api"*

**Clarified via two questions before drafting** (Epic 0.9 today has no MRD read endpoint at all, so a clean split wasn't mechanical):
1. **Tier-(b) placement** → stays with the **JOH-data** epic (which becomes the "main" reference-data epic — mirrors how Epic 0.3 stayed the main ETL epic when MRD split off as the narrower Epic 0.8 back in SCP 2026-08-24b).
2. **MRD API scope** → **add a new story**, not a placeholder. Epic 0.10 gets a real, designed endpoint for `mrd_specialisms`, not a stub.

**Mode:** Batch. **Scope classification:** Moderate — one new epic with genuinely new story content (an endpoint that didn't exist before), plus a cross-reference sweep.

---

## 1. Issue Summary

Epic 0.9 ("Reference data is served read-only via a versioned, jurisdiction-filtered API") bundles tier-(b) CTAM-owned tables (Story 0.9.1) and a read-only REST API (Story 0.9.2) that, on inspection, only ever defined endpoints for tier-(b) vocab (`/regions`, `/offices`, `/calendar`, `/vocabularies/{list}`) and tier-(a) **JOH** data (`/johs`, `/jurisdictions`, `/tickets`). There is no endpoint anywhere for `mrd_specialisms` (Epic 0.8's MRD ingestion target) — MRD data lands in the database but nothing reads it back out via API today. That's a real gap, not just an organisational one: any Phase 1+ service wanting JOH Specialisations would currently need direct SQL access to `ctam-reference-data`'s schema, breaking the "reads via API" pattern the rest of the read surface follows.

Splitting the epic by upstream source — mirroring the Epic 0.3 (JOH ETL) / Epic 0.8 (MRD ingestion) split already in place on the write side — gives MRD data the same API-as-Product treatment JOH data gets, instead of leaving it as a silent gap.

## 2. Impact Analysis

### Epic impact

- **Epic 0.9** retitled **"JOH data is served read-only via a versioned, jurisdiction-filtered API"** — keeps Stories 0.9.1 (tier-(b) tables) and 0.9.2 (JOH + tier-(b) read API), content essentially unchanged (it never covered MRD), just reframed from generic "Reference data" to "JOH data" and given an explicit pointer to the new MRD epic. `depends_on` unchanged (`[epic-0.3, epic-0.7]`).
- **New Epic 0.10** — "MRD data is served read-only via a versioned, jurisdiction-filtered API" — one new story (0.10.1) adding `GET /v1/reference-data/specialisms` for `mrd_specialisms`, following the same jurisdiction-filtered/versioned/OpenAPI/RFC-9457/Postman pattern as Epic 0.9's endpoints. `depends_on: [epic-0.7, epic-0.8]` (needs auth for `JWTFilter`/jurisdiction, and Epic 0.8 for `mrd_specialisms` to exist — the JOH-ETL dependency Epic 0.9 has doesn't apply here since this epic never touches `jo_*` data).

### Story impact

- Story 0.9.1 — unchanged.
- Story 0.9.2 — reworded from "Reference Data" to "JOH data" framing; out-of-scope note added pointing to Epic 0.10 for MRD.
- **New Story 0.10.1** — MRD read-only REST API (real content, not a stub, per your answer).

### Artifact conflicts / updates needed

| Artifact | Change |
|---|---|
| `epics/phase-0/epic-0.9-reference-data-read-only-api.md` | Retitled/reframed to JOH-specific; unchanged stories, unchanged `depends_on` |
| `epics/phase-0/epic-0.10-mrd-data-read-only-api.md` *(new)* | New epic, 1 story |
| `epics/phase-0/index.md` | Epic 0.9 row/summary updated; new 0.10 row/summary; Stories Summary table +1 row; totals 26→27 stories, 10→11 epics |
| `epics/index.md` | Phase 0 summary line: 10→11 epics, 26→27 stories |
| `epics/framework.md` | Reference Data area: note the JOH/MRD read-API split |
| `epics/fr-coverage-map.md` | FR6/FR7/FR58 rows: note Epic 0.10 covers the MRD read surface |
| `architecture.md` | New decision entry (#17) |
| `architecture/changelog.md` | New version entry |
| `sprint-status.yaml` | `epic-0.9` story list unchanged; new `epic-0.10` block |
| `scripts/python/build_html.py` | NAV: retitle 0.9 entry, add 0.10 entry |

**Not touched:** `data-tables.md` (no new table — `mrd_specialisms` already exists via Epic 0.8; this only adds a read endpoint over it). `gaps.md`/`assumptions.md` (G8.1 is about the ingestion contract, not the read API — unaffected).

## 3. Recommended Approach

**Direct Adjustment** — split one epic into two, with one epic gaining a genuinely new (but small — one endpoint) story. Nothing rolls back (`sprint-status.yaml` shows Epic 0.9 fully `backlog`). No FR/NFR/PRD text changes (FR6/FR7/FR58 already covered "read API" generically; this just fills a coverage gap the epic-level text hadn't caught).

**Effort:** Low–Medium. **Risk:** Low — new story mirrors an already-proven pattern (Epic 0.9's own endpoints) closely enough that there's little design risk. **Timeline impact:** None — Epic 0.10 depends only on Epic 0.7 (auth) and Epic 0.8 (MRD ingestion), both already-planned Phase 0 epics; it doesn't block or get blocked by Epic 0.9.

## 4. Detailed Change Proposals

### 4.1 `epic-0.9-reference-data-read-only-api.md` — retitle and reframe

**Title:** "Reference data is served read-only via a versioned, jurisdiction-filtered API" → **"JOH data is served read-only via a versioned, jurisdiction-filtered API"**

**User outcome paragraph** — reworded to say tier-(a) **JOH** data + tier-(b) CTAM-owned data (dropping the implication that "reference data" covers MRD too), with an explicit line: *"MRD-sourced data (`mrd_specialisms`) is served by a separate epic, Epic 0.10, since it wasn't covered by any endpoint here."*

**Story 0.9.2**'s AC list is otherwise unchanged (it already only ever listed JOH + tier-(b) endpoints) — just the epic-level framing changes, plus an explicit "Explicitly NOT in scope: MRD read endpoints — Epic 0.10" line.

### 4.2 New file — `epic-0.10-mrd-data-read-only-api.md`

```markdown
---
type: 'Epic'
description: "User outcome: mrd_specialisms (ingested by Epic 0.8) is queryable read-only via ctam-reference-data's versioned REST API, jurisdiction-filtered, so Phase 1+ services can read JOH Specialisations without direct SQL access. Split out of Epic 0.9 (SCP 2026-08-25c) as new scope - no MRD read endpoint existed before this epic."
epic: 0.10
title: 'MRD data is served read-only via a versioned, jurisdiction-filtered API'
storyCount: 1
repo: ctam-reference-data
depends_on: [epic-0.7, epic-0.8]
---

# Epic 0.10: MRD data is served read-only via a versioned, jurisdiction-filtered API

**User outcome:** `mrd_specialisms` (ingested by Epic 0.8's weekly MRD Excel pick-up) is queryable **read-only** via `ctam-reference-data`'s versioned REST API, **jurisdiction-filtered**[^d8], so Phase 1+ services can read JOH Specialisations at runtime instead of needing direct SQL access. **Split out of Epic 0.9** (SCP 2026-08-25c) — this is genuinely new scope: no endpoint over `mrd_*` data existed before this epic (Epic 0.9's Story 0.9.2 only ever covered tier-(b) vocab and tier-(a) JOH data).

**Vertical slice:**
- Reference Data **read-only** REST API extended with an MRD-sourced resource: `GET /v1/reference-data/specialisms`, jurisdiction-filtered
- Same API-as-Product read-side standards as Epic 0.9: URL versioning, OpenAPI 3.x (springdoc, Spectral-linted), RFC 9457 problem-details, RFC 9745 `Deprecation` + RFC 8594 `Sunset` headers
- Postman collection coverage added to the existing `ctam-reference-data-phase0.postman_collection.json`
- **No write endpoints** — `mrd_*` is tier-(a), corrections happen at source (MRD team), never hand-edited in CTAM (FR6)

**FRs covered:** FR6 (read surface over tier-(a) MRD data), FR7, FR58 (versioned read API contract), FR59 (structured logs).

**Key NFRs:** NFR14 (no forbidden data), NFR40 (per-service deployable), NFR42 (Postman collection).

**Out of scope (explicitly):** JOH data and tier-(b) vocab endpoints — Epic 0.9 (unchanged, already shipped there). Write endpoints for `mrd_*` (never, in any phase). MRD API integration replacing the Excel blob-drop reader (post-MVP, per Epic 0.8).

---

## Story 0.10.1: MRD data read-only REST API with jurisdiction filtering, versioning, OpenAPI, RFC 9457 errors

As an **API consumer** (downstream services from Phase 1+; `ctam-ui`),
I want a versioned **read-only** endpoint over MRD-sourced supplementary reference data (JOH Specialisations), with jurisdiction-filtered responses, full OpenAPI spec, and RFC 9457 error envelopes,
So that **Phase 1+ services can query JOH Specialisations at runtime, scoped to the requester's jurisdiction, without direct SQL access to `ctam-reference-data`'s schema** — closing the gap Epic 0.9's read API left over MRD data.

**Acceptance Criteria:**

**Given** `ctam-reference-data` carries `mrd_specialisms` (Epic 0.8, Story 0.8.1), and `JWTFilter` + jurisdiction resolution are available (Epic 0.7),
**When** the engineer implements the endpoint,
**Then** `GET /v1/reference-data/specialisms` returns `200 OK` with structured JSON,
**And** the endpoint is protected by `JWTFilter` (any authenticated principal can read; per NFR13),
**And** **responses are filtered by the requester's jurisdiction** resolved from `AuthDetails` (D8/FR2) — a specialism record's jurisdiction is resolved via its JOH's `personnel_number` → `jo_people` → `jo_jurisdictions`,
**And** **no write endpoints** (`POST`/`PUT`/`PATCH`/`DELETE`) are implemented — the controller rejects with `405 Method Not Allowed` and an RFC 9457 problem-details body pointing to "corrections at source" (MRD team, per FR6).

**Given** the engineer implements pagination + filtering,
**When** a consumer queries `GET /v1/reference-data/specialisms?personnelNumber=...&page=1&size=50`,
**Then** the response uses the same paginated envelope as Epic 0.9's endpoints (`{items, page, size, totalElements, totalPages}`),
**And** invalid query parameters return `400 Bad Request` with RFC 9457 problem-details.

**Given** the OpenAPI spec is regenerated and Spectral lint runs in CI,
**When** the spec is built,
**Then** it passes Spectral lint, and the `specialisms` resource is documented alongside the existing Epic 0.9 endpoints in the same published `api-ctam-reference-data` artefact (no separate spec — one service, one contract),
**And** `Deprecation`/`Sunset` headers are wired the same way as Epic 0.9's mechanism (none flagged deprecated at Phase 0).

**Given** the existing Phase 0 Postman collection (`postman/ctam-reference-data-phase0.postman_collection.json`, first published in Epic 0.9),
**When** the collection is extended,
**Then** it exercises the new endpoint: happy path + jurisdiction filtering + 400 (invalid query) + 401 (unauthenticated) + 405 (write attempt), per NFR42 — the same collection file, not a new one (one service, one collection).

**References:** FR6 (read surface over `mrd_*`), FR7, FR58, FR59; NFR12, NFR13, NFR14, NFR39, NFR42; AR8, AR17, AR27, AR33, AR37, AR38, AR39, AR41; D8; depends on Epic 0.7 (auth) and Epic 0.8 (`mrd_specialisms` exists).

**Explicitly NOT in scope:**
- JOH data / tier-(b) vocab endpoints — Epic 0.9 (already shipped there)
- Admin write endpoints for `mrd_*` (never, in any phase)
- MRD API integration replacing the blob-drop reader (post-MVP, per Epic 0.8)

[^d8]: D8 — rollout is jurisdiction-first, then per-region; jurisdiction is a first-class hierarchical attribute.
```

### 4.3 `epics/phase-0/index.md`

- Epics table: retitle 0.9 row to "JOH data is served read-only via a versioned, jurisdiction-filtered API"; add row `| [0.10](epic-0.10-mrd-data-read-only-api.md) | MRD data is served read-only via a versioned, jurisdiction-filtered API | 1 | 🟡 Planned |`; total 26→27 stories.
- Epic 0.9 summary: reworded per §4.1; new Epic 0.10 summary added.
- Phase 0 Epic Stories Summary table: 0.9 row description updated to "JOH"; new 0.10 row (1 story); total 26→27 stories, "ten demos"→"eleven demos".

### 4.4 `epics/index.md`

Phase 0 row: "🟡 Planned — 10 epics, 26 stories" → "🟡 Planned — 11 epics, 27 stories".

### 4.5 `epics/framework.md` — Reference Data area

Append: *"The read-only API is split by upstream source: [Epic 0.9](phase-0/epic-0.9-reference-data-read-only-api.md) serves JOH data (tier-(a) + tier-(b)); [Epic 0.10](phase-0/epic-0.10-mrd-data-read-only-api.md) serves MRD data (`mrd_specialisms`) — split 2026-08-25c since no MRD read endpoint existed before."*

### 4.6 `epics/fr-coverage-map.md`

FR6, FR7, FR58 rows: append "; MRD read surface is [Epic 0.10](phase-0/epic-0.10-mrd-data-read-only-api.md), split out 2026-08-25c" where they cite Epic 0.9's Story 0.9.2.

### 4.7 `architecture.md` — decision log

New row:

| 17 | Reference Data read API split by upstream source: JOH (0.9) vs MRD (new 0.10) *(SCP 2026-08-25c)* | Epic 0.9's read API never actually covered `mrd_*` data — only tier-(b) vocab and tier-(a) JOH endpoints were ever specified, leaving MRD data reachable only via direct SQL. Split the epic by upstream source, mirroring the Epic 0.3 (JOH ingestion) / Epic 0.8 (MRD ingestion) write-side split: **Epic 0.9** keeps JOH + tier-(b) (unchanged content, retitled); **new Epic 0.10** adds the first `mrd_*` read endpoint (`GET /v1/reference-data/specialisms`), same API-as-Product conventions, published in the same `api-ctam-reference-data` OpenAPI artefact (one service, one contract — no new repo or deployable). See [`./sprint-change-proposal-2026-08-25c.md`](./sprint-change-proposal-2026-08-25c.md). |

### 4.8 `architecture/changelog.md`

New version entry (v4.14) summarising the split and the new-scope MRD endpoint.

### 4.9 `sprint-status.yaml`

Append:

```yaml
  epic-0.10: backlog
  0-10-1-mrd-data-read-only-rest-api-with-jurisdiction-filtering-versioning-openapi-rfc-9457-errors: backlog
  epic-0.10-retrospective: optional
```

(Epic 0.9's own block is unchanged — same two stories, same slugs.)

### 4.10 `scripts/python/build_html.py`

NAV: retitle the Epic 0.9 entry; add an Epic 0.10 entry after it.

## 5. Implementation Handoff

**Scope: Moderate** — one new epic with real (if small) new story content, plus a cross-reference sweep. Routed as **Product Owner / Developer**.

**Success criteria:** Epic 0.9 and Epic 0.10 are each internally consistent; `epics/phase-0/index.md`'s two summary tables agree (27 stories, 11 epics); `docs/` regenerates cleanly with Epic 0.10 reachable from the nav; `data-tables.md` unchanged (no new table — this only adds a read endpoint over the existing `mrd_specialisms`).
