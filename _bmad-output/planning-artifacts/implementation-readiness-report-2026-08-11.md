---
stepsCompleted: ['step-01-document-discovery', 'step-02-prd-analysis', 'step-03-epic-coverage-validation', 'step-04-ux-alignment', 'step-05-epic-quality-review', 'step-06-final-assessment']
scope: 'epic phase-0'
---

# Implementation Readiness Assessment Report

**Date:** 2026-08-11
**Project:** ram-analysis (RAM Pathfinder)
**Scope:** Epic Phase 0 (Foundations)

## Document Inventory

### PRD

**Whole document (in use):**
- `prd.md` (124,468 bytes, modified 2026-08-07 12:19)

**Historical (not the active PRD — dated validation reports, immutable records):**
- `prd-validation-report-2026-06-10.md`
- `prd-validation-report-2026-06-17.md`

### Architecture

**Whole document (entry point):**
- `architecture.md` (100,815 bytes, modified 2026-08-07 12:07) — per project convention, this is the canonical entry point linking to sharded topic files below, not a duplicate of them.

**Sharded (`architecture/`):**
- `assumptions.md`, `changelog.md`, `conventions.md`, `data-tables.md`, `delivery-operating-model.md`, `functional-requirements-coverage.md`, `gaps.md`, `non-functional-requirements-coverage.md`, `repo-structure.md`, `repository-strategy.md`, `starter-template.md`, `user-types.md`
- `analysis/` (subfolder), `diagrams/`, `sequence-diagrams/`

**⚠️ Needs confirmation — possible duplicate:**
- `architecture-summary.md` (23,476 bytes, modified 2026-08-07 12:07) exists alongside `architecture.md`. Need to confirm this is an intentional distilled summary (e.g. for onboarding/context-bus seeding) rather than a stale/competing full copy.

### Epics & Stories (sharded — `epics/`)

- `index.md` — programme entry point
- `framework.md` — Phase × Area architectural framework
- `requirements-inventory.md` — FR/NFR/AR inventory
- `fr-coverage-map.md` — FR → Epic traceability
- `phase-0/index.md` + 6 epic files:
  - `epic-0.0-platform-estate-provisioned.md`
  - `epic-0.1-upstream-reference-data-ingested.md`
  - `epic-0.2-user-authenticates.md`
  - `epic-0.3-reference-data-read-only-api.md`
  - `epic-0.4-user-populations-bootstrapped.md`
  - `epic-0.5-system-dispatches-emails.md`

No duplicates found (whole `epic*.md` files do not exist alongside the sharded folder).

### UX Design Documents

**Not present — documented, accepted gap.** `epics/index.md` explicitly records `uxDocument: 'not-present-accepted-gap'` and notes downstream epics inherit UI requirements directly from PRD FR55/FR56 and GOV.UK Design System conventions (NFR17). This is a known, pre-accepted condition, not an oversight — will be verified in Step 4 (UX Alignment), not re-litigated as a missing-document blocker here.

## Issues Found

1. **⚠️ Needs your confirmation:** `architecture-summary.md` vs `architecture.md` — please confirm which is authoritative for this assessment (expected: `architecture.md` + shards; `architecture-summary.md` treated as a derived artifact only).
2. **No blocking duplicates** in PRD or Epics.
3. **UX gap is pre-accepted** per documented decision — carried forward as context, not flagged as missing.

## PRD Analysis

*Source: `prd.md` (read in full, 872 lines), cross-checked against `architecture/functional-requirements-coverage.md`, `architecture/non-functional-requirements-coverage.md`, `epics/requirements-inventory.md`.*

### Functional Requirements Extracted

**Total: 60 (FR1–FR60), verified contiguous, no gaps or duplicates.** Full text captured for all 60; grouped by domain area in the PRD: Identity & Authorisation (FR1–FR5), Foundational Data Management (FR6–FR9), JOH Records & Working Patterns (FR10–FR18), Absence Workflow (FR19–FR22), Vacancy & Cover (FR23–FR28), Booking Management (FR29–FR34), Sitting Management (FR35–FR40), Payment & Reconciliation (FR41–FR47), Itineraries & Reporting (FR48–FR54), Platform Operations & Migration (FR55–FR60).

**Phase 0 draws exclusively from three groups: FR1–FR9 (Identity/Authorisation + Foundational Data) and FR55–FR59 (Platform Operations), consistent with D1's locked Phase 0 scope.** FR10–FR54 and FR60 belong to Phases 1–9+ and are correctly out of Phase 0 scope (see Epic Coverage Validation below).

