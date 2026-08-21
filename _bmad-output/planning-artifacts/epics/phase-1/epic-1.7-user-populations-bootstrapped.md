---
type: 'Epic'
description: 'CTAM Pathfinder has two distinct groups of people who need to sign in - judges and tribunal members on one side, and HMCTS administrative staff on the other. This work sets up each group''s access records (their roles, jurisdiction, and area coverage) and proves every one of them matches a real identity in the sign-in system, with everyone switched off by default until a go-live deliberately turns them on.'
resource: 'epics/phase-1/epic-1.7-user-populations-bootstrapped.html'
tags: [ctam-pathfinder, epics, phase-1, employment-tribunals]
timestamp: '2026-06-17'
parent: 'epics/phase-1/index.md'
epic: 1.7
title: 'Both user populations are bootstrapped and verifiable against the IdP'
storyCount: 1
repo: ctam-architecture
depends_on: [epic-1.1, epic-1.4]            # needs ctam_auth_* tables + jo_* fixtures + mock-auth roster
---

# Epic 1.7: Both user populations are bootstrapped and verifiable against the IdP

**Business Goal:** Nobody can sign into CTAM Pathfinder unless their identity has been set up and verified in advance. That's true for every environment the programme uses, from a developer's laptop through to the day a real jurisdiction goes live. The business needs confidence that both groups of users — judges and tribunal members, and HMCTS's own administrative staff — are set up correctly and can prove they map to a real sign-in identity, before anyone relies on being able to log in. Getting this wrong at go-live would mean people simply couldn't access the system on day one.

**What this covers:** There are two separate groups of people who use CTAM, each resolved a different way. Judicial office holders (judges and tribunal members) are looked up by matching their sign-in email to a personnel record, and from there to a CTAM-assigned unique reference. HMCTS administrative staff are looked up through a separate, CTAM-internal identity list. Both groups end up keyed on a CTAM-assigned unique reference, not on any number carried over from another system. This piece of work covers three things: (1) scripts that seed both groups' data for development and automated testing; (2) a repeatable check that proves every seeded (and eventually every real) user actually matches a real sign-in identity; and (3) a written runbook explaining how programme management sets this up for real, live users. The sign-in feature built elsewhere in this phase depends on this data existing.

There is no carrying over of user accounts from any legacy system, in any form — no import of old user records, no reconciliation process, no manual review list of records that didn't match. None of that exists, and none of it is planned. There is also no administrative screen for managing this data in this first release — an authorised database administrator makes any changes directly, following the operational runbook; a proper on-screen admin tool is planned for later.

