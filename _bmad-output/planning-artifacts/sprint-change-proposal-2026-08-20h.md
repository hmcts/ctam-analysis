---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — swap epics/phase-0/ and epics/phase-1/'
description: 'Date: 2026-08-20 — the epics/ directory pair is swapped: Foundations (the ten-epic, 22-story phase) moves from epics/phase-0/ to epics/phase-1/, renumbered 0.0-0.9 -> 1.0-1.9; JOH (the one-epic contract-mock phase added same day) moves from epics/phase-1/ to epics/phase-0/, renumbered 1.0 -> 0.0. Scoped per explicit user clarification to the epics/ directories and epic-ID numbers only -- PRD.md and architecture.md keep their existing Phase 0 = Foundations narrative, which now reads backwards against the epics/ folder names.'
resource: 'sprint-change-proposal-2026-08-20h.html'
tags: [ctam-pathfinder, sprint-change, epics, phase-0, phase-1]
timestamp: '2026-08-20'
parent: 'planning-artifacts/index.md'
project: 'ctam-analysis (CTAM Pathfinder)'
change_scope: 'Moderate — directory + epic-ID renumbering across two phases, no PRD/architecture/FR change'
mode: 'Batch'
architectureVersion: 'v4.13'
last_updated: 2026-08-20
---

# Sprint Change Proposal — 2026-08-20 (h)

**Swap `epics/phase-0/` and `epics/phase-1/`**

---

## Section 1 — Issue Summary

**Trigger:** *"swap phase-0 and phase-1"*. Phase 0 (Foundations — 10 epics, 22 stories) and Phase 1 (JOH — 1 epic, 1 story, added same day by SCP 2026-08-20g) traded places: Foundations becomes Phase 1, JOH becomes Phase 0.

**Scope, clarified with the user before starting:** the literal request could mean anything from a folder rename to a full rewrite of the PRD's and architecture's phase narrative. Asked to choose; the user selected the narrowest of the offered options: *"Just swap the two epics/ directories and their epic-ID numbers"* — `epics/phase-0/` ↔ `epics/phase-1/`, `epic: 0.X` → `1.X` and `1.0` → `0.0`, `depends_on` updated to match. **`prd.md` and `architecture.md`'s narrative ("Phase 0 = Foundations") are explicitly NOT touched** — only the planning-epics numbering flips, which now reads backwards against them. This is the same tradeoff already accepted, and is consistent with how `architecture/repository-strategy.md`'s per-repo "Phase" column and the conceptual "Phase 0 (Foundations)" mentions in `architecture/gaps.md` and `epics/requirements-inventory.md` were left alone — they are architecture narrative, siblings/derivatives of `architecture.md`, not the `epics/` directory structure this SCP's scope covers.

**One judgment call made while implementing, not separately confirmed with the user:** the phase-index files (`epics/phase-0/index.md`, `epics/phase-1/index.md`) and `epics/framework.md` have their own `phase:` frontmatter field and self-titling ("Phase 0 — Foundations", "### Phase 0 · Area: ..."). Since the mechanical part of the swap already flips their `phase:` frontmatter value, leaving their own headings unflipped would create direct self-contradiction *within the same file* (a file whose frontmatter says `phase: 1` titled "Phase 0 — Foundations"). Judged that a **full, self-consistent swap of "Phase N" everywhere under `epics/`** — including these files' own titles, framework.md's Phase × Area table and section headers, and `epics/index.md`'s phase-status table — is the more defensible reading than leaving those specific headings stale, while still holding the line at `epics/`: `prd.md`, `architecture.md`, and `architecture.md`'s own sibling shards (`repository-strategy.md`, `gaps.md`'s and `requirements-inventory.md`'s conceptual "Phase 0" mentions) are untouched, exactly as the user specified. Flagging this here since it extends "epic-ID numbers" to "epics/-internal phase concept" by inference, not by direct instruction.

**Status check:** all 11 affected stories remain `backlog` except Story 1.9.1 (`done`, carried over unchanged) and Epic 1.9 (`in-progress`, carried over unchanged). No code exists in any of the 16 execution-unit repos for either phase. Low implementation risk; high documentation-consistency risk given the file count, which is why the full verification battery below was run.