Key Phase-0-relevant FR texts (verbatim from `prd.md`):

- **FR1**[^d11][^d9]: Authenticated users access RAM Pathfinder via HMCTS IdP single sign-on; password, session, and account lifecycle are owned by the IdP. At authentication time, the IdP email is resolved to RAM Pathfinder's canonical identifier — the **personal number** (JOH, via `jo_people`) or a RAM-internal staff identifier (admin staff).
- **FR2**[^d8][^d11]: Authorisation service maps each authenticated principal to roles + jurisdiction + Region/Area scope; authorises every system call against that mapping.
- **FR3**: Authorised users can retrieve their effective permissions for their authenticated session.
- **FR4**[^d10][^d11]: System administrators can update role/jurisdiction/Region-Area assignments. MVP: DBA-via-SQL; admin-UI surface post-MVP.
- **FR5** *(post-MVP)*: Machine-to-machine auth mechanism — no M2M consumers in MVP scope; open question tracked as gap G7.
- **FR6**[^d10][^d11]: Two-tier Reference Data — (a) upstream-sourced (JOH eLinks + MRD, read-only in RAM, corrections at source), (b) RAM-owned (DBA-via-SQL in MVP, admin UI post-MVP). RSU users view both tiers via `ram-reference-data`'s versioned read API.
- **FR7**[^d11]: Every service reads Reference Data via direct SQL on the shared schema (SELECT-granted per DB role); writes follow the tier.
- **FR8** *(revised v2.2)*: Shared `ram_configuration_values` table for cross-service runtime policy values, Liquibase-managed, SELECT-granted to every service.
- **FR9**: Transactional email dispatch (booking/absence acknowledgements, payment schedules) via HMCTS email infrastructure, with delivery log.
- **FR55**: Authenticated users land on a role-scoped Home page (navigation, Region/Area selector, summary tiles, contextual help).
- **FR56**[^d10]: `ram-ui` (business-user SPA) replicates the as-is APEX functional surface, WCAG 2.2 AA. MVP = `ram-ui` only; `ram-admin-ui` post-MVP.
- **FR57**[^d10][^d11]: Per-jurisdiction, per-region phased activation via `ram_auth_user_activation_flags`; all-FALSE at bootstrap; per-wave DBA flip at cutover.
- **FR58**: Every service exposes a versioned API contract, RFC 9457 problem-details, published OpenAPI; `Deprecation`/`Sunset` headers (RFC 9745/8594).
- **FR59**: Every service emits structured logs with correlation IDs and consistent error categorisation.
- **FR60**[^d11][^d5] *(Phase 9+, not Phase 0, but load-bearing context)*: Manual incumbent-parity UAT script per domain service, per wave. Wave 1 (ET): `[ET-INCUMBENT-TBD]`-experienced users, role set provisional pending G8.5, panel blocked on G8.4.

### Non-Functional Requirements Extracted

**Total: 42 (NFR1–NFR42), verified contiguous, no gaps.** Grouped: Performance (NFR1–9), Security (NFR10–16), Accessibility (NFR17–19), Integration (NFR20–24), Observability (NFR25–29), Data Privacy & Sovereignty (NFR30–33), Reliability & Availability (NFR34–38), Maintainability (NFR39–42).

**Cross-cutting NFRs verified across Phase 0 stories** (per `epics/phase-0/index.md`): NFR10 (TLS), NFR11 (data-at-rest), NFR12 (JWT propagation), NFR13 (authz enforcement incl. jurisdiction), NFR14 (no forbidden data), NFR15 (change trails), NFR16 (Key Vault), NFR17–19 (business UI WCAG — admin UI deferred), NFR20 (HMCTS IdP via mock), NFR22 (HMCTS email), NFR24 (JOH eLinks + MRD MVP integrations), NFR25–28 (observability), NFR31 (Azure UK South), NFR39 (API-as-Product), NFR40 (per-service deployable), NFR42 (Postman collections).

Notably **NFR20 — HMCTS IdP integration is a hard Phase 0 dependency** (OIDC or SAML, whichever the IdP exposes) — Epic 0.2 substitutes `ram-mock-auth` for Phase 0–8, deferring the real IdP integration decision; this is a known, accepted architectural stance (AR35), not a Phase 0 gap, but worth carrying forward as a pre-Phase-9 cutover dependency.

### Additional Requirements

