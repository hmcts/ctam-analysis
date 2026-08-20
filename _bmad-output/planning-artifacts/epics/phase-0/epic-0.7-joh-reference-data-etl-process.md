---
type: 'Epic'
description: 'User outcome: an in-process nightly ETL process pulls the JOH eLinks API and full-refresh-upserts the tier-(a) jo_* tables designed in Epic 0.1, so jo_people exists and is current — making JOH sign-in resolvable (FR1) and jurisdiction available without any legacy migration.'
resource: 'epics/phase-0/epic-0.7-joh-reference-data-etl-process.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-20'
parent: 'epics/phase-0/index.md'
epic: 0.7
title: 'JOH reference data flows into CTAM via the nightly eLinks ETL process'
storyCount: 1
repo: ctam-reference-data
depends_on: [epic-0.1]                      # needs the tier-(a) schema + write protection to exist first
---

# Epic 0.7: JOH reference data flows into CTAM via the nightly eLinks ETL process

> **Split from Epic 0.1 2026-08-20 (SCP 2026-08-20b):** this epic carries the story previously numbered 0.1.3, renumbered 0.7.1. No AC content changed. The schema this ETL process writes into is designed in **[Epic 0.1](epic-0.1-postgres-db-schema-design.md)**.

**User outcome:** Judicial-holder reference data flows into CTAM Pathfinder from its upstream source of truth — the **JOH eLinks API** (15 `jo_*` entities, nightly) — so that `jo_people` exists and is current, `jo_jurisdictions` is available as the first-class jurisdiction dimension (D8), and judicial-holder reference data is authoritative in CTAM **without any legacy migration** (revised D3, NFR24). JOH sign-in (Epic 0.2) is impossible until `jo_people` — the identity-lookup target — is populated by this ETL process.

**Hosting:** the ETL runs in-process inside `ctam-reference-data` — no separate `ctam-integrations` repo, no new deployable, no service principal (AR46).

**Vertical slice:**
- **JOH eLinks nightly in-process `@Scheduled` sync** (AR46, AR48) over the tier-(a) schema designed in Epic 0.1
- Full-refresh upsert on upstream natural keys; soft-deactivation (never hard-delete); every run logged to `ctam_sync_status`
- Manual out-of-cycle trigger for ops

**FRs covered:** FR1 (the identity-lookup *target* data — `jo_people` populated), FR6 tier-(a) (writes follow the tier), FR7 (tier-(a) writes via this ETL process only).

**Key NFRs first exercised here:** NFR16 (Key Vault — the eLinks API credential), NFR24 (JOH eLinks MVP integration), NFR25–NFR28 (structured logs + Application Insights + probes, inherited from the scaffold).

**Out of scope (explicitly):** The MRD ingestion (Epic 0.8). The tier-(a) schema and write-protection grants themselves (Epic 0.1, Story 0.1.2 — this epic only populates them). The read-only Reference Data API (Epic 0.3, Story 0.3.2). All authentication / authorisation / UI (Epic 0.2).

---

## Story 0.7.1: JOH reference data flows into CTAM nightly from the JOH eLinks API

As a **CTAM Pathfinder platform** (and every downstream consumer of JOH identity and reference data),
I want an in-process scheduled sync that pulls the JOH eLinks API nightly and refreshes the tier-(a) `jo_*` tables,
So that **`jo_people` exists and is current — making JOH sign-in resolvable (FR1), jurisdiction available (`jo_jurisdictions`, D8), and judicial-holder reference data authoritative without any legacy migration** (revised D3, NFR24).

**Acceptance Criteria:**

**Given** the tier-(a) `jo_*` tables and `ctam_sync_status` exist per Epic 0.1, Story 0.1.2,
**When** the engineer implements the eLinks sync as an in-process `@Scheduled` task (per AR46 — no new deployable, no service principal),
**Then** the sync runs on its nightly schedule and pulls all 15 entities from the JOH eLinks API using the outbound credential held in Azure Key Vault (per NFR16),
**And** it **full-refresh-upserts** each table keyed on the upstream natural key (`personnel_number` for `jo_people`), and mints a `ctam_joh_identities` row (a stable CTAM JOH UUID keyed to `personnel_number`) for any `jo_people` row lacking one,
**And** rows absent upstream are **marked inactive — never hard-deleted** (FK protection per AR46),
**And** the run is recorded in `ctam_sync_status` with source, started/finished timestamps, outcome, per-entity row counts, and error detail (per AR48),
**And** the sync is also manually triggerable by ops (e.g. an actuator-adjacent admin endpoint or k8s Job) for out-of-cycle refreshes.

**Given** the JOH eLinks API is unreachable or returns a malformed payload mid-sync,
**When** the sync fails,
**Then** the previous good state remains fully in place (ingestion is transactional per entity set — never partially written, per AR48),
**And** the failure is recorded in `ctam_sync_status` and surfaced via structured logs with correlation ID for ops triage,
**And** reference data is at most one sync cycle stale.

**Given** the sync has run successfully at least once in dev,
**When** `ctam-authorisation` (Epic 0.2, Story 0.2.3) looks up a seeded JOH email,
**Then** the lookup resolves against `jo_people` to a `personnel_number`, and via `ctam_joh_identities` to the CTAM JOH UUID,
**And** dev/CI environments use seeded `jo_*` fixtures loaded by the one-off seed scripts where a live eLinks connection is unavailable (per AR52 — the sync code path is integration-tested against a WireMock/stub eLinks API in CI).

**Given** the JOH eLinks API contract has not yet been confirmed (gaps.md G8.1),
**When** the contract lands,
**Then** the ingestion mapping is validated against it (every upstream field CTAM needs has a slot; the natural-key scheme holds; cadence/SLA workable),
**And** any unmapped upstream structure raises an architectural PR (per G8.1) — this AC is the story's external-dependency gate and is tracked explicitly in sprint planning.

**References:** FR1 (identity lookup target), FR6 tier (a), FR7 (writes follow the tier); NFR16, NFR24, NFR25–NFR28; AR46, AR48, AR49; gaps.md G8.1; D3 (revised), D8, D9 (restructured).

**Explicitly NOT in scope:**
- MRD ingestion — Epic 0.8, Story 0.8.1
- The tier-(a) schema and write-protection grants — Epic 0.1, Story 0.1.2
- The read-only REST API — Epic 0.3, Story 0.3.2

[^d3]: Revised D3 (2026-06-10) — no data migration from any legacy system; judicial-holder reference data is ingested from the JOH eLinks API and MRD.
[^d8]: D8 — rollout is jurisdiction-first, then per-region; jurisdiction is a first-class hierarchical attribute.
[^d9]: Restructured D9 (2026-06-10; refined 2026-07-09 per SCP) — two user populations. JOHs resolve IdP email → `jo_people` → `personnel_number` → a **CTAM-assigned JOH UUID** (`ctam_joh_identities`); HMCTS admin staff via a CTAM-internal identity table. Both key on a CTAM-assigned UUID; `personnel_number` is the upstream link only. No legacy user migration.
