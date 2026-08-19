---
type: 'Phase Index'
title: 'Phase 0-Mock — Upstream Source Stand-Ins'
description: 'User outcome: Both of CTAM Pathfinder upstream sources of truth — the JOH eLinks API and the MRD weekly Excel feed — have contract-shaped, deployable stand-ins before the ingestion epics that consume them, so Phase 0 is buildable without external-team access…'
resource: 'epics/phase-0-mock/index.html'
tags: [ctam-pathfinder, epics, phase-0-mock]
timestamp: '2026-08-18'
parent: 'epics/index.md'
phase: 0-mock
phaseName: 'Upstream Source Stand-Ins'
---

# Phase 0-Mock — Upstream Source Stand-Ins

> **Phase 0-Mock runs before Phase 0's ingestion epics.** It is a **pre-Phase-0 tier**, not a slot in the 0–9 phase sequence: its two epics are dependencies **of** Epic 0.2 (JOH ingestion) and Epic 0.3 (MRD ingestion), and nothing else in the programme depends on them. [`../../delivery/dispatch-graph.yaml`](../../delivery/dispatch-graph.yaml) is the single authority on build order.
>
> The `0M.` epic prefix marks the tier explicitly, so no reader has to infer sequencing from a number that would otherwise sort after Epic 0.8.

## Why this phase exists

CTAM Pathfinder ingests judicial-holder reference data from two upstream sources of truth — the **JOH eLinks API** (15 `jo_*` entities, nightly JSON pull) and the **MRD weekly Excel feed** (`mrd_*`, Blob drop). Neither contract is confirmed. This is recorded as gaps.md **G8.1** and was **promoted to a wave-1 blocker on 2026-08-07**:

> *"The ingestion design (nightly in-process sync; weekly blob drop) **assumes**: the eLinks API exposes all 15 `jo_*` entities with stable natural keys; the jurisdiction hierarchy's parent-child shape is available; the MRD team can deliver the weekly workbook to an Azure Blob container in an agreed shape."*

Yet Epic 0.2 is the platform's foundational data layer — `jo_people` must exist before any JOH can sign in (Epic 0.4) — and Epic 0.3 follows it. Waiting on Judicial Office and the MRD team would idle the critical path.

So each upstream gets a **deployable, contract-shaped stand-in** delivered *before* the ingestion epic that consumes it. This is the same mock-first play the programme already runs for identity: `ctam-mock-auth` reduced HMCTS IdP *"from a Phase 0 blocker to a pre-Phase-9 prerequisite"* (see `architecture.md` → *Phasing of Authentication*). Phase 0-Mock generalises it from identity to the **upstream data plane** — an external-team dependency becomes a **configuration cutover**.

## What this phase does not do

**It does not close G8.1** — though the JOH half is now materially better evidenced than the MRD half. As of 2026-08-18 the **eLinks v5 contract is documented** and its real reference data is in hand (SCP 2026-08-18d), so `ctam-joh-mock` reflects vendor documentation rather than a guess; `ctam-mrd-mock` is still CTAM's expectation derived from the `mrd_*` schema in Epic 0.1. Neither is a **live connection**: nobody has authenticated against the real eLinks API, confirmed its cadence or SLA, verified `updated_since` semantics under load, seen a real person payload, or settled the MRD feed arrangement at all. G8.1 closes only when each ingestion has run end-to-end against **real** upstream data *and* ET jurisdiction coverage is confirmed. Both epics' final acceptance criteria state this explicitly and require a formal diff-and-architectural-PR when each real contract lands.

**Its fixtures are not ET evidence.** Per gaps.md **G8.5**, the repository holds no ET as-is analysis pack. Every ET role name and vocabulary value in both fixture sets is marked **provisional**.

## Scope model

