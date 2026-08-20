---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — split Epic 0.5 into JOH and MRD reference-data read-API epics'
description: 'Date: 2026-08-20 — Epic 0.5 (Reference data served read-only via a versioned, jurisdiction-filtered API) is split. Epic 0.5 keeps its number, retitled to JOH + CTAM-owned reference data (tier-b tables/seed/DBA runbook + the read API over tier-b and JOH tier-a). A new Epic 0.9 adds the MRD-sourced read endpoint as new content, extending Epic 0.5s already-published API rather than duplicating it. No third epic for tier-(b) data, per the users direction to remove the existing epic and land exactly two.'
resource: 'sprint-change-proposal-2026-08-20d.html'
tags: [ctam-pathfinder, sprint-change, epics, phase-0]
timestamp: '2026-08-20'
parent: 'planning-artifacts/index.md'
project: 'ctam-analysis (CTAM Pathfinder)'
change_scope: 'Moderate — backlog split + new story content, no PRD/architecture/FR change'
mode: 'Batch'
architectureVersion: 'v4.9'
last_updated: 2026-08-20
---

# Sprint Change Proposal — 2026-08-20 (d)

**Split Epic 0.5 (Reference Data read API) into JOH and MRD read-API epics**

---

## Section 1 — Issue Summary

**Trigger:** *"split the epic-0.5 into 2 epics: joh-reference-data-read-api, mrd-reference-data-read-api"*, followed by clarification: *"split into 2 epics as suggested, remove the existing one"* — i.e. exactly two resulting epics, no third epic surviving for anything Epic 0.5 currently covers.

**The complication, raised before proceeding:** Epic 0.5 has two stories:

- **0.5.1** — tier-(b) **CTAM-owned** reference tables (regions, offices, calendar, 12 operational vocabularies), seed data, DBA maintenance runbook. This data is **not** JOH-sourced or MRD-sourced — it's CTAM's own.
- **0.5.2** — the read-only REST API. Its AC text only ever specified tier-(b) endpoints and tier-(a) **JOH** endpoints (`/johs`, `/jurisdictions`, `/tickets`). **No MRD-sourced endpoint has ever been written** — there is no existing content to "extract" into an MRD epic; it has to be authored.

So a literal two-way JOH/MRD split has nowhere to put the tier-(b) content, and the MRD side starts from nothing. Resolved directly with the user:

1. **Tier-(b) stays bundled with JOH, not split into a third epic.** Two of tier-(b)'s 12 vocabularies (`ctam_joh_types`, `ctam_joh_fee_entitlements`) are JOH-specific, and JOH scheduling is tier-(b)'s dominant consumer overall — a defensible product framing, and it's what "remove the existing one, land exactly two" requires.
2. **The MRD epic is genuinely new content** — a jurisdiction-filtered read endpoint over `mrd_specialisms` (JOH Specialisations), authored to match the existing epic's conventions and explicitly designed as an **extension** of the already-published `api-ctam-reference-data` OpenAPI spec and Postman collection rather than a second API surface. This mirrors how Epic 0.3 (MRD ETL) added its own small schema onto the already-scaffolded `ctam-reference-data` service instead of standing up something separate — the same "small supplementary addition, not a parallel structure" pattern already established for MRD elsewhere in this backlog.

**Numbering:** Epic 0.5 **keeps its number** (nothing currently lists it as a `depends_on` prerequisite, so this is zero-cascade) and is retitled "JOH and CTAM-owned reference data is served read-only…". The new MRD epic is appended at the next free slot, **0.9**, rather than renumbered for adjacency — called out explicitly here since the prior two SCPs (2026-08-20b, 2026-08-20c) show the user does sometimes want adjacency-driven renumbering; this default can be revisited if wanted.

**Status check:** both of Epic 0.5's stories are `backlog`; nothing dispatched, no code exists. Low-risk.

---

## Section 2 — Impact Analysis

### 2.1 Epic impact

| Epic | Change |
|---|---|
| **Epic 0.5** | Renamed file (`epic-0.5-reference-data-read-only-api.md` → `epic-0.5-joh-reference-data-read-api.md`); retitled; `depends_on` drops `epic-0.3` (no longer needs MRD data to exist); Stories 0.5.1/0.5.2 AC wording narrowed from "both tiers" to "tier-(b) + JOH tier-(a)"; "Out of scope" gains an explicit MRD → Epic 0.9 pointer |
| **Epic 0.9 (new)** | `mrd-reference-data-read-api` — 1 new story (0.9.1, new content); `depends_on: [epic-0.3, epic-0.5]` |

