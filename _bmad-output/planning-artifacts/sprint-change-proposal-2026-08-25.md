---
type: 'Sprint Change Proposal'
description: '12 Sprint Change Proposals from 2026-08-25, consolidated into one file per day. Moves Epic 1.1 (JOH domain schema, PostgreSQL) from Phase 1 into Phase 0 as Epic 0.9. Phase 1 reverts to framework-only (it had no other epics). Pure renumber/relocate - no content change.'
resource: 'sprint-change-proposal-2026-08-25.html'
tags: [ctam-pathfinder, sprint-change-proposal]
timestamp: '2026-08-25'
title: 'Sprint Change Proposal — 2026-08-25'
---

# Sprint Change Proposal — 2026-08-25

This file consolidates **12 Sprint Change Proposals** made on **2026-08-25** into one file (previously separate files: `sprint-change-proposal-2026-08-25.md#sprint-change-proposal-2026-08-25`, `sprint-change-proposal-2026-08-25.md#sprint-change-proposal-2026-08-25b`, `sprint-change-proposal-2026-08-25.md#sprint-change-proposal-2026-08-25c`, `sprint-change-proposal-2026-08-25.md#sprint-change-proposal-2026-08-25d`, `sprint-change-proposal-2026-08-25.md#sprint-change-proposal-2026-08-25f`, `sprint-change-proposal-2026-08-25.md#sprint-change-proposal-2026-08-25g`, `sprint-change-proposal-2026-08-25.md#sprint-change-proposal-2026-08-25h`, `sprint-change-proposal-2026-08-25.md#sprint-change-proposal-2026-08-25i`, `sprint-change-proposal-2026-08-25.md#sprint-change-proposal-2026-08-25j`, `sprint-change-proposal-2026-08-25.md#sprint-change-proposal-2026-08-25k`, `sprint-change-proposal-2026-08-25.md#sprint-change-proposal-2026-08-25l`, `sprint-change-proposal-2026-08-25.md#sprint-change-proposal-2026-08-25m`). Each entry below is preserved verbatim from its original file — only frontmatter, heading levels, and the file boundary changed.

## Index