**What's included:**
- Development and test-environment seed scripts (a one-off setup step, not something that runs automatically in production) that populate **both** groups: sample judicial office holder records (used wherever there's no live connection to the real judicial data source yet), the administrative-staff identity records, the combined user records (tagging each one as a judicial or administrative user, and recording their jurisdiction), their assigned roles, their Region/Area coverage, and their access-activation status — everyone starts switched **off** by default, organised by jurisdiction and region. This mirrors the same test users already used elsewhere for sign-in testing.
- A **verification check** that confirms every seeded (and later, every real) user record actually matches a real identity in the sign-in system — checked against a stand-in sign-in directory during earlier phases, and against the real HMCTS sign-in system once the programme is ready to cut over to it — and produces a report. If anything fails to match, that failure blocks the go-live step for that group of users.
- A **written runbook** for setting this up for real, describing exactly what programme management needs to provide (the list of staff identities, and each person's roles/jurisdiction/area coverage), how that data gets loaded into the database, how to run the verification check, and how a database administrator makes ongoing changes to someone's role, jurisdiction, or coverage area.

**Who resolves how:**

| User group | How they're identified | Where their identity lives |
|---|---|---|
| Judicial office holders | Sign-in email matched to their personnel record, then to a CTAM-assigned reference | The judicial-holder identity table |
| HMCTS administrative staff | Sign-in email matched directly | The CTAM-internal staff identity table |

**Why this matters:** This isn't a customer-facing feature in itself, but it's the foundation the sign-in feature depends on to actually work in any environment — and it's the safeguard that stops a jurisdiction going live with users who can't actually get in.

**Explicitly out of scope:**
- Actually supplying the real, live list of users for a production go-live — that's programme management's job; this work only provides the runbook and the verification check, not the source data itself
- Any on-screen tool for administrators to manage users, roles, or activation status — that's planned for a later release
- Any process for importing or reconciling user accounts from a legacy system — no such process exists or is planned

---

## Story 1.7.1: Both groups of users can be seeded, verified against the sign-in system, and set up for real via a runbook

As the **person responsible for identity setup, and every engineer who needs working sign-in in every environment**,
I want seed scripts covering both groups of users, a repeatable check that proves every user maps to a real sign-in identity, and a written runbook for setting this up for real,
So that **sign-in works end-to-end everywhere it's needed, and nobody can go live for a group of users whose identities haven't been proven to actually work**.

**Acceptance Criteria:**

**Given** the engineer writes the development/test seed scripts (a one-off setup script, not something that runs as part of the live system, and not part of the ordinary database change process),
**When** the scripts run against a freshly created development or test database,
**Then** they create: realistic sample judicial-holder records — including personnel records whose email addresses match the judicial test users already used for sign-in testing, with stable personnel numbers, a freshly-generated CTAM reference for each one, and sample jurisdictions covering Employment Tribunals, the Social Security and Child Support tribunal, and example ordinary courts,
**And** administrative-staff identity records whose email addresses match the administrative test users already used for sign-in testing,
**And** combined user records for both groups — each tagged as judicial or administrative, linked to the correct underlying identity record, and recording which jurisdiction they belong to,
**And** role assignments and Region/Area coverage records covering every documented role in both groups,
**And** activation-status records for every jurisdiction/region combination — all switched **off** by default, except a handful of designated test users deliberately switched **on**, so the sign-in demo can show both the "activated" and "not yet activated" experience,
**And** the scripts can be safely re-run against a database that's already been seeded, without creating duplicates or breaking anything.

**Given** the verification check is built (a repeatable script or scheduled job, owned by the architecture team),
**When** it runs against an environment,
**Then** for every user record, in both groups, it confirms the person actually exists in the sign-in system — checked by email against a stand-in sign-in directory during earlier phases, and against the real HMCTS sign-in directory once the programme cuts over to it,
**And** it checks that the underlying data is internally consistent for each group: every judicial user record links to a valid judicial-holder identity whose personnel number maps to an active personnel record; every administrative-staff user record links to a valid staff-identity record,
**And** it produces a report showing, per group, the total number of users, how many were successfully verified, and the specific reason for any that weren't,
**And** if even one user fails to verify, the check fails outright — and passing this check cleanly is a required step before any jurisdiction/region combination can go live,
**And** running the check never changes any data — it only checks and reports.

**Given** the written runbook for setting this up for real,
**When** programme management prepares the users for a jurisdiction going live,
**Then** the runbook spells out exactly what programme management must supply — the list of administrative staff identities with their email addresses, and the role/jurisdiction/area-coverage assignments for both groups (judicial-holder personal data itself arrives separately, through the ongoing sync with the judicial data source, not through this setup process),
**And** it documents, table by table, how a database administrator loads that data — including the rule that everyone starts switched off by default,
**And** it explains how to run the verification check, and states plainly that a clean pass is required before that jurisdiction/region combination can go live,
**And** it explains how a database administrator makes an ongoing change to someone's role, jurisdiction, or coverage area, including how that change gets recorded for audit purposes,
**And** it states plainly what this process does **not** do: there is no import of user accounts from any legacy system, and the underlying source of the real user list is programme management's responsibility, not something this process provides.

**Given** the seed scripts have run in a development environment,
**When** the automated sign-in test suite runs,
**Then** the judicial test user can sign in and resolves correctly to their CTAM reference, and the administrative-staff test user can sign in and resolves correctly to their staff identity,
**And** the verification check passes cleanly against that seeded environment as part of the automated build.

**Explicitly not in scope:**
- Any on-screen tool for administrators to manage users, roles, jurisdiction, scope, or activation status
- Where programme management actually gets its real, live list of users from — that's outside this work
- Any process for importing or reconciling user accounts from a legacy system — none exists or is planned
