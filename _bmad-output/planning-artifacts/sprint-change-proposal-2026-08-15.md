---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — 2026-08-15: Explicit cleanse / transform / persist pipeline in Epic 0.1 ingestion stories'
timestamp: '2026-08-15'
tags: [ctam-pathfinder, sprint-change-proposal, epic-0.1, ingestion]
---

# Sprint Change Proposal — 2026-08-15

## Make the ingestion pipeline's three stages explicit in Epic 0.1

## 1. Issue Summary

**Trigger:** a direct request to ensure Epic 0.1's ingestion stories explicitly call out every step considered "at ingestion time" — cleansing the data, transforming it from its source format into the relational (RDBMS) shape, and persisting it to PostgreSQL.

**Problem statement:** Epic 0.1's two ingestion stories described these steps unevenly:
- **Story 0.1.3 (JOH eLinks, JSON source)** went straight from "pull the JSON payload" to "full-refresh-upsert" — cleansing was implicit (only a whole-payload "malformed" failure case existed) and the JSON→relational transform step was not named at all.
- **Story 0.1.4 (MRD, Excel source)** already validated the workbook before writing (an implicit cleansing stage) and upserted into `mrd_*` tables (persist), but likewise never named a distinct transform step for mapping Excel's tabular (sheet/column) shape into the relational `mrd_*` shape.

Neither story distinguished a **per-record** cleansing failure (quarantine one bad row, keep processing the rest) from a **structural** failure (malformed/incomplete source, reject the whole run) — both existed in spirit (0.1.4 already had `rejected/` vs implicit partial handling) but weren't stated as a consistent pattern across both stories.

This is a **clarification of existing scope**, not new functionality: AR46 (eLinks sync), AR47 (MRD ingestion), and AR48 (ingestion run-log/transactional semantics) already govern this behaviour. No new AR, NFR, or FR is introduced.

**Scope confirmed with the user:** apply under **Epic 0.1** only — Story 0.1.3 (JOH, JSON) and Story 0.1.4 (MRD, Excel), plus the epic's vertical-slice summary. Architecture-level documents (`architecture.md`, `requirements-inventory.md`, `gaps.md`) are unaffected — this is not a new architecture decision.

## 2. Impact Analysis

### Epic / story impact
- **Epic 0.1** vertical-slice bullets for the eLinks sync and MRD ingestion now each name the three-stage pipeline (cleanse → transform → persist) explicitly.
- **Story 0.1.3** acceptance criteria restructured to name a cleansing stage (malformed-record quarantine, normalisation, type coercion, de-duplication), a transform stage (JSON entity → `jo_*` relational shape, incl. `jo_jurisdictions` hierarchy assembly), and a persist stage (full-refresh-upsert + `ctam_joh_identities` minting). A new AC distinguishes per-record quarantine (entity set still proceeds) from a structural payload failure (whole entity set fails per the existing transactional guarantee).
- **Story 0.1.4** acceptance criteria gain an explicit transform stage between the existing cleansing (validation) and persist (upsert) steps; the existing "workbook fails validation" AC is reworded to make clear it is the *structural*-failure case, distinct from per-row quarantine.
- **No FR/NFR/AR changes.** No other Phase 0 epic is affected — Epics 0.2–0.5 consume `jo_*`/`mrd_*` tables as already-persisted data; how the data got there is Epic 0.1's internal concern.
- **No ledger/dispatch-graph changes** — same stories, same FRs/NFRs, no new story added; `delivery/ledger/epic-0.1.yaml` and `delivery/dispatch-graph.yaml` are unaffected.

### Artifact conflicts
None. `architecture/data-tables.md` already documents the `jo_*`/`mrd_*` relational shapes referenced by the new transform-stage wording; no schema change is implied. PRD, UX, and other epics are unaffected.

## 3. Recommended Approach

**Selected: Option 1 — Direct Adjustment** (reword existing acceptance criteria within the existing two stories; no new story, no rollback, no MVP change).

**Rationale:** both stories are `not-started` (per `delivery/ledger/epic-0.1.yaml`); this is a same-scope clarification, not a new requirement, and the existing AR46–AR48 already carry the underlying intent — the change makes it explicit and consistent, nothing more.

**Effort:** Low (documentation only). **Risk:** Low (no code impact, no dependency change). **Timeline impact:** None.

