---
type: 'Sprint Change Proposal'
title: 'Add ctam-jomockapi (17th repo, dev/integration-only) + new Phase 0 epic'
description: 'Onboard the existing ctam-jomockapi mock JOH eLinks server as a documented repo (classified like ctam-mock-auth: dev-only, never production) and give it a real Phase 0 epic preceding Phase 1 Foundations.'
resource: 'sprint-change-proposal-2026-08-24b.html'
tags: [ctam-pathfinder, sprint-change-proposal, epics, architecture]
timestamp: '2026-08-24'
parent: 'index.md'
purpose: 'Record and route the ctam-jomockapi onboarding requested 2026-08-24'
---

# Sprint Change Proposal — 2026-08-24 (b)

**Trigger:** Direct request: "update the epic-0.0 to joh-mock-apis use the docs in the folder to create this epic /Users/shivakumar/MOJ/ctam-jomockapi/docs/".

## 1. Issue Summary

`epic-0.0` at `epics/phase-0/` currently holds throwaway BMad-tooling test-fixture content (created earlier this session, explicitly marked non-real). The request repurposes it into a genuine epic, sourced from a real, already-built sibling project: `/Users/shivakumar/MOJ/ctam-jomockapi/` — a working Node.js/Express mock of the **Judiciary E-links People API v5** (the upstream JOH reference-data source gap **G8.1** flags as having an unconfirmed contract). It serves realistic synthetic JOH people/reference data from the real production CSV exports, with a no-op bearer-auth check, and covers `people`, `leavers`, `deleted`, and `reference_data` endpoints per its README.

Clarified with the requester:
1. **This is real programme scope**, and `ctam-jomockapi` becomes a documented **17th repo**.
2. It is classified **like `ctam-mock-auth`** — dev/integration-only, never deployed to production — not a 12th production service. This keeps every existing "11 services" statement correct as-is; only repo-**count** mentions ("16-repo polyrepo" → 17) and the two repo-listing shards need new content.
3. It lives at `epics/phase-0/`, which becomes a **new, real Phase 0** — distinct from the old Foundations phase that SCP 2026-08-24 renamed to Phase 1. Numerically clean: nothing else renumbers, since 0 < 1 and there is no other "Phase 0" left to collide with.

## 2. Impact Analysis

### Epic impact
- `epics/phase-0/epic-0.0-mock-epic.md` (fixture) is replaced with `epic-0.0-joh-mock-apis.md` (real epic), sourced from the sibling repo's README, `package.json`, and route/lib structure.
- `epics/phase-0/index.md` becomes a real phase index (currently reads "MOCK Phase 0 — Fixture").
- The BMad-tooling test fixture this displaces is retired — if you still want a throwaway fixture for tooling tests later, it'll need a new, non-colliding location (e.g. outside `planning-artifacts/`, per the option raised and declined earlier today).
- No existing epic (1.0–1.6) changes shape or numbering.

### Artifact conflicts

| Category | Files | Treatment |
|---|---|---|
| Repo-count mentions | `CLAUDE.md`, `README.md`, `architecture/repository-strategy.md`, `architecture/delivery-operating-model.md`, `architecture.md` (decision-log row #13, which the established precedent from today's earlier SCP treats as living, not frozen) | "16-repo" → "17-repo" / "16 repos" → "17 repos"; "15 service/UI/infra repos" (the execution-unit count, excluding the control plane) → "16" |
| Repo listings | `architecture/repository-strategy.md` (Repository List table + total line), `architecture/repo-structure.md` | Add a `ctam-jomockapi` row/section, Phase 0, dev/integration-only (same category note as `ctam-mock-auth`) |
| Epics connective docs | `epics/framework.md`, `epics/index.md` | Add a Phase 0 row/section ahead of Phase 1; link to the new epic |
| Tracking | `sprint-status.yaml` | Add `epic-0.0` + its stories |
| Build tooling | `scripts/python/build_html.py` NAV | Add the Phase 0 pages back (real content this time) |
| **Not touched** | Every "11 services" mention (PRD success criteria, NFR40, architecture.md service clusters, `conventions.md`, `starter-template.md`, etc.) | Correct as-is under the dev/integration-only classification — `ctam-jomockapi` doesn't join the 11-service count, same as `ctam-mock-auth` today |
| **Not touched** | Dated historical reports, PRD's D-table/editHistory, changelog.md's prior version rows | Immutable history, same convention as before |

### Technical impact
None — this control plane holds no runtime code, and `ctam-jomockapi` already exists and runs independently. This SCP only documents it; it doesn't move, rewrite, or take ownership of that repo's code.

## 3. Recommended Approach

**Direct Adjustment** — repurpose one fixture epic into a real one, add one new repo entry, update repo-count mentions. Effort: Medium (real epic-writing plus a repo-count sweep across ~6 living files — much smaller than today's earlier renumbering, since the "11 services" language is explicitly untouched under the dev/integration-only classification). Risk: Low, given the classification precedent (`ctam-mock-auth`) already exists to model this on.

## 4. PRD MVP Impact

None to FRs/NFRs. `ctam-jomockapi` doesn't fulfil an FR itself (it's a dev aid standing in for an unconfirmed upstream contract); it de-risks gap **G8.1** by giving `ctam-reference-data`'s Epic 1.1 (ingestion) a concrete, realistic contract to build and test against ahead of the real eLinks API being confirmed. `gaps.md` G8.1 gets a note pointing at it.

## 5. Implementation Handoff

**Scope classification: Minor** — additive, no FR/NFR/scope change, models an existing precedent (`ctam-mock-auth`). Direct implementation this session.

**Plan:**
1. Write the real `epic-0.0-joh-mock-apis.md` (user outcome, vertical slice referencing the actual endpoints/auth/data-generation approach, FRs supported — none directly, referenced from G8.1 — stories for "stand up the mock server for local dev" / "wire epic-1.1 ingestion against it").
2. Rewrite `epics/phase-0/index.md` as a real phase index.
3. Add the repo-list row to `repository-strategy.md` and a tree section to `repo-structure.md`.
4. Sweep repo-count mentions (16→17, 15→16 execution units) in `CLAUDE.md`, `README.md`, `delivery-operating-model.md`, `architecture.md`'s decision-log row #13.
5. Add a Phase 0 section to `framework.md`, a Phase 0 entry to `epics/index.md`, `epic-0.0` to `sprint-status.yaml`, Phase 0 pages to `build_html.py` NAV.
6. Add a `changelog.md` entry.
7. Verify with the same kind of audit script used for the earlier renumbering (grep every changed repo-count number against its original, confirm no stray "11 services" got bumped).
8. Regenerate `docs/`.

**Success criteria:** `ctam-jomockapi` is documented once, correctly, in the two repo-listing shards; every living repo-count mention reads 17 (not 16, not 18); every "11 services" mention is untouched; the new Phase 0 epic accurately reflects what the sibling repo actually does (verified against its README); `docs/` regenerates clean.
