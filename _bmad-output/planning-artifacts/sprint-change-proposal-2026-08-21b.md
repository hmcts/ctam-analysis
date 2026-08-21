---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — resync sprint-status.yaml story keys with the Phase 1 business-readable rewrite'
description: 'Date: 2026-08-21 -- the business-readable rewrite of all ten Phase 1 epics (commit b6f61c4) renamed every story heading but never touched sprint-status.yaml, so every phase-1 story key in the tracking file was a slug generated from a title that no longer exists anywhere in the epics pack. Phase 0 (epics 0.0/0.1) was unaffected and already correct. This SCP regenerates every phase-1 story/epic key from the current epic headings, preserving every existing status value exactly.'
resource: 'sprint-change-proposal-2026-08-21b.html'
tags: [ctam-pathfinder, sprint-change, sprint-status, phase-1]
timestamp: '2026-08-21'
parent: 'planning-artifacts/index.md'
project: 'ctam-analysis (CTAM Pathfinder)'
change_scope: 'Minor — tracking-file key resync only, no epic/story/PRD/architecture content change'
mode: 'Batch'
architectureVersion: 'v4.15'
last_updated: 2026-08-21
---

# Sprint Change Proposal — 2026-08-21 (b)

**Resync `sprint-status.yaml` story keys with the Phase 1 business-readable rewrite**

---

## Section 1 — Issue Summary

**Trigger:** *"update sprint-status.yaml based on the epics"* — a targeted `bmad-correct-course` check, run immediately after SCP 2026-08-21 closed out this branch's documentation trail.

**What was found:** commit `b6f61c4` ("rewrite phase-1 (Foundations) epics in business-readable format") reworded every one of the ten Phase 1 epics' story headings — plain-language titles replacing the original technical, citation-heavy ones — but its own commit message and file list never touched `_bmad-output/implementation-artifacts/sprint-status.yaml`. `bmad-sprint-planning` derives each story's tracking key by slugifying its current heading, so every phase-1 story key in the tracking file was generated from a title that no longer exists in any epic file on this branch. For example, Story 1.9.1's heading is now *"Publish `ctam-architecture` as the official, version-tagged architecture package"* but the tracking file still carried the pre-rewrite key `1-9-1-publish-ctam-architecture-as-the-context-bus-and-tag-arch-v1-0`.

**Scope of the drift:** all 10 phase-1 epics (22 story keys total) plus their epic-level keys' story lists were affected in the sense that every story sub-key needed regenerating; epic-level keys themselves (`epic-1.0` … `epic-1.9`) were already correctly named and untouched. **Phase 0 (`epic-0.0`, `epic-0.1`) was not affected** — those two epics' story titles were finalised before their respective commits (`82b4a75`, `f36ace6`) updated `sprint-status.yaml` in the same commit, so they were already correct going into this check.

**Status values carried forward unchanged** — this was purely a key-naming resync, not a status change:

| Key | Status before and after |
|---|---|
| `epic-1.9` | `in-progress` |
| Story 1.9.1 (renamed key) | `done` |
| Every other epic and story | `backlog` |

Confirmed against the epics pack itself: `epics/phase-1/index.md`'s own status table shows Epic 1.9 as 🟢 *In progress* and every other Phase 1 epic as 🟡 *Planned* — consistent with what `sprint-status.yaml` already recorded, so no status was misattributed by this fix.

**Verified no other file references the stale keys:** a repo-wide grep for several of the old phase-1 slugs (e.g. `1-0-1-scaffold-ctam-shared-infrastructure…`, `1-9-1-publish-ctam-architecture-as-the-context-bus…`) found no hits outside `sprint-status.yaml` itself — no story packet exists yet in any of the 16 execution-unit repos (nothing has been dispatched), and no other planning doc hardcodes a story key. Low risk to fix in place.

---

## Section 2 — Impact Analysis

### 2.1 Epic impact

None. No epic's scope, stories, ACs, `depends_on`, or status changes.

### 2.2 Story impact

All 22 Phase 1 story keys renamed to match their current headings (Section 4 below has the full before/after). No story's content, acceptance criteria, or status changes — this is a tracking-file key rename only.

### 2.3 Artifact conflicts / cross-reference sweep

Only `_bmad-output/implementation-artifacts/sprint-status.yaml` needed a change. Nothing else in the repo references these keys (verified by grep above), so there is no cascading fix required — unlike the epics/-numbering SCPs, this drift was fully contained to one generated file.

### 2.4 Technical impact

None — no code exists in any of the 16 execution-unit repos; nothing has been dispatched against any of the stale keys.

---

## Section 3 — Recommended Approach

**Direct adjustment.** Regenerate every phase-1 story key from the current epic headings using the same slugification convention already visible elsewhere in the file (lowercase; strip backticks/quotes/parens/commas; convert remaining punctuation, including periods and slashes, to hyphens; collapse to single hyphens), preserving every existing status value by key meaning rather than by literal key string. Bump `last_updated` to 2026-08-21.

**Effort:** Low — a mechanical, well-verified rename. **Risk:** Low — no status changes, no external references broken (verified above), nothing dispatched.

---

## Section 4 — Detailed Change Proposals

### 4.1 `_bmad-output/implementation-artifacts/sprint-status.yaml` — all 22 Phase 1 story keys

