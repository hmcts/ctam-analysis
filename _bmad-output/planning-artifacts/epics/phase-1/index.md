---
type: 'Phase Index'
title: 'Phase 1 — Foundations'
description: 'Ten epics that stand up the shared platform, the two upstream data feeds, sign-in, the reference-data read API, and notification - all before any judge-facing feature is built - so every later feature has a proven platform to build on instead of inventing its own.'
resource: 'epics/phase-1/index.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-06-17'
parent: 'epics/index.md'
phase: 1
phaseName: 'Foundations'
---

# Phase 1 — Foundations

> Phase 1 is sequenced **platform-then-integrations-first**: Epic 1.0 platform estate → Epic 1.1 schema/scaffold → Epics 1.2/1.3 ingestion → Epic 1.4 sign-in + UI → Epic 1.5 read API → Epic 1.6 MRD read API → Epic 1.7 bootstrap → Epic 1.8 notification. The shared Azure estate stands up and is independently verified first (Epic 1.0), then the data-ingestion work runs inside the reference-data service itself — there is no separate integrations service.
>
> Phase 1 is the platform's proving ground: every standard the programme will hold every later service to — versioned APIs, consistent error handling, structured logging — is exercised here first, on sign-in and reference-data reads, before any judge-facing feature is built.
>
> The Phase 1 areas in [../framework.md](../framework.md) are an **architectural map**. The ten concrete epics below are the **implementation plan** — each delivers a demoable outcome and carries its own supporting technical work as stories.

## Phase 1 scope model

- **No legacy data migration** — nothing migrates from any incumbent system, ever. Judicial-holder reference data is **ingested from its real upstream sources**: the JOH data source (nightly sync) and MRD (a weekly Excel drop). Historical data stays where it already lives.
- **The platform estate is the first deliverable (Epic 1.0)**: the shared Azure environment (Kubernetes cluster, database, container registry, API gateway, monitoring, secrets vault) is stood up and independently proven, layer by layer, before anything else is built on top of it.
- **The database design comes next (Epic 1.1), then the two data feeds (Epics 1.2/1.3)**: the reference-data service is the first service scaffolded, and it deploys onto the Epic 1.0 estate; its database design comes first, then the nightly JOH sync and the weekly MRD import populate it. Everything runs inside that one service — there's no separate integrations service.
- **Two genuinely different kinds of user**: judges and tribunal members are identified one way (via the judicial reference data), and HMCTS admin staff another way (via a separate internal identity table). Both end up sharing one permissions model and one CTAM-assigned identifier.
- **Jurisdiction matters everywhere**: every permission check, every reference-data lookup, and every phased rollout decision is aware of which jurisdiction (and region) a person or a piece of data belongs to.
- **No admin screens yet**: maintaining CTAM-owned reference data and user/role assignments is done directly by the database team for now; a proper admin interface is planned for later.

## Epics

| Epic | Title | Stories | Status |
|---|---|---|---|
| [1.0](epic-1.0-platform-estate-provisioned.md) | Platform estate is provisioned, verifiable, and CNP-compliant | 5 | 🟡 Planned |
| [1.1](epic-1.1-postgres-db-schema-design.md) | Postgres reference-data schema is designed and scaffolded | 2 | 🟡 Planned |
| [1.2](epic-1.2-joh-reference-data-etl-process.md) | JOH reference data flows into CTAM via the nightly eLinks ETL process | 1 | 🟡 Planned |
| [1.3](epic-1.3-mrd-reference-data-etl-process.md) | MRD reference data flows into CTAM via the weekly Excel ETL process | 1 | 🟡 Planned |
| [1.4](epic-1.4-user-authenticates.md) | User authenticates and lands on a role-scoped Home page | 5 | 🟡 Planned |
| [1.5](epic-1.5-joh-reference-data-read-api.md) | JOH and CTAM-owned reference data is served read-only via a versioned, jurisdiction-filtered API | 2 | 🟡 Planned |
| [1.6](epic-1.6-mrd-reference-data-read-api.md) | MRD reference data is served read-only via the Reference Data API | 1 | 🟡 Planned |
| [1.7](epic-1.7-user-populations-bootstrapped.md) | Both user populations are bootstrapped and verifiable against the IdP | 1 | 🟡 Planned |
| [1.8](epic-1.8-system-dispatches-emails.md) | Notification service is scaffolded and contractually ready | 2 | 🟡 Planned |
| [1.9](epic-1.9-context-bus-and-shared-baseline.md) | Context bus is published and the shared configuration baseline exists | 2 | 🟢 In progress |
| **Total** | | **22 stories** | |