**Decisions log (D1–D13)** — D1 locks Phase 0 scope; D3 (no data migration, upstream ingestion only); D9 (two user populations, RAM-assigned UUIDs); D10 (admin UI post-MVP, DBA-via-SQL runbooks); D13 (2026-08-07, supersedes D11) — **ET-first pilot**, wave 1 = ET, wave 2 = SSCS, waves 3+ = Courts; reworded ~12 FR/NFRs without renumbering or epic restructuring (Phase 0 stays at 6 epics / 19 stories).

**Architecture-derived requirements (AR) directly relevant to Phase 0:** AR23/AR53 (Terraform-provisioned shared Azure estate, Epic 0.0), AR46–AR49 (JOH eLinks nightly sync, MRD weekly ingestion, sync-status tracking, tier-(a) write protection via DB grants + ArchUnit), AR34–AR36 (`JWTFilter` + `authz/check`, `ram-mock-auth` as dev/CI OIDC issuer, `client_credentials` for batch), AR18/AR22 (shared schema, direct-SQL cross-service reads, no client class/cache), AR52 (identity bootstrap + verification job), AR30–AR33 (notification dispatch + structured logging/OTel wiring).

**Open gaps material to Phase 0/wave-1 readiness:** **G8.4** (ET scheduling incumbent unidentified — blocks D5 behavioural reference, FR60/NFR41 UAT target, NFR36 rollback target, NFR32 historical-data location), **G8.5** (ET role/JOH-type taxonomy provisional, pending an as-is analysis pack that does not yet exist), **G8.6** (JFEPS/Liberata applicability to ET unverified), **G8.1** (promoted to wave-1 blocker — JOH eLinks must be confirmed to carry ET data), **G7/G7.1** (post-MVP service-principal auth mechanism open), **G3.6** (disaster-recovery scope open), **G1.3** (bootstrap-verification job detail), **G5.3** (`ram-mock-auth` production-profile refusal behaviour).

### PRD Completeness Assessment

The PRD is structurally sound: FR/NFR numbering is contiguous and complete, both architecture coverage documents independently confirm 100% architectural support with none unaddressed, and the D13 change cascade explicitly enumerates exactly which FRs/NFRs were reworded for the ET-first pivot without touching numbering, epics, or code — a disciplined, traceable change record.

**None of the Phase-0-relevant FRs/NFRs (FR1–FR9, FR55–FR59, NFR24 + cross-cutting NFRs) are themselves blocked by G8.4–G8.6** — those gaps bite at the wave-1/Phase-9 cutover gate, not at Phase 0 build. Phase 0 is buildable as scoped.

**Two findings worth carrying into the final assessment:**
1. **🟡 Minor — FR1 wording drift.** `prd.md`'s FR1 text states the canonical identifier is the **personal number**; `architecture/functional-requirements-coverage.md` and `epics/requirements-inventory.md` both state it is the **RAM JOH UUID** (`jo_people` → `personnel_number` → `ram_joh_identities`) — the latter reflects the D9 refinement dated 2026-07-09, which was not backfilled into `prd.md`'s own FR1 text. The artifacts agree in substance (personnel_number is the upstream *link*, not the canonical RAM identifier) but are not word-for-word aligned. Low risk — a documentation-sync fix, not a design ambiguity — but flag for correction before Phase 0 story implementation to avoid an agent taking `prd.md`'s FR1 literally.
2. **⚪ Informational — Journey 1 (wave-1 ET journey) is explicitly marked "PROVISIONAL — structural placeholder"** in the PRD's own text, consistent with G8.4/G8.5. Not a Phase 0 blocker (Phase 0 has no ET-specific content), but confirms the provisional-taxonomy caveat in `CLAUDE.md` is accurately reflected upstream.

## Epic Coverage Validation

### Epic FR Coverage Extracted (from `epics/fr-coverage-map.md`, the canonical FR→Epic index)

