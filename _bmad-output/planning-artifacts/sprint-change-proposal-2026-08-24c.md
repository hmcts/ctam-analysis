---
type: 'Sprint Change Proposal'
description: 'Adds Epic 1.1 — the first Phase 1 epic — scoped to schema-only design and implementation of the ctam-joh service'"'"'s 5 domain tables (working patterns, overlays, jurisdictional splits) in PostgreSQL via Liquibase. No behavioral logic; that stays for future Phase 1 epics.'
resource: 'sprint-change-proposal-2026-08-24c.html'
tags: [ctam-pathfinder, sprint-change-proposal]
timestamp: '2026-08-24'
title: 'Sprint Change Proposal — 2026-08-24c'
status: 'proposed'
---

# Sprint Change Proposal — 2026-08-24c

**Trigger:** *"create an epic for postgress-sql-schema-design. This is to design and implement the joh schema in postgres sql database"*

**Clarified via two questions before drafting:**
1. **Which "JOH schema"** → **`ctam-joh`'s own domain schema** — the 5 CTAM-owned overlay tables (working patterns, ticket/location overlays, jurisdictional splits), *not* the tier-(a) `jo_*` eLinks tables (already covered by Epic 0.1 Story 0.1.2).
2. **Scope** → **Schema only** — tables, PKs/FKs, Liquibase changelogs, tier ownership/grants. No working-pattern-generation, overlay-CRUD, or jurisdictional-split-validation *business logic* — that's later Phase 1 work.

**Mode:** Batch. **Scope classification:** Moderate — this is the **first Phase 1 epic ever created** (Phase 1 currently has no epics/stories, only a `framework.md` area description), so it's a bigger step than the Phase-0 backlog edits earlier this session, even though its own content is schema-only.

---

## 1. Issue Summary

Phase 1 (JOH) has never been decomposed into epics — `epics/index.md`'s phase table lists it as "_to be storied_ / ⚪ Framework only," and `architecture/data-tables.md` already fully specifies `ctam-joh`'s 5 domain tables (§"JOH service (`ctam-joh`) — 5 tables") without any story ever scheduling their creation. The team wants to start Phase 1 with the database schema specifically — design and implement `ctam-joh`'s own PostgreSQL tables — before building the working-pattern/overlay business logic on top of them, mirroring the pattern Epic 0.1 already used (Story 0.1.2 "tables" landed before Story 0.1.3 "sync logic").

This SCP creates that one schema-only epic. It does **not** run the full `bmad-create-epics-and-stories` decomposition for Phase 1 — FR12–FR18's behavioral stories (working-pattern management, forward-sitting generation, overlay CRUD, jurisdictional-split workflow) remain undecomposed and are explicitly out of scope here.

## 2. Impact Analysis

### Epic impact

