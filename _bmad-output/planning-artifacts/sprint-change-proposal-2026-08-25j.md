---
type: 'Sprint Change Proposal'
description: 'Expands Epic 0.1 from 2 to 4 stories so ctam-joh domain-schema design carries the same rigor as the JOH eLinks integration schema (Confluence 3.2.1.1/3.2.1.2): a written design-decisions doc, an ER diagram, a full column-level spec, and a data-warnings/open-questions companion. The jo_* tables those pages describe stay with Epic 0.3 (ctam-reference-data), not duplicated into Epic 0.1.'
resource: 'sprint-change-proposal-2026-08-25j.html'
tags: [ctam-pathfinder, sprint-change-proposal]
timestamp: '2026-08-25'
title: 'Sprint Change Proposal — 2026-08-25j'
status: 'approved'
---

# Sprint Change Proposal — 2026-08-25j

**Trigger:** User request — two Confluence pages (`3.2.1.1 CTAM JO Schema`, `3.2.1.2 CTAM Schema and Source Mapping`) document how the JOH eLinks integration schema was designed; the user wants CTAM's own PostgreSQL schema designed "in the similar way," with Epic 0.1 updated and new stories authored for it.

**Mode:** Incremental (single artifact, iterated live with the user). **Scope classification:** **Moderate** — epic content is substantially rewritten (2 → 4 stories) and Phase 0 story totals shift, but no PRD/FR/NFR change, no new table, no new repo, no dependency-graph change.

---

## 1. Issue Summary

The user supplied two internal HMCTS Confluence pages under the JUDIT space:

- `3.2.1.1 CTAM JO Schema` — ER diagrams (full + transactional-core) for the JOH eLinks integration.
- `3.2.1.2 CTAM Schema and Source Mapping` — the same schema's design decisions (naming, JOH lifecycle, deprecated-attribute exclusion, sync metadata, FK strategy, a documented edge case), a 16-table list, a full column-level mapping per table (CTAM column / type / PK-FK / source attribute / description), a refresh-strategy note, 8 numbered data warnings, and 13 numbered open questions (11 closed, 2 open).

Both pages are behind HMCTS's internal `tools.hmcts.net` Confluence, unreachable from this environment; the user exported them to PDF, which were read in full and distilled to `_bmad-output/source-docs/joh-schema-confluence/`.

Cross-checking the source pages against the current architecture surfaced a structural fact the user's request needed reconciling with: the 16 tables these pages describe are the **tier-(a) `jo_*` upstream-replica schema**, which `architecture/data-tables.md` and decision D3/D9 already assign to **`ctam-reference-data` / Epic 0.3** (Story 0.3.2) — a different repo and a different, non-overlapping table set from **Epic 0.1**'s 5 CTAM-owned tier-(b) `ctam-joh` overlay tables (`ctam_working_patterns`, `ctam_working_pattern_days`, `ctam_joh_ticket`, `ctam_joh_location`, `ctam_jurisdictional_splits`). Duplicating `jo_*` table definitions into Epic 0.1 would put tier-(a) DDL in the wrong repo and break the single-writer tier-ownership rule (AR49: only `ctam_reference_data` holds INSERT/UPDATE on `jo_*`).

The user, on hearing this, directed: keep the update on Epic 0.1, and design `ctam-joh`'s own schema **the same way** the source pages design theirs — i.e. adopt the *documentation rigor* (design-decisions doc → ER diagram → column-level spec → data-warnings/open-questions doc), not the specific `jo_*` tables. This SCP implements that direction.

## 2. Impact Analysis

### Epic Impact