## Epic summaries

### Epic 1.0: Platform estate is provisioned, verifiable, and CNP-compliant (5 stories)

**Outcome:** The shared Azure environment — the Kubernetes cluster, database, container registry, API gateway, monitoring, and secrets vault — is stood up in its own dedicated setup, provisioned one layer at a time with each layer proven working before the next is built, so every Phase 1 service has a tested platform to deploy onto. Comes before Epic 1.1. Its five stories build, in order: the repository and provisioning foundation; the network and cluster; the database and secrets vault; the container registry and monitoring; and the API gateway with an end-to-end smoke test.

→ [Full epic with stories](epic-1.0-platform-estate-provisioned.md)

### Epic 1.1: Postgres reference-data schema is designed and scaffolded (2 stories)

**Outcome:** The reference-data service is the first service scaffolded (Story 1.1.1) and deploys onto the shared platform from Epic 1.0; the database design for the data coming in from outside sources — the JOH tables and a sync-tracking table — is put in place with clear rules about who's allowed to write to it (Story 1.1.2). This is the platform's foundational data layer; the JOH and MRD data-import work that follows (Epics 1.2 and 1.3) populates it once it exists.

→ [Full epic with stories](epic-1.1-postgres-db-schema-design.md)

### Epic 1.2: JOH reference data flows into CTAM via the nightly eLinks ETL process (1 story)

**Outcome:** A nightly automated job (Story 1.2.1) pulls judge and tribunal-member data from the real JOH data source and keeps CTAM's copy of it current, using the database design from Epic 1.1 — the precondition for judges and tribunal members being able to sign in (Epic 1.4). This work was originally part of Epic 1.1 and was later split out into its own epic.

→ [Full epic with stories](epic-1.2-joh-reference-data-etl-process.md)

### Epic 1.3: MRD reference data flows into CTAM via the weekly Excel ETL process (1 story)

**Outcome:** A weekly file drop and scheduled pick-up (Story 1.3.1) imports the MRD team's Excel workbook into its own small table, making supplementary judicial data (notably JOH Specialisms) available without waiting for MRD to build a proper API. This work was also originally part of Epic 1.1 and was later split out into its own epic.

→ [Full epic with stories](epic-1.3-mrd-reference-data-etl-process.md)

### Epic 1.4: User authenticates and lands on a role-scoped Home page (5 stories)

**Outcome:** A user from either population — a judge or tribunal member, or HMCTS admin staff — signs in through single sign-on, has their identity worked out automatically, and lands on a Home page showing only what they're allowed to see. Depends on Epics 1.1 and 1.2 (the JOH data needs to already be flowing in) and deploys onto the shared platform from Epic 1.0.

→ [Full epic with stories](epic-1.4-user-authenticates.md)

### Epic 1.5: JOH and CTAM-owned reference data is served read-only via a versioned, jurisdiction-filtered API (2 stories)

**Outcome:** CTAM's own reference data (regions, offices, calendar, operational vocabularies) is created, seeded, and maintained directly by the database team for now (Story 1.5.1); together with the JOH data from Epic 1.2, it's made available through a versioned, read-only, jurisdiction-aware API (Story 1.5.2). Comes after Epic 1.4, since it needs sign-in and permission-checking to already exist. The MRD side of this same API is a separate epic (1.6), which extends this work rather than duplicating it.

→ [Full epic with stories](epic-1.5-joh-reference-data-read-api.md)

### Epic 1.6: MRD reference data is served read-only via the Reference Data API (1 story)

**Outcome:** JOH Specialisms (the MRD-sourced data) become queryable through the exact same API everything else already uses for reference data (Epic 1.5) — one new endpoint added to an existing, already-published API, not a new service or a new version. This work was split out of Epic 1.5 as genuinely new content — no MRD read endpoint existed before this epic.

→ [Full epic with stories](epic-1.6-mrd-reference-data-read-api.md)

### Epic 1.7: Both user populations are bootstrapped and verifiable against the IdP (1 story)

**Outcome:** Accounts for both populations exist (seeded for development and testing; set up through a proper process in production) with everyone starting deactivated by (jurisdiction, region) until their go-live date, and a re-runnable check proves every account genuinely maps back to a real sign-in identity — a standing gate the programme reuses at every future rollout wave.

→ [Full epic with stories](epic-1.7-user-populations-bootstrapped.md)

### Epic 1.8: Notification service is scaffolded and contractually ready (2 stories)

