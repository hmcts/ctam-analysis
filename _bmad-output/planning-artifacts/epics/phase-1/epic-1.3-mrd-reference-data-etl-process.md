---
type: 'Epic'
description: 'User outcome: a weekly ETL process ingests the MRD teams Excel workbook from an Azure Blob drop into the mrd_* tables (schema designed within this epic), making supplementary judicial reference data (notably JOH Specialisations) available in CTAM without waiting for MRDs public APIs.'
resource: 'epics/phase-1/epic-1.3-mrd-reference-data-etl-process.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-08-20'
parent: 'epics/phase-1/index.md'
epic: 1.3
title: 'MRD reference data flows into CTAM via the weekly Excel ETL process'
storyCount: 1
repo: ctam-reference-data
depends_on: [epic-1.1]                      # needs ctam-reference-data scaffolded + the tier-(a) baseline first
---

# Epic 1.3: MRD reference data flows into CTAM via the weekly Excel ETL process

> **Split from Epic 1.1 2026-08-20 (SCP 2026-08-20b):** this epic carries the story previously numbered 0.1.4, renumbered 0.8.1. No AC content changed. `ctam-reference-data` itself is scaffolded in **[Epic 1.1](epic-1.1-postgres-db-schema-design.md)**.

**User outcome:** Judicial-holder reference data flows into CTAM Pathfinder from its supplementary upstream source of truth — the **MRD** weekly Excel dataset — so that data not present in JOH eLinks (notably JOH Specialisations) is available in CTAM **without any legacy migration** (revised D3, NFR24), and without waiting for MRD's public APIs.

**Hosting:** the ETL runs in-process inside `ctam-reference-data` — no separate `ctam-integrations` repo. This epic owns its own `mrd_*` schema (a small, self-contained Liquibase changeset) as well as the blob-drop ingestion mechanism, since both are scoped tightly to this one supplementary feed.

**Vertical slice:**
- **MRD weekly Excel blob ingestion** via Azure Blob drop + scheduled pick-up (AR47)
- The `mrd_*` schema (`mrd_specialisms`, further tables as MRD entities enter scope), owned by `ctam_reference_data` with the same tier-(a) write protection as the `jo_*` tables (AR49)
- Validate → upsert → archive per file; idempotent per file; rejected files quarantined with a report

**FRs covered:** FR6 tier-(a) (writes follow the tier), FR7.

**Key NFRs first exercised here:** NFR16 (Key Vault), NFR24 (MRD MVP integration), NFR25–NFR28 (structured logs + Application Insights + probes, inherited from the scaffold).

**Out of scope (explicitly):** The JOH eLinks sync (Epic 1.2). MRD API integration (post-MVP — when MRD ships public APIs). Hand-editing of `mrd_*` data in CTAM (never, in any phase — corrections at source per FR6).

---

## Story 1.3.1: MRD supplementary reference data is ingested from the weekly Excel feed

As a **CTAM Pathfinder platform** (and downstream consumers of JOH Specialisations),
I want the MRD team's weekly Excel workbook ingested from an Azure Blob drop into the `mrd_*` tables,
So that **supplementary judicial reference data not present in JOH eLinks (notably JOH Specialisations) is available in CTAM** (revised D3, NFR24) without waiting for MRD's public APIs.

**Acceptance Criteria:**

**Given** a dedicated Azure storage account + Blob container exists for the MRD feed — provisioned via **Terraform in this repo's `terraform/` directory** (per AR53: `ctam-reference-data` is the first repo to need this resource; access for the MRD team or ops to drop the weekly workbook),
**And** the Liquibase changeset `db/changelog/002-init-mrd-tables.sql` creates `mrd_specialisms` (further `mrd_*` tables added as MRD entities enter scope) owned by `ctam_reference_data` with the same tier-(a) write protection as the `jo_*` tables (per AR49),
**When** the weekly workbook lands in the container,
**Then** a `@Scheduled` task in `ctam-reference-data` detects it on its polling cycle (per AR47).

**Given** the ingestion task picks up a workbook,
**When** processing runs,
**Then** the workbook is validated before any write — shape (expected sheets/columns), vocabulary (values resolvable against controlled lists), and referential checks (Specialisations reference resolvable JOH personnel numbers / jurisdiction codes),
**And** valid rows are upserted into the `mrd_*` tables keyed on the upstream natural key,
**And** the processed file is **archived** (moved to an `archive/` path in the container, retained for lineage/audit per AR47),
**And** the run is recorded in `ctam_sync_status` (source = `mrd-excel`) with row counts and outcome (per AR48).

**Given** the same workbook is dropped twice (or the task restarts mid-cycle),
**When** ingestion re-runs,
**Then** the result is idempotent per file — no duplicate rows, no spurious updates (per AR47).

**Given** a workbook fails validation,
**When** the task rejects it,
**Then** no `mrd_*` table is modified (previous good state intact, per AR48),
**And** the file is moved to a `rejected/` path with a validation report alongside it,
**And** the failure is recorded in `ctam_sync_status` and surfaced via structured logs for ops to liaise with the MRD team (corrections happen at source per FR6 tier (a)).

**Given** MRD's public APIs become available post-MVP,
**When** the integration is upgraded,
**Then** only the reader component swaps (blob pick-up → API client); the `mrd_*` tables and downstream consumers are unchanged (per AR47 — the blob-drop seam is the explicit upgrade point).

**References:** FR6 tier (a), FR7; NFR16, NFR24, NFR25–NFR28; AR47, AR48, AR49, AR53; gaps.md G8.1; D3 (revised).

**Explicitly NOT in scope:**
- MRD API integration (post-MVP — when MRD ships public APIs)
- Hand-editing of `mrd_*` data in CTAM (never, in any phase — tier (a) per FR6)

[^d3]: Revised D3 (2026-06-10) — no data migration from any legacy system; judicial-holder reference data is ingested from the JOH eLinks API and MRD.
