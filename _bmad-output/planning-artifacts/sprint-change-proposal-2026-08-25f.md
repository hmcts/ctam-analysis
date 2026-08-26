---
type: 'Sprint Change Proposal'
description: 'Epic 0.2 (JOH eLinks mock API) no longer deploys to any shared dev/staging environment. ctam-jomockapi runs locally via Docker Compose only, alongside a locally-run ctam-reference-data. depends_on drops to [] since the estate was its only real dependency.'
resource: 'sprint-change-proposal-2026-08-25f.html'
tags: [ctam-pathfinder, sprint-change-proposal]
timestamp: '2026-08-25'
title: 'Sprint Change Proposal — 2026-08-25f'
status: 'approved'
---

# Sprint Change Proposal — 2026-08-25f

**Trigger:** *"we are deploying the service in local environment remove the dependency on 0.0"*, following a `/bmad-help` exchange about why Epic 0.2 depends on Epic 0.0.

**Mode:** Batch. **Scope classification:** **Moderate** — a deployment-target narrowing within one epic, not a functional cut.

---

## 1. Issue Summary

Epic 0.2 (`ctam-jomockapi`, the JOH eLinks mock API) previously deployed to the shared dev/staging Azure estate (AKS, ACR, Key Vault, APIM) so that `ctam-reference-data`'s eLinks sync could reach it over the network in a shared environment — this was the epic's entire reason for `depends_on: [epic-0.0]`. The team is instead running these services locally during development. Since the mock is never deployed anywhere but a developer's machine in this scope, the shared-estate dependency is not just unnecessary — it doesn't correspond to anything the epic actually does anymore, so it's removed.

## 2. Impact Analysis

### What changed

- **Epic 0.2** — `depends_on` drops from `[epic-0.0]` to `[]`. Story 0.2.2 rewritten from "Deploy `ctam-jomockapi` onto the shared dev/staging estate" (Helm chart, AKS, Key Vault-held credential) to "Run `ctam-jomockapi` locally via Docker Compose" (a `docker-compose.yml` service, a local `.env` credential). Story 0.2.3 rewritten from "...runs against the deployed mock in dev/staging" to "...runs against the locally-running mock" — the demonstrability claim narrows from "dev/staging" to "local development." Story 0.2.1 (onboarding) is adjusted to drop the ACR registry push and any Helm/deploy-workflow scaffolding, since nothing in this epic deploys anywhere shared.
- **Epic 0.3** — Story 0.3.3's AC block that pointed the sync's "dev/staging base URL" at Epic 0.2's deployed mock is reworded to point the sync's *local* base URL at the locally-running mock instead.
- **NFR16 (Key Vault), NFR31 (Azure UK South), NFR40 (per-service deployable)** — no longer exercised by Epic 0.2 at all (nothing is deployed to the shared estate from this epic). **NFR24**'s "exercised end-to-end pre-contract" claim narrows from a dev/staging demonstration to a local-only one.
- **gaps.md G8.1** and **non-functional-requirements-coverage.md's NFR24 entry** — reworded to say the mock unblock is local, not dev/staging. G8.1 itself (the real eLinks contract confirmation) stays open regardless — unaffected by where the mock runs.

### Artifact sweep

| Artifact | Change |
|---|---|
| `epic-0.2-joh-elinks-mock-api-stands-in.md` | `depends_on` → `[]`; scope-reduction note added; Hosting/vertical-slice/out-of-scope reworded; Story 0.2.1 (registry push dropped), 0.2.2 (full rewrite to Docker Compose), 0.2.3 (full rewrite to "locally-running mock") |
| `epic-0.3-joh-reference-data-etl-process.md` | Story 0.3.3's mock-target AC reworded from dev/staging to local |
| `epics/phase-0/index.md` | Epic 0.2 summary, sequencing note, Phase 0 Epic Stories Summary table rows for 0.2 and 0.3 |
| `epics/framework.md` | Ingestion area note (Epic 0.2's mock target reworded) |
| `epics/fr-coverage-map.md` | NFR24 row |
| `architecture/gaps.md` | G8.1 |
| `architecture/non-functional-requirements-coverage.md` | NFR24 entry |
| `architecture/repository-strategy.md` | `ctam-jomockapi` row |
| `architecture/assumptions.md` | A38 |
| `architecture/delivery-operating-model.md` | Parallelism illustration (Epic 0.2 has no epic dependency, not "needs only the estate") |
| `architecture.md` | New decision **#19** |
| `architecture/changelog.md` | New **v4.16** entry |
| `sprint-status.yaml` | Epic 0.2's Story 0.2.2/0.2.3 slugs renamed to match the rewritten titles |

**Not touched:** dated historical SCPs/changelog entries and decision-log rows (immutable record); Epic 0.0, 0.1, 0.4 (unaffected — this change is scoped to Epic 0.2 and the one cross-reference in Epic 0.3).

## 3. Recommended Approach

**Direct implementation.** Effort: **Low-Medium** (one epic's deployment model changes, with a small ripple into Epic 0.3's one AC block and several NFR/gap cross-references). **Risk:** Low — nothing was `done` on this epic yet (`epic-0.2: backlog`), so no completed work is disrupted; the real eLinks contract gap (G8.1) is explicitly unaffected.

## 4. Detailed Change Proposals

See §2 for the full before/after mapping. Full diffs are in the files themselves.

## 5. Implementation Handoff

**Scope: Moderate** — one epic's deployment target changes, with cross-references updated to match; not a functional cut.

**Responsibilities:**
- **Product Owner / stakeholders:** confirm local-only is acceptable for Phase 0's demoability goal for this integration — if a shared dev/staging demonstration is later needed, a future epic can add it back (Epic 0.2's out-of-scope note says so explicitly).
- **This session:** all edits above applied directly; nothing committed without being asked.

**Success criteria:** Epic 0.2's `depends_on` is `[]` and every AC in its 3 stories consistently describes a local Docker Compose flow, not a shared-estate deployment; Epic 0.3's Story 0.3.3 cross-reference matches; no remaining "dev/staging" claim tied to this mock anywhere in the sweep list above; `docs/` regenerates cleanly.
