---
type: 'Epic'
description: "User outcome: ctam-reference-data's nightly eLinks sync runs end-to-end against a deployed, schema-faithful mock of the JOH eLinks People API v5, so Phase 0 has a demoable ingestion pipeline in dev/staging before the real eLinks contract (gaps.md G8.1) is confirmed."
resource: 'epics/phase-0/epic-0.2-joh-elinks-mock-api-stands-in.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-24'
parent: 'epics/phase-0/index.md'
epic: 0.2
title: 'JOH eLinks mock API stands in for the unconfirmed upstream contract'
storyCount: 3
repo: ctam-jomockapi
depends_on: [epic-0.0]
---

# Epic 0.2: JOH eLinks mock API stands in for the unconfirmed upstream contract

**User outcome:** `ctam-reference-data`'s nightly JOH eLinks sync (Story 0.3.3) runs **end-to-end against a live, deployed mock** of the eLinks People API v5 — not just a CI-only WireMock stub — so Phase 0 has a genuine, demoable ingestion pipeline in dev/staging while the real eLinks API contract remains unconfirmed (gaps.md G8.1). `ctam-jomockapi` is onboarded as CTAM Pathfinder's 17th repo, non-production-only, in the same category as `ctam-mock-auth` (repository-strategy.md).

**Hosting:** `ctam-jomockapi` is a standalone Node.js/Express service — an explicitly-scoped deviation from the Java/Spring Boot stack baseline (see gaps.md / assumptions.md A38), justified because it delivers no FR/NFR and never deploys to production. It deploys onto the shared estate provisioned in Epic 0.0, alongside `ctam-mock-auth`.

**Vertical slice:**
- Onboard the existing `ctam-jomockapi` codebase as a CTAM Pathfinder GitHub repo, per the manual GitHub-setup runbook (D10 — no `gh` CLI)
- CI: run its existing test suite (`npm test`), build + push a container image to ACR
- A minimal Helm chart deploying it to dev/staging AKS, fronted by the shared APIM gateway
- A Key-Vault-held mock bearer credential, wired the same way the real eLinks credential will be (NFR16) — the mock itself accepts any non-empty token, so this exercises the *wiring*, not an auth check
- `ctam-reference-data`'s eLinks sync (Story 0.3.3) points its dev/staging base URL at the deployed mock instead of `localhost`

**FRs covered:** none directly (infrastructure/tooling, not a product feature). **Supports:** FR1, FR6 tier-(a), FR7 tier-(a), NFR24 (exercised end-to-end pre-contract).

**Key NFRs first exercised here:** NFR16 (Key Vault credential wiring, dev/staging), NFR31 (Azure UK South), NFR40 (per-service deployable).

**Out of scope (explicitly):**
- The real JOH eLinks API contract (gaps.md G8.1 remains open until Judicial Office confirms it; production cutover is gated on that, not on this epic)
- MRD ingestion (Story 0.8.1) — the mock covers eLinks only, not MRD's Excel feed
- Rewriting `ctam-jomockapi` in Java/Spring — it stays Node/Express as already built
- Production deployment of `ctam-jomockapi` — never (same guard as `ctam-mock-auth`, A27-equivalent)

---

## Story 0.2.1: Onboard `ctam-jomockapi` as a CTAM Pathfinder repo

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

**References:** repository-strategy.md (new row); D10; this story does **not** depend on Epic 0.0 (no deployment yet — Story 0.2.2 needs the estate).

**Explicitly NOT in scope:**
- Deployment to any environment — Story 0.2.2
- Any change to the mock's existing endpoint behaviour, seeded data, or auth handling

---

## Story 0.2.2: Deploy `ctam-jomockapi` onto the shared dev/staging estate

As a **platform engineer**,
I want `ctam-jomockapi` deployed onto the shared Azure estate (Epic 0.0) in dev and staging, with its mock bearer credential held in Key Vault,
So that **it is reachable over the network by `ctam-reference-data`'s scheduled sync job**, not just runnable locally via `npm start`.

**Acceptance Criteria:**

**Given** `ctam-jomockapi` is onboarded per Story 0.2.1, and the shared estate (AKS, ACR, Key Vault, APIM) is provisioned and verified per Epic 0.0,
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
- Wiring `ctam-reference-data`'s sync to this URL — Story 0.2.3
- Production deployment — never, per this epic's out-of-scope note

---

## Story 0.2.3: `ctam-reference-data`'s eLinks sync runs against the deployed mock in dev/staging

As a **CTAM Pathfinder platform** (and every downstream consumer of JOH identity and reference data),
I want Story 0.3.3's nightly `@Scheduled` eLinks sync to run, in dev and staging, against the `ctam-jomockapi` URL deployed in Story 0.2.2,
So that **the full ingestion pipeline — full-refresh-upsert, `ctam_joh_identities` minting, soft-deactivation of records absent upstream, `ctam_sync_status` logging — is demoable end-to-end before the real eLinks contract (G8.1) is confirmed.**

**Acceptance Criteria:**

**Given** `ctam-jomockapi` is deployed per Story 0.2.2, and the Key Vault credential is available to `ctam-reference-data`'s pod,
**When** `ctam-reference-data`'s dev/staging configuration sets the eLinks base URL to the deployed mock's URL instead of any placeholder/localhost value,
**Then** the nightly (and manually-triggered) sync run in Story 0.3.3 completes successfully against it,
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

**References:** FR1, FR6 tier-(a), NFR24; gaps.md G8.1 (stays open); AR46, AR48, AR52; depends on Story 0.3.3 and Story 0.2.2.

**Explicitly NOT in scope:**
- Closing G8.1 — that needs the real contract from Judicial Office
- MRD ingestion (Story 0.8.1) — unaffected, no mock exists or is needed for MRD in this SCP
