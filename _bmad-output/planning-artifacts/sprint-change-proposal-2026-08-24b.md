---
type: 'Sprint Change Proposal'
description: 'Epic 0.1 is retitled "JOH Reference-Data ETL Process" and narrowed to JOH eLinks data only; MRD ingestion (former Story 0.1.4) splits into a new Epic 0.8, same repo, same run-log.'
resource: 'sprint-change-proposal-2026-08-24b.html'
tags: [ctam-pathfinder, sprint-change-proposal]
timestamp: '2026-08-24'
title: 'Sprint Change Proposal — 2026-08-24b'
status: 'approved'
---

# Sprint Change Proposal — 2026-08-24b

**Trigger:** *"we are focusing on joh data as phase-0 update epic-0.1 as joh-reference-data-etl process"*

**Clarified via two questions before drafting:**
1. **"ETL" meaning** → **Rename/reframe only.** The technical design (in-process nightly `@Scheduled` sync, decision #9 in `architecture.md`) is unchanged. "ETL" becomes the epic's label for that ongoing pipeline.
2. **"Focusing on JOH data" scope** → **Split MRD out.** Epic 0.1 becomes JOH-eLinks-only (Stories 0.1.1–0.1.3); MRD ingestion (former Story 0.1.4) moves to a new Epic 0.8.

**Mode:** Batch (carried over from the prior SCP this session). **Scope classification:** Moderate (epic retitle + split, story renumbering, coordinated shard sweep; no PRD/FR/NFR change).

**Note on process:** given the two clarifying answers fully scoped this change, edits below were drafted directly rather than staged separately; nothing is committed to git — this document is the record, and anything here can still be adjusted before that happens.

---

## 1. Issue Summary

Epic 0.1 ("Upstream JOH/MRD reference data is ingested") bundled two upstream integrations — the JOH eLinks API sync (Stories 0.1.1–0.1.3) and the MRD weekly Excel ingestion (Story 0.1.4) — under one epic. The team's near-term focus is JOH data specifically; keeping MRD bundled into the same epic obscures that focus and overstates what "Epic 0.1 done" means (an epic-level `depends_on` gate, per `dispatch-preflight.sh`, currently can't distinguish "JOH ETL done" from "JOH ETL done AND MRD done").

Separately, the team wants Epic 0.1 to carry the "ETL" label for communication clarity. This needs care: "ETL" was **explicitly retired** in this repo (D3, 2026-06-10; gaps.md G4.6) when it referred to the **one-shot legacy APEX-migration tool** — retracted because CTAM Pathfinder does no legacy data migration of any kind. Reusing "ETL" for a *different*, ongoing thing (the nightly eLinks sync) is fine, but only if clearly distinguished from that retirement, or it silently reopens a settled decision. Both gaps.md (G4.6) and the new epic file now carry that distinction explicitly.

## 2. Impact Analysis

### Epic impact

- **Epic 0.1** retitled **"JOH Reference-Data ETL Process"**; narrowed to Stories 0.1.1–0.1.3 (JOH eLinks only). `depends_on` unchanged (`[epic-0.0, epic-0.6]`).
- **New Epic 0.8** ("MRD supplementary reference data is ingested") carries the former Story 0.1.4, renumbered **Story 0.8.1**, content otherwise verbatim. `depends_on: [epic-0.0, epic-0.1]` — same repo (`ctam-reference-data`), needs Epic 0.1's scaffold (0.1.1) and tier-(a) write-protection pattern (0.1.2) established first.
- No other epic's scope changes. Epic 0.2 (auth) still depends on Epic 0.1 for `jo_people` — unaffected, since JOH data (not MRD) is what sign-in needs.

### Story impact

- Story 0.1.4 → **Story 0.8.1**, moved wholesale (Acceptance Criteria, references, out-of-scope notes carried over unchanged).
- Stories 0.1.1, 0.1.2, 0.1.3 — cross-references to "Story 0.1.4" updated to "Epic 0.8, Story 0.8.1"; no AC content changed.
- No story is added, removed in substance, or has its acceptance criteria altered — this is a **relabelling + regrouping**, not a scope change.

### Artifact conflicts / updates needed

