---
type: 'Sprint Change Proposal'
description: 'A closed 5-epic renumber in Phase 0: JOH domain schema, JOH eLinks mock API, and JOH reference-data ETL process move to 0.1/0.2/0.3, displacing User authenticates and Reference data read-only API to the two vacated slots, 0.7/0.9. Relabeling only - no technical dependency change.'
resource: 'sprint-change-proposal-2026-08-25b.html'
tags: [ctam-pathfinder, sprint-change-proposal]
timestamp: '2026-08-25'
title: 'Sprint Change Proposal — 2026-08-25b'
status: 'approved'
---

# Sprint Change Proposal — 2026-08-25b

**Trigger:** *"reorder the epics as follows: postgress-sql-schema-design as 0.1, joh-elinks-mock-api as 0.2, joh-reference-data-etl-process as 0.3"*

**Clarified via two questions before drafting** (the requested target slots 0.1–0.3 were occupied by two other epics not mentioned in the request):
1. **Displaced-epic handling** → **Minimal swap.** Only the 5 involved epics move, as a closed permutation: ETL-process 0.1→0.3, User-authenticates 0.2→0.7, Reference-data-API 0.3→0.9, Mock-API 0.7→0.2, Schema-design 0.9→0.1. Epics 0.0, 0.4, 0.5, 0.6, 0.8 untouched.
2. **Relabeling scope** → **Relabeling only.** Real technical dependencies are unchanged; `depends_on` arrays get rewired to point at the new ids of the same epics, not altered in meaning.

**Mode:** Batch. **Scope classification:** Moderate — mechanically large (touches every Phase 0 epic file plus ~10 supporting artifacts), but conceptually simple (a closed permutation, no content change).

---

## 1. Issue Summary

The team wants three epics — JOH domain schema, JOH eLinks mock API, and the JOH reference-data ETL process — filed at the front of Phase 0's numbering (0.1–0.3), ahead of the auth and reference-data-API epics that currently occupy those slots. Since every epic's `depends_on` array references other epics **by id** (e.g. `depends_on: [epic-0.0, epic-0.1, epic-0.6]`), a renumber isn't just a label change — every epic that depended on one of the 5 moved epics needs its `depends_on` rewired to the new id, or the dependency graph silently breaks (pointing at whatever epic now happens to sit at the old number).

## 2. Impact Analysis

### The permutation

| Epic | Old → New | Title |
|---|---|---|
| Schema design | 0.9 → **0.1** | JOH domain schema is designed and implemented in PostgreSQL |
| Mock API | 0.7 → **0.2** | JOH eLinks mock API stands in for the unconfirmed upstream contract |
| ETL process | 0.1 → **0.3** | JOH reference-data ETL process |
| User authenticates | 0.2 → **0.7** | User authenticates and lands on a role-scoped Home page |
| Reference data read API | 0.3 → **0.9** | Reference data is served read-only via a versioned, jurisdiction-filtered API |

Unaffected: 0.0 (Platform estate), 0.4 (User populations bootstrapped), 0.5 (Notification), 0.6 (Context bus), 0.8 (MRD ingestion).

### Dependency graph rewiring

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

### Story renumbering

Each moved epic's stories move with it (story index within the epic stays the same, only the epic-number prefix changes): 0.1.1–0.1.3 → 0.3.1–0.3.3 (ETL); 0.2.1–0.2.5 → 0.7.1–0.7.5 (auth); 0.3.1–0.3.2 → 0.9.1–0.9.2 (read API); 0.7.1–0.7.3 → 0.2.1–0.2.3 (mock API); 0.9.1–0.9.2 → 0.1.1–0.1.2 (schema).

### Artifact conflicts / updates needed

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

### Pre-existing staleness caught during the sweep

The mechanical sweep (see §3) surfaced three bugs left over from **earlier** SCPs this session, unrelated to today's renumber but fixed while already touching these files:
1. Several "Story 0.1.4" mentions (in `epic-0.0`, `epic-0.7`'s NOT-in-scope notes, `epic-0.8`'s split note, `gaps.md` G8.1) were never updated to "Story 0.8.1" when MRD split out in SCP 2026-08-24b — because that split's sweep, like this one, needs to distinguish "was called X" (historical, correctly kept as `0.1.4`) from "currently called X" (should say `0.8.1`). Both kinds now read correctly.
2. `delivery-operating-model.md`'s illustrative epic-frontmatter example still carried the **pre-retitle** title ("Upstream JOH/MRD reference data is ingested") and story count (4) from before the SCP 2026-08-24b retitle — corrected to the current title and story count (3).
3. Two **plural** "Stories 0.X.Y/0.X.Z" references (`epic-0.9-reference-data-read-only-api.md`, `epic-0.5-system-dispatches-emails.md`, `fr-coverage-map.md`'s FR1 row) were missed by both today's and the 2026-08-24b sweep's singular-form pattern-matching — found and fixed by hand.

## 3. Recommended Approach

**Direct implementation**, done via a scripted two-pass text substitution rather than manual per-file edits, to guarantee the 5-way permutation applied atomically (no risk of a sequential find-replace re-processing its own output — e.g. mapping 1→3 and then later re-mapping that same 3→9 by accident). Pass A fixed the pre-existing "Story 0.1.4" staleness first (so it couldn't collide with the epic-swap mapping); Pass B applied the 5-way swap to `epic-0.X-` (file links), bare `epic-0.X` (`depends_on` entries), `Epic 0.X` (prose), `epic: 0.X` (frontmatter), and `Story 0.X.Y` (story ids) patterns in one regex pass per file. The 5 files were then renamed via intermediate `.tmp` names to avoid collisions mid-rename (e.g. renaming 0.1→0.3 while 0.3 still existed under its old name). Every result was verified by grep — checking every referenced filename resolves to a real file, and manually reviewing every remaining "0.1.4"/"previously"/"Stories" (plural) occurrence for correctness — before writing this proposal.

**Effort:** Medium (large mechanical surface, low conceptual risk). **Risk:** Low, given the verification pass; the three pre-existing bugs it caught are evidence the verification was worth doing. **Timeline impact:** None — no story content or dependency semantics changed, only labels.

## 4. Detailed Change Proposals

See §2's tables for the full before/after mapping. Full per-file diffs are in the files themselves — given the scale (10 epic files + 9 supporting artifacts), this SCP records the mapping and verification method rather than re-pasting every changed line.

## 5. Implementation Handoff

**Scope: Moderate** — large mechanical footprint, no content/scope change, no PO/DEV coordination needed beyond the sweep itself (already done).

**Success criteria:** every `epic-0.X-slug.md` filename referenced anywhere in the live (non-historical) doc set resolves to a real file on disk (verified via `comm` diff against `ls`); every `depends_on` array's real technical dependency is preserved under its new id; `epics/phase-0/index.md`'s two summary tables agree with each other and with the individual epic files (26 stories, 10 epics); `docs/` regenerates cleanly with no dangling nav links.
