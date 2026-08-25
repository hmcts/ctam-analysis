---
type: 'Sprint Change Proposal'
description: 'Narrows Phase 0 to epics 0.0-0.4 (the JOH data pipeline). Removes Notification, User authenticates, MRD ingestion, User populations bootstrapped, and MRD data read API from the active plan. Folds the context bus into Epic 0.0 and simplifies Epic 0.4s read API to open/unauthenticated to resolve the two real dependency breaks this creates.'
resource: 'sprint-change-proposal-2026-08-25d.html'
tags: [ctam-pathfinder, sprint-change-proposal]
timestamp: '2026-08-25'
title: 'Sprint Change Proposal — 2026-08-25d'
status: 'approved'
---

# Sprint Change Proposal — 2026-08-25d

**Trigger:** *"retain the epics from 0.0,0.1,0.2,0.3,0.4 and remove all the other epics"*, followed by *"update all the files based on latest changes"* after the initial clarifying questions were declined.

**Mode:** Batch. **Scope classification:** **Major** — this removes real product scope (auth, notification, MRD, user bootstrap) from Phase 0, not just relabeling. Routed as recorded below.

---

## 1. Issue Summary

The team wants Phase 0 narrowed to just epics 0.0–0.4 — the platform estate and the JOH data pipeline (schema, mock API, ETL, read API) — with everything else removed. This is not a pure numbering exercise like the previous several SCPs this session: two of the epics being removed are genuine dependencies of epics being kept:

1. **Epic 0.1** (JOH schema) and **Epic 0.3** (JOH ETL) both `depends_on: epic-0.6` — the context bus (published architecture submodule) and the shared `ctam_configuration_values` baseline table.
2. **Epic 0.4** (JOH data read API)'s stories require `JWTFilter`-protected, jurisdiction-filtered endpoints, sourced from **Epic 0.7** (User authenticates).

I asked clarifying questions about how to resolve these two breaks and about whether "remove" meant permanent deletion or deferral; the questions were declined and the follow-up instruction was to proceed and keep everything else consistent. I resolved the two breaks using the options I'd flagged as recommended:

1. **Context bus folded into Epic 0.0** — its two stories become Stories 0.0.6–0.0.7. This is not just relabeling: Story 0.6.1 (publish `ctam-architecture` as the context bus, tag `arch-v1.0`) was recorded `done` in `sprint-status.yaml` — that status carries forward as Story 0.0.6, it is not reset to `backlog`.
2. **Epic 0.4's read API simplified to open/unauthenticated** — `JWTFilter` protection and jurisdiction-filtering are removed from its acceptance criteria, with an explicit note that re-adding them later (when an auth epic returns) is additive, not a redesign.

## 2. Impact Analysis

### Epics removed (files deleted, git history retains them)

| Epic | Title | Stories | What happens to its scope |
|---|---|---|---|
| 0.5 | Notification service is scaffolded and contractually ready | 2 | FR9 unimplemented; downstream consumers (booking/absence acks, payment-schedule dispatch) blocked until re-planned |
| 0.6 | Context bus is published and the shared configuration baseline exists | 2 | **Folded into Epic 0.0**, not lost — Stories 0.0.6–0.0.7, `done` status preserved |
| 0.7 | User authenticates and lands on a role-scoped Home page | 5 | FR1–FR3, FR55, FR56, FR58 (auth half) unimplemented; Epic 0.4's API loses auth protection as a direct consequence |
| 0.8 | MRD supplementary reference data is ingested | 1 | `mrd_*` ingestion unimplemented; MRD read API (0.10) loses its data source |
| 0.9 | Both user populations are bootstrapped and verifiable against the IdP | 1 | FR4, FR57 unimplemented |
| 0.10 | MRD data is served read-only via a versioned, jurisdiction-filtered API | 1 | Removed along with its data source (Epic 0.8) |

