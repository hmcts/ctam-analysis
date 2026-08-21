---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — restore epic-level tracking for all Phase 1 epics'
description: 'Date: 2026-08-21 -- at explicit user request, epic-1.0 through epic-1.8 (and their retrospective keys) are added back to sprint-status.yaml as epic-level-only entries (no story sub-keys, since none exist after SCP 2026-08-21e stripped Phase 1''s stories). This also restores the dispatch-preflight.sh safety check that SCP 2026-08-21e had flagged as weakened: Epic 0.0/0.1''s prerequisite check on epic-1.1/epic-1.3 goes back from a WARN to a hard STOP, verified by re-running the script.'
resource: 'sprint-change-proposal-2026-08-21f.html'
tags: [ctam-pathfinder, sprint-change, sprint-status, phase-1]
timestamp: '2026-08-21'
parent: 'planning-artifacts/index.md'
project: 'ctam-analysis (CTAM Pathfinder)'
change_scope: 'Minor — tracking-file addition only, no epic/story content change'
mode: 'Batch'
architectureVersion: 'v4.19'
last_updated: 2026-08-21
---

# Sprint Change Proposal — 2026-08-21 (f)

**Restore epic-level tracking for all Phase 1 epics**

---

## Section 1 — Issue Summary

**Trigger:** *"Could you please track the other epics also"* — following *"list all the epics in sprint-status.yaml"*, which showed only `epic-0.0`, `epic-0.1`, and `epic-1.9` tracked. The other nine Phase 1 epics (`epic-1.0`–`epic-1.8`) were removed entirely by SCP 2026-08-21e, since they had no stories left to track after that change stripped Phase 1's story decomposition.

**What changed:** added `epic-1.0` through `epic-1.8` back to `sprint-status.yaml`'s `development_status`, each as an epic-level-only entry (`epic-1.X: backlog` + `epic-1.X-retrospective: optional`) — **no story sub-keys**, since none of these nine epics currently has any (unchanged from SCP 2026-08-21e; only Epic 1.9's Story 1.9.1 exists). Each carries the same title-comment convention established by SCP 2026-08-21d.

**A direct, welcome consequence:** SCP 2026-08-21e had flagged that removing `epic-1.1`/`epic-1.3` from this file weakened `scripts/dispatch-preflight.sh`'s prerequisite check for Epic 0.0/0.1's stories — from a hard `STOP` ("prerequisite epic-1.1 is 'backlog', not 'done'") down to a `WARN` ("prerequisite 'epic-1.1' is not in sprint-status.yaml"). Restoring these epic entries restores the hard `STOP` too — verified by re-running `./scripts/dispatch-preflight.sh 0.0.1`, which now correctly reports the blocker again.

**Status check:** all nine restored epics are `backlog`, matching `phase-1/index.md`'s 🟡 *Planned* status for each. `epic-1.9`, `epic-0.0`, `epic-0.1` and every existing story key are unchanged. `development_status` now carries 31 keys (12 epics + 12 retrospectives + 6 Phase 0 stories + 1 Phase 1 story).

---

## Section 2 — Impact Analysis

### 2.1 Epic impact

None — no epic's scope, `depends_on`, or content changes; this only affects what `sprint-status.yaml` tracks.

### 2.2 Story impact

None — no story exists to add for these nine epics.

### 2.3 Artifact conflicts / cross-reference sweep

Only `sprint-status.yaml` needed a change. `phase-1/index.md`, `epics/index.md`, `fr-coverage-map.md`, and `framework.md` already describe these epics as epic-level-only (SCP 2026-08-21e), consistent with this restoration — no further edits needed there.

### 2.4 Technical impact

None — no code exists; nothing has been dispatched.

---

## Section 3 — Recommended Approach

**Direct adjustment.** Add the nine epic entries back, verify YAML validity and the restored `dispatch-preflight.sh` behaviour.

**Effort:** Trivial. **Risk:** None — additive only, re-verified against the real consuming script.

---

## Section 4 — Detailed Change Proposals

### 4.1 `_bmad-output/implementation-artifacts/sprint-status.yaml`

```diff
+  # Platform estate is provisioned, verifiable, and CNP-compliant
+  epic-1.0: backlog
+  epic-1.0-retrospective: optional
+
+  ... (same shape for epic-1.1 through epic-1.8) ...
+
   # Context bus is published and the shared configuration baseline exists
   epic-1.9: in-progress
   1-9-1-publish-ctam-architecture-as-the-official-version-tagged-architecture-package: done
   epic-1.9-retrospective: optional
```

### 4.2 `architecture/changelog.md` — new entry (v4.19)

Records the restoration and the dispatch-preflight.sh safety-check consequence.

---

## Section 5 — Implementation Handoff

**Scope classification: Minor.** Direct implementation by the Developer agent (this session).

**Success criteria:**
- All 12 epics (`epic-0.0`, `epic-0.1`, `epic-1.0`–`epic-1.9`) are tracked in `sprint-status.yaml`.
- `./scripts/dispatch-preflight.sh 0.0.1` reports a hard `STOP` on `epic-1.1`, not a `WARN`.
- `architecture/changelog.md` carries a v4.19 entry.