| FR/NFR | Phase 0 Epic Coverage |
|---|---|
| FR1 | Epic 0.2 (Stories 0.2.3/0.2.5) + Epic 0.1 (`jo_people` ingested) + Epic 0.4 (auth records) |
| FR2 | Epic 0.2 Story 0.2.3 |
| FR3 | Epic 0.2 Story 0.2.3 |
| FR4 | Epic 0.4 (data layer only; UI post-MVP) |
| FR5 | — (post-MVP, intentional pre-existing deferral) |
| FR6 | Epic 0.1 Story 0.1.2/0.1.3/0.1.4 (tier a) + Epic 0.3 Story 0.3.1/0.3.2 (tier b + read API) |
| FR7 | Epic 0.1 Story 0.1.2 (tier-a grants) + Epic 0.3 Story 0.3.1 (tier-b grants) |
| FR8 | Epic 0.1 Story 0.1.1 |
| FR9 | Epic 0.5 |
| FR55 | Epic 0.2 Story 0.2.5 |
| FR56 | Epic 0.2 (business stack; admin stack post-MVP) |
| FR57 | Epic 0.4 (initial flag state; cutover flip is Phase 9+) |
| FR58 | Epic 0.2 Story 0.2.3 + Epic 0.3 Story 0.3.2 + every service story |
| FR59 | Epic 0.1 Story 0.1.1 + every service story |
| NFR24 | Epic 0.1 Stories 0.1.3/0.1.4 |

**Total FRs claimed covered by Phase 0 epics: 13 of 60 FR numbers touched (FR1–FR4, FR6–FR9, FR55–FR59), plus NFR24 and the cross-cutting NFR cohort listed above.** This matches exactly what a Phase 0 (foundations-only) scope should cover — no domain-service FRs (FR10–FR54) or the wave-rollout FR60 are expected here.

### FR Coverage Analysis (Phase-0-relevant scope only)

| FR/NFR | PRD Requirement (gist) | Epic Coverage | Status |
|---|---|---|---|
| FR1 | IdP SSO → canonical identifier resolution | Epic 0.1 + 0.2 (0.2.3/0.2.5) + 0.4 | ✓ Covered |
| FR2 | Authorisation: roles + jurisdiction + scope | Epic 0.2 (0.2.3) | ✓ Covered |
| FR3 | Effective-permissions lookup | Epic 0.2 (0.2.3) | ✓ Covered |
| FR4 | Admin role/jurisdiction/scope updates | Epic 0.4 (data layer only) | ✓ Covered *(MVP scope: DBA-via-SQL, matches D10 — UI surface correctly excluded)* |
| FR5 | M2M auth mechanism | — | ⚪ Correctly excluded — pre-existing post-MVP deferral (PRD v2.5), not a Phase 0 gap |
| FR6 | Two-tier Reference Data view + maintenance | Epic 0.1 (tier a) + Epic 0.3 (tier b + read API) | ✓ Covered |
| FR7 | Direct-SQL cross-service reads | Epic 0.1 + Epic 0.3 | ✓ Covered |
| FR8 | Shared `ram_configuration_values` | Epic 0.1 (0.1.1) | ✓ Covered |
| FR9 | Transactional email + delivery log | Epic 0.5 | ✓ Covered |
| FR55 | Role-scoped Home page | Epic 0.2 (0.2.5) | ✓ Covered |
| FR56 | `ram-ui` business SPA, WCAG 2.2 AA | Epic 0.2 | ✓ Covered *(admin stack correctly deferred per D10)* |
| FR57 | Per-jurisdiction/region activation flags | Epic 0.4 (initial state only) | ✓ Covered *(cutover flip correctly deferred to Phase 9+ per D8/D13)* |
| FR58 | API-as-Product standards | Epic 0.2 + Epic 0.3 + every story | ✓ Covered |
| FR59 | Structured logging + correlation IDs | Epic 0.1 (0.1.1) + every story | ✓ Covered |
| NFR24 | JOH eLinks + MRD MVP integration | Epic 0.1 (0.1.3/0.1.4) | ✓ Covered |
| FR10–FR54 | Domain-service FRs (JOH, Absence, Vacancy, Booking, Sitting, Payment, Itinerary, MI) | — | ⚪ Correctly out of scope — Phases 1–8 per `fr-coverage-map.md` |
| FR60 | Wave-rollout manual UAT | — | ⚪ Correctly out of scope — Phase 9+ per `fr-coverage-map.md` |

### Missing FR Coverage

**None found.** Every FR/NFR that D1 assigns to Phase 0 has a named epic and, in most cases, a named story. No orphaned Phase-0-relevant FR, and no epic claims coverage of an FR that doesn't exist in the PRD (spot-checked against the verified 60-FR/42-NFR count from PRD Analysis above).

One **traceability nuance, not a gap:** FR58 and FR59 are each covered by an explicit story (0.2.3/0.3.2 and 0.1.1 respectively) *and* reasserted as "every service story" — this is intentional (API-as-Product standards and structured logging are cross-cutting non-functional patterns every story must satisfy, not one-off features), but a reviewer unfamiliar with the pattern could misread "every service story" as vague hand-waving. Recommend Epic 0.1/0.2/0.3 story ACs each explicitly re-affirm FR58/FR59 compliance (even one line) so the traceability claim is checkable story-by-story, not just asserted at the epic level.

