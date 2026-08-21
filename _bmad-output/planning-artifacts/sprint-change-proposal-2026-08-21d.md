---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — annotate sprint-status.yaml epics with their exact titles'
description: 'Date: 2026-08-21 -- sprint-status.yaml''s epic-N.M keys carried no human-readable name, only the bare id. Added each epic''s exact title (from its own title: frontmatter) as a comment on the line above the key. A first attempt put the comment on the same line as the status value and was caught, before commit, breaking scripts/dispatch-preflight.sh''s depends_on status extraction -- corrected to a comment-above-the-key form that leaves every status value and the epic-id key format untouched.'
resource: 'sprint-change-proposal-2026-08-21d.html'
tags: [ctam-pathfinder, sprint-change, sprint-status, phase-0, phase-1]
timestamp: '2026-08-21'
parent: 'planning-artifacts/index.md'
project: 'ctam-analysis (CTAM Pathfinder)'
change_scope: 'Minor — annotation only, no status/content/key change'
mode: 'Batch'
architectureVersion: 'v4.17'
last_updated: 2026-08-21
---

# Sprint Change Proposal — 2026-08-21 (d)

**Annotate `sprint-status.yaml` epics with their exact titles**

---

## Section 1 — Issue Summary

**Trigger:** *"modify sprint-status.yaml to reflect the exact name of the epics"* — a direct `bmad-correct-course` request. `sprint-status.yaml`'s 12 `epic-N.M` keys carried only the bare id (e.g. `epic-1.4: backlog`) with no indication of what that epic actually is, unlike its story keys, which already embed a full descriptive slug.

**Constraint discovered while implementing:** the epic id itself cannot safely carry a slug the way story keys do. `scripts/dispatch-preflight.sh`'s "is it buildable yet" check greps a prerequisite epic's status line with `^epic-N.M:` — an exact match with nothing between the id and the colon. A slugged key (`epic-1.4-user-authenticates: backlog`) would silently stop matching, and every story depending on that epic would falsely report the prerequisite as "not in sprint-status.yaml."

**A second, more subtle problem caught before this was committed:** the first attempt appended each epic's title as a *trailing* comment on the same line as the status (`epic-1.4: backlog  # User authenticates and lands on a role-scoped Home page`). This parses fine under a YAML library, but `dispatch-preflight.sh` doesn't use one — it extracts the status with plain string manipulation (`dstatus="${dline##*:}"`, then whitespace-trim only, no `#`-stripping). Verified by hand: `${dline##*:}` on that line yields `backlog  # User authenticates and lands on a role-scoped Home page`, which after whitespace-stripping is `backlogUserauthenticates…` — never equal to the literal string `done`. Every dependent story would have permanently reported that prerequisite as blocked, even once the epic genuinely was `done`. Caught by running the script's own extraction logic against the edited file before shipping it, not by inspection alone.

**Fix:** each epic's exact title (from its own epic file's `title:` frontmatter) is now a comment on its **own line, directly above** the `epic-N.M:` key — never trailing after the status. Verified this leaves `dispatch-preflight.sh`'s extraction producing a clean status string for every one of the 12 epics, and ran the script end-to-end against a real story (`1.1.1`) to confirm it still correctly reports blocked/clear.

**Status check:** no epic or story status value changed. `epic-1.9` is still `in-progress`, story `1-9-1-…` is still `done`, everything else is still `backlog` — verified the same 52 `development_status` keys and values before and after.

---

## Section 2 — Impact Analysis

### 2.1 Epic impact

None — no epic's scope, stories, ACs, `depends_on`, or status changed.

### 2.2 Story impact

None.

### 2.3 Artifact conflicts / cross-reference sweep

Only `sprint-status.yaml` changed. Nothing else references its comment lines. `scripts/dispatch-preflight.sh` was re-verified against the edited file (see Section 1) rather than assumed compatible.

### 2.4 Technical impact

None — no code exists in any of the 16 execution-unit repos; nothing has been dispatched.

---

## Section 3 — Recommended Approach

**Direct adjustment**, corrected once during implementation after the trailing-comment approach was caught breaking `dispatch-preflight.sh`'s status extraction. Final form: a comment line above each `epic-N.M:` key, key and status values otherwise untouched.

**Effort:** Trivial. **Risk:** None, post-fix — verified via the actual consuming script's extraction logic, not just YAML validity.

---

## Section 4 — Detailed Change Proposals

### 4.1 `_bmad-output/implementation-artifacts/sprint-status.yaml`

```diff
 development_status:
+  # Platform estate is provisioned, verifiable, and CNP-compliant
   epic-1.0: backlog
   ...
+  # User authenticates and lands on a role-scoped Home page
   epic-1.4: backlog
   ...
```

Applied to all 12 epics (`epic-0.0`, `epic-0.1`, `epic-1.0`–`epic-1.9`), each title copied verbatim from that epic file's own `title:` frontmatter. A short header note explaining the convention — and explicitly why it's a comment-above, not a trailing comment or a slugged key — was added near the existing Epic/Story/Retrospective Status Definitions block.

---

## Section 5 — Implementation Handoff

**Scope classification: Minor.** Direct implementation by the Developer agent (this session).

**Success criteria:**
- Every `epic-N.M:` key in `sprint-status.yaml` is preceded by a comment line carrying that epic's exact title.
- No epic or story key, status value, or count changed.
- `scripts/dispatch-preflight.sh`'s prerequisite-status extraction still yields a clean status string for every epic (verified) and a real end-to-end run against Story 1.1.1 still reports the correct blockers.
