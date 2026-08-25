---
type: 'Sprint Change Proposal'
description: 'JOH eLinks API contract remains unconfirmed (gaps.md G8.1) but a schema-faithful mock — ctam-jomockapi — already exists; adds Epic 0.7 to onboard, deploy, and wire it in as the Phase 0 dev/staging stand-in for the JOH eLinks API.'
resource: 'sprint-change-proposal-2026-08-24.html'
tags: [ctam-pathfinder, sprint-change-proposal]
timestamp: '2026-08-24'
title: 'Sprint Change Proposal — 2026-08-24'
status: 'approved'
---

# Sprint Change Proposal — 2026-08-24

**Trigger:** *"We don't have real APIs to consume the data from JOH. We are building a mock API with mock data for consumption."* — evidenced by `/Users/shivakumar/MOJ/ctam-jomockapi`, an already-implemented Node/Express mock of the **Judiciary "E-links" People API v5**, built directly from the real `Swagger UI.pdf` + `apiresponses.docx` and populated from the real `ReferenceData/*.csv|json` exports.

**Mode:** Batch. **Scope classification:** Moderate (backlog reorganisation — new epic + story amendment + architecture-shard updates; no PRD/MVP change).

---

## 1. Issue Summary

Phase 0's foundational data layer (Epic 0.1, `ctam-reference-data`) is built on an **unconfirmed external dependency**: the JOH eLinks API contract (gaps.md **G8.1**, business-case.md risk #1, "Med/High"). The existing mitigation on record is thin — Story 0.1.3's AC and the 2026-06-17 implementation-readiness report both point to *"the sync code path is integration-tested against a WireMock/stub eLinks API in CI"* (AR52-referenced). That mitigation is CI-test-only: it proves the sync *code path* compiles and runs against a canned response, but nothing in the current plan lets the real `@Scheduled` nightly sync job run **end-to-end against a live network endpoint** in dev or staging, and nothing gives Phase 0 a demoable ingestion walkthrough before the real eLinks contract lands.

That gap has now been closed by work already done outside this repo: `ctam-jomockapi` is a complete, runnable mock service — not a test fixture — covering the full documented eLinks v5 contract (auth-token behaviour, `/people` change-feed with `updated_since`/pagination, `/leavers`, `/deleted`, and all 11 `/reference_data/:attribute_name` vocabularies), seeded with 100 realistic JOH profiles joined against the **real** production reference-data exports (2000 locations, 1462 base locations, 194 appointment titles, 164 judiciary roles, 159 tickets, 54 ticket categories, etc.), with a fixed random seed for stable ids across restarts.

**This is a legitimate correct-course trigger, not a scope change:** it doesn't alter any FR/NFR, PRD goal, or the eventual need to confirm the real eLinks contract (G8.1 stays open). It upgrades the *interim substitute* for that contract from "CI-only WireMock stub" to "a deployed, schema-faithful mock service" — which was already the plan's own stated mitigation pattern (business-case.md: *"Build against a WireMock stub now; contract gates production cutover only"*), just not yet reflected as a repo, an epic, or a deployment target in the tracked artifacts.

## 2. Impact Analysis

### Epic impact

- **Epic 0.1** (`epics/phase-0/epic-0.1-upstream-reference-data-ingested.md`) is **not invalidated** — it proceeds as planned. **Story 0.1.3** gains one new AC block: the dev/staging nightly sync points at the deployed `ctam-jomockapi` endpoint (config-driven base URL + Key-Vault-held bearer token, mirroring the real eLinks credential wiring per NFR16) rather than `localhost`; the existing CI WireMock stub (AR52) is retained for pure unit/integration tests — the two are complementary, not a replacement of one by the other.
- **New Epic 0.7** is added: *"JOH eLinks mock API stands in for the unconfirmed upstream contract."* It onboards `ctam-jomockapi` as a CTAM Pathfinder repo, deploys it onto the shared estate (Epic 0.0), and hands `ctam-reference-data` a live URL to sync against. It is **not numbered 0.1a / inserted mid-sequence** — following the Epic 0.6 precedent ("the number is not the order"; see `depends_on`), it runs in parallel with / shortly after Epic 0.0 and ahead of Story 0.1.3's dev-verification AC.
- No other Phase 0 epic (0.0, 0.2–0.6) changes. No Phase 1–8 epic is affected (none exist yet beyond framework-level prose).

### Story impact

- **Story 0.1.3** — amended AC (see §4).
- **New Stories 0.7.1–0.7.3** — repo onboarding, dev/staging deployment, and the wiring-in of Story 0.1.3's sync against it.

### Artifact conflicts / updates needed

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

### Technical impact

