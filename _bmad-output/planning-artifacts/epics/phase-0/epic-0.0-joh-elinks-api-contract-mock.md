---
type: 'Epic'
description: 'Business goal: de-risk the JOH eLinks integration - the wave-1 (Employment Tribunals) programmes single most safety-critical external data dependency - before production ingestion code is written. User outcome: the real JOH eLinks People API (v5) contract is confirmed and reproduced as a contract-accurate CI-only mock, seeded from real production reference-data extracts, so the Epic 1.2 eLinks sync integration-tests against a faithful target instead of an ad-hoc stub. Resolves the structural half of gap G8.1 and surfaces a new gap (G8.7): the real APIs natural-key field does not match CTAMs personnel_number assumption.'
resource: 'epics/phase-0/epic-0.0-joh-elinks-api-contract-mock.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-20'
parent: 'epics/phase-0/index.md'
epic: 0.0
title: 'The JOH eLinks API contract is confirmed and mocked for CI-only integration testing'
storyCount: 3
repo: ctam-reference-data
depends_on: [epic-1.1]                      # cross-phase: needs Phase 1's tier-(a) schema to exist so the mock's field mapping can be cross-checked against it
---

# Epic 0.0: The JOH eLinks API contract is confirmed and mocked for CI-only integration testing

> **New 2026-08-20, informed by an external reference codebase** (`ctam-jomockapi`, a local Node.js mock of the real JOH eLinks People API v5, built from the real Swagger export and complete example payloads, seeded from real production reference-data extracts). Not a split of an existing epic — new work triggered by that reference material becoming available.
>
> **Numbering history:** originally appended to what was then called "Phase 0" (Foundations) as Epic 0.10 (quoted `"0.10"`, since that phase's ten single-digit slots were exhausted). Moved to a newly-created "Phase 1" (JOH) as Epic 1.0 (SCP 2026-08-20g) — a clean, unquoted float, no collision risk, and a better conceptual fit (upstream-contract confirmation for JOH data belongs in the JOH phase, not platform/foundations). **Today (SCP 2026-08-20h), Phase 0 and Phase 1 were swapped wholesale**: Foundations content moved to the folder now called `phase-1/`, and this epic (JOH) moved to the folder now called `phase-0/`, becoming **Epic 0.0**. Depends cross-phase on Epic 1.1 (Phase 1's tier-(a) schema, now that Foundations is Phase 1) — cross-phase dependencies are normal; Phase 0 (JOH) as a whole already depends on Phase 1 (Foundations).

**Business Goal:** Employment Tribunals is CTAM Pathfinder's wave-1 rollout jurisdiction, and every JOH-facing feature in the programme — profile views, working patterns, sittings, bookings — ultimately reads `jo_people` data sourced from the JOH eLinks API. Before the programme commits engineering effort to that dependency, the business needs confidence that the integration is buildable against a *real, contract-accurate* target rather than assumptions drawn from a Swagger PDF export — so that a structural surprise (such as a missing `personnel_number` field) is caught while it is still a documentation-driven design decision, not a live-integration incident that risks stalling the wave-1 cutover.

**Scope of this body of work:** Although delivered as a single story, this epic spans three distinct pieces of work: **(1)** reverse-engineering the real API contract from primary sources — the Swagger export, complete example payloads, and dated production reference-data extracts; **(2)** building a CI-only fixture/mock layer inside `ctam-reference-data` that reproduces that contract faithfully (endpoints, auth, pagination, error shapes, realistic data volumes) rather than a hand-rolled happy-path stub; and **(3)** surfacing and formally recording the one structural mismatch that reverse-engineering uncovered (gap G8.7), turning it into a tracked architectural decision rather than a surprise found mid-integration. It represents the full "contract confirmation" phase of the JOH eLinks integration — normally a multi-week discovery exercise — compressed into a single epic because a complete external reference codebase made it tractable in one pass.

**User outcome:** The real JOH eLinks People API (v5) — endpoints, auth behaviour, pagination envelope, change-feed semantics, and response shapes — is confirmed (resolving the structural half of gaps.md **G8.1**, previously "unconfirmed") and reproduced as a **contract-accurate, CI-only mock**, seeded from real production reference-data extracts. Epic 1.2's eLinks sync (Story 1.2.1, which currently only promises testing "against a WireMock/stub eLinks API in CI" per AR52) gets a faithful target to integration-test against, rather than an ad-hoc hand-rolled stub. Building this mock surfaced a new, separately-tracked gap (**G8.7**): the real API's natural-key field does not match what CTAM's architecture assumed.

**Hosting:** lives inside `ctam-reference-data`'s own test infrastructure — a CI-only fixture/stub layer (WireMock mappings or an equivalent in-process fake), not a new deployable and not a new repo. This follows the same "no new surface for test-only infrastructure" principle already applied to the eLinks sync and MRD ingestion (both run in-process, no `ctam-integrations` repo) — the mock is a **build artefact of the test suite**, not a service anyone deploys.

