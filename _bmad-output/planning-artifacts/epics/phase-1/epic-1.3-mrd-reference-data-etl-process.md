---
type: 'Epic'
description: 'A weekly, automated import brings the MRD teams Excel workbook into CTAM from an Azure Blob drop, making supplementary judicial reference data - notably JOH Specialisations - available in CTAM without waiting for MRD to ship its own public API.'
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

> This piece of work was split out from the database-schema epic, carrying over a story that was numbered differently at the time; nothing about what's being built changed in that split. The `ctam-reference-data` service itself is set up in that earlier schema epic.

**Business Goal:** CTAM needs a complete picture of every judge and tribunal member, but not all of that picture comes from the main judicial data source. Some supplementary information - most notably each judge's specialisations - only exists in a separate dataset maintained by the MRD team, and MRD hasn't yet built a modern way for other systems to connect to it directly. What MRD can offer today is the same weekly spreadsheet its own team already works from. Rather than wait for MRD to build a proper API - or resort to a one-off manual data migration, which the programme has ruled out entirely - this piece of work builds an automated, weekly import of that spreadsheet, so CTAM gets this data reliably and on a predictable schedule from day one.

**What this covers:** This is a small, self-contained piece of work with a few connected parts: setting up a secure drop-off point in the cloud where the MRD team can leave their weekly file; a small set of new database tables to hold the data once it arrives; and an automated job that picks up the file, checks it's sound, and loads it in safely - archiving what succeeded and quarantining what didn't, so nothing is ever silently lost or wrongly applied.

**Hosting:** This weekly import runs as part of the same service that already looks after CTAM's judicial reference data - there is no separate system built just for this. That service also owns the small set of new database tables created to hold the MRD data, and the mechanism that watches for the weekly file to arrive, since both are narrowly scoped to this one supplementary feed.

**What's included:**
- A dedicated, secure cloud storage location where the MRD team (or the operations team on their behalf) drops the weekly workbook, set up using the project's standard infrastructure tooling - the first time this particular kind of cloud storage has been needed anywhere in the programme
- A small set of new database tables to hold the MRD data - starting with judge specialisations, with room to add more as MRD's own data grows - protected by the same strict write-control rules that already apply to the main judicial data tables, so this data can only ever be corrected at its source, never edited by hand inside CTAM
- A scheduled background job that checks the drop-off location on a regular cycle and picks up any new file it finds
- Before anything is loaded, the file is checked for soundness: does it have the sheets and columns expected, do its values match known reference lists, and do things like specialisation records point to real, recognised judges and jurisdictions
- Once checked, valid rows are safely loaded in (matched against existing records, not blindly duplicated), the processed file is filed away for audit purposes, and the outcome - including how many rows were affected - is logged
- Running the same file through twice, or the job restarting partway through, never causes duplicate or incorrect data
- A file that fails its checks is quarantined together with a report explaining what was wrong, nothing is loaded from it, and the operations team is alerted so they can follow up with the MRD team directly
- The design leaves an easy upgrade path: once MRD builds its own public API, only the part of the system that fetches the file needs to be swapped out for one that calls the API instead - everything downstream stays the same

**Technical reference:**

| Piece | Detail |
|---|---|
| Cloud storage drop-off | A dedicated Azure Storage account and Blob container, provisioned via Terraform in this repo's `terraform/` directory |
| New database tables | Liquibase changeset `db/changelog/002-init-mrd-tables.sql` creates `mrd_specialisms` (further `mrd_*` tables added as MRD entities enter scope), owned by `ctam_reference_data` with the same write protection as the existing `jo_*` tables |
| Pick-up mechanism | A `@Scheduled` polling task inside `ctam-reference-data` |
| Run logging | Every run - success or failure - is recorded in the `ctam_sync_status` table, tagged with source `mrd-excel`, including row counts and outcome |
| Filing after processing | Successful files move to an `archive/` path in the container; failed files move to a `rejected/` path alongside a validation report |
| Future upgrade seam | Only the reader component changes (blob pick-up to an API client) when MRD's public API ships - the `mrd_*` tables and downstream consumers are untouched |

**Why this matters:** Judge specialisation data has real value across the programme - for example, in matching the right judges to the right cases - and without this weekly import, that data simply wouldn't exist inside CTAM. Building it as an automated, checked, and auditable pipeline (rather than a manual copy-paste job) means the data can be trusted from the outset, and the deliberate hand-off point to a future MRD API means this isn't throwaway work.

**Explicitly out of scope:** The separate nightly import of judge and tribunal-member data from the main judicial data source - that is a different piece of work. Connecting to MRD's own API once it exists - that's future work, to happen once MRD actually ships one. Hand-editing MRD data directly inside CTAM - that is never allowed, in any phase; any correction has to happen at the source, with the MRD team.

---

## Story 1.3.1: MRD supplementary reference data is ingested from the weekly Excel feed

As the **CTAM Pathfinder platform** (and everyone downstream who relies on judge specialisation data),
I want the MRD team's weekly Excel workbook automatically picked up from its cloud drop-off point and loaded into CTAM's own tables,
So that **supplementary judicial reference data that isn't available from the main judicial data source - most notably judge specialisations - is available inside CTAM without needing to wait for MRD to build its own API**.

**Acceptance Criteria:**

**Given** a dedicated Azure Storage account and Blob container for the MRD feed have been set up via Terraform in this repo's `terraform/` directory (the first repository in the programme to need this kind of resource), giving the MRD team or operations the ability to drop the weekly workbook,
**And** the Liquibase changeset `db/changelog/002-init-mrd-tables.sql` has created the `mrd_specialisms` table (with further `mrd_*` tables to follow as more of MRD's data comes into scope), owned by `ctam_reference_data` with the same write protection as the existing `jo_*` tables,
**When** the weekly workbook lands in that storage container,
**Then** a `@Scheduled` polling task inside `ctam-reference-data` picks it up on its next check.

**Given** the polling task has picked up a workbook,
**When** it processes the file,
**Then** the file is validated before anything is written - checking it has the expected sheets and columns, that its values match known reference lists, and that records like specialisations point to real, resolvable JOH personnel numbers and jurisdiction codes,
**And** valid rows are then upserted into the `mrd_*` tables, keyed on the upstream natural key rather than duplicated,
**And** the processed file is moved to an `archive/` path in the container, kept there for audit and traceability,
**And** the run is recorded in the `ctam_sync_status` table, tagged with source `mrd-excel`, together with row counts and outcome.

**Given** the same workbook is dropped a second time, or the task restarts partway through a run,
**When** it processes the file again,
**Then** the outcome is exactly the same as the first successful run - no duplicate rows are created, and nothing is updated unnecessarily.

**Given** a workbook fails its validation checks,
**When** the task rejects it,
**Then** none of the `mrd_*` tables are changed - the data already in CTAM stays exactly as it was,
**And** the file is instead moved to a `rejected/` path together with a validation report explaining what was wrong,
**And** the failure is recorded in `ctam_sync_status` and written to the platform's structured logs, so the operations team can see it and follow up directly with the MRD team - since corrections always happen at the source, never inside CTAM.

**Given** MRD eventually makes its own API available,
**When** the integration is upgraded to use it,
**Then** only the part of the system that fetches the data changes - swapping the file drop-off for a direct API call - while the MRD database tables and everything downstream that relies on them stay exactly as they are.

**Explicitly NOT in scope:**
- Connecting to MRD's own API - that only happens once MRD makes one available, as later work
- Hand-editing MRD data inside CTAM - that is never allowed, in any phase
