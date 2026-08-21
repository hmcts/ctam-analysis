---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — strip stories from all Phase 1 epics'
description: 'Date: 2026-08-21 -- at explicit user request, the "## Story N.N.N" sections are removed from all ten Phase 1 (Foundations) epic files, reverting each epic to epic-level-only content (business goal, outcome, scope, out-of-scope) with no stories -- the state phases 2-9+ are already in, and the state Phase 1 itself was in before bmad-create-epics-and-stories'' step 3 ran. Epics themselves, their frontmatter (repo, depends_on), and Epic 0.0/0.1 (Phase 0) are unaffected. One exception, flagged and confirmed by the user before implementation: Story 1.9.1 documents real, already-completed work (the ctam-architecture bus is genuinely published and tagged) and is kept as a completion record rather than deleted.'
resource: 'sprint-change-proposal-2026-08-21e.html'
tags: [ctam-pathfinder, sprint-change, epics, phase-1, stories]
timestamp: '2026-08-21'
parent: 'planning-artifacts/index.md'
project: 'ctam-analysis (CTAM Pathfinder)'
change_scope: 'Moderate — backlog reorganisation across 10 epics + 6 connective docs, no PRD/architecture/FR change'
mode: 'Batch'
architectureVersion: 'v4.18'
last_updated: 2026-08-21
---

# Sprint Change Proposal — 2026-08-21 (e)

**Strip stories from all Phase 1 epics**

---

## Section 1 — Issue Summary

**Trigger:** *"remove all phase-1 related stories"* — a direct `bmad-correct-course` request. Clarified with the user before starting, given how large and ambiguous the literal request was: of four offered readings (strip stories from epic files only / delete the epics entirely / clear only `sprint-status.yaml` entries / something else), the user chose **"strip stories from the epic files only"** — the `## Story N.N.N` sections come out of all ten Phase 1 epic files; the epics themselves (business goal, outcome, scope, `repo:`/`depends_on:` frontmatter) stay.

**What this reverts:** `bmad-create-epics-and-stories` is a four-step workflow (validate prerequisites → design epics → create stories → final validation). Phase 1 had completed all four steps (22 stories, Gherkin ACs, later rewritten business-readable by `b6f61c4`). This change rolls Phase 1 back to **after step 2, before step 3** — epics designed, stories not yet created — which is exactly the state Phase 0's primary area (JOH Records, FR10–FR18) and Phases 2–9+ are already in. **Epic 0.0 and 0.1 (Phase 0) are untouched** — the request was scoped to Phase 1 only.

**One consequence found during impact analysis, flagged for explicit approval before proceeding — not assumed:** Story **1.9.1** ("Publish `ctam-architecture` as the official, version-tagged architecture package") is not a hypothetical future story. It documents real, already-completed work: `ctam-architecture` genuinely exists on GitHub, tagged `arch-v1.0` and `arch-v1.1` (verified via `git ls-remote --tags`), and `sprint-status.yaml` already records it as `done`. Deleting its story text along with the other 21 backlog stories would erase the only written record of what was actually verified and shipped, and would leave `epic-1.9`'s `in-progress` status in `sprint-status.yaml` with nothing underneath it. **Decision confirmed by the user before implementation: keep Story 1.9.1 as a completion record inside Epic 1.9's file; strip the other 21 stories (all still `backlog`) as requested.**

**A second consequence found only after implementing, verified rather than assumed:** with `epic-1.1` and `epic-1.3` no longer tracked in `sprint-status.yaml` (nothing left to track — they have no stories), `scripts/dispatch-preflight.sh`'s prerequisite check for Epic 0.0/0.1's own stories can no longer confirm those prerequisites are unmet — it downgrades from a hard `STOP` to a `WARN`. Confirmed by running `./scripts/dispatch-preflight.sh 0.0.1` before and after this change: before, it correctly reported `STOP prerequisite epic-1.1 is 'backlog', not 'done'`; after, it reports `WARN prerequisite 'epic-1.1' is not in sprint-status.yaml` and the story becomes "Clear to dispatch." This is a real, if narrow, weakening of that safety check — worth knowing, not hidden in the changelog.