**Vertical slice:**
- The real contract, confirmed: base path `/api/v5/...` (also mounted under `/elinks`, per the real Swagger doc's server field); bearer-token auth on every People/Reference Data endpoint (`401` on missing/malformed token); public `GET /` and `GET /api/v5/healthcheck`
- Reference-data endpoints: `GET /api/v5/reference_data/:attribute_name` (list, `{results: [...]}`) and `GET /api/v5/reference_data/:attribute_name/:reference_id` (single, `{results: [item]}`) — covering all 11 `jo_*`-mapped attribute names (`appointment_titles`, `base_locations`, `contract_types`, `genders`, `judiciary_roles`, `jurisdictions`, `location_types`, `locations`, `ticket_categories`, `ticket_category_types`, `tickets`), including deprecated singular aliases
- People endpoints: `GET /api/v5/people/:id` (full profile, `?include_previous_appointments=true`) and `GET /api/v5/people` (change-feed, **required** `?updated_since=YYYY-MM-DD`, `per_page`/`page`) — active people return full profiles, `leaver`/`deleted` people return compact stub shapes mixed into the same `results` array
- `GET /api/v5/leavers` (**required** `?left_since=`) and `GET /api/v5/deleted` (**required** `?deleted_since=`), same pagination shape
- Standard error envelopes confirmed: `400` `{"message": "Please correct the following validation errors and try again.", "errors": [...]}` for missing/invalid required params; `404` `{"message": "No person found for id <id>."}` / `{"message": "No reference data found for id <id>."}`; pagination envelope `{current_page, more_pages, results_per_page, pages, results}`
- CI-only fixture data cross-checked against real production reference-data volumes (`locations`: 2000, `base_locations`: 1462, `appointment_titles`: 194, `judiciary_roles`: 164, `tickets`: 159, `ticket_categories`: 54; small fixed vocabularies — `genders`, `contract_types`, `location_types`, `ticket_category_types`, `jurisdictions` — kept at their real (small) size)
- **Gap G8.7 recorded, not resolved here:** the real person record has no `personnel_number` field — it returns `per_id` (numeric) and `personal_code` (10-digit string) instead. This epic documents the discovery; reconciling CTAM's schema is a separate architectural decision (see gaps.md G8.7).

**FRs covered:** none directly — this is contract-confirmation and CI test-infrastructure work. **Supports** FR1 (identity-lookup target) and NFR24 (JOH eLinks MVP integration) by de-risking Epic 1.2's eLinks sync before it's built against real upstream data. Also the natural first step into this phase's own FR10–FR18 (JOH Records & Working Patterns) — those FRs all build on `jo_people` data whose upstream contract this epic confirms.

**Key NFRs:** NFR25–NFR28 (the mock's fixtures feed the same structured-logging/observability assertions Epic 1.2's CI already exercises) — otherwise this epic's NFR footprint is test-infrastructure, not runtime.

**Out of scope (explicitly):** Deciding the `personnel_number` → `per_id`/`personal_code` mapping (gaps.md G8.7 — a separate architectural decision, not made by this epic). Any change to `data-tables.md`, decision D9, or the schema in Phase 1's Epics 1.1/1.2/1.4/1.6/1.7. Standing up the mock as a deployed service or a new repo (it's CI-only, in-process test infrastructure). The MRD feed side of G8.1 (unrelated — MRD is a weekly Excel blob drop, not an API). Any of this phase's own JOH Records & Working Patterns functionality (FR10–FR18) — those remain framework-only, not yet decomposed into epics.

---

## Story 0.0.1: Contract endpoints, auth, and pagination are confirmed via the mock

As the **engineer building Epic 1.2's eLinks sync** (and every future maintainer of that integration),
I want `ctam-reference-data`'s CI suite to run against a mock that reproduces the real JOH eLinks People API (v5)'s endpoint set, bearer-token auth behaviour, and pagination/change-feed semantics — not a hand-rolled stub that only covers the happy path the original developer thought of,
So that **the sync's routing, auth handling, and pagination logic are proven against the real contract before the first live connection**.

**Acceptance Criteria:**

**Given** the tier-(a) `jo_*` schema exists per Epic 1.1, Story 1.1.2,
**When** the engineer builds the CI-only mock/fixture layer for the eLinks API,
**Then** it exposes the confirmed endpoint set — `GET /api/v5/reference_data/:attribute_name` (+ `/:reference_id`), `GET /api/v5/people/:id`, `GET /api/v5/people`, `GET /api/v5/leavers`, `GET /api/v5/deleted`, plus public `GET /` and `GET /api/v5/healthcheck` — mounted at both the bare path and under `/elinks`, matching the real Swagger doc's server field,
**And** every People/Reference Data route enforces bearer-token auth, returning `401 {"message": "Unauthorized. Invalid or missing token."}` on a missing or malformed `Authorization` header.

