---
type: 'Epic'
description: 'Publishes one official, version-tagged copy of the architecture that every service team can build against, and creates a single shared table of cross-service configuration values that every service can read but none can change. Both need to be in place before any service is built, so no team has to invent its own copy of shared truth or its own configuration table.'
resource: 'epics/phase-1/epic-1.9-context-bus-and-shared-baseline.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-08-19'
parent: 'epics/phase-1/index.md'
epic: 1.9
title: 'Context bus is published and the shared configuration baseline exists'
storyCount: 1
repo: ctam-architecture
depends_on: [epic-1.0]
---

# Epic 1.9: Context bus is published and the shared configuration baseline exists

> This piece of work has moved and been renumbered several times as the plan evolved; its current number reflects that history, not its priority. It also started life as an informal placeholder rather than a properly tracked piece of work, and has since been promoted so it is fully visible to the team and can be planned and delivered like any other epic.

**Business Goal:** Every team building a CTAM Pathfinder service needs to work from the same shared understanding of the architecture, and every service needs somewhere to read a handful of programme-wide settings from — things like session-timeout warnings, batch schedules, and feature flags — without each team inventing its own copy or hard-coding the values. This epic puts both of those foundations in place before the first service is built, so no team has to guess at shared conventions or build a one-off configuration mechanism of its own.

**What this covers:** This is two related pieces of foundational groundwork. The first is publishing the architecture itself — turning the working planning documents into one official, version-tagged package that every service repository can pin a copy of and only update on purpose. The second is creating one small, shared database table that holds programme-wide configuration values, which every service can read but none can change directly. Neither piece is tied to a single feature; both exist so later work has solid, shared ground to build on.

A practical note on sequencing: although this epic sits between two others in the numbering, the actual build order comes from what each piece of work genuinely needs, not from the numbers. In practice, this epic's two pieces of work have different real dependencies — publishing the architecture package needed nothing else and is already complete (Story 1.9.1); the second piece, creating the shared configuration table, needs the shared database to exist first and is not yet decomposed into a story. Because dependencies are tracked at the whole-epic level, automated readiness checks may still flag the earlier database epic as a blocker for the whole of this epic, even though the first piece didn't actually need it.

**Outcome:** Every service team can pin one official, version-tagged copy of the architecture (referred to as the "context bus"), and every service can read shared, programme-wide settings from one table it doesn't own. Both are ready before the first service is scaffolded, so nobody has to invent a local copy of shared truth or a local settings table.

**What's included:**
- The `ctam-architecture` repository published as the official architecture package: the architecture documents and their supporting sections, the product requirements document, and an authored pack of agent working-rules, all tagged as a numbered release (for example, `arch-v1.0`)
- A repeatable publishing script (`ctam-analysis/scripts/publish-arch.sh`) that produces this package, rather than someone copying files by hand
- A new shared database table, `ctam_configuration_values`, created through a database migration script owned by the `ctam-architecture` repository — this is the one table in the whole programme that no single service owns
- Read-only access to that table granted to every service; no service is allowed to write to it
- Both pieces are checkable in practice: a service repository can pull in the published architecture at its tagged version and read it, and a service's database role can read the shared table but cannot write to it

**Why this matters:** Secrets and passwords never belong in this shared table — those stay in the programme's secure secrets vault, and this table is strictly for everyday policy settings. Every version of the published architecture is a clearly tagged release, and every change to the shared table happens through a tracked migration script, so there's always a clear, auditable record of what changed and when.

**Explicitly out of scope for now:**
- A screen or API for editing these shared configuration values directly — that's planned for later; for now, changes are made directly in the database by a database administrator, following the team's standard operating procedures
- Publishing supporting diagrams or deeper analysis documents into the architecture package — that will be added once a team actually needs them, rather than speculatively now
- A read-only mirror of individual services' own API specifications — that arrives once the first service's own API specification is published, later in the programme

---

## Story 1.9.1: Publish `ctam-architecture` as the official, version-tagged architecture package

As a **platform engineer**,
I want the architecture documents and the agent working-rules pack published together in the `ctam-architecture` repository and tagged as a release,
So that **every service team can pin exactly one version of the shared architecture**, and only move to a newer version through a deliberate, visible update — never silently.

**Acceptance Criteria:**

**Given** the official architecture documents live in this planning repository,
**When** the publishing script is run,
**Then** the main architecture document, its summary, the product requirements document, and every supporting architecture section are copied into the `ctam-architecture` repository,
**And** a note in that repository clearly states these files are a mirror and must never be hand-edited there,
**And** the script itself makes no version-control changes (such as commits or tags) — it only copies files.

**Given** the published files plus the authored agent working-rules pack are ready on the main branch,
**When** the release is tagged,
**Then** a proper, annotated release tag (`arch-v1.0`) exists on the `ctam-architecture` repository,
**And** that tag is pushed and can be seen by anyone checking the repository's tags,
**And** the tag is created by a person, not by an automated coding session — that's a deliberate human checkpoint.

**Given** a service repository needs the shared architecture,
**When** it pulls in `ctam-architecture` as a linked sub-repository at the `arch-v1.0` tag,
**Then** both the core agent working-rules file and the shared naming-and-conventions document are present and readable inside it,
**And** the exact version being used is written down in that service's own project instructions and in each piece of work's own tracking record.

**Given** a shared convention changes later on,
**When** that change is published,
**Then** it comes out as a new, higher-numbered release tag together with a deliberate update in each service repository that adopts it — the shared package never silently changes what a service is already using.

