---
type: 'Epic'
description: "User outcome: supplementary judicial reference data not present in JOH eLinks (notably JOH Specialisations) is ingested from the MRD team's weekly Excel feed into mrd_* tables inside ctam-reference-data. Split out of Epic 0.3 (SCP 2026-08-24b) so Phase 0 can focus on JOH data."
resource: 'epics/phase-0/epic-0.8-mrd-supplementary-reference-data-ingested.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-24'
parent: 'epics/phase-0/index.md'
epic: 0.8
title: 'MRD supplementary reference data is ingested'
storyCount: 1
repo: ctam-reference-data
depends_on: [epic-0.0, epic-0.3]
---

# Epic 0.8: MRD supplementary reference data is ingested

> **Split note** *(SCP 2026-08-24b)*: this epic was **Story 0.1.4** inside the JOH reference-data ETL process (numbered Epic 0.1 at the time; since renumbered to **Epic 0.3**, SCP 2026-08-25). Split out so that epic (now retitled "JOH Reference-Data ETL Process") is JOH-eLinks-only for Phase 0. No technical content changed — the story's text is carried over verbatim, only renumbered (0.1.4 → 0.8.1) and its cross-references updated. `mrd_specialisms` and `ctam_sync_status` still live in the same repo, `ctam-reference-data`, as the JOH ETL process (Epic 0.3) — this is an epic-tracking split, not a repo split.

**User outcome:** Supplementary judicial reference data not present in JOH eLinks (notably JOH Specialisations) is ingested from the MRD team's weekly Excel feed into the `mrd_*` tables inside `ctam-reference-data` (revised D3, NFR24), without waiting for MRD's public APIs.

**Hosting:** ingestion runs in-process inside `ctam-reference-data` — the same repo as Epic 0.3's JOH eLinks ETL, sharing its `ctam_sync_status` run-log and its tier-(a) write-protection pattern (AR49). No separate repo or deployable. Depends on Epic 0.3 (needs the scaffolded repo and its Liquibase baseline established by Story 0.3.1/0.1.2) and Epic 0.0 (needs the shared estate, incl. the Blob storage account this epic provisions its own Terraform for).

**FRs covered:** FR6 tier-(a), FR7 tier-(a) grants; NFR24 (the MRD half — the JOH eLinks half is Epic 0.3).

**Key NFRs first exercised here:** NFR16 (Key Vault — MRD blob container access), NFR25–NFR28 (structured logs, `ctam_sync_status`).

**Out of scope (explicitly):** MRD API integration (post-MVP — when MRD ships public APIs). Hand-editing of `mrd_*` data in CTAM (never, in any phase — tier (a) per FR6). The JOH eLinks ETL process (Epic 0.3).

---

## Story 0.8.1: MRD supplementary reference data is ingested from the weekly Excel feed

As a **CTAM Pathfinder platform** (and downstream consumers of JOH Specialisations),
I want the MRD team's weekly Excel workbook ingested from an Azure Blob drop into the `mrd_*` tables,
So that **supplementary judicial reference data not present in JOH eLinks (notably JOH Specialisations) is available in CTAM** (revised D3, NFR24) without waiting for MRD's public APIs.

**Acceptance Criteria:**

**Given** a dedicated Azure storage account + Blob container exists for the MRD feed — provisioned via **Terraform in `ctam-reference-data`'s `terraform/` directory** (per AR53: `ctam-reference-data` is the first repo to need this resource; access for the MRD team or ops to drop the weekly workbook),
**And** the Liquibase changeset `db/changelog/002-init-mrd-tables.sql` creates `mrd_specialisms` (further `mrd_*` tables added as MRD entities enter scope) owned by `ctam_reference_data` with the same tier-(a) write protection as the `jo_*` tables (per AR49, established in Epic 0.3, Story 0.3.2),
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

**References:** FR6 tier (a), FR7; NFR16, NFR24, NFR25–NFR28; AR47, AR48, AR49, AR53; gaps.md G8.1; D3 (revised); depends on Epic 0.3 Story 0.3.2 (tier-(a) write-protection pattern + `ctam_sync_status`).

**Explicitly NOT in scope:**
- MRD API integration (post-MVP — when MRD ships public APIs)
- Hand-editing of `mrd_*` data in CTAM (never, in any phase — tier (a) per FR6)
- The JOH eLinks ETL process — Epic 0.3
