---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — renumber JOH/MRD ETL epics 0.7/0.8 to 0.2/0.3, cascading five epics up by two'
description: 'Date: 2026-08-20 — the two ETL epics created by SCP 2026-08-20b (JOH eLinks at 0.7, MRD ingestion at 0.8) move to 0.2/0.3, directly after the schema epic (0.1) they depend on. Since 0.2 and 0.3 were already taken by user-authenticates and reference-data-read-only-api, this cascades: 0.2→0.4, 0.3→0.5, 0.4→0.6, 0.5→0.7, 0.6→0.8, 0.7→0.2, 0.8→0.3. Epics 0.0/0.1 and their stories are untouched; every other epic and its stories are renumbered with it. No AC content changed; every story remains backlog.'
resource: 'sprint-change-proposal-2026-08-20c.html'
tags: [ctam-pathfinder, sprint-change, epics, phase-0]
timestamp: '2026-08-20'
parent: 'planning-artifacts/index.md'
project: 'ctam-analysis (CTAM Pathfinder)'
change_scope: 'Moderate — backlog renumbering, no PRD/architecture/FR change'
mode: 'Batch'
architectureVersion: 'v4.8'
last_updated: 2026-08-20
---

# Sprint Change Proposal — 2026-08-20 (c)

**Renumber Epics 0.7/0.8 (JOH/MRD ETL) to 0.2/0.3 — a seven-epic cascade**

---

## Section 1 — Issue Summary

**Trigger:** a direct request — *"change 0.7 and 0.8 epics to 0.1 and 0.2"*. SCP 2026-08-20b had just split the old Epic 0.1 into three: schema-design (kept as 0.1), JOH eLinks ETL (new 0.2 → but appended as **0.7** to avoid touching every existing cross-reference), MRD ETL (new 0.3 → appended as **0.8**). The product owner wants the two ETL epics to sit immediately after the schema epic they depend on, not tacked on at the end.

**The complication:** Epic numbers **0.1 and 0.2** as literally requested collide with epics that already exist — 0.1 is the schema epic itself (just split out), and 0.2 is `user-authenticates`. Clarified with the user directly: proceed with the **cascade** option — schema stays 0.1, JOH ETL → 0.2, MRD ETL → 0.3, and everything from the old 0.2 onward shifts up by two to make room. This is a full seven-epic renumbering, one single permutation cycle:

```
0.2 → 0.4   (user-authenticates)
0.3 → 0.5   (reference-data-read-only-api)
0.4 → 0.6   (user-populations-bootstrapped)
0.5 → 0.7   (system-dispatches-emails / notification)
0.6 → 0.8   (context-bus-and-shared-baseline)
0.7 → 0.2   (joh-reference-data-etl-process)
0.8 → 0.3   (mrd-reference-data-etl-process)
```

Epics 0.0 and 0.1 (and their stories 0.0.1–0.0.5, 0.1.1–0.1.2) are untouched — the whole point of keeping 0.1 stable through the prior split (SCP 2026-08-20b) was to absorb exactly this kind of follow-on churn without a second cascade through the foundational epics.

**Status check (why this is still low-risk despite the size):** every story under every renumbered epic remains `backlog`. Nothing has been dispatched; no branch, packet, or code exists for any of them. This is a pure planning-artifact renumbering.

---

## Section 2 — Impact Analysis

### 2.1 Epic impact

| Old → New | Epic | File renamed | `depends_on` after |
|---|---|---|---|
| 0.7 → **0.2** | JOH reference-data ETL process | `epic-0.7-joh-…` → `epic-0.2-joh-…` | `[epic-0.1]` (unchanged — still just needs the schema) |
| 0.8 → **0.3** | MRD reference-data ETL process | `epic-0.8-mrd-…` → `epic-0.3-mrd-…` | `[epic-0.1]` (unchanged) |
| 0.2 → **0.4** | User authenticates | `epic-0.2-user-authenticates.md` → `epic-0.4-…` | `[epic-0.0, epic-0.1, epic-0.2]` — gains the renumbered JOH-ETL id |
| 0.3 → **0.5** | Reference data read-only API | `epic-0.3-reference-data-read-only-api.md` → `epic-0.5-…` | `[epic-0.1, epic-0.2, epic-0.3, epic-0.4]` — every id shifts |
| 0.4 → **0.6** | User populations bootstrapped | `epic-0.4-user-populations-bootstrapped.md` → `epic-0.6-…` | `[epic-0.1, epic-0.4]` — the auth id shifts |
| 0.5 → **0.7** | Notification (system dispatches emails) | `epic-0.5-system-dispatches-emails.md` → `epic-0.7-…` | `[epic-0.0]` (unchanged) |
| 0.6 → **0.8** | Context bus + shared baseline | `epic-0.6-context-bus-and-shared-baseline.md` → `epic-0.8-…` | `[epic-0.0]` (unchanged) |
| 0.1 | Postgres schema design | *(no rename)* | `[epic-0.0, epic-0.8]` — the context-bus id shifts |
| 0.0 | Platform estate | *(no rename)* | `[]` (unchanged) |

Renamed via `git mv` staged through temporary filenames — the mapping is one closed 7-cycle, so a direct rename sequence would have overwritten a not-yet-moved file at some point.

### 2.2 Story impact

