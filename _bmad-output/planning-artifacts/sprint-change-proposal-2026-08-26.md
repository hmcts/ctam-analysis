---
type: 'Sprint Change Proposal'
description: '2 Sprint Change Proposals from 2026-08-26: (a) consolidates the 16 lettered same-day SCPs into one file per day; (b) adopts one-file-per-day as the standing rule going forward, recorded in CLAUDE.md.'
resource: 'sprint-change-proposal-2026-08-26.html'
tags: [ctam-pathfinder, sprint-change-proposal]
timestamp: '2026-08-26'
title: 'Sprint Change Proposal — 2026-08-26'
---

# Sprint Change Proposal — 2026-08-26

This file consolidates **2 Sprint Change Proposals** made on **2026-08-26** — this is itself the first proposal to follow the "one file per day" rule it establishes: appended here rather than filed as a separate `sprint-change-proposal-2026-08-26b.md`.

## Index

- [Sprint Change Proposal — 2026-08-26](#sprint-change-proposal-2026-08-26)  — 29 Sprint Change Proposals consolidated to one file per day
- [Sprint Change Proposal — 2026-08-26b](#sprint-change-proposal-2026-08-26b)  — one-file-per-day adopted as the standing rule going forward

---

## Sprint Change Proposal — 2026-08-26

*29 Sprint Change Proposals consolidated to one file per day*

**Status:** approved

**Trigger:** *"consolidate the sprint-change-proposal a single file per day"*, following an earlier same-day request to consolidate all 29 proposals into one file, which was implemented and then explicitly reverted at the user's request before this narrower version was asked for.

**Mode:** Batch. **Scope classification:** **Moderate** — a documentation-architecture change (29 files → 13, 94 cross-references rewritten) with no scope, FR/NFR, or epic/dependency impact.

---

### 1. Issue Summary

Earlier today, all 29 `sprint-change-proposal-{date}.md` files were merged into a single `sprint-change-proposal-log.md` (that SCP's record was itself part of the merge and no longer exists as a standalone entry — it was reverted along with everything else). The user then asked for that to be undone, which was done via `git revert` (a new commit, not a history rewrite, since the merge commit was already pushed).

The user then asked for a narrower consolidation instead: **one file per day**, not one file total. Multiple proposals landed on the same calendar date use a lettered suffix (`2026-08-19`, `-19b`, `-19c`, `-19d`; `2026-08-24`, `-24b`, `-24c`; `2026-08-25`, `-25b` through `-25m`) — those groups get merged into their day's base file. The 10 dates that only ever had one proposal are untouched, since they're already "one file per day."

### 2. Impact Analysis

#### What changed

- **`sprint-change-proposal-2026-08-19.md`** — merged with `-19b`, `-19c`, `-19d` (4 → 1). Now covers: agent delivery rules (TDD/coverage/mutation gates); story-packet schema reconciled with BMad; PR as the human gate; `sprint-status.yaml` replacing the bespoke ledger.
- **`sprint-change-proposal-2026-08-24.md`** — merged with `-24b`, `-24c` (3 → 1). Now covers the `ctam-jomockapi` onboarding SCP and its two follow-ups.
- **`sprint-change-proposal-2026-08-25.md`** — merged with `-25b` through `-25m` (12 → 1). Now covers the full day's work: the epic-numbering swaps, MRD-scope removal, JOH schema epic relocation, the local-only mock move, the Java/Spring Boot rebuild, both consistency-review rounds, the schema design-rigor expansion, the mock-contract correction against the real Swagger doc, the "Implementation touchpoints" guidance, and the source-docs relocation.
- **16 lettered files deleted** (and their generated `docs/*.html` pages). **10 single-proposal dates untouched.** Total: **29 files → 13.**
- **94 cross-references** rewritten across `architecture.md` (28), `architecture/changelog.md` (36), the three merged day-files themselves (29, now-internal same-file references between former siblings), and `epics/phase-0/index.md` (1) — from the old lettered filenames to `sprint-change-proposal-{date}.md#sprint-change-proposal-{date}{letter}` anchors.
- **`scripts/python/build_html.py`'s NAV** updated to list the 13 surviving files. While doing this, a pre-existing gap was also closed: the NAV list had never carried entries for `2026-08-24` or `2026-08-25` at all (any of their lettered variants) — a gap from before this session, unrelated to today's consolidation but natural to fix while rewriting this exact block.

#### Not touched

- The **content** of any individual proposal — every entry reads exactly as it did in its own file, only nested one heading-level deeper.
- `prd.md`, `prd-validation-report-2026-06-10.md`, `implementation-readiness-report-2026-05-15-rev2.md`, `business-case.md` — these only cite dates that were never lettered (single-proposal days), so nothing in them needed to change.
- Decision-log entries' and changelog rows' own prose — only their SCP link targets were updated (unavoidable, since the files they pointed at no longer exist standalone), consistent with how every prior file-rename/deletion this session has been handled.

### 3. Recommended Approach

**Direct implementation**, matching the user's explicit "one file per day" scope (narrower than the all-in-one attempt made and reverted earlier today). Effort: **Medium** (mechanical merge + reference sweep across a meaningful but bounded surface — 16 files, 94 references, versus 29/111 for the earlier all-in-one attempt). **Risk:** Low — verified via a full repo grep for the 16 deleted lettered filenames post-merge, finding zero dangling references; `docs/` rebuild produced no unexpected diffs beyond the intended file set.

### 4. Detailed Change Proposals

See §2 for the full before/after mapping. Full diffs are in the files themselves.

### 5. Implementation Handoff

**Scope: Moderate** — a repo-wide documentation reorganisation, no functional/epic/dependency change.

**Responsibilities:**
- **This session:** all edits above applied directly; nothing committed or pushed without being asked.

**Success criteria:** `ls sprint-change-proposal-*.md` in `planning-artifacts/` returns exactly 13 files; a repo-wide grep for the 16 deleted lettered filenames returns nothing; every merged file's index correctly lists and links to every entry that day; `docs/` regenerates cleanly with 13 SCP pages (was 29) and no dangling links.

---

## Sprint Change Proposal — 2026-08-26b

*One-file-per-day adopted as the standing rule going forward*

**Status:** approved

**Trigger:** *"always create a single file for sprint-change-proposal per day"*.

**Mode:** Batch. **Scope classification:** **Minor** — a working-convention change recorded in `CLAUDE.md`, applying going forward; no retroactive file changes beyond this file's own structure (which becomes the first proposal to follow the new rule).

---

### 1. Issue Summary

The previous entry on this same day (`#sprint-change-proposal-2026-08-26`) consolidated 16 lettered same-day files down to 3 — but that fixed the *symptom*, not the *habit*. Nothing stopped the next `bmad-correct-course` run today (or any future day with more than one proposal) from creating `sprint-change-proposal-2026-08-26b.md` and starting the same accumulation again. The user asked for a standing rule: always one file per day, going forward.

The installed `bmad-correct-course` skill's own default output path is already `{planning_artifacts}/sprint-change-proposal-{date}.md` — technically "one file per day" by default. The lettered-suffix habit was never part of the skill's documented behaviour; it was an improvised workaround (by this and prior sessions) for not wanting to overwrite an existing same-day file. The real fix isn't a skill change (the skill's install is gitignored, outside this repo's control) — it's a documented working convention that overrides the improvised habit: **check for today's file first; append to it; don't create a lettered sibling.**

### 2. Impact Analysis

#### What changed

- **`CLAUDE.md`** — a new bullet added to *Working conventions*: one Sprint Change Proposal file per day, append a new `## Sprint Change Proposal — {date}[suffix]` entry (with its own Index line) to today's file if it already exists, rather than creating a same-day lettered file. Only start a new file when the date rolls over.
- **This file** (`sprint-change-proposal-2026-08-26.md`) — restructured from a single-entry file into the multi-entry per-day format (frontmatter, intro, Index, then `##`-level entries) to hold this second same-day entry, demonstrating the rule immediately rather than only describing it.

#### Not touched

- No other planning artifact — this is a documentation/process convention, not a product, epic, or architecture change. No decision-log entry in `architecture.md` was added for this specific sub-change (the prior entry, #27, already covers the underlying "one file per day" filing scheme this formalises); no new changelog row beyond what #27's corresponding entry already recorded is needed for a same-day append.
- The 13 existing SCP files from the prior consolidation — untouched, this doesn't reopen that work.

### 3. Recommended Approach

**Direct implementation.** Effort: **Low** — one `CLAUDE.md` bullet, one file restructure. **Risk:** Very low — a documentation convention, not a code or schema change; enforcement depends on future sessions (including this one, later today) actually reading and following `CLAUDE.md`, which is standard practice for this repo.

### 4. Detailed Change Proposals

See §2. No story/AC-level changes — this SCP has no epic impact.

### 5. Implementation Handoff

**Scope: Minor** — a working-convention addition to `CLAUDE.md`, self-demonstrated in this same file.

**Responsibilities:**
- **This session:** edits applied directly; nothing committed or pushed without being asked.
- **Future sessions (including this one):** honour the new `CLAUDE.md` bullet — check for today's `sprint-change-proposal-{date}.md` before writing a new SCP file, and append rather than create a sibling.

**Success criteria:** `CLAUDE.md`'s Working Conventions section documents the one-file-per-day rule; this file itself now holds two entries under one Index, proving the pattern; no `sprint-change-proposal-2026-08-26b.md` (or similar sibling) exists as a separate file.
