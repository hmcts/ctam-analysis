---
type: 'Epic'
description: 'User outcome: Supplementary judicial reference data not present in JOH eLinks (notably JOH Specialisations) flows into CTAM Pathfinder from the MRD team weekly Excel feed, without waiting for MRD public APIs…'
resource: 'epics/phase-0/epic-0.3-mrd-reference-data-ingested.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-15'
parent: 'epics/phase-0/index.md'
epic: 0.3
title: 'Upstream MRD reference data is ingested'
storyCount: 1
---

# Epic 0.3: Upstream MRD reference data is ingested

**User outcome:** Supplementary judicial reference data not present in JOH eLinks — notably JOH Specialisations — flows into CTAM Pathfinder from the **MRD** team's weekly Excel feed (`mrd_*` data), without waiting for MRD's public APIs (revised D3, NFR24). This is a separate upstream source from JOH eLinks: a different format (Excel workbook vs JSON API), a different cadence (weekly vs nightly), and a different delivery mechanism (Azure Blob drop vs API pull) — split out from Epic 0.2 (JOH) into its own epic so each ingestion mechanism is independently demoable and verifiable.

**Hosting:** the ingestion runs in-process inside `ctam-reference-data` — the same service scaffolded in Epic 0.2, Story 0.2.1. No separate `ctam-integrations` repo. This epic adds only this service's own MRD storage account/container via its `terraform/` directory (Story 0.3.1) — the shared estate lives in `ctam-shared-infrastructure` (Epic 0.0).

**Vertical slice:**
- Dedicated Azure storage account + Blob container for the MRD feed, provisioned via Terraform in `ctam-reference-data`'s own `terraform/` directory (per AR53: this repo is the first to need this resource)
- `mrd_specialisms` (and further `mrd_*` tables as MRD entities enter scope), owned by `ctam_reference_data`, with the same tier-(a) write protection as the `jo_*` tables (AR49), conforming to the schema design published in Epic 0.1
- **MRD weekly Excel blob ingestion** via Azure Blob drop + scheduled pick-up (AR47) — a three-stage pipeline: **cleanse** the workbook (shape/vocabulary/referential validation, quarantine bad rows), **transform** validated Excel rows from their tabular (sheet/column) shape into the relational `mrd_*` table shape, **persist** via idempotent upsert to PostgreSQL — recorded in the shared `ctam_sync_status` run log established in Epic 0.2, Story 0.2.2

**FRs covered:** FR6 tier-(a), FR7 tier-(a) grants; NFR24 (MRD MVP integration).

**Key NFRs first exercised here:** NFR16 (Key Vault — MRD storage account access), NFR24 (MRD integration), NFR25–NFR28 (structured logs + Application Insights ingestion).

**Out of scope (explicitly):** the JOH eLinks sync and `jo_*` tables (Epic 0.2). The read-only Reference Data API + jurisdiction filtering (Epic 0.5, Story 0.5.2). Tier-(b) CTAM-owned reference tables (Epic 0.5, Story 0.5.1). All authentication / authorisation / UI (Epic 0.4). MRD API integration (post-MVP — when MRD ships public APIs). Hand-editing of `mrd_*` data in CTAM (never, in any phase — corrections at source per FR6).

---

## Story 0.3.1: MRD supplementary reference data is ingested from the weekly Excel feed

As a **CTAM Pathfinder platform** (and downstream consumers of JOH Specialisations),
I want the MRD team's weekly Excel workbook ingested from an Azure Blob drop into the `mrd_*` tables,
So that **supplementary judicial reference data not present in JOH eLinks (notably JOH Specialisations) is available in CTAM** (revised D3, NFR24) without waiting for MRD's public APIs.

**Acceptance Criteria:**

**Given** `ctam-reference-data` is scaffolded (Epic 0.2, Story 0.2.1) and the shared `ctam_sync_status` run log exists (Epic 0.2, Story 0.2.2),
**And** a dedicated Azure storage account + Blob container exists for the MRD feed — provisioned via **Terraform in this repo's `terraform/` directory** (per AR53: `ctam-reference-data` is the first repo to need this resource; access for the MRD team or ops to drop the weekly workbook),
**And** the Liquibase changeset `db/changelog/002-init-mrd-tables.sql` creates `mrd_specialisms` (further `mrd_*` tables added as MRD entities enter scope) owned by `ctam_reference_data` with the same tier-(a) write protection as the `jo_*` tables (per AR49), conforming to the schema design published in **Epic 0.1** and passing its CI fitness function,
**When** the weekly workbook lands in the container,
**Then** a `@Scheduled` task in `ctam-reference-data` detects it on its polling cycle (per AR47).

**Given** the ingestion task picks up a workbook,
**When** processing runs,
**Then** a **cleansing stage** validates the workbook before any write — shape (expected sheets/columns present), vocabulary (values resolvable against controlled lists), type coercion (numeric/date cell formats), whitespace/format normalisation of text cells, and referential checks (Specialisations reference resolvable JOH personnel numbers / jurisdiction codes) — individual non-conformant rows are quarantined rather than failing the whole workbook, unless the failure is structural (a required sheet or column is missing),
**And** a **transform stage** maps each cleansed row from its tabular (sheet/column) shape into the relational `mrd_*` table shape per `architecture/data-tables.md`, resolving any cross-sheet lookups needed to populate the reference columns,
**And** a **persist stage** upserts the transformed rows into the `mrd_*` tables keyed on the upstream natural key, within the file's ingestion transaction,
**And** the processed file is **archived** (moved to an `archive/` path in the container, retained for lineage/audit per AR47),
**And** the run is recorded in `ctam_sync_status` (source = `mrd-excel`) with row counts split by **cleansed / quarantined / persisted**, and overall outcome (per AR48).

**Given** the same workbook is dropped twice (or the task restarts mid-cycle),
**When** ingestion re-runs,
**Then** the result is idempotent per file — no duplicate rows, no spurious updates (per AR47).

**Given** a workbook fails the cleansing stage structurally (a required sheet or column is missing) and the whole file is rejected,
**When** the task rejects it,
**Then** no `mrd_*` table is modified (previous good state intact, per AR48),
**And** the file is moved to a `rejected/` path with a validation report alongside it (including any per-row quarantine detail already gathered),
**And** the failure is recorded in `ctam_sync_status` and surfaced via structured logs for ops to liaise with the MRD team (corrections happen at source per FR6 tier (a)).

**Given** MRD's public APIs become available post-MVP,
**When** the integration is upgraded,
**Then** only the reader component swaps (blob pick-up → API client); the `mrd_*` tables and downstream consumers are unchanged (per AR47 — the blob-drop seam is the explicit upgrade point).

**References:** FR6 tier (a), FR7; NFR16, NFR24, NFR25–NFR28; AR47, AR48, AR49, AR53; gaps.md G8.1; D3 (revised); **depends on Epic 0.1** (schema design) and **Epic 0.2** (scaffolded repo + `ctam_sync_status`).

**Explicitly NOT in scope:**
- MRD API integration (post-MVP — when MRD ships public APIs)
- Hand-editing of `mrd_*` data in CTAM (never, in any phase — tier (a) per FR6)

[^d3]: Revised D3 (2026-06-10) — no data migration from any legacy system; judicial-holder reference data is ingested from the JOH eLinks API and MRD.