**Given** the mock's change-feed and list endpoints are queried with valid parameters,
**When** the eLinks sync's client code calls `GET /api/v5/people?updated_since=...&per_page=...&page=...`,
**Then** the response matches the confirmed pagination envelope `{results: [...], pagination: {current_page, more_pages, results_per_page, pages, results}}`,
**And** `results` mixes full-profile entries (active people) with compact `leaver`/`deleted` stub shapes, per the real change-feed semantics,
**And** `GET /api/v5/people/:id` always returns a full profile (`include_previous_appointments=true` includes ended appointments in the same `appointments` array; there is no separate field for it),
**And** a deleted person's `GET /api/v5/people/:id` returns `404 {"message": "No person found for id <id>."}`.

**References:** FR1 (supports, does not deliver), NFR24; gaps.md G8.1 (structural confirmation — endpoint set, auth, pagination/change-feed).

**Explicitly NOT in scope:**
- Error-envelope shapes for invalid requests and fixture-data realism (Story 0.0.2)
- The natural-key mismatch, gap G8.7 (Story 0.0.3)
- Deploying the mock as a real service (CI-only, in-process)

---

## Story 0.0.2: Error handling and fixture data match real production shapes and volumes

As the **engineer building Epic 1.2's eLinks sync**,
I want the mock to return the real API's error envelopes for invalid requests, and its fixture data cross-checked against real production reference-data volumes,
So that **the sync's error handling is proven against real error shapes, and its behaviour is validated in CI against realistic data volume rather than a handful of hand-picked happy-path records**.

**Acceptance Criteria:**

**Given** the mock is queried without required parameters,
**When** `GET /api/v5/people`, `/leavers`, or `/deleted` is called without its required date parameter (`updated_since`, `left_since`, `deleted_since` respectively),
**Then** the response is `400` with the confirmed validation-error envelope: `{"message": "Please correct the following validation errors and try again.", "errors": [...]}`,
**And** the same envelope is returned for an invalid `reference_id` (non-numeric) or an unknown `attribute_name`.

**Given** the mock's fixture data,
**When** CI seeds it,
**Then** reference-data fixtures are cross-checked against the real production volumes this epic confirmed (`locations`: 2000, `base_locations`: 1462, `appointment_titles`: 194, `judiciary_roles`: 164, `tickets`: 159, `ticket_categories`: 54; small fixed vocabularies kept at real size),
**And** generated people fixtures are internally consistent (appointments/judiciary-roles/authorisations join against the same reference-data fixtures, not independently randomised).

**References:** FR1 (supports, does not deliver), NFR24, NFR25–NFR28; gaps.md G8.1 (structural confirmation — error handling, fixture realism).

**Explicitly NOT in scope:**
- The contract's endpoint set, auth, and pagination shapes (Story 0.0.1)
- The natural-key mismatch, gap G8.7 (Story 0.0.3)
- Deploying the mock as a real service (CI-only, in-process)

---

## Story 0.0.3: The natural-key mismatch is discovered and recorded as gap G8.7

As the **architect responsible for CTAM's identity model** (decision D9),
I want the mock's confirmed person-record shape compared against `data-tables.md`'s `jo_people.personnel_number` assumption, with any mismatch formally recorded and the sync's field-mapping code marked accordingly,
So that **a structural surprise in the real upstream contract becomes a tracked architectural decision (gaps.md G8.7) rather than a surprise discovered mid-integration**, and the eventual reconciliation is a grep-able, bounded change rather than an untracked one.

**Acceptance Criteria:**

**Given** the mock's person-record shape is now confirmed (Story 0.0.1),
**When** the engineer compares it against `data-tables.md`'s `jo_people.personnel_number` assumption,
**Then** the mismatch is recorded as gaps.md **G8.7** (no schema change made here — that is a separate architectural decision),
**And** the eLinks sync's field-mapping code is written against the confirmed real fields (`per_id`, `personal_code`) with an explicit `// TODO: gaps.md G8.7` marker wherever `personnel_number` is currently assumed to be the natural key, so the eventual reconciliation is a grep-able, bounded change.

**References:** FR1 (supports, does not deliver); gaps.md G8.1 (structural confirmation), G8.7 (natural-key mismatch, new); D9[^d9] (the identity model this finding bears on, unchanged here).

**Explicitly NOT in scope:**
- Resolving G8.7 (the `personnel_number` mapping decision) — architectural decision, not made by this story
- The contract's endpoint/auth/pagination/error/fixture confirmation (Stories 0.0.1, 0.0.2)
- The MRD feed side of G8.1

[^d9]: Restructured D9 (2026-06-10; refined 2026-07-09 per SCP) — two user populations. JOHs resolve IdP email → `jo_people` → `personnel_number` → a **CTAM-assigned JOH UUID** (`ctam_joh_identities`); HMCTS admin staff via a CTAM-internal identity table. Both key on a CTAM-assigned UUID; `personnel_number` is the upstream link only. No legacy user migration. **Note (2026-08-20, gaps.md G8.7):** the real eLinks API has no `personnel_number` field — this decision's natural-key name needs reconciling against the confirmed real fields (`per_id`, `personal_code`); not yet done.
