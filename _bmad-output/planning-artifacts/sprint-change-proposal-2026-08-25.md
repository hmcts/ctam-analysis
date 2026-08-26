---
type: 'Sprint Change Proposal'
description: 'Moves Epic 1.1 (JOH domain schema, PostgreSQL) from Phase 1 into Phase 0 as Epic 0.9. Phase 1 reverts to framework-only (it had no other epics). Pure renumber/relocate - no content change.'
resource: 'sprint-change-proposal-2026-08-25.html'
tags: [ctam-pathfinder, sprint-change-proposal]
timestamp: '2026-08-25'
title: 'Sprint Change Proposal — 2026-08-25'
status: 'proposed'
---

# Sprint Change Proposal — 2026-08-25

**Trigger:** *"move epic-1.1 to phase-0"*

**Mode:** Batch. **Scope classification:** Minor — a pure relocate/renumber, no story content, no FR/NFR, no architecture-decision change.

## 1. Issue Summary

Epic 1.1 ("JOH domain schema is designed and implemented in PostgreSQL") was added yesterday (SCP 2026-08-24c) as the first — and only — epic in a new `epics/phase-1/` folder. The team wants it filed as a Phase 0 epic instead. Since it was the sole occupant of Phase 1, moving it out leaves Phase 1 with nothing, reverting to its prior "framework only" state.

Nothing about the epic's *content* changes — same 2 stories (scaffold `ctam-joh`; create its 5 domain tables), same dependencies, same open items flagged for the implementer (tier-(b) vocabulary FK verification; the `ctam_jurisdictional_splits` 100%-sum enforcement choice). Only its number, file location, and cross-references change.

## 2. Impact Analysis

- **Epic renumbered:** 1.1 → **0.9** (next free Phase 0 slot). Stories 1.1.1/1.1.2 → **0.9.1/0.9.2**.
- **File moved:** `epics/phase-1/epic-1.1-postgres-sql-schema-design.md` → `epics/phase-0/epic-0.9-postgres-sql-schema-design.md` (via `git mv`, preserving history).
- **`epics/phase-1/` folder removed** — Phase 1 had no other epics, so it reverts to "_to be storied_ / ⚪ Framework only" in `epics/index.md`, same as every other undecomposed phase.
- **`depends_on` unchanged** (`[epic-0.0, epic-0.1, epic-0.6]` — all were already Phase 0 epics, so the dependency set needed no change).
- **`framework.md`'s Phase 1 · JOH area** keeps its cross-reference to this schema epic (the *content* is still JOH-domain schema work, described in that architectural area) — only the link target updates to the new Phase 0 location. This mirrors how Epic 0.6/0.7 already sit in the Phase 0 folder while covering cross-cutting, not purely Phase-0-scoped, concerns.
- **`fr-coverage-map.md`** — the "schema groundwork landed" note under the Phase 1 pending FR10–FR18 row updates its link/label from Epic 1.1 to Epic 0.9; it stays in the *Phase 1 FRs* table (FR-ownership, not file location, drives that table).
- **Caught while editing:** `epics/index.md`'s Phase 0 summary line still read "6 epics, 19 stories" — stale since the Epic 0.6/0.7/0.8 additions earlier this session. Corrected to the actual current total (10 epics, 26 stories, including this move) alongside this change.
- **Not touched:** `data-tables.md` (unaffected — same 5 tables, same design), the epic's own story content/ACs (verbatim, only numbers change), `architecture.md` decision log (a file relocation isn't an architectural decision), and yesterday's SCP 2026-08-24c (left as an immutable historical record of what was proposed and approved that day).

## 3. Recommended Approach

Direct relocate + renumber (Option 1, trivially). No rollback question (nothing built against Epic 1.1 yet — `sprint-status.yaml` shows it `backlog`), no MVP/FR impact.

**Effort:** Low. **Risk:** Low — mechanical, verified file-by-file rather than blind find-replace. **Timeline impact:** None.

## 4. Detailed Change Proposals

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

## 5. Implementation Handoff

**Scope: Minor** — direct implementation, no PO/DEV backlog coordination needed beyond the mechanical sweep above.

**Success criteria:** `epic-0.9`'s file is internally consistent (no leftover "1.1"/"Phase 1" references); `epics/index.md` and `epics/phase-0/index.md` totals agree; `docs/` regenerates cleanly with no dangling Phase 1 nav entries; `data-tables.md` and the epic's ACs are unchanged in substance.
