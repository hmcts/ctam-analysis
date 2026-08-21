---
type: 'Epic'
description: "CTAM's own reference data (regions, offices, calendar and financial-year boundaries, and the standard operational vocabularies used across the programme) is created, pre-populated with real values, and kept up to date by database administrators following a written runbook. Together with the judge and tribunal-member data already brought in from the JOH data source, all of it can be looked up, read-only, through a single versioned API that automatically filters what each caller sees to their own jurisdiction. Reference data sourced from the separate MRD feed is covered by its own piece of work."
resource: 'epics/phase-1/epic-1.5-joh-reference-data-read-api.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-06-17'
parent: 'epics/phase-1/index.md'
epic: 1.5
title: 'JOH and CTAM-owned reference data is served read-only via a versioned, jurisdiction-filtered API'
storyCount: 0
repo: ctam-reference-data
depends_on: [epic-1.1, epic-1.2, epic-1.4]  # the read API needs the reference-data service, the JOH data sync, and jurisdiction-aware authentication to exist first
---

# Epic 1.5: JOH and CTAM-owned reference data is served read-only via a versioned, jurisdiction-filtered API

> This piece of work originally covered all reference data read access. It was later narrowed to just the data CTAM owns outright and the judge/tribunal-member data from the JOH data source; the separate MRD-sourced lookup (JOH Specialisations) was split out into its own piece of work, [Epic 1.6](epic-1.6-mrd-reference-data-read-api.md), which builds on top of the API published here.

**Business Goal:** Every service in the CTAM Pathfinder programme needs one trustworthy place to look up shared reference information — which regions and offices exist, what the current court calendar looks like, and the standard lists (roles, ticket types, session types, and so on) used throughout the system — as well as the judge and tribunal-member data already brought in from the JOH data source. Building a single, well-governed, read-only API for all of this now means every feature built afterwards can rely on consistent, jurisdiction-appropriate data instead of each team re-inventing its own lookup logic. It also lets the programme prove out its approach to building APIs — how they're versioned, how errors are reported, how an endpoint gets retired — on a low-risk, read-only surface before those standards are relied on by higher-stakes features.

**What this covers:** This is two related pieces of work. The first is creating and populating the reference tables that CTAM owns outright — the ones that don't come from any upstream system at all, such as regions, offices, and calendar boundaries — and writing down exactly how database administrators keep them up to date day to day. The second is building the read-only API that exposes both that CTAM-owned data and the judge/tribunal-member data already synced in from the JOH data source, filtered so each caller only sees the entries relevant to their own jurisdiction, and built to the programme's emerging standards for how an API should look, version itself, and report errors.

**Outcome:** CTAM's own reference data — regions, offices, calendar and financial-year boundaries, and the standard operational vocabularies used across the programme — exists, is pre-populated with real values, and is kept up to date by database administrators following a written runbook. Together with the judge and tribunal-member data already brought in from the JOH data source by the earlier data-sync work, all of this becomes queryable, read-only, through a single versioned API on `ctam-reference-data`, with every response automatically filtered to the requester's jurisdiction. There is no admin screen for managing this data in this phase, and the judge and tribunal-member data is never edited by hand inside CTAM in any phase — corrections happen at the original source system and flow through automatically on the next sync.

**What's included:**
- The 15 reference tables CTAM owns outright (`ctam_regions`, `ctam_offices`, `ctam_calendar_periods`, plus 12 operational vocabulary tables including `ctam_joh_types` and `ctam_joh_fee_entitlements`), added through the `ctam-reference-data` service's own database change scripts — the service itself was already set up in an earlier piece of work
- Seed data for those tables, loaded through the same database change-script mechanism, plus a written runbook for database administrators covering how to make a change to this data
- The standard pattern of giving every service read-only database access to the reference tables it needs, completed for direct SQL reads
- A read-only reference data API — `GET` endpoints over both the CTAM-owned data and the judge/tribunal-member data from the JOH data source — with every response filtered to show only the entries relevant to the caller's jurisdiction, for use by the CTAM user interface, other CTAM services, and any client generated from its published API specification. There are deliberately no endpoints to create, update, or delete data through this API: the judge/tribunal-member data is only ever written by the automated data sync, and the CTAM-owned data is only ever changed by database administrators following the runbook
- The programme's first full run-through of its standards for read-only APIs: web addresses that carry a version number (`/v1/reference-data/...`), a published machine-readable API specification, error responses in a standard "problem details" format, and standard signals for marking an endpoint as being phased out (`Deprecation` and `Sunset` response headers)
- The programme's first Postman collection, published at `postman/ctam-reference-data-phase0.postman_collection.json`, for automated end-to-end checks of the API

**Key expectations:**
- The controlled vocabulary tables contain no case or financial data by design, since they're built entirely from a fixed, agreed list of values
- The service can be deployed on its own, independently of every other CTAM service
- A Postman collection exists so the API's behaviour is checked automatically, every time
- Since no user interface is being built for this data in this phase, accessibility standards for screens don't apply yet — they come back into play once a maintenance screen is built after MVP

**Explicitly out of scope (deferred post-MVP or to another piece of work):**
- A maintenance screen for RSU staff to manage the CTAM-owned data, and an admin screen for managing role, jurisdiction, and region-area assignments — both are planned for the admin user interface after MVP; until then, everything is managed by database administrators via direct SQL, following the runbook
- The reference data endpoint sourced from the separate MRD feed (JOH Specialisations) — that's a later piece of work that builds on top of the API published here rather than standing up its own
- Any endpoints to create, update, or delete the CTAM-owned data through the API
- A reference-data maintenance module in the admin user interface
- There is no legacy-data migration and no git-based sign-off workflow for this data — the judge and tribunal-member data arrives entirely through the earlier data-sync work's own ingestion mechanism