Every story under a moved epic is renumbered with its epic (e.g. auth's `0.2.1`–`0.2.5` → `0.4.1`–`0.4.5`; context-bus's `0.6.1`/`0.6.2` → `0.8.1`/`0.8.2`, including `0.6.1`'s `done` status, which carries over). **No Acceptance Criteria content changed anywhere** — this is a pure renumbering.

### 2.3 What the mechanical sweep caught vs. what needed a manual read

A scripted regex pass handled the bulk of the rename safely — it required an `Epic `/`epic-`/`Story ` textual anchor before any digit it touched, specifically so it would **not** false-match version-number substrings that coincidentally contain `0.`+digit (e.g. `Spring Boot Testcontainers 4.1.0`, `gradle-versions:0.54.0`, `JJWT 0.13.0` all appear in these files and were correctly left alone).

That same anchor requirement meant the script **missed compound references with no prefix on the second token**, all found and fixed by reading every touched file in full afterward:

- **Markdown link labels**: `[0.2](epic-0.4-user-authenticates.md)` — the bracketed number is link text, not prose, so it carried the *old* number after the file it pointed to had already been renamed. This broke all three summary tables in `epics/phase-0/index.md`, which were rewritten in ascending order.
- **"Epics 0.1 and 0.7" / "Depends on Epics 0.1 and 0.7"** — only the first number sits next to the word "Epic(s)"; the second, after "and", was untouched.
- **"Stories 0.1.1 / 0.2.1"** — space around the slash defeated the chain-continuation pattern (a no-space variant, e.g. `0.4.3/0.4.5`, worked fine).
- **Bare table cells**: `| 0.7 | 1 story (0.7.1) | ... |` in the "Phase 0 Epic Stories Summary" table — plain text, no anchor at all.

One **pre-existing** content bug (predating this change, from the SCP 2026-08-20b split) surfaced during the read-through and was fixed in passing: Epic 0.4's Story 0.4.3 AC said `jo_people` is "populated by the Epic 0.1 eLinks sync" — it always meant the eLinks-sync epic (now 0.2), not the schema epic (0.1). Corrected to `Epic 0.2`.

### 2.4 Artifact conflicts (files touched)

`epics/phase-0/epic-0.{0,1}-*.md` (content only, no rename) · the seven renamed epic files above · `epics/phase-0/index.md` (epic table, all epic summaries reordered 0.0→0.8, stories-summary table) · `epics/fr-coverage-map.md` · `epics/framework.md` · `epics/requirements-inventory.md` · `architecture/repository-strategy.md` · `architecture/delivery-operating-model.md` (the "runs alongside" parallelism note + the canonical story-packet worked example, which illustrated itself with the real MRD story and needed updating to the new 0.3.1/epic-0.3 identifiers) · `scripts/python/build_html.py` `NAV` list · `_bmad-output/implementation-artifacts/sprint-status.yaml` (every epic/story key from 0.2 onward, full rewrite) · a new `architecture/changelog.md` entry (v4.8, existing rows left as immutable history) · `docs/` regenerated.

**Not touched (historical, per "leave dated reports/changelog immutable"):** `sprint-change-proposal-2026-08-20b.md` and its own file — it accurately records the 0.7/0.8 decision that was current *then*; this SCP is the record of superseding it, not a retroactive edit of it. Existing `changelog.md` rows before v4.8 likewise stand as written.

### 2.5 Technical impact

None — no code exists for any of these repos/stories. Purely planning-artifact and `docs/` changes.

---

## Section 3 — Recommended Approach

**Direct adjustment** — renumber per the cascade above. No PRD, architecture, or FR/NFR change; no rollback or MVP-scope review needed. Effort: mechanical-plus-manual-verification (~1–1.5h given the compound-reference gaps the mechanical pass couldn't safely close); risk: low (nothing dispatched, git-reversible, verified by cross-checking every `depends_on`, every story heading against its parent epic, and every markdown link target after the fact); no timeline impact (story/epic count unchanged, only renumbered).

---

## Section 4 — Verification performed

Before treating this as done, the following were checked programmatically across every touched file:

1. Every `epics/phase-0/*.md` markdown link resolves to a file that exists on disk.
2. Every epic file's `epic:` frontmatter, filename number, and `title:` agree with each other.
3. Every `## Story N.M` heading inside a file matches that file's own epic number (no leftover story numbered under the wrong epic).
4. Every epic's `storyCount:` frontmatter matches its actual story-heading count.
5. Every `depends_on:` array was re-derived from what each epic actually needs (not just mechanically remapped) and cross-checked against the dependency chain.
6. `scripts/build-html.sh` runs clean; the old `docs/*.html` outputs for every renamed file are gone (no stale artefacts) and the new ones exist.

---

## Section 5 — Implementation Handoff

**Scope classification: Moderate** — backlog renumbering across planning artifacts, no PRD/architecture/FR change, no code exists yet for the affected stories.

**Route:** Developer agent (this session) implements directly — file renames, content fixes, `sprint-status.yaml` rewrite, changelog entry, `scripts/build-html.sh` regeneration. No PO/PM/Architect escalation needed; there's no scope or requirements change, only a regrouping and renumbering of already-approved, undispatched stories.

**Success criteria:** all six verification checks in Section 4 pass; `git status` shows a clean set of renames + content edits with no orphaned old-numbered files; the published `docs/` site reflects the new numbering with no broken links.