### Coverage Statistics (Phase 0 scope)

- Total PRD FRs: 60 (+ 42 NFRs)
- FRs in Phase 0's declared scope (D1): 13 FR numbers (FR1–FR4, FR6–FR9, FR55–FR59) + NFR24 + ~16 cross-cutting NFRs
- FRs covered by Phase 0 epics: 13 of 13 (100% of in-scope FRs)
- FRs correctly deferred to later phases: 47 (FR5, FR10–FR54, FR60) — all traced to a named future phase in `fr-coverage-map.md`, none silently dropped
- **Coverage percentage (Phase-0-scoped FRs): 100%**

## UX Alignment Assessment

### UX Document Status

**Not found** — and, per the document inventory, this is a pre-existing, explicitly documented decision (`epics/index.md` frontmatter: `uxDocument: 'not-present-accepted-gap'`), recorded originally in the 2026-05-06 readiness report. This is not a fresh finding; it is being re-verified against current PRD/Architecture content below.

### Is UX/UI implied?

Yes. The PRD is explicit about a business-facing UI:

- **FR55** — authenticated users land on a role-scoped Home page (navigation, Region/Area selector, summary tiles, contextual help).
- **FR56** (footnoted D10) — `ram-ui` (business-user SPA) replicates the functional surface of the as-is APEX UI and must meet **WCAG 2.2 Level AA**. `ram-admin-ui` is explicitly **post-MVP** per D10 — so Phase 0 only needs to support `ram-ui`.
- **NFR17** (WCAG 2.2 AA, tested per UI page per domain phase gate), **NFR18** (assistive-tech: keyboard nav, ARIA, screen-reader), **NFR19** (Public Sector Bodies Accessibility Regulations 2018, incl. published accessibility statement).

### Alignment check — PRD ↔ Architecture

- Architecture/`project-context.md` mandates **React 18 + TypeScript 5 + Vite 5 + GOV.UK Design System** specifically *because* it's the accessibility-compliant base for WCAG 2.2 AA (NFR17) — direct traceability from NFR to tech choice, no gap.
- Epic 0.2 (`User authenticates and lands on a role-scoped Home page`) is the Phase 0 vehicle for FR55/FR56/NFR17 — a role-scoped Home page is its stated demoable outcome.
- No UX document means there is **no independently-authored user-journey / wireframe / interaction-design artifact** to check epics against — the epics inherit UI requirements directly from PRD prose + GOV.UK Design System conventions instead of a UX spec. For a role-scoped Home page (Epic 0.2) this is a thin surface and low risk. It becomes higher-risk **from Phase 1 onward** as `ram-ui` grows more screens (absence, vacancy, booking, sitting, payment, itinerary, MI) without a UX artifact to keep those journeys consistent — worth flagging as a forward risk, not a Phase-0 blocker.

### Warnings

⚠️ **Carried-forward, not new:** absence of a UX document remains an accepted gap for Phase 0 (thin UI surface: sign-in → Home page). **Recommend revisiting before Phase 1 story creation** (Absence domain), once `ram-ui` gains real user workflows beyond a single landing page — at that point GOV.UK Design System conventions alone may not be sufficient to keep multi-screen journeys coherent.

No NEW alignment issues found between PRD, Architecture, and the (documented-absent) UX layer for Phase 0 scope.

## Epic Quality Review

*Standard applied: create-epics-and-stories best practices (user value focus, epic independence, no forward dependencies, story sizing, BDD acceptance criteria, DB-creation timing, starter-template usage, greenfield indicators). All 6 Phase 0 epic files + `index.md` + `framework.md` read in full.*

### Epic Structure Validation

Phase 0's 6 epics / 19 stories are unusually well-documented — every epic states FRs/NFRs covered, an explicit "out of scope" list, and traces back to architecture decisions (D3/D8/D9/D10/D13, AR-numbers, gaps.md). That rigor is a genuine strength. However, the review surfaced **one systemic, epic-breaking sequencing defect** (Epics 0.2 and 0.3 both have hard functional dependencies on Epic 0.4, which is sequenced *after* them), plus several concrete factual/titling defects.

### Story Quality Assessment