- **Both stand-ins are first-class deployables, not test fixtures.** Each is deployed onto the shared Azure estate provisioned in **Epic 0.0** and reached over a **real HTTP or blob hop**. `ctam-mrd-mock` is scaffolded from the HMCTS Crime SpringBoot template via `ctam-scaffold.sh` (AR2–AR17); **`ctam-joh-mock` was adopted brownfield in Node/Express** and is the single documented exception to that rule (**AR55.1**), scoped to language and build tooling only. A mock living inside its consumer's test tree cannot be deployed, cannot be version-tagged independently, and quietly becomes an assertion about CTAM's own code rather than a written expectation of someone else's contract. Rationale in [`../../architecture/repository-strategy.md`](../../architecture/repository-strategy.md).
- **Never deployed to production**, guarded three ways per mock (gaps.md **G5.3** as widened): `production`-profile startup refusal, `deploy-production.yml` exclusion, and CI lint against any production manifest referencing them.
- **Neither owns a table in the shared schema.** Fixtures are in-repo resource files, so the Epic 0.1 schema fitness function and [`../../architecture/data-tables.md`](../../architecture/data-tables.md) need no exception. (Contrast `ctam-mock-auth`, which *does* own 2 dev-only tables because it is a stateful OIDC issuer.)
- **Each publishes its contract** — an OpenAPI 3.x spec for `ctam-joh-mock`, a column dictionary for `ctam-mrd-mock`. **The two are no longer equivalent in evidential status.** `ctam-joh-mock`'s spec is CTAM's reading of **documented vendor material** (`Swagger UI.pdf`, `apiresponses.docx`) with each field marked *evidenced* or *inferred*; `ctam-mrd-mock`'s dictionary is still CTAM's **guess**, with every guessed column pre-annotated. Both remain unagreed with their upstream owner.
- **Fixture identity is shared across the mocks.** A documented set of identity keys in the `ctam-joh-mock` fixtures is the same set the `ctam-mrd-mock` Specialisations reference, the **Epic 0.4** `ctam-mock-auth` JOH test-user roster resolves against, and the **Epic 0.7** bootstrap fixtures use — so a test user signs in and resolves end-to-end across all three mocks without hand-reconciled data, and at least one shared identity is an **ET** office holder. **Note:** those keys are **`per_id` / `personal_code`**, not `personnel_number` — the eLinks contract has no such field (finding F4 on Epic 0M.1). The D9 identity chain still names `personnel_number`; that correction is owned by a follow-up SCP.
- **`ctam-mock-auth` is not in this phase.** It is an **identity-provider** mock delivered as Story 0.4.2 inside Epic 0.4, whose user outcome — a user signs in and lands on a role-scoped Home page — needs the issuer, `ctam-authorisation` and `ctam-ui` together. Phase 0-Mock covers **upstream data-source** mocks only.
- **Not retired at cutover.** Like `ctam-mock-auth`, both stand-ins remain the non-production upstream for the life of the programme; no environment except production is expected to depend on live upstream access. What changes on G8.1 closure is that their fixtures and published contracts are reconciled against reality and re-tagged.

## Epics

| Epic | Title | Repo | Stories | Status |
|---|---|---|---|---|
| [0M.1](epic-0M.1-joh-reference-data-mocked.md) | Upstream JOH reference data has a contract-shaped mock source *(brownfield adoption; Node/Express per AR55.1)* | `ctam-joh-mock` | 2 | 🟡 Planned |
| [0M.2](epic-0M.2-mrd-reference-data-mocked.md) | Upstream MRD reference data has a contract-shaped mock source | `ctam-mrd-mock` | 2 | 🟡 Planned |
| **Total** | | | **4 stories** | |

## Epic summaries

### Epic 0M.1: Upstream JOH reference data has a contract-shaped mock source (2 stories) — *feeds Epic 0.2*

