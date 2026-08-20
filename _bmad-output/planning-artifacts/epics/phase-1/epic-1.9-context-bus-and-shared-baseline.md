---
type: 'Epic'
description: 'User outcome: the published context bus exists and is version-pinned (arch-vN), and the shared ctam_configuration_values infrastructure table exists with SELECT granted to every service role — both in place before the first domain service is built. Promoted from a dispatch-graph node to a first-class epic 2026-08-19 (SCP 2026-08-19d) so BMad tracks it.'
resource: 'epics/phase-1/epic-1.9-context-bus-and-shared-baseline.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-08-19'
parent: 'epics/phase-1/index.md'
epic: 1.9
title: 'Context bus is published and the shared configuration baseline exists'
storyCount: 2
repo: ctam-architecture
depends_on: [epic-1.0]
---

# Epic 1.9: Context bus is published and the shared configuration baseline exists

> **Runs between Epic 1.0 and Epic 1.1 — the number is not the order.** Sequence comes from `depends_on`, not from the epic number: this epic depends on Epic 1.0 and Epic 1.1 depends on it. Note the dependency is **story-specific in practice** — Story 1.9.1 (publish and tag the bus) needs nothing and is already done; only Story 1.9.2 (the Liquibase baseline) needs Epic 1.0's shared PostgreSQL. `depends_on` is epic-level, so it records the stricter of the two; expect `dispatch-preflight.sh` to flag Epic 1.0 as a blocker for 1.9.1 even though that story is complete. **Numbering history:** first added as Epic 0.6 (SCP 2026-08-19d) — deliberately out of build order, since renumbering the then-authored epics 0.1–0.5 for no benefit was rejected. Moved to Epic 0.8 (SCP 2026-08-20c) when Epic 0.1 was split and the JOH/MRD ETL epics were inserted at 0.2/0.3, cascading every later epic number up by two. Moved again to Epic 0.9 (SCP 2026-08-20e) to make room for the MRD read-API epic sliding in at 0.6, directly after Epic 0.5. Moved once more to **Epic 1.9** (SCP 2026-08-20h) when Phase 0 and Phase 1 were swapped wholesale — this epic's Foundations content now lives in the folder called `phase-1/` — the "number is not the order" principle is why every one of these moves was acceptable rather than disruptive.
>
> **History:** this was `arch-baseline` in `delivery/dispatch-graph.yaml`, a node marked `decomposed: false`. That made it invisible to every BMad skill — it appeared in no sprint status, had no stories, and could not be dispatched. Promoted to a real epic when the dispatch graph was retired (SCP 2026-08-19d).

**User outcome:** Every service repo can pin one published, versioned copy of the architecture (the **context bus**), and every service can read cross-service runtime policy values from one shared table it does not own. Both exist before the first domain service is scaffolded, so no service has to invent a local copy of shared truth or a local config table.

**Vertical slice:**
- `ctam-architecture` published as the context bus: the architecture set (`architecture.md` + `architecture/` shards + `prd.md` mirror) plus the authored `agent-rules/` pack, tagged `arch-vN`
- The publish mechanism is reproducible, not hand-copied (`ctam-analysis/scripts/publish-arch.sh`)
- `ctam_configuration_values` created by a Liquibase **baseline changelog owned by `ctam-architecture`** — the one table with no owning service (per `data-tables.md`)
- `SELECT` granted to every service DB role; no service granted write
- Both verifiable: a service repo can add the submodule at the tag and read it; a service role can read the table and cannot write it

**FRs covered:** FR8 (shared cross-service policy values)

**Key NFRs:** NFR16 (secrets stay in Key Vault — this table is for policy, never secrets), NFR40 (auditable trail: bus versions are tags, schema changes are changelogs)

**Out of scope for Phase 0 (deferred):**
- A UI or API for editing configuration values — **post-MVP**; MVP maintenance is DBA-via-SQL per operational runbooks[^d10]
- Publishing `diagrams/`, `sequence-diagrams/` or `architecture/analysis/` to the bus — added when a consumer needs them, not speculatively
- The `api-specs/` read-only contract mirror — arrives with the first published service spec (Epic 1.5)

---

## Story 1.9.1: Publish `ctam-architecture` as the context bus and tag `arch-v1.0`

