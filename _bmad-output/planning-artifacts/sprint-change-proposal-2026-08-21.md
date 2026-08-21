---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — close out the 2026-08-21 epic-0.0/epic-0.1 documentation trail'
description: 'Date: 2026-08-21 -- four commits (business-goal framing + 3-way story split for Epic 0.0, new sibling Epic 0.1 (MRD reference-data mock), a delivery/README.md staleness fix, and a business-readable rewrite of all ten Phase 1 epics) landed without the changelog.md entry and Sprint Change Proposal the repos own cross-cutting-change rule requires, and without sweeping two connective docs (fr-coverage-map.md, and the root README.md/CLAUDE.md epics-folder description) that still described the pre-split, pre-swap state. This SCP records the four commits retroactively and fixes the missed connective-doc staleness.'
resource: 'sprint-change-proposal-2026-08-21.html'
tags: [ctam-pathfinder, sprint-change, epics, phase-0, phase-1, documentation]
timestamp: '2026-08-21'
parent: 'planning-artifacts/index.md'
project: 'ctam-analysis (CTAM Pathfinder)'
change_scope: 'Minor — documentation/traceability only, no PRD/architecture/FR/epic-content change'
mode: 'Batch'
architectureVersion: 'v4.14'
last_updated: 2026-08-21
---

# Sprint Change Proposal — 2026-08-21

**Close out the documentation trail for the Epic 0.0/0.1 work already on this branch**

---

## Section 1 — Issue Summary

**Trigger:** *"fix all the files based on the changes what we have done till now as part of latest pr"* — a `bmad-correct-course` sweep of `chore/split-epic-0.1-etl-processes` before it goes for review.

**What happened:** four commits landed on this branch after the 2026-08-20 phase-0/phase-1 swap (SCP 2026-08-20h, changelog v4.13):

| Commit | What it did |
|---|---|
| `82b4a75` | Epic 0.0 gets a Business Goal + "what this covers" framing; its single dense Story 0.0.1 is split into three (0.0.1 contract/auth/pagination, 0.0.2 error handling + fixture realism, 0.0.3 the G8.7 natural-key discovery); fixed a stale "Epic 0.2" cross-reference left over from the phase swap (should have read Epic 1.2) |
| `f36ace6` | Epic 0.0 gains a concrete "Endpoints being mocked" reference table; new sibling **Epic 0.1** (`mrd-reference-data-mock`, 3 stories) added — the MRD-side equivalent, built on a *proposed*, explicitly-unconfirmed workbook shape rather than a real reference example; `fr-coverage-map.md`'s NFR24 row and `gaps.md` G8.1 updated to reflect it |
| `ff7d884` | `delivery/README.md`'s "Current state" section corrected — it still said "Phase 0 is structured; phases 1-8 are prose" (pre-dating the 2026-08-20 swap) and cited a nonexistent "story 0.9.1" |
| `b6f61c4` | All ten Phase 1 (Foundations) epics + `phase-1/index.md` rewritten in the same business-readable style already applied to Epic 0.0/0.1 — citations (FR/NFR/AR/gap/decision-ID, `References:` footnotes) stripped from epic bodies, since `fr-coverage-map.md` is the actual single source of truth for that mapping; no structural or AC content changed |