| Artifact | Change |
|---|---|
| `epics/phase-0/epic-0.1-upstream-reference-data-ingested.md` | Retitled "JOH Reference-Data ETL Process"; naming note added (ETL distinction); Story 0.1.4 removed; storyCount 4→3; cross-references fixed |
| `epics/phase-0/epic-0.8-mrd-supplementary-reference-data-ingested.md` *(new)* | Former Story 0.1.4, now Story 0.8.1, as its own epic; `depends_on: [epic-0.0, epic-0.1]` |
| `epics/phase-0/index.md` | Epic table (0.1 retitled/3 stories, +0.8/1 story); epic summaries (0.1 rewritten, +0.8); Stories Summary table (0.1/+0.8 rows; **total corrected to 24** — the table previously read 22, an arithmetic carry-over error caught while editing it) |
| `epics/framework.md` | Reference Data area: ingestion paragraph split by epic; Phase 0 area-table row updated |
| `epics/fr-coverage-map.md` | FR6 and NFR24 rows: split JOH (0.1.3) vs MRD (0.8.1) |
| `epics/requirements-inventory.md` | MRD storage Terraform cross-reference updated to Epic 0.8 |
| `architecture/non-functional-requirements-coverage.md` | NFR24 bullet: JOH → Epic 0.1, MRD → Epic 0.8 |
| `architecture/repository-strategy.md` | `ctam-reference-data` row: MRD storage cross-reference + "JOH eLinks ETL process" phrasing |
| `architecture/delivery-operating-model.md` | Story-packet template's illustrative example (`story_id`, `epic`, `sprint_status_key`) updated from the now-moved `0.1.4` to `0.8.1` so the worked example stays accurate |
| `architecture/gaps.md` | G4.6: terminology note distinguishing reused "ETL" from the retired legacy-migration ETL. G8.1: epic-split cross-reference (JOH→0.1, MRD→0.8) |
| `architecture.md` | Decision log: new **#15** |
| `architecture/changelog.md` | New **v4.10** entry |
| `sprint-status.yaml` | `0-1-4-...` moved out of `epic-0.1` block into new `epic-0.8` block as `0-8-1-...`, status unchanged (`backlog`) |

**Not touched (deliberately):** dated historical records — `sprint-change-proposal-2026-05-15.md`, `-2026-06-17.md`, `-2026-08-20.md`, `implementation-readiness-report-2026-06-17.md`, and the `changelog.md` v3.1/v4.6/v4.7 entries — all correctly describe the state *as of their date* and are left as immutable history per this repo's convention. `assumptions.md` A36/A37 (reference G8.1, not epic numbers — no change needed). No PRD, UX, or FR/NFR change.

### Technical impact

None. The eLinks sync's implementation (in-process `@Scheduled`, full-refresh upsert, `ctam_sync_status` logging) and MRD's implementation (blob poll, validate, upsert, archive) are unchanged — only which epic tracks each, and what Epic 0.1 is called. `ctam_sync_status` remains a single shared table written by both, now-separately-tracked, processes in the same repo.

## 3. Recommended Approach

**Option 1 — Direct Adjustment.** This is a pure backlog reorganisation: retitle one epic, split one story into a sibling epic, sweep cross-references. Nothing is built yet (`sprint-status.yaml` shows both epics fully `backlog`), so there's no rollback question (Option 2 doesn't apply) and no MVP/FR impact (Option 3 doesn't apply).

**Effort:** Low. **Risk:** Low — relabelling plus a mechanical cross-reference sweep, verified file-by-file rather than blind find-replace (per this repo's cross-cutting-change convention). **Timeline impact:** None — Epic 0.8's `depends_on` on Epic 0.1 preserves the same effective build order MRD already had as Story 0.1.4 (it came after 0.1.1–0.1.3 anyway).

## 4. Detailed Change Proposals

All edits are described in full, with before/after text, in the files themselves (this SCP intentionally doesn't re-paste the whole rewritten epic files — see the two epic files directly for the authoritative before/after). Summary of the key renames:

- **Epic 0.1**: "Upstream JOH/MRD reference data is ingested" → **"JOH Reference-Data ETL Process"**, 4 stories → 3 (0.1.1–0.1.3).
- **Epic 0.8** *(new)*: "MRD supplementary reference data is ingested", 1 story (0.8.1 — was 0.1.4).
- **Decision #15** added to `architecture.md`'s decision log; **v4.10** added to `changelog.md`.
- **G4.6** (gaps.md) gains a terminology note; **G8.1** gains an epic-split cross-reference.
- Phase 0 totals: **9 epics** (was 8), **24 stories** (unchanged — 3+1 replaces the old 4).

## 5. Implementation Handoff

**Scope: Moderate** — backlog reorganisation (epic retitle + split + renumbering) with a coordinated cross-reference sweep. No PRD rewrite, no FR/NFR change. Routed as **Product Owner / Developer**, not Product Manager / Architect.

**Responsibilities:**
- **This session:** all edits above have been drafted directly in the tracked planning-artifact files (nothing committed). Pending final approval, the next step is `scripts/build-html.sh` to regenerate `docs/`.
- **Product Owner (human):** confirm no dispatcher has picked up `0.1.4`/Story 0.8.1 under its old identity outside this control plane (checked: `sprint-status.yaml` shows it was `backlog` under `epic-0.1`, never dispatched).

**Success criteria:** Epic 0.1 and Epic 0.8 files are internally consistent and cross-reference each other correctly; `epics/phase-0/index.md`'s two summary tables agree on totals (24 stories, 9 epics); `docs/` regenerates cleanly; no FR/NFR/PRD text changed.
