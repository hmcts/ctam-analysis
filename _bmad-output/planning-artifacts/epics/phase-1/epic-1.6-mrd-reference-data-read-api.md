---
type: 'Epic'
description: 'Extends the already-published Reference Data API with one new read-only endpoint so JOH Specialisations - reference data sourced from the separate MRD feed - can be looked up through the same API consumers already use, filtered by jurisdiction, rather than needing a second API or a second set of automated checks.'
resource: 'epics/phase-1/epic-1.6-mrd-reference-data-read-api.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-08-20'
parent: 'epics/phase-1/index.md'
epic: 1.6
title: 'MRD reference data is served read-only via the Reference Data API'
storyCount: 1
repo: ctam-reference-data
depends_on: [epic-1.3, epic-1.5]  # needs MRD data to exist (eLinks-independent ETL) and the already-published read API + JWTFilter/jurisdiction-filtering infra
---

# Epic 1.6: MRD reference data is served read-only via the Reference Data API

> This piece of work was split out from the epic that originally built the main Reference Data read API, once it became clear that a JOH Specialisations endpoint had never actually been specified there. It extends that existing API and its automated checks with one more endpoint, rather than building anything new from scratch.

**Business Goal:** Judicial Office Holders' specialisms — extra background information held in MRD, a separate reference-data feed with its own update schedule — are useful to later features such as Itinerary planning, but only if the rest of the programme can get at them without learning about, and integrating with, a second API. This epic makes sure that information shows up through the exact same reference-data lookup service that the CTAM front end and other downstream services already use for everything else, so there's one place to look, one API to test, and one collection of automated checks to run — not a growing maze of separate integrations to keep track of.

**Outcome:** A judge's specialisms can now be looked up read-only, filtered so a requester only ever sees information for judges within their own jurisdiction, through the very same reference-data lookup service already used for everything else on the API. Anyone consuming the API doesn't need to know or care that this particular piece of information comes from a different upstream feed on a different schedule — it simply shows up alongside everything else already available.

**Hosting:** This lives in exactly the same place as the rest of the Reference Data API — the same repository, the same running service, the same published API definition. Nothing new is being stood up; this is one more endpoint added onto something that already exists and is already in use.

**What's included:**
- One new endpoint for looking up a judge's specialisms, filtered so it only ever returns results for judges the requester is allowed to see, using the same permission-checking approach already used everywhere else on this API
- The new endpoint folded into the existing API definition (published as the next version of the same package, not a new package) and into the existing collection of automated API checks

**Explicitly out of scope:** Bringing MRD data into CTAM in the first place — that's separate, earlier work. The endpoints already covering other kinds of reference data — also separate, earlier work. Any ability to create, edit, or delete MRD-sourced data through this API — that's never planned, for any phase; corrections happen back at the source system and arrive through the next scheduled data sync.

---

## Story 1.6.1: JOH Specialisations are made available through the Reference Data read-only API

As an **API consumer** — the CTAM front end, and other downstream services in later phases that need to know a judge's specialisms, such as Itinerary planning —
I want a read-only, jurisdiction-filtered endpoint over the JOH Specialisations data, added onto the existing Reference Data API,
So that **this information can be looked up through the one API surface these services already use**, without needing to discover and integrate with a second API or run a second set of automated checks.

**Acceptance Criteria:**

**Given** the JOH Specialisations data already exists and has been loaded,
**And** the Reference Data API's existing read infrastructure — security-token checking, jurisdiction-based filtering, a standard error-response format, and versioned web addresses under `/v1/reference-data/...` — is already in place,
**When** the engineer adds a new endpoint, `GET /v1/reference-data/johs/{johId}/specialisms`,
**Then** the endpoint returns a successful response with that judge's list of specialisms, found by tracing from the judge's identity through to their personnel number and on to the specialisms data,
**And** the response is filtered by jurisdiction in exactly the same way as every other endpoint on this API — someone asking about a judge outside their own jurisdiction gets a clear "not allowed" response, not an empty result that pretends the judge doesn't exist,
**And** a judge who genuinely has no specialisms on record gets back a successful response with an empty list, not a "not found" error,
**And** no ability to create, update, or delete specialisms is provided — any attempt to do so is clearly rejected with a "method not allowed" response explaining that corrections happen back at the source system and arrive via the next scheduled data sync.

**Given** the API's technical definition is regenerated,
**When** the engineer publishes the updated version,
**Then** the published package moves to its next version (not a new, separate package) with the new endpoint documented alongside everything already there,
**And** the automated linting check that keeps the API definition consistent with the rest of the programme's APIs still passes.

**Given** the existing collection of automated API checks used in continuous integration,
**When** it runs,
**Then** it gains a new set of checks for the new endpoint — the successful case, the jurisdiction-filtered rejection, the empty-list case, and the rejected write attempt — sitting alongside the checks already in place for the other reference data this API covers.

**Explicitly NOT in scope:**
- Bringing MRD data into CTAM in the first place — separate, earlier work
- The endpoints already covering other kinds of reference data — separate, earlier work
- Any ability to edit MRD-sourced data through this API — never planned, for any phase