---

## Section 2 — Impact Analysis

### 2.1 Structural impact

| Change | Detail |
|---|---|
| Directory swap | `epics/phase-0/` (old Foundations, 10 epics) ↔ `epics/phase-1/` (old JOH, 1 epic) — staged through a temporary directory name (`phase-temp`) to break the 2-way cycle safely |
| Foundations epics renumbered | `epic-0.0` … `epic-0.9` → `epic-1.0` … `epic-1.9` (10 files, `git mv`, permutation-safe via temp names) |
| JOH epic renumbered | `epic-1.0-joh-elinks-api-contract-mock.md` → `epic-0.0-joh-elinks-api-contract-mock.md` |
| `depends_on` | Every Foundations epic's internal `depends_on` re-pointed to the new `1.X` ids; the JOH epic's cross-phase `depends_on: [epic-1.1]` (was `[epic-1.1]` pointing at the schema epic under its *old* 1.1 id — re-verified still correct, since the schema epic kept the same relative position, now at `epic-1.1` under the new numbering) |
| Phase-index files rewritten | `epics/phase-1/index.md` (new home of Foundations) self-titles "Phase 1 — Foundations"; `epics/phase-0/index.md` (new home of JOH) self-titles "Phase 0 — JOH" — both frontmatter and body fully rewritten for internal self-consistency, not just path-updated |
| `epics/framework.md` | Phase × Area summary table's JOH row moved to phase **0** (now first row) and Foundations rows moved to phase **1**; all eight `### Phase 0 · Area: ...` Foundations subheaders → `### Phase 1 · Area: ...`; the JOH section header/subheader → `## Phase 0 — JOH` / `### Phase 0 · Area: JOH Records & Working Patterns`; "Phase dependency order" table's JOH row → **0 — JOH**, Absence/Sitting rows' "depends on Phase 1" → "Phase 0", Itineraries' now-discontiguous "Phases 1–5" range corrected to "Phases 0, 2–5" |
| `epics/index.md` | Phase-status table rows and the "Phase 0 has completed... Phase 1 has one epic..." sentence swapped to match |
| `epics/fr-coverage-map.md` | Section header "Phase 0 (concrete epics)" → notes it now lives in `phase-1/` as 1.0–1.9; pending-table header and the FR10–FR18/JOH row's Phase column corrected `1` → `0`; two bare "Phase 0" mentions describing Foundations-era behaviour (user-JWT propagation, `ctam-ui` delivery phase) corrected to `Phase 1` |
| Two stale depends_on **comments** found and fixed (not caught by any prior sweep, since they're inside YAML comments) | `epic-1.4-user-authenticates.md`: "the schema (0.1)" → "(1.1)"; `epic-1.8-system-dispatches-emails.md`: "alongside 0.1/0.2/0.3/0.4" → "alongside 1.1/1.2/1.3/1.4" |
| One genuinely wrong cross-reference found and fixed | `architecture/repo-structure.md` had three mentions of "Epic 0.0" meaning the platform-estate epic — since `epic-0.0` is now a *different* epic (JOH contract-mock), these were silently pointing at the wrong deliverable, not just reading backwards; corrected to "Epic 1.0" |
| `architecture/gaps.md` G8.7 | "Epic 0.0 (Phase 1, ...)" corrected to "Epic 0.0 (Phase 0, ...)" (epic-0.0 now lives in phase-0/, not phase-1/); "the Phase 0 epic/story text that names it" corrected to "Phase 1" (personnel_number is named in the JOH ETL epic, which is in Foundations, now Phase 1) |
| `architecture/delivery-operating-model.md` + `delivery/README.md` | "Epic 1.8 (Notification) ... alongside 0.1/0.2/0.3/0.4" → "alongside 1.1/1.2/1.3/1.4" (both files carried this stale mention already, predating this swap) |
| `_bmad-output/implementation-artifacts/sprint-status.yaml` | Fully re-keyed: `epic-0.0`…`epic-0.9` (+ their `0-N-M-slug` story keys) → `epic-1.0`…`epic-1.9` (+ `1-N-M-slug`); `epic-1.0` (+ `1-0-1-…`) → `epic-0.0` (+ `0-0-1-…`); statuses carried over unchanged (Epic 1.9 `in-progress`, Story 1.9.1 `done`) |
| `scripts/python/build_html.py` NAV | The two `Implementation — Phase N` sections swapped in both order and content (epic list, paths, titles) to match the new directory contents |

### 2.2 What was deliberately left alone (architecture narrative, not epics/ structure)

`architecture/repository-strategy.md`'s per-repo "Phase" column (0 for Foundations components, 1 for `ctam-joh`) and the general "Phase 0 deliverable" mentions in `architecture/gaps.md` and `epics/requirements-inventory.md` all describe the **conceptual** programme phase — the same concept `architecture.md`'s own narrative uses — and are left unchanged per the user's explicit scope. These now read backwards against the `epics/` folder names (folder `phase-1/` holds what `repository-strategy.md` still calls "Phase 0"), which is the accepted tradeoff, not a bug. Only genuine epic-file **cross-references** in these same files (e.g. `repo-structure.md`'s "Epic 0.0") were corrected, since those point at a specific file, not a concept.