- **AC form:** All 19 stories consistently use Given/When/Then BDD structure — no vague ACs found; consistently measurable (`kubectl get nodes` Ready, specific HTTP status codes, specific response shapes/file paths).
- **Error/failure-path coverage:** Consistently present and above the checklist bar — TLS-refused checks, sync-failure rollback, workbook-validation rejection, 400/401/403/405 paths, non-activated-user rejection.
- **Story sizing:** Each story is a coherent, shippable unit; no forward references *within* an epic.
- **Cross-epic story coupling:** This is where the real problems live — see Dependency Analysis.

### Dependency Analysis

Declared chain (`index.md`): `0.0 → 0.1 → 0.2 → 0.3 → 0.4 → 0.5`.

| Edge | Direction | Verdict |
|---|---|---|
| 0.1 → 0.0 | backward | ✅ fine |
| 0.1 → 0.2 (Story 0.1.3, AC3) | forward | 🟠 soft/testability issue |
| 0.2 → 0.1 | backward | ✅ fine |
| **0.2 → 0.4** (Stories 0.2.3, 0.2.5) | **forward** | 🔴 hard functional dependency |
| 0.3 → 0.2 | backward | ✅ fine |
| **0.3 → 0.4** (Story 0.3.2) | **forward** | 🔴 hard functional dependency (same root cause) |
| 0.4 → 0.2 (Story 0.4.1, closing AC) | forward | 🟠 soft/testability issue |
| 0.5 → 0.2 | backward | ✅ fine — 0.4 already precedes 0.5 |