| Epic | Old key (stale) | New key (current heading) | Status (unchanged) |
|---|---|---|---|
| 1.0 | `1-0-1-scaffold-ctam-shared-infrastructure-and-establish-the-terraform-foundation` | `1-0-1-the-shared-repository-and-its-safe-change-management-process-are-set-up` | backlog |
| 1.0 | `1-0-2-provision-networking-and-the-aks-cluster-dev-verifiable-via-kubectl` | `1-0-2-the-network-and-the-kubernetes-cluster-are-built-and-checked-development-environment` | backlog |
| 1.0 | `1-0-3-provision-postgresql-and-key-vault-dev-verifiable-over-tls-from-the-cluster` | `1-0-3-the-shared-database-and-secrets-vault-are-built-and-checked-development-environment` | backlog |
| 1.0 | `1-0-4-provision-acr-and-observability-dev-verifiable-via-image-pull-and-a-test-trace` | `1-0-4-the-container-registry-and-monitoring-setup-are-built-and-checked-development-environment` | backlog |
| 1.0 | `1-0-5-provision-apim-dev-verifiable-end-to-end-via-a-smoke-api-over-tls` | `1-0-5-the-api-gateway-is-built-and-checked-end-to-end-development-environment` | backlog |
| 1.1 | `1-1-1-scaffold-ctam-reference-data-from-the-hmcts-starter-onto-the-epic-1-0-estate` | `1-1-1-scaffold-ctam-reference-data-from-the-hmcts-starter-template` | backlog |
| 1.1 | `1-1-2-tier-a-upstream-jo-tables-ctam-sync-status-and-tier-a-write-protection` | `1-1-2-the-15-outside-sourced-tables-exist-with-write-access-locked-to-this-service-alone` | backlog |
| 1.2 | `1-2-1-joh-reference-data-flows-into-ctam-nightly-from-the-joh-elinks-api` | `1-2-1-joh-reference-data-flows-into-ctam-nightly-from-the-joh-elinks-feed` | backlog |
| 1.3 | `1-3-1-mrd-supplementary-reference-data-is-ingested-from-the-weekly-excel-feed` | *(unchanged — already matched)* | backlog |
| 1.4 | `1-4-1-scaffold-ctam-authorisation-service-from-the-hmcts-crime-springboot-template` | *(unchanged — already matched)* | backlog |
| 1.4 | `1-4-2-user-can-authenticate-against-ctam-mock-auth-and-receive-a-jwt` | `1-4-2-user-can-authenticate-against-ctam-mock-auth-and-receive-a-security-token` | backlog |
| 1.4 | `1-4-3-ctam-authorisation-validates-jwts-and-resolves-identity-roles-jurisdiction-region-area-scope-read-only-api` | `1-4-3-ctam-authorisation-validates-security-tokens-and-resolves-identity-roles-jurisdiction-and-region-area-scope-read-only-api` | backlog |
| 1.4 | `1-4-4-scaffold-ctam-ui-repo-with-react-typescript-vite-gov-uk-base-auth-wrapper` | `1-4-4-scaffold-ctam-ui-repo-with-react-typescript-vite-a-gov-uk-based-design-system-and-an-auth-wrapper` | backlog |
| 1.4 | `1-4-5-user-signs-into-ctam-pathfinder-via-sso-and-lands-on-a-role-scoped-home-page` | `1-4-5-user-signs-into-ctam-pathfinder-via-single-sign-on-and-lands-on-a-role-scoped-home-page` | backlog |
| 1.5 | `1-5-1-tier-b-ctam-owned-reference-tables-seed-data-and-the-dba-maintenance-runbook` | *(unchanged — already matched)* | backlog |
| 1.5 | `1-5-2-reference-data-read-only-rest-api-with-jurisdiction-filtering-versioning-openapi-rfc-9457-errors` | *(unchanged — already matched)* | backlog |
| 1.6 | `1-6-1-mrd-reference-data-joh-specialisms-is-exposed-via-the-reference-data-read-only-api` | `1-6-1-joh-specialisations-are-made-available-through-the-reference-data-read-only-api` | backlog |
| 1.7 | `1-7-1-identity-seed-scripts-both-populations-bootstrap-verification-job-and-the-production-bootstrap-runbook` | `1-7-1-both-groups-of-users-can-be-seeded-verified-against-the-sign-in-system-and-set-up-for-real-via-a-runbook` | backlog |
| 1.8 | `1-8-1-scaffold-ctam-notification-service-delivery-log-table-smtp-integration` | `1-8-1-the-notification-service-its-delivery-history-table-and-its-connection-to-email-are-set-up` | backlog |
| 1.8 | `1-8-2-post-v1-notifications-send-endpoint-with-jwt-propagation-retry-semantics-delivery-logging-rfc-9457-errors` | `1-8-2-the-send-an-email-endpoint-delivers-retries-and-logs-every-request-with-a-way-to-review-what-was-sent` | backlog |
| 1.9 | `1-9-1-publish-ctam-architecture-as-the-context-bus-and-tag-arch-v1-0` | `1-9-1-publish-ctam-architecture-as-the-official-version-tagged-architecture-package` | **done** |
| 1.9 | `1-9-2-shared-ctam-configuration-values-liquibase-baseline-with-per-service-select-grants` | `1-9-2-shared-configuration-table-exists-with-read-only-access-for-every-service` | backlog |

Epic-level keys (`epic-1.0` … `epic-1.9`) and retrospective keys are unchanged — only their nested story sub-keys moved. `last_updated` bumped 2026-08-20 → 2026-08-21.

### 4.2 `architecture/changelog.md` — new entry (v4.15)

Records this resync for the same reason every other tracking-consistency fix on this branch has one: traceability for a change to a canonical, git-tracked file.

---

## Section 5 — Implementation Handoff

**Scope classification: Minor.** Direct implementation by the Developer agent (this session).

**Success criteria:**
- Every phase-1 story key in `sprint-status.yaml` matches the slug of its epic's current heading.
- `epic-1.9` remains `in-progress`, its renamed Story 1.9.1 key remains `done`, every other key remains `backlog` — no status silently changed.
- `architecture/changelog.md` carries a v4.15 entry.
- `docs/` regenerated so the new SCP page is built and linked from the site navigation.
