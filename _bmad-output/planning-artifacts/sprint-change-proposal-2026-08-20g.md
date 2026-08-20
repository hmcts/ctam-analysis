---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — move Epic 0.10 to a new Phase 1 as Epic 1.0'
description: 'Date: 2026-08-20 — Epic 0.10 (JOH eLinks API contract confirmed + CI mock, added by SCP 2026-08-20f) moves out of Phase 0 into a new Phase 1, renumbered 0.10 -> 1.0. This is the programmes first Phase-1 decomposition, though Phase 1s primary area (JOH Records & Working Patterns, FR10-FR18) remains framework-only. Two more staleness bugs (framework.md using bare lowercase epic references, epics/index.md carrying a stale epic/story count) were found and fixed during the full re-read this move required.'
resource: 'sprint-change-proposal-2026-08-20g.html'
tags: [ctam-pathfinder, sprint-change, epics, phase-0, phase-1]
timestamp: '2026-08-20'
parent: 'planning-artifacts/index.md'
project: 'ctam-analysis (CTAM Pathfinder)'
change_scope: 'Moderate — epic relocation across phases, no PRD/architecture/FR change'
mode: 'Batch'
architectureVersion: 'v4.12'
last_updated: 2026-08-20
---

# Sprint Change Proposal — 2026-08-20 (g)

**Move Epic 0.10 to a new Phase 1, renumbered as Epic 1.0**

---

## Section 1 — Issue Summary

**Trigger:** *"move epic-0.10 to new phase-1"*. Epic 0.10 (JOH eLinks API contract confirmed + CI mock, added by SCP 2026-08-20f) was appended to Phase 0 because Phase 0 already existed and had a schema-design epic (0.1) it naturally depends on. On reflection, its content — confirming an upstream JOH data contract — fits better as the opening epic of **Phase 1 (JOH)**, whose primary area (JOH Records & Working Patterns, FR10–FR18) is exactly what depends on that same upstream data. Phase 1 has never been decomposed before; this is this programme's first Phase-1 epic.