- [Sprint Change Proposal — 2026-08-25](#sprint-change-proposal-2026-08-25)
- [Sprint Change Proposal — 2026-08-25b](#sprint-change-proposal-2026-08-25b)
- [Sprint Change Proposal — 2026-08-25c](#sprint-change-proposal-2026-08-25c)
- [Sprint Change Proposal — 2026-08-25d](#sprint-change-proposal-2026-08-25d)
- [Sprint Change Proposal — 2026-08-25f](#sprint-change-proposal-2026-08-25f)
- [Sprint Change Proposal — 2026-08-25g](#sprint-change-proposal-2026-08-25g)
- [Sprint Change Proposal — 2026-08-25h](#sprint-change-proposal-2026-08-25h)
- [Sprint Change Proposal — 2026-08-25i](#sprint-change-proposal-2026-08-25i)
- [Sprint Change Proposal — 2026-08-25j](#sprint-change-proposal-2026-08-25j)
- [Sprint Change Proposal — 2026-08-25k](#sprint-change-proposal-2026-08-25k)
- [Sprint Change Proposal — 2026-08-25l](#sprint-change-proposal-2026-08-25l)
- [Sprint Change Proposal — 2026-08-25m](#sprint-change-proposal-2026-08-25m)

---

## Sprint Change Proposal — 2026-08-25

**Status:** proposed

**Trigger:** *"move epic-1.1 to phase-0"*

**Mode:** Batch. **Scope classification:** Minor — a pure relocate/renumber, no story content, no FR/NFR, no architecture-decision change.

### 1. Issue Summary

Epic 1.1 ("JOH domain schema is designed and implemented in PostgreSQL") was added yesterday (SCP 2026-08-24c) as the first — and only — epic in a new `epics/phase-1/` folder. The team wants it filed as a Phase 0 epic instead. Since it was the sole occupant of Phase 1, moving it out leaves Phase 1 with nothing, reverting to its prior "framework only" state.

Nothing about the epic's *content* changes — same 2 stories (scaffold `ctam-joh`; create its 5 domain tables), same dependencies, same open items flagged for the implementer (tier-(b) vocabulary FK verification; the `ctam_jurisdictional_splits` 100%-sum enforcement choice). Only its number, file location, and cross-references change.

### 2. Impact Analysis

- **Epic renumbered:** 1.1 → **0.9** (next free Phase 0 slot). Stories 1.1.1/1.1.2 → **0.9.1/0.9.2**.
- **File moved:** `epics/phase-1/epic-1.1-postgres-sql-schema-design.md` → `epics/phase-0/epic-0.9-postgres-sql-schema-design.md` (via `git mv`, preserving history).
- **`epics/phase-1/` folder removed** — Phase 1 had no other epics, so it reverts to "_to be storied_ / ⚪ Framework only" in `epics/index.md`, same as every other undecomposed phase.
- **`depends_on` unchanged** (`[epic-0.0, epic-0.1, epic-0.6]` — all were already Phase 0 epics, so the dependency set needed no change).
- **`framework.md`'s Phase 1 · JOH area** keeps its cross-reference to this schema epic (the *content* is still JOH-domain schema work, described in that architectural area) — only the link target updates to the new Phase 0 location. This mirrors how Epic 0.6/0.7 already sit in the Phase 0 folder while covering cross-cutting, not purely Phase-0-scoped, concerns.
- **`fr-coverage-map.md`** — the "schema groundwork landed" note under the Phase 1 pending FR10–FR18 row updates its link/label from Epic 1.1 to Epic 0.9; it stays in the *Phase 1 FRs* table (FR-ownership, not file location, drives that table).
- **Caught while editing:** `epics/index.md`'s Phase 0 summary line still read "6 epics, 19 stories" — stale since the Epic 0.6/0.7/0.8 additions earlier this session. Corrected to the actual current total (10 epics, 26 stories, including this move) alongside this change.
- **Not touched:** `data-tables.md` (unaffected — same 5 tables, same design), the epic's own story content/ACs (verbatim, only numbers change), `architecture.md` decision log (a file relocation isn't an architectural decision), and yesterday's SCP 2026-08-24c (left as an immutable historical record of what was proposed and approved that day).

### 3. Recommended Approach

Direct relocate + renumber (Option 1, trivially). No rollback question (nothing built against Epic 1.1 yet — `sprint-status.yaml` shows it `backlog`), no MVP/FR impact.

**Effort:** Low. **Risk:** Low — mechanical, verified file-by-file rather than blind find-replace. **Timeline impact:** None.

### 4. Detailed Change Proposals

| Artifact | Change |
|---|---|
| `epics/phase-0/epic-0.9-postgres-sql-schema-design.md` *(moved + renumbered)* | `epic: 1.1`→`0.9`; `parent`/`resource` → phase-0 paths; H1 "Epic 1.1"→"Epic 0.9"; Stories 1.1.1/1.1.2 → 0.9.1/0.9.2 throughout; body content otherwise verbatim |
| `epics/phase-1/` | Removed (`index.md` deleted — no epics left) |
| `epics/index.md` | Phase 0 row: 6 epics/19 stories → 10 epics/26 stories (corrects stale count + adds this epic). Phase 1 row: reverts to `_to be storied_` / ⚪ |
| `epics/phase-0/index.md` | Epic 0.9 row added to epics table + summary section; Stories Summary table +1 row; totals 24→26 stories, 9→10 epics; "nine demos"→"ten demos" |
| `epics/framework.md` | Phase 1 · JOH area: link updated from `phase-1/epic-1.1-...` to `phase-0/epic-0.9-...` |
| `epics/fr-coverage-map.md` | FR10–FR18 pending row: "Epic 1.1" → "Epic 0.9", link updated |
| `architecture/changelog.md` | New v4.12 entry |
| `sprint-status.yaml` | `epic-1.1`/`1-1-1-...`/`1-1-2-...` renamed to `epic-0.9`/`0-9-1-...`/`0-9-2-...`, status unchanged (`backlog`) |
| `scripts/python/build_html.py` | Remove "Implementation — Phase 1" NAV group; add Epic 0.9 to "Implementation — Phase 0" NAV list |

### 5. Implementation Handoff

**Scope: Minor** — direct implementation, no PO/DEV backlog coordination needed beyond the mechanical sweep above.

**Success criteria:** `epic-0.9`'s file is internally consistent (no leftover "1.1"/"Phase 1" references); `epics/index.md` and `epics/phase-0/index.md` totals agree; `docs/` regenerates cleanly with no dangling Phase 1 nav entries; `data-tables.md` and the epic's ACs are unchanged in substance.

---

## Sprint Change Proposal — 2026-08-25b

**Status:** approved

**Trigger:** *"reorder the epics as follows: postgress-sql-schema-design as 0.1, joh-elinks-mock-api as 0.2, joh-reference-data-etl-process as 0.3"*

**Clarified via two questions before drafting** (the requested target slots 0.1–0.3 were occupied by two other epics not mentioned in the request):
1. **Displaced-epic handling** → **Minimal swap.** Only the 5 involved epics move, as a closed permutation: ETL-process 0.1→0.3, User-authenticates 0.2→0.7, Reference-data-API 0.3→0.9, Mock-API 0.7→0.2, Schema-design 0.9→0.1. Epics 0.0, 0.4, 0.5, 0.6, 0.8 untouched.
2. **Relabeling scope** → **Relabeling only.** Real technical dependencies are unchanged; `depends_on` arrays get rewired to point at the new ids of the same epics, not altered in meaning.

**Mode:** Batch. **Scope classification:** Moderate — mechanically large (touches every Phase 0 epic file plus ~10 supporting artifacts), but conceptually simple (a closed permutation, no content change).

---

### 1. Issue Summary

The team wants three epics — JOH domain schema, JOH eLinks mock API, and the JOH reference-data ETL process — filed at the front of Phase 0's numbering (0.1–0.3), ahead of the auth and reference-data-API epics that currently occupy those slots. Since every epic's `depends_on` array references other epics **by id** (e.g. `depends_on: [epic-0.0, epic-0.1, epic-0.6]`), a renumber isn't just a label change — every epic that depended on one of the 5 moved epics needs its `depends_on` rewired to the new id, or the dependency graph silently breaks (pointing at whatever epic now happens to sit at the old number).

### 2. Impact Analysis

#### The permutation

| Epic | Old → New | Title |
|---|---|---|
| Schema design | 0.9 → **0.1** | JOH domain schema is designed and implemented in PostgreSQL |
| Mock API | 0.7 → **0.2** | JOH eLinks mock API stands in for the unconfirmed upstream contract |
| ETL process | 0.1 → **0.3** | JOH reference-data ETL process |
| User authenticates | 0.2 → **0.7** | User authenticates and lands on a role-scoped Home page |
| Reference data read API | 0.3 → **0.9** | Reference data is served read-only via a versioned, jurisdiction-filtered API |

Unaffected: 0.0 (Platform estate), 0.4 (User populations bootstrapped), 0.5 (Notification), 0.6 (Context bus), 0.8 (MRD ingestion).

#### Dependency graph rewiring

Every `depends_on` array across all 10 Phase 0 epics was checked and rewired where it referenced one of the 5 moved epics (values only — the *files that declare* these arrays, e.g. epic 0.4 or 0.8, were themselves untouched in number):

| Epic (new id) | `depends_on` before | `depends_on` after |
|---|---|---|
| 0.1 (schema) | `[epic-0.0, epic-0.1, epic-0.6]` | `[epic-0.0, epic-0.3, epic-0.6]` |
| 0.2 (mock API) | `[epic-0.0]` | `[epic-0.0]` (unchanged) |
| 0.3 (ETL) | `[epic-0.0, epic-0.6]` | `[epic-0.0, epic-0.6]` (unchanged) |
| 0.4 (bootstrap) | `[epic-0.1, epic-0.2]` | `[epic-0.3, epic-0.7]` |
| 0.7 (auth) | `[epic-0.0, epic-0.1]` | `[epic-0.0, epic-0.3]` |
| 0.8 (MRD) | `[epic-0.0, epic-0.1]` | `[epic-0.0, epic-0.3]` |
| 0.9 (read API) | `[epic-0.1, epic-0.2]` | `[epic-0.3, epic-0.7]` |

Every real technical dependency is unchanged (e.g. the schema epic still needs `ctam_joh_identities`, which the ETL epic mints — it now just cites that epic as `epic-0.3` instead of `epic-0.1`).

#### Story renumbering

Each moved epic's stories move with it (story index within the epic stays the same, only the epic-number prefix changes): 0.1.1–0.1.3 → 0.3.1–0.3.3 (ETL); 0.2.1–0.2.5 → 0.7.1–0.7.5 (auth); 0.3.1–0.3.2 → 0.9.1–0.9.2 (read API); 0.7.1–0.7.3 → 0.2.1–0.2.3 (mock API); 0.9.1–0.9.2 → 0.1.1–0.1.2 (schema).

#### Artifact conflicts / updates needed

| Artifact | Change |
|---|---|
| All 10 `epics/phase-0/epic-0.*.md` | 5 files renamed (slug kept, number changed); every file's cross-references (frontmatter `epic:`/`resource:`, `depends_on:`, prose "Epic 0.X"/"Story 0.X.Y") rewired |
| `epics/phase-0/index.md` | Full rewrite: epics table, summaries, and Stories Summary table reordered/relabeled |
| `epics/framework.md`, `epics/fr-coverage-map.md`, `epics/requirements-inventory.md` | Cross-references rewired |
| `architecture/non-functional-requirements-coverage.md`, `architecture/repository-strategy.md`, `architecture/gaps.md`, `architecture/assumptions.md` | Cross-references rewired |
| `architecture/delivery-operating-model.md` | Illustrative epic-frontmatter/sprint-status examples rewired (see below — also fixed pre-existing staleness) |
| `architecture.md` | New decision **#16**; supersession notes added to #14/#15 (their epic numbers are left as historical record of what was true when each decision was made, per this repo's "add, don't rewrite" convention — mirroring how #12 carries a "superseded by #13" note rather than being rewritten) |
| `architecture/changelog.md` | New **v4.13** entry |
| `sprint-status.yaml` | All `epic-0.X` blocks and story slugs renumbered to match, reordered to ascending numeric order |
| `scripts/python/build_html.py` | NAV list reordered/relabeled to match |

**Not touched:** dated historical records — `changelog.md`'s v4.9–v4.12 entries, all prior dated SCPs, `implementation-readiness-report-2026-06-17.md` — left as accurate point-in-time record of what was true when written. `data-tables.md`, PRD, FR/NFR text — untouched (pure epic-numbering change).

#### Pre-existing staleness caught during the sweep

The mechanical sweep (see §3) surfaced three bugs left over from **earlier** SCPs this session, unrelated to today's renumber but fixed while already touching these files:
1. Several "Story 0.1.4" mentions (in `epic-0.0`, `epic-0.7`'s NOT-in-scope notes, `epic-0.8`'s split note, `gaps.md` G8.1) were never updated to "Story 0.8.1" when MRD split out in SCP 2026-08-24b — because that split's sweep, like this one, needs to distinguish "was called X" (historical, correctly kept as `0.1.4`) from "currently called X" (should say `0.8.1`). Both kinds now read correctly.
2. `delivery-operating-model.md`'s illustrative epic-frontmatter example still carried the **pre-retitle** title ("Upstream JOH/MRD reference data is ingested") and story count (4) from before the SCP 2026-08-24b retitle — corrected to the current title and story count (3).
3. Two **plural** "Stories 0.X.Y/0.X.Z" references (`epic-0.9-reference-data-read-only-api.md`, `epic-0.5-system-dispatches-emails.md`, `fr-coverage-map.md`'s FR1 row) were missed by both today's and the 2026-08-24b sweep's singular-form pattern-matching — found and fixed by hand.

### 3. Recommended Approach

**Direct implementation**, done via a scripted two-pass text substitution rather than manual per-file edits, to guarantee the 5-way permutation applied atomically (no risk of a sequential find-replace re-processing its own output — e.g. mapping 1→3 and then later re-mapping that same 3→9 by accident). Pass A fixed the pre-existing "Story 0.1.4" staleness first (so it couldn't collide with the epic-swap mapping); Pass B applied the 5-way swap to `epic-0.X-` (file links), bare `epic-0.X` (`depends_on` entries), `Epic 0.X` (prose), `epic: 0.X` (frontmatter), and `Story 0.X.Y` (story ids) patterns in one regex pass per file. The 5 files were then renamed via intermediate `.tmp` names to avoid collisions mid-rename (e.g. renaming 0.1→0.3 while 0.3 still existed under its old name). Every result was verified by grep — checking every referenced filename resolves to a real file, and manually reviewing every remaining "0.1.4"/"previously"/"Stories" (plural) occurrence for correctness — before writing this proposal.

**Effort:** Medium (large mechanical surface, low conceptual risk). **Risk:** Low, given the verification pass; the three pre-existing bugs it caught are evidence the verification was worth doing. **Timeline impact:** None — no story content or dependency semantics changed, only labels.

### 4. Detailed Change Proposals

See §2's tables for the full before/after mapping. Full per-file diffs are in the files themselves — given the scale (10 epic files + 9 supporting artifacts), this SCP records the mapping and verification method rather than re-pasting every changed line.

### 5. Implementation Handoff

**Scope: Moderate** — large mechanical footprint, no content/scope change, no PO/DEV coordination needed beyond the sweep itself (already done).

**Success criteria:** every `epic-0.X-slug.md` filename referenced anywhere in the live (non-historical) doc set resolves to a real file on disk (verified via `comm` diff against `ls`); every `depends_on` array's real technical dependency is preserved under its new id; `epics/phase-0/index.md`'s two summary tables agree with each other and with the individual epic files (26 stories, 10 epics); `docs/` regenerates cleanly with no dangling nav links.

---

## Sprint Change Proposal — 2026-08-25c

**Status:** proposed

> **Addendum (approved in the same turn):** the user additionally asked to place the JOH-data read-only API epic at **Epic 0.4** instead of keeping it at 0.9. Epic 0.4 was already occupied ("Both user populations are bootstrapped and verifiable against the IdP") — resolved as a minimal 2-way swap, consistent with this session's established pattern for numbering collisions (see SCP 2026-08-25b): **JOH data read-only API → Epic 0.4**; **User populations bootstrapped → Epic 0.9** (the slot the JOH-data epic vacates). The MRD-data-read-only-api epic is unaffected by this — it lands at **Epic 0.10** exactly as designed below. Every mention of "Epic 0.9" below that refers to the JOH-data-API epic should be read as **Epic 0.4** in the final implementation, and "Epic 0.4" (bootstrap) as **Epic 0.9** — this addendum is the authoritative numbering; the body below is kept as originally drafted/approved for the record rather than rewritten line-by-line.

**Trigger:** *"split epic-0.9 into 2 epics joh-data-read-only-api and mrd-data-read-only-api"*

**Clarified via two questions before drafting** (Epic 0.9 today has no MRD read endpoint at all, so a clean split wasn't mechanical):
1. **Tier-(b) placement** → stays with the **JOH-data** epic (which becomes the "main" reference-data epic — mirrors how Epic 0.3 stayed the main ETL epic when MRD split off as the narrower Epic 0.8 back in SCP 2026-08-24b).
2. **MRD API scope** → **add a new story**, not a placeholder. Epic 0.10 gets a real, designed endpoint for `mrd_specialisms`, not a stub.

**Mode:** Batch. **Scope classification:** Moderate — one new epic with genuinely new story content (an endpoint that didn't exist before), plus a cross-reference sweep.

---

### 1. Issue Summary

Epic 0.9 ("Reference data is served read-only via a versioned, jurisdiction-filtered API") bundles tier-(b) CTAM-owned tables (Story 0.9.1) and a read-only REST API (Story 0.9.2) that, on inspection, only ever defined endpoints for tier-(b) vocab (`/regions`, `/offices`, `/calendar`, `/vocabularies/{list}`) and tier-(a) **JOH** data (`/johs`, `/jurisdictions`, `/tickets`). There is no endpoint anywhere for `mrd_specialisms` (Epic 0.8's MRD ingestion target) — MRD data lands in the database but nothing reads it back out via API today. That's a real gap, not just an organisational one: any Phase 1+ service wanting JOH Specialisations would currently need direct SQL access to `ctam-reference-data`'s schema, breaking the "reads via API" pattern the rest of the read surface follows.

Splitting the epic by upstream source — mirroring the Epic 0.3 (JOH ETL) / Epic 0.8 (MRD ingestion) split already in place on the write side — gives MRD data the same API-as-Product treatment JOH data gets, instead of leaving it as a silent gap.

### 2. Impact Analysis

#### Epic impact

- **Epic 0.9** retitled **"JOH data is served read-only via a versioned, jurisdiction-filtered API"** — keeps Stories 0.9.1 (tier-(b) tables) and 0.9.2 (JOH + tier-(b) read API), content essentially unchanged (it never covered MRD), just reframed from generic "Reference data" to "JOH data" and given an explicit pointer to the new MRD epic. `depends_on` unchanged (`[epic-0.3, epic-0.7]`).
- **New Epic 0.10** — "MRD data is served read-only via a versioned, jurisdiction-filtered API" — one new story (0.10.1) adding `GET /v1/reference-data/specialisms` for `mrd_specialisms`, following the same jurisdiction-filtered/versioned/OpenAPI/RFC-9457/Postman pattern as Epic 0.9's endpoints. `depends_on: [epic-0.7, epic-0.8]` (needs auth for `JWTFilter`/jurisdiction, and Epic 0.8 for `mrd_specialisms` to exist — the JOH-ETL dependency Epic 0.9 has doesn't apply here since this epic never touches `jo_*` data).

#### Story impact

- Story 0.9.1 — unchanged.
- Story 0.9.2 — reworded from "Reference Data" to "JOH data" framing; out-of-scope note added pointing to Epic 0.10 for MRD.
- **New Story 0.10.1** — MRD read-only REST API (real content, not a stub, per your answer).

#### Artifact conflicts / updates needed

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

### 3. Recommended Approach

**Direct Adjustment** — split one epic into two, with one epic gaining a genuinely new (but small — one endpoint) story. Nothing rolls back (`sprint-status.yaml` shows Epic 0.9 fully `backlog`). No FR/NFR/PRD text changes (FR6/FR7/FR58 already covered "read API" generically; this just fills a coverage gap the epic-level text hadn't caught).

**Effort:** Low–Medium. **Risk:** Low — new story mirrors an already-proven pattern (Epic 0.9's own endpoints) closely enough that there's little design risk. **Timeline impact:** None — Epic 0.10 depends only on Epic 0.7 (auth) and Epic 0.8 (MRD ingestion), both already-planned Phase 0 epics; it doesn't block or get blocked by Epic 0.9.

### 4. Detailed Change Proposals

#### 4.1 `epic-0.9-reference-data-read-only-api.md` — retitle and reframe

**Title:** "Reference data is served read-only via a versioned, jurisdiction-filtered API" → **"JOH data is served read-only via a versioned, jurisdiction-filtered API"**

**User outcome paragraph** — reworded to say tier-(a) **JOH** data + tier-(b) CTAM-owned data (dropping the implication that "reference data" covers MRD too), with an explicit line: *"MRD-sourced data (`mrd_specialisms`) is served by a separate epic, Epic 0.10, since it wasn't covered by any endpoint here."*

**Story 0.9.2**'s AC list is otherwise unchanged (it already only ever listed JOH + tier-(b) endpoints) — just the epic-level framing changes, plus an explicit "Explicitly NOT in scope: MRD read endpoints — Epic 0.10" line.

#### 4.2 New file — `epic-0.10-mrd-data-read-only-api.md`

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

#### 4.3 `epics/phase-0/index.md`

- Epics table: retitle 0.9 row to "JOH data is served read-only via a versioned, jurisdiction-filtered API"; add row `| [0.10](epic-0.10-mrd-data-read-only-api.md) | MRD data is served read-only via a versioned, jurisdiction-filtered API | 1 | 🟡 Planned |`; total 26→27 stories.
- Epic 0.9 summary: reworded per §4.1; new Epic 0.10 summary added.
- Phase 0 Epic Stories Summary table: 0.9 row description updated to "JOH"; new 0.10 row (1 story); total 26→27 stories, "ten demos"→"eleven demos".

#### 4.4 `epics/index.md`

Phase 0 row: "🟡 Planned — 10 epics, 26 stories" → "🟡 Planned — 11 epics, 27 stories".

#### 4.5 `epics/framework.md` — Reference Data area

Append: *"The read-only API is split by upstream source: [Epic 0.9](phase-0/epic-0.9-reference-data-read-only-api.md) serves JOH data (tier-(a) + tier-(b)); [Epic 0.10](phase-0/epic-0.10-mrd-data-read-only-api.md) serves MRD data (`mrd_specialisms`) — split 2026-08-25c since no MRD read endpoint existed before."*

#### 4.6 `epics/fr-coverage-map.md`

FR6, FR7, FR58 rows: append "; MRD read surface is [Epic 0.10](phase-0/epic-0.10-mrd-data-read-only-api.md), split out 2026-08-25c" where they cite Epic 0.9's Story 0.9.2.

#### 4.7 `architecture.md` — decision log

New row:

| 17 | Reference Data read API split by upstream source: JOH (0.9) vs MRD (new 0.10) *(SCP 2026-08-25c)* | Epic 0.9's read API never actually covered `mrd_*` data — only tier-(b) vocab and tier-(a) JOH endpoints were ever specified, leaving MRD data reachable only via direct SQL. Split the epic by upstream source, mirroring the Epic 0.3 (JOH ingestion) / Epic 0.8 (MRD ingestion) write-side split: **Epic 0.9** keeps JOH + tier-(b) (unchanged content, retitled); **new Epic 0.10** adds the first `mrd_*` read endpoint (`GET /v1/reference-data/specialisms`), same API-as-Product conventions, published in the same `api-ctam-reference-data` OpenAPI artefact (one service, one contract — no new repo or deployable). See [`./sprint-change-proposal-2026-08-25.md#sprint-change-proposal-2026-08-25c`](./sprint-change-proposal-2026-08-25.md#sprint-change-proposal-2026-08-25c). |

#### 4.8 `architecture/changelog.md`

New version entry (v4.14) summarising the split and the new-scope MRD endpoint.

#### 4.9 `sprint-status.yaml`

Append:

```yaml
  epic-0.10: backlog
  0-10-1-mrd-data-read-only-rest-api-with-jurisdiction-filtering-versioning-openapi-rfc-9457-errors: backlog
  epic-0.10-retrospective: optional
```

(Epic 0.9's own block is unchanged — same two stories, same slugs.)

#### 4.10 `scripts/python/build_html.py`

NAV: retitle the Epic 0.9 entry; add an Epic 0.10 entry after it.

### 5. Implementation Handoff

**Scope: Moderate** — one new epic with real (if small) new story content, plus a cross-reference sweep. Routed as **Product Owner / Developer**.

**Success criteria:** Epic 0.9 and Epic 0.10 are each internally consistent; `epics/phase-0/index.md`'s two summary tables agree (27 stories, 11 epics); `docs/` regenerates cleanly with Epic 0.10 reachable from the nav; `data-tables.md` unchanged (no new table — this only adds a read endpoint over the existing `mrd_specialisms`).

---

## Sprint Change Proposal — 2026-08-25d

**Status:** approved

**Trigger:** *"retain the epics from 0.0,0.1,0.2,0.3,0.4 and remove all the other epics"*, followed by *"update all the files based on latest changes"* after the initial clarifying questions were declined.

**Mode:** Batch. **Scope classification:** **Major** — this removes real product scope (auth, notification, MRD, user bootstrap) from Phase 0, not just relabeling. Routed as recorded below.

---

### 1. Issue Summary

The team wants Phase 0 narrowed to just epics 0.0–0.4 — the platform estate and the JOH data pipeline (schema, mock API, ETL, read API) — with everything else removed. This is not a pure numbering exercise like the previous several SCPs this session: two of the epics being removed are genuine dependencies of epics being kept:

1. **Epic 0.1** (JOH schema) and **Epic 0.3** (JOH ETL) both `depends_on: epic-0.6` — the context bus (published architecture submodule) and the shared `ctam_configuration_values` baseline table.
2. **Epic 0.4** (JOH data read API)'s stories require `JWTFilter`-protected, jurisdiction-filtered endpoints, sourced from **Epic 0.7** (User authenticates).

I asked clarifying questions about how to resolve these two breaks and about whether "remove" meant permanent deletion or deferral; the questions were declined and the follow-up instruction was to proceed and keep everything else consistent. I resolved the two breaks using the options I'd flagged as recommended:

1. **Context bus folded into Epic 0.0** — its two stories become Stories 0.0.6–0.0.7. This is not just relabeling: Story 0.6.1 (publish `ctam-architecture` as the context bus, tag `arch-v1.0`) was recorded `done` in `sprint-status.yaml` — that status carries forward as Story 0.0.6, it is not reset to `backlog`.
2. **Epic 0.4's read API simplified to open/unauthenticated** — `JWTFilter` protection and jurisdiction-filtering are removed from its acceptance criteria, with an explicit note that re-adding them later (when an auth epic returns) is additive, not a redesign.

### 2. Impact Analysis

#### Epics removed (files deleted, git history retains them)

| Epic | Title | Stories | What happens to its scope |
|---|---|---|---|
| 0.5 | Notification service is scaffolded and contractually ready | 2 | FR9 unimplemented; downstream consumers (booking/absence acks, payment-schedule dispatch) blocked until re-planned |
| 0.6 | Context bus is published and the shared configuration baseline exists | 2 | **Folded into Epic 0.0**, not lost — Stories 0.0.6–0.0.7, `done` status preserved |
| 0.7 | User authenticates and lands on a role-scoped Home page | 5 | FR1–FR3, FR55, FR56, FR58 (auth half) unimplemented; Epic 0.4's API loses auth protection as a direct consequence |
| 0.8 | MRD supplementary reference data is ingested | 1 | `mrd_*` ingestion unimplemented; MRD read API (0.10) loses its data source |
| 0.9 | Both user populations are bootstrapped and verifiable against the IdP | 1 | FR4, FR57 unimplemented |
| 0.10 | MRD data is served read-only via a versioned, jurisdiction-filtered API | 1 | Removed along with its data source (Epic 0.8) |

**Total removed: 12 stories.** Phase 0 goes from 11 epics / 27 stories to **5 epics / 17 stories** (the +2 from folding Epic 0.6 into Epic 0.0 is why it isn't 15).

#### Epics kept, and what changed in them

- **Epic 0.0** — gains Stories 0.0.6–0.0.7 (folded from 0.6), `repo:` becomes a list (`[ctam-shared-infrastructure, ctam-architecture]`), storyCount 5→7.
- **Epic 0.1** — `depends_on` drops `epic-0.6`, now `[epic-0.0, epic-0.3]` (the context bus dependency now resolves through Epic 0.0).
- **Epic 0.2** — unaffected (no cross-references to removed epics).
- **Epic 0.3** — `depends_on` drops `epic-0.6`, now `[epic-0.0]`. All MRD and auth cross-references reworded to reflect their removal (not deletion of the ETL epic's own content — its 3 stories are unchanged).
- **Epic 0.4** — `depends_on` drops `epic-0.7`, now `[epic-0.3]`. Story 0.4.2 rewritten: drops `JWTFilter` protection, jurisdiction-filtering, the 401 Postman case, and the MRD-specific NFR13/NFR12 references. Title drops "jurisdiction-filtered." Explicit scope-reduction note added.

#### Artifact sweep

| Artifact | Change |
|---|---|
| 6 epic files | Deleted |
| `epic-0.0-platform-estate-provisioned.md` | +2 stories (0.0.6–0.0.7), `repo:` → list, scope-reduction note |
| `epic-0.1-postgres-sql-schema-design.md` | `depends_on` fixed, context-bus reference updated to Epic 0.0 |
| `epic-0.3-joh-reference-data-etl-process.md` | `depends_on` fixed; MRD/auth cross-references reworded throughout; one Story 0.3.3 AC reworded (no longer references the removed authorisation service for verification) |
| `epic-0.4-joh-data-read-only-api.md` | `depends_on` fixed; retitled; Story 0.4.2 rewritten to open/unauthenticated; scope-reduction notes added |
| `epics/phase-0/index.md` | Full rewrite: 5 epics, 17 stories |
| `epics/index.md` | Phase 0 count: 5 epics, 17 stories |
| `epics/framework.md` | Phase 0 Areas without a concrete epic marked as such (not deleted — they're still the architectural map); dependency-order table and parallelism note fixed |
| `epics/fr-coverage-map.md` | FR1–FR4, FR9, FR55–FR58 (partial), FR57 marked ⚪ not currently delivered (not deleted — real PRD requirements) |
| `epics/requirements-inventory.md` | MRD storage cross-reference marked not-currently-provisioned |
| `architecture/non-functional-requirements-coverage.md` | NFR24 narrowed to JOH-only |
| `architecture/repository-strategy.md` | `ctam-reference-data` row: MRD/auth cross-references removed |
| `architecture/gaps.md` | G8.1: MRD half marked untracked (gap itself not closed) |
| `architecture/delivery-operating-model.md` | Illustrative examples referencing removed epics swapped for still-valid ones |
| `architecture.md` | New decision **#18** |
| `architecture/changelog.md` | New **v4.15** entry |
| `sprint-status.yaml` | 6 epic blocks removed; Epic 0.0 gains Stories 0.0.6 (**`done`**, carried forward) and 0.0.7; incidental fix of a stale "16-repo" comment to "17-repo" |
| `scripts/python/build_html.py` | NAV: 6 entries removed, Epic 0.0's story count updated |

**Not touched:** dated historical SCPs/changelog entries (immutable record of what was true when written); `data-tables.md` (schema for removed epics' tables is unaffected — the tables just aren't being created by an active epic right now).

### 3. Recommended Approach

**Direct implementation** (the two clarifying questions were declined, so I proceeded using the recommended defaults I'd already identified, rather than blocking further). Deletion was judged safe to do literally (not just deferred) because: this branch's prior commit is already pushed to the remote PR, so the removed epics' content remains fully recoverable via git history without needing an in-repo "deferred" holding area.

**Effort:** High (large mechanical sweep). **Risk:** Medium — this is a real scope cut, not a relabel; FR1–FR4, FR9, FR55–58, FR57 genuinely lose Phase 0 coverage and are flagged as such rather than silently dropped. **Timeline impact:** Reduces Phase 0's build scope by roughly 44% of its stories (12 of 27); nothing currently in flight was disrupted (`sprint-status.yaml` showed only Story 0.6.1 as `done`, now carried forward as 0.0.6).

### 4. Detailed Change Proposals

See §2 for the full before/after mapping. Full diffs are in the files themselves.

### 5. Implementation Handoff

**Scope: Major** — real functional scope removed from an active plan, not a backlog reorganisation. Per the workflow's own classification this would normally route to Product Manager / Solution Architect for a fundamental replan; it was executed directly here per explicit, repeated user instruction (the clarifying questions that would normally precede PM/Architect-level judgment were declined twice).

**Responsibilities:**
- **Product Owner / stakeholders:** confirm this scope cut is intended for the demo/milestone this narrower Phase 0 is meant to support, and decide when (if ever) auth, notification, MRD, and user bootstrap should be re-planned as new epics.
- **This session:** all edits above applied directly; `docs/` regenerated; nothing committed without being asked.

**Success criteria:** all 5 remaining epic files are internally consistent (no dangling references to removed epics); `depends_on` arrays across the 5 epics resolve only to each other; `epics/phase-0/index.md`'s two summary tables agree (17 stories, 5 epics); `fr-coverage-map.md` accurately marks every FR that lost coverage; `docs/` regenerates cleanly with no dangling nav links to deleted epic pages.

---

## Sprint Change Proposal — 2026-08-25f

**Status:** approved

**Trigger:** *"we are deploying the service in local environment remove the dependency on 0.0"*, following a `/bmad-help` exchange about why Epic 0.2 depends on Epic 0.0.

**Mode:** Batch. **Scope classification:** **Moderate** — a deployment-target narrowing within one epic, not a functional cut.

---

### 1. Issue Summary

Epic 0.2 (`ctam-jomockapi`, the JOH eLinks mock API) previously deployed to the shared dev/staging Azure estate (AKS, ACR, Key Vault, APIM) so that `ctam-reference-data`'s eLinks sync could reach it over the network in a shared environment — this was the epic's entire reason for `depends_on: [epic-0.0]`. The team is instead running these services locally during development. Since the mock is never deployed anywhere but a developer's machine in this scope, the shared-estate dependency is not just unnecessary — it doesn't correspond to anything the epic actually does anymore, so it's removed.

### 2. Impact Analysis

#### What changed

- **Epic 0.2** — `depends_on` drops from `[epic-0.0]` to `[]`. Story 0.2.2 rewritten from "Deploy `ctam-jomockapi` onto the shared dev/staging estate" (Helm chart, AKS, Key Vault-held credential) to "Run `ctam-jomockapi` locally via Docker Compose" (a `docker-compose.yml` service, a local `.env` credential). Story 0.2.3 rewritten from "...runs against the deployed mock in dev/staging" to "...runs against the locally-running mock" — the demonstrability claim narrows from "dev/staging" to "local development." Story 0.2.1 (onboarding) is adjusted to drop the ACR registry push and any Helm/deploy-workflow scaffolding, since nothing in this epic deploys anywhere shared.
- **Epic 0.3** — Story 0.3.3's AC block that pointed the sync's "dev/staging base URL" at Epic 0.2's deployed mock is reworded to point the sync's *local* base URL at the locally-running mock instead.
- **NFR16 (Key Vault), NFR31 (Azure UK South), NFR40 (per-service deployable)** — no longer exercised by Epic 0.2 at all (nothing is deployed to the shared estate from this epic). **NFR24**'s "exercised end-to-end pre-contract" claim narrows from a dev/staging demonstration to a local-only one.
- **gaps.md G8.1** and **non-functional-requirements-coverage.md's NFR24 entry** — reworded to say the mock unblock is local, not dev/staging. G8.1 itself (the real eLinks contract confirmation) stays open regardless — unaffected by where the mock runs.

#### Artifact sweep

| Artifact | Change |
|---|---|
| `epic-0.2-joh-elinks-mock-api-stands-in.md` | `depends_on` → `[]`; scope-reduction note added; Hosting/vertical-slice/out-of-scope reworded; Story 0.2.1 (registry push dropped), 0.2.2 (full rewrite to Docker Compose), 0.2.3 (full rewrite to "locally-running mock") |
| `epic-0.3-joh-reference-data-etl-process.md` | Story 0.3.3's mock-target AC reworded from dev/staging to local |
| `epics/phase-0/index.md` | Epic 0.2 summary, sequencing note, Phase 0 Epic Stories Summary table rows for 0.2 and 0.3 |
| `epics/framework.md` | Ingestion area note (Epic 0.2's mock target reworded) |
| `epics/fr-coverage-map.md` | NFR24 row |
| `architecture/gaps.md` | G8.1 |
| `architecture/non-functional-requirements-coverage.md` | NFR24 entry |
| `architecture/repository-strategy.md` | `ctam-jomockapi` row |
| `architecture/assumptions.md` | A38 |
| `architecture/delivery-operating-model.md` | Parallelism illustration (Epic 0.2 has no epic dependency, not "needs only the estate") |
| `architecture.md` | New decision **#19** |
| `architecture/changelog.md` | New **v4.16** entry |
| `sprint-status.yaml` | Epic 0.2's Story 0.2.2/0.2.3 slugs renamed to match the rewritten titles |

**Not touched:** dated historical SCPs/changelog entries and decision-log rows (immutable record); Epic 0.0, 0.1, 0.4 (unaffected — this change is scoped to Epic 0.2 and the one cross-reference in Epic 0.3).

### 3. Recommended Approach

**Direct implementation.** Effort: **Low-Medium** (one epic's deployment model changes, with a small ripple into Epic 0.3's one AC block and several NFR/gap cross-references). **Risk:** Low — nothing was `done` on this epic yet (`epic-0.2: backlog`), so no completed work is disrupted; the real eLinks contract gap (G8.1) is explicitly unaffected.

### 4. Detailed Change Proposals

See §2 for the full before/after mapping. Full diffs are in the files themselves.

### 5. Implementation Handoff

**Scope: Moderate** — one epic's deployment target changes, with cross-references updated to match; not a functional cut.

**Responsibilities:**
- **Product Owner / stakeholders:** confirm local-only is acceptable for Phase 0's demoability goal for this integration — if a shared dev/staging demonstration is later needed, a future epic can add it back (Epic 0.2's out-of-scope note says so explicitly).
- **This session:** all edits above applied directly; nothing committed without being asked.

**Success criteria:** Epic 0.2's `depends_on` is `[]` and every AC in its 3 stories consistently describes a local Docker Compose flow, not a shared-estate deployment; Epic 0.3's Story 0.3.3 cross-reference matches; no remaining "dev/staging" claim tied to this mock anywhere in the sweep list above; `docs/` regenerates cleanly.

---

## Sprint Change Proposal — 2026-08-25g

**Status:** approved

**Trigger:** *"Modify epic-0.2 to build the joh-elinks-mock-api using java springboot applications instead of npm"*.

**Mode:** Batch. **Scope classification:** **Minor** — a build-stack change within Epic 0.2's own repo; no cross-epic dependency, FR/NFR, or PRD impact.

---

### 1. Issue Summary

Epic 0.2's `ctam-jomockapi` was previously scoped as an explicitly-recorded deviation from CTAM Pathfinder's Java/Spring Boot stack baseline (assumptions.md A38) — the existing Node.js/Express codebase at the real `ctam-jomockapi` repo was to be onboarded as-is, justified because it delivers no FR/NFR and never reaches production (mirroring `ctam-mock-auth`'s non-production-only exemption). The team now wants it built with Java/Spring Boot instead, like every other CTAM Pathfinder service — removing that stack deviation entirely.

### 2. Impact Analysis

#### What changed

- **Story 0.2.1** — retitled from "Onboard `ctam-jomockapi` as a CTAM Pathfinder repo" to "Scaffold `ctam-jomockapi` from the HMCTS starter and port the eLinks mock to Java/Spring Boot." Its ACs are rewritten around `ctam-scaffold.sh` (same pattern as `ctam-reference-data`/`ctam-joh`'s scaffold stories): Spring Boot 4.0.x, Gradle Groovy DSL, Group ID `uk.gov.hmcts.ctam`, artefact `ctam-jomockapi`, base package `uk.gov.hmcts.ctam.jomockapi`, port `8090`. The existing Node/Express reference implementation's documented contract — endpoints, fixed-seed data generation, bearer-token handling, the `ReferenceData/*.csv|json` fixtures — is explicitly scoped as a **faithful port**, not a redesign: same request/response shapes, same seed data, same auth behaviour.
- **Deliberately excluded**, unlike every domain service: Liquibase, Testcontainers PostgreSQL, MapStruct (the mock is stateless — no database, no cross-object mapping need), and a Helm chart / per-service Terraform (it still never deploys anywhere but locally, per SCP 2026-08-25f).
- **Story 0.2.2** — updated for the new stack: port references change from Node's `4000` to the new service's `8090`; the `npm start` comparison in the story's "so that" clause becomes `./gradlew bootRun`.
- **Story 0.2.3** — unaffected; it never referenced Node/npm specifically, only "the local instance," which is stack-agnostic.
- **Epic 0.2's Hosting/vertical-slice/out-of-scope sections** — the "standalone Node.js/Express service — an explicitly-scoped deviation" framing is replaced with "scaffolded like every other CTAM Pathfinder backend service — no stack deviation." The old out-of-scope bullet "Rewriting `ctam-jomockapi` in Java/Spring — it stays Node/Express as already built" is **removed** (it's now the literal opposite of what this epic does) and replaced with two new exclusions: no behavioural contract change during the port, and no database of any kind.
- **assumptions.md A38** — revised in place (not superseded via a new row — this is a living reference document, not a dated record) to describe the Java/Spring Boot build instead of the Node/Express deviation.
- **repository-strategy.md's `ctam-jomockapi` row** — revised to describe a Java/Spring Boot service scaffolded via `ctam-scaffold.sh`, ported from an earlier Node/Express reference implementation.

#### Artifact sweep

| Artifact | Change |
|---|---|
| `epic-0.2-joh-elinks-mock-api-stands-in.md` | Stack-change scope-reduction note added; description/User outcome/Hosting/vertical-slice/out-of-scope reworded; Story 0.2.1 fully rewritten (scaffold + faithful port); Story 0.2.2 updated (port 8090, `./gradlew bootRun`) |
| `architecture/assumptions.md` | A38 revised in place |
| `architecture/repository-strategy.md` | `ctam-jomockapi` row revised |
| `architecture.md` | New decision **#20** |
| `architecture/changelog.md` | New **v4.17** entry |
| `sprint-status.yaml` | Story 0.2.1's slug renamed to match the new title |

**Not touched:** `epic-0.3` (its Story 0.3.3 cross-reference to Epic 0.2 doesn't name a tech stack, so it's unaffected by this change — it was already updated for the local-vs-dev/staging change in SCP 2026-08-25f); Story 0.2.3 (stack-agnostic); gaps.md G8.1 (doesn't mention tech stack); `epics/framework.md` (its Epic 0.2 mention doesn't name a stack either); FR/NFR coverage (this mock delivers no FR/NFR directly, unaffected); dated historical SCPs/changelog entries (immutable record).

### 3. Recommended Approach

**Direct implementation.** Effort: **Low** — one story rewritten, one story lightly touched, two reference docs updated in place. **Risk:** Low — `epic-0.2: backlog` in `sprint-status.yaml`, nothing built yet against the old Node-based plan; the actual `ctam-jomockapi` codebase on disk (a real, already-built Node/Express app) is unaffected by this planning-repo change until Story 0.2.1 is actually dispatched and executed against it — at which point the story now instructs a fresh Java/Spring Boot scaffold with the existing app treated as a reference implementation to port, not a codebase to onboard verbatim.

### 4. Detailed Change Proposals

See §2 for the full before/after mapping. Full diffs are in the files themselves.

### 5. Implementation Handoff

**Scope: Minor** — a build-stack change within one epic's own scope, no cross-epic ripple beyond what SCP 2026-08-25f already touched.

**Responsibilities:**
- **Product Owner / stakeholders:** confirm the Java/Spring Boot port is worth the engineering effort versus keeping the existing, already-working Node/Express mock — this SCP does not weigh that trade-off, it only encodes the decision as given.
- **This session:** all edits above applied directly; nothing committed without being asked.

**Success criteria:** Epic 0.2 no longer mentions Node.js/Express as its build stack anywhere except as the explicit port-source; Story 0.2.1's ACs consistently describe a `ctam-scaffold.sh`-based Spring Boot scaffold with a faithful contract port, not an onboarding of the existing codebase as-is; assumptions.md A38 and repository-strategy.md's `ctam-jomockapi` row agree with the epic; `docs/` regenerates cleanly.

---

## Sprint Change Proposal — 2026-08-25h

**Status:** approved

**Trigger:** *"review all the 5 epics and suggest if there are any changes"*, followed by *"fix all the above inconsistencies"* after the review was presented.

**Mode:** Batch. **Scope classification:** **Minor** — documentation/citation fixes within existing epics; no scope change, no FR/NFR change, no `depends_on` change.

---

### 1. Issue Summary

A full read-through of all 5 Phase 0 epics (0.0–0.4) — prompted by a request to review them for consistency — surfaced five concrete inconsistencies, none caught by the narrower per-round sweeps in earlier SCPs because they cut across epics rather than living inside the one epic each prior SCP touched.

### 2. Impact Analysis

#### Finding 1 — Port collision between `ctam-joh` and `ctam-reference-data`

Story 0.1.1 and Story 0.3.1 both hardcoded "default port is 8082 (per AR3)," and AR3 itself just says "Default port 8082" with no per-service override. Two services scaffolded from the same rule would collide the moment they run side by side (locally, or in a cluster without an explicit override).

**Fix:** AR3 revised to say each service gets its own distinct port, starting from 8082 and incrementing per service in scaffold order. `ctam-joh` moves to **8083**; `ctam-reference-data` keeps **8082** (it was scaffolded first, and is referenced by port number in several other places — moving it would have a larger ripple for no benefit); `ctam-jomockapi`'s existing 8090 is called out as consistent with this pattern.

#### Finding 2 — FR8 double-attributed

Epic 0.3's "FRs covered" line claimed *"FR8 (shared `ctam_configuration_values` baseline first lands here)"* — but `fr-coverage-map.md` and Epic 0.0 Story 0.0.7 both correctly show Epic 0.0 as the epic that creates that table. Epic 0.3 only verifies the table is reachable before `ctam-reference-data` proceeds (Story 0.3.1's AC); it doesn't deliver FR8.

**Fix:** Epic 0.3's "FRs covered" line drops the FR8 claim and adds a parenthetical: *"FR8 is delivered by Epic 0.0, Story 0.0.7 — this epic only consumes/verifies the shared baseline."*

#### Finding 3 — Wrong story citation in Epic 0.4, Story 0.4.1

Its lead AC said *"Given `ctam-reference-data` is scaffolded and carries the tier-(a) tables per Story 0.3.3"* — Story 0.3.3 is the nightly sync (populates data); the tables themselves are created in **Story 0.3.2**. Story 0.4.1 only needs the tables to exist (to keep tier-(b) tables separate from them), not populated data.

**Fix:** Citation corrected to Story 0.3.2, with a parenthetical explaining why (doesn't need the sync to have run).

#### Finding 4 — `ctam_joh_identities` never explicitly created

Story 0.3.2's changeset AC enumerated exactly the 15 `jo_*` tables plus `ctam_sync_status` — `ctam_joh_identities` appeared nowhere in either list, despite Story 0.3.3 minting rows into it, Epic 0.1's Story 0.1.2 citing it as an existing FK target (correctly, citing Story 0.3.2), and Epic 0.3's own prose describing binding `personnel_number` to it.

**Fix:** Story 0.3.2's changeset AC now explicitly creates `ctam_joh_identities` (`id uuid PK`, `personnel_number` unique, `created_at`/`updated_at`), stating it's created empty here and populated row-by-row by Story 0.3.3's sync.

#### Finding 5 — Local mock vs. AKS-deployed `ctam-reference-data` unreconciled

Epic 0.2's `ctam-jomockapi` runs **only locally** via Docker Compose (SCP 2026-08-25f). Story 0.3.3's mock-integration AC pointed the sync's "local base URL" at it — but Story 0.3.1 (same epic) also deploys `ctam-reference-data` to the shared AKS dev cluster, and an AKS pod has no network path to a developer's Docker Compose network. Nothing said which run-mode of `ctam-reference-data` the mock-integration AC exercises.

**Fix:** The AC now states explicitly that it exercises `ctam-reference-data` run locally too (`./gradlew bootRun` alongside `docker-compose up`, per Story 0.3.1's local-verification AC) — **not** the AKS-deployed instance.

#### Not fixed — raised as an open question instead

A sixth observation from the review: Epic 0.0 still provisions a full Terraform shared Azure estate (5 stories) for the domain services, while Epic 0.2 just moved to local-only for its mock. Whether that split is intentional (mocks stay local forever; domain services need a real shared environment eventually) or whether the team's local-first practice should extend further is a product/architecture call, not a documentation bug — left open for the user to decide, not fixed here.

#### Artifact sweep

| Artifact | Change |
|---|---|
| `epics/requirements-inventory.md` | AR3 reworded — per-service distinct ports |
| `epic-0.1-postgres-sql-schema-design.md` | Story 0.1.1 port 8082 → 8083 |
| `epic-0.3-joh-reference-data-etl-process.md` | FR8 attribution reworded; `ctam_joh_identities` added to Story 0.3.2's changeset; Story 0.3.3's mock-integration AC clarified (local `ctam-reference-data`, not AKS) |
| `epic-0.4-joh-data-read-only-api.md` | Story 0.4.1's prerequisite citation fixed (0.3.3 → 0.3.2) |
| `architecture.md` | New decision **#21** |
| `architecture/changelog.md` | New **v4.18** entry |

**Not touched:** `epic-0.0`, `epic-0.2` (no findings against them beyond the open question); `fr-coverage-map.md` (already correctly attributed FR8 to Epic 0.0 — Epic 0.3 was the one out of step, now fixed to match); `sprint-status.yaml` (no story added/removed/renamed — only AC text and one port number changed within existing stories); dated historical SCPs/changelog entries (immutable record).

### 3. Recommended Approach

**Direct implementation.** Effort: **Low** — five targeted text edits across three epic files plus one requirements-inventory row, no structural change. **Risk:** Very low — nothing here changes `depends_on`, FR/NFR coverage, or story counts; it only corrects citations, a port number, and an implicit-but-undocumented table creation to match what other stories already assumed.

### 4. Detailed Change Proposals

See §2 for the full before/after mapping. Full diffs are in the files themselves.

### 5. Implementation Handoff

**Scope: Minor** — documentation/citation corrections within the existing plan, no scope or dependency change.

**Responsibilities:**
- **This session:** all edits above applied directly; nothing committed without being asked.
- **Product Owner / Architect (deferred):** decide the open question above — whether Epic 0.0's shared-estate scope should also narrow toward local-first for Phase 0, or stays as-is for the real domain services. Not gating on this SCP.

**Success criteria:** no two Phase 0 services share a hardcoded port; Epic 0.3's FR8 claim matches `fr-coverage-map.md` and Epic 0.0; every story citation in Epic 0.4 points at the story that actually delivers what it depends on; `ctam_joh_identities` has an explicit creation point before anything reads or writes it; Story 0.3.3's mock-integration AC is unambiguous about which `ctam-reference-data` run-mode it exercises.

---

## Sprint Change Proposal — 2026-08-25i

**Status:** approved

**Trigger:** *"review all epics in phase-0"* — a second review pass, following SCP 2026-08-25h's fixes from the first pass.

**Mode:** Batch. **Scope classification:** **Minor** — documentation/citation fixes within existing epics; no scope, FR/NFR, or dependency change.

---

### 1. Issue Summary

A second full review of all 5 Phase 0 epics was requested. Rather than re-checking the same epic-to-epic cross-references already fixed in SCP 2026-08-25h, this pass cross-checked each epic's claims against the two documents epics are supposed to be *derived from*: `architecture/data-tables.md` (the canonical table inventory) and `requirements-inventory.md`'s AR list (the canonical architecture-rule numbering). That angle surfaced two more issues neither epic-to-epic comparison nor the first pass had caught.

### 2. Impact Analysis

#### Finding 6 — `ctam_joh_identities` grant breadth understated

`data-tables.md` documents `ctam_joh_identities` explicitly: *"SELECT-granted to every domain service"* — listing Authorisation, JOH, Absence, Booking, Sitting, Itinerary, and MI Feed as key consumers, because it's the JOH identity spine every domain table keys off of (`joh_id` → `ctam_joh_identities.id`). Story 0.3.2's grants AC (which SCP 2026-08-25h had just extended to also *create* this table) only said SELECT grants exist "for `ctam_joh` (schema composition, Epic 0.1) and placeholder roles for future services" — correct for the `jo_*` tables, but understating `ctam_joh_identities`'s actual grant scope, which isn't `ctam_joh`-specific at all.

**Fix:** Story 0.3.2's grants AC now states explicitly that `ctam_joh_identities` is SELECT-granted to *every* current and placeholder domain service DB role, quoting `data-tables.md`'s own language, and the fitness-function AC now verifies grant breadth as well as the tier-(a) write-protection rule.

#### Finding 7 — AR52 mis-cited for the WireMock/stub testing convention

Three places cite "AR52" for `ctam-reference-data`'s CI-only WireMock/stub eLinks API pattern: Epic 0.3's Story 0.3.3 AC, and Epic 0.2's Story 0.2.3 AC plus its References line. But AR52 in `requirements-inventory.md` is actually: *"User and authorisation records... are strictly CTAM-internal, populated by programme-management / operational mechanisms..."* — completely unrelated to WireMock or eLinks testing. Searching the whole `requirements-inventory.md` for "WireMock" turned up nothing — no architecture rule anywhere actually documents this testing convention, despite three stories treating it as an established, numbered rule.

**Fix:** Added **AR54** to `requirements-inventory.md`, describing the WireMock/stub convention and its relationship to Epic 0.2's locally-run mock (complementary — fast hermetic CI checks vs. a realistic local network target, not a replacement of one by the other). Corrected all three stale "AR52" citations to "AR54," and completed Story 0.3.3's References line, which cited AR46/AR48/AR49 but had omitted AR54/AR52 entirely even though its own AC body referenced it.

#### Artifact sweep

| Artifact | Change |
|---|---|
| `epics/requirements-inventory.md` | New **AR54** added (CI-only WireMock/stub eLinks API convention) |
| `epic-0.3-joh-reference-data-etl-process.md` | Story 0.3.2's grants AC extended for `ctam_joh_identities` breadth; Story 0.3.3's AR52 → AR54 citation fixed; Story 0.3.3's References line completed with AR54 |
| `epic-0.2-joh-elinks-mock-api-stands-in.md` | Story 0.2.3's AR52 → AR54 citation fixed (AC body + References line) |
| `architecture.md` | New decision **#22** |
| `architecture/changelog.md` | New **v4.19** entry |

**Not touched:** `epic-0.0`, `epic-0.1`, `epic-0.4` (no findings against them this pass); `sprint-status.yaml` (no story added/removed/renamed); `fr-coverage-map.md`, `gaps.md`, `assumptions.md` (checked, no discrepancy found this pass); dated historical SCPs/changelog entries (immutable record).

### 3. Recommended Approach

**Direct implementation.** Effort: **Low** — two targeted fixes, one new AR entry, four citation corrections. **Risk:** Very low — no structural change; both fixes make documentation match what other parts of the same epics (and `data-tables.md`) already assumed was true.

### 4. Detailed Change Proposals

See §2 for the full before/after mapping. Full diffs are in the files themselves.

### 5. Implementation Handoff

**Scope: Minor** — documentation/citation corrections within the existing plan, no scope or dependency change.

**Responsibilities:**
- **This session:** all edits above applied directly; nothing committed without being asked.

**Success criteria:** `ctam_joh_identities`'s documented grant scope in Story 0.3.2 matches `data-tables.md`'s "every domain service" note; every citation of the WireMock/stub convention across Epic 0.2 and Epic 0.3 points at a real, existing AR (AR54); Story 0.3.3's References line lists every AR its own ACs actually cite.

---

## Sprint Change Proposal — 2026-08-25j

**Status:** approved

**Trigger:** User request — two Confluence pages (`3.2.1.1 CTAM JO Schema`, `3.2.1.2 CTAM Schema and Source Mapping`) document how the JOH eLinks integration schema was designed; the user wants CTAM's own PostgreSQL schema designed "in the similar way," with Epic 0.1 updated and new stories authored for it.

**Mode:** Incremental (single artifact, iterated live with the user). **Scope classification:** **Moderate** — epic content is substantially rewritten (2 → 4 stories) and Phase 0 story totals shift, but no PRD/FR/NFR change, no new table, no new repo, no dependency-graph change.

---

### 1. Issue Summary

The user supplied two internal HMCTS Confluence pages under the JUDIT space:

- `3.2.1.1 CTAM JO Schema` — ER diagrams (full + transactional-core) for the JOH eLinks integration.
- `3.2.1.2 CTAM Schema and Source Mapping` — the same schema's design decisions (naming, JOH lifecycle, deprecated-attribute exclusion, sync metadata, FK strategy, a documented edge case), a 16-table list, a full column-level mapping per table (CTAM column / type / PK-FK / source attribute / description), a refresh-strategy note, 8 numbered data warnings, and 13 numbered open questions (11 closed, 2 open).

Both pages are behind HMCTS's internal `tools.hmcts.net` Confluence, unreachable from this environment; the user exported them to PDF, which were read in full and distilled to `_bmad-output/source-docs/joh-schema-confluence/`.

Cross-checking the source pages against the current architecture surfaced a structural fact the user's request needed reconciling with: the 16 tables these pages describe are the **tier-(a) `jo_*` upstream-replica schema**, which `architecture/data-tables.md` and decision D3/D9 already assign to **`ctam-reference-data` / Epic 0.3** (Story 0.3.2) — a different repo and a different, non-overlapping table set from **Epic 0.1**'s 5 CTAM-owned tier-(b) `ctam-joh` overlay tables (`ctam_working_patterns`, `ctam_working_pattern_days`, `ctam_joh_ticket`, `ctam_joh_location`, `ctam_jurisdictional_splits`). Duplicating `jo_*` table definitions into Epic 0.1 would put tier-(a) DDL in the wrong repo and break the single-writer tier-ownership rule (AR49: only `ctam_reference_data` holds INSERT/UPDATE on `jo_*`).

The user, on hearing this, directed: keep the update on Epic 0.1, and design `ctam-joh`'s own schema **the same way** the source pages design theirs — i.e. adopt the *documentation rigor* (design-decisions doc → ER diagram → column-level spec → data-warnings/open-questions doc), not the specific `jo_*` tables. This SCP implements that direction.

### 2. Impact Analysis

#### Epic Impact

**Epic 0.1** (`epic-0.1-postgres-sql-schema-design.md`) — substantially rewritten:
- Story count: 2 → 4.
- Story 0.1.1 (scaffold `ctam-joh`) — unchanged content; forward-references to "Story 0.1.2" for table creation corrected to point at the new Story 0.1.3.
- **New Story 0.1.2** — a schema design-decisions doc (`architecture/ctam-joh-schema-design.md`), covering naming/PK/FK conventions, the `ctam_jurisdictional_splits` cross-row invariant decision (carried forward verbatim from the old Story 0.1.2's AC), the tier-(b)-vocabulary FK verification gate (also carried forward), and an explicit restatement of the grant model.
- **Story 0.1.3** (rewritten from the old Story 0.1.2) — the actual DDL, now paired with a D2+ELK ER diagram (house standard, `CLAUDE.md`) and a full column-level reference per table, mirroring the source pages' own column-mapping tables (minus a "source attribute" column, since these are CTAM-native tables with no upstream source).
- **New Story 0.1.4** — a data-warnings/open-questions companion doc, mirroring the source pages' §5–6, seeded with three concrete warning candidates specific to `ctam-joh`'s overlay tables (soft-delete parity on upstream leaver/deleted, split re-validation timing, overlay reconciliation against the tier-(a) baseline).
- Epic-level frontmatter (`description`, `storyCount`), vertical-slice bullets, and out-of-scope note updated to match.

**Epic 0.3** (`ctam-reference-data`, tier-(a) `jo_*` tables) — **not touched by this SCP.** Its Story 0.3.2 already lists the correct 15 `jo_*` table names (matching the source pages' table list exactly) but has no column-level detail. The source pages could supply that detail and may partially close `gaps.md` G8.1 (previously: "the JOH eLinks API contract... is unconfirmed" — these pages are sourced from "eLinks (a.k.a. JHR) REST API, Data Dictionary v2.0, 2025-07-02," i.e. a real, dated contract artefact). This is flagged as a follow-up, not actioned here, since the user's request was explicitly scoped to Epic 0.1.

**`data-tables.md`** — not touched. Its `jo_*` and `ctam-joh` sections both remain accurate at the level of detail they already carry (table names + one-line descriptions); this SCP adds column-level detail to Epic 0.1's own doc set, not to this shard.

#### A naming question surfaced, deliberately not resolved here

The source pages' real natural-key column is `jo_people.personal_code` (VARCHAR(32)) — but 27 files across this repo (PRD, `architecture.md`, `conventions.md`, every Phase-0 epic, decision D9) use `personnel_number` for the same concept, and `personal_code` appears nowhere in the current repo. This is a `jo_*`/Epic 0.3 concern, not an Epic 0.1 one (Epic 0.1's own tables reference `ctam_joh_identities.id` via `joh_id`, never `personnel_number` directly, so the rename — if made — would not change any Epic 0.1 AC). Raised here for visibility; **not actioned**, and left for a future SCP scoped to Epic 0.3 if the user wants it resolved.

#### Artifact sweep

| Artifact | Change |
|---|---|
| `epic-0.1-postgres-sql-schema-design.md` | Full rewrite: 2 → 4 stories, frontmatter, vertical slice, out-of-scope note |
| `epics/phase-0/index.md` | Epic table row (2 → 4 stories), Epic 0.1 summary paragraph, Phase 0 Epic Stories Summary table row, both story totals (17 → 19) |
| `epics/index.md` | Phase 0 status line story total (17 → 19) |
| `architecture.md` | New decision **#23** |
| `architecture/changelog.md` | New **v4.20** entry |
| `_bmad-output/source-docs/joh-schema-confluence/` | New — the two source PDFs, copied in (source documents are read-only elsewhere in the repo; this is the designated distillation location) |

**Not touched:** `epic-0.0`, `epic-0.2`, `epic-0.3`, `epic-0.4` (flagged as a follow-up candidate only, per above); `data-tables.md`; `gaps.md` (G8.1 flagged, not edited); `fr-coverage-map.md` (Epic 0.1's FR coverage claim — "schema groundwork only" — is unchanged by this expansion); `requirements-inventory.md` (no new AR — this epic cites existing AR2–AR32 plus `CLAUDE.md`'s D2+ELK diagram standard, which isn't a numbered AR); `sprint-status.yaml` (out of this session's scope — a sprint-planning concern, not a course-correction one); dated historical SCPs/changelog entries (immutable record).

### 3. Recommended Approach

**Direct Adjustment** — rewrite Epic 0.1 in place; no rollback, no MVP scope change. Effort: **Moderate** (one epic substantially rewritten, two index files updated, one decision-log + changelog entry). Risk: **Low** — additive documentation rigor to an epic with no implementation started yet (per the epic's own "nothing built yet" precedent, decision #8); no FR/NFR/dependency-graph change; the one open naming question is explicitly deferred rather than silently decided.

### 4. Detailed Change Proposals

See §2 for the full before/after mapping; the rewritten epic file carries complete Given/When/Then ACs for all 4 stories.

Story-shape rationale (why 4, not more or fewer): the source pages' own structure has four natural phases — *design decisions* (§1), *ER diagram* (their two diagrams), *column-level mapping* (§3, 16 sub-sections), *data warnings/open questions* (§5–6). Column-level mapping and the ER diagram are combined into one story (0.1.3) because for CTAM-native tables the diagram and the DDL are authored together, not sequentially the way a replicated schema's diagram (fixed by the source) can precede its mapping table.

### 5. Implementation Handoff

**Scope: Moderate** — epic content substantially rewritten (backlog reorganization: story count changes, no code exists yet to migrate). Routed to **Product Owner / Developer agents** for sprint-planning pickup (`bmad-sprint-planning` will need to regenerate `sprint-status.yaml` entries for the new Story ids 0.1.2–0.1.4, since the old 0.1.2 no longer refers to table DDL).

**Responsibilities:**
- **This session:** all edits above applied directly; nothing committed without being asked.
- **Follow-up (not this SCP, flagged for a future one):** an equivalent column-level documentation pass against Epic 0.3 Story 0.3.2 / `data-tables.md`'s `jo_*` section, using the same two source pages; and a decision on the `personnel_number` vs. `personal_code` naming question.

**Success criteria:** Epic 0.1 has 4 stories with complete ACs; every forward/backward story cross-reference within the epic resolves correctly (0.1.1 → 0.1.2/0.1.3/0.1.4; 0.1.3 depends on 0.1.2; 0.1.4 depends on 0.1.2 + 0.1.3); Phase 0 story totals are consistent across `epic-0.1`, `phase-0/index.md`, and `epics/index.md` (19 everywhere); the decision log and changelog both record this as a traceable, dated change; the `jo_*` schema itself is not duplicated anywhere in Epic 0.1.

---

## Sprint Change Proposal — 2026-08-25k

**Status:** approved

**Trigger:** User request — "update epic-0.2 based on the files in `/Users/shivakumar/MOJ/ram_analysis_docs`," a folder containing the real `E-links API v5.0` Swagger doc (`Swagger UI.pdf`) and June 2026 production reference-data exports (`ReferenceData/*.csv|json`) — the same class of source material Epic 0.2's Story 0.2.1 already claims to port "faithfully," but a direct comparison had not previously been done against this specific Swagger export.

**Mode:** Incremental (single artifact, iterated live with the user). **Scope classification:** **Minor** — Story 0.2.1's AC is corrected in place for completeness; no new story, no FR/NFR/PRD change, no dependency-graph change.

---

### 1. Issue Summary

Comparing the real Swagger doc's `Schemas`/`Paths` against Story 0.2.1's endpoint-porting AC (which claims every endpoint is reimplemented with an "identical" request/response shape) surfaced two omissions and several unspecified contract details:

1. **`GET /api/v5/people/{id}`** — a single-person lookup endpoint, distinct from the `/people` change-feed, present in the real contract but never named in the epic.
2. **`GET /api/v5/reference_data/{attribute_name}/{reference_id}`** — a single reference-data-item lookup, companion to the already-named list endpoint, also never named.
3. **Required query parameters** — `updated_since` (`/people`), `left_since` (`/leavers`), and `deleted_since` (`/deleted`) are all `required` in the real contract (missing → `400` validation error, confirmed from the Swagger UI's own "Try it out" error state); the epic didn't say so.
4. **Pagination defaults and metadata** — `per_page` (default 50) and `page` (default 1) are documented optional params, with responses carrying a `PaginationResponse` (`pages`, `current_page`, `results_per_page`, `more_pages`); not previously specified.
5. **Deprecated singular aliases** — the real `attribute_name` path parameter accepts 11 deprecated singular forms (`appointment_title`, `base_location`, …) alongside the 11 canonical plural names; not previously specified.

The real reference-data exports (`AppointmentTitle`, `BaseLocation`, `ContractType`, `Gender`, `JudiciaryRole`, `Jurisdiction`, `Location`, `LocationType`, `Ticket`, `TicketCategory`, `TicketCategoryType` — 11 files) confirm the epic's existing "11 vocabularies" claim is correct; no change needed there.

**Discussed and explicitly decided against:** the real Swagger doc's `Servers` value is `/elinks`, meaning production routes are `{host}/elinks/api/v5/...`. The user confirmed the mock should **not** adopt this prefix — it reads as gateway/ingress routing in front of the real hosted service, not part of the application's own contract, and a local Spring Boot mock has no gateway in front of it. The epic's existing bare `/api/v5/...` routes stand; this is now recorded as an explicit out-of-scope item so it isn't re-litigated later.

### 2. Impact Analysis

**Epic impact:** Epic 0.2 only, Story 0.2.1's endpoint-porting AC. Stories 0.2.2 and 0.2.3 are unaffected — neither depends on the two newly-named endpoints or the parameter detail added here.

**Artifact impact:** no PRD, architecture pattern, or UX change. No new table, repo, or dependency edge.

#### Artifact sweep

| Artifact | Change |
|---|---|
| `epic-0.2-joh-elinks-mock-api-stands-in.md` | Story 0.2.1's endpoint-porting AC rewritten to name all 7 endpoints (was 5 named/6 implied) plus required-param, pagination, and deprecated-alias detail; References line updated; one new out-of-scope bullet (`/elinks` prefix) |
| `_bmad-output/source-docs/joh-elinks-api/` | New — the real Swagger doc + `ReferenceData/*.csv|json` archived for traceability (mirrors the `joh-schema-confluence/` pattern from SCP 2026-08-25j) |
| `architecture.md` | New decision **#24** |
| `architecture/changelog.md` | New **v4.21** entry |

**Not touched:** `epics/phase-0/index.md`, `epics/index.md` (story count unchanged — 19); `sprint-status.yaml` (no story added/removed/renamed); Stories 0.2.2, 0.2.3 (no dependency on the corrected detail); `gaps.md` G8.1 (unaffected — this is mock-fidelity, not real-contract confirmation); `repository-strategy.md`, `assumptions.md` A38 (both already describe the mock at the right level of abstraction; no correction needed).

### 3. Recommended Approach

**Direct Adjustment.** Effort: **Low** — one AC block rewritten, one out-of-scope bullet, one References update, source-doc archival, decision-log + changelog entries. **Risk:** Very low — additive precision to an existing "faithful reimplementation" claim; no behavioural redesign, no story restructuring.

### 4. Detailed Change Proposals

See §1 for the full finding-by-finding rationale; the applied diff is in `epic-0.2-joh-elinks-mock-api-stands-in.md` itself.

### 5. Implementation Handoff

**Scope: Minor** — direct edit to existing epic content, no scope or dependency change.

**Responsibilities:**
- **This session:** all edits applied directly; nothing committed or pushed without being asked.

**Success criteria:** Story 0.2.1's endpoint-porting AC names every endpoint in the real `E-links API v5.0` Swagger doc that Epic 0.2's scope covers (people change-feed, people-by-id, leavers, deleted, reference-data list, reference-data-by-id, healthcheck), with required/optional query-parameter behaviour and pagination shape specified; the `/elinks` prefix question is recorded as a decided out-of-scope item, not left open; the real source material is archived under `_bmad-output/source-docs/` for future traceability; `docs/` regenerated from the updated markdown.

---

## Sprint Change Proposal — 2026-08-25l

**Status:** approved

**Trigger:** User request — "Update epic-0.2 stories with the following details: Acceptance Criteria [already present]; Tasks/Subtasks: API changes, service changes, repository changes, UI changes, tests."

**Mode:** Incremental (single artifact, iterated live with the user). **Scope classification:** **Minor** — additive guidance content within existing stories; no AC change, no FR/NFR/PRD change, no dependency-graph change.

---

### 1. Issue Summary

The literal request — add a `## Tasks / Subtasks` section to Epic 0.2's stories, broken into API/service/repository/UI/test changes — collides with a documented, previously-incident-tested contract in `architecture/delivery-operating-model.md`: **`## Tasks / Subtasks` is a BMad-reserved heading**, generated by `bmad-create-story` into the **story-packet** (`docs/stories/<id>.md` in the *target* repo) at dispatch time, and read/written by exact heading by `bmad-dev-story`. That same file records that SCP 2026-08-19b existed specifically to fix a prior incident where a hand-authored packet omitted `## Tasks / Subtasks` and broke the dev workflow — the rule against improvising that heading elsewhere is not incidental, it's load-bearing.

Epics in this repo (`_bmad-output/planning-artifacts/epics/`) are documented to carry embedded Gherkin Acceptance Criteria only; the task-level breakdown is meant to be produced later, per-story, when `bmad-create-story` actually dispatches that story using the epic's ACs as input.

**Resolution, confirmed with the user:** keep the *content* the user asked for (an API/service/repository/UI/test breakdown per story) but under a **differently-named subsection** — **"Implementation touchpoints"** — so it (a) doesn't collide with the reserved heading `bmad-dev-story` reads/writes, and (b) reads unambiguously as *dispatch guidance for `bmad-create-story`*, not as the dispatch-time artifact itself.

### 2. Impact Analysis

**Epic impact:** Epic 0.2 only, all three stories (0.2.1, 0.2.2, 0.2.3) gain a new "Implementation touchpoints" paragraph each, placed after their existing "Explicitly NOT in scope" bullets. No AC changed, no story added or renumbered.

**Artifact impact:** no PRD, architecture pattern, FR/NFR, or UX change. No new table, repo, or dependency edge. Introduces (but does not mandate elsewhere) a reusable per-story guidance pattern that future epics may adopt the same way — not applied retroactively to any other epic by this SCP.

#### Artifact sweep

| Artifact | Change |
|---|---|
| `epic-0.2-joh-elinks-mock-api-stands-in.md` | New "Implementation touchpoints" paragraph added to each of Stories 0.2.1, 0.2.2, 0.2.3 |
| `architecture.md` | New decision **#25** |
| `architecture/changelog.md` | New **v4.22** entry |

**Not touched:** `epics/phase-0/index.md`, `epics/index.md` (story count unchanged — 19); `sprint-status.yaml` (no story added/removed/renamed); every other Phase 0 epic (this SCP does not retrofit the pattern elsewhere); `epics/framework.md` (no canonical epic-content template exists there to update).

### 3. Recommended Approach

**Direct Adjustment.** Effort: **Low** — three additive paragraphs, decision-log + changelog entries. **Risk:** Very low — purely additive guidance content; the naming choice specifically avoids the one collision risk this kind of change could otherwise create.

### 4. Detailed Change Proposals

Per story, a new paragraph:

> **Implementation touchpoints** *(dispatch guidance for `bmad-create-story` — not the BMad `## Tasks / Subtasks` section itself, which `bmad-create-story` generates in the story-packet at dispatch time, per `delivery-operating-model.md`)*:
> - **API changes:** ...
> - **Service changes:** ...
> - **Repository changes:** ...
> - **UI changes:** ...
> - **Tests:** ...

- **Story 0.2.1:** names the new Spring controllers/services by class name, confirms no repository layer (stateless mock, no DB) and no UI, and describes the ported JUnit test suite.
- **Story 0.2.2:** all categories are "none" except tests (Docker Compose liveness + manual curl verification) — this story is deployment/wiring only.
- **Story 0.2.3:** flagged explicitly that its code changes land in **`ctam-reference-data`**, not `ctam-jomockapi` — config-only service change (base URL), no new repository code (existing Story 0.3.2 repositories), integration test verifying the full sync against the mock.

Full text is in the epic file itself.

### 5. Implementation Handoff

**Scope: Minor** — direct edit to existing epic content, no scope or dependency change.

**Responsibilities:**
- **This session:** all edits applied directly; nothing committed or pushed without being asked.

**Success criteria:** every one of Epic 0.2's three stories carries an "Implementation touchpoints" paragraph covering API/service/repository/UI/test changes; no story acquires a literal `## Tasks / Subtasks` heading; the naming and framing make clear this is dispatch-time guidance, not the BMad-generated artifact itself; `docs/` regenerated from the updated markdown.

---

## Sprint Change Proposal — 2026-08-25m

**Status:** approved

**Trigger:** Explicit user request — first "remove the source-docs folder completely and update," then refined to "move source-docs from this folder to `/Users/shivakumar/MOJ/docs`." The net effect implemented is the second, refined instruction: relocate, not delete.

**Mode:** Direct execution (unambiguous instruction; no judgment call to iterate on). **Scope classification:** **Minor** — file relocation + reference correction; no AC/FR/NFR/PRD change, no dependency-graph change.

---

### 1. Issue Summary

`_bmad-output/source-docs/` held two archives created earlier the same day:

- `joh-schema-confluence/` (SCP 2026-08-25j) — two distilled PDFs of internal HMCTS Confluence pages describing the JOH eLinks integration schema.
- `joh-elinks-api/` (SCP 2026-08-25k) — the real E-links API v5.0 Swagger doc, plus **real HMCTS production reference-data exports** (`eLinks_Pivotl_Production_all-data_2026-06-01_*`, 11 CSV/JSON files) supplied by the user for the mock-API contract correction.

The user asked for this folder to be taken out of the repo and relocated to `/Users/shivakumar/MOJ/docs` on their own machine — outside version control, outside `ctam-analysis` entirely — and for the resulting references to be updated accordingly.

### 2. Impact Analysis

**Epic impact:** none structural — Epic 0.1 and Epic 0.2's *content* (the schema-design pattern adopted, the mock-API contract corrections) stands independently of whether a local copy of the source material is archived inside the repo. Only the two places that claimed an in-repo archived copy needed correcting.

**Artifact impact:**

| Artifact | Change |
|---|---|
| `_bmad-output/source-docs/` | Moved out of the repo to `/Users/shivakumar/MOJ/docs/source-docs/` (both subfolders, 14 files, preserved intact — not deleted, an unrelated pre-existing PDF already in the destination folder is untouched) |
| `epic-0.1-postgres-sql-schema-design.md` | Design-rigor note's "distilled to `_bmad-output/source-docs/joh-schema-confluence/`" claim removed; a dated note added recording the relocation |
| `epic-0.2-joh-elinks-mock-api-stands-in.md` | Story 0.2.1's References line's "archived to `_bmad-output/source-docs/joh-elinks-api/`" claim corrected to note the archive existed in-repo and was later relocated out |
| `architecture.md` | Decisions #23 and #24 get a short bracketed annotation (`*(relocated out of the repo by #26)*`) — matching the existing #14/#16 precedent for a later decision affecting an earlier one — text otherwise left as immutable history; new decision **#26** |
| `architecture/changelog.md` | New **v4.23** entry; v4.20/v4.21 entries left untouched (immutable history, per this repo's convention) |

**Not touched:** `sprint-change-proposal-2026-08-25.md#sprint-change-proposal-2026-08-25j`, `sprint-change-proposal-2026-08-25.md#sprint-change-proposal-2026-08-25k` (dated historical records — immutable, per `CLAUDE.md`'s "leave dated reports and existing changelog entries as immutable history — add, don't rewrite"); the Confluence-page and Swagger-doc *citations themselves* (still valid — only the claim of an in-repo copy is removed); `sprint-status.yaml`, `epics/phase-0/index.md`, `epics/index.md` (no story/count change).

**Not done:** a git-history rewrite. The relocated files remain recoverable from the commits that added them (`a4bd168` for `joh-schema-confluence/`, `3be19ef` for `joh-elinks-api/`) unless the user separately, explicitly requests a history rewrite — not attempted here per this repo's hard rules on destructive git operations.

### 3. Recommended Approach

**Direct Adjustment.** Effort: **Low**. **Risk:** Very low — the relocation was explicitly requested; the only risk was leaving dangling in-repo references, which this SCP corrects.

### 4. Detailed Change Proposals

See §2; full diffs are in the files themselves.

### 5. Implementation Handoff

**Scope: Minor** — direct file relocation + reference correction, no scope or dependency change.

**Responsibilities:**
- **This session:** all edits applied directly; nothing committed or pushed without being asked.

**Success criteria:** `_bmad-output/source-docs/` no longer exists inside `ctam-analysis`; the 14 files are intact at `/Users/shivakumar/MOJ/docs/source-docs/`; no remaining planning-artifact text claims an in-repo archived copy exists; the underlying source citations (Confluence pages, real Swagger doc, real reference-data exports) remain accurately described as sources, just without an in-repo copy; `docs/` (the published site) regenerated from the updated markdown.
