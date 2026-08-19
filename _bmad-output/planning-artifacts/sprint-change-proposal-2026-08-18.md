---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — 2026-08-18: Epic 0.5 filename aligned to the `joh` epic-slug convention'
timestamp: '2026-08-18'
tags: [ctam-pathfinder, sprint-change-proposal, phase-0, epics, editorial]
---

# Sprint Change Proposal — 2026-08-18

## Rename Epic 0.5's file to `epic-0.5-joh-reference-data-read-only-api.md`

## 1. Issue Summary

**Trigger:** a direct request to change the name of Epic 0.5 to `jo-reference-data-read-only-api`.

**Problem statement:** since SCP 2026-08-15c (Decision #16) split the Reference Data read API into two epics — Epic 0.5 (JOH tier-(a) + tier-(b)) and Epic 0.6 (MRD) — Epic 0.5's filename, `epic-0.5-reference-data-read-only-api.md`, has been the only Phase 0 epic slug that does not name its upstream source. Its sibling and its ingestion counterparts all do:

| Layer | JOH | MRD |
|---|---|---|
| Ingestion | `epic-0.2-joh-reference-data-ingested` | `epic-0.3-mrd-reference-data-ingested` |
| Read API | `epic-0.5-reference-data-read-only-api` ← **asymmetric** | `epic-0.6-mrd-reference-data-read-only-api` |

Before the v4.4 split there was a single read-API epic, so the unqualified slug was unambiguous. After the split it reads as though Epic 0.5 covers *all* reference data, which is precisely the ambiguity Decision #16 set out to remove at the read-API layer.

**Evidence:** `_bmad-output/planning-artifacts/architecture/changelog.md` v4.4 row (Decision #16); the four sibling filenames listed above; `epics/phase-0/epic-0.5-*.md` line 15, which states MRD data has its own separate read API (Epic 0.6).

**Issue type:** editorial / naming consistency — **not** a technical limitation, requirement change, or strategic pivot.

**Two decisions confirmed with the user during analysis:**

1. **Slug token: `joh`, not `jo`.** The request said `jo-`, but `jo_*` is the *database table prefix* for upstream-sourced tables (`architecture/conventions.md`, Data & persistence), whereas `joh` is the domain term used in every epic slug. `jo-` would have been the only epic slug of its kind. The user selected `joh-reference-data-read-only-api`.
2. **Slug and `resource:` path only — the epic title is unchanged.** The user selected the lower-blast-radius option, so `title:` and the H1 remain *"JOH and tier-(b) reference data is served read-only via a versioned, jurisdiction-filtered API"*, and the ledger/dispatch-graph titles stay valid.

**Known and accepted residual:** the slug names the epic's upstream source (as its three siblings do) but not its full tier coverage — Epic 0.5 also delivers the 15 tier-(b) CTAM-owned tables (`ctam_regions`, `ctam_offices`, `ctam_calendar_periods` + 12 operational vocabularies), none of which are MRD-sourced. The `title:` remains the authoritative scope statement. The alternative `epic-0.5-joh-and-tier-b-reference-data-read-only-api` was offered and not selected.

## 2. Impact Analysis

### Epic / story impact

**None.** Epic number, `epic:` front-matter key, title, story IDs (0.5.1, 0.5.2), acceptance criteria, FR coverage (FR6, FR7, FR58, FR59), NFR coverage, and `depends_on` edges are all unchanged. Only the file's name, its own `resource:` front-matter, and inbound link targets change.

### Dependency-graph and ledger impact

**None.** `delivery/dispatch-graph.yaml` (node `epic-0.5`, `depends_on: [epic-0.1, epic-0.2, epic-0.4]`, and the `future:` edges at lines 119/159) and `delivery/ledger/epic-0.5.yaml` (`epic: epic-0.5`) key on the **epic number**, never the slug. Verified by repo-wide sweep — neither file contains the slug.

### Artifact impact (exhaustive — every live reference)

| Artifact | Occurrences | Change |
|---|---|---|
| `epics/phase-0/epic-0.5-reference-data-read-only-api.md` | filename + 1 | Renamed to `epic-0.5-joh-reference-data-read-only-api.md`; `resource:` front-matter (line 4) retargeted to the matching `.html` |
| `epics/phase-0/index.md` | 2 | Epics-table link (line 41) and the "Full epic with stories" link (line 95) |
| `epics/fr-coverage-map.md` | 4 | FR6 row (×2 — tier-(b) tables + read API), FR7 row, FR58 row |
| `scripts/python/build_html.py` | 1 | NAV entry (line 263) — required so the page still renders on the published site |
| `docs/epics/phase-0/*.html` | generated | Rebuilt via `scripts/build-html.sh`; the stale `epic-0.5-reference-data-read-only-api.html` deleted |

### Immutable history — deliberately NOT rewritten

Per the repo convention ("leave dated reports and existing changelog entries as immutable history — add, don't rewrite"), three references to the old filename are preserved verbatim:

- `sprint-change-proposal-2026-08-15b.md` line 58 — code span, prose only
- `sprint-change-proposal-2026-08-15c.md` line 49 — code span, prose only
- `architecture/changelog.md` v4.4 row — contains an actual markdown **link** to the old path, which no longer resolves. Accepted as audit trail; the new v4.5 entry states this explicitly so the dead link is documented rather than surprising.

### Other artifacts checked — no impact

`prd.md`, `architecture.md` and its shards (other than the changelog entry being added), `epics/index.md`, `epics/framework.md`, `epics/requirements-inventory.md`, `delivery/README.md`, `_bmad-output/project-context.md`. No UX specification exists for this epic (Epic 0.5 delivers no UI surface — NFR17–NFR19 explicitly do not apply in Phase 0). No spec document. No deployment, IaC, monitoring, test, or CI/CD artifact references the slug.

### Technical impact

**None.** No FR, NFR, or AR changes. No schema, API contract, or endpoint changes. No code impact — implementation has not started and Epic 0.5 is `not-started` in the ledger.

## 3. Recommended Approach

**Selected: Option 1 — Direct Adjustment.** Rename the file and update every live inbound reference plus the site NAV; add this SCP and a changelog entry; regenerate `docs/`.

**Rationale:** the change is a pure naming correction with no story, scope, dependency, or requirement effect. Rollback (Option 2) is not applicable — nothing has been implemented to revert. An MVP review (Option 3) is not applicable — MVP scope is untouched.

**Effort:** Low (documentation + one NAV line). **Risk:** Low — the only failure mode is a missed inbound link, mitigated by a repo-wide sweep before and after. **Timeline impact:** None.

## 4. Detailed Change Proposals

### 4.1 File rename

```
OLD: _bmad-output/planning-artifacts/epics/phase-0/epic-0.5-reference-data-read-only-api.md
NEW: _bmad-output/planning-artifacts/epics/phase-0/epic-0.5-joh-reference-data-read-only-api.md
```

**Rationale:** symmetry with `epic-0.2-joh-*` / `epic-0.3-mrd-*` / `epic-0.6-mrd-*`.

### 4.2 Epic 0.5 front-matter (line 4)

**OLD:**
> `resource: 'epics/phase-0/epic-0.5-reference-data-read-only-api.html'`

**NEW:**
> `resource: 'epics/phase-0/epic-0.5-joh-reference-data-read-only-api.html'`

**Rationale:** the `resource:` path must match the generated HTML filename, which derives from the markdown filename.

### 4.3 `epics/phase-0/index.md` (lines 41, 95)

**OLD (line 41):**
> `| [0.5](epic-0.5-reference-data-read-only-api.md) | JOH and tier-(b) reference data served read-only via a versioned, jurisdiction-filtered API | 2 | 🟡 Planned |`

**NEW (line 41):**
> `| [0.5](epic-0.5-joh-reference-data-read-only-api.md) | JOH and tier-(b) reference data served read-only via a versioned, jurisdiction-filtered API | 2 | 🟡 Planned |`

**OLD (line 95):**
> `→ [Full epic with stories](epic-0.5-reference-data-read-only-api.md)`

**NEW (line 95):**
> `→ [Full epic with stories](epic-0.5-joh-reference-data-read-only-api.md)`

**Rationale:** link targets only — the visible row text and epic title are unchanged.

### 4.4 `epics/fr-coverage-map.md` (FR6 ×2, FR7, FR58)

Link targets `phase-0/epic-0.5-reference-data-read-only-api.md` → `phase-0/epic-0.5-joh-reference-data-read-only-api.md`. Visible link labels (`Epic 0.5`) and all coverage prose unchanged.

**Rationale:** these are the only live cross-artifact links into Epic 0.5; leaving them would break the FR traceability path from the coverage map to the epic.

### 4.5 `scripts/python/build_html.py` NAV (line 263)

**OLD:**
> `("Epic 0.5 — JOH + tier-(b) read-only API (2 stories)", "epics/phase-0/epic-0.5-reference-data-read-only-api", False),`

**NEW:**
> `("Epic 0.5 — JOH + tier-(b) read-only API (2 stories)", "epics/phase-0/epic-0.5-joh-reference-data-read-only-api", False),`

**Rationale:** required by the repo convention that every planning artifact carries a NAV entry; the label already reads "JOH + tier-(b)" and needs no change.

### 4.6 New `architecture/changelog.md` entry — v4.5

Added above the v4.4 row (newest-first). Records the rename, the `joh`-over-`jo` decision, the title-unchanged decision, the accepted tier-(b) naming residual, and the preserved-but-now-stale v4.4 link.

**Rationale:** repo convention — every cross-cutting change gets a Sprint Change Proposal plus a changelog entry.

### 4.7 Regenerate `docs/`

Run `scripts/build-html.sh`, then delete the orphaned `docs/epics/phase-0/epic-0.5-reference-data-read-only-api.html`.

## 5. Implementation Handoff

**Scope classification: Minor** — direct implementation, no backlog reorganization, no replan.

- **No PO involvement needed:** no story added, removed, resequenced, or rescoped.
- **No PM/Architect involvement needed:** no new architecture decision number was allocated, because a filename is not an architecture decision. The changelog entry is recorded as an editorial/consistency change.
- **Recipient:** Developer agent (control plane) — apply the five edits above, add this SCP + the v4.5 changelog entry, regenerate `docs/`.
- **Commit:** the user reviews and commits externally via VSCode (git writes are blocked inside Claude).

**Success criteria:**

1. A repo-wide sweep for `epic-0.5-reference-data-read-only-api` returns **only** the three immutable-history hits listed in §2.
2. `epics/phase-0/index.md` and `epics/fr-coverage-map.md` links resolve to the renamed file.
3. `scripts/build-html.sh` completes and produces `docs/epics/phase-0/epic-0.5-joh-reference-data-read-only-api.html`, reachable from the site NAV.
4. The stale `docs/epics/phase-0/epic-0.5-reference-data-read-only-api.html` no longer exists.
5. `delivery/ledger/epic-0.5.yaml` and `delivery/dispatch-graph.yaml` are unmodified (`git diff` shows no change).

## 6. Separate Finding — Not Part of This Change

`scripts/python/build_html.py`'s **"Change Control & Readiness"** NAV group lists 8 Sprint Change Proposals but **4 are missing**: `2026-08-14`, `2026-08-15`, `2026-08-15b`, `2026-08-15c`. Those four markdown files exist and are authoritative history, but are unreachable from the published site — including SCP 2026-08-15b/c, which define the current Phase 0 numbering. Also missing: `implementation-readiness-report-2026-06-17`, `-2026-08-11`, and both `prd-validation-report-*` files.

This pre-dates the present change and is **out of scope** here. Flagged for a follow-up SCP or a direct NAV fix at the user's discretion.
