---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — split Epic 0.1 into schema-design + two ETL-process epics'
description: 'Date: 2026-08-20 — Epic 0.1 (Upstream JOH/MRD reference data is ingested) is split into three epics: Epic 0.1 keeps its number and is narrowed to the ctam-reference-data scaffold + tier-(a) Postgres schema design (its existing Stories 0.1.1/0.1.2, untouched); Story 0.1.3 (JOH eLinks nightly sync) becomes new Epic 0.7 (joh-reference-data-etl-process); Story 0.1.4 (MRD weekly ingestion) becomes new Epic 0.8 (mrd-reference-data-etl-process). No story content changes — only epic-level grouping, numbering, and the cross-references that named the old grouping.'
resource: 'sprint-change-proposal-2026-08-20b.html'
tags: [ctam-pathfinder, sprint-change, epics, phase-0]
timestamp: '2026-08-20'
parent: 'planning-artifacts/index.md'
project: 'ctam-analysis (CTAM Pathfinder)'
change_scope: 'Moderate — backlog reorganization (epic split), no PRD/architecture/FR change'
mode: 'Batch'
architectureVersion: 'v4.6'
last_updated: 2026-08-20
---

# Sprint Change Proposal — 2026-08-20 (b)

**Split Epic 0.1 into `ctam-postgres-db-schema-design`, `joh-reference-data-etl-process`, `mrd-reference-data-etl-process`**

---

## Section 1 — Issue Summary

**Trigger:** a direct request to split **Epic 0.1 (Upstream JOH/MRD reference data is ingested)** into three separately-dispatchable epics named:

1. `ctam-postgres-db-schema-design`
2. `joh-reference-data-etl-process`
3. `mrd-reference-data-etl-process`

**Why this is a clean split.** Epic 0.1 already has four stories that decompose exactly onto these three names, with no AC rewriting needed:

| Existing story | Content | Target epic |
|---|---|---|
| 0.1.1 — Scaffold `ctam-reference-data` | Service scaffold onto the Epic 0.0 estate | `ctam-postgres-db-schema-design` |
| 0.1.2 — Tier-(a) `jo_*` tables, `ctam_sync_status`, write protection | The Postgres schema design + single-writer enforcement | `ctam-postgres-db-schema-design` |
| 0.1.3 — JOH eLinks nightly sync | The ETL process that populates `jo_*` from the eLinks API | `joh-reference-data-etl-process` |
| 0.1.4 — MRD weekly Excel ingestion | The ETL process that populates `mrd_*` from the weekly blob drop | `mrd-reference-data-etl-process` |

**Status check (why this is low-risk):** every one of these four stories is still `backlog` in `sprint-status.yaml` — nothing has been dispatched or implemented. No branch, no packet, no code exists yet for any of them. This is a pure planning-artifact reorganisation before any work starts.

**Numbering decision:** Epic 0.1 **keeps its number** and is narrowed to just the scaffold + schema stories (0.1.1/0.1.2 keep their story numbers unchanged). The two ETL stories move out to **new epics 0.7 and 0.8** (appended after the highest existing epic, 0.6), each carrying one renumbered story (0.1.3 → 0.7.1, 0.1.4 → 0.8.1). Precedent: Epic 0.6 already establishes that "epic numbers are not the order — sequence comes from `depends_on`" (see its own file, which is deliberately numbered out of build order to avoid exactly this kind of cascading renumber). Renumbering Epic 0.1 itself, or renumbering 0.1.1/0.1.2, would force edits to every cross-reference in `fr-coverage-map.md`, `changelog.md`, `assumptions.md`, `repository-strategy.md`, and multiple sibling epics that cite "Story 0.1.1" / "Story 0.1.2" for reasons unrelated to this split (e.g. FR8's first landing point, NFR59's first exercise, the `gh`-CLI manual-setup pattern). Keeping 0.1/0.1.1/0.1.2 stable means only the references to **0.1.3 and 0.1.4** need to move.

**Naming note:** the requested name `ctam-postgress-db-schema-design` is used below as `ctam-postgres-db-schema-design` (single "s") — treating the double "s" as a typo; flag if the double-"s" spelling was intentional.

---

## Section 2 — Impact Analysis