**Epic 0.1** (`epic-0.1-postgres-sql-schema-design.md`) — substantially rewritten:
- Story count: 2 → 4.
- Story 0.1.1 (scaffold `ctam-joh`) — unchanged content; forward-references to "Story 0.1.2" for table creation corrected to point at the new Story 0.1.3.
- **New Story 0.1.2** — a schema design-decisions doc (`architecture/ctam-joh-schema-design.md`), covering naming/PK/FK conventions, the `ctam_jurisdictional_splits` cross-row invariant decision (carried forward verbatim from the old Story 0.1.2's AC), the tier-(b)-vocabulary FK verification gate (also carried forward), and an explicit restatement of the grant model.
- **Story 0.1.3** (rewritten from the old Story 0.1.2) — the actual DDL, now paired with a D2+ELK ER diagram (house standard, `CLAUDE.md`) and a full column-level reference per table, mirroring the source pages' own column-mapping tables (minus a "source attribute" column, since these are CTAM-native tables with no upstream source).
- **New Story 0.1.4** — a data-warnings/open-questions companion doc, mirroring the source pages' §5–6, seeded with three concrete warning candidates specific to `ctam-joh`'s overlay tables (soft-delete parity on upstream leaver/deleted, split re-validation timing, overlay reconciliation against the tier-(a) baseline).
- Epic-level frontmatter (`description`, `storyCount`), vertical-slice bullets, and out-of-scope note updated to match.

**Epic 0.3** (`ctam-reference-data`, tier-(a) `jo_*` tables) — **not touched by this SCP.** Its Story 0.3.2 already lists the correct 15 `jo_*` table names (matching the source pages' table list exactly) but has no column-level detail. The source pages could supply that detail and may partially close `gaps.md` G8.1 (previously: "the JOH eLinks API contract... is unconfirmed" — these pages are sourced from "eLinks (a.k.a. JHR) REST API, Data Dictionary v2.0, 2025-07-02," i.e. a real, dated contract artefact). This is flagged as a follow-up, not actioned here, since the user's request was explicitly scoped to Epic 0.1.

**`data-tables.md`** — not touched. Its `jo_*` and `ctam-joh` sections both remain accurate at the level of detail they already carry (table names + one-line descriptions); this SCP adds column-level detail to Epic 0.1's own doc set, not to this shard.

### A naming question surfaced, deliberately not resolved here

The source pages' real natural-key column is `jo_people.personal_code` (VARCHAR(32)) — but 27 files across this repo (PRD, `architecture.md`, `conventions.md`, every Phase-0 epic, decision D9) use `personnel_number` for the same concept, and `personal_code` appears nowhere in the current repo. This is a `jo_*`/Epic 0.3 concern, not an Epic 0.1 one (Epic 0.1's own tables reference `ctam_joh_identities.id` via `joh_id`, never `personnel_number` directly, so the rename — if made — would not change any Epic 0.1 AC). Raised here for visibility; **not actioned**, and left for a future SCP scoped to Epic 0.3 if the user wants it resolved.

### Artifact sweep

| Artifact | Change |
|---|---|
| `epic-0.1-postgres-sql-schema-design.md` | Full rewrite: 2 → 4 stories, frontmatter, vertical slice, out-of-scope note |
| `epics/phase-0/index.md` | Epic table row (2 → 4 stories), Epic 0.1 summary paragraph, Phase 0 Epic Stories Summary table row, both story totals (17 → 19) |
| `epics/index.md` | Phase 0 status line story total (17 → 19) |
| `architecture.md` | New decision **#23** |
| `architecture/changelog.md` | New **v4.20** entry |
| `_bmad-output/source-docs/joh-schema-confluence/` | New — the two source PDFs, copied in (source documents are read-only elsewhere in the repo; this is the designated distillation location) |

**Not touched:** `epic-0.0`, `epic-0.2`, `epic-0.3`, `epic-0.4` (flagged as a follow-up candidate only, per above); `data-tables.md`; `gaps.md` (G8.1 flagged, not edited); `fr-coverage-map.md` (Epic 0.1's FR coverage claim — "schema groundwork only" — is unchanged by this expansion); `requirements-inventory.md` (no new AR — this epic cites existing AR2–AR32 plus `CLAUDE.md`'s D2+ELK diagram standard, which isn't a numbered AR); `sprint-status.yaml` (out of this session's scope — a sprint-planning concern, not a course-correction one); dated historical SCPs/changelog entries (immutable record).

## 3. Recommended Approach

**Direct Adjustment** — rewrite Epic 0.1 in place; no rollback, no MVP scope change. Effort: **Moderate** (one epic substantially rewritten, two index files updated, one decision-log + changelog entry). Risk: **Low** — additive documentation rigor to an epic with no implementation started yet (per the epic's own "nothing built yet" precedent, decision #8); no FR/NFR/dependency-graph change; the one open naming question is explicitly deferred rather than silently decided.

## 4. Detailed Change Proposals

See §2 for the full before/after mapping; the rewritten epic file carries complete Given/When/Then ACs for all 4 stories.

Story-shape rationale (why 4, not more or fewer): the source pages' own structure has four natural phases — *design decisions* (§1), *ER diagram* (their two diagrams), *column-level mapping* (§3, 16 sub-sections), *data warnings/open questions* (§5–6). Column-level mapping and the ER diagram are combined into one story (0.1.3) because for CTAM-native tables the diagram and the DDL are authored together, not sequentially the way a replicated schema's diagram (fixed by the source) can precede its mapping table.

## 5. Implementation Handoff

**Scope: Moderate** — epic content substantially rewritten (backlog reorganization: story count changes, no code exists yet to migrate). Routed to **Product Owner / Developer agents** for sprint-planning pickup (`bmad-sprint-planning` will need to regenerate `sprint-status.yaml` entries for the new Story ids 0.1.2–0.1.4, since the old 0.1.2 no longer refers to table DDL).

**Responsibilities:**
- **This session:** all edits above applied directly; nothing committed without being asked.
- **Follow-up (not this SCP, flagged for a future one):** an equivalent column-level documentation pass against Epic 0.3 Story 0.3.2 / `data-tables.md`'s `jo_*` section, using the same two source pages; and a decision on the `personnel_number` vs. `personal_code` naming question.

**Success criteria:** Epic 0.1 has 4 stories with complete ACs; every forward/backward story cross-reference within the epic resolves correctly (0.1.1 → 0.1.2/0.1.3/0.1.4; 0.1.3 depends on 0.1.2; 0.1.4 depends on 0.1.2 + 0.1.3); Phase 0 story totals are consistent across `epic-0.1`, `phase-0/index.md`, and `epics/index.md` (19 everywhere); the decision log and changelog both record this as a traceable, dated change; the `jo_*` schema itself is not duplicated anywhere in Epic 0.1.
