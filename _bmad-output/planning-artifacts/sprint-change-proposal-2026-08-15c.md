---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — 2026-08-15c: Reference Data read API split into a JOH+tier-(b) surface and an MRD surface'
timestamp: '2026-08-15'
tags: [ctam-pathfinder, sprint-change-proposal, phase-0, epics]
---

# Sprint Change Proposal — 2026-08-15c

## Split Epic 0.5 (Reference Data read-only API) into a JOH+tier-(b) API and an MRD API

## 1. Issue Summary

**Trigger:** a direct request to split Epic 0.5 ("Reference data is served read-only via a versioned, jurisdiction-filtered API") into two APIs — one serving JOH data reads, one serving MRD data reads — mirroring the ingestion split already applied to the former Epic 0.1 (decision #15, SCP 2026-08-15b).

**Problem statement:** Epic 0.5 bundled the read-only REST API for **two upstream ownership boundaries** (JOH tier-(a), MRD tier-(a)) plus tier-(b) CTAM-owned data under one epic and one story (0.5.2). This mirrored the pre-split ingestion epic's problem: the API surface didn't visibly reflect that JOH and MRD are separate upstream sources with separate contracts. A closer read also surfaced a **pre-existing gap**: Story 0.5.2's acceptance criteria enumerated `GET /v1/reference-data/regions`, `/offices`, `/calendar`, `/vocabularies/{list}` (tier b) and `/johs`, `/jurisdictions`, `/tickets` (tier a JOH) — but never actually listed an MRD/Specialisations endpoint, despite the epic's user outcome claiming to serve "both tiers." This split closes that gap explicitly.

**Design decision — where does tier-(b) data go:** none of the 15 tier-(b) CTAM-owned tables (`ctam_regions`, `ctam_offices`, `ctam_calendar_periods`, and 12 operational vocabularies) are MRD-sourced; several are JOH/booking-domain vocabularies (`ctam_joh_types`, `ctam_joh_fee_entitlements`, etc.). Tier-(b) therefore stays with the JOH-side API — the only split that keeps the result at exactly two APIs, per the user's request. This was stated as an assumption and executed; the user did not raise an objection.

**Numbering strategy:** full cascading renumber, consistent with the two prior splits in this session (decision #15 for ingestion, and the Epic 0.0 network-hardening split before it) — the user has consistently chosen this over a lower-blast-radius append-at-the-end alternative.

## 2. Impact Analysis

### Epic impact — Phase 0 renumbered again

| Old | New | Change |
|---|---|---|
| Epic 0.0–0.4 | Unchanged | No change |
| Epic 0.5 (JOH+MRD+tier-b read API, 2 stories) | **Epic 0.5** | Trimmed to JOH tier-(a) + tier-(b) only; Story 0.5.2's AC no longer references MRD; title updated to "JOH and tier-(b) reference data served read-only..." |
| — | **Epic 0.6 (new)** | MRD reference data served read-only via a versioned, jurisdiction-filtered API — 1 story (0.6.1), including the previously-missing `GET /v1/reference-data/mrd/specialisms` endpoint |
| Epic 0.6 (bootstrap, 1 story) | **Epic 0.7** | Both user populations bootstrapped (story renumbered 0.6.1 → 0.7.1) |
| Epic 0.7 (notification, 2 stories) | **Epic 0.8** | Notification service (stories renumbered 0.7.1/0.7.2 → 0.8.1/0.8.2) |

Phase 0: **8 → 9 epics, 22 → 23 stories.** All epics remain `not-started` — no code impact.

### Dependency graph impact (`delivery/dispatch-graph.yaml`)

- **Epic 0.5** `depends_on` drops `epic-0.3` (MRD) — it no longer serves MRD data. Now `[epic-0.1, epic-0.2, epic-0.4]`.
- **Epic 0.6 (new)** `depends_on: [epic-0.1, epic-0.3, epic-0.4]` — schema design, MRD tier-(a) data, and auth (same auth dependency Epic 0.5 has, since both read APIs sit downstream of `JWTFilter`/`authz/check`).
- **Epic 0.7** (bootstrap) and **Epic 0.8** (notification) dependency sets are unchanged in substance — only the node names shift (0.6→0.7, 0.7→0.8).
- `future.phase-1-joh` now depends on `[epic-0.4, epic-0.5, epic-0.6]` — `ctam-joh` composes JOH profiles from both the JOH+tier-b API and the MRD API (Specialisations are part of a JOH profile view, per FR11/FR15).
- `future.post-mvp-admin-ui` similarly gains the Epic 0.6 dependency.
- `future.phase-2-absence` and `future.phase-6-payment`'s notification dependency shifts `epic-0.7` → `epic-0.8`.

### Artifact impact (exhaustive)

| Artifact | Change |
|---|---|
| `epics/phase-0/epic-0.5-reference-data-read-only-api.md` | Rewritten in place (same filename, same epic number) — trimmed to JOH tier-(a) + tier-(b); MRD dependency and endpoint references removed; explicit pointers to Epic 0.6 added. |
| `epics/phase-0/epic-0.6-mrd-reference-data-read-only-api.md` | **New file.** 1 story: MRD read API, including the `mrd/specialisms` endpoint that was missing from the original Epic 0.5. |
| `epics/phase-0/epic-0.7-user-populations-bootstrapped.md` | Renamed from `epic-0.6-*`. Story renumbered 0.6.1→0.7.1; internal "Epic 0.4" (auth) references unaffected (auth stays 0.4). |
| `epics/phase-0/epic-0.8-system-dispatches-emails.md` | Renamed from `epic-0.7-*`. Stories renumbered 0.7.x→0.8.x. |
| `epics/phase-0/index.md` | Full rewrite: 9-epic table, epic summaries, epic-stories-summary table, scope-model bullets. |
| `epics/index.md`, `delivery/README.md` | Phase 0 count: 8→9 epics, 22→23 stories. |
| `epics/fr-coverage-map.md` | FR6, FR7, FR58 rows split to name both Epic 0.5 (JOH+tier-b) and Epic 0.6 (MRD) explicitly; FR1/FR4/FR57 bootstrap references shifted 0.6→0.7; FR9 notification reference shifted 0.7→0.8. |
| `epics/framework.md` | Bootstrap-verification reference shifted 0.6→0.7. |
| `delivery/ledger/epic-0.5.yaml` | Rewritten — titles updated, story count unchanged (2). |
| `delivery/ledger/epic-0.6.yaml` | **New** — MRD read-API epic, 1 story. |
| `delivery/ledger/epic-0.7.yaml` / `epic-0.8.yaml` | Renamed from `0.6`/`0.7`; `epic:` field and story IDs renumbered. |
| `delivery/dispatch-graph.yaml` | Full rewrite — 9 epic nodes + updated `future:` dependency edges (see above). |
| `architecture.md` | New decision **#16**. |
| `architecture/changelog.md` | New **v4.4** entry (existing entries untouched). |
| `scripts/python/build_html.py` | NAV list: Epic 0.5 relabelled "JOH + tier-(b) read-only API", new Epic 0.6 entry, Epic 0.6/0.7 (bootstrap/notification) renumbered to 0.7/0.8. |

No hits found (per pre-edit sweep) in `architecture/gaps.md`, `architecture/repository-strategy.md`, or `epics/requirements-inventory.md` — none of those referenced the old Epic 0.5/0.6/0.7 numbers or story IDs, so they needed no changes. No PRD, UX, or `data-tables.md`/`conventions.md` conflict — no FR/NFR/schema change, just an API-surface reorganisation of already-planned work.

## 3. Recommended Approach

**Selected: Option 1 — Direct Adjustment**, executed as a full renumber per the established pattern in this session.

**Rationale:** Epic 0.5 (and everything downstream of it) remains `not-started` — nothing to roll back, no MVP scope change. The split makes an implicit gap (the missing MRD read endpoint) explicit and gives each upstream source's data an API surface that matches its ingestion epic, which is the same reasoning that justified the ingestion split (decision #15).

**Effort:** Moderate for this session (one epic trimmed, one new epic authored, two epics renumbered, ledger/dispatch-graph/cross-reference updates) — smaller in scope than the decision #15 renumber since only 3 epics (0.5, 0.6, 0.7) were touched rather than the whole Phase 0 lineup. **Zero** cost to the engineering team — no code exists yet.
**Risk:** Low. A pre-edit sweep across the full planning-artifacts tree (`epics/`, `architecture/`, `delivery/`, `scripts/python/build_html.py`) was run before any edit, confirming the exact set of cross-references to update and ruling out hits in `gaps.md`, `repository-strategy.md`, and `requirements-inventory.md`.

## 4. PRD MVP Impact

None. No FR/NFR added, removed, or reworded; no MVP scope change. FR6's read-API coverage is unchanged in substance — it's now explicitly attributed to two epics instead of one.

## 5. Implementation Handoff

**Change scope classification: Minor** — planning-artifact reorganisation of two not-started epics (plus a two-epic cascade shift); no backlog reorganisation beyond the mechanical renumber, no PM/Architect strategic replan.

**Handoff:** applied directly in this session (control-plane documentation only, per CLAUDE.md — this repo holds no runtime code). `docs/` regenerated via `scripts/build-html.sh`.

**Success criteria:** Epic 0.5 and Epic 0.6 each read as a complete, independently-demoable read API for their upstream source; every cross-reference to the renumbered bootstrap (0.7) and notification (0.8) epics resolves correctly; the dispatch graph's `future:` section correctly reflects that Phase 1 (`ctam-joh`) depends on both read APIs; `docs/` regenerates cleanly with no broken NAV links.