As a **platform engineer**,
I want the architecture set and the agent-rules pack published in `ctam-architecture` and tagged,
So that **every service repo can pin exactly one version of shared truth** as a submodule, and adopt a newer one only by a deliberate, auditable bump.

**Acceptance Criteria:**

**Given** the canonical architecture lives in `ctam-analysis/_bmad-output/planning-artifacts/`,
**When** `ctam-analysis/scripts/publish-arch.sh` is run,
**Then** `architecture.md`, `architecture-summary.md`, `prd.md` and every `architecture/*.md` shard are copied into `ctam-architecture`,
**And** `architecture/PUBLISHED.md` states that those files are a mirror and must never be hand-edited,
**And** the script performs no version-control operations of its own.

**Given** the published payload plus the authored `agent-rules/` pack are on `main`,
**When** the release is tagged,
**Then** an annotated tag `arch-v1.0` exists on `ctam-architecture`,
**And** the tag is pushed and readable by `git ls-remote --tags`,
**And** tagging was performed by a human — a Claude session cannot create tags (agent-rules R13).

**Given** a service repo needs shared truth,
**When** it adds `ctam-architecture` as a submodule at `_arch/` and checks out `arch-v1.0`,
**Then** `_arch/agent-rules/00-core.md` and `_arch/architecture/conventions.md` both resolve,
**And** the pinned version is recorded in the repo's `CLAUDE.md` and in each story packet's `bus_version`.

**Given** a convention later changes,
**When** the change is published,
**Then** it is a new tag (`arch-v(N+1)`) plus a deliberate submodule bump in each adopting repo — the bus never mutates a downstream repo silently.

**References:** FR8; NFR40; AR2; `architecture/delivery-operating-model.md` (Decision 1, the bus-pinning rule); `architecture/repo-structure.md` (the `ctam-architecture` tree).

---

## Story 1.9.2: Shared `ctam_configuration_values` Liquibase baseline with per-service SELECT grants

As a **service developer**,
I want one shared, typed table of cross-service runtime policy values that my service can read but not write,
So that policy visible to several services (session-timeout warnings, batch schedules, feature flags) lives in exactly one place, instead of being duplicated per service or hard-coded.

**Acceptance Criteria:**

**Given** the shared PostgreSQL instance from Epic 1.0 exists,
**And** the engineer adds `ctam-architecture`'s Liquibase **baseline** changelog,
**When** Liquibase applies it,
**Then** `ctam_configuration_values` exists in the shared schema,
**And** it holds **typed** policy values — a key, a value, and the value's type — with `id uuid` primary key and `created_at` / `updated_at timestamptz NOT NULL`, per `conventions.md` → *Naming Patterns*,
**And** no column beyond that minimal shape is added without a cited need (agent-rules R6),
**And** the table is documented as **shared infrastructure with no owning service** in `architecture/data-tables.md`.

**Given** the table exists,
**When** DB roles are granted,
**Then** every service role holds `SELECT` on it,
**And** **no service role holds INSERT, UPDATE or DELETE** — writes are DBA-only in MVP,
**And** the grants are codified in `ctam-architecture`'s changelog, not applied by hand (per `gaps.md` G6.4).

**Given** a service reads a policy value,
**When** it does so,
**Then** it reads via JPA against the shared schema — there is no configuration client or service to call,
**And** the value is treated as policy, never as a secret: secrets remain in Azure Key Vault (NFR16).

**Given** an integration test runs,
**When** the baseline changelog is applied to an empty database via Testcontainers,
**Then** the table and its grants are created from scratch and asserted — proving the changelog, not the developer's local database (agent-rules P6).

**References:** FR8; NFR16; `architecture/data-tables.md` (shared-infrastructure row); `architecture/conventions.md` → *Naming Patterns*; `gaps.md` G6.4 (grant maintenance).

**Explicitly NOT in scope:**
- Any write path, UI or API for configuration values — post-MVP[^d10]
- Per-service configuration, which stays in Spring profiles + `application.yml` + Key Vault (FR8 revised v2.2)

[^d10]: D10 (2026-05-15) — admin UI is post-MVP; MVP admin operations are DBA-via-SQL per operational runbooks.