## 4. Detailed Change Proposals

### 4.1 Epic 0.1 vertical slice (epic-level summary)

**OLD:**
> - **JOH eLinks nightly in-process `@Scheduled` sync** (AR46, AR48)
> - **MRD weekly Excel blob ingestion** via Azure Blob drop + scheduled pick-up (AR47)

**NEW:**
> - **JOH eLinks nightly in-process `@Scheduled` sync** (AR46, AR48) — each run is a three-stage pipeline: **cleanse** the raw JSON payload (reject/quarantine malformed records, normalise/type-coerce fields, de-duplicate natural keys), **transform** cleansed JSON entities into the relational `jo_*` table shape (per `architecture/data-tables.md`), **persist** via full-refresh-upsert to the shared PostgreSQL instance
> - **MRD weekly Excel blob ingestion** via Azure Blob drop + scheduled pick-up (AR47) — the same three-stage pipeline applied to the Excel source: **cleanse** the workbook (shape/vocabulary/referential validation, quarantine bad rows), **transform** validated Excel rows from their tabular (sheet/column) shape into the relational `mrd_*` table shape, **persist** via idempotent upsert to PostgreSQL

**Rationale:** names the pattern once at epic level so both stories read as instances of the same pipeline, not two unrelated mechanisms.

### 4.2 Story 0.1.3 (JOH eLinks — JSON)

**OLD** (first AC block, abridged): pull JSON → full-refresh-upsert → mint `ctam_joh_identities` → mark absent rows inactive → record in `ctam_sync_status` → manually triggerable.

**NEW:** pull JSON → **cleansing stage** (reject malformed payload / quarantine bad records / normalise / de-dup) → **transform stage** (map to `jo_*` relational shape, assemble `jo_jurisdictions` hierarchy) → **persist stage** (full-refresh-upsert + mint `ctam_joh_identities`) → mark absent rows inactive → record in `ctam_sync_status` with counts split by cleansed/quarantined/persisted → manually triggerable.

**New AC added:** distinguishes a per-record quarantine (conformant records still proceed through transform/persist for that run) from a structural payload failure (whole entity set fails, per the pre-existing transactional guarantee).

**Rationale:** the failure-handling story previously only covered the structural case; per-record cleansing was implied by "malformed payload" but not stated as its own, non-fatal path.

### 4.3 Story 0.1.4 (MRD — Excel)

**OLD** (second AC block, abridged): workbook validated (shape/vocabulary/referential) → valid rows upserted → file archived → recorded in `ctam_sync_status`.

**NEW:** workbook goes through a **cleansing stage** (shape/vocabulary/type-coercion/normalisation/referential checks; per-row quarantine vs whole-file structural rejection) → a **transform stage** (map cleansed Excel rows from sheet/column shape to the relational `mrd_*` shape, resolving cross-sheet lookups) → a **persist stage** (upsert within the file's transaction) → file archived → recorded in `ctam_sync_status` with counts split by cleansed/quarantined/persisted.

The existing "workbook fails validation" AC is reworded to "fails the cleansing stage structurally … the whole file is rejected," so it reads as the structural counterpart to the new per-row quarantine language rather than a separate, ambiguous case.

**Rationale:** Story 0.1.4 already had cleansing and persist in spirit; the transform step (Excel's tabular shape → the relational `mrd_*` shape) was the missing explicit stage, and the validation-failure AC needed to be disambiguated once per-row quarantine was named.

## 5. PRD MVP Impact

None. No FR/NFR is added, removed, or reworded; no MVP scope change.

## 6. Implementation Handoff

**Change scope classification: Minor** — acceptance-criteria clarification within two not-started stories in one epic; no backlog reorganisation, no architecture-log change, no PM/Architect replan.

**Handoff:** applied directly in this session (control-plane documentation only, per CLAUDE.md — this repo holds no runtime code). `docs/` regenerated via `scripts/build-html.sh`. No ledger, dispatch-graph, or architecture-log changes were needed.

**Success criteria:** Story 0.1.3 and Story 0.1.4 each read as an instance of the same cleanse → transform → persist pipeline, with the JSON-vs-Excel source format difference the only material distinction; the epic's vertical-slice summary states the pattern once at epic level.
