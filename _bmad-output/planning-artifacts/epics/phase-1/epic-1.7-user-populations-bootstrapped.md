---
type: 'Epic'
description: 'CTAM Pathfinder has two distinct groups of people who need to sign in - judges and tribunal members on one side, and HMCTS administrative staff on the other. This work sets up each group''s access records (their roles, jurisdiction, and area coverage) and proves every one of them matches a real identity in the sign-in system, with everyone switched off by default until a go-live deliberately turns them on.'
resource: 'epics/phase-1/epic-1.7-user-populations-bootstrapped.html'
tags: [ctam-pathfinder, epics, phase-1, employment-tribunals]
timestamp: '2026-06-17'
parent: 'epics/phase-1/index.md'
epic: 1.7
title: 'Both user populations are bootstrapped and verifiable against the IdP'
storyCount: 0
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