### 2.1 Epic impact

| Epic | Change |
|---|---|
| **Epic 0.1** | Renamed file + title + description; scope narrowed to scaffold + schema design (Stories 0.1.1/0.1.2 unchanged verbatim); "Out of scope" gains an explicit line for the two ETL processes; FR1/NFR24 (population, not schema) move out to Epic 0.7; `depends_on` unchanged (`[epic-0.0, epic-0.6]`) |
| **Epic 0.7 (new)** | `joh-reference-data-etl-process` — carries Story 0.1.3 renumbered to 0.7.1, verbatim AC content; `depends_on: [epic-0.1]` |
| **Epic 0.8 (new)** | `mrd-reference-data-etl-process` — carries Story 0.1.4 renumbered to 0.8.1, verbatim AC content; `depends_on: [epic-0.1]` |
| **Epic 0.2** | `depends_on` gains `epic-0.7` (it needs `jo_people` populated, which is now Epic 0.7's job, not Epic 0.1's); "Depends on Epic 0.1" prose updated to cite Epic 0.7 Story 0.7.1 for the eLinks sync; "Out of scope" line updated |
| **Epic 0.3** | `depends_on` gains `epic-0.7` and `epic-0.8` (Story 0.3.2 needs both ETL processes to have real tier-(a) data); Story 0.3.1's AC corrects a pre-existing mislabel — "carries the tier-(a) tables per Story 0.1.3" should read **Story 0.1.2** (0.1.2 creates the tables; 0.1.3 was the sync) — this reference breaks once 0.1.3 moves out, surfacing the fix |
| **Epic 0.4** | **No change.** Its `jo_*` fixtures come from dev/CI seed scripts (Story 0.4.1), independent of the live eLinks/MRD ETL — it only ever needed the schema (Epic 0.1), which hasn't moved |
| **Epic 0.0, 0.5, 0.6** | No change (their Story-0.1.1-only references are untouched since 0.1.1 stays put) |

### 2.2 Story impact

No story Acceptance Criteria change. Story 0.1.3 and 0.1.4's full bodies move verbatim into Epic 0.7/0.8, renumbered 0.7.1/0.8.1 (including their own footnote references, which move with them). `sprint-status.yaml` keys `0-1-3-...` and `0-1-4-...` are replaced by `0-7-1-...` / `0-8-1-...` under new `epic-0.7` / `epic-0.8` blocks; both remain `backlog`.

### 2.3 Artifact conflicts / cross-reference sweep

Repo-wide sweep for `epic-0.1`, `0.1.1`–`0.1.4`, `Epic 0.1` found these **living, canonical** files needing edits (dated reports and existing changelog rows are left as immutable history per project convention, even where they cite the pre-split filename):

- `epics/phase-0/index.md` — Epic 0.1 row/summary narrowed; two new rows/summaries added; both epic-story-count tables updated (epic count 7→9, story total unchanged at 21 across more rows)
- `epics/fr-coverage-map.md` — FR1, FR6, and the `NFR24` row split across Epic 0.1 (schema) and Epics 0.7/0.8 (population)
- `epics/framework.md` — two prose mentions of "Epic 0.1's vertical slice" / "Epic 0.1" for the ingestion mechanisms now say "Epics 0.7/0.8"
- `epics/requirements-inventory.md` — one Terraform/MRD-storage reference moves from "Epic 0.1 Story 0.1.4" to "Epic 0.8 Story 0.8.1"
- `epics/phase-0/epic-0.2-user-authenticates.md` — `depends_on` + two prose references (dependency comment, "Depends on Epic 0.1", "Out of scope")
- `epics/phase-0/epic-0.3-reference-data-read-only-api.md` — `depends_on` + four prose references + the Story 0.1.3→0.1.2 mislabel fix
- `architecture/repository-strategy.md` — one Terraform/MRD-storage reference (Story 0.1.4 → 0.8.1)
- `architecture/delivery-operating-model.md` — the canonical story-packet **example** currently illustrates itself with the real Story 0.1.4/Epic 0.1 identifiers; updated to the new Story 0.8.1/Epic 0.8 identifiers so the worked example stays valid (the separate `sprint-status.yaml` excerpt already only shows 0.1.1/0.1.2 and needs no change)
- `scripts/python/build_html.py` — `NAV` list: Epic 0.1's title/story-count updated, two new entries added for Epic 0.7/0.8
- `_bmad-output/implementation-artifacts/sprint-status.yaml` — story keys moved/renamed as above, two new `epic-0.7`/`epic-0.8` blocks added