**Core problem:** Epic 0.2 Story 0.2.3's own scope note states *"the auth tables are created here; they're populated by Epic 0.4's seed scripts ... not by API writes."* Yet 0.2.3's happy-path ACs require exactly that seeded data to exist (`POST /v1/authz/check` resolving a test JOH to roles/jurisdiction/regions/areas/activation state); Story 0.2.5 needs a seeded non-activated user to demo the activation banner; Story 0.3.2 needs seeded users in two different jurisdictions to demo jurisdiction-filtering. Since Epic 0.4 (which owns this seeding) is sequenced *after* 0.2 and 0.3, neither can be demoed or CI-verified end-to-end in isolation — contradicting the stated epic-independence model and the Phase 0 demo-gate claim in `index.md`. Not a circular dependency (0.4 doesn't need 0.2/0.3 to deliver its own value), but the two are mutually entangled for end-to-end verification.

### Best Practices Compliance Checklist (summary — full per-epic checklist available on request)

| Epic | User Value | Independence | Sizing | ACs | DB Timing | Starter Template | Greenfield | Traceability |
|---|---|---|---|---|---|---|---|---|
| 0.0 Platform estate | ✅ (foundations exception) | ✅ | ✅ | ✅ | N/A | N/A (Terraform-only) | ✅ | ~ (minor: log-retention sign-off pending) |
| 0.1 Reference data ingested | ✅ | ~ (soft fwd-ref, Finding 4) | ✅ | ✅ | ~ (minor, Finding 7) | ✅ | ✅ | ✅ |
| 0.2 User authenticates | ✅ | ❌ **fails** (Finding 1) | ✅ | ✅ | ✅ | ✅ | ✅ | ~ (Findings 2, 6) |
| 0.3 Reference data read API | ✅ | ❌ **fails** (Finding 1, same root cause) | ✅ | ✅ | ~ (minor, Finding 7) | N/A (reuses 0.1's service) | N/A | ✅ |
| 0.4 User populations bootstrapped | ✅ | ✅ (its own fwd-ref is soft, Finding 5) | ✅ | ✅ | N/A | N/A | N/A | ✅ |
| 0.5 Notification service | ~ **title drift** (Finding 3) | ✅ (only epic where ordering fully works) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

### Findings by Severity

**🔴 Critical**

1. **Epic 0.2 and Epic 0.3 have a hard forward dependency on Epic 0.4 — sequencing is functionally broken.** Stories 0.2.3, 0.2.5, and 0.3.2 all require seeded identity/authorisation data that, per the epics' own text, is Epic 0.4's deliverable — but Epic 0.4 is sequenced two epics later. Neither Epic 0.2 nor 0.3 can be demoed or CI-verified end-to-end as currently sequenced. **Remediation (either):** (a) split Epic 0.4 into a "dev/CI seed data" sub-story pulled forward to immediately follow Epic 0.2's schema story, leaving the full bootstrap-verification job + production runbook in place at 0.4; or (b) add a minimal seed-fixture sub-story inside Epic 0.2 itself (mirroring the fixture pattern Epic 0.1 already uses for `jo_*` data per AR52), reserving Epic 0.4 for the full verification job and production runbook only.

**🟠 Major**

2. **Default port `8082` is identically assigned to three unrelated services** — Story 0.1.1 (`ram-reference-data`), Story 0.2.1 (`ram-authorisation`), and Story 0.5.1 (`ram-notification`) all state "default port is 8082 (per AR3)." Looks like a copy-paste artifact rather than a deliberate per-service convention; will collide in any local multi-service dev/CI stack — which Phase 0's own demo gate requires. **Remediation:** verify the intended per-service port table in `architecture/conventions.md` (AR3) and correct each story before scaffolding.
3. **Epic 0.5's title drifts toward a technical-milestone framing** — filename `epic-0.5-system-dispatches-emails.md` is user/outcome-framed, but the actual title is "Notification service is scaffolded and contractually ready" (the exact "disguised technical milestone" pattern the standard flags), even though the underlying content (`POST /v1/notifications/send` → Mailpit) is genuinely demoable. **Remediation:** retitle to match filename intent, e.g. "System dispatches transactional emails via a versioned, contract-published API."
4. **Epic 0.1 Story 0.1.3's AC forward-references Epic 0.2 Story 0.2.3** as its own verification mechanism ("When `ram-authorisation` (Epic 0.2, Story 0.2.3) looks up a seeded JOH email..."), making 0.1.3 not independently verifiable as written. **Remediation:** move this AC into Epic 0.2 Story 0.2.3 as a *Given* precondition, not one of 0.1.3's own completion criteria.
5. **Epic 0.4 Story 0.4.1's closing AC has the same forward-reference pattern in reverse** ("When the Epic 0.2 Playwright suite executes...") — same issue as Finding 4, and combined with Finding 1 shows 0.2 and 0.4 are mutually entangled for verification despite being modeled as independent sequential epics. **Remediation:** reframe as an epic-level cross-reference in `index.md`, not a story-level AC.
6. **`framework.md`'s FR attribution is inconsistent with the concrete epics for FR4** — `framework.md`'s Identity & Authorisation Area row lists FR4, but the concrete Epic 0.2 does not claim FR4 (it's delivered by Epic 0.4 instead). A reader cross-checking `framework.md` against the Phase 0 epics would reasonably but incorrectly conclude FR4 lands in Epic 0.2. **Remediation:** correct `framework.md`'s Area table or add a cross-reference footnote.

**🟡 Minor**

7. Bulk-style table creation within single stories (Story 0.1.2: 15 `jo_*` tables + `ram_sync_status`; Story 0.3.1: 15 tier-(b) tables, both in one changeset) — each set is consumed by the very next story so this is likely acceptable, but larger than the checklist's per-need principle would ideally prefer; worth a light check that no individual table sits unused for more than one story.
8. **`ram_configuration_values` Liquibase baseline (FR8) has no owning story in Phase 0** — Stories 0.1.1 and 0.2.1 both treat it as a pre-existing *Given* attributed to `ram-architecture`, but no Phase 0 epic/story actually delivers it as tracked work. If this has real implementation cost, it needs an explicit story or a `delivery/dispatch-graph.yaml` entry.
9. Story 0.0.4's log-retention AC embeds an unresolved external dependency ("90 days non-prod, subject to HMCTS sign-off") — honest and well-flagged, but the AC's own measurable value is conditional on a sign-off that hasn't happened yet; worth a fallback value or an explicit blocking-dependency note in sprint planning.
10. ET role-taxonomy/incumbent placeholders (`[ET-INCUMBENT-TBD]` G8.4, provisional taxonomy G8.5) are consistently and transparently flagged in Story 0.3.1 — not a Phase 0 defect, since they bite at Phase 9+ wave rollout, not Phase 0's own functional completion. No action needed within Phase 0.

## Summary and Recommendations

### Overall Readiness Status

**NEEDS WORK**

Phase 0's planning artifacts are strong on documentation discipline and traceability (100% FR/NFR coverage for Phase 0's declared scope, consistent BDD acceptance criteria across all 19 stories, transparent gap-tracking for the ET-first pivot). But **one critical structural defect** means Epics 0.2 and 0.3 — half the epics in this phase — cannot currently be demoed or CI-verified in isolation as sequenced. This is a fixable sequencing/story-scoping problem, not a fundamental re-architecture, so it does not warrant NOT READY — but it should not be waved through as-is either.

### Critical Issues Requiring Immediate Action

1. **🔴 Epic 0.2 and Epic 0.3 have a hard forward dependency on Epic 0.4's seed data.** Stories 0.2.3, 0.2.5, and 0.3.2 all require identity/authorisation/jurisdiction data that Epic 0.4 (sequenced two epics later) is the one that seeds. As written, neither epic's happy-path ACs are independently executable. **Fix before implementation starts on Epic 0.2:** either pull a minimal dev/CI seed-fixture sub-story forward into Epic 0.2 (reserving Epic 0.4 for the full bootstrap-verification job + production runbook), or resequence Epic 0.4's seed-scripts portion ahead of Epic 0.2.

### Other Issues to Address (non-blocking, address opportunistically)

- **🟠 Major (4):** default port `8082` collision across three service-scaffold stories (0.1.1/0.2.1/0.5.1); Epic 0.5 title reads as a technical milestone despite demoable content; Epic 0.1 Story 0.1.3 and Epic 0.4 Story 0.4.1 each embed a forward-reference AC to the other's epic instead of framing it as a cross-epic integration note.
- **🟡 Minor (4):** bulk multi-table DDL within single stories (0.1.2, 0.3.1) — likely fine, worth a light check; `ram_configuration_values` (FR8) has no owning Phase 0 story despite being a dependency two stories rely on; Story 0.0.4's log-retention AC rests on an unconfirmed HMCTS sign-off; ET incumbent/taxonomy placeholders are already transparently tracked (no action needed, noted for completeness).
- **🟡 Minor (documentation):** `prd.md` FR1 text ("personal number" as canonical identifier) has not been backfilled with the 2026-07-09 D9 refinement that both `architecture/functional-requirements-coverage.md` and `epics/requirements-inventory.md` already reflect (RAM JOH UUID is canonical; personnel_number is only the upstream link). Low risk but could mislead an implementing agent reading `prd.md` literally.
- **⚪ Needs your confirmation (not re-checked further):** `architecture-summary.md` alongside `architecture.md` — confirm it's a derived/summary artifact and not meant as an alternate source of truth.
- **⚪ Forward risk (not a Phase 0 blocker):** no UX design document exists (documented, accepted gap for Phase 0's thin UI surface). Recommend revisiting before Phase 1 story creation once `ram-ui` grows beyond a single Home page.
- **🟡 Minor traceability nuance:** FR58/FR59 coverage is asserted partly via "every service story" — recommend each Epic 0.1/0.2/0.3 story AC explicitly re-affirm compliance so the claim is checkable story-by-story.

### Recommended Next Steps

1. **Resolve the Epic 0.2/0.3 ↔ Epic 0.4 dependency** before dev-agent work starts on either epic — this is the one item that would actually block a "single dev-agent session" story from being completable as scoped.
2. **Fix the `8082` port collision** across Stories 0.1.1, 0.2.1, and 0.5.1 against the actual `architecture/conventions.md` (AR3) port table before any service is scaffolded.
3. **Retitle Epic 0.5** to a user/outcome-framed title matching its filename intent.
4. **Correct `framework.md`'s FR4 attribution** and reconcile `prd.md` FR1's wording with the D9-refined canonical-identifier text already used downstream.
5. **Confirm `architecture-summary.md`'s status** (derived artifact vs. alternate source of truth) so future assessments don't need to re-flag it.
6. Everything else in this report is either already correctly handled (UX gap, ET placeholders, FR/NFR coverage) or a minor/opportunistic fix — safe to defer without blocking Phase 0 kickoff.

### Final Note

This assessment identified **15 findings** across 5 categories (document inventory, PRD analysis, epic coverage, UX alignment, epic quality) — 1 critical, 4 major, 6 minor, and 4 informational/no-action items. FR/NFR traceability for Phase 0's declared scope is complete (100%), and the UX gap is a pre-existing, correctly documented decision, not a new finding. The one critical issue (Epic 0.2/0.3 forward dependency on Epic 0.4) should be resolved before implementation begins on those two epics; the remaining issues can be fixed opportunistically without blocking Phase 0 kickoff.

---

**Assessed by:** BMAD Implementation Readiness workflow (Claude Code)
**Date:** 2026-08-11

## Documents In Scope For This Assessment

- PRD: `prd.md`
- Architecture: `architecture.md` + all files under `architecture/`
- Epics: `epics/index.md`, `epics/framework.md`, `epics/requirements-inventory.md`, `epics/fr-coverage-map.md`, `epics/phase-0/index.md` + 6 Phase-0 epic files
- UX: none (accepted gap, documented in `epics/index.md`)