- `ctam-jomockapi` is Node.js/Express — a **deliberate, explicitly-scoped deviation** from the Java 25/Spring Boot 4 stack baseline in `_bmad-output/project-context.md`. Justification: it delivers no FR/NFR, is never deployed to production, and is not a CTAM Pathfinder domain service — the same category of exception the repository strategy already grants `ctam-mock-auth` (non-prod-only, contract-parity tooling, distinct lifecycle from the 15 production/UI repos). It is **not** rewritten in Java; the existing implementation is onboarded as-is.
- Deploying it onto the shared AKS estate needs: a minimal Helm chart, a Key-Vault-held mock bearer credential (the mock accepts any non-empty token — Key Vault storage is for wiring-realism/parity with the real eLinks credential path, not because the mock enforces anything), and a `values-{env}.yaml` exposing its base URL to `ctam-reference-data`'s config.
- No database, no Liquibase, no tier-ownership — the mock generates its dataset in-memory at startup with a fixed seed; nothing to migrate or grant.

## 3. Recommended Approach

**Selected: Option 1 — Direct Adjustment** (new epic + one story's AC amended within the existing Phase 0 structure).

- **Option 2 (rollback)** — not viable/not applicable: no Epic 0.1 stories are built yet (all `backlog` in `sprint-status.yaml`); there is nothing to roll back.
- **Option 3 (MVP review)** — not needed: no FR/NFR/PRD goal is affected; this closes an execution risk the plan already flagged (business-case.md risk #1), it doesn't reopen it.
- **Option 1** fits cleanly: the architecture already has a precedent shape for exactly this kind of repo (`ctam-mock-auth` — non-prod mock, own epic-adjacent story, deployed onto the shared estate, explicit "never production" guard). Epic 0.7 reuses that shape for the JOH eLinks side.

**Effort:** Low–Medium. Three small stories (repo onboarding, Helm/deploy, wiring), no new production code path, no schema change. **Risk:** Low. The mock is additive infrastructure; if it were deleted tomorrow, Story 0.1.3 falls back to exactly today's plan (CI WireMock stub + real contract when it lands). **Timeline impact:** Positive — it *de-risks* Epic 0.1's dev/staging demo readiness ahead of the ET-cohort implementation-readiness assessment, rather than adding to the critical path (Epic 0.7 can run alongside Epic 0.0/0.6).

## 4. Detailed Change Proposals

### 4.1 New file — `epics/phase-0/epic-0.7-joh-elinks-mock-api-stands-in.md`

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

### 4.2 `epics/phase-0/epic-0.1-upstream-reference-data-ingested.md` — Story 0.1.3 amendment

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

### 4.3 `architecture/repository-strategy.md`

- Line 1 decision statement: `11 service repos + 1 mock-auth repo + 1 JOH-mock repo + 2 UI repos (business + admin) + 1 architecture/scaffolding repo.` (frontmatter `description` and body).
- New table row, inserted after `ctam-mock-auth`:

  | Repo | Phase | Purpose | Key Functions |
  |---|---|---|---|
  | **`ctam-jomockapi`** | 0 | Node.js/Express mock of the **JOH eLinks People API v5**, standing in for the unconfirmed upstream contract (gaps.md G8.1). **Never deployed to production.** | Serve the documented eLinks v5 contract (people change-feed, leavers, deleted, 11 reference-data vocabularies) from realistic seeded data joined against real production reference-data exports; give `ctam-reference-data`'s dev/staging eLinks sync a live network target (Epic 0.7). |

- Closing summary line: `**16 repos total**` → `**17 repos total** (11 production services + 2 UI + architecture + mock-auth + JOH-mock + shared-infrastructure). ... \`ctam-jomockapi\` is dev/staging/CI-only and never deploys to production, in the same category as \`ctam-mock-auth\`.`

### 4.4 `architecture/gaps.md` — G8.1 (append, don't rewrite the row)

Append to the end of the G8.1 **Detail** cell:

> **Mock unblock added 2026-08-24 (SCP 2026-08-24):** a schema-faithful mock of the eLinks People API v5 (`ctam-jomockapi`, built directly from the real Swagger doc + example-response docs, seeded from real reference-data exports) is now deployed to dev/staging (Epic 0.7) so Phase 0's ingestion pipeline is demoable end-to-end without waiting on this gap. **This does not close G8.1** — the mock is built from documentation, not a confirmed live contract, and production cutover still requires the real contract to be confirmed and the ingestion mapping validated against it.

### 4.5 `architecture/assumptions.md`

New row (title becomes "Assumptions (A1–A38)"):

| **A38** *(new 2026-08-24, SCP 2026-08-24)* | `ctam-jomockapi` provides a schema-faithful mock of the JOH eLinks People API v5 (built from the real Swagger doc + `apiresponses.docx`, seeded from real reference-data exports) for Phase 0 dev/staging/CI consumption. It is **not** a confirmation of the real contract — mirrors A26/A27's mock-auth pattern: non-production only, contract-parity claim is scoped to what the public docs describe, and real-contract confirmation (G8.1) still gates production cutover. | Load-bearing **for Phase 0 dev/staging demonstrability only** | Epic 0.7 deliverable; enforced by CI/deploy guard (no production Helm values, per Story 0.7.1) |

### 4.6 `architecture.md` — decision log

New row after #13:

| # | TBD | Resolution |
|---|---|---|
| 14 | Interim substitute for the unconfirmed JOH eLinks contract *(SCP 2026-08-24)* | **A deployed, schema-faithful mock — `ctam-jomockapi` (17 repos total)** — replaces "CI-only WireMock stub" as Phase 0's dev/staging demonstrability story, without closing G8.1. Onboarded as a new Epic 0.7, in the same non-production-only category as `ctam-mock-auth` (repository-strategy.md). Story 0.1.3 gains one AC block pointing its dev/staging sync target at the deployed mock; the existing CI WireMock stub is retained unchanged. See [`./sprint-change-proposal-2026-08-24.md`](./sprint-change-proposal-2026-08-24.md). |

### 4.7 `architecture/changelog.md`

New version row:

| **v4.9 — JOH eLinks mock API (`ctam-jomockapi`) onboarded as Epic 0.7** | 2026-08-24 | **Additive, no FR/NFR/PRD change.** Adds a 17th repo, `ctam-jomockapi` (Node/Express, non-production-only — same category as `ctam-mock-auth`), giving `ctam-reference-data`'s eLinks sync (Story 0.1.3) a deployed, schema-faithful dev/staging network target while the real eLinks contract (G8.1) remains unconfirmed. G8.1 is **not closed** by this change. See [`../sprint-change-proposal-2026-08-24.md`](../sprint-change-proposal-2026-08-24.md). | `repository-strategy.md`, `gaps.md` (G8.1), `assumptions.md` (A38), decision log (#14), `epics/phase-0/epic-0.1-...md` (Story 0.1.3), new `epics/phase-0/epic-0.7-...md` |

### 4.8 `epics/framework.md` — Phase 0 · Area: Reference Data

Append one sentence to the existing "Ingestion" paragraph: *"A deployed, schema-faithful mock of the eLinks API (`ctam-jomockapi`, Epic 0.7) gives the dev/staging sync a live network target while the real contract (gaps.md G8.1) remains unconfirmed."*

### 4.9 `epics/fr-coverage-map.md` and `architecture/non-functional-requirements-coverage.md` (NFR24)

Append `; dev/staging demonstrability via Epic 0.7's deployed mock ahead of the real contract` to the existing NFR24 rows in both files.

### 4.10 `epics/phase-0/index.md`

- Epic table: add a row `| [0.7](epic-0.7-joh-elinks-mock-api-stands-in.md) | JOH eLinks mock API stands in for the unconfirmed upstream contract | 3 | 🟡 Planned |`; **Total** stories 21 → 24.
- Add an "### Epic 0.7: ..." summary paragraph (mirrors the Epic 0.6 "runs between 0.0 and 0.1 — the number is not the order" framing).
- Phase 0 Epic Stories Summary table: add a `0.7` row (3 stories); **Total** 19 → 22 stories; update the 0.1 row's demo note to mention the deployed mock.

### 4.11 `CLAUDE.md`

- "ships as a **16-repo polyrepo**" → "**17-repo polyrepo**"; add `ctam-jomockapi` to the parenthetical repo list (after `ctam-mock-auth`, before `ctam-reference-data`, matching the phase-0 grouping used elsewhere).

### 4.12 `_bmad-output/implementation-artifacts/sprint-status.yaml`

Append after the `epic-0.6` block:

```yaml
  epic-0.7: backlog
  0-7-1-onboard-ctam-jomockapi-as-a-ctam-pathfinder-repo: backlog
  0-7-2-deploy-ctam-jomockapi-onto-the-shared-dev-staging-estate: backlog
  0-7-3-ctam-reference-data-s-elinks-sync-runs-against-the-deployed-mock-in-dev-staging: backlog
  epic-0.7-retrospective: optional
```

### 4.13 Regenerate the site

Run `scripts/build-html.sh` after all markdown edits land (hard rule — `docs/*.html` is generated, never hand-edited).

## 5. Implementation Handoff

**Scope: Moderate** — backlog reorganisation (one new epic + one story's AC amended) plus a coordinated sweep across architecture shards that reference the repo count, G8.1, and the assumptions/decision/changelog ledgers. No PRD rewrite, no FR/NFR change, no re-plan of programme goals — routed as **Product Owner / Developer**, not Product Manager / Architect.

**Responsibilities:**
- **This session (Developer agent role)**: apply all edits in §4 directly (they're additive, mechanical, and don't touch `main` per the protected-branch hook — all writes are to tracked planning-artifact markdown in the working tree), then run `scripts/build-html.sh` to regenerate `docs/`.
- **Product Owner (human)**: confirm the new Epic 0.7 story numbering doesn't collide with any in-flight dispatch (checked: `sprint-status.yaml` shows Epic 0.1 fully `backlog`, so no collision), and decide when `ctam-jomockapi`'s GitHub-setup runbook step (Story 0.7.1) gets scheduled relative to Epic 0.0.
- **Judicial Office / eLinks liaison (unchanged owner)**: G8.1 remains their gate — this SCP does not change who owns confirming the real contract, only what CTAM can demonstrate before it lands.

**Success criteria:** all thirteen artifact edits in §4 land consistently (cross-references resolve, story/epic counts match across `index.md`, `sprint-status.yaml`, and the epic files themselves), `docs/` regenerates cleanly, and G8.1 in `gaps.md` explicitly still reads as open.