### 2.3 Technical impact

None — no code exists for any affected repo.

---

## Section 3 — Recommended Approach

**Direct adjustment** — swap the two directories, renumber every epic/story id and `depends_on` inside them, make each phase-index and `framework.md`/`epics/index.md` internally self-consistent with its new phase number, and fix the handful of genuine (not conceptual) cross-reference bugs uncovered along the way. No PRD, architecture-narrative, or FR/NFR change, per explicit scope. Effort: moderate-to-high (two 10+1-file renumbering passes plus five connective-tissue files); risk: low on implementation (nothing built yet), moderate on documentation consistency (mitigated by the verification battery below).

---

## Section 4 — Verification performed

Extended the standard checklist across both swapped phase directories:

- **Link resolution:** every markdown link in `epics/phase-0/*.md`, `epics/phase-1/*.md`, `epics/framework.md`, `epics/index.md`, and `epics/fr-coverage-map.md` resolves to an existing file — checked programmatically, zero broken links.
- **`storyCount` vs. actual headings:** every epic file's `storyCount:` frontmatter matches its actual count of `## Story` headings — checked programmatically across all 11 epic files, zero mismatches.
- **Story-heading vs. epic-number:** every `## Story N.M.x` heading's `N.M` prefix matches its file's own `epic:` frontmatter value and filename — checked programmatically, zero mismatches.
- **`depends_on` correctness:** every epic's `depends_on` list was read back and confirmed to reference an existing epic id under the new numbering; this pass is what surfaced the two stale YAML-comment bugs (epic-1.4, epic-1.8) fixed in 2.1.
- **Repo-wide grep sweep** for stale old-numbered references across `architecture/`, `epics/`, and `delivery/`, filtered to exclude dated SCPs/reports/changelog entries (immutable history, correctly left untouched) — surfaced and fixed the `repo-structure.md` "Epic 0.0" bug and the `gaps.md` G8.7 phase-tag bug.
- **Site rebuild:** `scripts/build-html.sh` runs clean, no warnings; `docs/epics/phase-0/` and `docs/epics/phase-1/` regenerated with the swapped content and no broken links.

---

## Section 5 — Implementation Handoff

**Scope classification: Moderate** — directory + epic-ID renumbering across two phases plus connective-tissue fixes, no PRD/architecture-narrative/FR change, no code exists yet.

**Route:** Developer agent (this session) implements directly. No PO/PM/Architect escalation needed for the swap itself. **Flag for the product owner:** the judgment call in Section 1 (full self-consistent "Phase N" swap within `epics/`, versus the narrower reading of touching only specific epic-ID/path references) was not separately confirmed — worth a quick look at `epics/framework.md` and the two phase indexes to confirm this reads as intended.

**Success criteria:** the verification checks in Section 4 pass (all do); `git status` shows the directory swap, ten-plus-one file renumbering, and the connective-tissue edits listed in Section 2.1 with no unrelated changes; the published `docs/` site's Phase 0/Phase 1 sections reflect the swap with no broken links.