**The problem:** every one of these is individually sound (each commit's own message documents what it touched and why), but **none of them added the changelog.md entry or Sprint Change Proposal that CLAUDE.md's own hard rule requires for a cross-cutting change** ("record the change in a new Sprint Change Proposal + a `changelog.md` entry, then regenerate `docs/`") — so there is no traceable record of Epic 0.1's addition or the Phase 1 rewrite in `architecture/changelog.md`, unlike every other structural change to the epics pack this month. Re-running the repo-wide staleness sweep the last several SCPs have relied on (grepping for old epic numbers, checking every `depends_on`, checking every connective doc) turned up two further loose ends the four commits' own scopes didn't cover, because they sit outside `epics/`:

1. **`epics/fr-coverage-map.md`** line 44's "Phase 0 pending" note still says *"Phase 0's first epic, [0.0]… is already storied"* — written before Epic 0.1 existed (added 2026-08-21, the day after that note), and never revisited when Epic 0.1 landed.
2. **Root `README.md`** (three spots — the "Epics" bullet, the repo-layout tree comment, and nav step 5) and **`CLAUDE.md`** (its "Where things live" bullet for `epics/`) still describe the *pre-split, pre-swap* state: "only Phase 0 is decomposed so far — 6 epics, 19 stories." Neither file is under `epics/` or `architecture/`, so none of the last four renumbering/swap SCPs' scopes touched them — but they are exactly the files a new joiner or a fresh Claude Code session reads first, and both undercount the current reality (Phase 1 "Foundations": 10 epics/22 stories; Phase 0 "JOH": 2 epics/6 stories) and fail to mention `phase-1/` exists at all.

**Status check:** no epic/story content changes, no `depends_on` changes, no code impact — every story remains in the status it already had in `sprint-status.yaml` (Epic 1.9 `in-progress`, Story 1.9.1 `done`, everything else `backlog`). This is a documentation-completeness gap, not a scope or sequencing change.

**One item found opportunistically, outside the epics-restructuring trigger, and fixed on explicit user request:** root `README.md` line 15 still read "decisions D1–D12" — stale since decision D13 (the 2026-08-07 ET-first pivot, SCP 2026-08-07) was taken, predating this branch entirely. Corrected to D1–D13 as part of this SCP's implementation, at the user's request when the proposal was presented for approval.

---

## Section 2 — Impact Analysis

### 2.1 Epic impact

None. No epic gains, loses, or changes scope, stories, ACs, or `depends_on` as a result of this SCP. Epic 0.1's content (added by `f36ace6`) is not itself in question — it is already correct and already reflected in `sprint-status.yaml`, `build_html.py`'s NAV, and `docs/`.

### 2.2 Story impact

None.

### 2.3 Artifact conflicts / cross-reference sweep

| Artifact | Issue | Fix |
|---|---|---|
| `epics/fr-coverage-map.md` | "Phase 0 pending" note names only Epic 0.0 as already-storied | Extend the note to name both Epic 0.0 and Epic 0.1 |
| `README.md` (root) | "Epics" bullet says "only Phase 0 is decomposed so far — 6 epics, 19 stories"; repo-layout tree comment says "framework + phase-0 epics"; nav step 5 says "the Phase 0 breakdown" | Update all three to name both `phase-1/` (Foundations, 10 epics/22 stories) and `phase-0/` (JOH, 2 epics/6 stories) as decomposed, phases 2–9+ as pending |
| `CLAUDE.md` | "Where things live" bullet for `epics/` says "`phase-0/` epics… only Phase 0 is decomposed so far; run `bmad-create-epics-and-stories` per phase for 1–8" | Same correction — both `phase-1/` and `phase-0/` decomposed; remaining phases 2–9+ |
| `architecture/changelog.md` | No entry for the four 2026-08-21 commits | New **v4.14** entry, recording all four commits plus this SCP's own fr-coverage-map/README/CLAUDE.md fixes |
| `scripts/python/build_html.py` NAV list | The eight Sprint Change Proposals from the epic-renumbering cascade (2026-08-20b through 20h) were never added to the "Change Control & Readiness" NAV group — their `docs/*.html` pages exist (the build script picks up every `sprint-change-proposal-*.md` on disk regardless of NAV) but none of them appear in the site's left-hand navigation, so they're only reachable by guessing the URL or via an in-body link from `changelog.html`. Found while adding this SCP's own NAV entry and checking the existing list for the pattern. | Add all eight plus this SCP's own 2026-08-21 entry to the NAV list |

**Verified clean (no action needed):** a repo-wide grep for stale epic numbers (`epic-0.2` through `epic-0.9`, `epic-0.10`, bare `epic N.M`/`Epic N.M`/`Story N.M.K` patterns) outside the dated SCP/report/changelog historical record found nothing further; `sprint-status.yaml` and `build_html.py`'s NAV list already match the file tree exactly; every phase-0 and phase-1 epic's frontmatter (`epic:`, `depends_on:`, `repo:`) is internally consistent; the Phase 1 business-readable rewrite left no orphaned citation markers or footnote references in any of the ten epic files; `delivery/README.md` already correctly names both Epic 0.0 and 0.1 (fixed by `ff7d884`).

### 2.4 Technical impact

None — this is a planning-repo documentation fix. No code exists in any of the 16 execution-unit repos for either phase.

---

## Section 3 — Recommended Approach

**Direct adjustment.** Fix the four stale spots in place; add the missing changelog entry recording the four commits (retroactively) plus this SCP's own fixes; regenerate `docs/`. No PRD, architecture, FR/NFR, epic, or story change — this closes a documentation-traceability gap, it does not reopen a planning decision.

**Effort:** Low — four small, mechanical text edits plus one changelog entry. **Risk:** Low — additive/corrective only, nothing existing is restructured, no `depends_on` or status changes.

---

## Section 4 — Detailed Change Proposals

### 4.1 `epics/fr-coverage-map.md`

```diff
- | FR10–FR18 | 0 | JOH Records & Working Patterns (...). **Note:** Phase 0's first epic, [0.0](phase-0/epic-0.0-joh-elinks-api-contract-mock.md), is already storied (contract confirmation + CI mock, ahead of this area) — see [phase-0/index.md](phase-0/index.md) | ⚪ |
+ | FR10–FR18 | 0 | JOH Records & Working Patterns (...). **Note:** Phase 0's first two epics, [0.0](phase-0/epic-0.0-joh-elinks-api-contract-mock.md) and [0.1](phase-0/epic-0.1-mrd-reference-data-mock.md), are already storied (contract confirmation + CI mocks for the two upstream feeds, ahead of this area) — see [phase-0/index.md](phase-0/index.md) | ⚪ |
```

### 4.2 `README.md` (root)

```diff
- - **Epics** — `epics/framework.md` + `epics/phase-0/` (stories embedded in each epic; only Phase 0 is decomposed so far — 6 epics, 19 stories).
+ - **Epics** — `epics/framework.md` + two decomposed phases so far: `epics/phase-1/` (Foundations, 10 epics/22 stories) and `epics/phase-0/` (JOH, 2 epics/6 stories — de-risking mocks for the two upstream data feeds, ahead of JOH's own primary area). Phases 2–9+ remain framework-only.
```

```diff
- │   │   ├── epics/              # framework + phase-0 epics (stories embedded)
+ │   │   ├── epics/              # framework + phase-1 (Foundations) and phase-0 (JOH) epics (stories embedded)
```

```diff
- 5. **[`epics/`](_bmad-output/planning-artifacts/epics/)** — the Phase 0 breakdown and FR coverage map.
+ 5. **[`epics/`](_bmad-output/planning-artifacts/epics/)** — the Phase 1 (Foundations) and Phase 0 (JOH) breakdowns, and the FR coverage map.
```

### 4.3 `CLAUDE.md`

```diff
-   - `epics/` — `framework.md` + `phase-0/` epics with **stories embedded inside each epic** (only Phase 0 is decomposed so far; run `bmad-create-epics-and-stories` per phase for 1–8).
+   - `epics/` — `framework.md` + two decomposed phases with **stories embedded inside each epic**: `phase-1/` (Foundations, 10 epics/22 stories) and `phase-0/` (JOH, 2 epics/6 stories — de-risking mocks, ahead of JOH's own primary area). Run `bmad-create-epics-and-stories` per phase for 2–9+.
```

### 4.4 `README.md` (root) — D1–D13

```diff
- Requirements baseline: **60 FRs, 42 NFRs, decisions D1–D12** (see `prd.md`).
+ Requirements baseline: **60 FRs, 42 NFRs, decisions D1–D13** (see `prd.md`).
```

Pre-existing staleness (decision D13 landed 2026-08-07, predating this branch), fixed opportunistically at the user's request rather than deferred to a separate SCP.

### 4.5 `scripts/python/build_html.py` — NAV list

Added all eight missing 2026-08-20b–h Sprint Change Proposals, plus this SCP (2026-08-21), to the "Change Control & Readiness" NAV group, most-recent-first, ahead of the existing "Sprint Change Proposal — 2026-08-20" entry — matching the title text already in each SCP's own frontmatter.

### 4.6 `architecture/changelog.md` — new entry (v4.14)

A new top-of-table row recording, retroactively: Epic 0.0's business-goal framing + 3-way story split + stale "Epic 0.2" fix (`82b4a75`); new Epic 0.1 + its endpoint-reference addition to Epic 0.0 + the `fr-coverage-map.md`/`gaps.md` updates that came with it (`f36ace6`); the `delivery/README.md` staleness fix (`ff7d884`); the Phase 1 business-readable rewrite across all ten epics (`b6f61c4`); the eight missing NAV entries; and this SCP's own fixes to `fr-coverage-map.md`, `README.md` (including the incidental D1–D13 correction), and `CLAUDE.md`.

---

## Section 5 — Implementation Handoff

**Scope classification: Minor.** Direct implementation by the Developer agent (this session) — no PO/DEV backlog reorganisation, no PM/Architect involvement required.

**Success criteria:**
- `fr-coverage-map.md`, `README.md`, `CLAUDE.md` all name both decomposed phases with correct current epic/story counts.
- `architecture/changelog.md` carries a v4.14 entry covering the four 2026-08-21 commits, the NAV-list fix, and this SCP.
- `scripts/python/build_html.py`'s NAV list includes all nine outstanding Sprint Change Proposals (2026-08-20b through h, plus this one).
- `docs/` regenerated via `scripts/build-html.sh` so the published site matches, and the previously-orphaned SCP pages are now reachable from the left-hand navigation.
- `sprint-status.yaml` unchanged (no epic/story/status change is in scope).
