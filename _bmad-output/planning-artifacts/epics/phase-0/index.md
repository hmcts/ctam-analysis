---
type: 'Phase Index'
title: 'Phase 0 — JOH'
description: 'Phase 0 covers JOH Records & Working Patterns (FR10-FR18, framework-only so far). Its first concrete epic, 0.0, confirms the JOH eLinks API contract and builds a CI-only mock for it — foundational for everything else in this phase, which reads jo_* data ingested via that same eLinks contract.'
resource: 'epics/phase-0/index.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-20'
parent: 'epics/index.md'
phase: 0
phaseName: 'JOH'
---

# Phase 0 — JOH

> Phase 0's primary area — **JOH Records & Working Patterns** (FR10–FR18) — is framework-only so far (see [../framework.md](../framework.md) → *Phase 0 · Area: JOH Records & Working Patterns*); `bmad-create-epics-and-stories` has not yet been run for it. **Epic 0.0** is this phase's first concrete, storied epic — added 2026-08-20 as the JOH eLinks API contract-mock epic, because it's upstream-contract confirmation for JOH data, which this phase is the natural home for, not Phase 1 platform/foundations work.
>
> **Numbering history:** this epic was first added to what was then called "Phase 0" (Foundations, before today) as Epic 0.10 (quoted `"0.10"`, since that phase's ten single-digit slots were exhausted). It moved to a newly-created "Phase 1" (JOH) as Epic 1.0 (SCP 2026-08-20g), retiring the quoting since it was now the first epic of a fresh phase. Today (SCP 2026-08-20h), Phase 0 and Phase 1 were swapped wholesale — Foundations content moved to the folder now called `phase-1/`, and this epic (JOH) moved to the folder now called `phase-0/`, becoming **Epic 0.0**.

## Epics

| Epic | Title | Stories | Status |
|---|---|---|---|
| [0.0](epic-0.0-joh-elinks-api-contract-mock.md) | The JOH eLinks API contract is confirmed and mocked for CI-only integration testing | 1 | 🟡 Planned |
| **Total** | | **1 story** | |

## Epic summaries

### Epic 0.0: The JOH eLinks API contract is confirmed and mocked for CI-only integration testing (1 story)

**User outcome:** The real JOH eLinks People API (v5) is confirmed — endpoints, auth, pagination, response shapes — via an external reference mock, resolving the structural half of gaps.md G8.1, and reproduced as a contract-accurate CI-only fixture layer inside `ctam-reference-data` so Phase 1's Epic 1.2 (eLinks sync) integration-tests against a faithful target. Surfaced a new gap (G8.7): the real API has no `personnel_number` field (it returns `per_id`/`personal_code` instead) — recorded, not resolved, by this epic. Cross-phase dependency: `depends_on: [epic-1.1]` (Phase 1's tier-(a) schema).

**FRs covered:** none directly (contract-confirmation + CI test-infrastructure); supports FR1, NFR24, and — looking ahead — this phase's own FR10–FR18 (all of which read `jo_people` data via the contract this epic confirms).

→ [Full epic with stories](epic-0.0-joh-elinks-api-contract-mock.md)

## Not yet storied

**JOH Records & Working Patterns** (FR10–FR18) itself remains framework-only. Per [../framework.md](../framework.md): `ctam-joh` backend + `joh/` UI module in `ctam-ui`; JOH profile views composing tier-(a) `jo_*` data with `ctam-joh`'s CTAM-owned overlays; Working Patterns; forward-sitting generation; ticket overlays; same-Region base-location switching; off-circuit/cross-Region JOH linking. Depends on Phase 1 epics 1.4 (auth) and 1.5 (reference-data reads) — see *Phase dependency order* in framework.md. Run `bmad-create-epics-and-stories` for this phase to decompose it.

## Validation

- Not yet run for this phase's primary area. Epic 0.0 itself needs no separate readiness gate beyond the standard dispatch-preflight check (`depends_on: [epic-1.1]`, `done` before dispatch).
