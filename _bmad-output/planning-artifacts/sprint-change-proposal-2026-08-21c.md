---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — reorder phase-0/phase-1 epics in sprint-status.yaml'
description: 'Date: 2026-08-21 -- sprint-status.yaml listed epic-1.0-epic-1.9 before epic-0.0/epic-0.1, matching epics/index.md''s Document Map table order (Phase 1 listed before Phase 0) but reading backwards against the epic-id numbering itself. Reordered to ascending epic id (epic-0.0, epic-0.1, epic-1.0..epic-1.9) at explicit user request. No status, key, or content change -- purely a reordering of existing entries.'
resource: 'sprint-change-proposal-2026-08-21c.html'
tags: [ctam-pathfinder, sprint-change, sprint-status, phase-0, phase-1]
timestamp: '2026-08-21'
parent: 'planning-artifacts/index.md'
project: 'ctam-analysis (CTAM Pathfinder)'
change_scope: 'Minor — cosmetic reordering only, no status/content change'
mode: 'Batch'
architectureVersion: 'v4.16'
last_updated: 2026-08-21
---

# Sprint Change Proposal — 2026-08-21 (c)

**Reorder phase-0/phase-1 epics in `sprint-status.yaml`**

---

## Section 1 — Issue Summary

**Trigger:** *"reorder the epics of phase-0 and phase-1 in sprint-status.yaml"* — a direct `bmad-correct-course` request.

**Before this change**, `development_status` in `sprint-status.yaml` listed `epic-1.0` through `epic-1.9` first, then `epic-0.0` and `epic-0.1` last. This matched `epics/index.md`'s own "Document Map" table, which lists Phase 1 (Foundations) before Phase 0 (JOH) — a deliberate consequence of the 2026-08-20 phase-directory swap (SCP 2026-08-20h) plus the "the number is not the order" precedent this programme has used since Epic 0.6/1.9's original numbering. It read backwards, however, against the plain numeric reading of the epic ids themselves (`0.0`, `0.1` are lower than `1.0`–`1.9`), and against `epics/phase-0/` sorting alphabetically before `epics/phase-1/` on disk.

**What changed:** reordered `development_status`'s epic blocks to ascending epic id — `epic-0.0`, `epic-0.1`, then `epic-1.0` through `epic-1.9` — with every story sub-key, epic status, and retrospective key moved as a whole block, unchanged internally. **No status value changed**: `epic-1.9` is still `in-progress`, story `1-9-1-…` is still `done`, everything else is still `backlog`. Verified the file is still valid YAML with the same 52 top-level `development_status` keys before and after (12 epics + 12 retrospectives + 28 stories).

**Known resulting inconsistency, not in scope for this SCP:** `epics/index.md`'s Document Map table and `scripts/python/build_html.py`'s NAV list both still list "Phase 1" before "Phase 0" — the order this SCP just moved away from in `sprint-status.yaml`. This SCP was scoped by the user to `sprint-status.yaml` only; the two files above are left as-is. If the user wants those reordered too for consistency, that's a follow-up SCP, not assumed here.

---

## Section 2 — Impact Analysis

### 2.1 Epic impact

None — no epic's scope, stories, ACs, `depends_on`, or status changed.

### 2.2 Story impact

None — no story's content or status changed; only the file position of each epic's block (and its nested stories) moved.

### 2.3 Artifact conflicts / cross-reference sweep

Only `sprint-status.yaml` was touched. `dispatch-preflight.sh` and every other consumer read entries by key (`grep -E "^[[:space:]]*${key}:"`), not by position, so nothing else in the repo depends on this file's key order — confirmed by inspecting `scripts/dispatch-preflight.sh`'s lookup logic. This is a purely cosmetic, zero-functional-risk change.

### 2.4 Technical impact

None — no code exists in any of the 16 execution-unit repos; nothing has been dispatched.

---

## Section 3 — Recommended Approach

**Direct adjustment.** Reorder the existing blocks in place; no other file needs a corresponding change for this file to remain internally valid.

**Effort:** Trivial. **Risk:** None — verified key set and status values identical before/after.

---

## Section 4 — Detailed Change Proposals

### 4.1 `_bmad-output/implementation-artifacts/sprint-status.yaml`

```diff
 development_status:
-  epic-1.0: backlog
-  ...(epic-1.0 through epic-1.9 blocks, unchanged internally)...
-  epic-1.9-retrospective: optional
-
-  epic-0.0: backlog
-  ...(epic-0.0 block, unchanged internally)...
-  epic-0.0-retrospective: optional
-
-  epic-0.1: backlog
-  ...(epic-0.1 block, unchanged internally)...
-  epic-0.1-retrospective: optional
+  epic-0.0: backlog
+  ...(epic-0.0 block, unchanged internally)...
+  epic-0.0-retrospective: optional
+
+  epic-0.1: backlog
+  ...(epic-0.1 block, unchanged internally)...
+  epic-0.1-retrospective: optional
+
+  epic-1.0: backlog
+  ...(epic-1.0 through epic-1.9 blocks, unchanged internally)...
+  epic-1.9-retrospective: optional
```

Every individual key and status value is byte-identical to before; only the three blocks' relative order changed.

### 4.2 `architecture/changelog.md` — new entry (v4.16)

Records this reordering for the same traceability reason every other tracking-file change this session has one.

---

## Section 5 — Implementation Handoff

**Scope classification: Minor.** Direct implementation by the Developer agent (this session).

**Success criteria:**
- `sprint-status.yaml`'s `development_status` lists `epic-0.0`, `epic-0.1`, then `epic-1.0`–`epic-1.9`, in that order.
- Every status value (epic and story) is unchanged from before the reorder.
- `architecture/changelog.md` carries a v4.16 entry.
- `docs/` regenerated so the new SCP page is built and linked from the site navigation.
