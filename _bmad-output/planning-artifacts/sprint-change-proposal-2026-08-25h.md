---
type: 'Sprint Change Proposal'
description: 'Fixes five cross-epic inconsistencies found by reviewing all 5 Phase 0 epics: a port collision, a misattributed FR, a wrong story citation, a missing table creation, and an unclarified local-vs-shared-estate run-mode.'
resource: 'sprint-change-proposal-2026-08-25h.html'
tags: [ctam-pathfinder, sprint-change-proposal]
timestamp: '2026-08-25'
title: 'Sprint Change Proposal — 2026-08-25h'
status: 'approved'
---

# Sprint Change Proposal — 2026-08-25h

**Trigger:** *"review all the 5 epics and suggest if there are any changes"*, followed by *"fix all the above inconsistencies"* after the review was presented.

**Mode:** Batch. **Scope classification:** **Minor** — documentation/citation fixes within existing epics; no scope change, no FR/NFR change, no `depends_on` change.

---

## 1. Issue Summary

A full read-through of all 5 Phase 0 epics (0.0–0.4) — prompted by a request to review them for consistency — surfaced five concrete inconsistencies, none caught by the narrower per-round sweeps in earlier SCPs because they cut across epics rather than living inside the one epic each prior SCP touched.

## 2. Impact Analysis

### Finding 1 — Port collision between `ctam-joh` and `ctam-reference-data`

Story 0.1.1 and Story 0.3.1 both hardcoded "default port is 8082 (per AR3)," and AR3 itself just says "Default port 8082" with no per-service override. Two services scaffolded from the same rule would collide the moment they run side by side (locally, or in a cluster without an explicit override).

**Fix:** AR3 revised to say each service gets its own distinct port, starting from 8082 and incrementing per service in scaffold order. `ctam-joh` moves to **8083**; `ctam-reference-data` keeps **8082** (it was scaffolded first, and is referenced by port number in several other places — moving it would have a larger ripple for no benefit); `ctam-jomockapi`'s existing 8090 is called out as consistent with this pattern.

### Finding 2 — FR8 double-attributed

Epic 0.3's "FRs covered" line claimed *"FR8 (shared `ctam_configuration_values` baseline first lands here)"* — but `fr-coverage-map.md` and Epic 0.0 Story 0.0.7 both correctly show Epic 0.0 as the epic that creates that table. Epic 0.3 only verifies the table is reachable before `ctam-reference-data` proceeds (Story 0.3.1's AC); it doesn't deliver FR8.

**Fix:** Epic 0.3's "FRs covered" line drops the FR8 claim and adds a parenthetical: *"FR8 is delivered by Epic 0.0, Story 0.0.7 — this epic only consumes/verifies the shared baseline."*

### Finding 3 — Wrong story citation in Epic 0.4, Story 0.4.1

Its lead AC said *"Given `ctam-reference-data` is scaffolded and carries the tier-(a) tables per Story 0.3.3"* — Story 0.3.3 is the nightly sync (populates data); the tables themselves are created in **Story 0.3.2**. Story 0.4.1 only needs the tables to exist (to keep tier-(b) tables separate from them), not populated data.

**Fix:** Citation corrected to Story 0.3.2, with a parenthetical explaining why (doesn't need the sync to have run).

### Finding 4 — `ctam_joh_identities` never explicitly created

Story 0.3.2's changeset AC enumerated exactly the 15 `jo_*` tables plus `ctam_sync_status` — `ctam_joh_identities` appeared nowhere in either list, despite Story 0.3.3 minting rows into it, Epic 0.1's Story 0.1.2 citing it as an existing FK target (correctly, citing Story 0.3.2), and Epic 0.3's own prose describing binding `personnel_number` to it.

**Fix:** Story 0.3.2's changeset AC now explicitly creates `ctam_joh_identities` (`id uuid PK`, `personnel_number` unique, `created_at`/`updated_at`), stating it's created empty here and populated row-by-row by Story 0.3.3's sync.

### Finding 5 — Local mock vs. AKS-deployed `ctam-reference-data` unreconciled

Epic 0.2's `ctam-jomockapi` runs **only locally** via Docker Compose (SCP 2026-08-25f). Story 0.3.3's mock-integration AC pointed the sync's "local base URL" at it — but Story 0.3.1 (same epic) also deploys `ctam-reference-data` to the shared AKS dev cluster, and an AKS pod has no network path to a developer's Docker Compose network. Nothing said which run-mode of `ctam-reference-data` the mock-integration AC exercises.

**Fix:** The AC now states explicitly that it exercises `ctam-reference-data` run locally too (`./gradlew bootRun` alongside `docker-compose up`, per Story 0.3.1's local-verification AC) — **not** the AKS-deployed instance.

### Not fixed — raised as an open question instead

A sixth observation from the review: Epic 0.0 still provisions a full Terraform shared Azure estate (5 stories) for the domain services, while Epic 0.2 just moved to local-only for its mock. Whether that split is intentional (mocks stay local forever; domain services need a real shared environment eventually) or whether the team's local-first practice should extend further is a product/architecture call, not a documentation bug — left open for the user to decide, not fixed here.

### Artifact sweep

| Artifact | Change |
|---|---|
| `epics/requirements-inventory.md` | AR3 reworded — per-service distinct ports |
| `epic-0.1-postgres-sql-schema-design.md` | Story 0.1.1 port 8082 → 8083 |
| `epic-0.3-joh-reference-data-etl-process.md` | FR8 attribution reworded; `ctam_joh_identities` added to Story 0.3.2's changeset; Story 0.3.3's mock-integration AC clarified (local `ctam-reference-data`, not AKS) |
| `epic-0.4-joh-data-read-only-api.md` | Story 0.4.1's prerequisite citation fixed (0.3.3 → 0.3.2) |
| `architecture.md` | New decision **#21** |
| `architecture/changelog.md` | New **v4.18** entry |

**Not touched:** `epic-0.0`, `epic-0.2` (no findings against them beyond the open question); `fr-coverage-map.md` (already correctly attributed FR8 to Epic 0.0 — Epic 0.3 was the one out of step, now fixed to match); `sprint-status.yaml` (no story added/removed/renamed — only AC text and one port number changed within existing stories); dated historical SCPs/changelog entries (immutable record).

## 3. Recommended Approach

**Direct implementation.** Effort: **Low** — five targeted text edits across three epic files plus one requirements-inventory row, no structural change. **Risk:** Very low — nothing here changes `depends_on`, FR/NFR coverage, or story counts; it only corrects citations, a port number, and an implicit-but-undocumented table creation to match what other stories already assumed.

## 4. Detailed Change Proposals

See §2 for the full before/after mapping. Full diffs are in the files themselves.

## 5. Implementation Handoff

**Scope: Minor** — documentation/citation corrections within the existing plan, no scope or dependency change.

**Responsibilities:**
- **This session:** all edits above applied directly; nothing committed without being asked.
- **Product Owner / Architect (deferred):** decide the open question above — whether Epic 0.0's shared-estate scope should also narrow toward local-first for Phase 0, or stays as-is for the real domain services. Not gating on this SCP.

**Success criteria:** no two Phase 0 services share a hardcoded port; Epic 0.3's FR8 claim matches `fr-coverage-map.md` and Epic 0.0; every story citation in Epic 0.4 points at the story that actually delivers what it depends on; `ctam_joh_identities` has an explicit creation point before anything reads or writes it; Story 0.3.3's mock-integration AC is unambiguous about which `ctam-reference-data` run-mode it exercises.
