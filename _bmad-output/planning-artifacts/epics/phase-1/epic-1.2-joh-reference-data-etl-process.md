---
type: 'Epic'
description: 'A nightly automated process pulls judicial office holder data from the JOH eLinks system and keeps CTAM Pathfinder’s own copy of that data current, so that judges and tribunal members can be recognised at sign-in and their jurisdiction is available — without migrating any data from legacy systems.'
resource: 'epics/phase-1/epic-1.2-joh-reference-data-etl-process.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-08-20'
parent: 'epics/phase-1/index.md'
epic: 1.2
title: 'JOH reference data flows into CTAM via the nightly eLinks ETL process'
storyCount: 0
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

