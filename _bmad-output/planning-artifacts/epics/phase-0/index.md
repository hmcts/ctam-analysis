---
type: 'Phase Index'
title: 'Phase 0 — Dev/Integration Prerequisites'
description: 'User outcome: a local mock of the JOH eLinks API exists so ctam-reference-data can build and test its ingestion sync ahead of the real upstream contract being confirmed.'
resource: 'epics/phase-0/index.html'
tags: [ctam-pathfinder, epics]
timestamp: '2026-08-24'
parent: 'epics/index.md'
phase: 0
phaseName: 'Dev/Integration Prerequisites'
---

# Phase 0 — Dev/Integration Prerequisites

> Phase 0 holds **dev/integration-only prerequisites** — tooling that exists to support building the real product but is never itself deployed to production, the same category as `ctam-mock-auth`. It precedes Phase 1 (Foundations) numerically because Epic 0.0's mock server is a prerequisite for Phase 1's ingestion work (Epic 1.1), not because it is part of the product's own phase sequence. Added 2026-08-24 (SCP 2026-08-24b).

## Epics

| Epic | Title | Stories | Status |
|---|---|---|---|
| [0.0](epic-0.0-joh-mock-apis.md) | JOH Mock APIs — local eLinks mock server | 2 | 🟡 Planned |

### Epic 0.0: JOH Mock APIs — local eLinks mock server (2 stories)

**User outcome:** A local mock of the upstream **Judiciary E-links People API (v5)** (`ctam-jomockapi`) gives `ctam-reference-data`'s ingestion sync (Epic 1.1) a realistic, stable contract to build and test against ahead of the real eLinks API's contract being confirmed (gap G8.1). Dev/integration-only — never deployed to production.

**Component(s)**: `ctam-jomockapi` (new repo, dev/integration-only, classified like `ctam-mock-auth`).

**Primary FR/NFR coverage**: none directly (a dev/test aid); supports FR1, FR6, FR7 indirectly via Epic 1.1.

→ [Full epic with stories](epic-0.0-joh-mock-apis.md)
