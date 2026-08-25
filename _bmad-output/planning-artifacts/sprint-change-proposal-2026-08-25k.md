---
type: 'Sprint Change Proposal'
description: 'Corrects Epic 0.2s mock-API contract fidelity against the real E-links API v5.0 Swagger doc and June 2026 production reference-data exports: two omitted endpoints (single-person and single-reference-data-item lookup) and unspecified required-query-parameter / pagination / deprecated-alias detail. No behavioural redesign, no scope change.'
resource: 'sprint-change-proposal-2026-08-25k.html'
tags: [ctam-pathfinder, sprint-change-proposal]
timestamp: '2026-08-25'
title: 'Sprint Change Proposal — 2026-08-25k'
status: 'approved'
---

# Sprint Change Proposal — 2026-08-25k

**Trigger:** User request — "update epic-0.2 based on the files in `/Users/shivakumar/MOJ/ram_analysis_docs`," a folder containing the real `E-links API v5.0` Swagger doc (`Swagger UI.pdf`) and June 2026 production reference-data exports (`ReferenceData/*.csv|json`) — the same class of source material Epic 0.2's Story 0.2.1 already claims to port "faithfully," but a direct comparison had not previously been done against this specific Swagger export.

**Mode:** Incremental (single artifact, iterated live with the user). **Scope classification:** **Minor** — Story 0.2.1's AC is corrected in place for completeness; no new story, no FR/NFR/PRD change, no dependency-graph change.

---

## 1. Issue Summary

Comparing the real Swagger doc's `Schemas`/`Paths` against Story 0.2.1's endpoint-porting AC (which claims every endpoint is reimplemented with an "identical" request/response shape) surfaced two omissions and several unspecified contract details:

1. **`GET /api/v5/people/{id}`** — a single-person lookup endpoint, distinct from the `/people` change-feed, present in the real contract but never named in the epic.
2. **`GET /api/v5/reference_data/{attribute_name}/{reference_id}`** — a single reference-data-item lookup, companion to the already-named list endpoint, also never named.
3. **Required query parameters** — `updated_since` (`/people`), `left_since` (`/leavers`), and `deleted_since` (`/deleted`) are all `required` in the real contract (missing → `400` validation error, confirmed from the Swagger UI's own "Try it out" error state); the epic didn't say so.
4. **Pagination defaults and metadata** — `per_page` (default 50) and `page` (default 1) are documented optional params, with responses carrying a `PaginationResponse` (`pages`, `current_page`, `results_per_page`, `more_pages`); not previously specified.
5. **Deprecated singular aliases** — the real `attribute_name` path parameter accepts 11 deprecated singular forms (`appointment_title`, `base_location`, …) alongside the 11 canonical plural names; not previously specified.

The real reference-data exports (`AppointmentTitle`, `BaseLocation`, `ContractType`, `Gender`, `JudiciaryRole`, `Jurisdiction`, `Location`, `LocationType`, `Ticket`, `TicketCategory`, `TicketCategoryType` — 11 files) confirm the epic's existing "11 vocabularies" claim is correct; no change needed there.

**Discussed and explicitly decided against:** the real Swagger doc's `Servers` value is `/elinks`, meaning production routes are `{host}/elinks/api/v5/...`. The user confirmed the mock should **not** adopt this prefix — it reads as gateway/ingress routing in front of the real hosted service, not part of the application's own contract, and a local Spring Boot mock has no gateway in front of it. The epic's existing bare `/api/v5/...` routes stand; this is now recorded as an explicit out-of-scope item so it isn't re-litigated later.

## 2. Impact Analysis

**Epic impact:** Epic 0.2 only, Story 0.2.1's endpoint-porting AC. Stories 0.2.2 and 0.2.3 are unaffected — neither depends on the two newly-named endpoints or the parameter detail added here.

**Artifact impact:** no PRD, architecture pattern, or UX change. No new table, repo, or dependency edge.

### Artifact sweep

| Artifact | Change |
|---|---|
| `epic-0.2-joh-elinks-mock-api-stands-in.md` | Story 0.2.1's endpoint-porting AC rewritten to name all 7 endpoints (was 5 named/6 implied) plus required-param, pagination, and deprecated-alias detail; References line updated; one new out-of-scope bullet (`/elinks` prefix) |
| `_bmad-output/source-docs/joh-elinks-api/` | New — the real Swagger doc + `ReferenceData/*.csv|json` archived for traceability (mirrors the `joh-schema-confluence/` pattern from SCP 2026-08-25j) |
| `architecture.md` | New decision **#24** |
| `architecture/changelog.md` | New **v4.21** entry |

**Not touched:** `epics/phase-0/index.md`, `epics/index.md` (story count unchanged — 19); `sprint-status.yaml` (no story added/removed/renamed); Stories 0.2.2, 0.2.3 (no dependency on the corrected detail); `gaps.md` G8.1 (unaffected — this is mock-fidelity, not real-contract confirmation); `repository-strategy.md`, `assumptions.md` A38 (both already describe the mock at the right level of abstraction; no correction needed).

## 3. Recommended Approach

**Direct Adjustment.** Effort: **Low** — one AC block rewritten, one out-of-scope bullet, one References update, source-doc archival, decision-log + changelog entries. **Risk:** Very low — additive precision to an existing "faithful reimplementation" claim; no behavioural redesign, no story restructuring.

## 4. Detailed Change Proposals

See §1 for the full finding-by-finding rationale; the applied diff is in `epic-0.2-joh-elinks-mock-api-stands-in.md` itself.

## 5. Implementation Handoff

**Scope: Minor** — direct edit to existing epic content, no scope or dependency change.

**Responsibilities:**
- **This session:** all edits applied directly; nothing committed or pushed without being asked.

**Success criteria:** Story 0.2.1's endpoint-porting AC names every endpoint in the real `E-links API v5.0` Swagger doc that Epic 0.2's scope covers (people change-feed, people-by-id, leavers, deleted, reference-data list, reference-data-by-id, healthcheck), with required/optional query-parameter behaviour and pagination shape specified; the `/elinks` prefix question is recorded as a decided out-of-scope item, not left open; the real source material is archived under `_bmad-output/source-docs/` for future traceability; `docs/` regenerated from the updated markdown.
