---
type: 'Sprint Change Proposal'
description: 'ctam-jomockapi is rebuilt as a Java/Spring Boot service (scaffolded from the same HMCTS template as every other CTAM service) instead of the original Node.js/Express implementation. The existing contract is faithfully ported, not redesigned.'
resource: 'sprint-change-proposal-2026-08-25g.html'
tags: [ctam-pathfinder, sprint-change-proposal]
timestamp: '2026-08-25'
title: 'Sprint Change Proposal — 2026-08-25g'
status: 'approved'
---

# Sprint Change Proposal — 2026-08-25g

**Trigger:** *"Modify epic-0.2 to build the joh-elinks-mock-api using java springboot applications instead of npm"*.

**Mode:** Batch. **Scope classification:** **Minor** — a build-stack change within Epic 0.2's own repo; no cross-epic dependency, FR/NFR, or PRD impact.

---

## 1. Issue Summary

Epic 0.2's `ctam-jomockapi` was previously scoped as an explicitly-recorded deviation from CTAM Pathfinder's Java/Spring Boot stack baseline (assumptions.md A38) — the existing Node.js/Express codebase at the real `ctam-jomockapi` repo was to be onboarded as-is, justified because it delivers no FR/NFR and never reaches production (mirroring `ctam-mock-auth`'s non-production-only exemption). The team now wants it built with Java/Spring Boot instead, like every other CTAM Pathfinder service — removing that stack deviation entirely.

## 2. Impact Analysis

### What changed

- **Story 0.2.1** — retitled from "Onboard `ctam-jomockapi` as a CTAM Pathfinder repo" to "Scaffold `ctam-jomockapi` from the HMCTS starter and port the eLinks mock to Java/Spring Boot." Its ACs are rewritten around `ctam-scaffold.sh` (same pattern as `ctam-reference-data`/`ctam-joh`'s scaffold stories): Spring Boot 4.0.x, Gradle Groovy DSL, Group ID `uk.gov.hmcts.ctam`, artefact `ctam-jomockapi`, base package `uk.gov.hmcts.ctam.jomockapi`, port `8090`. The existing Node/Express reference implementation's documented contract — endpoints, fixed-seed data generation, bearer-token handling, the `ReferenceData/*.csv|json` fixtures — is explicitly scoped as a **faithful port**, not a redesign: same request/response shapes, same seed data, same auth behaviour.
- **Deliberately excluded**, unlike every domain service: Liquibase, Testcontainers PostgreSQL, MapStruct (the mock is stateless — no database, no cross-object mapping need), and a Helm chart / per-service Terraform (it still never deploys anywhere but locally, per SCP 2026-08-25f).
- **Story 0.2.2** — updated for the new stack: port references change from Node's `4000` to the new service's `8090`; the `npm start` comparison in the story's "so that" clause becomes `./gradlew bootRun`.
- **Story 0.2.3** — unaffected; it never referenced Node/npm specifically, only "the local instance," which is stack-agnostic.
- **Epic 0.2's Hosting/vertical-slice/out-of-scope sections** — the "standalone Node.js/Express service — an explicitly-scoped deviation" framing is replaced with "scaffolded like every other CTAM Pathfinder backend service — no stack deviation." The old out-of-scope bullet "Rewriting `ctam-jomockapi` in Java/Spring — it stays Node/Express as already built" is **removed** (it's now the literal opposite of what this epic does) and replaced with two new exclusions: no behavioural contract change during the port, and no database of any kind.
- **assumptions.md A38** — revised in place (not superseded via a new row — this is a living reference document, not a dated record) to describe the Java/Spring Boot build instead of the Node/Express deviation.
- **repository-strategy.md's `ctam-jomockapi` row** — revised to describe a Java/Spring Boot service scaffolded via `ctam-scaffold.sh`, ported from an earlier Node/Express reference implementation.

### Artifact sweep

| Artifact | Change |
|---|---|
| `epic-0.2-joh-elinks-mock-api-stands-in.md` | Stack-change scope-reduction note added; description/User outcome/Hosting/vertical-slice/out-of-scope reworded; Story 0.2.1 fully rewritten (scaffold + faithful port); Story 0.2.2 updated (port 8090, `./gradlew bootRun`) |
| `architecture/assumptions.md` | A38 revised in place |
| `architecture/repository-strategy.md` | `ctam-jomockapi` row revised |
| `architecture.md` | New decision **#20** |
| `architecture/changelog.md` | New **v4.17** entry |
| `sprint-status.yaml` | Story 0.2.1's slug renamed to match the new title |

**Not touched:** `epic-0.3` (its Story 0.3.3 cross-reference to Epic 0.2 doesn't name a tech stack, so it's unaffected by this change — it was already updated for the local-vs-dev/staging change in SCP 2026-08-25f); Story 0.2.3 (stack-agnostic); gaps.md G8.1 (doesn't mention tech stack); `epics/framework.md` (its Epic 0.2 mention doesn't name a stack either); FR/NFR coverage (this mock delivers no FR/NFR directly, unaffected); dated historical SCPs/changelog entries (immutable record).

## 3. Recommended Approach

**Direct implementation.** Effort: **Low** — one story rewritten, one story lightly touched, two reference docs updated in place. **Risk:** Low — `epic-0.2: backlog` in `sprint-status.yaml`, nothing built yet against the old Node-based plan; the actual `ctam-jomockapi` codebase on disk (a real, already-built Node/Express app) is unaffected by this planning-repo change until Story 0.2.1 is actually dispatched and executed against it — at which point the story now instructs a fresh Java/Spring Boot scaffold with the existing app treated as a reference implementation to port, not a codebase to onboard verbatim.

## 4. Detailed Change Proposals

See §2 for the full before/after mapping. Full diffs are in the files themselves.

## 5. Implementation Handoff

**Scope: Minor** — a build-stack change within one epic's own scope, no cross-epic ripple beyond what SCP 2026-08-25f already touched.

**Responsibilities:**
- **Product Owner / stakeholders:** confirm the Java/Spring Boot port is worth the engineering effort versus keeping the existing, already-working Node/Express mock — this SCP does not weigh that trade-off, it only encodes the decision as given.
- **This session:** all edits above applied directly; nothing committed without being asked.

**Success criteria:** Epic 0.2 no longer mentions Node.js/Express as its build stack anywhere except as the explicit port-source; Story 0.2.1's ACs consistently describe a `ctam-scaffold.sh`-based Spring Boot scaffold with a faithful contract port, not an onboarding of the existing codebase as-is; assumptions.md A38 and repository-strategy.md's `ctam-jomockapi` row agree with the epic; `docs/` regenerates cleanly.
