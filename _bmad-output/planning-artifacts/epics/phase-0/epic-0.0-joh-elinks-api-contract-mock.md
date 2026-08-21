---
type: 'Epic'
description: 'Confirms exactly what the real JOH data source looks like - its web addresses, security rules, and paging behaviour - by building a safe practice copy of it for testing, seeded with realistic data. This means the team building the nightly JOH data sync can prove their work against a faithful copy of the real system before ever connecting to it live. It also uncovers and records an important discovery: the real system does not use the field we had assumed would be its unique identifier for each person.'
resource: 'epics/phase-0/epic-0.0-joh-elinks-api-contract-mock.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-20'
parent: 'epics/phase-0/index.md'
epic: 0.0
title: 'The JOH eLinks API contract is confirmed and mocked for CI-only integration testing'
storyCount: 3
repo: ctam-reference-data
depends_on: [epic-1.1]                      # needs the JOH/MRD database schema work to exist first, so this epic's findings can be checked against it
---

# Epic 0.0: The JOH eLinks API contract is confirmed and mocked for CI-only integration testing

> This piece of work was added once a real reference example of the JOH data source became available, and moved between phase groupings as the programme's structure was reorganised. Its number reflects that history, not its priority.

**Business Goal:** Employment Tribunals is the first jurisdiction going live on CTAM Pathfinder, and every judge-facing feature in the programme — profile views, working patterns, sittings, bookings — ultimately depends on judge and tribunal-member data pulled from the JOH data source. Before the team commits engineering effort to that dependency, the business needs confidence that it can be built against a *real, accurate* picture of that data source, rather than assumptions drawn from a PDF export of its documentation. Catching a structural surprise now — while it is still a design decision — is far cheaper than discovering it live, where it could delay the first jurisdiction's go-live.

**What this covers:** Although delivered as a handful of stories, this is a full body of work with three parts: **(1)** working out exactly what the real data source looks like, using its official documentation and real example data; **(2)** building a safe, realistic practice copy of it purely for automated testing — not a rough stand-in that only covers the easy cases; and **(3)** writing down, clearly and formally, the one important mismatch this work uncovered, so it becomes a tracked decision for the team to make rather than a surprise found partway through building the real integration. It compresses what is normally a multi-week discovery exercise into a single, focused piece of work, made possible by having a complete real-world example to learn from.

**Outcome:** The real JOH data source's web addresses, login/security behaviour, page-by-page data retrieval, and response formats are all confirmed and reproduced as a realistic, safe practice copy — seeded with data at the same scale as the real thing. The team building the nightly JOH data sync gets a trustworthy target to test against, instead of a rough stand-in. Building this practice copy also revealed that the real data source doesn't use the identifier field the team had assumed it would.

**Hosting:** This practice copy lives entirely inside the testing setup of the service that will do the real data sync — it is not a new system, not something anyone deploys, and nobody outside the automated test suite ever sees it running. It exists purely so that automated checks have something realistic to run against.

**What's included:**
- The real data source's structure, confirmed: how it's addressed on the web; that every request needs a security token, with a clear rejection message if one is missing or wrong; and a couple of endpoints anyone can reach without a token, for basic health checks
- Lookup data endpoints — for things like appointment titles, locations, contract types, genders, roles, jurisdictions, and ticket categories — covering every category CTAM needs, including some older, deprecated names that still need to be understood
- Person-lookup endpoints — fetching a single judicial office holder's full profile, and a "what's changed recently" feed for keeping local data in sync, which returns compact stub records for people who have left or been removed rather than full profiles
- Dedicated feeds for people who've left, and people who've been deleted, using the same paging approach as the main feed
- The exact shape of error messages and "not found" responses, and the exact shape of the paging information returned with every list of results
- Practice data seeded at realistic scale — matching real-world counts for locations, job titles, roles, tickets, and categories — not just a handful of made-up test records
- **An important discovery, written down but not yet resolved:** the real data source does not have the identifier field the team had planned to use as each person's unique reference number — it uses two different fields instead. This work records that discovery clearly; deciding which field to actually use is a separate decision for the team to make.

**Endpoints being mocked:** every endpoint below is mounted at both its standard address and an alternative address the real system also supports.

*Public (no security token required):*

| Endpoint | Purpose |
|---|---|
| `GET /` | Root / landing |
| `GET /api/v5/healthcheck` | Health check |

*Lookup data (security token required):*

| Endpoint | Purpose |
|---|---|
| `GET /api/v5/reference_data/:attribute_name` | List all values for a lookup category |
| `GET /api/v5/reference_data/:attribute_name/:reference_id` | A single lookup value by id |

Covering all 11 categories CTAM needs (including older, deprecated names): `appointment_titles`, `base_locations`, `contract_types`, `genders`, `judiciary_roles`, `jurisdictions`, `location_types`, `locations`, `ticket_categories`, `ticket_category_types`, `tickets`.

*Person data (security token required):*