**Status check:** every affected story is `backlog` except 1.9.1 (`done`, and per the above, proposed to be kept). No code exists in any of the 16 execution-unit repos. This is a planning-document rollback, not a scope or architecture change — no FR/NFR is dropped, since the epics (and the FRs they exist to satisfy) remain; only their story-level decomposition is undone.

---

## Section 2 — Impact Analysis

### 2.1 Epic impact

All 10 Phase 1 epics (1.0–1.9) lose their story content but keep their epic-level definition (Business Goal, What this covers, Outcome, Component(s)-equivalent narrative, Explicitly out of scope). `storyCount` frontmatter drops to `0` (or is removed — see 4.1). No epic's `repo:` or `depends_on:` frontmatter changes. No epic is deleted, renumbered, or moved.

### 2.2 Story impact

All 22 Phase 1 stories are removed from their epic files (1.0.1–1.0.5, 1.1.1–1.1.2, 1.2.1, 1.3.1, 1.4.1–1.4.5, 1.5.1–1.5.2, 1.6.1, 1.7.1, 1.8.1–1.8.2, 1.9.1–1.9.2) — **except Story 1.9.1, pending the decision above.** Phase 0's 6 stories (Epic 0.0/0.1) are untouched.

### 2.3 Artifact conflicts / cross-reference sweep

| Artifact | What needs to change |
|---|---|
| `epics/phase-1/epic-1.0-…md` … `epic-1.9-…md` (10 files) | Remove everything from the `---` separator before the first `## Story` heading to end of file; `storyCount: 0` |
| `epics/phase-1/index.md` | Rewrite the Epics table (drop the Stories/count column values, "22 stories" total), drop the entire "Phase 1 Epic Stories Summary" table (story-level demo descriptions), rewrite epic summaries to drop "(N stories)" and story-number references |
| `epics/index.md` | Document Map row: "🟡 Planned — 10 epics, 22 stories" → "10 epics (not yet storied)"; "How this document is produced" narrative: "Phase 1 has completed all four steps" → "Phase 1 has completed steps 1–2 (epics designed); stories not yet created"; frontmatter `stepsCompleted` drops `step-03-create-stories-phase-1` and `step-04-final-validation-phase-1` |
| `epics/fr-coverage-map.md` | Every "Epic 1.X Story 1.X.Y" citation (FR1, FR2, FR3, FR6, FR7, FR8, FR55, FR58, FR59, NFR24) loses its Story-level suffix, becoming a plain Epic 1.X citation — the FR is still associated with the epic that will eventually deliver it, just not yet at story granularity |
| `epics/framework.md` | "→ Phase 1 concrete epics + stories: phase-1/" → "→ Phase 1 concrete epics (not yet storied): phase-1/" |
| `_bmad-output/implementation-artifacts/sprint-status.yaml` | Remove all 22 Phase 1 story keys and, since there's nothing left to track at story level, the 10 `epic-1.X`/`epic-1.X-retrospective` keys too — **except epic-1.9 and its one surviving story key, pending the Section 1 decision** |
| `scripts/python/build_html.py` NAV | Drop the "(N stories)" story counts from all 10 Phase 1 NAV entry labels |
| `architecture/changelog.md` | New v4.18 entry |

### 2.4 Technical impact

None — no code exists in any of the 16 execution-unit repos; nothing has been dispatched.

---

## Section 3 — Recommended Approach

**Direct adjustment**, with one decision needed before implementation: **keep Story 1.9.1 as a completion record** (it documents real, verified, already-shipped work — deleting the only written record of it serves no purpose and actively loses information), while removing the other 21 backlog stories as requested. This is presented as a recommendation, not a fait accompli — the user may instead want 1.9.1 removed too for full consistency with "all Phase 1 stories," in which case `epic-1.9`'s `in-progress` status and its lone `done` story marker in `sprint-status.yaml` would need to be reconciled (e.g. dropped to `backlog` with the completion evidence surviving only in `architecture/changelog.md`'s existing v4.x entries, which already record the publication independently).

**Effort:** Moderate — 10 epic-file edits + 6 connective-doc edits, all mechanical once the boundary decision is made. **Risk:** Low — no FR/NFR/architecture change, no code exists, fully reversible via git history if this needs undoing later.

---

## Section 4 — Detailed Change Proposals

### 4.1 Each of the 10 Phase 1 epic files