### 2.2 Story impact

- Story 0.5.1: **unchanged in substance** (tier-(b) tables/seed/runbook were never MRD- or JOH-specific to begin with; no edit needed beyond the epic-level framing).
- Story 0.5.2: AC text narrowed — "tier (a) per Epic 0.2 Story 0.2.1 / Epic 0.3 Story 0.3.1" → "the tier-(a) JOH data (per Epic 0.2, Story 0.2.1)"; "Out of scope" gains "The MRD-sourced read endpoint — Epic 0.9, Story 0.9.1".
- Story 0.9.1 (**new**): `GET /v1/reference-data/johs/{johId}/specialisms` over `mrd_specialisms`, resolved via `ctam_joh_identities` → `personnel_number` → `mrd_specialisms`; jurisdiction-filtered consistently with every other endpoint on the API (403, not a silently-filtered empty result, for an out-of-jurisdiction requester); empty-list 200 (not 404) for a JOH with no specialisms; no write endpoints (405 + RFC 9457); OpenAPI artefact **version-bumped**, not re-coordinated; Postman collection gains a case rather than a second collection.

### 2.3 Artifact conflicts

`epics/phase-0/epic-0.5-*.md` (renamed + edited) · new `epics/phase-0/epic-0.9-mrd-reference-data-read-api.md` · `epics/phase-0/index.md` (epic table row, both epic-summary blocks, stories-summary table, totals: 9→10 epics, 21→22 stories) · `epics/fr-coverage-map.md` (FR6, FR7, FR58 rows gain the Epic 0.9 reference; header range 0.0–0.8 → 0.0–0.9) · `scripts/python/build_html.py` `NAV` list · `_bmad-output/implementation-artifacts/sprint-status.yaml` (new `epic-0.9` block; Epic 0.5's own story keys unchanged) · a new `architecture/changelog.md` entry (v4.9, prior rows untouched) · `docs/` regenerated.

**Checked, not touched:** `framework.md`, `requirements-inventory.md`, `repository-strategy.md`, `delivery-operating-model.md` — none reference Epic 0.5 by number outside the files listed above.

### 2.4 Technical impact

None — no code exists for `ctam-reference-data` yet. Purely planning-artifact and `docs/` changes.

---

## Section 3 — Recommended Approach

**Direct adjustment** — split as described, author the new MRD story to the epic's existing conventions. No PRD, architecture, or FR/NFR change (FR6/FR7/FR58 already covered tier (a) generally; the MRD endpoint is a concrete instance of FR6, not a new requirement). Effort: moderate (new AC content, not just a mechanical split); risk: low (nothing dispatched, git-reversible).

---

## Section 4 — Verification performed

Same checklist as the two prior SCPs on this backlog: every markdown link in `epics/phase-0/*.md` resolves to an existing file; every epic's `storyCount:` frontmatter matches its actual `## Story` heading count; every `## Story N.M` heading matches its file's own epic number; every `depends_on:` was re-derived from what the epic actually needs (Epic 0.9 needs Epic 0.3 for the data to exist and Epic 0.5 for the API/JWTFilter/jurisdiction-filtering infra it extends — not, say, Epic 0.4 directly, since that's already covered transitively via Epic 0.5); `scripts/build-html.sh` runs clean with no stale old-numbered output files left behind.

---

## Section 5 — Implementation Handoff

**Scope classification: Moderate** — a backlog split plus newly-authored story content, no PRD/architecture/FR change, no code exists yet for the affected repo.

**Route:** Developer agent (this session) implements directly. No PO/PM/Architect escalation needed — the new MRD story was authored to match the existing epic's established conventions (jurisdiction filtering, RFC 9457, OpenAPI/Postman patterns), not a novel design decision.

**Success criteria:** the four verification checks in Section 4 pass; `git status` shows a clean rename + content edits + one new epic file, no orphaned old-numbered files; the published `docs/` site reflects Epic 0.5's new title and Epic 0.9 with no broken links.