- **New Epic 1.1** — "JOH domain schema is designed and implemented in PostgreSQL" (file slug: `postgres-sql-schema-design`, per the trigger). First epic in a new `epics/phase-1/` folder.
- **Depends on Epic 0.1** (hard dependency: `ctam_joh_identities` — the FK target for every `ctam-joh` table's `joh_id` column — is minted by Epic 0.1's eLinks sync, Story 0.1.3, and its schema is created in Story 0.1.2). Also depends on **Epic 0.0** (shared estate) and **Epic 0.6** (context bus + config baseline), mirroring Epic 0.1's own dependency set for the same reasons (first `ctam-joh` scaffold needs both).
- **Open item flagged, not resolved here:** some of the 5 tables plausibly carry FK columns into tier-(b) vocabulary tables owned by `ctam-reference-data` (e.g. a working-pattern-type reference into `ctam_working_pattern_types`, landed in Epic 0.3 Story 0.3.1) — `data-tables.md` documents the vocabulary tables and their JOH-consumer relationship but not full column-level DDL, so I'm not asserting a hard Epic 0.3 dependency I can't verify. The new epic's schema story instead carries an explicit AC: verify each such FK against `data-tables.md` and Epic 0.3's landing status at implementation time; raise an architectural PR (same pattern as gaps.md G8.1's "unmapped upstream structure") if a referenced vocabulary table doesn't exist yet.
- No existing epic (0.0–0.8) changes.

### Story impact

- **New Story 1.1.1** — scaffold `ctam-joh` from the HMCTS starter (mirrors Story 0.1.1's pattern — first time this repo is scaffolded).
- **New Story 1.1.2** — the 5-table domain schema itself, via Liquibase, with tier ownership + grants (mirrors Story 0.1.2's pattern).
- No existing story changes.

### Artifact conflicts / updates needed

| Artifact | Change |
|---|---|
| `epics/phase-1/index.md` *(new)* | Phase 1 overview — Epic 1.1 only; explicit note that FR12–FR18 behavioral decomposition is still pending |
| `epics/phase-1/epic-1.1-postgres-sql-schema-design.md` *(new)* | The epic itself — 2 stories |
| `epics/index.md` | Phase-level breakdowns table: Phase 1 row updated from "_to be storied_ / ⚪" to link + partial status |
| `epics/framework.md` | Phase 1 · Area: JOH Records & Working Patterns — one-sentence cross-reference to Epic 1.1 |
| `epics/fr-coverage-map.md` | Phases 1–9+ pending table: FR10–FR18 row annotated (schema groundwork landed; behavior still pending) — status stays ⚪, not flipped to ✅ |
| `architecture/changelog.md` | New version entry |
| `sprint-status.yaml` | New `epic-1.1` block, 2 stories, `backlog` |

**Not touched:** `data-tables.md` (already fully specifies these 5 tables — nothing to change, this epic just schedules building what's already documented there). `architecture.md` decision log (no new architectural decision — the schema design was already fixed by `data-tables.md`; this is pure backlog scheduling). No PRD, FR/NFR, or UX change.

### Technical impact

None beyond what's already documented: `ctam-joh` becomes the second domain service scaffolded (after `ctam-reference-data`), owns 5 tables with the same conventions as every other domain table (`id uuid` PK, `joh_id` FK → `ctam_joh_identities.id`, `created_at`/`updated_at timestamptz NOT NULL`, Liquibase-only DDL, per-service DB role write ownership, ArchUnit grants fitness function). One genuinely open technical question, flagged as a story AC rather than resolved here: `ctam_jurisdictional_splits`' "must total 100%" constraint (FR16) is a **cross-row** invariant — a plain Postgres `CHECK` constraint can't express "this JOH's rows sum to 100," so the story requires the implementer to choose (and justify) a trigger, an application-level enforcement, or a materialized total column, rather than silently assuming one.

## 3. Recommended Approach

**Option 1 — Direct Adjustment (new epic).** Nothing rolls back (Phase 1 has zero stories today, so Option 2 doesn't apply) and nothing touches MVP scope or FR/NFR text (Option 3 doesn't apply). This is additive: one new epic, schema-only, in a phase that's otherwise still framework-only.

**Effort:** Low–Medium (two stories: a scaffold mirroring an already-proven pattern, and a schema migration against an already-fully-specified table set). **Risk:** Low, with one flagged design question (the 100%-sum constraint) that the story surfaces rather than resolves — appropriate for a schema-only epic to hand to the implementer as a cited open item, not something this SCP should invent an answer for. **Timeline impact:** None on Phase 0; this is the first step of Phase 1 and doesn't block anything currently in flight (all Phase 0 epics still `backlog`/`in-progress` per `sprint-status.yaml`).

## 4. Detailed Change Proposals

### 4.1 New file — `epics/phase-1/epic-1.1-postgres-sql-schema-design.md`

```markdown
---
type: 'Epic'
description: "User outcome: ctam-joh's own PostgreSQL domain schema — 5 tables (working patterns, ticket/location overlays, jurisdictional splits) — is designed and implemented via Liquibase, so later Phase 1 behavioral epics have a schema to build against. Schema only — no business logic."
resource: 'epics/phase-1/epic-1.1-postgres-sql-schema-design.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-08-24'
parent: 'epics/phase-1/index.md'
epic: 1.1
title: 'JOH domain schema is designed and implemented in PostgreSQL'
storyCount: 2
repo: ctam-joh
depends_on: [epic-0.0, epic-0.1, epic-0.6]
---

# Epic 1.1: JOH domain schema is designed and implemented in PostgreSQL

**User outcome:** `ctam-joh`'s own PostgreSQL domain schema — the 5 CTAM-owned overlay tables (`ctam_working_patterns`, `ctam_working_pattern_days`, `ctam_joh_ticket`, `ctam_joh_location`, `ctam_jurisdictional_splits` — per `architecture/data-tables.md`) — is designed and implemented via Liquibase, each keyed by `joh_id` → `ctam_joh_identities.id`, so that later Phase 1 epics (working-pattern management, overlay maintenance, jurisdictional-split workflow — FR12, FR15b, FR16, FR17) have a schema to build against. **Schema only** — no business logic, no API, no UI in this epic.

**Hosting:** `ctam-joh` is the **second** domain service scaffolded (after `ctam-reference-data`, Epic 0.1); it deploys onto the shared Azure estate provisioned in **Epic 0.0** and carries only its own per-repo Terraform. This epic does not build `ctam-joh`'s API or any working-pattern/overlay business logic — those are later Phase 1 epics, run via `bmad-create-epics-and-stories` once Phase 1 is fully decomposed.

**Vertical slice:**
- **Second scaffolded backend service: `ctam-joh`** (HMCTS Crime SpringBoot template + `ctam-scaffold.sh` conventions per AR2–AR4, same pattern as Epic 0.1 Story 0.1.1)
- **Consumes the shared Azure estate** provisioned in Epic 0.0
- The 5 domain tables, service-owned Liquibase changelog (AR18–AR20), keyed by `joh_id` → `ctam_joh_identities.id` (Epic 0.1)
- Tier ownership: only the `ctam_joh` DB role holds INSERT/UPDATE on its own tables; SELECT-granted to `ctam_reference_data` for JOH profile-view composition (per `data-tables.md`'s explicit note)

**FRs covered:** none behaviourally — **schema groundwork only** for FR12 (working patterns), FR15b (ticket overlay), FR16 (jurisdictional split), FR17 (location overlay). Full behavioral coverage is later Phase 1 epics.

**Key NFRs first exercised here (for `ctam-joh`):** NFR10 (TLS at APIM), NFR11 (data-at-rest), NFR25–NFR28 (structured logs + observability), NFR31 (Azure UK South), NFR40 (per-service deployable).

**Out of scope (explicitly):** Working-pattern generation / forward-sitting generation (FR13). Ticket/location overlay CRUD business logic. Jurisdictional-split validation workflow. JOH profile *view* composition itself (only the SELECT grant enabling it is this epic's concern). `ctam-joh`'s REST API. `ctam-ui`'s `joh/` module. All of these are future Phase 1 epics.

---

## Story 1.1.1: Scaffold `ctam-joh` from the HMCTS starter (onto the Epic 0.0 estate)

As a **platform engineer**,
I want to scaffold `ctam-joh` — the second CTAM Pathfinder backend service — from the HMCTS Crime SpringBoot template using `ctam-scaffold.sh`, and deploy it onto the shared Azure estate provisioned in Epic 0.0,
So that **the JOH domain schema (Story 1.1.2) has a service to live in**, following the same proven scaffold pattern Epic 0.1 established for `ctam-reference-data`.

**Acceptance Criteria:**

**Given** the engineer has performed the GitHub manual-setup checklist (`ctam-architecture/runbooks/github-setup.md`) **before** running the scaffold (repo `ctam-joh` created via the GitHub web UI; branch protection on `main`; no `gh` CLI, per D10),
**When** the engineer runs `ctam-scaffold.sh ctam-joh` from `ctam-architecture/scaffolding/`,
**Then** the script scaffolds a Spring Boot 4.0.x project locally from `https://github.com/hmcts/service-hmcts-crime-springboot-template`, commits, and pushes to the pre-created remote on a feature branch via plain `git`,
**And** Group ID is `uk.gov.hmcts.ctam`, artefact is `ctam-joh`, base package is `uk.gov.hmcts.ctam.joh`, default port is 8082 (per AR3),
**And** the same baseline dependency set as every other CTAM service is configured (Liquibase, Testcontainers PostgreSQL, MapStruct, OWASP encoder, docker-compose plugin, OpenAPI tooling, Helm chart, Key Vault, JaCoCo, CycloneDX SBOM — per AR5–AR17),
**And** a `terraform/` directory exists holding only `ctam-joh`'s own resources (Key Vault namespace) — the shared estate lives in `ctam-shared-infrastructure` (per AR53 revised),
**And** GitHub Actions workflows, `CODEOWNERS`, `PULL_REQUEST_TEMPLATE.md`, and a Postman collection skeleton exist (per AR28, AR29, AR41).

**Given** the shared Azure estate provisioned and independently verified in Epic 0.0,
**When** `ctam-joh`'s Helm chart is deployed to the dev AKS cluster,
**Then** the service reaches the shared cluster, database, registry, gateway, and observability estate (this story **consumes** the estate; it does not provision it),
**And** `GET /actuator/health` returns `200 OK`, liveness/readiness probes pass, and structured JSON logs with `correlationId` appear (per NFR25, NFR28, AR30, AR32).

**Given** the `ctam-architecture` Liquibase baseline and shared `ctam_configuration_values` table already exist (Epic 0.6),
**When** `ctam-joh` is scaffolded,
**Then** its DB role has `SELECT` on `ctam_configuration_values`,
**And** its own service-owned Liquibase changelog directory exists but is empty (the 5 domain tables are created in Story 1.1.2).

**References:** AR2–AR17, AR23–AR32, AR41, AR53 (revised); D10; depends on Epic 0.0 (shared estate) and Epic 0.6 (context bus + config baseline).

**Explicitly NOT in scope:**
- The 5 domain tables and tier ownership/grants — Story 1.1.2
- Any `ctam-joh` API, business logic, or UI — future Phase 1 epics

---

## Story 1.1.2: The 5 `ctam-joh` domain tables are designed and implemented

As a **CTAM Pathfinder platform** (and every future Phase 1 story that builds on this schema),
I want the 5 CTAM-owned `ctam-joh` overlay tables created via Liquibase, keyed by `joh_id` → `ctam_joh_identities.id`, with tier ownership and cross-service SELECT grants in place,
So that **later Phase 1 epics (working-pattern management, overlay maintenance, jurisdictional-split workflow) have a correctly-owned schema to build behavior against, and `ctam-reference-data` can compose JOH profile views without a shared code dependency**.

**Acceptance Criteria:**

**Given** `ctam-joh` is scaffolded per Story 1.1.1, and `ctam_joh_identities` exists (Epic 0.1, Story 0.1.2),
**When** the engineer adds the Liquibase changeset `db/changelog/001-init-joh-domain-tables.sql` (formatted-SQL, included from `db.changelog-master.yaml`),
**Then** the 5 tables exist per `architecture/data-tables.md`'s "JOH service (`ctam-joh`) — 5 tables" section:
  - `ctam_working_patterns` — per-JOH working-pattern definition (target sit %, active period; FR12)
  - `ctam_working_pattern_days` — per-day work-type breakdown within a working pattern (FR12)
  - `ctam_joh_ticket` — CTAM-overlay tickets layered on the upstream `jo_tickets` set (FR15 layer (b))
  - `ctam_joh_location` — JOH base-location changes recorded in CTAM, not propagated upstream (FR17)
  - `ctam_jurisdictional_splits` — per-JOH jurisdictional split percentages (FR16)
**And** every table has `id uuid PK`, `joh_id uuid` FK → `ctam_joh_identities.id` (never a bare `personnel_number`), and `created_at`/`updated_at timestamptz NOT NULL`, per house convention,
**And** `ctam_working_pattern_days` FKs to its parent `ctam_working_patterns.id`.

**Given** any of the 5 tables needs a foreign key into a tier-(b) vocabulary table owned by `ctam-reference-data` (e.g. a working-pattern-type reference into `ctam_working_pattern_types`),
**When** the engineer designs that column,
**Then** the referenced vocabulary table's existence and shape is verified against `data-tables.md` and Epic 0.3's landing status **before** the FK is added — an unmapped or not-yet-landed vocabulary table raises an architectural PR rather than being assumed (cite-or-ask; mirrors gaps.md G8.1's "unmapped upstream structure raises an architectural PR" pattern).

**Given** `ctam_jurisdictional_splits`' percentages must total 100% per JOH (FR16) — a **cross-row** invariant a single-row Postgres `CHECK` constraint cannot express,
**When** the engineer designs this table's enforcement,
**Then** the chosen mechanism (a trigger, application-level validation, or an equivalent) is explicit and justified in the migration's accompanying notes — this AC exists precisely so the choice is made deliberately, not defaulted to "no enforcement."

**Given** the tables are created,
**When** grants are configured,
**Then** the `ctam_joh` DB role owns all 5 tables and holds INSERT/UPDATE on them; **no other role holds INSERT/UPDATE** (mirrors AR49's tier-ownership pattern, now for `ctam-joh`'s own tier rather than tier (a)),
**And** `ctam_reference_data`'s DB role holds `SELECT` on all 5 tables (per `data-tables.md`: "the overlay tables are SELECT-granted to `ctam_reference_data`" for JOH profile-view composition),
**And** the ArchUnit/grants fitness function in CI verifies this write-protection + grant rule.

**References:** FR12, FR15b, FR16, FR17 (schema groundwork only — no behavior); NFR15; AR18–AR20, AR22; `architecture/data-tables.md` §"JOH service (`ctam-joh`) — 5 tables"; depends on Epic 0.1 Story 0.1.2 (`ctam_joh_identities`).

**Explicitly NOT in scope:**
- Working-pattern generation / forward-sitting generation (FR13) — future Phase 1 epic
- Ticket/location overlay CRUD, jurisdictional-split validation workflow — future Phase 1 epics
- JOH profile view composition (only the SELECT grant enabling it is here) — future Phase 1 epic
- `ctam-joh`'s REST API — future Phase 1 epic
```

### 4.2 New file — `epics/phase-1/index.md`

```markdown
---
type: 'Phase Index'
title: 'Phase 1 — JOH'
description: 'Epic 1.1 (schema only) is the first Phase 1 epic. FR10–FR18 behavioral decomposition is still pending a full bmad-create-epics-and-stories run for this phase.'
resource: 'epics/phase-1/index.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-08-24'
parent: 'epics/index.md'
phase: 1
phaseName: 'JOH'
---

# Phase 1 — JOH

> **Partial decomposition.** Only **Epic 1.1** (schema-only) exists so far — added via Sprint Change Proposal 2026-08-24c, ahead of a full Phase 1 decomposition. FR10–FR18's behavioral stories (working-pattern management, forward-sitting generation, overlay CRUD, jurisdictional-split workflow, JOH search/profile views — see [`../framework.md`](../framework.md) → *Phase 1 · Area: JOH Records & Working Patterns*) are **not yet storied**. Run `bmad-create-epics-and-stories` for Phase 1 to decompose the rest; Epic 1.1's schema is what those future epics will build against.

## Epics

| Epic | Title | Stories | Status |
|---|---|---|---|
| [1.1](epic-1.1-postgres-sql-schema-design.md) | JOH domain schema is designed and implemented in PostgreSQL | 2 | 🟡 Planned |
| **Total** | | **2 stories** | |

## Epic summaries

### Epic 1.1: JOH domain schema is designed and implemented in PostgreSQL (2 stories)

**User outcome:** `ctam-joh`'s 5 domain tables — working patterns, per-day pattern breakdown, ticket overlay, location overlay, jurisdictional splits — are designed and implemented via Liquibase, keyed by `joh_id` → `ctam_joh_identities.id`, with tier ownership and a cross-service SELECT grant to `ctam-reference-data`. **Schema only** — the behavioral stories that populate and maintain this schema are future Phase 1 epics.

**FRs covered:** none behaviourally — schema groundwork for FR12, FR15b, FR16, FR17.

→ [Full epic with stories](epic-1.1-postgres-sql-schema-design.md)

## Not yet storied

FR10, FR11, FR13, FR14, FR18, and the behavioral halves of FR12/FR15b/FR16/FR17 — see [`../framework.md`](../framework.md) → *Phase 1 · Area: JOH Records & Working Patterns* for the architectural map. Run `bmad-create-epics-and-stories` for Phase 1 when ready to decompose these.
```

### 4.3 `epics/index.md` — Phase-level breakdowns table

**OLD:**
```
| **1** — JOH | _to be storied_ | ⚪ Framework only |
```

**NEW:**
```
| **1** — JOH | [phase-1/](phase-1/index.md) | 🟡 Partially planned — 1 epic (schema only, SCP 2026-08-24c); FR10–FR18 behavior still to be storied |
```

### 4.4 `epics/framework.md` — Phase 1 · Area: JOH Records & Working Patterns

Append one sentence to the existing scope paragraph: *"`ctam-joh`'s own PostgreSQL schema (the 5 tables above) is designed and implemented in [Epic 1.1](phase-1/epic-1.1-postgres-sql-schema-design.md) — schema only; the behavioral stories in this area are not yet storied."*

### 4.5 `epics/fr-coverage-map.md` — Phases 1–9+ pending table

**OLD:**
```
| FR10–FR18 | 1 | JOH Records & Working Patterns (profiles are *views* over tier (a) + `ctam-joh` overlays; FR14 is display-only — conversions happen upstream) | ⚪ |
```

**NEW:**
```
| FR10–FR18 | 1 | JOH Records & Working Patterns (profiles are *views* over tier (a) + `ctam-joh` overlays; FR14 is display-only — conversions happen upstream). **Schema groundwork landed**: [Epic 1.1](phase-0/../phase-1/epic-1.1-postgres-sql-schema-design.md) (SCP 2026-08-24c) — schema only, behavior still ⚪ | ⚪ |
```

### 4.6 `architecture/changelog.md`

New version row (above the current top entry):

| **v4.11 — Phase 1's first epic: `ctam-joh` domain schema (schema only)** | 2026-08-24 | **Additive** (SCP 2026-08-24c), no FR/NFR/PRD/architecture-decision change — `data-tables.md` already fully specified these 5 tables. Adds **Epic 1.1** in a new `epics/phase-1/` folder: scaffold `ctam-joh` (Story 1.1.1) + create its 5 domain tables via Liquibase (Story 1.1.2), keyed by `joh_id` → `ctam_joh_identities.id` (Epic 0.1), tier-owned + SELECT-granted to `ctam_reference_data`. Schema only — FR12/FR15b/FR16/FR17's behavioral stories remain unstoried. Flags one open design question for the implementer: `ctam_jurisdictional_splits`' 100%-sum constraint is a cross-row invariant, not a plain `CHECK`. See [`../sprint-change-proposal-2026-08-24c.md`](../sprint-change-proposal-2026-08-24c.md). | new `epics/phase-1/index.md`, new `epics/phase-1/epic-1.1-postgres-sql-schema-design.md`; `epics/index.md`; `epics/framework.md`; `epics/fr-coverage-map.md`; `sprint-status.yaml` |

### 4.7 `sprint-status.yaml`

Append a new block:

```yaml
  epic-1.1: backlog
  1-1-1-scaffold-ctam-joh-from-the-hmcts-starter-onto-the-epic-0-0-estate: backlog
  1-1-2-the-5-ctam-joh-domain-tables-are-designed-and-implemented: backlog
  epic-1.1-retrospective: optional
```

## 5. Implementation Handoff

**Scope: Moderate** — first Phase 1 epic, schema-only, additive. No PRD/FR/NFR/architecture-decision change (the schema itself was already fixed in `data-tables.md`; this only schedules building it). Routed as **Product Owner / Developer**.

**Responsibilities:**
- **This session:** on approval, create the two new files and apply the five edits above, then regenerate `docs/` and add the two new NAV entries (`epics/phase-1/index.md`, `epics/phase-1/epic-1.1-postgres-sql-schema-design.md`) to `scripts/python/build_html.py`, following the same convention as the Phase 0 entries.
- **Implementing engineer (Story 1.1.2):** resolve the two flagged open items at implementation time — (a) verify any tier-(b) vocabulary FK against `data-tables.md`/Epic 0.3's status before adding it, raising an architectural PR if unmapped; (b) choose and justify the `ctam_jurisdictional_splits` 100%-sum enforcement mechanism.
- **Product Owner (human):** decide when to run `bmad-create-epics-and-stories` for the rest of Phase 1 (FR10–FR18 behavior) — not part of this SCP's scope.

**Success criteria:** `epics/phase-1/index.md` and the new epic file are internally consistent; `epics/index.md`'s Phase 1 row links correctly; `docs/` regenerates cleanly with both new pages reachable from the NAV sidebar; no FR/NFR/PRD text changed; `data-tables.md` unchanged (nothing here contradicts it).
