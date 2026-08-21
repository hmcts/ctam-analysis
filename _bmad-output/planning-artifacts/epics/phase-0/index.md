---
type: 'Phase Index'
title: 'Phase 0 — JOH'
description: 'Phase 0 covers JOH Records & Working Patterns (FR10-FR18, framework-only so far). Its two concrete epics de-risk the two upstream data feeds this phase (and the phase after it) depend on: Epic 0.0 confirms the real JOH data source and builds a practice copy of it; Epic 0.1 proposes a provisional shape for the MRD workbook, since no real example exists yet, and builds a practice copy of that.'
resource: 'epics/phase-0/index.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-20'
parent: 'epics/index.md'
phase: 0
phaseName: 'JOH'
---

# Phase 0 — JOH

> Phase 0's primary area — **JOH Records & Working Patterns** (FR10–FR18) — is framework-only so far (see [../framework.md](../framework.md) → *Phase 0 · Area: JOH Records & Working Patterns*); `bmad-create-epics-and-stories` has not yet been run for it. **Epics 0.0 and 0.1** are this phase's first concrete, storied epics — both are practice copies of the two upstream data feeds this phase (and the one after it) depend on, built ahead of the primary area itself so the team building those feeds has something realistic to test against.
>
> **Numbering history:** Epic 0.0 was first added to what was then called "Phase 0" (Foundations, before 2026-08-20) as Epic 0.10, then moved to a newly-created "Phase 1" (JOH) as Epic 1.0, then to here as **Epic 0.0** when Phase 0 and Phase 1 were swapped wholesale (2026-08-20). Epic 0.1 is genuinely new work (2026-08-21), added as Epic 0.0's sibling for the MRD side of the same de-risking approach — it was never anywhere else.

## Epics

| Epic | Title | Stories | Status |
|---|---|---|---|
| [0.0](epic-0.0-joh-elinks-api-contract-mock.md) | The JOH eLinks API contract is confirmed and mocked for CI-only integration testing | 3 | 🟡 Planned |
| [0.1](epic-0.1-mrd-reference-data-mock.md) | A provisional MRD workbook shape is proposed and mocked for CI-only integration testing | 3 | 🟡 Planned |
| **Total** | | **6 stories** | |

## Epic summaries

### Epic 0.0: The JOH eLinks API contract is confirmed and mocked for CI-only integration testing (3 stories)

**Outcome:** The real JOH data source is confirmed — its addresses, security rules, paging behaviour, and response shapes — via a real reference example, and reproduced as a realistic practice copy inside `ctam-reference-data` so the team building the JOH data sync (Epic 1.2, in the Foundations phase) tests against a faithful target. This work also uncovered an important discovery: the real data source doesn't use the identifier field the team had assumed it would — written down, not yet resolved. Depends on the Foundations-phase database schema work (`depends_on: [epic-1.1]`).

→ [Full epic with stories](epic-0.0-joh-elinks-api-contract-mock.md)

### Epic 0.1: A provisional MRD workbook shape is proposed and mocked for CI-only integration testing (3 stories)

**Outcome:** Unlike Epic 0.0, no real reference example of the MRD workbook exists yet. This work proposes a reasoned, clearly-labelled working assumption for its shape, and builds a realistic practice copy against that proposal, so the team building the MRD data load (Epic 1.3, in the Foundations phase) has something concrete to test against now — while keeping the open question (what does the real workbook actually look like?) visibly tracked until the MRD team confirms or corrects it. Depends on the Foundations-phase MRD table work (`depends_on: [epic-1.3]`).

→ [Full epic with stories](epic-0.1-mrd-reference-data-mock.md)

## Not yet storied

**JOH Records & Working Patterns** (FR10–FR18) itself remains framework-only. Per [../framework.md](../framework.md): `ctam-joh` backend + `joh/` UI module in `ctam-ui`; JOH profile views composing tier-(a) `jo_*` data with `ctam-joh`'s CTAM-owned overlays; Working Patterns; forward-sitting generation; ticket overlays; same-Region base-location switching; off-circuit/cross-Region JOH linking. Depends on Phase 1 epics 1.4 (auth) and 1.5 (reference-data reads) — see *Phase dependency order* in framework.md. Run `bmad-create-epics-and-stories` for this phase to decompose it.

## Validation

- Not yet run for this phase's primary area. Epics 0.0 and 0.1 themselves need no separate readiness gate beyond the standard dispatch-preflight check (`depends_on: [epic-1.1]` and `depends_on: [epic-1.3]` respectively, each `done` before dispatch).