| Endpoint | Purpose | Required inputs |
|---|---|---|
| `GET /api/v5/people/:id` | Full profile for one person | — (`?include_previous_appointments=true` optional) |
| `GET /api/v5/people` | "What's changed" feed, paginated | a from-date is required; page size/number optional |
| `GET /api/v5/leavers` | People who've left | a from-date is required |
| `GET /api/v5/deleted` | People who've been deleted | a from-date is required |

*Response behaviour also being confirmed (not separate endpoints, but expected of every route above):* a clear rejection when the security token is missing or wrong; a clear "please correct these errors" message when a required input is missing or invalid; a clear "not found" message for an unknown person or lookup value; and a consistent paging format on every list of results.

**Why this matters:** This isn't tied to a single customer-facing feature — it's foundational, de-risking work that protects the nightly data sync everyone else's judge-facing features will depend on, and it's the natural first step before the team starts building the judge profile and working-pattern features planned for later in this phase.

**Explicitly out of scope:** Deciding which field to use as each person's unique identifier — that's a separate decision for the team, not resolved by this work. Any changes to the actual database design used elsewhere in the programme. Turning this practice copy into a real, deployed service — it exists purely for automated testing. The equivalent discovery work for the separate MRD data feed (a weekly spreadsheet drop, not a live data source, so it's a different kind of problem). Any of the judge profile or working-pattern features themselves — those are planned for later and aren't started yet.

---

## Story 0.0.1: Contract endpoints, auth, and pagination are confirmed via the mock

As the **engineer building the nightly JOH data sync** (and everyone who maintains it afterwards),
I want the automated test suite to run against a practice copy that behaves exactly like the real JOH data source — its web addresses, its security checks, and the way it pages through results — rather than a rough stand-in that only covers the easy cases,
So that **the sync's routing, security handling, and paging logic are all proven correct before it ever talks to the real system**.

**Acceptance Criteria:**

**Given** the underlying database structure for JOH data already exists,
**When** the engineer builds the practice copy of the JOH data source for automated testing,
**Then** it offers the full, confirmed set of lookup, person, and health-check endpoints, reachable both at their standard address and at an alternative address the real system also supports,
**And** every lookup and person endpoint requires a valid security token, clearly rejecting any request with a missing or malformed one.

**Given** the practice copy's "what's changed" and list-style endpoints are queried with valid inputs,
**When** the sync's code asks for everyone updated since a given date, with paging options,
**Then** the response matches the confirmed paging format exactly,
**And** the results mix full profiles for active people with compact stub records for people who've left or been removed, matching the real system's behaviour,
**And** looking up a single person by their reference always returns their full profile, including past appointments where requested,
**And** looking up someone who has been deleted returns a clear "not found" response.

**Explicitly not in scope:**
- Error-message formats for invalid requests, and realistic test-data volumes (covered in the next story)
- The identifier-field discovery (covered in the story after that)
- Turning this practice copy into a real, deployed service

---

## Story 0.0.2: Error handling and fixture data match real production shapes and volumes

As the **engineer building the nightly JOH data sync**,
I want the practice copy to return error messages in exactly the same shape as the real system, and to be seeded with test data at a realistic scale,
So that **the sync's error handling is proven against real error formats, and its behaviour is checked against realistic data volumes rather than a handful of hand-picked test records**.

**Acceptance Criteria:**

**Given** the practice copy is asked for something without a piece of information it needs,
**When** a request is missing a required date, or gives an invalid or unrecognised lookup value,
**Then** the response comes back with the confirmed error-message format, clearly explaining what went wrong.

**Given** the practice copy's seeded test data,
**When** the automated test suite starts up,
**Then** the lookup data is seeded at the same scale as the real system (matching real-world counts for locations, job titles, roles, tickets, and categories),
**And** the generated people records are internally consistent — their appointments, roles, and permissions all line up with the same seeded lookup data, rather than being randomly generated in isolation.

**Explicitly not in scope:**
- The data source's addresses, security checks, and paging shapes (covered in the previous story)
- The identifier-field discovery (covered in the next story)
- Turning this practice copy into a real, deployed service

---

## Story 0.0.3: The natural-key mismatch is discovered and recorded as gap G8.7

As the **person responsible for how CTAM identifies judges and tribunal members**,
I want the practice copy's confirmed person-record shape compared against what the programme had assumed the unique identifier field would be, with any mismatch clearly written down and flagged in the sync team's own code,
So that **a structural surprise in the real data source becomes a tracked decision for the team to make, rather than something discovered midway through building the real integration** — and whoever eventually resolves it can find every affected spot easily, instead of hunting for it.

**Acceptance Criteria:**

**Given** the practice copy's person-record shape is now confirmed,
**When** the engineer compares it against the identifier field the programme had assumed would be used,
**Then** the mismatch is written down clearly as a tracked, open item (no changes to the actual database design are made here — that's a separate decision),
**And** the sync's own code is written against the two fields the real system actually returns, with an obvious, searchable marker left wherever the old assumption still applies, so the eventual fix is a small, well-contained change rather than an open-ended hunt.

**Explicitly not in scope:**
- Deciding which field to actually use as the identifier — that's a separate decision for the team, not made by this work
- The data source's addresses, security checks, error formats, or paging shapes (covered in the previous two stories)
- The equivalent discovery work for the separate MRD data feed