> **Brownfield adoption, not a greenfield build** (rewritten 2026-08-18, SCP 2026-08-18d / decision #19).

**User outcome:** A working mock of the **Judicial Office eLinks People API v5** already exists — written from vendor documentation (`Swagger UI.pdf`, `apiresponses.docx`) and serving the **real production reference-data exports** of 2026-06-01 (Locations 1,999 · BaseLocations 1,461 · AppointmentTitles 193 · JudiciaryRoles 163 · Tickets 158; organisational data only, no personal data — gaps.md **G8.7**), with synthetic people generated deterministically under a fixed seed. This epic **adopts** it as `ctam-joh-mock`: containerised, deployed onto the Epic 0.0 estate, observable, CI-gated, production-refusing, contract-published — and **extends** it with the two things it lacks. Story 0M.1.1 covers adoption and hardening (the production-refusal guards are **currently absent**); Story 0M.1.2 covers the machine-readable OpenAPI spec, a **guaranteed ET cohort**, fixture-identity alignment across all three mocks, and **fault injection** (also currently absent — without it Epic 0.2's failure-path ACs have no mechanism).

**Stack:** **Node 22 LTS + Express 4** — the **single documented exception to AR2–AR17** (**AR55.1**), scoped to language and build tooling only. Container, Helm chart, probes, structured JSON logs with correlation IDs, App Insights ingestion, production-refusal guards, CI gates, SBOM and published contract are all still required. Not precedent for any other repo.

**Depends on:** **Epic 0.A** (`ctam-scaffold.sh`, the Helm/CI/logging conventions and the GitHub-setup runbook — the node formerly called `arch-baseline`, decomposed into stories by SCP 2026-08-18e) and Epic 0.0 (the estate). **Not** Epic 0.B — this mock owns no table in the shared schema and needs no DB role. **Epic 0.1 was dropped as a prerequisite** — the mock's shape now derives from the real contract rather than CTAM's `jo_*` schema, which inverts the information flow (Epic 0.1's schema should be validated *against* this contract). Epic 0.2 still depends on both Epic 0.1 and this epic, so nothing downstream is weakened.

**⚠ This epic carries four findings that contradict the current artifact set** — the API is a **change feed** not a full-refresh dump (contradicts AR46); `REF_Jurisdiction` is **flat** with hierarchy on `locations.parent_id` instead (contradicts D8/G8.1); **ET is a location, not a jurisdiction**, so FR57's `(jurisdiction, region)` key cannot express ET; and there is **no `personnel_number`** field — the contract exposes `per_id`/`personal_code` (contradicts D9). They are **recorded, not actioned** — a follow-up SCP owns the corrections. **Read the epic's *Findings* section before dispatching any story against Epic 0.2, 0.4, 0.5 or 0.7.**

**FRs covered:** none — enablement infrastructure for FR1 and FR6/FR7 tier-(a). **NFRs:** NFR10, NFR14, NFR16, NFR24, NFR25–NFR28, NFR31, NFR39, NFR40, NFR42. **ARs:** **AR55 (revised)**, **AR55.1 (new — the stack exception)**. **Gaps:** G5.3 (widened), **G8.1 (contract now documented; three assumptions falsified; still open)**, **G8.5 (ET legal titles evidenced; lay-member panels still provisional)**, **G8.7 (new — production-export governance)**.

→ [Full epic with stories](epic-0M.1-joh-reference-data-mocked.md)

### Epic 0M.2: Upstream MRD reference data has a contract-shaped mock source (2 stories) — *feeds Epic 0.3*

**User outcome:** The **MRD weekly Excel feed** has a deployable publisher, **`ctam-mrd-mock`**, that generates a workbook in the expected shape from a version-tagged fixture set — whose Specialisations reference the same personnel numbers as the Epic 0M.1 fixtures, so the ingestion's **referential** cleansing checks resolve against JOH data that actually exists — and publishes it into a **configurable** blob container, on demand and on the real weekly `@Scheduled` cadence, in **conformant / per-row-non-conformant / structurally-invalid / cross-sheet-lookup-failure / byte-identical-re-drop** variants, each driving a specific Story 0.3.1 acceptance criterion. Story 0M.2.1 scaffolds the repo with the production-refusal safeguard; Story 0M.2.2 delivers the generator, fixtures, variants, and the published column dictionary.

**Container-target-agnostic by design.** It does **not** provision the MRD drop container — that stays in `ctam-reference-data`'s own `terraform/` (Epic 0.3, Story 0.3.1), because the consumer owns the resource the real MRD team will drop into. The mock targets local **Azurite** in CI, so it is verifiable standalone before that container exists. This is what keeps the dependency graph **acyclic**: the stand-in never depends on the ingestion epic it feeds.

**Depends on:** **Epic 0.A** (scaffold conventions — formerly `arch-baseline`), Epic 0.0 (the estate), Epic 0.1 (the `mrd_*` schema). **Not** Epic 0.B (owns no table). Deliberately **not** Epic 0.3.

**FRs covered:** none — enablement infrastructure for FR6/FR7 tier-(a). **NFRs:** NFR10, NFR16, NFR24, NFR25–NFR28, NFR31, NFR39, NFR40, NFR42. **ARs:** **AR56**. **Gaps:** G5.3 (widened), G8.1 (de-risked, not closed), G8.5 (ET vocabulary provisional).

→ [Full epic with stories](epic-0M.2-mrd-reference-data-mocked.md)

## Phase 0-Mock Stories Summary

| Epic | Stories | FRs covered | Demo |
|---|---|---|---|
| 0M.1 | 2 stories (0M.1.1–0M.1.2) | none (enablement); NFR14, NFR16, NFR24, NFR39 | The adopted eLinks v5 mock deployed on the Epic 0.0 estate and **refusing to start** when the environment indicates production; its logs and correlation IDs landing in the shared App Insights workspace; the published OpenAPI spec served with *evidenced* / *inferred* field markers; a **documented ET cohort** reachable through the change, leavers and deleted feeds; each fault mode reproduced on demand and the Epic 0.2 sync's failure paths shown passing against it |
| 0M.2 | 2 stories (0M.2.1–0M.2.2) | none (enablement); NFR16, NFR24, NFR39 | `ctam-mrd-mock` deployed and refusing the `production` profile; a conformant workbook published into Azurite and consumed end-to-end; the structurally-invalid, per-row-quarantine and re-drop variants each shown driving the Epic 0.3 rejection / quarantine / idempotency paths |
| **Total** | **4 stories** | | Both demos immediately precede the ingestion epic that consumes them, so the Phase 0 walkthrough shows each upstream stand-in and then the ingestion working against it |

## Position in the build order

The dispatch graph is verified acyclic. Because both Phase 0-Mock epics share the same prerequisites, the build order is a **partial** order, not a single line — `{ }` marks work that can run in parallel:

```
epic-0.A → epic-0.0 → epic-0.B → epic-0.1 → { epic-0M.1, epic-0M.2, epic-0.8 }
                                          │           │
                                          ▼           ▼
                                      epic-0.2 → epic-0.3 → epic-0.4
                                          → epic-0.5 → epic-0.6 → epic-0.7
```

Both Phase 0-Mock epics become dispatchable **as soon as Epic 0.1 is `done`** — they do not wait on each other. Epic 0M.1 gates Epic 0.2; Epic 0M.2 gates Epic 0.3. Both are parallelisable with each other and with Epic 0.8. Any linearization respecting those edges is valid; do not read a single arrow sequence as *the* order.

## Validation

Phase 0-Mock is assessed as part of the **ET-cohort implementation-readiness assessment**[^d13] alongside Phase 0. Its specific readiness question is not "do the mocks work" but **"is every inferred field annotated, and is the diff protocol in place"** — because the risk this phase carries is **mock-reality divergence**: a stand-in that encodes a wrong assumption can make a broken integration look finished.

Since 2026-08-18 that risk is **asymmetric across the two epics**, and readiness should treat them differently. `ctam-joh-mock` is built against documented vendor material, so its residual risk is narrow and specific — cadence/SLA, `updated_since` behaviour under load, real pagination at scale, and the handful of fields marked *inferred*. `ctam-mrd-mock` is still built against CTAM's own guess at a workbook nobody has sent, so its residual risk is broad. A readiness assessment that scores them the same is mis-reporting.

A second, newer risk belongs here too: **`ctam-joh-mock` has now produced evidence that contradicts four load-bearing statements elsewhere in the artifact set** (findings F1–F4). Until the follow-up SCP lands, the artifacts and the evidence disagree — and readiness must track that the corrections are outstanding rather than treating the findings as closed by having been written down.

[^d13]: D13 (2026-08-07, supersedes D11) — ET-first pilot: wave 1 = the **Employment Tribunals (ET)** jurisdiction (scheduling incumbent `[ET-INCUMBENT-TBD]` — unidentified, gap G8.4); wave 2 = **SSCS** (replaces **ListAssist**; **GAPS**, SSCS case management, is retained); waves 3+ = Courts jurisdictions per HMCTS judicial region (replacing JI/APEX).
