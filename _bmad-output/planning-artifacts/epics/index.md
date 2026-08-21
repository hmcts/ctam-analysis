---
type: 'Epics Index'
title: 'ctam-analysis (CTAM Pathfinder) — Epic Breakdown'
description: 'This is the entry point for the CTAM Pathfinder epic and story breakdown.'
resource: 'epics/index.html'
tags: [ctam-pathfinder, epics, employment-tribunals]
timestamp: '2026-06-11'
projectName: 'ctam-analysis'
productCodename: 'CTAM Pathfinder'
inputDocuments:
  - '_bmad-output/planning-artifacts/prd.md'
  - '_bmad-output/planning-artifacts/architecture.md'
  - '_bmad-output/planning-artifacts/architecture/data-tables.md'
  - '_bmad-output/planning-artifacts/architecture/starter-template.md'
  - '_bmad-output/planning-artifacts/architecture/repo-structure.md'
  - '_bmad-output/planning-artifacts/architecture/repository-strategy.md'
uxDocument: 'not-present-accepted-gap'
stepsCompleted:
  - 'step-01-validate-prerequisites'
  - 'step-02-design-epics-phase-1'
  - 'step-03-create-stories-phase-1'
  - 'step-04-final-validation-phase-1'
---

# ctam-analysis (CTAM Pathfinder) — Epic Breakdown

This is the **entry point** for the CTAM Pathfinder epic and story breakdown. Each section below lives in its own file for maintainability.

## Overview

CTAM Pathfinder is HMCTS's greenfield JOH availability-and-scheduling platform — rolled out **jurisdiction by jurisdiction**[^d13]: **wave 1 = the Employment Tribunals (ET) jurisdiction** (its scheduling incumbent is not yet identified — gap G8.4); **wave 2 = SSCS**, replacing **ListAssist** (the SSCS judicial-scheduling tool; GAPS, the SSCS case-management system, is retained); **waves 3+ = the Courts jurisdictions**, replacing the as-is JI application (Oracle APEX) per HMCTS judicial region. Scope boundary[^d12]: availability/scheduling only; case and hearing management live in external systems that consume CTAM's APIs. This document decomposes the requirements from the PRD (60 FRs, 42 NFRs, D1–D13 — ET-first wave 1[^d13]) and the Architecture (HMCTS Crime SpringBoot starter, polyrepo, shared-DB + per-service DB roles, two-tier reference data ingested from JOH eLinks + MRD, two-population identity, Kubernetes on Azure AKS) into implementable stories.

UX Design document is not present; downstream epics inherit UI requirements directly from PRD FRs (FR55, FR56) and architecture conventions (GOV.UK Design System base, WCAG 2.2 AA per NFR17). This gap is documented in the 2026-05-06 readiness report.

## Document Map

### Foundations (project-wide context)

| File | Contents |
|---|---|
| [requirements-inventory.md](requirements-inventory.md) | All FRs (FR1–FR60), NFRs (NFR1–NFR42), Architecture-derived ARs (AR1–AR52), and UX Design Requirements (none — accepted gap) |
| [framework.md](framework.md) | Phase × Area architectural framework — the spine that organises concrete epics across 10 sequential phases |
| [fr-coverage-map.md](fr-coverage-map.md) | Single source of truth for FR → Epic mapping across the whole programme |

### Phase-level breakdowns (one folder per phase)

| Phase | Folder | Status |
|---|---|---|
| **1** — Foundations | [phase-1/](phase-1/index.md) | 🟡 Planned — 10 epics, 22 stories |
| **0** — JOH | [phase-0/](phase-0/index.md) | 🟡 Planned — 1 epic, 3 stories (primary area FR10–FR18 still framework only) |
| **2** — Absence | _to be storied_ | ⚪ Framework only |
| **3** — Vacancy | _to be storied_ | ⚪ Framework only |
| **4** — Booking | _to be storied_ | ⚪ Framework only |
| **5** — Sitting | _to be storied_ | ⚪ Framework only |
| **6** — Payment | _to be storied_ | ⚪ Framework only |
| **7** — Itineraries | _to be storied_ | ⚪ Framework only |
| **8** — MI Feed & Reporting | _to be storied_ | ⚪ Framework only |
| **9+** — Wave Rollout (jurisdiction-first) | _to be storied_ | ⚪ Framework only |

## How this document is produced

Each phase advances through four steps of the `bmad-create-epics-and-stories` workflow:

1. **Validate prerequisites** — confirm PRD + Architecture available, extract requirements
2. **Design epics** — group requirements into user-value epics (not technical milestones)
3. **Create stories** — produce Gherkin-AC user stories sized for a single dev-agent session
4. **Final validation** — verify FR/NFR coverage, dependency soundness, architecture compliance

Phase 1 has completed all four steps. Phase 0 has one epic through all four steps (Epic 0.0, added 2026-08-20 ahead of its primary area — see [phase-0/index.md](phase-0/index.md)); its primary area (JOH Records & Working Patterns, FR10–FR18) is still framework-only. Phases 2–9+ are at the framework stage only (Step 1 inputs ready; Steps 2–4 not yet run).

## How to find your way

- **Looking for what to build next?** Start at the phase index (e.g. [phase-1/index.md](phase-1/index.md)) and pick an epic.
- **Looking for a specific story?** Stories are named `Story {phase}.{epic}.{n}` (e.g. Story 1.1.5). They live under `phase-{n}/epic-{n}.{m}-{slug}.md`.
- **Looking for an FR?** Use [fr-coverage-map.md](fr-coverage-map.md).
- **Looking for an architecture rule?** Use [requirements-inventory.md](requirements-inventory.md) — ARs are in the Additional Requirements section.
- **Verifying readiness?** Run `bmad-check-implementation-readiness` from the repo root; it understands this sharded shape.

[^d11]: D11 (2026-06-10, amended 2026-06-18; **superseded by D13 2026-08-07 for wave ordering**) — SSCS pilot wave: CTAM Pathfinder replaces **ListAssist** (the SSCS judicial-scheduling tool); **GAPS (SSCS case management) is retained, not replaced**. Per D13 the SSCS wave is **wave 2**.

[^d13]: D13 (2026-08-07, supersedes D11) — ET-first pilot: wave 1 = the **Employment Tribunals (ET)** jurisdiction (scheduling incumbent `[ET-INCUMBENT-TBD]` — unidentified, gap G8.4); wave 2 = **SSCS** (replaces **ListAssist**; **GAPS**, SSCS case management, is retained); waves 3+ = Courts jurisdictions per HMCTS judicial region (replacing JI/APEX).
[^d12]: D12 (2026-06-10) — CTAM is the system of record for JOH availability and scheduling only; case and hearing management live in external systems.