**Not touched (historical, left as-is per "leave dated reports/changelog immutable"):** `architecture.md` decision-log row #13, `architecture/changelog.md` existing v3.1/v3.5/v3.8/v3.9/v4.6 rows, `architecture/gaps.md` G1.4a, `architecture/assumptions.md` A34, every `sprint-change-proposal-*.md` file, both `implementation-readiness-report-*.md` files. These all cite Story 0.1.1 (which is unaffected) or narrate what was true at the time; their links to the old epic-0.1 filename are left standing as historical record, same tension already accepted for every prior rename in this repo.

**A new `architecture/changelog.md` entry** (v4.7) documents the split going forward rather than editing history.

### 2.4 Technical impact

None — no code exists for any of these repos/stories yet. Purely planning-artifact and `docs/` (regenerated) changes.

---

## Section 3 — Recommended Approach

**Direct adjustment** — reorganise the backlog artifacts as described. No PRD, architecture, or FR/NFR change; no rollback or MVP-scope review needed. Effort: mechanical, ~30 min; risk: low (nothing dispatched, git-reversible); no timeline impact (Phase 0 story/epic count unchanged, only regrouped).

---

## Section 4 — Detailed Change Proposals

### 4.1 `epics/phase-0/epic-0.1-upstream-reference-data-ingested.md` → renamed `epics/phase-0/epic-0.1-ctam-postgres-db-schema-design.md`

**Frontmatter:**
```diff
- description: 'User outcome: Judicial-holder reference data flows into CTAM Pathfinder from its upstream sources of truth — the JOH eLinks API (15 jo_ entities, nightly) and the MRD weekly dataset (supplementary…'
- resource: 'epics/phase-0/epic-0.1-upstream-reference-data-ingested.html'
- storyCount: 4
+ description: 'User outcome: ctam-reference-data is scaffolded as the first CTAM Pathfinder domain service, and the tier-(a) upstream JOH/MRD Postgres schema (15 jo_* tables + ctam_sync_status) is designed with enforced single-writer ownership — ready for the JOH eLinks (Epic 0.7) and MRD (Epic 0.8) ETL processes to populate it.'
+ resource: 'epics/phase-0/epic-0.1-ctam-postgres-db-schema-design.html'
+ storyCount: 2
- title: 'Upstream JOH/MRD reference data is ingested'
+ title: 'CTAM Postgres reference-data schema is designed and scaffolded'
  depends_on: [epic-0.0, epic-0.6]            # unchanged
```

