---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — 2026-08-15b: Postgres schema design and JOH/MRD ingestion split into separate epics; Phase 0 renumbered'
timestamp: '2026-08-15'
tags: [ctam-pathfinder, sprint-change-proposal, phase-0, epics]
---

# Sprint Change Proposal — 2026-08-15b

## Split Postgres schema design and JOH/MRD ingestion into separate epics; renumber Phase 0

## 1. Issue Summary

**Trigger:** two related requests in the same session: (a) split the combined "Upstream JOH/MRD reference data is ingested" epic into two independently-demoable epics — one for JOH (JSON, eLinks API, nightly), one for MRD (Excel, weekly Blob drop) — since they differ in format, cadence, and delivery mechanism; and (b) add a further epic covering PostgreSQL schema design, sequenced before any table-creating epic.

**Problem statement:** the former Epic 0.1 bundled two genuinely independent ingestion mechanisms under one epic and one demo, obscuring that JOH eLinks (Story 0.1.3) and MRD Excel (Story 0.1.4) are separate integrations with separate upstream owners, contracts, and failure modes. Separately, no epic in the artifact set made the relational schema design itself — naming conventions, PK/FK/tier-prefix rules, the full per-table ownership inventory — an explicit, reviewed, CI-enforced deliverable; it was implicit in each table-creating story's reference to `architecture/data-tables.md` and `architecture/conventions.md`, with no fitness function actually checking conformance.

**Scope confirmed with the user:**
- Schema design becomes its own epic, sequenced **first** (new Epic 0.1) — before JOH and MRD ingestion, since a table must be designed before it's created.
- Numbering strategy: **full cascading renumber** (not append-at-the-end) — the user explicitly chose this over the lower-blast-radius alternative, consistent with the numbering choice made earlier in the same session for the Epic 0.0 network-hardening split.

## 2. Impact Analysis

### Epic impact — full Phase 0 renumber

| Old | New | Change |
|---|---|---|
| Epic 0.0 | Epic 0.0 | Unchanged (6 stories) |
| — | **Epic 0.1 (new)** | Shared PostgreSQL schema design is established and CI-enforced (2 stories) |
| Epic 0.1 (JOH + MRD, 4 stories) | **Epic 0.2** | Upstream JOH reference data is ingested — trimmed to 3 stories (0.2.1–0.2.3); MRD split out |
| — | **Epic 0.3 (new)** | Upstream MRD reference data is ingested — 1 story (0.3.1, was Story 0.1.4) |
| Epic 0.2 | Epic 0.4 | User authenticates and lands on a role-scoped Home page (5 stories renumbered 0.4.1–0.4.5) |
| Epic 0.3 | Epic 0.5 | Reference data read-only API (2 stories renumbered 0.5.1–0.5.2) — now depends on **both** Epic 0.2 (JOH) and Epic 0.3 (MRD) for tier-(a) data, rather than one bundled ingestion epic |
| Epic 0.4 | Epic 0.6 | User populations bootstrapped (1 story renumbered 0.6.1) |
| Epic 0.5 | Epic 0.7 | Notification service (2 stories renumbered 0.7.1–0.7.2) |

Phase 0: **6 → 8 epics, 20 → 22 stories.** All epics remain `not-started` in the ledger — this is a pure renumber/split with **no code impact**.

### Dependency graph impact (`delivery/dispatch-graph.yaml`)

