---
type: 'Sprint Change Proposal'
description: 'Merges the 16 lettered same-day Sprint Change Proposals (2026-08-19b/c/d, 2026-08-24b/c, 2026-08-25b through m) into their days base file, one file per day, content preserved verbatim. Supersedes an earlier same-day all-into-one-file attempt that was reverted.'
resource: 'sprint-change-proposal-2026-08-26.html'
tags: [ctam-pathfinder, sprint-change-proposal]
timestamp: '2026-08-26'
title: 'Sprint Change Proposal — 2026-08-26'
status: 'approved'
---

# Sprint Change Proposal — 2026-08-26

**Trigger:** *"consolidate the sprint-change-proposal a single file per day"*, following an earlier same-day request to consolidate all 29 proposals into one file, which was implemented and then explicitly reverted at the user's request before this narrower version was asked for.

**Mode:** Batch. **Scope classification:** **Moderate** — a documentation-architecture change (29 files → 13, 94 cross-references rewritten) with no scope, FR/NFR, or epic/dependency impact.

---

## 1. Issue Summary

Earlier today, all 29 `sprint-change-proposal-{date}.md` files were merged into a single `sprint-change-proposal-log.md` (that SCP's record was itself part of the merge and no longer exists as a standalone entry — it was reverted along with everything else). The user then asked for that to be undone, which was done via `git revert` (a new commit, not a history rewrite, since the merge commit was already pushed).

The user then asked for a narrower consolidation instead: **one file per day**, not one file total. Multiple proposals landed on the same calendar date use a lettered suffix (`2026-08-19`, `-19b`, `-19c`, `-19d`; `2026-08-24`, `-24b`, `-24c`; `2026-08-25`, `-25b` through `-25m`) — those groups get merged into their day's base file. The 10 dates that only ever had one proposal are untouched, since they're already "one file per day."

## 2. Impact Analysis

### What changed

- **`sprint-change-proposal-2026-08-19.md`** — merged with `-19b`, `-19c`, `-19d` (4 → 1). Now covers: agent delivery rules (TDD/coverage/mutation gates); story-packet schema reconciled with BMad; PR as the human gate; `sprint-status.yaml` replacing the bespoke ledger.
- **`sprint-change-proposal-2026-08-24.md`** — merged with `-24b`, `-24c` (3 → 1). Now covers the `ctam-jomockapi` onboarding SCP and its two follow-ups.
- **`sprint-change-proposal-2026-08-25.md`** — merged with `-25b` through `-25m` (12 → 1). Now covers the full day's work: the epic-numbering swaps, MRD-scope removal, JOH schema epic relocation, the local-only mock move, the Java/Spring Boot rebuild, both consistency-review rounds, the schema design-rigor expansion, the mock-contract correction against the real Swagger doc, the "Implementation touchpoints" guidance, and the source-docs relocation.
- **16 lettered files deleted** (and their generated `docs/*.html` pages). **10 single-proposal dates untouched.** Total: **29 files → 13.**
- **94 cross-references** rewritten across `architecture.md` (28), `architecture/changelog.md` (36), the three merged day-files themselves (29, now-internal same-file references between former siblings), and `epics/phase-0/index.md` (1) — from the old lettered filenames to `sprint-change-proposal-{date}.md#sprint-change-proposal-{date}{letter}` anchors.
- **`scripts/python/build_html.py`'s NAV** updated to list the 13 surviving files. While doing this, a pre-existing gap was also closed: the NAV list had never carried entries for `2026-08-24` or `2026-08-25` at all (any of their lettered variants) — a gap from before this session, unrelated to today's consolidation but natural to fix while rewriting this exact block.

### Not touched

- The **content** of any individual proposal — every entry reads exactly as it did in its own file, only nested one heading-level deeper.
- `prd.md`, `prd-validation-report-2026-06-10.md`, `implementation-readiness-report-2026-05-15-rev2.md`, `business-case.md` — these only cite dates that were never lettered (single-proposal days), so nothing in them needed to change.
- Decision-log entries' and changelog rows' own prose — only their SCP link targets were updated (unavoidable, since the files they pointed at no longer exist standalone), consistent with how every prior file-rename/deletion this session has been handled.

## 3. Recommended Approach

**Direct implementation**, matching the user's explicit "one file per day" scope (narrower than the all-in-one attempt made and reverted earlier today). Effort: **Medium** (mechanical merge + reference sweep across a meaningful but bounded surface — 16 files, 94 references, versus 29/111 for the earlier all-in-one attempt). **Risk:** Low — verified via a full repo grep for the 16 deleted lettered filenames post-merge, finding zero dangling references; `docs/` rebuild produced no unexpected diffs beyond the intended file set.

## 4. Detailed Change Proposals

See §2 for the full before/after mapping. Full diffs are in the files themselves.

## 5. Implementation Handoff

**Scope: Moderate** — a repo-wide documentation reorganisation, no functional/epic/dependency change.

**Responsibilities:**
- **This session:** all edits above applied directly; nothing committed or pushed without being asked.

**Success criteria:** `ls sprint-change-proposal-*.md` in `planning-artifacts/` returns exactly 13 files; a repo-wide grep for the 16 deleted lettered filenames returns nothing; every merged file's index correctly lists and links to every entry that day; `docs/` regenerates cleanly with 13 SCP pages (was 29) and no dangling links.