**Total removed: 12 stories.** Phase 0 goes from 11 epics / 27 stories to **5 epics / 17 stories** (the +2 from folding Epic 0.6 into Epic 0.0 is why it isn't 15).

### Epics kept, and what changed in them

- **Epic 0.0** — gains Stories 0.0.6–0.0.7 (folded from 0.6), `repo:` becomes a list (`[ctam-shared-infrastructure, ctam-architecture]`), storyCount 5→7.
- **Epic 0.1** — `depends_on` drops `epic-0.6`, now `[epic-0.0, epic-0.3]` (the context bus dependency now resolves through Epic 0.0).
- **Epic 0.2** — unaffected (no cross-references to removed epics).
- **Epic 0.3** — `depends_on` drops `epic-0.6`, now `[epic-0.0]`. All MRD and auth cross-references reworded to reflect their removal (not deletion of the ETL epic's own content — its 3 stories are unchanged).
- **Epic 0.4** — `depends_on` drops `epic-0.7`, now `[epic-0.3]`. Story 0.4.2 rewritten: drops `JWTFilter` protection, jurisdiction-filtering, the 401 Postman case, and the MRD-specific NFR13/NFR12 references. Title drops "jurisdiction-filtered." Explicit scope-reduction note added.

### Artifact sweep

| Artifact | Change |
|---|---|
| 6 epic files | Deleted |
| `epic-0.0-platform-estate-provisioned.md` | +2 stories (0.0.6–0.0.7), `repo:` → list, scope-reduction note |
| `epic-0.1-postgres-sql-schema-design.md` | `depends_on` fixed, context-bus reference updated to Epic 0.0 |
| `epic-0.3-joh-reference-data-etl-process.md` | `depends_on` fixed; MRD/auth cross-references reworded throughout; one Story 0.3.3 AC reworded (no longer references the removed authorisation service for verification) |
| `epic-0.4-joh-data-read-only-api.md` | `depends_on` fixed; retitled; Story 0.4.2 rewritten to open/unauthenticated; scope-reduction notes added |
| `epics/phase-0/index.md` | Full rewrite: 5 epics, 17 stories |
| `epics/index.md` | Phase 0 count: 5 epics, 17 stories |
| `epics/framework.md` | Phase 0 Areas without a concrete epic marked as such (not deleted — they're still the architectural map); dependency-order table and parallelism note fixed |
| `epics/fr-coverage-map.md` | FR1–FR4, FR9, FR55–FR58 (partial), FR57 marked ⚪ not currently delivered (not deleted — real PRD requirements) |
| `epics/requirements-inventory.md` | MRD storage cross-reference marked not-currently-provisioned |
| `architecture/non-functional-requirements-coverage.md` | NFR24 narrowed to JOH-only |
| `architecture/repository-strategy.md` | `ctam-reference-data` row: MRD/auth cross-references removed |
| `architecture/gaps.md` | G8.1: MRD half marked untracked (gap itself not closed) |
| `architecture/delivery-operating-model.md` | Illustrative examples referencing removed epics swapped for still-valid ones |
| `architecture.md` | New decision **#18** |
| `architecture/changelog.md` | New **v4.15** entry |
| `sprint-status.yaml` | 6 epic blocks removed; Epic 0.0 gains Stories 0.0.6 (**`done`**, carried forward) and 0.0.7; incidental fix of a stale "16-repo" comment to "17-repo" |
| `scripts/python/build_html.py` | NAV: 6 entries removed, Epic 0.0's story count updated |

**Not touched:** dated historical SCPs/changelog entries (immutable record of what was true when written); `data-tables.md` (schema for removed epics' tables is unaffected — the tables just aren't being created by an active epic right now).

## 3. Recommended Approach

**Direct implementation** (the two clarifying questions were declined, so I proceeded using the recommended defaults I'd already identified, rather than blocking further). Deletion was judged safe to do literally (not just deferred) because: this branch's prior commit is already pushed to the remote PR, so the removed epics' content remains fully recoverable via git history without needing an in-repo "deferred" holding area.

**Effort:** High (large mechanical sweep). **Risk:** Medium — this is a real scope cut, not a relabel; FR1–FR4, FR9, FR55–58, FR57 genuinely lose Phase 0 coverage and are flagged as such rather than silently dropped. **Timeline impact:** Reduces Phase 0's build scope by roughly 44% of its stories (12 of 27); nothing currently in flight was disrupted (`sprint-status.yaml` showed only Story 0.6.1 as `done`, now carried forward as 0.0.6).

## 4. Detailed Change Proposals

See §2 for the full before/after mapping. Full diffs are in the files themselves.

## 5. Implementation Handoff

**Scope: Major** — real functional scope removed from an active plan, not a backlog reorganisation. Per the workflow's own classification this would normally route to Product Manager / Solution Architect for a fundamental replan; it was executed directly here per explicit, repeated user instruction (the clarifying questions that would normally precede PM/Architect-level judgment were declined twice).

**Responsibilities:**
- **Product Owner / stakeholders:** confirm this scope cut is intended for the demo/milestone this narrower Phase 0 is meant to support, and decide when (if ever) auth, notification, MRD, and user bootstrap should be re-planned as new epics.
- **This session:** all edits above applied directly; `docs/` regenerated; nothing committed without being asked.

**Success criteria:** all 5 remaining epic files are internally consistent (no dangling references to removed epics); `depends_on` arrays across the 5 epics resolve only to each other; `epics/phase-0/index.md`'s two summary tables agree (17 stories, 5 epics); `fr-coverage-map.md` accurately marks every FR that lost coverage; `docs/` regenerates cleanly with no dangling nav links to deleted epic pages.
