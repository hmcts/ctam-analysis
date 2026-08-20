---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — move MRD reference-data read-API epic from 0.9 to 0.6'
description: 'Date: 2026-08-20 — the MRD reference-data read-API epic (added by SCP 2026-08-20d at the next free slot, 0.9) moves to 0.6, directly after the JOH read-API epic (0.5) it extends. Since 0.6 was taken, this cascades a 4-epic permutation: 0.6->0.7, 0.7->0.8, 0.8->0.9, 0.9->0.6. Epics 0.0-0.5 and their stories are untouched. Two pre-existing staleness bugs (one from this session, one surviving two prior renumbering rounds in delivery/README.md) were found and fixed during the mandatory full re-read.'
resource: 'sprint-change-proposal-2026-08-20e.html'
tags: [ctam-pathfinder, sprint-change, epics, phase-0]
timestamp: '2026-08-20'
parent: 'planning-artifacts/index.md'
project: 'ctam-analysis (CTAM Pathfinder)'
change_scope: 'Moderate — backlog renumbering, no PRD/architecture/FR change'
mode: 'Batch'
architectureVersion: 'v4.10'
last_updated: 2026-08-20
---

# Sprint Change Proposal — 2026-08-20 (e)

**Move Epic 0.9 (MRD reference-data read API) to 0.6, directly after Epic 0.5**

---

## Section 1 — Issue Summary

**Trigger:** *"move mrd-reference-data-read-api after epic-0.5"*. SCP 2026-08-20d created the MRD read-API epic and appended it at the next free slot, **0.9**, explicitly flagging that as a zero-cascade default the user could redirect if they wanted adjacency instead. They did.

**The mapping:** 0.6 (currently `user-populations-bootstrapped`) is taken, so this is a 4-epic permutation cycle, same technique as the two prior renumbering SCPs (2026-08-20c, 2026-08-20e's own predecessor):

```
0.6 → 0.7   (user-populations-bootstrapped)
0.7 → 0.8   (system-dispatches-emails / notification)
0.8 → 0.9   (context-bus-and-shared-baseline)
0.9 → 0.6   (mrd-reference-data-read-api)
```

Epics 0.0–0.5 (and their stories) are untouched.

**Status check:** every story under every moved epic remains `backlog`. Nothing dispatched, no code exists. Low-risk.

---

## Section 2 — Impact Analysis

### 2.1 Epic impact

| Old → New | Epic | File renamed |
|---|---|---|
| 0.9 → **0.6** | MRD reference-data read API | `epic-0.9-mrd-…` → `epic-0.6-mrd-…` |
| 0.6 → **0.7** | User populations bootstrapped | `epic-0.6-user-populations-…` → `epic-0.7-…` |
| 0.7 → **0.8** | Notification | `epic-0.7-system-dispatches-…` → `epic-0.8-…` |
| 0.8 → **0.9** | Context bus + shared baseline | `epic-0.8-context-bus-…` → `epic-0.9-…` |

Every story under a moved epic renumbers with it (context-bus's 0.8.1/0.8.2 → 0.9.1/0.9.2, including 0.8.1's `done` status, carried over unchanged). Epic 0.1's `depends_on` updates from `epic-0.8` to `epic-0.9` (context bus moved again). Epic 0.9 (context bus) is itself unaffected in substance — it's the same epic, third time it's been renumbered (0.6 → 0.8 → 0.9), each time for a different downstream insertion, consistent with its own "the number is not the order" callout.

### 2.2 Two bugs found and fixed during the mandatory full re-read (neither introduced by this move)

1. **`phase-0/index.md` epic-summary ordering** — SCP 2026-08-20d appended the new Epic 0.6 (MRD read-API)'s summary block at the *end* of the "Epic summaries" section instead of positioning it after Epic 0.5, even though the epic *table* above it was already correctly ordered. This move's full re-read caught it; the section is now in strict ascending order 0.0→0.9.
2. **`delivery/README.md` stale since v4.8** — this file lives under `delivery/`, outside the `epics/`/`architecture/` directories the two prior renumbering sweeps grepped, so it was missed twice:
   - *"May be a list — Epic 0.2 spans three repos"* — Epic 0.2 was `user-authenticates` (3 repos) only in the brief window between the original split (SCP 2026-08-20b) and the first cascade (SCP 2026-08-20c); auth has been Epic 0.4 since. Corrected to Epic 0.4.
   - *"Epic 0.5 needs only the estate ... alongside 0.1/0.2"* — Epic 0.5 was Notification only before SCP 2026-08-20c moved it to 0.7 (now 0.8 after this move). Corrected to Epic 0.8, and the parallelism list extended to 0.1/0.2/0.3/0.4 to match the equivalent, already-correct sentence in `delivery-operating-model.md`.
   - *"7 epics, 21 stories ... Epic 0.6 is in-progress"* — stale epic/story counts and the context-bus epic number. Corrected to 10 epics, 22 stories, Epic 0.9.

This file is now added to the standing sweep list for any future Phase 0 epic renumbering.

### 2.3 Artifact conflicts

The four renamed epic files · `epics/phase-0/index.md` (epic table, summary order, both correctly ordered this time) · `epics/fr-coverage-map.md` · `epics/framework.md` · `epics/phase-0/epic-0.1-postgres-db-schema-design.md` (`depends_on`) · `epics/phase-0/epic-0.4-user-authenticates.md` (bootstrap epic-number reference) · `epics/phase-0/epic-0.5-joh-reference-data-read-api.md` (MRD epic-number reference) · `architecture/delivery-operating-model.md` (worked example + parallelism note) · `delivery/README.md` (three stale spots, all predating this move) · `scripts/python/build_html.py` `NAV` list · `_bmad-output/implementation-artifacts/sprint-status.yaml` · a new `architecture/changelog.md` entry (v4.10) · `docs/` regenerated.

### 2.4 Technical impact

None — no code exists for any affected repo. Purely planning-artifact and `docs/` changes.

---

## Section 3 — Recommended Approach

**Direct adjustment** — renumber per the cascade above; fix the two staleness bugs found in passing since they were directly in the blast radius of the files being touched. No PRD, architecture, or FR/NFR change. Effort: mechanical-plus-manual-verification, consistent with the two prior renumbering SCPs; risk: low.

---

## Section 4 — Verification performed

Same checklist as SCPs 2026-08-20c/d, plus a widened repo-wide grep (beyond the `epics/`/`architecture/` file list) that is what surfaced the `delivery/README.md` staleness this time: every markdown link resolves; every `storyCount:` matches actual headings; every `## Story N.M` matches its file's own epic number; every `depends_on:` re-derived from what the epic actually needs; `scripts/build-html.sh` runs clean with no stale old-numbered outputs.

---

## Section 5 — Implementation Handoff

**Scope classification: Moderate** — backlog renumbering, no PRD/architecture/FR change, no code exists yet.

**Route:** Developer agent (this session) implements directly. No PO/PM/Architect escalation needed.

**Success criteria:** the verification checks in Section 4 pass; `git status` shows a clean set of renames + content edits, no orphaned old-numbered files; the published `docs/` site reflects the new numbering with no broken links.
