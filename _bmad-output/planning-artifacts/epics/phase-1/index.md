---
type: 'Phase Index'
title: 'Phase 1 — JOH'
description: 'Phase 1 covers JOH Records & Working Patterns (FR10-FR18, framework-only so far). Its first concrete epic, 1.0, confirms the JOH eLinks API contract and builds a CI-only mock for it — foundational for everything else in this phase, which reads jo_* data ingested via that same eLinks contract.'
resource: 'epics/phase-1/index.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-08-20'
parent: 'epics/index.md'
phase: 1
phaseName: 'JOH'
---

# Phase 1 — JOH

> Phase 1's primary area — **JOH Records & Working Patterns** (FR10–FR18) — is framework-only so far (see [../framework.md](../framework.md) → *Phase 1 · Area: JOH Records & Working Patterns*); `bmad-create-epics-and-stories` has not yet been run for it. **Epic 1.0** is this phase's first concrete, storied epic — added 2026-08-20, moved here from Phase 0 (see its own file for the numbering/move history) because it's upstream-contract confirmation for JOH data, which this phase is the natural home for, not Phase 0 platform/foundations work.

## Epics

| Epic | Title | Stories | Status |
|---|---|---|---|
| [1.0](epic-1.0-joh-elinks-api-contract-mock.md) | The JOH eLinks API contract is confirmed and mocked for CI-only integration testing | 1 | 🟡 Planned |
| **Total** | | **1 story** | |

## Epic summaries

### Epic 1.0: The JOH eLinks API contract is confirmed and mocked for CI-only integration testing (1 story)

**User outcome:** The real JOH eLinks People API (v5) is confirmed — endpoints, auth, pagination, response shapes — via an external reference mock, resolving the structural half of gaps.md G8.1, and reproduced as a contract-accurate CI-only fixture layer inside `ctam-reference-data` so Phase 0's Epic 0.2 (eLinks sync) integration-tests against a faithful target. Surfaced a new gap (G8.7): the real API has no `personnel_number` field (it returns `per_id`/`personal_code` instead) — recorded, not resolved, by this epic. Cross-phase dependency: `depends_on: [epic-0.1]` (Phase 0's tier-(a) schema).

**FRs covered:** none directly (contract-confirmation + CI test-infrastructure); supports FR1, NFR24, and — looking ahead — this phase's own FR10–FR18 (all of which read `jo_people` data via the contract this epic confirms).

→ [Full epic with stories](epic-1.0-joh-elinks-api-contract-mock.md)

## Not yet storied

**JOH Records & Working Patterns** (FR10–FR18) itself remains framework-only. Per [../framework.md](../framework.md): `ctam-joh` backend + `joh/` UI module in `ctam-ui`; JOH profile views composing tier-(a) `jo_*` data with `ctam-joh`'s CTAM-owned overlays; Working Patterns; forward-sitting generation; ticket overlays; same-Region base-location switching; off-circuit/cross-Region JOH linking. Depends on Phase 0 epics 0.4 (auth) and 0.5 (reference-data reads) — see *Phase dependency order* in framework.md. Run `bmad-create-epics-and-stories` for this phase to decompose it.

## Validation

- Not yet run for this phase's primary area. Epic 1.0 itself needs no separate readiness gate beyond the standard dispatch-preflight check (`depends_on: [epic-0.1]`, `done` before dispatch).