**Numbering:** the move retires the need for the quoted `epic: "0.10"` workaround (Phase 0's ten single-digit slots, 0.0–0.9, were exhausted). As the first epic of a brand-new phase, it becomes **Epic 1.0** — a normal, unquoted float, no collision risk.

**Scope of this move:** only Epic 0.10/1.0 relocates. Phase 1's primary area (FR10–FR18, `ctam-joh`/`ctam-ui` JOH module) remains framework-only — this SCP does not decompose it; that is separate future work via `bmad-create-epics-and-stories`.

**Status check:** the epic's one story remains `backlog`. Nothing dispatched, no code exists. Low-risk.

---

## Section 2 — Impact Analysis

### 2.1 Structural impact

| Change | Detail |
|---|---|
| New directory | `epics/phase-1/` — this programme's first Phase-1 decomposition |
| File moved | `epics/phase-0/epic-0.10-joh-elinks-api-contract-mock.md` → `epics/phase-1/epic-1.0-joh-elinks-api-contract-mock.md` |
| Epic renumbered | `0.10` (quoted string) → `1.0` (unquoted float) |
| Story renumbered | `0.10.1` → `1.0.1`; AC content unchanged |
| `depends_on` | Unchanged: `[epic-0.1]` — a normal cross-phase dependency (Phase 1 already depends on Phase 0 as a whole) |
| New file | `epics/phase-1/index.md` — mirrors `phase-0/index.md`'s structure, scaled to one epic; documents that FR10–FR18 remains framework-only |
| Phase 0 | Epic 0.10's table row, epic-summary block, and stories-table row removed; totals revert to **10 epics, 22 stories** |
| `epics/index.md` | Phase 0 row corrected from a stale "6 epics, 19 stories" to the current 10/22; Phase 1 row now links `phase-1/index.md` ("1 epic, 1 story") |

### 2.2 Two more staleness bugs found and fixed during the mandatory full re-read (both predating this move)

1. **`epics/framework.md`'s "Phase dependency order" table used bare lowercase `epic N.M` references** — no hyphen (`epic-0.5`), no capital "Epic" (`Epic 0.5`) — a pattern none of the prior three renumbering sweeps' greps matched (they searched for `Epic 0\.[0-9]` and `epic-0\.[0-9]`, not bare lowercase `epic 0.5`). Found: "Phase 0 epics 0.2, 0.3" (meant auth + JOH-read-API; those have been 0.4/0.5 since SCP 2026-08-20c) in two rows, and "epic 0.5" (meant Notification; that's been 0.8 since the same SCP) in one row and the parallelism note below the table. All four corrected; the parallelism note also extended to `0.1/0.2/0.3/0.4` to match the equivalent already-fixed sentences in `delivery/README.md` and `delivery-operating-model.md`.
2. **`epics/index.md`'s phase-status table** carried a stale "6 epics, 19 stories" for Phase 0 (accurate only up to the very first split, SCP 2026-08-20b) — corrected to the current 10 epics / 22 stories in the same edit that added Phase 1's row.

Each of the last three renumbering SCPs (2026-08-20c/d/e) found at least one file that earlier sweeps missed due to a different reference format (bracket link labels, bare table cells, lowercase-no-hyphen prose). This SCP's find — bare lowercase epic mentions in prose tables — extends that list. A repo-wide grep for `epic 0\.[0-9]` (lowercase, no hyphen) turned up nothing further outside historical SCPs, `delivery-operating-model.md`'s already-correct "epic 0.0" mention (unaffected — 0.0 never moves), and one historical SCP (2026-07-09) correctly left untouched.

### 2.3 Artifact conflicts

The two new/moved epic files · `epics/phase-0/index.md` · `epics/index.md` · `epics/fr-coverage-map.md` (NFR24 row repointed; Phase 1 pending-table row gains a note) · `epics/framework.md` (two staleness fixes) · `architecture/gaps.md` (G8.7's epic reference) · `scripts/python/build_html.py` NAV (Phase 0 entry removed, new Phase 1 NAV section added) · `_bmad-output/implementation-artifacts/sprint-status.yaml` (`epic-0.10`/`0-10-1-…` → `epic-1.0`/`1-0-1-…`) · a new `architecture/changelog.md` entry (v4.12) · `docs/` regenerated (including a new `docs/epics/phase-1/` directory).

### 2.4 Technical impact

None — no code exists for any affected repo.

---

## Section 3 — Recommended Approach

**Direct adjustment** — relocate the epic, stand up the minimal Phase 1 structure, fix the staleness found in passing (both directly relevant: `framework.md`'s Phase-dependency table is exactly what a reader moving an epic between phases needs accurate). No PRD, architecture, or FR/NFR change. Effort: moderate (new directory + index authored, not just a rename); risk: low.

---

## Section 4 — Verification performed

Extended the standard checklist to cover both phase directories: every markdown link in `epics/phase-0/*.md` and `epics/phase-1/*.md` resolves to an existing file in the correct phase directory; `storyCount:` matches actual headings in both phases; the story heading (`## Story 1.0.1`) matches the file's own `epic: 1.0`; `depends_on: [epic-0.1]` is a real, existing epic (cross-phase, expected); a repo-wide grep for stale `0.10`/`epic-0.10` references turned up only the intentional historical mentions (this epic's own "moved from 0.10" note, and the v4.11 changelog entry); `scripts/build-html.sh` runs clean and produces a new `docs/epics/phase-1/` directory with no broken links.

---

## Section 5 — Implementation Handoff

**Scope classification: Moderate** — epic relocation across phases plus a new (minimal) phase index, no PRD/architecture/FR change, no code exists yet.

**Route:** Developer agent (this session) implements directly. No PO/PM/Architect escalation needed for the relocation itself. **Separate from this change:** decomposing Phase 1's primary area (FR10–FR18, JOH Records & Working Patterns) is real future work, not started here — flagged in `phase-1/index.md`'s "Not yet storied" section for whoever runs `bmad-create-epics-and-stories` against it next.

**Success criteria:** the verification checks in Section 4 pass; `git status` shows the epic file moved (not duplicated), a new `phase-1/index.md`, and the small set of connective-file edits with no unrelated changes; the published `docs/` site's new Phase 1 section has no broken links.