**Outcome:** The notification service is deployed with its way of being called published, its delivery-history table created, its connection to the real HMCTS email system configured, and its "send an email" endpoint working end to end. Later features (starting in the next phase) will call it directly using the identity of whoever is signed in. Proven by hand during this phase's testing — no admin screen yet.

→ [Full epic with stories](epic-1.8-system-dispatches-emails.md)

### Epic 1.9: Context bus is published and the shared configuration baseline exists (2 stories)

**Outcome:** Every service repository can pin one published, versioned copy of the shared architecture, and every service can read cross-service policy values from one shared table it doesn't own. Both exist before the first domain service is scaffolded.

This epic's number doesn't reflect when it actually runs — it sits between Epic 1.0 and Epic 1.1 in practice. It was promoted from an informal placeholder to a proper tracked epic once the programme's delivery tooling could represent it as one.

→ [Full epic with stories](epic-1.9-context-bus-and-shared-baseline.md)

## Phase 1 Epic Stories Summary

| Epic | Stories | Phase 1 demo |
|---|---|---|
| 1.0 | 5 stories (1.0.1–1.0.5) | Each infrastructure layer stands up and is proven working as it's deployed — the cluster is reachable and healthy, the database only accepts secure connections, the secrets vault round-trips a secret, the container registry can be pulled from, and the API gateway routes a test call all the way through |
| 1.1 | 2 stories (1.1.1–1.1.2) | The reference-data service is scaffolded onto the Epic 1.0 platform; the JOH database tables and sync-tracking table exist with write protection proven by an automated check |
| 1.2 | 1 story (1.2.1) | Judge and tribunal-member data flows in every night from the real data source, kept current and provable via the sync-tracking table |
| 1.3 | 1 story (1.3.1) | The MRD team's weekly Excel workbook flows in via the file drop, kept current and provable via the sync-tracking table |
| 1.4 | 5 stories (1.4.1–1.4.5) | A user from either population signs in, has their identity and permissions worked out automatically, and lands on a role-scoped Home page |
| 1.5 | 2 stories (1.5.1–1.5.2) | The jurisdiction-aware Reference Data API serves both CTAM's own data and the JOH data, read-only |
| 1.6 | 1 story (1.6.1) | The same Reference Data API gains a jurisdiction-aware JOH Specialisms endpoint |
| 1.7 | 1 story (1.7.1) | Seeded accounts across both populations are proven against the sign-in system; Epic 1.4's sign-in works against them |
| 1.8 | 2 stories (1.8.1–1.8.2) | The "send an email" endpoint works end-to-end, proven by hand with a testing tool |
| 1.9 | 2 stories (1.9.1–1.9.2) | A service repository pins the published architecture and resolves it; a service can read the shared configuration table but not write to it |
| **Total** | **17 stories** | The nine demos chain together for the Phase 1 stakeholder walkthrough — starting with the verified platform estate (Epic 1.0's 5 stories are the platform smoke-test that precedes this table, not counted here) |

**Quality standards proven across Phase 1:** secure connections everywhere (TLS), data encrypted at rest, sign-in tokens checked on every request, permissions enforced everywhere including by jurisdiction, no data that shouldn't be there, a documented trail for every change, secrets kept in the secure vault (including the credential used to reach the JOH data source), the public-facing application meeting government accessibility standards (the admin application is deferred), sign-in working against the temporary stand-in for the real HMCTS system, the real HMCTS email system reachable, both data feeds meeting their delivery targets, every service observable and independently deployable, hosted in the UK, following the programme's API-versioning and change-signalling conventions, and every service shipping a ready-made set of test requests other teams can reuse.

## Post-MVP roadmap items

1. **Admin-facing web application** — scaffolding + sign-in wrapper + the government design system's admin theme
2. **Reference Data maintenance screen** (CTAM-owned data only) in the admin application
3. **Users & Roles admin screen** in the admin application — search, edit roles / jurisdiction / region scope
4. **Reference Data API write endpoints** (CTAM-owned data only) — create/update/delete, admin-gated
5. **Authorisation service admin write endpoints**
6. **Admin "Send Test Email" screen**
7. **Delivery-log viewer screen**
8. **Activation-flag toggle screen** (per jurisdiction and region)

Upstream-sourced reference data never gets a write surface in any phase — corrections happen at the source, not in CTAM — and there is no migration-reports surface, since there is no migration to report on.

Not post-MVP (lands in a later MVP phase): a way for fully automated, scheduled processes to authenticate — needed once automated payment runs arrive later in the programme. The two nightly/weekly data feeds need no such mechanism, since they run inside the reference-data service itself.

## Validation

- Phase 1 awaits validation via the programme's implementation-readiness assessment for its first rollout wave.
