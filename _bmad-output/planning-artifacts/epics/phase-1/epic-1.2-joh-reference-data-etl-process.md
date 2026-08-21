---
type: 'Epic'
description: 'A nightly automated process pulls judicial office holder data from the JOH eLinks system and keeps CTAM Pathfinder’s own copy of that data current, so that judges and tribunal members can be recognised at sign-in and their jurisdiction is available — without migrating any data from legacy systems.'
resource: 'epics/phase-1/epic-1.2-joh-reference-data-etl-process.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-08-20'
parent: 'epics/phase-1/index.md'
epic: 1.2
title: 'JOH reference data flows into CTAM via the nightly eLinks ETL process'
storyCount: 1
repo: ctam-reference-data
depends_on: [epic-1.1]                      # needs the tier-(a) schema + write protection to exist first
---

# Epic 1.2: JOH reference data flows into CTAM via the nightly eLinks ETL process

> This piece of work was originally part of the database-schema epic and was later split out so the data-loading process could be tracked as its own piece of delivery; the database tables it fills are designed in that earlier work.

**Business Goal:** Before anyone can sign in to CTAM Pathfinder as a judge or tribunal member, or see which jurisdiction they belong to, the platform needs its own up-to-date copy of that person's details. Today that information lives only in HMCTS's JOH eLinks system, not in CTAM. This piece of work builds the automated process that copies it across every night, so CTAM Pathfinder always has current, trustworthy judicial-holder data to work from — without anyone having to migrate historical data from old systems.

**Outcome:** Judicial office holder reference data flows automatically into CTAM Pathfinder from its source system, the JOH eLinks feed, covering all 15 categories of judicial-holder data, every night. This means the table holding people's core details is always populated and current, the table holding jurisdiction information becomes the platform's proper source for jurisdiction as its own distinct piece of data, and CTAM Pathfinder becomes the authoritative home for judicial-holder reference data — all without migrating any data from legacy systems. Signing in to CTAM Pathfinder as a judicial office holder, which is built in a later piece of work, is impossible until this data-loading process has run and populated the people table.

**Hosting:** This data-loading process runs inside the same service that will later expose reference data to the rest of the platform — there is no separate integration service, nothing extra to deploy, and no separate service account to manage.

**What's included:**
- A nightly scheduled job, running inside that service, that pulls all 15 categories of judicial-holder data from the JOH eLinks feed, loading it into the database tables designed in the earlier schema work
- Each run fully refreshes and updates the data, matching records using the source system's own reference number for each record rather than any number CTAM invents itself
- Records that disappear from the source system are marked inactive rather than deleted outright, so nothing elsewhere in the database that refers to them ever breaks
- Every run is logged — where the data came from, when it started and finished, whether it succeeded, how many rows of each type were processed, and any error details — so problems can be diagnosed after the fact
- A way for the operations team to trigger an extra, out-of-cycle run by hand, on top of the nightly schedule
- The credential this process uses to talk to the JOH eLinks feed is stored securely rather than embedded in code, and the process reports its activity through the same logging, monitoring, and health-check setup used everywhere else in the platform

**Explicitly out of scope:** Bringing in the separate weekly data feed used for other reference data — that is a different piece of work. Building or changing the database tables and their write-protection rules themselves — this work only fills them with data; they are designed separately. Exposing this data to other systems through a read-only lookup service — that is a separate, later piece of work. Sign-in, permissions, and any user-facing screens — none of that is built here.

---

## Story 1.2.1: JOH reference data flows into CTAM nightly from the JOH eLinks feed

As **the CTAM Pathfinder platform**, and everyone downstream who relies on judicial-holder data being accurate,
I want **a nightly automated process that pulls judicial-holder data from the JOH eLinks feed and refreshes CTAM's own copy of it**,
So that **the people table is always populated and current, jurisdiction information is available, and judicial-holder reference data is authoritative within CTAM — without needing to migrate any data from legacy systems**.

**Acceptance Criteria:**

**Given** the database tables for judicial-holder data and the run-status logging table already exist from the earlier schema work,
**When** the engineer builds the nightly sync as an automated task running inside the existing service, needing no separate deployment or service account,
**Then** it runs on its nightly schedule and pulls all 15 categories of data from the JOH eLinks feed, using a credential held securely in Azure Key Vault,
**And** it fully refreshes and updates each table, matching records on the source system's own reference number for each one (the `personnel_number` field, for people), and creates a stable CTAM-assigned identifier (in the `ctam_joh_identities` table) for any person who doesn't already have one,
**And** any record that has disappeared from the source system is marked inactive rather than deleted, so nothing else in the database that refers to it is ever broken,
**And** each run is recorded in the `ctam_sync_status` table with where it came from, when it started and finished, its outcome, how many rows of each type it processed, and any error details,
**And** the process can also be triggered manually by the operations team — for example through an admin endpoint or a one-off job — for an extra, out-of-cycle refresh.

**Given** the JOH eLinks feed is unreachable, or sends back data in an unexpected shape, partway through a run,
**When** the sync fails,
**Then** the previously loaded data is left completely intact — each category of data is loaded as a single all-or-nothing unit, so nothing is ever left half-written,
**And** the failure is recorded in the run log and reported through the platform's standard structured logging, tagged with a correlation ID so operations staff can trace exactly what happened,
**And** the reference data is never more than one sync cycle — one night — out of date.

**Given** the sync has run successfully at least once in a development environment,
**When** the sign-in service looks up a judicial office holder by a seeded email address,
**Then** the lookup successfully resolves through the people table to that person's reference number, and from there to their CTAM-assigned identifier,
**And** development and test environments can run against realistic seeded sample data when a live connection to the JOH eLinks feed isn't available, with the sync itself checked automatically in continuous integration against a realistic stand-in for the real feed.

**Given** the exact shape of the JOH eLinks feed has not yet been formally confirmed,
**When** that confirmation becomes available,
**Then** the way this process maps incoming data onto CTAM's own tables is checked against it — making sure every field CTAM needs has somewhere to go, the way each record is uniquely identified still holds up, and the timing of the real feed is workable,
**And** if anything about the real feed's data doesn't fit what was assumed, that is raised as a formal design question rather than quietly worked around — this check is an explicit, tracked step in planning the work, not an afterthought.

**Explicitly NOT in scope:**
- Bringing in the separate weekly data feed used for other reference data — a different piece of work
- The database tables and their write-protection rules themselves — designed separately; this story only fills them with data
- The read-only lookup service that will expose this data to other systems — a separate, later piece of work
