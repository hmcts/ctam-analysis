---
type: 'Sprint Change Proposal'
title: 'Renumber phase sequence: Phase 0-9+ → Phase 1-10+'
description: 'Shift every phase number up by one (0-indexed → 1-indexed) across the epics/architecture/PRD corpus, at the requester''s explicit direction and against the corpus''s own prior stated policy of not renumbering authored epics.'
resource: 'sprint-change-proposal-2026-08-24.html'
tags: [ctam-pathfinder, sprint-change-proposal, epics, renumbering]
timestamp: '2026-08-24'
parent: 'index.md'
purpose: 'Record and route the phase-numbering change requested 2026-08-24'
---

# Sprint Change Proposal — 2026-08-24

**Trigger:** Direct request from Shivakumar via `/bmad-correct-course`: "modify the name of phase-0 to phase-1."

## 1. Issue Summary

This is not a defect or a discovered constraint — it is a deliberate renumbering request. Clarified with the requester across three checkpoints:

1. **Scope of the rename.** "Phase 1" already exists and names a distinct, fully-defined phase (JOH Records & Working Patterns, `ctam-joh`, FR10–FR18). Renaming only `phase-0` → `phase-1` in isolation would collide with it. Confirmed intent: **renumber every phase +1** — Phase 0 → 1, Phase 1 (JOH) → 2, Phase 2 (Absence) → 3, Phase 3 (Vacancy) → 4, Phase 4 (Booking) → 5, Phase 5 (Sitting) → 6, Phase 6 (Payment) → 7, Phase 7 (Itineraries) → 8, Phase 8 (MI Feed) → 9, Phase 9+ (Wave Rollout) → 10+.
2. **In-flight epic 0.6.** `sprint-status.yaml` shows epic 0.6 is `in-progress`, with story 0-6-1 (publish the context bus) already `done` — tagged `arch-v1.0` in the live `ctam-architecture` repo, a name baked into that repo's branch/tag history under the *old* numbering. Confirmed: renumber epic 0.6 too (→ epic 1.6), accepting that the already-created `arch-v1.0` git artifacts in `ctam-architecture` retain the old `0-6-1` numbering as a historical fact this control plane cannot (and must not) rewrite.
3. **Existing precedent against this.** `epic-0.6-context-bus-and-shared-baseline.md` itself states: *"It is numbered 0.6 because renumbering the authored epics 0.1–0.5 would break every FR mapping and cross-reference for no benefit."* That was written for a much smaller renumber (one epic) than what's being asked here (all 10 phases, every FR/AR cross-reference across ~21 living documents). Flagged explicitly; requester confirmed **proceed anyway** — the benefit is cosmetic (1-indexed vs 0-indexed) and accepted as a deliberate choice.

## 2. Impact Analysis

### Epic impact
- No epic is added, removed, rescoped, or reordered. `depends_on:` edges and story content are unchanged — only the phase/epic *numbers* and the `phase-0/` directory name shift.
- Every epic's frontmatter (`epic:`, `parent:`, `resource:`, `tags:`) and every story ID in `sprint-status.yaml` under the renumbered epics changes to match.

### Artifact conflicts (repo-wide sweep — dated/historical records excluded per rule below)

| Category | Files | Treatment |
|---|---|---|
| Epic pack (rename + edit) | `epics/phase-0/` → `epics/phase-1/` (dir), its `index.md` + 6 epic files (`epic-0.0-*.md` → `epic-1.0-*.md`, … `epic-0.6-*.md` → `epic-1.6-*.md`) | Rename files, update frontmatter (`epic:`, `parent:`, `resource:`, `tags:`), update the internal "Epic 0.X" headings and cross-references |
| Epics connective docs | `epics/framework.md`, `epics/index.md`, `epics/fr-coverage-map.md`, `epics/requirements-inventory.md` | Renumber every phase/epic reference per the +1 map |
| Architecture shards | `architecture.md`, `architecture-summary.md`, `architecture/assumptions.md`, `architecture/data-tables.md`, `architecture/functional-requirements-coverage.md`, `architecture/non-functional-requirements-coverage.md`, `architecture/gaps.md`, `architecture/repo-structure.md`, `architecture/sequence-diagrams/admin-maintenance-flows.md`, `architecture/user-types.md` | Renumber current/forward-looking phase references |
| PRD | `prd.md` | Renumber **current, living** phase references (MVP scope, Journey↔Phase mapping table, glossary, FR/NFR bodies, Integration Requirements table, delivery variants). **Leave the dated Key Decisions log rows (D1–D14) untouched** — each is a point-in-time record of what was decided *and named* on its date, same convention as `changelog.md` |
| Business case, delivery docs | `business-case.md`, `delivery/README.md` | Renumber current references |
| Control-plane docs | `CLAUDE.md`, `README.md` | Renumber current references (repo map, folder descriptions) |
| Tracking | `_bmad-output/implementation-artifacts/sprint-status.yaml` | `epic-0.X` → `epic-1.X`, story IDs `0-X-Y-...` → `1-X-Y-...` for every entry (all current entries are Phase-0 epics) |
| Build tooling | `scripts/python/build_html.py` (NAV list), `scripts/python/apply_okf_frontmatter.py` (`phase-0` path/tag matching) | Update hardcoded `phase-0` path and tag references to `phase-1` |
| Changelog | `architecture/changelog.md` | **Add** a new dated entry recording this renumbering and the epic-0.6/`arch-v1.0` numbering seam. Existing entries are not rewritten |
| Generated site | `docs/**/*.html` | Never hand-edited — regenerated via `scripts/build-html.sh` after the above lands |
| **Left untouched (immutable history)** | All dated `sprint-change-proposal-*.md`, `implementation-readiness-report-*.md`, `prd-validation-report-*.md` files; PRD's own dated Key Decisions log rows; `.claude/memory/project_bmad_ctam_pathfinder_state.md` | These describe what was true *on the date they were written* — rewriting them would falsify the record. Per `CLAUDE.md`: "Leave dated reports and existing changelog entries as immutable history — add, don't rewrite." |

