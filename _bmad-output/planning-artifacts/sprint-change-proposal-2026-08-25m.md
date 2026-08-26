---
type: 'Sprint Change Proposal'
description: 'Relocates _bmad-output/source-docs/ (the joh-schema-confluence and joh-elinks-api archives added earlier the same day by SCP 2026-08-25j and SCP 2026-08-25k) out of the repo entirely, to a local non-versioned path on the requesters machine, at explicit user request, and corrects the two epics that referenced those in-repo archived paths.'
resource: 'sprint-change-proposal-2026-08-25m.html'
tags: [ctam-pathfinder, sprint-change-proposal]
timestamp: '2026-08-25'
title: 'Sprint Change Proposal — 2026-08-25m'
status: 'approved'
---

# Sprint Change Proposal — 2026-08-25m

**Trigger:** Explicit user request — first "remove the source-docs folder completely and update," then refined to "move source-docs from this folder to `/Users/shivakumar/MOJ/docs`." The net effect implemented is the second, refined instruction: relocate, not delete.

**Mode:** Direct execution (unambiguous instruction; no judgment call to iterate on). **Scope classification:** **Minor** — file relocation + reference correction; no AC/FR/NFR/PRD change, no dependency-graph change.

---

## 1. Issue Summary

`_bmad-output/source-docs/` held two archives created earlier the same day:

- `joh-schema-confluence/` (SCP 2026-08-25j) — two distilled PDFs of internal HMCTS Confluence pages describing the JOH eLinks integration schema.
- `joh-elinks-api/` (SCP 2026-08-25k) — the real E-links API v5.0 Swagger doc, plus **real HMCTS production reference-data exports** (`eLinks_Pivotl_Production_all-data_2026-06-01_*`, 11 CSV/JSON files) supplied by the user for the mock-API contract correction.

The user asked for this folder to be taken out of the repo and relocated to `/Users/shivakumar/MOJ/docs` on their own machine — outside version control, outside `ctam-analysis` entirely — and for the resulting references to be updated accordingly.

## 2. Impact Analysis

**Epic impact:** none structural — Epic 0.1 and Epic 0.2's *content* (the schema-design pattern adopted, the mock-API contract corrections) stands independently of whether a local copy of the source material is archived inside the repo. Only the two places that claimed an in-repo archived copy needed correcting.

**Artifact impact:**

| Artifact | Change |
|---|---|
| `_bmad-output/source-docs/` | Moved out of the repo to `/Users/shivakumar/MOJ/docs/source-docs/` (both subfolders, 14 files, preserved intact — not deleted, an unrelated pre-existing PDF already in the destination folder is untouched) |
| `epic-0.1-postgres-sql-schema-design.md` | Design-rigor note's "distilled to `_bmad-output/source-docs/joh-schema-confluence/`" claim removed; a dated note added recording the relocation |
| `epic-0.2-joh-elinks-mock-api-stands-in.md` | Story 0.2.1's References line's "archived to `_bmad-output/source-docs/joh-elinks-api/`" claim corrected to note the archive existed in-repo and was later relocated out |
| `architecture.md` | Decisions #23 and #24 get a short bracketed annotation (`*(relocated out of the repo by #26)*`) — matching the existing #14/#16 precedent for a later decision affecting an earlier one — text otherwise left as immutable history; new decision **#26** |
| `architecture/changelog.md` | New **v4.23** entry; v4.20/v4.21 entries left untouched (immutable history, per this repo's convention) |

**Not touched:** `sprint-change-proposal-2026-08-25j.md`, `sprint-change-proposal-2026-08-25k.md` (dated historical records — immutable, per `CLAUDE.md`'s "leave dated reports and existing changelog entries as immutable history — add, don't rewrite"); the Confluence-page and Swagger-doc *citations themselves* (still valid — only the claim of an in-repo copy is removed); `sprint-status.yaml`, `epics/phase-0/index.md`, `epics/index.md` (no story/count change).

**Not done:** a git-history rewrite. The relocated files remain recoverable from the commits that added them (`a4bd168` for `joh-schema-confluence/`, `3be19ef` for `joh-elinks-api/`) unless the user separately, explicitly requests a history rewrite — not attempted here per this repo's hard rules on destructive git operations.

## 3. Recommended Approach

**Direct Adjustment.** Effort: **Low**. **Risk:** Very low — the relocation was explicitly requested; the only risk was leaving dangling in-repo references, which this SCP corrects.

## 4. Detailed Change Proposals

See §2; full diffs are in the files themselves.

## 5. Implementation Handoff

**Scope: Minor** — direct file relocation + reference correction, no scope or dependency change.

**Responsibilities:**
- **This session:** all edits applied directly; nothing committed or pushed without being asked.

**Success criteria:** `_bmad-output/source-docs/` no longer exists inside `ctam-analysis`; the 14 files are intact at `/Users/shivakumar/MOJ/docs/source-docs/`; no remaining planning-artifact text claims an in-repo archived copy exists; the underlying source citations (Confluence pages, real Swagger doc, real reference-data exports) remain accurately described as sources, just without an in-repo copy; `docs/` (the published site) regenerated from the updated markdown.
