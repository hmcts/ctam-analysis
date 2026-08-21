---
type: 'Epic'
description: 'ctam-reference-data is scaffolded as the first CTAM Pathfinder service to be built, and its underlying database schema - 15 tables holding judicial office holder and tribunal data, plus a table that logs every data-sync run - is designed with a firm rule that only this one service is ever allowed to write to it. This gives the teams building the nightly and weekly data feeds from the outside source systems a proper, protected schema to load their data into.'
resource: 'epics/phase-1/epic-1.1-postgres-db-schema-design.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-06-17'
parent: 'epics/phase-1/index.md'
epic: 1.1
title: 'Postgres reference-data schema is designed and scaffolded'
storyCount: 2
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

---

## Story 1.1.1: Scaffold `ctam-reference-data` from the HMCTS starter template

As a **platform engineer**,
I want to scaffold the **first** CTAM Pathfinder backend service — `ctam-reference-data` — from HMCTS's standard Spring Boot starter template using the programme's scaffolding script, and deploy it onto the shared cloud environment that already exists,
So that **every service built after it follows the same consistent, secure, version-pinned baseline**, and the team can prove the whole deployment pipeline works end to end against the already-verified shared platform, before any actual business logic is written.

**Acceptance Criteria:**

**Given** the engineer has worked through the GitHub manual-setup checklist (found in the architecture repo's runbooks) **before** running the scaffold script:
  - Created an empty private GitHub repository named `ctam-reference-data` under the HMCTS organisation, through GitHub's website
  - Turned on branch protection for `main` via Settings → Branches (requiring a PR review, requiring status checks to pass, and requiring a linear history)
  - Note: GitHub's command-line tool is not available in this engineering environment, so all GitHub admin setup — creating the repo, branch protection, team access — is done manually through the website, following the runbook,
**And** the engineer has a clean local development setup with Java 25, the Gradle wrapper, and Docker installed,
**When** the engineer runs the scaffolding script against `ctam-reference-data` from the architecture repo's scaffolding folder,
**Then** the script builds a Spring Boot 4.0.x project locally from HMCTS's Crime Spring Boot template (`https://github.com/hmcts/service-hmcts-crime-springboot-template`), then commits and pushes it to the pre-created GitHub repository on a feature branch using plain `git` commands (no GitHub command-line tool involved),
**And** the resulting project is a Spring Boot 4.0.x scaffold built from that same HMCTS template,
**And** the Gradle build uses the Groovy DSL, with the Spring Boot Gradle plugin version 4.1.0 and the `io.spring.dependency-management` plugin version 1.1.7,
**And** the project's group ID is `uk.gov.hmcts.ctam`, its artefact name is `ctam-reference-data`, its base Java package is `uk.gov.hmcts.ctam.referencedata`, and it runs on port 8082 by default,
**And** the initial commit message is exactly *"Scaffold CTAM Pathfinder reference-data from HMCTS starter"*,
**And** Lombok 1.18.46 and MapStruct 1.6.3 are set up and ready to use,
**And** the JJWT library (version 0.13.0) and the OWASP HTML/text encoder (version 1.4.0) are available on the classpath,
**And** springdoc-openapi is configured to generate OpenAPI 3.x API documentation automatically,
**And** JaCoCo (test coverage), CycloneDX (software bill of materials), the Gradle git-properties plugin, the Gradle versions plugin, and the Gradle Docker Compose plugin are all configured,
**And** Spring Boot Test with JUnit 5 (using the JUnit BOM version 6.0.3), Testcontainers for PostgreSQL (version 1.21.4), Spring Boot's Testcontainers support (version 4.1.0), and the Spring MVC test starter are all set up,
**And** Spectral (API-contract linting), ArchUnit (architecture rule checking), Spotless, and Checkstyle are all configured,
**And** a starter Helm chart exists at `charts/ctam-reference-data/`, with separate configuration overlays for dev, staging, and production,
**And** a `terraform/` folder exists with separate dev, staging, and production stacks holding only this service's own cloud resources (its secrets-store namespace, plus storage for the weekly MRD file drop added later) — the shared cloud environment itself lives in a separate, central infrastructure setup,
**And** GitHub Actions workflow files exist for continuous integration and for deploying to dev, staging, and production,
**And** a `CODEOWNERS` file and a pull-request template exist,
**And** a starter Postman collection exists at `postman/ctam-reference-data-phase0.postman_collection.json`.

**Given** the scaffolded service is running locally (started with `./gradlew bootRun` after bringing up a local Postgres container),
**When** the engineer checks the service's health-check address on `http://localhost:8082`,
**Then** it responds `200 OK` with the body `{"status":"UP"}`,
**And** the service's info endpoint returns build/git metadata automatically embedded at build time,
**And** the readiness-check endpoint also responds `200 OK`,
**And** the service prints structured JSON logs to its console output, using the Logstash Logback Encoder (version 9.0),
**And** every log line includes a correlation ID that's automatically attached to each incoming request — this is the very first place structured logging is exercised in the programme.

**Given** the shared cloud environment has already been built and independently checked in the programme's earlier infrastructure work — the shared Kubernetes cluster, the shared PostgreSQL database server, the container registry, the API gateway with its baseline security policies, the monitoring and logging workspace, and the secrets store — all running in the UK South region with the agreed sizing,
**When** `ctam-reference-data`'s Helm chart is deployed to the dev Kubernetes cluster,
**Then** the service successfully reaches the shared cluster, database, container registry, gateway, and monitoring setup that already exists (this story uses that shared environment; it does not build it),
**And** if any part of that shared environment is missing, the deployment fails fast with a clear error message, rather than failing silently or partway through.

**Given** the shared baseline database-migration script (owned centrally, and run before `ctam-reference-data`'s own migrations),
**When** that baseline is applied to the dev database,
**Then** the shared `ctam_configuration_values` table exists,
**And** `ctam-reference-data`'s own database role has read (SELECT) access to that shared table,
**And** `ctam-reference-data`'s own folder of database-migration scripts exists (with its master changelog file) but is still empty at this point — the actual tables are added in the next story.

**Given** the shared API gateway, already set up and TLS-verified in the earlier infrastructure work,
**When** `ctam-reference-data` registers its API through that gateway and a request comes in over HTTP,
**Then** the service's API is reachable securely over HTTPS,
**And** any plain HTTP request is rejected with a redirect to HTTPS.

**Given** the shared PostgreSQL database server, already set up with encryption and TLS verified in the earlier infrastructure work,
**When** the dev configuration overlay is applied,
**Then** the database connection details point to that shared server, which encrypts data at rest and only accepts encrypted connections,
**And** `ctam-reference-data` connects to it successfully using its own dedicated database role.

**Given** the shared monitoring workspace, already set up in the earlier infrastructure work with an agreed data-retention policy,
**When** the deployed service sends telemetry,
**Then** `ctam-reference-data`'s structured logs and traces land in that shared workspace.

**Given** the engineer pushes the initial commit to a feature branch,
**And** opens a Pull Request from that branch into `main` manually through GitHub's website,
**When** the continuous-integration workflow runs,
**Then** it runs the build, the automated tests, the API-contract lint, the architecture-rule checks, and the code-style and Helm-chart checks,
**And** all of those checks pass on the freshly scaffolded baseline,
**And** a test-coverage report is produced.

**Given** the Pull Request is merged into `main` through GitHub's website (the engineer clicks "Merge pull request" once it's approved),
**When** the deploy-to-dev workflow triggers automatically,
**Then** the service deploys to the dev Kubernetes cluster in the UK South region,
**And** its container image is pushed to the shared container registry,
**And** the deployed instance passes its liveness and readiness checks,
**And** the shared monitoring workspace receives its first structured log entries from the service.

> **Scaffolding note:** the HMCTS Crime Spring Boot template on its own is minimal. The programme's scaffolding script layers the remaining pieces on top of it — the database-migration tooling, Testcontainers, MapStruct, the OWASP encoder, the Docker Compose plugin, the API-documentation tooling, Helm, the secrets-store integration, and the CI quality checks — drawing on a second HMCTS reference template plus the programme's own conventions. A full inventory of what comes from where lives in the architecture documentation's starter-template reference.

**Explicitly NOT in scope:**
- The 15 outside-sourced tables and the data-sync run-log table — that's the next story
- The nightly JOH data sync itself
- The weekly MRD data sync, and the database tables it owns
- CTAM's own reference tables, and the read-only API on top of them

---

## Story 1.1.2: The 15 outside-sourced tables exist, with write access locked to this service alone

As **the CTAM Pathfinder platform** (and every future feature that reads judge and tribunal-member data),
I want the 15 database tables that hold judge, appointment, role, location, and ticket data sourced from outside CTAM, plus the run-log table for data-sync jobs, created through this service's own versioned migration scripts, with write access locked down so that only `ctam-reference-data` can ever change them,
So that **the judge and tribunal-member data these tables will eventually hold exists with the right structure and the right protection before the nightly JOH data sync starts loading real data into it**.

**Acceptance Criteria:**

**Given** `ctam-reference-data` has already been scaffolded as described in the previous story,
**When** the engineer adds a new database-migration script (a formatted-SQL changeset, included from the service's master migration file),
**Then** all 15 outside-sourced tables exist with the structure documented in the programme's data-tables reference: the people table, the appointments table, the judiciary role-assignment table, the authorisations-with-dates table, plus tables for appointment titles, base locations, contract types, genders, judiciary roles, jurisdictions, locations, location types, tickets, ticket categories, and ticket category types,
**And** the run-log table for tracking data-sync jobs also exists,
**And** the people table's `personnel_number` field is treated as the source system's own natural identifier for each person — CTAM binds a separate, stable, CTAM-generated unique ID to each person (in its own identities table) that every other part of the platform actually refers to; `personnel_number` itself is used only as the link back to the source system, not as CTAM's internal identifier,
**And** the jurisdictions table preserves the parent-child hierarchy that the source system uses (or builds that hierarchy in as data is first loaded),
**And** the `ctam_reference_data` database role owns all of these tables, and no other role is ever granted permission to insert or update rows in any of them — this is the enforced single-writer rule for this outside-sourced data,
**And** read-only access is granted to the authorisation service (for identity look-ups) and to placeholder roles reserved for future services,
**And** an automated check in the CI pipeline verifies that this write-protection rule actually holds, so it can never silently regress.

**Explicitly NOT in scope:**
- The nightly JOH data sync that will actually populate these tables with real data
- The weekly MRD data sync, and the separate tables it owns
- CTAM's own reference tables (regions, offices, controlled vocabularies) — that's later work
- The read-only API that will eventually expose this data to other services
