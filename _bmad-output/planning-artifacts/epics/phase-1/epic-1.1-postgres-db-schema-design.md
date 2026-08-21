---
type: 'Epic'
description: 'ctam-reference-data is scaffolded as the first CTAM Pathfinder service to be built, and its underlying database schema - 15 tables holding judicial office holder and tribunal data, plus a table that logs every data-sync run - is designed with a firm rule that only this one service is ever allowed to write to it. This gives the teams building the nightly and weekly data feeds from the outside source systems a proper, protected schema to load their data into.'
resource: 'epics/phase-1/epic-1.1-postgres-db-schema-design.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-06-17'
parent: 'epics/phase-1/index.md'
epic: 1.1
title: 'Postgres reference-data schema is designed and scaffolded'
storyCount: 0
repo: ctam-reference-data
depends_on: [epic-1.0, epic-1.9]            # needs the estate + the shared config baseline (was arch-baseline)
---

# Epic 1.1: Postgres reference-data schema is designed and scaffolded

> This piece of work used to also include the two jobs that load data into the schema from outside sources. Those have since been split out into their own pieces of work — the nightly JOH data sync and the weekly MRD data sync — each of which depends on this epic existing first. This epic itself now covers only the scaffolding and the schema design.

**Business Goal:** `ctam-reference-data` is the very first service built for CTAM Pathfinder, and everything else in the programme is built on top of it. Every judge-facing feature that comes later — profiles, working patterns, sittings, bookings — ultimately reads judge and tribunal-member data that lives in this service's database. Before any of that data can be loaded in, the database itself has to exist, with the right tables, and with a firm, enforced rule about which service is allowed to change judge and tribunal data. Getting this foundation right, and locking it down from day one, protects the accuracy of that data for every team and every feature that depends on it later.

**What this covers:** This is foundation-laying work with two parts. First, standing up the very first CTAM Pathfinder service from HMCTS's standard starter template, connecting it to the shared cloud environment, and proving that the whole build-test-deploy pipeline works end to end before any real business logic is written. Second, designing the actual database tables that will hold judge and tribunal-member data sourced from outside CTAM, and locking those tables down so that only this one service can ever write to them. Actually loading real data into those tables is separate work, picked up afterwards by the teams building the nightly and weekly data feeds.

**Outcome:** `ctam-reference-data` exists as a working, deployed service — the first domain service in the programme — and its database has 15 tables holding judge, appointment, role, location, and ticket data sourced from outside systems, plus a table that logs every data-sync run. Only `ctam-reference-data` itself is allowed to write to those 15 tables; nothing else in the platform can. This gives the teams building the nightly JOH data sync and the weekly MRD data sync a proper schema to populate, and gives every future consumer of judge and tribunal-member data confidence that it comes from exactly one, protected source.

**Hosting:** the schema, and the data-loading that will populate it later, both live inside `ctam-reference-data` itself — there's no separate integrations service. `ctam-reference-data` is the first domain service to be built, and it runs on the shared cloud environment that was set up in the programme's earlier infrastructure work; it only carries its own small, service-specific setup (its own secrets store, and later, storage for the weekly MRD file drop).

**What's included:**
- A manual, step-by-step setup guide for the GitHub side of things (creating the repository, turning on branch protection) — done through GitHub's website rather than a command-line tool, because that tool isn't available in this environment
- The first backend service in the programme, `ctam-reference-data`, built from HMCTS's standard Spring Boot starter template and the programme's own scaffolding script, so every service that comes after it follows the same consistent, secure baseline
- Connecting that service to the shared cloud environment already set up (the shared Kubernetes cluster, the shared database server, the container registry, the API gateway, the monitoring setup, and the secrets store)
- A shared baseline table of configuration values, set up once centrally and made readable (but not writable) by every service, including this one
- The 15 database tables that hold judge, appointment, role, location, and ticket data sourced from outside CTAM, plus the run-log table for tracking data-sync jobs — all defined through this service's own versioned database-migration scripts, with write access locked down to `ctam-reference-data` alone

**Why this matters:** This isn't tied to a single customer-facing feature — it's the foundational data layer everything else in the programme sits on top of. It has to exist, and exist correctly, before the JOH data sync and MRD data sync can load anything into it, and before any judge profile or working-pattern feature can be built on top of that data.

**Explicitly out of scope:** The nightly JOH data sync and the weekly MRD data sync themselves — this epic creates the schema and the write-protection rule only; loading it with real data happens afterwards, as separate work. The read-only API that lets other services read this data, and filtering that data by jurisdiction — that comes later, once authentication is in place. CTAM's own reference tables (the ones CTAM owns and maintains itself, rather than sourcing from outside) — also later work. All authentication, authorisation, and user-interface work — a separate piece of work entirely. Hand-editing any of this outside-sourced data directly in CTAM — that must never happen, in any phase; corrections always go back to the original source system.