**Body:** Stories 0.1.1 and 0.1.2 carried over **verbatim, unchanged**. The epic-level intro/vertical-slice/FRs/NFRs/out-of-scope prose is rewritten to describe only scaffold + schema design (dropping the eLinks-sync and MRD-ingestion bullets, dropping FR1/NFR24 from "covered" since those describe *population*, not schema — both move to Epic 0.7/0.8's coverage). "Out of scope" gains: *"The JOH eLinks nightly sync (Epic 0.7) and MRD weekly ingestion (Epic 0.8) — this epic creates the schema and write-protection only."* Footnotes `[^d3][^d8][^d9][^d10]` retained (all four are cited in the surviving stories/intro).

**Rationale:** isolates the schema-design deliverable so it can be dispatched/reviewed independently of either ETL process.

### 4.2 New `epics/phase-0/epic-0.7-joh-reference-data-etl-process.md`

Carries former Story 0.1.3 verbatim, renumbered **0.7.1**. New epic-level wrapper:
- `epic: 0.7`, `title: 'JOH reference data flows into CTAM via the nightly eLinks ETL process'`, `storyCount: 1`, `repo: ctam-reference-data`, `depends_on: [epic-0.1]`
- User outcome / FRs covered (FR1, FR6 tier-a, FR7) / Key NFRs (NFR16, NFR24, NFR25–28) carried over from the parts of the old epic-0.1 intro that described the sync specifically
- Out of scope: MRD ingestion (Epic 0.8); the read-only API (Epic 0.3)
- Footnotes `[^d3][^d8][^d9]` (no `[^d10]` — not cited in this story)

### 4.3 New `epics/phase-0/epic-0.8-mrd-reference-data-etl-process.md`

Carries former Story 0.1.4 verbatim, renumbered **0.8.1**. New epic-level wrapper:
- `epic: 0.8`, `title: 'MRD reference data flows into CTAM via the weekly Excel ETL process'`, `storyCount: 1`, `repo: ctam-reference-data`, `depends_on: [epic-0.1]`
- User outcome / FRs covered (FR6 tier-a, FR7) / Key NFRs (NFR16, NFR24, NFR25–28) carried over
- Out of scope: MRD API integration (post-MVP); hand-editing `mrd_*` (never)
- Footnote `[^d3]` only

### 4.4 `epics/phase-0/index.md`

- Epic table row 0.1: title → "Postgres reference-data schema is designed and scaffolded", stories 4→2
- Two new rows added after 0.6: Epic 0.7 (1 story), Epic 0.8 (1 story)
- "Epic summaries" section: Epic 0.1 summary narrowed; two new summaries added for 0.7/0.8
- "Phase 0 Epic Stories Summary" table: split the 0.1 row into three rows (0.1: 2 stories/schema; 0.7: 1 story/eLinks; 0.8: 1 story/MRD), demo description split accordingly
- Epic count 7 → 9; total story count unchanged (21, per the top table's existing count — the bottom table's pre-existing 19-vs-21 discrepancy is untouched, out of scope for this split)

### 4.5 `epics/fr-coverage-map.md`

```diff
- | FR1 | [Epic 0.2](...) (...) + [Epic 0.1](phase-0/epic-0.1-upstream-reference-data-ingested.md) (`jo_people` ingested — the JOH lookup target) + [Epic 0.4](...) | ...
+ | FR1 | [Epic 0.2](...) (...) + [Epic 0.1](phase-0/epic-0.1-ctam-postgres-db-schema-design.md) (`jo_people` schema) + [Epic 0.7](phase-0/epic-0.7-joh-reference-data-etl-process.md) (`jo_people` populated via the eLinks sync) + [Epic 0.4](...) | ...

- | **FR6** | **Tier (a)**: [Epic 0.1](...) Story 0.1.2 (tables) + Stories 0.1.3/0.1.4 (eLinks sync + MRD ingestion — read-only in CTAM, corrections at source). **Tier (b)**: ... |
+ | **FR6** | **Tier (a)**: [Epic 0.1](...) Story 0.1.2 (tables) + [Epic 0.7](...) Story 0.7.1 (eLinks sync) + [Epic 0.8](...) Story 0.8.1 (MRD ingestion) — read-only in CTAM, corrections at source. **Tier (b)**: ... |

- | *(NFR24)* | [Epic 0.1](...) Stories 0.1.3/0.1.4 | MRD reader swaps... |
+ | *(NFR24)* | [Epic 0.7](...) Story 0.7.1 + [Epic 0.8](...) Story 0.8.1 | MRD reader swaps... |

- > Reference data arrives via upstream ingestion (Epic 0.1); ...
+ > Reference data arrives via upstream ingestion (Epic 0.1 schema + Epics 0.7/0.8 ETL processes); ...
```
(FR7, FR8, FR59 rows are unaffected — all cite Story 0.1.1/0.1.2, which stay in Epic 0.1.)

### 4.6 `epics/framework.md`

```diff
- **Ingestion (in Epic 0.1's vertical slice — sign-in depends on `jo_people`)**: nightly in-process `@Scheduled` eLinks sync ...
+ **Ingestion (in Epics 0.7/0.8's vertical slice — sign-in depends on `jo_people`)**: nightly in-process `@Scheduled` eLinks sync ...

- Reference data arrives via the Upstream Reference-Data Ingestion area (Epic 0.1).
+ Reference data arrives via the Upstream Reference-Data Ingestion area (Epic 0.1 schema + Epics 0.7/0.8 ETL processes).
```

### 4.7 `epics/requirements-inventory.md`

```diff
- **`ctam-reference-data`** carries the MRD feed storage account + blob container (Epic 0.1 Story 0.1.4 — its own resource).
+ **`ctam-reference-data`** carries the MRD feed storage account + blob container (Epic 0.8 Story 0.8.1 — its own resource).
```

### 4.8 `epics/phase-0/epic-0.2-user-authenticates.md`

```diff
- depends_on: [epic-0.0, epic-0.1]            # needs jo_people (0.1.3) + the estate
+ depends_on: [epic-0.0, epic-0.1, epic-0.7]  # needs the estate + the schema (0.1) + jo_people populated by the eLinks sync (0.7.1)

- **Depends on Epic 0.1:** `jo_people` (the JOH identity-lookup target) is populated by the eLinks sync (Story 0.1.3); the shared Azure estate ... is provisioned by `ctam-reference-data` (Story 0.1.1) and consumed here.
+ **Depends on Epics 0.1 and 0.7:** `jo_people` (the JOH identity-lookup target) is populated by the eLinks sync (Epic 0.7, Story 0.7.1); the shared Azure estate ... is provisioned by `ctam-reference-data` (Epic 0.1, Story 0.1.1) and consumed here.

- **Out of scope (explicitly):** All upstream ingestion + `ctam-reference-data` scaffold + shared-estate provisioning + tier-(a) tables (Epic 0.1). ...
+ **Out of scope (explicitly):** The JOH eLinks ingestion (Epic 0.7) + `ctam-reference-data` scaffold + shared-estate provisioning + tier-(a) schema (Epic 0.1). ...
```

### 4.9 `epics/phase-0/epic-0.3-reference-data-read-only-api.md`

```diff
- depends_on: [epic-0.1, epic-0.2]            # read API is downstream of auth (JWTFilter + authz/check, D8)
+ depends_on: [epic-0.1, epic-0.7, epic-0.8, epic-0.2]  # read API is downstream of auth (D8) and needs both ETL processes for real tier-(a) data

- ... the upstream-sourced tier-(a) tables ingested in Epic 0.1 and the tier-(b) tables created here ...
+ ... the upstream-sourced tier-(a) tables (schema in Epic 0.1, ingested by Epics 0.7/0.8) and the tier-(b) tables created here ...

- ... tier (a) is written only by the Epic 0.1 ingestion mechanisms ...
+ ... tier (a) is written only by the Epic 0.7/0.8 ingestion mechanisms ...

- *(There is no legacy-data ETL ... Upstream data arrives via Epic 0.1's ingestion mechanisms.)*
+ *(There is no legacy-data ETL ... Upstream data arrives via Epic 0.7/0.8's ingestion mechanisms.)*

  Story 0.3.1 AC:
- **Given** `ctam-reference-data` is scaffolded and carries the tier-(a) tables per Story 0.1.3,
+ **Given** `ctam-reference-data` is scaffolded and carries the tier-(a) tables per Story 0.1.2,
  (pre-existing mislabel — 0.1.2 creates the tables; 0.1.3 was the sync, now moved out and no longer a valid reference)

  Story 0.3.2 AC:
- **Given** `ctam-reference-data` carries both tiers (tier (a) per Stories 0.1.3/0.1.4; tier (b) per Story 0.3.1),
+ **Given** `ctam-reference-data` carries both tiers (tier (a) per Epic 0.7 Story 0.7.1 / Epic 0.8 Story 0.8.1; tier (b) per Story 0.3.1),
```

### 4.10 `architecture/repository-strategy.md`

```diff
- ... carries only its own per-repo Terraform (MRD storage, Story 0.1.4). ...
+ ... carries only its own per-repo Terraform (MRD storage, Epic 0.8 Story 0.8.1). ...
```

### 4.11 `architecture/delivery-operating-model.md`

The canonical story-packet worked example currently uses the real MRD story as its illustration; update it to the new identifiers so it stays a valid, checkable example:

```diff
  story_id: 0.1.4
  epic: epic-0.1-upstream-reference-data-ingested
+ story_id: 0.8.1
+ epic: epic-0.8-mrd-reference-data-etl-process
  ...
  sprint_status_key: 0-1-4-mrd-supplementary-reference-data-is-ingested-from-the-weekly-excel-feed
+ sprint_status_key: 0-8-1-mrd-supplementary-reference-data-is-ingested-from-the-weekly-excel-feed
  # Story 0.1.4: <title>
+ # Story 0.8.1: <title>
```
(The separate `sprint-status.yaml` excerpt shown a few lines below already truncates after `0-1-2-...` with `...`, so it needs no edit — it remains accurate for Epic 0.1 post-split.)

### 4.12 `scripts/python/build_html.py` — `NAV` list

```diff
- ("Epic 0.1 — Upstream JOH/MRD reference data is ingested (4 stories)", "epics/phase-0/epic-0.1-upstream-reference-data-ingested", False),
+ ("Epic 0.1 — Postgres reference-data schema designed and scaffolded (2 stories)", "epics/phase-0/epic-0.1-ctam-postgres-db-schema-design", False),
  ("Epic 0.2 — User authenticates (5 stories)", ...),
  ("Epic 0.3 — Reference data read-only API (2 stories)", ...),
  ("Epic 0.4 — User populations bootstrapped (1 story)", ...),
  ("Epic 0.5 — Notification scaffolded (2 stories)", ...),
  ("Epic 0.6 — Context bus published + shared config baseline (2 stories)", ...),
+ ("Epic 0.7 — JOH reference data ETL process (1 story)", "epics/phase-0/epic-0.7-joh-reference-data-etl-process", False),
+ ("Epic 0.8 — MRD reference data ETL process (1 story)", "epics/phase-0/epic-0.8-mrd-reference-data-etl-process", False),
```

### 4.13 `_bmad-output/implementation-artifacts/sprint-status.yaml`

```diff
  epic-0.1: backlog
  0-1-1-scaffold-ctam-reference-data-from-the-hmcts-starter-onto-the-epic-0-0-estate: backlog
  0-1-2-tier-a-upstream-jo-tables-ctam-sync-status-and-tier-a-write-protection: backlog
- 0-1-3-joh-reference-data-flows-into-ctam-nightly-from-the-joh-elinks-api: backlog
- 0-1-4-mrd-supplementary-reference-data-is-ingested-from-the-weekly-excel-feed: backlog
  epic-0.1-retrospective: optional
  ...
  epic-0.6-context-bus...: (unchanged block)
+
+ epic-0.7: backlog
+ 0-7-1-joh-reference-data-flows-into-ctam-nightly-from-the-joh-elinks-api: backlog
+ epic-0.7-retrospective: optional
+
+ epic-0.8: backlog
+ 0-8-1-mrd-supplementary-reference-data-is-ingested-from-the-weekly-excel-feed: backlog
+ epic-0.8-retrospective: optional
```

### 4.14 `architecture/changelog.md` — new entry (v4.7)

A new row is **added** (existing rows untouched) documenting: Epic 0.1 split into schema-design (kept as 0.1) + two new ETL-process epics (0.7 JOH, 0.8 MRD); nothing dispatched yet so no code/branch impact; cross-reference sweep list as in §2.3; link to this SCP.

---

## Section 5 — Implementation Handoff

**Scope classification: Moderate** — backlog reorganisation across planning artifacts, no PRD/architecture/FR change, no code exists yet for the affected stories.

**Route:** Developer agent (this session) implements directly — file renames, edits, `sprint-status.yaml` update, changelog entry, then `scripts/build-html.sh` to regenerate `docs/`. No PO/PM/Architect escalation needed; there's no scope or requirements change, only a regrouping of already-approved stories.

**Success criteria:**
- `epics/phase-0/epic-0.1-ctam-postgres-db-schema-design.md`, `epic-0.7-joh-reference-data-etl-process.md`, `epic-0.8-mrd-reference-data-etl-process.md` all exist with correct frontmatter, `depends_on`, and verbatim story ACs
- No dangling reference to the old filename or to Stories 0.1.3/0.1.4 remains in any living planning artifact
- `sprint-status.yaml` reflects 9 epics / same 4 stories under the new grouping, all `backlog`
- `scripts/build-html.sh` runs clean and `docs/` reflects the new structure