- Epic 0.1 (schema design) depends on `[epic-0.0, arch-baseline]` — same as the old combined ingestion epic did, since it needs the estate and is sequenced alongside the config-values baseline.
- Epic 0.2 (JOH) depends on `[epic-0.0, arch-baseline, epic-0.1]` — adds the schema-design dependency.
- Epic 0.3 (MRD) depends on `[epic-0.1, epic-0.2]` — needs the schema design **and** the scaffolded repo + shared `ctam_sync_status` table that Epic 0.2 establishes.
- Epic 0.4 (auth) depends on `[epic-0.0, epic-0.1, epic-0.2]` — was `[epic-0.0, epic-0.1]` where old-0.1 meant combined ingestion; now explicit that auth only needs JOH's `jo_people`, not MRD.
- Epic 0.5 (read API) depends on `[epic-0.1, epic-0.2, epic-0.3, epic-0.4]` — **materially changed**: previously depended on one bundled ingestion epic + auth; now explicitly depends on both JOH and MRD tier-(a) data plus auth plus schema design.
- Epic 0.6 (bootstrap) depends on `[epic-0.1, epic-0.2, epic-0.4]` — was `[epic-0.1, epic-0.2]` under old numbering (ingestion + auth); now explicit JOH + auth + schema design, no MRD dependency (bootstrap doesn't need MRD data).
- Epic 0.7 (notification) depends on `[epic-0.0, epic-0.1]` — was `[epic-0.0]`; adds schema-design dependency for its own `ctam_notification_dispatches` table.
- `future:` section: `phase-1-joh`, `phase-2-absence`, `phase-6-payment`, `post-mvp-admin-ui` dependency edges updated to the new epic numbers (auth 0.2→0.4, read-API 0.3→0.5, notification 0.5→0.7).

### Artifact impact (exhaustive — every file touched)

| Artifact | Change |
|---|---|
| `epics/phase-0/epic-0.1-postgres-schema-design.md` | **New file.** 2 stories: finalize `architecture/data-tables.md` schema design; build the CI schema-convention fitness function. |
| `epics/phase-0/epic-0.2-joh-reference-data-ingested.md` | Renamed from `epic-0.1-upstream-reference-data-ingested.md`. Trimmed to 3 JOH-only stories; all cross-references renumbered. |
| `epics/phase-0/epic-0.3-mrd-reference-data-ingested.md` | **New file**, adapted from the former Story 0.1.4. 1 story, referencing Epic 0.1 (schema) and Epic 0.2 (scaffolded repo + `ctam_sync_status`) as dependencies. |
| `epics/phase-0/epic-0.4-user-authenticates.md` | Renamed from `epic-0.2-user-authenticates.md`. Stories renumbered 0.2.x→0.4.x; cross-references to ingestion/read-API/bootstrap epics updated; two pre-existing stale references (estate said "provisioned in Epic 0.1"/"lives in `ctam-reference-data`") corrected to Epic 0.0 / `ctam-shared-infrastructure` while touching those lines anyway. |
| `epics/phase-0/epic-0.5-reference-data-read-only-api.md` | Renamed from `epic-0.3-reference-data-read-only-api.md`. Stories renumbered 0.3.x→0.5.x; now explicitly depends on Epic 0.1 (schema), Epic 0.2 (JOH), Epic 0.3 (MRD), Epic 0.4 (auth) — added a "Depends on" line for clarity. |
| `epics/phase-0/epic-0.6-user-populations-bootstrapped.md` | Renamed from `epic-0.4-user-populations-bootstrapped.md`. Story renumbered 0.4.1→0.6.1; auth cross-references updated. |
| `epics/phase-0/epic-0.7-system-dispatches-emails.md` | Renamed from `epic-0.5-system-dispatches-emails.md`. Stories renumbered 0.5.x→0.7.x; added a schema-design conformance note for `ctam_notification_dispatches`. |
| `epics/phase-0/index.md` | Full rewrite: epics table, epic summaries, epic-stories-summary table, scope-model bullets — 8 epics, 22 stories. |
| `epics/index.md` | Phase 0 row: 6→8 epics, 20→22 stories. |
| `epics/fr-coverage-map.md` | Every FR row's epic/story reference renumbered (FR1–FR9, FR55–FR59, NFR24). |
| `epics/framework.md` | Ingestion area now references both Epic 0.2 and Epic 0.3; bootstrap area reference 0.4→0.6; stale "four concrete epics" corrected to "eight." |
| `epics/requirements-inventory.md` | MRD storage-account reference: `Epic 0.1 Story 0.1.4` → `Epic 0.3 Story 0.3.1`. |
| `delivery/ledger/epic-0.1.yaml` | **New.** Schema-design epic, 2 stories. |
| `delivery/ledger/epic-0.2.yaml` | Rewritten (was the combined-ingestion shard) — JOH only, 3 stories. |
| `delivery/ledger/epic-0.3.yaml` | **New.** MRD epic, 1 story. |
| `delivery/ledger/epic-0.4.yaml` / `0.5.yaml` / `0.6.yaml` / `0.7.yaml` | Renamed from `0.2` / `0.3` / `0.4` / `0.5` respectively; `epic:` field and story IDs renumbered; titles unchanged. |
| `delivery/dispatch-graph.yaml` | Full rewrite — 8 epic nodes + updated `future:` dependency edges (see above). |
| `delivery/README.md` | Current-state line: 6→8 epics, 20→22 stories; date bumped. |
| `architecture/gaps.md` | G10.2's "first service … Epic 0.1" reference corrected to Epic 0.2 (JOH is now the first-scaffolded epic). |
| `architecture/repository-strategy.md` | MRD storage reference: `Story 0.1.4` → `Epic 0.3 Story 0.3.1`. |
| `architecture.md` | New decision **#15** appended to the architecture-phase decisions table. |
| `architecture/changelog.md` | New **v4.3** entry (existing entries untouched — immutable history). |
| `scripts/python/build_html.py` | NAV list: added Epic 0.1/0.3 entries, renumbered 0.2–0.5 → 0.4–0.7, fixed a pre-existing stale "(5 stories)" label on the Epic 0.0 line to "(6 stories)". |

No PRD conflict — no FR/NFR added, removed, or renumbered; MVP scope unchanged. No conflict with `data-tables.md`, `conventions.md`, `user-types.md`, or the sequence diagrams (none referenced specific old epic/story numbers per the pre-change sweep).

## 3. Recommended Approach

**Selected: Option 1 — Direct Adjustment**, executed as a full renumber per the user's explicit choice.

**Rationale:** all affected epics remain `not-started` — there is nothing to roll back, and no MVP scope change is implied. The user weighed the two numbering strategies (append-at-the-end vs full cascade) and chose the cascade for a coherent, chronologically-readable epic list, accepting the larger sweep as the cost.

**Effort:** High for this session (a large, careful file-by-file sweep — 8 epic files, 8 ledger shards, the dispatch graph, 6 supporting documents, and the build-tooling NAV list). **Zero** effort/risk for the engineering team, since no code exists yet.
**Risk:** Low in outcome (no code impact) but required careful execution — a renumbering sweep of this size is exactly the kind of change where a single missed cross-reference silently drifts the artifact set out of sync. Three independent read-only sweeps (epics/ tree, architecture/ tree, delivery/+build-tooling) were run before any edit, per this repo's "sweep first, don't blind find-replace" convention, specifically to avoid that failure mode.

## 4. PRD MVP Impact

None. No FR/NFR is added, removed, or reworded; no change to Success Criteria, Scope, or Phase mapping.

## 5. Implementation Handoff

**Change scope classification: Minor** — planning-artifact restructuring across not-started epics; no backlog reorganisation beyond the mechanical renumber, no PM/Architect strategic replan.

**Handoff:** applied directly in this session (control-plane documentation only, per CLAUDE.md — this repo holds no runtime code). `docs/` regenerated via `scripts/build-html.sh`.

**Success criteria:** every epic file, ledger shard, and the dispatch graph agree on the same 8-epic/22-story numbering; every cross-epic reference (in epic bodies, `fr-coverage-map.md`, `framework.md`, `requirements-inventory.md`, `gaps.md`, `repository-strategy.md`) resolves to the correct new epic/story number; `docs/` regenerates cleanly with no broken links in the NAV.