```diff
 ---
 ...
-storyCount: 5
+storyCount: 0
 repo: ctam-shared-infrastructure
 depends_on: []
 ---

 # Epic 1.0: ...

 **Business Goal:** ...
 **What this covers:** ...
 **Outcome:** ...
 ...
 **Explicitly out of scope:** ...

--
-
-## Story 1.0.1: ...
-[... full story content ...]
-
--
-
-## Story 1.0.5: ...
-[... full story content ...]
```

(Epic 1.9 is the one exception — see Section 1/3: its file keeps Story 1.9.1 verbatim, marked `done`, and loses only Story 1.9.2.)

### 4.2 `epics/phase-1/index.md`

Full rewrite: Epics table's Stories column becomes a flat "0 (not yet decomposed)" or is dropped entirely; the "Phase 1 Epic Stories Summary" table (demo-level, story-count detail) is removed; each epic summary's "(N stories)" suffix and any story-number reference is dropped, keeping the plain-language outcome text.

### 4.3 `epics/index.md`

```diff
 | **1** — Foundations | [phase-1/](phase-1/index.md) | 🟡 Planned — 10 epics, 22 stories |
+| **1** — Foundations | [phase-1/](phase-1/index.md) | 🟡 Planned — 10 epics (not yet storied) |
```
```diff
-Phase 1 has completed all four steps. Phase 0 has two epics through all four steps ...
+Phase 1 has completed steps 1-2 (epics designed); stories not yet created — reverted 2026-08-21, SCP (e). Phase 0 has two epics through all four steps ...
```
Frontmatter `stepsCompleted` drops `step-03-create-stories-phase-1` and `step-04-final-validation-phase-1`.

### 4.4 `epics/fr-coverage-map.md`

Every citation like `[Epic 1.4](phase-1/epic-1.4-user-authenticates.md) Story 1.4.3` becomes `[Epic 1.4](phase-1/epic-1.4-user-authenticates.md)` — the epic-level pointer survives, the story-level precision is dropped since it no longer exists. Applies to the FR1, FR2, FR3, FR6, FR7, FR8, FR55, FR58, FR59, NFR24 rows.

### 4.5 `epics/framework.md`

```diff
-→ **Phase 1 concrete epics + stories:** [phase-1/](phase-1/index.md)
+→ **Phase 1 concrete epics (not yet storied):** [phase-1/](phase-1/index.md)
```

### 4.6 `_bmad-output/implementation-artifacts/sprint-status.yaml`

Remove all Phase 1 epic and story keys (`epic-1.0`…`epic-1.8` + their stories + retrospectives). For `epic-1.9`: pending the Section 1 decision, either (a) keep `epic-1.9: in-progress` with only its `1-9-1-…: done` key (Story 1.9.2's key removed), or (b) remove the whole block per full literal consistency. Phase 0's block (`epic-0.0`, `epic-0.1`) is untouched.

### 4.7 `scripts/python/build_html.py` NAV

```diff
-("Epic 1.0 — Platform estate provisioned, verifiable, CNP-compliant (5 stories)", "epics/phase-1/epic-1.0-platform-estate-provisioned", False),
+("Epic 1.0 — Platform estate provisioned, verifiable, CNP-compliant", "epics/phase-1/epic-1.0-platform-estate-provisioned", False),
```
Applied to all 10 Phase 1 entries.

### 4.8 `architecture/changelog.md` — new entry (v4.18)

Records the reversion, the rationale, and the 1.9.1 decision as actually made.

---

## Section 5 — Implementation Handoff

**Scope classification: Moderate** — backlog reorganisation across 10 epic files and 6 connective documents, but no PRD/architecture/FR change and directly implementable in this session (consistent with every other epics-restructuring SCP this repo has recorded).

**Success criteria:**
- All 10 Phase 1 epic files carry no `## Story` sections except as decided for 1.9.1.
- `phase-1/index.md`, `epics/index.md`, `fr-coverage-map.md`, `framework.md` all describe Phase 1 as epic-level-only, consistent with each other.
- `sprint-status.yaml` carries no Phase 1 story keys except as decided for 1.9.1; Phase 0 untouched.
- `build_html.py` NAV and `docs/` regenerated and consistent with the above.
- `architecture/changelog.md` carries a v4.18 entry.
