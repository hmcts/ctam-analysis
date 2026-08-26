---
type: 'Sprint Change Proposal'
description: '3 Sprint Change Proposals from 2026-08-24, consolidated into one file per day. JOH eLinks API contract remains unconfirmed (gaps.md G8.1) but a schema-faithful mock — ctam-jomockapi — already exists; adds Epic 0.7 to onboard, deploy, and wire it in as the Phase 0 dev/staging stand-in for the JOH eLinks API.'
resource: 'sprint-change-proposal-2026-08-24.html'
tags: [ctam-pathfinder, sprint-change-proposal]
timestamp: '2026-08-24'
title: 'Sprint Change Proposal — 2026-08-24'
---

# Sprint Change Proposal — 2026-08-24

This file consolidates **3 Sprint Change Proposals** made on **2026-08-24** into one file (previously separate files: `sprint-change-proposal-2026-08-24.md#sprint-change-proposal-2026-08-24`, `sprint-change-proposal-2026-08-24.md#sprint-change-proposal-2026-08-24b`, `sprint-change-proposal-2026-08-24.md#sprint-change-proposal-2026-08-24c`). Each entry below is preserved verbatim from its original file — only frontmatter, heading levels, and the file boundary changed.

## Index

- [Sprint Change Proposal — 2026-08-24](#sprint-change-proposal-2026-08-24)
- [Sprint Change Proposal — 2026-08-24b](#sprint-change-proposal-2026-08-24b)
- [Sprint Change Proposal — 2026-08-24c](#sprint-change-proposal-2026-08-24c)

---

## Sprint Change Proposal — 2026-08-24

**Status:** approved

**Trigger:** *"We don't have real APIs to consume the data from JOH. We are building a mock API with mock data for consumption."* — evidenced by `/Users/shivakumar/MOJ/ctam-jomockapi`, an already-implemented Node/Express mock of the **Judiciary "E-links" People API v5**, built directly from the real `Swagger UI.pdf` + `apiresponses.docx` and populated from the real `ReferenceData/*.csv|json` exports.

**Mode:** Batch. **Scope classification:** Moderate (backlog reorganisation — new epic + story amendment + architecture-shard updates; no PRD/MVP change).

---

### 1. Issue Summary

Phase 0's foundational data layer (Epic 0.1, `ctam-reference-data`) is built on an **unconfirmed external dependency**: the JOH eLinks API contract (gaps.md **G8.1**, business-case.md risk #1, "Med/High"). The existing mitigation on record is thin — Story 0.1.3's AC and the 2026-06-17 implementation-readiness report both point to *"the sync code path is integration-tested against a WireMock/stub eLinks API in CI"* (AR52-referenced). That mitigation is CI-test-only: it proves the sync *code path* compiles and runs against a canned response, but nothing in the current plan lets the real `@Scheduled` nightly sync job run **end-to-end against a live network endpoint** in dev or staging, and nothing gives Phase 0 a demoable ingestion walkthrough before the real eLinks contract lands.

That gap has now been closed by work already done outside this repo: `ctam-jomockapi` is a complete, runnable mock service — not a test fixture — covering the full documented eLinks v5 contract (auth-token behaviour, `/people` change-feed with `updated_since`/pagination, `/leavers`, `/deleted`, and all 11 `/reference_data/:attribute_name` vocabularies), seeded with 100 realistic JOH profiles joined against the **real** production reference-data exports (2000 locations, 1462 base locations, 194 appointment titles, 164 judiciary roles, 159 tickets, 54 ticket categories, etc.), with a fixed random seed for stable ids across restarts.

**This is a legitimate correct-course trigger, not a scope change:** it doesn't alter any FR/NFR, PRD goal, or the eventual need to confirm the real eLinks contract (G8.1 stays open). It upgrades the *interim substitute* for that contract from "CI-only WireMock stub" to "a deployed, schema-faithful mock service" — which was already the plan's own stated mitigation pattern (business-case.md: *"Build against a WireMock stub now; contract gates production cutover only"*), just not yet reflected as a repo, an epic, or a deployment target in the tracked artifacts.

### 2. Impact Analysis

#### Epic impact

- **Epic 0.1** (`epics/phase-0/epic-0.1-upstream-reference-data-ingested.md`) is **not invalidated** — it proceeds as planned. **Story 0.1.3** gains one new AC block: the dev/staging nightly sync points at the deployed `ctam-jomockapi` endpoint (config-driven base URL + Key-Vault-held bearer token, mirroring the real eLinks credential wiring per NFR16) rather than `localhost`; the existing CI WireMock stub (AR52) is retained for pure unit/integration tests — the two are complementary, not a replacement of one by the other.
- **New Epic 0.7** is added: *"JOH eLinks mock API stands in for the unconfirmed upstream contract."* It onboards `ctam-jomockapi` as a CTAM Pathfinder repo, deploys it onto the shared estate (Epic 0.0), and hands `ctam-reference-data` a live URL to sync against. It is **not numbered 0.1a / inserted mid-sequence** — following the Epic 0.6 precedent ("the number is not the order"; see `depends_on`), it runs in parallel with / shortly after Epic 0.0 and ahead of Story 0.1.3's dev-verification AC.
- No other Phase 0 epic (0.0, 0.2–0.6) changes. No Phase 1–8 epic is affected (none exist yet beyond framework-level prose).

#### Story impact

- **Story 0.1.3** — amended AC (see §4).
- **New Stories 0.7.1–0.7.3** — repo onboarding, dev/staging deployment, and the wiring-in of Story 0.1.3's sync against it.

#### Artifact conflicts / updates needed

| Artifact | Conflict | Change |
|---|---|---|
| `architecture/repository-strategy.md` | States "16 repos total"; `ctam-jomockapi` isn't listed | Add repo row; 16 → 17 |
| `architecture/gaps.md` (G8.1) | Silent on the mock's existence | Append dated note: mock unblocks *dev*, contract confirmation still gates *production* |
| `architecture/assumptions.md` | No assumption records the mock | Add **A38**, mirroring the `ctam-mock-auth` precedent (A26/A27: non-prod only, contract parity claim scoped) |
| `architecture.md` (decision log) | No record of this decision | Add **decision #14** |
| `architecture/changelog.md` | No entry | Add **v4.9** |
| `epics/framework.md` (Phase 0 · Area: Reference Data) | Ingestion narrative doesn't mention a dev/staging network target | One-sentence addition |
| `epics/fr-coverage-map.md` / `architecture/non-functional-requirements-coverage.md` (NFR24) | Coverage row doesn't cite Epic 0.7 | Add cross-reference |
| `epics/phase-0/index.md` | Epic table, summaries, story counts (19 → 22) | Add Epic 0.7 row + summary |
| `epics/phase-0/epic-0.1-...md` | `depends_on` frontmatter unchanged; Story 0.1.3 AC | Add AC block; no `depends_on` change (see below) |
| `CLAUDE.md` | "16-repo polyrepo" repo list | 16 → 17; add `ctam-jomockapi` |
| `_bmad-output/implementation-artifacts/sprint-status.yaml` | No epic-0.7 entries | Add epic-0.7 + 3 stories, `backlog` |
| `docs/*.html` | Generated from the above | Regenerate via `scripts/build-html.sh` after all edits land |

**No PRD, UX, or FR/NFR change.** No change to `data-tables.md` (no new persisted table — the mock is external infrastructure, not a CTAM-owned schema) or to `conventions.md` (the deviation is scoped and justified inline, not a house-wide rule change).

**On `depends_on`:** Epic 0.1's frontmatter is **left unchanged** (`[epic-0.0, epic-0.6]`). Making the whole of Epic 0.1 depend on Epic 0.7 would block Stories 0.1.1 (scaffold) and 0.1.2 (tier-(a) tables) on a repo-onboarding epic they don't need — `depends_on` in this codebase is epic-granularity only (`scripts/dispatch-preflight.sh` gates the *whole* epic on it), so a hard dependency here would be needlessly coarse. Story 0.1.3's new AC instead carries the sequencing note inline — the same pattern already used for its existing G8.1/AR52 callouts. Epic 0.7 itself depends only on `epic-0.0` (needs the shared estate to deploy onto).

#### Technical impact

- `ctam-jomockapi` is Node.js/Express — a **deliberate, explicitly-scoped deviation** from the Java 25/Spring Boot 4 stack baseline in `_bmad-output/project-context.md`. Justification: it delivers no FR/NFR, is never deployed to production, and is not a CTAM Pathfinder domain service — the same category of exception the repository strategy already grants `ctam-mock-auth` (non-prod-only, contract-parity tooling, distinct lifecycle from the 15 production/UI repos). It is **not** rewritten in Java; the existing implementation is onboarded as-is.
- Deploying it onto the shared AKS estate needs: a minimal Helm chart, a Key-Vault-held mock bearer credential (the mock accepts any non-empty token — Key Vault storage is for wiring-realism/parity with the real eLinks credential path, not because the mock enforces anything), and a `values-{env}.yaml` exposing its base URL to `ctam-reference-data`'s config.
- No database, no Liquibase, no tier-ownership — the mock generates its dataset in-memory at startup with a fixed seed; nothing to migrate or grant.

### 3. Recommended Approach

**Selected: Option 1 — Direct Adjustment** (new epic + one story's AC amended within the existing Phase 0 structure).

- **Option 2 (rollback)** — not viable/not applicable: no Epic 0.1 stories are built yet (all `backlog` in `sprint-status.yaml`); there is nothing to roll back.
- **Option 3 (MVP review)** — not needed: no FR/NFR/PRD goal is affected; this closes an execution risk the plan already flagged (business-case.md risk #1), it doesn't reopen it.
- **Option 1** fits cleanly: the architecture already has a precedent shape for exactly this kind of repo (`ctam-mock-auth` — non-prod mock, own epic-adjacent story, deployed onto the shared estate, explicit "never production" guard). Epic 0.7 reuses that shape for the JOH eLinks side.

**Effort:** Low–Medium. Three small stories (repo onboarding, Helm/deploy, wiring), no new production code path, no schema change. **Risk:** Low. The mock is additive infrastructure; if it were deleted tomorrow, Story 0.1.3 falls back to exactly today's plan (CI WireMock stub + real contract when it lands). **Timeline impact:** Positive — it *de-risks* Epic 0.1's dev/staging demo readiness ahead of the ET-cohort implementation-readiness assessment, rather than adding to the critical path (Epic 0.7 can run alongside Epic 0.0/0.6).

### 4. Detailed Change Proposals

#### 4.1 New file — `epics/phase-0/epic-0.7-joh-elinks-mock-api-stands-in.md`

```markdown
---
type: 'Epic'
description: 'User outcome: ctam-reference-data'"'"'s nightly eLinks sync runs end-to-end against a deployed, schema-faithful mock of the JOH eLinks People API v5, so Phase 0 has a demoable ingestion pipeline in dev/staging before the real eLinks contract (gaps.md G8.1) is confirmed.'
resource: 'epics/phase-0/epic-0.7-joh-elinks-mock-api-stands-in.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-24'
parent: 'epics/phase-0/index.md'
epic: 0.7
title: 'JOH eLinks mock API stands in for the unconfirmed upstream contract'
storyCount: 3
repo: ctam-jomockapi
depends_on: [epic-0.0]
---

# Epic 0.7: JOH eLinks mock API stands in for the unconfirmed upstream contract

**User outcome:** `ctam-reference-data`'s nightly JOH eLinks sync (Story 0.1.3) runs **end-to-end against a live, deployed mock** of the eLinks People API v5 — not just a CI-only WireMock stub — so Phase 0 has a genuine, demoable ingestion pipeline in dev/staging while the real eLinks API contract remains unconfirmed (gaps.md G8.1). `ctam-jomockapi` is onboarded as CTAM Pathfinder's 17th repo, non-production-only, in the same category as `ctam-mock-auth` (repository-strategy.md).

**Hosting:** `ctam-jomockapi` is a standalone Node.js/Express service — an explicitly-scoped deviation from the Java/Spring Boot stack baseline (see gaps.md / assumptions.md A38), justified because it delivers no FR/NFR and never deploys to production. It deploys onto the shared estate provisioned in Epic 0.0, alongside `ctam-mock-auth`.

**Vertical slice:**
- Onboard the existing `ctam-jomockapi` codebase as a CTAM Pathfinder GitHub repo, per the manual GitHub-setup runbook (D10 — no `gh` CLI)
- CI: run its existing test suite (`npm test`), build + push a container image to ACR
- A minimal Helm chart deploying it to dev/staging AKS, fronted by the shared APIM gateway
- A Key-Vault-held mock bearer credential, wired the same way the real eLinks credential will be (NFR16) — the mock itself accepts any non-empty token, so this exercises the *wiring*, not an auth check
- `ctam-reference-data`'s eLinks sync (Story 0.1.3) points its dev/staging base URL at the deployed mock instead of `localhost`

**FRs covered:** none directly (infrastructure/tooling, not a product feature). **Supports:** FR1, FR6 tier-(a), FR7 tier-(a), NFR24 (exercised end-to-end pre-contract).

**Key NFRs first exercised here:** NFR16 (Key Vault credential wiring, dev/staging), NFR31 (Azure UK South), NFR40 (per-service deployable).

**Out of scope (explicitly):**
- The real JOH eLinks API contract (gaps.md G8.1 remains open until Judicial Office confirms it; production cutover is gated on that, not on this epic)
- MRD ingestion (Story 0.1.4) — the mock covers eLinks only, not MRD's Excel feed
- Rewriting `ctam-jomockapi` in Java/Spring — it stays Node/Express as already built
- Production deployment of `ctam-jomockapi` — never (same guard as `ctam-mock-auth`, A27-equivalent)

---

## Story 0.7.1: Onboard `ctam-jomockapi` as a CTAM Pathfinder repo

As a **platform engineer**,
I want the existing `ctam-jomockapi` codebase onboarded as a CTAM Pathfinder GitHub repo with CI wired to its existing test suite,
So that **the mock is a tracked, reviewable, CI-gated artifact like every other repo in the polyrepo**, not an out-of-band local tool.

**Acceptance Criteria:**

**Given** the engineer has performed the GitHub manual-setup checklist (`ctam-architecture/runbooks/github-setup.md`),
**When** `ctam-jomockapi`'s existing code (README, `server.js`, `src/`, `test/`, `package.json`, `ReferenceData/*.csv|json`, `Swagger UI.pdf`, `apiresponses.docx`) is pushed to a new private repo under the HMCTS org via a feature branch and PR (no `gh` CLI, per D10),
**Then** branch protection on `main` is enabled (require PR review, require status checks, require linear history),
**And** `.github/workflows/ci.yml` runs `npm install && npm test` plus a container build (`docker build`),
**And** `CODEOWNERS` and `PULL_REQUEST_TEMPLATE.md` exist per CTAM convention.

**Given** the onboarded repo,
**When** a CI run completes on the PR,
**Then** the existing test suite (`test/`) passes,
**And** the container image builds and is pushed to ACR on merge to `main`.

**Given** this is a non-production-only mock,
**When** the Helm values / CI workflow are authored,
**Then** there is **no** `deploy-production.yml` and **no** production Helm values file — mirroring `ctam-mock-auth`'s "never deployed to production" guard.

**References:** repository-strategy.md (new row); D10; **depends on Epic 0.0** is NOT required for this story (no deployment yet — Story 0.7.2 needs the estate).

**Explicitly NOT in scope:**
- Deployment to any environment — Story 0.7.2
- Any change to the mock's existing endpoint behaviour, seeded data, or auth handling

---

## Story 0.7.2: Deploy `ctam-jomockapi` onto the shared dev/staging estate

As a **platform engineer**,
I want `ctam-jomockapi` deployed onto the shared Azure estate (Epic 0.0) in dev and staging, with its mock bearer credential held in Key Vault,
So that **it is reachable over the network by `ctam-reference-data`'s scheduled sync job**, not just runnable locally via `npm start`.

**Acceptance Criteria:**

**Given** `ctam-jomockapi` is onboarded per Story 0.7.1, and the shared estate (AKS, ACR, Key Vault, APIM) is provisioned and verified per Epic 0.0,
**When** a Helm chart (`charts/ctam-jomockapi/` with `values-dev.yaml` / `values-staging.yaml`) is deployed,
**Then** the service runs as a pod in the dev AKS cluster, reachable at a stable in-cluster/APIM-fronted URL,
**And** liveness/readiness probes pass against `GET /api/v5/healthcheck` (public, no auth, per the mock's existing contract),
**And** the deployed pod's logs confirm the mock data was generated with the documented fixed seed (ids stable across restarts).

**Given** the mock requires a bearer token (any non-empty value, per its existing auth behaviour),
**When** a mock credential is provisioned in the shared Key Vault (namespaced to `ctam-jomockapi`, separate from the real eLinks credential slot reserved for `ctam-reference-data`),
**Then** the credential round-trips from a pod via workload identity (same pattern as Epic 0.0's Key Vault verification),
**And** no production Key Vault namespace or profile is created for this credential (non-prod only).

**Given** the deployed mock,
**When** an engineer curls `GET /api/v5/reference_data/jurisdictions` with the Key-Vault-sourced token from within the dev cluster,
**Then** the response matches the documented `ReferenceDataResponse` shape and returns the real jurisdiction reference values.

**References:** NFR16 (Key Vault), NFR31 (UK South), NFR40 (per-service deployable); depends on Epic 0.0.

**Explicitly NOT in scope:**
- Wiring `ctam-reference-data`'s sync to this URL — Story 0.7.3
- Production deployment — never, per this epic's out-of-scope note

---

## Story 0.7.3: `ctam-reference-data`'s eLinks sync runs against the deployed mock in dev/staging

As a **CTAM Pathfinder platform** (and every downstream consumer of JOH identity and reference data),
I want Story 0.1.3's nightly `@Scheduled` eLinks sync to run, in dev and staging, against the `ctam-jomockapi` URL deployed in Story 0.7.2,
So that **the full ingestion pipeline — full-refresh-upsert, `ctam_joh_identities` minting, soft-deactivation of records absent upstream, `ctam_sync_status` logging — is demoable end-to-end before the real eLinks contract (G8.1) is confirmed.**

**Acceptance Criteria:**

**Given** `ctam-jomockapi` is deployed per Story 0.7.2, and the Key Vault credential is available to `ctam-reference-data`'s pod,
**When** `ctam-reference-data`'s dev/staging configuration sets the eLinks base URL to the deployed mock's URL instead of any placeholder/localhost value,
**Then** the nightly (and manually-triggered) sync run in Story 0.1.3 completes successfully against it,
**And** all 15 `jo_*` tables populate from the mock's `/people` change-feed and `/reference_data/*` responses,
**And** `jo_people.personnel_number` upserts correctly and mints `ctam_joh_identities` rows exactly as designed for a real upstream source.

**Given** the mock's `/leavers` and `/deleted` endpoints (100 records each, independent of the 100 `/people` profiles),
**When** the sync's soft-deactivation logic (rows absent upstream marked inactive, never hard-deleted, per AR46) is exercised against them,
**Then** the behaviour is verified against realistic leaver/deleted data — something the CI WireMock stub's canned fixtures don't exercise as thoroughly.

**Given** the CI-only WireMock/stub eLinks API (AR52) used by `ctam-reference-data`'s automated tests,
**When** this story lands,
**Then** the WireMock stub is **retained unchanged** for unit/integration tests — it and the deployed `ctam-jomockapi` are complementary (fast, hermetic CI checks vs. a realistic dev/staging network target), not a replacement of one by the other.

**Given** the real JOH eLinks API contract is still unconfirmed (gaps.md G8.1),
**When** this story's ACs are met,
**Then** G8.1 is **not** closed by this story — it remains open until Judicial Office confirms the real contract and it is validated against the (by-then-live) ingestion mapping; this story closes the *dev/staging demonstrability* gap only, not the *contract-confirmation* gap.

**References:** FR1, FR6 tier-(a), NFR24; gaps.md G8.1 (stays open); AR46, AR48, AR52; depends on Story 0.1.3 and Story 0.7.2.

**Explicitly NOT in scope:**
- Closing G8.1 — that needs the real contract from Judicial Office
- MRD ingestion (Story 0.1.4) — unaffected, no mock exists or is needed for MRD in this SCP
```

#### 4.2 `epics/phase-0/epic-0.1-upstream-reference-data-ingested.md` — Story 0.1.3 amendment

**OLD** (Story 0.1.3, third `Given/When/Then` block):
```
**Given** the sync has run successfully at least once in dev,
**When** `ctam-authorisation` (Epic 0.2, Story 0.2.3) looks up a seeded JOH email,
**Then** the lookup resolves against `jo_people` to a `personnel_number`, and via `ctam_joh_identities` to the CTAM JOH UUID,
**And** dev/CI environments use seeded `jo_*` fixtures loaded by the one-off seed scripts where a live eLinks connection is unavailable (per AR52 — the sync code path is integration-tested against a WireMock/stub eLinks API in CI).
```

**NEW** (adds a sentence + a new block immediately after):
```
**Given** the sync has run successfully at least once in dev,
**When** `ctam-authorisation` (Epic 0.2, Story 0.2.3) looks up a seeded JOH email,
**Then** the lookup resolves against `jo_people` to a `personnel_number`, and via `ctam_joh_identities` to the CTAM JOH UUID,
**And** dev/CI environments use seeded `jo_*` fixtures loaded by the one-off seed scripts where a live eLinks connection is unavailable (per AR52 — the sync code path is integration-tested against a WireMock/stub eLinks API in CI).

**Given** the JOH eLinks mock API (`ctam-jomockapi`, Epic 0.7) is deployed to dev/staging,
**When** the sync's dev/staging base URL is configured to point at it,
**Then** the nightly sync runs end-to-end against a live network endpoint modelling the real eLinks contract — not just the CI WireMock stub — giving Phase 0 a demoable ingestion pipeline ahead of the real contract landing (per Epic 0.7, Story 0.7.3).
```

**References line** — append `; Epic 0.7` after `gaps.md G8.1`.

#### 4.3 `architecture/repository-strategy.md`

- Line 1 decision statement: `11 service repos + 1 mock-auth repo + 1 JOH-mock repo + 2 UI repos (business + admin) + 1 architecture/scaffolding repo.` (frontmatter `description` and body).
- New table row, inserted after `ctam-mock-auth`:

  | Repo | Phase | Purpose | Key Functions |
  |---|---|---|---|
  | **`ctam-jomockapi`** | 0 | Node.js/Express mock of the **JOH eLinks People API v5**, standing in for the unconfirmed upstream contract (gaps.md G8.1). **Never deployed to production.** | Serve the documented eLinks v5 contract (people change-feed, leavers, deleted, 11 reference-data vocabularies) from realistic seeded data joined against real production reference-data exports; give `ctam-reference-data`'s dev/staging eLinks sync a live network target (Epic 0.7). |

- Closing summary line: `**16 repos total**` → `**17 repos total** (11 production services + 2 UI + architecture + mock-auth + JOH-mock + shared-infrastructure). ... \`ctam-jomockapi\` is dev/staging/CI-only and never deploys to production, in the same category as \`ctam-mock-auth\`.`

#### 4.4 `architecture/gaps.md` — G8.1 (append, don't rewrite the row)

Append to the end of the G8.1 **Detail** cell:

> **Mock unblock added 2026-08-24 (SCP 2026-08-24):** a schema-faithful mock of the eLinks People API v5 (`ctam-jomockapi`, built directly from the real Swagger doc + example-response docs, seeded from real reference-data exports) is now deployed to dev/staging (Epic 0.7) so Phase 0's ingestion pipeline is demoable end-to-end without waiting on this gap. **This does not close G8.1** — the mock is built from documentation, not a confirmed live contract, and production cutover still requires the real contract to be confirmed and the ingestion mapping validated against it.

#### 4.5 `architecture/assumptions.md`

New row (title becomes "Assumptions (A1–A38)"):

| **A38** *(new 2026-08-24, SCP 2026-08-24)* | `ctam-jomockapi` provides a schema-faithful mock of the JOH eLinks People API v5 (built from the real Swagger doc + `apiresponses.docx`, seeded from real reference-data exports) for Phase 0 dev/staging/CI consumption. It is **not** a confirmation of the real contract — mirrors A26/A27's mock-auth pattern: non-production only, contract-parity claim is scoped to what the public docs describe, and real-contract confirmation (G8.1) still gates production cutover. | Load-bearing **for Phase 0 dev/staging demonstrability only** | Epic 0.7 deliverable; enforced by CI/deploy guard (no production Helm values, per Story 0.7.1) |

#### 4.6 `architecture.md` — decision log

New row after #13:

| # | TBD | Resolution |
|---|---|---|
| 14 | Interim substitute for the unconfirmed JOH eLinks contract *(SCP 2026-08-24)* | **A deployed, schema-faithful mock — `ctam-jomockapi` (17 repos total)** — replaces "CI-only WireMock stub" as Phase 0's dev/staging demonstrability story, without closing G8.1. Onboarded as a new Epic 0.7, in the same non-production-only category as `ctam-mock-auth` (repository-strategy.md). Story 0.1.3 gains one AC block pointing its dev/staging sync target at the deployed mock; the existing CI WireMock stub is retained unchanged. See [`./sprint-change-proposal-2026-08-24.md#sprint-change-proposal-2026-08-24`](./sprint-change-proposal-2026-08-24.md#sprint-change-proposal-2026-08-24). |

#### 4.7 `architecture/changelog.md`

New version row:

| **v4.9 — JOH eLinks mock API (`ctam-jomockapi`) onboarded as Epic 0.7** | 2026-08-24 | **Additive, no FR/NFR/PRD change.** Adds a 17th repo, `ctam-jomockapi` (Node/Express, non-production-only — same category as `ctam-mock-auth`), giving `ctam-reference-data`'s eLinks sync (Story 0.1.3) a deployed, schema-faithful dev/staging network target while the real eLinks contract (G8.1) remains unconfirmed. G8.1 is **not closed** by this change. See [`../sprint-change-proposal-2026-08-24.md#sprint-change-proposal-2026-08-24`](../sprint-change-proposal-2026-08-24.md#sprint-change-proposal-2026-08-24). | `repository-strategy.md`, `gaps.md` (G8.1), `assumptions.md` (A38), decision log (#14), `epics/phase-0/epic-0.1-...md` (Story 0.1.3), new `epics/phase-0/epic-0.7-...md` |

#### 4.8 `epics/framework.md` — Phase 0 · Area: Reference Data

Append one sentence to the existing "Ingestion" paragraph: *"A deployed, schema-faithful mock of the eLinks API (`ctam-jomockapi`, Epic 0.7) gives the dev/staging sync a live network target while the real contract (gaps.md G8.1) remains unconfirmed."*

#### 4.9 `epics/fr-coverage-map.md` and `architecture/non-functional-requirements-coverage.md` (NFR24)

Append `; dev/staging demonstrability via Epic 0.7's deployed mock ahead of the real contract` to the existing NFR24 rows in both files.

#### 4.10 `epics/phase-0/index.md`

- Epic table: add a row `| [0.7](epic-0.7-joh-elinks-mock-api-stands-in.md) | JOH eLinks mock API stands in for the unconfirmed upstream contract | 3 | 🟡 Planned |`; **Total** stories 21 → 24.
- Add an "### Epic 0.7: ..." summary paragraph (mirrors the Epic 0.6 "runs between 0.0 and 0.1 — the number is not the order" framing).
- Phase 0 Epic Stories Summary table: add a `0.7` row (3 stories); **Total** 19 → 22 stories; update the 0.1 row's demo note to mention the deployed mock.

#### 4.11 `CLAUDE.md`

- "ships as a **16-repo polyrepo**" → "**17-repo polyrepo**"; add `ctam-jomockapi` to the parenthetical repo list (after `ctam-mock-auth`, before `ctam-reference-data`, matching the phase-0 grouping used elsewhere).

#### 4.12 `_bmad-output/implementation-artifacts/sprint-status.yaml`

Append after the `epic-0.6` block:

```yaml
  epic-0.7: backlog
  0-7-1-onboard-ctam-jomockapi-as-a-ctam-pathfinder-repo: backlog
  0-7-2-deploy-ctam-jomockapi-onto-the-shared-dev-staging-estate: backlog
  0-7-3-ctam-reference-data-s-elinks-sync-runs-against-the-deployed-mock-in-dev-staging: backlog
  epic-0.7-retrospective: optional
```

#### 4.13 Regenerate the site

Run `scripts/build-html.sh` after all markdown edits land (hard rule — `docs/*.html` is generated, never hand-edited).

### 5. Implementation Handoff

**Scope: Moderate** — backlog reorganisation (one new epic + one story's AC amended) plus a coordinated sweep across architecture shards that reference the repo count, G8.1, and the assumptions/decision/changelog ledgers. No PRD rewrite, no FR/NFR change, no re-plan of programme goals — routed as **Product Owner / Developer**, not Product Manager / Architect.

**Responsibilities:**
- **This session (Developer agent role)**: apply all edits in §4 directly (they're additive, mechanical, and don't touch `main` per the protected-branch hook — all writes are to tracked planning-artifact markdown in the working tree), then run `scripts/build-html.sh` to regenerate `docs/`.
- **Product Owner (human)**: confirm the new Epic 0.7 story numbering doesn't collide with any in-flight dispatch (checked: `sprint-status.yaml` shows Epic 0.1 fully `backlog`, so no collision), and decide when `ctam-jomockapi`'s GitHub-setup runbook step (Story 0.7.1) gets scheduled relative to Epic 0.0.
- **Judicial Office / eLinks liaison (unchanged owner)**: G8.1 remains their gate — this SCP does not change who owns confirming the real contract, only what CTAM can demonstrate before it lands.

**Success criteria:** all thirteen artifact edits in §4 land consistently (cross-references resolve, story/epic counts match across `index.md`, `sprint-status.yaml`, and the epic files themselves), `docs/` regenerates cleanly, and G8.1 in `gaps.md` explicitly still reads as open.

---

## Sprint Change Proposal — 2026-08-24b

**Status:** approved

**Trigger:** *"we are focusing on joh data as phase-0 update epic-0.1 as joh-reference-data-etl process"*

**Clarified via two questions before drafting:**
1. **"ETL" meaning** → **Rename/reframe only.** The technical design (in-process nightly `@Scheduled` sync, decision #9 in `architecture.md`) is unchanged. "ETL" becomes the epic's label for that ongoing pipeline.
2. **"Focusing on JOH data" scope** → **Split MRD out.** Epic 0.1 becomes JOH-eLinks-only (Stories 0.1.1–0.1.3); MRD ingestion (former Story 0.1.4) moves to a new Epic 0.8.

**Mode:** Batch (carried over from the prior SCP this session). **Scope classification:** Moderate (epic retitle + split, story renumbering, coordinated shard sweep; no PRD/FR/NFR change).

**Note on process:** given the two clarifying answers fully scoped this change, edits below were drafted directly rather than staged separately; nothing is committed to git — this document is the record, and anything here can still be adjusted before that happens.

---

### 1. Issue Summary

Epic 0.1 ("Upstream JOH/MRD reference data is ingested") bundled two upstream integrations — the JOH eLinks API sync (Stories 0.1.1–0.1.3) and the MRD weekly Excel ingestion (Story 0.1.4) — under one epic. The team's near-term focus is JOH data specifically; keeping MRD bundled into the same epic obscures that focus and overstates what "Epic 0.1 done" means (an epic-level `depends_on` gate, per `dispatch-preflight.sh`, currently can't distinguish "JOH ETL done" from "JOH ETL done AND MRD done").

Separately, the team wants Epic 0.1 to carry the "ETL" label for communication clarity. This needs care: "ETL" was **explicitly retired** in this repo (D3, 2026-06-10; gaps.md G4.6) when it referred to the **one-shot legacy APEX-migration tool** — retracted because CTAM Pathfinder does no legacy data migration of any kind. Reusing "ETL" for a *different*, ongoing thing (the nightly eLinks sync) is fine, but only if clearly distinguished from that retirement, or it silently reopens a settled decision. Both gaps.md (G4.6) and the new epic file now carry that distinction explicitly.

### 2. Impact Analysis

#### Epic impact

- **Epic 0.1** retitled **"JOH Reference-Data ETL Process"**; narrowed to Stories 0.1.1–0.1.3 (JOH eLinks only). `depends_on` unchanged (`[epic-0.0, epic-0.6]`).
- **New Epic 0.8** ("MRD supplementary reference data is ingested") carries the former Story 0.1.4, renumbered **Story 0.8.1**, content otherwise verbatim. `depends_on: [epic-0.0, epic-0.1]` — same repo (`ctam-reference-data`), needs Epic 0.1's scaffold (0.1.1) and tier-(a) write-protection pattern (0.1.2) established first.
- No other epic's scope changes. Epic 0.2 (auth) still depends on Epic 0.1 for `jo_people` — unaffected, since JOH data (not MRD) is what sign-in needs.

#### Story impact

- Story 0.1.4 → **Story 0.8.1**, moved wholesale (Acceptance Criteria, references, out-of-scope notes carried over unchanged).
- Stories 0.1.1, 0.1.2, 0.1.3 — cross-references to "Story 0.1.4" updated to "Epic 0.8, Story 0.8.1"; no AC content changed.
- No story is added, removed in substance, or has its acceptance criteria altered — this is a **relabelling + regrouping**, not a scope change.

#### Artifact conflicts / updates needed

| Artifact | Change |
|---|---|
| `epics/phase-0/epic-0.1-upstream-reference-data-ingested.md` | Retitled "JOH Reference-Data ETL Process"; naming note added (ETL distinction); Story 0.1.4 removed; storyCount 4→3; cross-references fixed |
| `epics/phase-0/epic-0.8-mrd-supplementary-reference-data-ingested.md` *(new)* | Former Story 0.1.4, now Story 0.8.1, as its own epic; `depends_on: [epic-0.0, epic-0.1]` |
| `epics/phase-0/index.md` | Epic table (0.1 retitled/3 stories, +0.8/1 story); epic summaries (0.1 rewritten, +0.8); Stories Summary table (0.1/+0.8 rows; **total corrected to 24** — the table previously read 22, an arithmetic carry-over error caught while editing it) |
| `epics/framework.md` | Reference Data area: ingestion paragraph split by epic; Phase 0 area-table row updated |
| `epics/fr-coverage-map.md` | FR6 and NFR24 rows: split JOH (0.1.3) vs MRD (0.8.1) |
| `epics/requirements-inventory.md` | MRD storage Terraform cross-reference updated to Epic 0.8 |
| `architecture/non-functional-requirements-coverage.md` | NFR24 bullet: JOH → Epic 0.1, MRD → Epic 0.8 |
| `architecture/repository-strategy.md` | `ctam-reference-data` row: MRD storage cross-reference + "JOH eLinks ETL process" phrasing |
| `architecture/delivery-operating-model.md` | Story-packet template's illustrative example (`story_id`, `epic`, `sprint_status_key`) updated from the now-moved `0.1.4` to `0.8.1` so the worked example stays accurate |
| `architecture/gaps.md` | G4.6: terminology note distinguishing reused "ETL" from the retired legacy-migration ETL. G8.1: epic-split cross-reference (JOH→0.1, MRD→0.8) |
| `architecture.md` | Decision log: new **#15** |
| `architecture/changelog.md` | New **v4.10** entry |
| `sprint-status.yaml` | `0-1-4-...` moved out of `epic-0.1` block into new `epic-0.8` block as `0-8-1-...`, status unchanged (`backlog`) |

**Not touched (deliberately):** dated historical records — `sprint-change-proposal-2026-05-15.md`, `-2026-06-17.md`, `-2026-08-20.md`, `implementation-readiness-report-2026-06-17.md`, and the `changelog.md` v3.1/v4.6/v4.7 entries — all correctly describe the state *as of their date* and are left as immutable history per this repo's convention. `assumptions.md` A36/A37 (reference G8.1, not epic numbers — no change needed). No PRD, UX, or FR/NFR change.

#### Technical impact

None. The eLinks sync's implementation (in-process `@Scheduled`, full-refresh upsert, `ctam_sync_status` logging) and MRD's implementation (blob poll, validate, upsert, archive) are unchanged — only which epic tracks each, and what Epic 0.1 is called. `ctam_sync_status` remains a single shared table written by both, now-separately-tracked, processes in the same repo.

### 3. Recommended Approach

**Option 1 — Direct Adjustment.** This is a pure backlog reorganisation: retitle one epic, split one story into a sibling epic, sweep cross-references. Nothing is built yet (`sprint-status.yaml` shows both epics fully `backlog`), so there's no rollback question (Option 2 doesn't apply) and no MVP/FR impact (Option 3 doesn't apply).

**Effort:** Low. **Risk:** Low — relabelling plus a mechanical cross-reference sweep, verified file-by-file rather than blind find-replace (per this repo's cross-cutting-change convention). **Timeline impact:** None — Epic 0.8's `depends_on` on Epic 0.1 preserves the same effective build order MRD already had as Story 0.1.4 (it came after 0.1.1–0.1.3 anyway).

### 4. Detailed Change Proposals

All edits are described in full, with before/after text, in the files themselves (this SCP intentionally doesn't re-paste the whole rewritten epic files — see the two epic files directly for the authoritative before/after). Summary of the key renames:

- **Epic 0.1**: "Upstream JOH/MRD reference data is ingested" → **"JOH Reference-Data ETL Process"**, 4 stories → 3 (0.1.1–0.1.3).
- **Epic 0.8** *(new)*: "MRD supplementary reference data is ingested", 1 story (0.8.1 — was 0.1.4).
- **Decision #15** added to `architecture.md`'s decision log; **v4.10** added to `changelog.md`.
- **G4.6** (gaps.md) gains a terminology note; **G8.1** gains an epic-split cross-reference.
- Phase 0 totals: **9 epics** (was 8), **24 stories** (unchanged — 3+1 replaces the old 4).

### 5. Implementation Handoff

**Scope: Moderate** — backlog reorganisation (epic retitle + split + renumbering) with a coordinated cross-reference sweep. No PRD rewrite, no FR/NFR change. Routed as **Product Owner / Developer**, not Product Manager / Architect.

**Responsibilities:**
- **This session:** all edits above have been drafted directly in the tracked planning-artifact files (nothing committed). Pending final approval, the next step is `scripts/build-html.sh` to regenerate `docs/`.
- **Product Owner (human):** confirm no dispatcher has picked up `0.1.4`/Story 0.8.1 under its old identity outside this control plane (checked: `sprint-status.yaml` shows it was `backlog` under `epic-0.1`, never dispatched).

**Success criteria:** Epic 0.1 and Epic 0.8 files are internally consistent and cross-reference each other correctly; `epics/phase-0/index.md`'s two summary tables agree on totals (24 stories, 9 epics); `docs/` regenerates cleanly; no FR/NFR/PRD text changed.

---

## Sprint Change Proposal — 2026-08-24c

**Status:** proposed

**Trigger:** *"create an epic for postgress-sql-schema-design. This is to design and implement the joh schema in postgres sql database"*

**Clarified via two questions before drafting:**
1. **Which "JOH schema"** → **`ctam-joh`'s own domain schema** — the 5 CTAM-owned overlay tables (working patterns, ticket/location overlays, jurisdictional splits), *not* the tier-(a) `jo_*` eLinks tables (already covered by Epic 0.1 Story 0.1.2).
2. **Scope** → **Schema only** — tables, PKs/FKs, Liquibase changelogs, tier ownership/grants. No working-pattern-generation, overlay-CRUD, or jurisdictional-split-validation *business logic* — that's later Phase 1 work.

**Mode:** Batch. **Scope classification:** Moderate — this is the **first Phase 1 epic ever created** (Phase 1 currently has no epics/stories, only a `framework.md` area description), so it's a bigger step than the Phase-0 backlog edits earlier this session, even though its own content is schema-only.

---

### 1. Issue Summary

Phase 1 (JOH) has never been decomposed into epics — `epics/index.md`'s phase table lists it as "_to be storied_ / ⚪ Framework only," and `architecture/data-tables.md` already fully specifies `ctam-joh`'s 5 domain tables (§"JOH service (`ctam-joh`) — 5 tables") without any story ever scheduling their creation. The team wants to start Phase 1 with the database schema specifically — design and implement `ctam-joh`'s own PostgreSQL tables — before building the working-pattern/overlay business logic on top of them, mirroring the pattern Epic 0.1 already used (Story 0.1.2 "tables" landed before Story 0.1.3 "sync logic").

This SCP creates that one schema-only epic. It does **not** run the full `bmad-create-epics-and-stories` decomposition for Phase 1 — FR12–FR18's behavioral stories (working-pattern management, forward-sitting generation, overlay CRUD, jurisdictional-split workflow) remain undecomposed and are explicitly out of scope here.

### 2. Impact Analysis

#### Epic impact

- **New Epic 1.1** — "JOH domain schema is designed and implemented in PostgreSQL" (file slug: `postgres-sql-schema-design`, per the trigger). First epic in a new `epics/phase-1/` folder.
- **Depends on Epic 0.1** (hard dependency: `ctam_joh_identities` — the FK target for every `ctam-joh` table's `joh_id` column — is minted by Epic 0.1's eLinks sync, Story 0.1.3, and its schema is created in Story 0.1.2). Also depends on **Epic 0.0** (shared estate) and **Epic 0.6** (context bus + config baseline), mirroring Epic 0.1's own dependency set for the same reasons (first `ctam-joh` scaffold needs both).
- **Open item flagged, not resolved here:** some of the 5 tables plausibly carry FK columns into tier-(b) vocabulary tables owned by `ctam-reference-data` (e.g. a working-pattern-type reference into `ctam_working_pattern_types`, landed in Epic 0.3 Story 0.3.1) — `data-tables.md` documents the vocabulary tables and their JOH-consumer relationship but not full column-level DDL, so I'm not asserting a hard Epic 0.3 dependency I can't verify. The new epic's schema story instead carries an explicit AC: verify each such FK against `data-tables.md` and Epic 0.3's landing status at implementation time; raise an architectural PR (same pattern as gaps.md G8.1's "unmapped upstream structure") if a referenced vocabulary table doesn't exist yet.
- No existing epic (0.0–0.8) changes.

#### Story impact

- **New Story 1.1.1** — scaffold `ctam-joh` from the HMCTS starter (mirrors Story 0.1.1's pattern — first time this repo is scaffolded).
- **New Story 1.1.2** — the 5-table domain schema itself, via Liquibase, with tier ownership + grants (mirrors Story 0.1.2's pattern).
- No existing story changes.

#### Artifact conflicts / updates needed

| Artifact | Change |
|---|---|
| `epics/phase-1/index.md` *(new)* | Phase 1 overview — Epic 1.1 only; explicit note that FR12–FR18 behavioral decomposition is still pending |
| `epics/phase-1/epic-1.1-postgres-sql-schema-design.md` *(new)* | The epic itself — 2 stories |
| `epics/index.md` | Phase-level breakdowns table: Phase 1 row updated from "_to be storied_ / ⚪" to link + partial status |
| `epics/framework.md` | Phase 1 · Area: JOH Records & Working Patterns — one-sentence cross-reference to Epic 1.1 |
| `epics/fr-coverage-map.md` | Phases 1–9+ pending table: FR10–FR18 row annotated (schema groundwork landed; behavior still pending) — status stays ⚪, not flipped to ✅ |
| `architecture/changelog.md` | New version entry |
| `sprint-status.yaml` | New `epic-1.1` block, 2 stories, `backlog` |

**Not touched:** `data-tables.md` (already fully specifies these 5 tables — nothing to change, this epic just schedules building what's already documented there). `architecture.md` decision log (no new architectural decision — the schema design was already fixed by `data-tables.md`; this is pure backlog scheduling). No PRD, FR/NFR, or UX change.

#### Technical impact

None beyond what's already documented: `ctam-joh` becomes the second domain service scaffolded (after `ctam-reference-data`), owns 5 tables with the same conventions as every other domain table (`id uuid` PK, `joh_id` FK → `ctam_joh_identities.id`, `created_at`/`updated_at timestamptz NOT NULL`, Liquibase-only DDL, per-service DB role write ownership, ArchUnit grants fitness function). One genuinely open technical question, flagged as a story AC rather than resolved here: `ctam_jurisdictional_splits`' "must total 100%" constraint (FR16) is a **cross-row** invariant — a plain Postgres `CHECK` constraint can't express "this JOH's rows sum to 100," so the story requires the implementer to choose (and justify) a trigger, an application-level enforcement, or a materialized total column, rather than silently assuming one.

### 3. Recommended Approach

**Option 1 — Direct Adjustment (new epic).** Nothing rolls back (Phase 1 has zero stories today, so Option 2 doesn't apply) and nothing touches MVP scope or FR/NFR text (Option 3 doesn't apply). This is additive: one new epic, schema-only, in a phase that's otherwise still framework-only.

**Effort:** Low–Medium (two stories: a scaffold mirroring an already-proven pattern, and a schema migration against an already-fully-specified table set). **Risk:** Low, with one flagged design question (the 100%-sum constraint) that the story surfaces rather than resolves — appropriate for a schema-only epic to hand to the implementer as a cited open item, not something this SCP should invent an answer for. **Timeline impact:** None on Phase 0; this is the first step of Phase 1 and doesn't block anything currently in flight (all Phase 0 epics still `backlog`/`in-progress` per `sprint-status.yaml`).

### 4. Detailed Change Proposals

#### 4.1 New file — `epics/phase-1/epic-1.1-postgres-sql-schema-design.md`

```markdown
---
type: 'Epic'
description: "User outcome: ctam-joh's own PostgreSQL domain schema — 5 tables (working patterns, ticket/location overlays, jurisdictional splits) — is designed and implemented via Liquibase, so later Phase 1 behavioral epics have a schema to build against. Schema only — no business logic."
resource: 'epics/phase-1/epic-1.1-postgres-sql-schema-design.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-08-24'
parent: 'epics/phase-1/index.md'
epic: 1.1
title: 'JOH domain schema is designed and implemented in PostgreSQL'
storyCount: 2
repo: ctam-joh
depends_on: [epic-0.0, epic-0.1, epic-0.6]
---

# Epic 1.1: JOH domain schema is designed and implemented in PostgreSQL

**User outcome:** `ctam-joh`'s own PostgreSQL domain schema — the 5 CTAM-owned overlay tables (`ctam_working_patterns`, `ctam_working_pattern_days`, `ctam_joh_ticket`, `ctam_joh_location`, `ctam_jurisdictional_splits` — per `architecture/data-tables.md`) — is designed and implemented via Liquibase, each keyed by `joh_id` → `ctam_joh_identities.id`, so that later Phase 1 epics (working-pattern management, overlay maintenance, jurisdictional-split workflow — FR12, FR15b, FR16, FR17) have a schema to build against. **Schema only** — no business logic, no API, no UI in this epic.

**Hosting:** `ctam-joh` is the **second** domain service scaffolded (after `ctam-reference-data`, Epic 0.1); it deploys onto the shared Azure estate provisioned in **Epic 0.0** and carries only its own per-repo Terraform. This epic does not build `ctam-joh`'s API or any working-pattern/overlay business logic — those are later Phase 1 epics, run via `bmad-create-epics-and-stories` once Phase 1 is fully decomposed.

**Vertical slice:**
- **Second scaffolded backend service: `ctam-joh`** (HMCTS Crime SpringBoot template + `ctam-scaffold.sh` conventions per AR2–AR4, same pattern as Epic 0.1 Story 0.1.1)
- **Consumes the shared Azure estate** provisioned in Epic 0.0
- The 5 domain tables, service-owned Liquibase changelog (AR18–AR20), keyed by `joh_id` → `ctam_joh_identities.id` (Epic 0.1)
- Tier ownership: only the `ctam_joh` DB role holds INSERT/UPDATE on its own tables; SELECT-granted to `ctam_reference_data` for JOH profile-view composition (per `data-tables.md`'s explicit note)

**FRs covered:** none behaviourally — **schema groundwork only** for FR12 (working patterns), FR15b (ticket overlay), FR16 (jurisdictional split), FR17 (location overlay). Full behavioral coverage is later Phase 1 epics.

**Key NFRs first exercised here (for `ctam-joh`):** NFR10 (TLS at APIM), NFR11 (data-at-rest), NFR25–NFR28 (structured logs + observability), NFR31 (Azure UK South), NFR40 (per-service deployable).

**Out of scope (explicitly):** Working-pattern generation / forward-sitting generation (FR13). Ticket/location overlay CRUD business logic. Jurisdictional-split validation workflow. JOH profile *view* composition itself (only the SELECT grant enabling it is this epic's concern). `ctam-joh`'s REST API. `ctam-ui`'s `joh/` module. All of these are future Phase 1 epics.

---

## Story 1.1.1: Scaffold `ctam-joh` from the HMCTS starter (onto the Epic 0.0 estate)

As a **platform engineer**,
I want to scaffold `ctam-joh` — the second CTAM Pathfinder backend service — from the HMCTS Crime SpringBoot template using `ctam-scaffold.sh`, and deploy it onto the shared Azure estate provisioned in Epic 0.0,
So that **the JOH domain schema (Story 1.1.2) has a service to live in**, following the same proven scaffold pattern Epic 0.1 established for `ctam-reference-data`.

**Acceptance Criteria:**

**Given** the engineer has performed the GitHub manual-setup checklist (`ctam-architecture/runbooks/github-setup.md`) **before** running the scaffold (repo `ctam-joh` created via the GitHub web UI; branch protection on `main`; no `gh` CLI, per D10),
**When** the engineer runs `ctam-scaffold.sh ctam-joh` from `ctam-architecture/scaffolding/`,
**Then** the script scaffolds a Spring Boot 4.0.x project locally from `https://github.com/hmcts/service-hmcts-crime-springboot-template`, commits, and pushes to the pre-created remote on a feature branch via plain `git`,
**And** Group ID is `uk.gov.hmcts.ctam`, artefact is `ctam-joh`, base package is `uk.gov.hmcts.ctam.joh`, default port is 8082 (per AR3),
**And** the same baseline dependency set as every other CTAM service is configured (Liquibase, Testcontainers PostgreSQL, MapStruct, OWASP encoder, docker-compose plugin, OpenAPI tooling, Helm chart, Key Vault, JaCoCo, CycloneDX SBOM — per AR5–AR17),
**And** a `terraform/` directory exists holding only `ctam-joh`'s own resources (Key Vault namespace) — the shared estate lives in `ctam-shared-infrastructure` (per AR53 revised),
**And** GitHub Actions workflows, `CODEOWNERS`, `PULL_REQUEST_TEMPLATE.md`, and a Postman collection skeleton exist (per AR28, AR29, AR41).

**Given** the shared Azure estate provisioned and independently verified in Epic 0.0,
**When** `ctam-joh`'s Helm chart is deployed to the dev AKS cluster,
**Then** the service reaches the shared cluster, database, registry, gateway, and observability estate (this story **consumes** the estate; it does not provision it),
**And** `GET /actuator/health` returns `200 OK`, liveness/readiness probes pass, and structured JSON logs with `correlationId` appear (per NFR25, NFR28, AR30, AR32).

**Given** the `ctam-architecture` Liquibase baseline and shared `ctam_configuration_values` table already exist (Epic 0.6),
**When** `ctam-joh` is scaffolded,
**Then** its DB role has `SELECT` on `ctam_configuration_values`,
**And** its own service-owned Liquibase changelog directory exists but is empty (the 5 domain tables are created in Story 1.1.2).

**References:** AR2–AR17, AR23–AR32, AR41, AR53 (revised); D10; depends on Epic 0.0 (shared estate) and Epic 0.6 (context bus + config baseline).

**Explicitly NOT in scope:**
- The 5 domain tables and tier ownership/grants — Story 1.1.2
- Any `ctam-joh` API, business logic, or UI — future Phase 1 epics

---

## Story 1.1.2: The 5 `ctam-joh` domain tables are designed and implemented

As a **CTAM Pathfinder platform** (and every future Phase 1 story that builds on this schema),
I want the 5 CTAM-owned `ctam-joh` overlay tables created via Liquibase, keyed by `joh_id` → `ctam_joh_identities.id`, with tier ownership and cross-service SELECT grants in place,
So that **later Phase 1 epics (working-pattern management, overlay maintenance, jurisdictional-split workflow) have a correctly-owned schema to build behavior against, and `ctam-reference-data` can compose JOH profile views without a shared code dependency**.

**Acceptance Criteria:**

**Given** `ctam-joh` is scaffolded per Story 1.1.1, and `ctam_joh_identities` exists (Epic 0.1, Story 0.1.2),
**When** the engineer adds the Liquibase changeset `db/changelog/001-init-joh-domain-tables.sql` (formatted-SQL, included from `db.changelog-master.yaml`),
**Then** the 5 tables exist per `architecture/data-tables.md`'s "JOH service (`ctam-joh`) — 5 tables" section:
  - `ctam_working_patterns` — per-JOH working-pattern definition (target sit %, active period; FR12)
  - `ctam_working_pattern_days` — per-day work-type breakdown within a working pattern (FR12)
  - `ctam_joh_ticket` — CTAM-overlay tickets layered on the upstream `jo_tickets` set (FR15 layer (b))
  - `ctam_joh_location` — JOH base-location changes recorded in CTAM, not propagated upstream (FR17)
  - `ctam_jurisdictional_splits` — per-JOH jurisdictional split percentages (FR16)
**And** every table has `id uuid PK`, `joh_id uuid` FK → `ctam_joh_identities.id` (never a bare `personnel_number`), and `created_at`/`updated_at timestamptz NOT NULL`, per house convention,
**And** `ctam_working_pattern_days` FKs to its parent `ctam_working_patterns.id`.

**Given** any of the 5 tables needs a foreign key into a tier-(b) vocabulary table owned by `ctam-reference-data` (e.g. a working-pattern-type reference into `ctam_working_pattern_types`),
**When** the engineer designs that column,
**Then** the referenced vocabulary table's existence and shape is verified against `data-tables.md` and Epic 0.3's landing status **before** the FK is added — an unmapped or not-yet-landed vocabulary table raises an architectural PR rather than being assumed (cite-or-ask; mirrors gaps.md G8.1's "unmapped upstream structure raises an architectural PR" pattern).

**Given** `ctam_jurisdictional_splits`' percentages must total 100% per JOH (FR16) — a **cross-row** invariant a single-row Postgres `CHECK` constraint cannot express,
**When** the engineer designs this table's enforcement,
**Then** the chosen mechanism (a trigger, application-level validation, or an equivalent) is explicit and justified in the migration's accompanying notes — this AC exists precisely so the choice is made deliberately, not defaulted to "no enforcement."

**Given** the tables are created,
**When** grants are configured,
**Then** the `ctam_joh` DB role owns all 5 tables and holds INSERT/UPDATE on them; **no other role holds INSERT/UPDATE** (mirrors AR49's tier-ownership pattern, now for `ctam-joh`'s own tier rather than tier (a)),
**And** `ctam_reference_data`'s DB role holds `SELECT` on all 5 tables (per `data-tables.md`: "the overlay tables are SELECT-granted to `ctam_reference_data`" for JOH profile-view composition),
**And** the ArchUnit/grants fitness function in CI verifies this write-protection + grant rule.

**References:** FR12, FR15b, FR16, FR17 (schema groundwork only — no behavior); NFR15; AR18–AR20, AR22; `architecture/data-tables.md` §"JOH service (`ctam-joh`) — 5 tables"; depends on Epic 0.1 Story 0.1.2 (`ctam_joh_identities`).

**Explicitly NOT in scope:**
- Working-pattern generation / forward-sitting generation (FR13) — future Phase 1 epic
- Ticket/location overlay CRUD, jurisdictional-split validation workflow — future Phase 1 epics
- JOH profile view composition (only the SELECT grant enabling it is here) — future Phase 1 epic
- `ctam-joh`'s REST API — future Phase 1 epic
```

#### 4.2 New file — `epics/phase-1/index.md`

```markdown
---
type: 'Phase Index'
title: 'Phase 1 — JOH'
description: 'Epic 1.1 (schema only) is the first Phase 1 epic. FR10–FR18 behavioral decomposition is still pending a full bmad-create-epics-and-stories run for this phase.'
resource: 'epics/phase-1/index.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-08-24'
parent: 'epics/index.md'
phase: 1
phaseName: 'JOH'
---

# Phase 1 — JOH

> **Partial decomposition.** Only **Epic 1.1** (schema-only) exists so far — added via Sprint Change Proposal 2026-08-24c, ahead of a full Phase 1 decomposition. FR10–FR18's behavioral stories (working-pattern management, forward-sitting generation, overlay CRUD, jurisdictional-split workflow, JOH search/profile views — see [`../framework.md`](../framework.md) → *Phase 1 · Area: JOH Records & Working Patterns*) are **not yet storied**. Run `bmad-create-epics-and-stories` for Phase 1 to decompose the rest; Epic 1.1's schema is what those future epics will build against.

## Epics

| Epic | Title | Stories | Status |
|---|---|---|---|
| [1.1](epic-1.1-postgres-sql-schema-design.md) | JOH domain schema is designed and implemented in PostgreSQL | 2 | 🟡 Planned |
| **Total** | | **2 stories** | |

## Epic summaries

### Epic 1.1: JOH domain schema is designed and implemented in PostgreSQL (2 stories)

**User outcome:** `ctam-joh`'s 5 domain tables — working patterns, per-day pattern breakdown, ticket overlay, location overlay, jurisdictional splits — are designed and implemented via Liquibase, keyed by `joh_id` → `ctam_joh_identities.id`, with tier ownership and a cross-service SELECT grant to `ctam-reference-data`. **Schema only** — the behavioral stories that populate and maintain this schema are future Phase 1 epics.

**FRs covered:** none behaviourally — schema groundwork for FR12, FR15b, FR16, FR17.

→ [Full epic with stories](epic-1.1-postgres-sql-schema-design.md)

## Not yet storied

FR10, FR11, FR13, FR14, FR18, and the behavioral halves of FR12/FR15b/FR16/FR17 — see [`../framework.md`](../framework.md) → *Phase 1 · Area: JOH Records & Working Patterns* for the architectural map. Run `bmad-create-epics-and-stories` for Phase 1 when ready to decompose these.
```

#### 4.3 `epics/index.md` — Phase-level breakdowns table

**OLD:**
```
| **1** — JOH | _to be storied_ | ⚪ Framework only |
```

**NEW:**
```
| **1** — JOH | [phase-1/](phase-1/index.md) | 🟡 Partially planned — 1 epic (schema only, SCP 2026-08-24c); FR10–FR18 behavior still to be storied |
```

#### 4.4 `epics/framework.md` — Phase 1 · Area: JOH Records & Working Patterns

Append one sentence to the existing scope paragraph: *"`ctam-joh`'s own PostgreSQL schema (the 5 tables above) is designed and implemented in [Epic 1.1](phase-1/epic-1.1-postgres-sql-schema-design.md) — schema only; the behavioral stories in this area are not yet storied."*

#### 4.5 `epics/fr-coverage-map.md` — Phases 1–9+ pending table

**OLD:**
```
| FR10–FR18 | 1 | JOH Records & Working Patterns (profiles are *views* over tier (a) + `ctam-joh` overlays; FR14 is display-only — conversions happen upstream) | ⚪ |
```

**NEW:**
```
| FR10–FR18 | 1 | JOH Records & Working Patterns (profiles are *views* over tier (a) + `ctam-joh` overlays; FR14 is display-only — conversions happen upstream). **Schema groundwork landed**: [Epic 1.1](phase-0/../phase-1/epic-1.1-postgres-sql-schema-design.md) (SCP 2026-08-24c) — schema only, behavior still ⚪ | ⚪ |
```

#### 4.6 `architecture/changelog.md`

New version row (above the current top entry):

| **v4.11 — Phase 1's first epic: `ctam-joh` domain schema (schema only)** | 2026-08-24 | **Additive** (SCP 2026-08-24c), no FR/NFR/PRD/architecture-decision change — `data-tables.md` already fully specified these 5 tables. Adds **Epic 1.1** in a new `epics/phase-1/` folder: scaffold `ctam-joh` (Story 1.1.1) + create its 5 domain tables via Liquibase (Story 1.1.2), keyed by `joh_id` → `ctam_joh_identities.id` (Epic 0.1), tier-owned + SELECT-granted to `ctam_reference_data`. Schema only — FR12/FR15b/FR16/FR17's behavioral stories remain unstoried. Flags one open design question for the implementer: `ctam_jurisdictional_splits`' 100%-sum constraint is a cross-row invariant, not a plain `CHECK`. See [`../sprint-change-proposal-2026-08-24.md#sprint-change-proposal-2026-08-24c`](../sprint-change-proposal-2026-08-24.md#sprint-change-proposal-2026-08-24c). | new `epics/phase-1/index.md`, new `epics/phase-1/epic-1.1-postgres-sql-schema-design.md`; `epics/index.md`; `epics/framework.md`; `epics/fr-coverage-map.md`; `sprint-status.yaml` |

#### 4.7 `sprint-status.yaml`

Append a new block:

```yaml
  epic-1.1: backlog
  1-1-1-scaffold-ctam-joh-from-the-hmcts-starter-onto-the-epic-0-0-estate: backlog
  1-1-2-the-5-ctam-joh-domain-tables-are-designed-and-implemented: backlog
  epic-1.1-retrospective: optional
```

### 5. Implementation Handoff

**Scope: Moderate** — first Phase 1 epic, schema-only, additive. No PRD/FR/NFR/architecture-decision change (the schema itself was already fixed in `data-tables.md`; this only schedules building it). Routed as **Product Owner / Developer**.

**Responsibilities:**
- **This session:** on approval, create the two new files and apply the five edits above, then regenerate `docs/` and add the two new NAV entries (`epics/phase-1/index.md`, `epics/phase-1/epic-1.1-postgres-sql-schema-design.md`) to `scripts/python/build_html.py`, following the same convention as the Phase 0 entries.
- **Implementing engineer (Story 1.1.2):** resolve the two flagged open items at implementation time — (a) verify any tier-(b) vocabulary FK against `data-tables.md`/Epic 0.3's status before adding it, raising an architectural PR if unmapped; (b) choose and justify the `ctam_jurisdictional_splits` 100%-sum enforcement mechanism.
- **Product Owner (human):** decide when to run `bmad-create-epics-and-stories` for the rest of Phase 1 (FR10–FR18 behavior) — not part of this SCP's scope.

**Success criteria:** `epics/phase-1/index.md` and the new epic file are internally consistent; `epics/index.md`'s Phase 1 row links correctly; `docs/` regenerates cleanly with both new pages reachable from the NAV sidebar; no FR/NFR/PRD text changed; `data-tables.md` unchanged (nothing here contradicts it).
