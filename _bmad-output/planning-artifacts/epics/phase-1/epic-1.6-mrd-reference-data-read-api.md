---
type: 'Epic'
description: 'Extends the already-published Reference Data API with one new read-only endpoint so JOH Specialisations - reference data sourced from the separate MRD feed - can be looked up through the same API consumers already use, filtered by jurisdiction, rather than needing a second API or a second set of automated checks.'
resource: 'epics/phase-1/epic-1.6-mrd-reference-data-read-api.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-08-20'
parent: 'epics/phase-1/index.md'
epic: 1.6
title: 'MRD reference data is served read-only via the Reference Data API'
storyCount: 0
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