**The rename map applied everywhere in scope:**

| Old | New |
|---|---|
| Phase 0 | Phase 1 |
| Phase 1 (JOH) | Phase 2 |
| Phase 2 (Absence) | Phase 3 |
| Phase 3 (Vacancy) | Phase 4 |
| Phase 4 (Booking) | Phase 5 |
| Phase 5 (Sitting) | Phase 6 |
| Phase 6 (Payment) | Phase 7 |
| Phase 7 (Itineraries) | Phase 8 |
| Phase 8 (MI Feed) | Phase 9 |
| Phase 9+ (Wave Rollout) | Phase 10+ |
| `epic-0.0` … `epic-0.6` | `epic-1.0` … `epic-1.6` |
| story `0-X-Y-...` | story `1-X-Y-...` |
| `epics/phase-0/` | `epics/phase-1/` |

**Correction to this SCP's own earlier analysis:** an initial draft of this section wrongly treated `prd.md`'s "Phase 11+" (JI/APEX waves 3+) as stale drift against `framework.md`'s single "Phase 9+" umbrella and planned to "correct" it to "Phase 10+". That was wrong — `prd.md`'s NFR36 ("Each rollout wave (Phase 9, 10, …)") shows the PRD actually runs its own internally-consistent **per-wave-incrementing** scheme, distinct from `framework.md`'s umbrella label: wave 1 (ET) = Phase 9, wave 2 (SSCS) = Phase 10, Courts waves 3+ = Phase 11, 12, 13… (one number per judicial region). This SCP does **not** unify the two conventions — that is a semantic/architectural call outside a naming-only renumbering. Every number is shifted +1 mechanically, preserving whichever scheme was already in place at each location: "Phase 9 — Pilot rollout" → **Phase 10**; NFR36 "(Phase 9, 10, …)" → **(Phase 10, 11, …)**; "waves 3+ (Phase 11+)" → **Phase 12+**.

**Pre-existing inconsistency flagged, not resolved:** `prd.md`'s "Wave-by-wave rollout — Courts cohort" line already read "Phase 10..N" *before* this SCP, which does not match the JI/APEX line's "Phase 11+" for the same Courts-waves-3+ concept (both describe the same rollout but disagree on its starting phase number by one) — an authoring inconsistency between two lines that predates this SCP. The mechanical +1 preserves it as-is ("Phase 11..N" vs "Phase 12+") rather than guessing which one is correct; reconciling it is a separate, later decision for a human to make.

### UI/UX
None. No UI/UX specification exists yet for phases beyond Phase 0's shell scope; nothing to update.

### Technical impact
None to running code — this repo holds no runtime code. The only technical-adjacent artifact is `sprint-status.yaml` (dispatch tracking) and the two Python build scripts.

## 3. Recommended Approach

**Direct Adjustment** (checklist Option 1) — a systematic documentation sweep, no epic/story content changes, no PRD requirement changes, no rollback, no MVP scope change.

- **Effort:** Medium (large file count, but each edit is a mechanical number substitution guided by the map above; no design decisions).
- **Risk:** Low-to-medium. The main risk is the epic-0.6/`arch-v1.0` numbering seam (accepted, to be documented in the changelog) and the general risk of stray/incomplete substitution across ~21 files — mitigated by doing the sweep per-file against the map, then a verification grep for leftover `phase-0`/`epic-0.` references before regenerating `docs/`.
- **Rollback** and **PRD MVP review** are not applicable — nothing here is being reverted or descoped.

## 4. PRD MVP Impact

None. No functional or non-functional requirement is added, removed, or changed in substance — only the phase-number label attached to it changes where the PRD names a phase.

## 5. Implementation Handoff

**Scope classification: Minor** — a direct, mechanical relabeling with no scope/requirement change. Executed directly in this session (no separate PO/Architect step needed) once approved.

**Plan:**
1. Rename `epics/phase-0/` → `epics/phase-1/`; rename and edit the 6 epic files + `index.md` inside it.
2. Edit the epics connective docs, architecture shards, PRD (living sections only), business case, delivery README, `CLAUDE.md`, `README.md` per the map.
3. Update `sprint-status.yaml` epic/story keys.
4. Update the two Python build-tooling scripts' hardcoded `phase-0` references.
5. Add a new dated entry to `architecture/changelog.md` documenting the renumbering and the `arch-v1.0` seam.
6. Verification grep across the repo for any missed `phase-0` / `epic-0.` / stale "Phase N" reference in a living (non-historical) document.
7. Regenerate `docs/` via `scripts/build-html.sh`.
8. Present the full diff for review before anything is committed (per this repo's hard rule: commits happen only on request, and only to the current feature branch).

**Success criteria:** every living document uses the new phase numbers consistently; every dated/historical document is untouched; `sprint-status.yaml` keys match the renamed epics; `scripts/build-html.sh` runs clean and the regenerated site reflects the new numbering; a grep for `phase-0`/`epic-0.` outside the excluded historical files returns nothing.
