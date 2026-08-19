---
type: 'Epic'
description: 'User outcome: The MRD weekly Excel feed — whose delivery arrangements are unconfirmed (G8.1) — has a deployable stand-in, ctam-mrd-mock, that publishes conformant and deliberately-malformed workbooks into a configurable blob container, so the Epic 0.3 ingestion can be built, demoed, and negative-tested without waiting for the MRD team…'
resource: 'epics/phase-0-mock/epic-0M.2-mrd-reference-data-mocked.html'
tags: [ctam-pathfinder, epics, phase-0-mock]
timestamp: '2026-08-18'
parent: 'epics/phase-0-mock/index.md'
epic: 0M.2
title: 'Upstream MRD reference data has a contract-shaped mock source'
storyCount: 2
---

# Epic 0M.2: Upstream MRD reference data has a contract-shaped mock source

**User outcome:** The **MRD weekly Excel feed** — CTAM's upstream source for supplementary judicial reference data (notably JOH Specialisations), and whose delivery arrangements are **unconfirmed** (gaps.md **G8.1**: "the MRD team can deliver the weekly workbook to an Azure Blob container in an agreed shape") — has a deployable stand-in: **`ctam-mrd-mock`**. It generates a workbook in the expected shape from a version-tagged fixture set and publishes it into a **configurable** blob container, on demand and on the real weekly cadence, in **conformant and deliberately-malformed variants**. This means the Epic 0.3 ingestion — cleanse, transform, persist, archive, reject — can be **built, demoed, negative-tested, and CI-gated before the MRD team's first real workbook exists**.

Mirroring the Epic 0.2 / Epic 0.3 ingestion split, MRD gets its **own** mock epic rather than sharing Epic 0M.1's: a different format (Excel workbook vs JSON API), a different cadence (weekly vs nightly), and a different delivery mechanism (Blob drop vs API pull) mean the two stand-ins share almost no implementation. **Sequenced before Epic 0.3** — this epic sits in **Phase 0-Mock**, the pre-Phase-0 tier that stands up the upstream stand-ins, and Epic 0.3's `depends_on` names it.

**What this epic does not do:** it does **not** close G8.1. The mock encodes CTAM's *expectation* of the workbook shape, derived from the `mrd_*` schema published in **Epic 0.1** — it is not evidence about what the MRD team will actually send. G8.1 closes only when the ingestion runs against a **real** workbook. What it buys is that the first real workbook arrives as a **diff against a written, executable expectation**, with the ingestion pipeline already proven.

**Hosting:** a standalone deployable, scaffolded from the HMCTS Crime SpringBoot template via `ctam-scaffold.sh` (AR2–AR17), deployed onto the shared Azure estate provisioned in **Epic 0.0**. **Never deployed to production** (AR56) — same three-layer safeguard as `ctam-mock-auth` and `ctam-joh-mock`. **Owns no tables in the shared schema** — fixtures are in-repo resource files.

**Container-target-agnostic by design:** the mock writes to **whichever** blob container its configuration names. It does **not** provision the MRD drop container — that stays where it belongs, in `ctam-reference-data`'s own `terraform/` (**Epic 0.3**, Story 0.3.1), because the consumer owns the resource the real MRD team will drop into. In CI the mock targets a **local Azurite** container via the existing `gradle-docker-compose` plugin; in dev it targets the Epic 0.3 container once that exists. This is deliberate: it keeps the dependency edges acyclic (this epic depends only on Epics 0.0/0.1, never on Epic 0.3) and means the mock is verifiable standalone before the real container is provisioned.

**Vertical slice:**
- **New repo `ctam-mrd-mock`** scaffolded per the Story 0.2.1 pattern (manual GitHub web-UI setup per AR51), port **8102** per the per-service port allocation in `architecture/conventions.md` (the three non-production mocks are banded at 8100–8102; was 8091, which the allocation gives to `ctam-itinerary`)
- **Production refusal safeguard** — profile guard + pipeline guard + CI lint (AR56, gaps.md G5.3 widened)
- **Workbook generator** producing an `.xlsx` in the expected MRD shape — sheets, columns, and controlled vocabularies derived from the `mrd_*` schema published in `architecture/data-tables.md` (**Epic 0.1**)
- **Version-tagged fixture set** whose Specialisations reference the **same `personnel_number` values** as the `ctam-joh-mock` fixtures (Epic 0M.1), so the MRD ingestion's referential checks resolve against JOH data that actually exists
- **Variant modes** — conformant, per-row non-conformant, structurally invalid (missing sheet/column), and duplicate re-drop — each driving a specific Story 0.3.1 acceptance criterion
- **On-demand trigger + weekly `@Scheduled` publish** mirroring the real cadence, so the Epic 0.3 polling cycle is exercised as it will actually behave
- **Published workbook template + column dictionary** as the provisional MRD feed contract — the artefact the first real workbook is diffed against (G8.1)

**FRs covered:** none directly — **enablement infrastructure** for FR6/FR7 tier-(a), in the same way Epic 0.0 and Epic 0.1 are enablement for everything downstream.

**Key NFRs exercised here:** NFR10 (TLS), NFR16 (Key Vault — the storage credential), NFR24 (the MRD MVP integration is exercised end-to-end pre-arrangement), NFR25–NFR28 (structured logs, App Insights, probes), NFR31 (UK South), NFR40 (per-service deployable), NFR42 (Postman collection).

**Out of scope (explicitly):** the ingestion itself, the `mrd_*` tables, and the archive/reject handling (**Epic 0.3**). **Provisioning the MRD drop container** — that is Epic 0.3, Story 0.3.1, in `ctam-reference-data`'s `terraform/`. The JOH eLinks mock (**Epic 0M.1**). Mocking MRD's future **public APIs** (post-MVP — the blob-drop seam is the documented upgrade point per AR47; a future API mock would be a post-MVP concern). Any production deployment or production data (never — AR56). Asserting anything about the real MRD workbook shape — G8.1 stays open.

---

## Story 0M.2.1: Scaffold `ctam-mrd-mock` with a production-refusal safeguard

As a **platform engineer**,
I want `ctam-mrd-mock` scaffolded from the HMCTS starter on the same baseline as every other CTAM service, and hard-guarded against ever running in production,
So that **the MRD stand-in is a first-class, observable, CI-gated deployable** — and so that no configuration mistake can ever drop synthetic judicial reference data into a production container.

**Acceptance Criteria:**

**Given** the engineer has performed the GitHub manual-setup checklist for `ctam-mrd-mock` (`ctam-architecture/runbooks/github-setup.md`) — empty private repo created via the **GitHub web UI**, branch protection on `main` — noting the `gh` CLI is **not** available (per AR51; Story 0.2.1 is the canonical pattern),
**When** the engineer runs `ctam-scaffold.sh ctam-mrd-mock`,
**Then** the service has the same scaffolded baseline as Story 0.2.1 — Spring Boot 4.0.x, Gradle Groovy DSL, Lombok + MapStruct, springdoc-openapi, JaCoCo, CycloneDX SBOM, Testcontainers, Spectral/ArchUnit/Spotless/Checkstyle, Helm chart with dev/staging/production overlays, `.github/workflows/`, `CODEOWNERS`, `PULL_REQUEST_TEMPLATE.md` (per AR2–AR17, AR24, AR28, AR29),
**And** Group ID is `uk.gov.hmcts.ctam`, artefact is `ctam-mrd-mock`, base package is `uk.gov.hmcts.ctam.mrdmock`, and the port is **8102** per the allocation in `architecture/conventions.md` (mock band 8100–8102),
**And** an Excel-writing library is on the classpath, matching the reader library Epic 0.3's ingestion uses — so producer and consumer cannot disagree about workbook encoding,
**And** a Postman collection skeleton exists at `postman/ctam-mrd-mock-phase0.postman_collection.json` (per AR41, NFR42),
**And** the repo carries **no Liquibase changelog and no shared-schema tables** — fixtures are in-repo resource files under `src/main/resources/fixtures/`.

**Given** `ctam-mrd-mock` is starting up,
**When** the Spring profile in use is `production`,
**Then** the application refuses to start with a fatal error message *"ctam-mrd-mock must not be deployed to production"* (per AR56, mirroring AR35 and gaps.md G5.3 as widened),
**And** the `deploy-production.yml` workflow is configured to never deploy `ctam-mrd-mock`,
**And** a CI lint check fails any production Helm values file that names a production storage account as this service's publish target.

**Given** the mock's blob target is **configuration, not a provisioned resource it owns**,
**When** the engineer runs it locally or in CI,
**Then** a local **Azurite** container started by the existing `gradle-docker-compose` plugin serves as the publish target, and the full publish path is verifiable **without any Azure resource existing**,
**And** the storage credential for a non-local target is read from Azure Key Vault (per NFR16) — never from source control or a baked image (per AR25),
**And** the service refuses to start if its configured target container is absent, with a clear diagnostic naming the container it expected.

**Given** the shared Azure estate is provisioned and verified in **Epic 0.0**,
**When** `ctam-mrd-mock`'s Helm chart is deployed to the dev AKS cluster,
**Then** the pod passes liveness + readiness probes (per NFR28),
**And** `/actuator/health` returns `200 OK` with `{"status":"UP"}`,
**And** structured JSON logs carrying a `correlationId` land in the shared Application Insights workspace (per AR30–AR32, NFR25–NFR27),
**And** its trigger API is reachable over TLS via the shared APIM gateway, with HTTP-only requests rejected (per NFR10),
**And** every generated workbook carries an unmissable *"Mock MRD feed — synthetic judicial data, not for production"* marker in a header row or document property, so a stray file is identifiable on sight.

**Given** the engineer opens a PR **manually via the GitHub web UI** and it is merged after review,
**When** `ci.yml` and then `deploy-dev.yml` run,
**Then** build + test + Spectral + ArchUnit + Spotless + Checkstyle + Helm lint all pass,
**And** the service deploys to dev AKS in UK South (per AR23, NFR31),
**And** the image is pushed to the shared ACR provisioned in Epic 0.0.

**References:** NFR10, NFR16, NFR25–NFR28, NFR31, NFR40, NFR42; AR2–AR17, AR23–AR32, AR41, AR51, **AR56 (new)**; gaps.md G5.3 (widened); **depends on Epic 0.0** (estate) and **Epic 0.1** (the `mrd_*` schema the fixtures conform to).

**Explicitly NOT in scope:**
- The workbook generator and fixture set — Story 0M.2.2
- Provisioning the MRD drop container — Epic 0.3, Story 0.3.1
- The JOH eLinks mock — Epic 0M.1

---

## Story 0M.2.2: `ctam-mrd-mock` publishes conformant and deliberately-malformed MRD workbooks on demand and on the weekly cadence

As a **platform engineer building the Epic 0.3 MRD ingestion**,
I want the mock to drop a workbook in the expected MRD shape into the configured container — on demand and on the real weekly schedule — and to be able to produce each malformed variant the real feed could send,
So that **the cleanse → transform → persist → archive pipeline (AR47) and every one of its rejection and quarantine paths are implemented and proven against a real blob hop before the MRD team's first workbook lands** — and so that the mock's workbook template becomes the written expectation the real workbook is diffed against (G8.1).

**Acceptance Criteria:**

**Given** the `mrd_*` relational schema is finalized and published in `architecture/data-tables.md` (**Epic 0.1**, Story 0.1.1),
**When** the engineer implements the workbook generator,
**Then** the generated `.xlsx` carries the expected **sheets and columns** for every `mrd_*` entity in scope — `mrd_specialisms` at minimum, extensible as further MRD entities enter scope,
**And** every field CTAM's ingestion needs per `data-tables.md` has a column (the workbook is **field-complete by construction** — the executable form of G8.1's "every upstream field CTAM needs has a slot" check),
**And** the workbook shape is documented as a **column dictionary** in the repo (sheet name, column name, type, controlled vocabulary, required/optional, natural key) published alongside the service and explicitly labelled **provisional — CTAM's expectation of the MRD feed, not an agreed contract**,
**And** any column whose upstream name, type, or vocabulary is a **guess** is marked as such, so the diff against the first real workbook is pre-annotated.

**Given** the fixture set is authored for the **wave-1 ET cohort**[^d13],
**When** a conformant workbook is generated,
**Then** its Specialisations rows reference the **same `personnel_number` values** as the `ctam-joh-mock` fixtures (**Epic 0M.1**, Story 0M.1.2) and resolvable jurisdiction codes — so Epic 0.3's **referential** cleansing checks pass against JOH data that actually exists, rather than against orphan keys,
**And** the fixture set is **version-tagged**, so a run recorded in `ctam_sync_status` traces to the exact fixture version consumed,
**And** repeated generation from the same fixture version produces a **semantically identical** workbook (deterministic content — so CI assertions are stable),
**And** ET-specific vocabulary values are marked **provisional pending the ET as-is analysis pack** (gaps.md **G8.5**).

**Given** the mock is deployed and its target container configured,
**When** the weekly `@Scheduled` publish fires, or an engineer calls the on-demand trigger endpoint,
**Then** a workbook is written into the configured container under the expected drop path and naming convention,
**And** the trigger endpoint accepts a **variant** parameter selecting which workbook to produce,
**And** the trigger endpoint requires authentication and returns RFC 9457 problem-details on failure (per AR37, NFR39),
**And** the publish is recorded in the mock's own structured logs with the fixture version and variant, so a confusing ingestion result can be traced back to what was actually dropped.

**Given** Story 0.3.1's failure-path acceptance criteria need each variant to be reproducible,
**When** a variant is selected,
**Then** the mock can produce a **structurally invalid** workbook — a required **sheet or column missing** — driving Story 0.3.1's whole-file rejection AC (no `mrd_*` table modified, file moved to `rejected/` with a validation report),
**And** it can produce a workbook with **individually non-conformant rows** — missing required fields, invalid types, unresolvable vocabulary values, unresolvable personnel numbers / jurisdiction codes, malformed date and numeric cell formats, untrimmed text — driving Story 0.3.1's per-row **quarantine** ACs, including that conformant rows still persist,
**And** it can produce **cross-sheet lookup failures**, so the transform stage's resolution logic is exercised on the unhappy path,
**And** it can **re-drop a byte-identical workbook**, driving Story 0.3.1's **idempotency** AC (no duplicate rows, no spurious updates),
**And** each variant is documented and covered by the Postman collection.

**Given** `ctam-mrd-mock` and the Epic 0.3 ingestion are both deployed to dev,
**When** the mock publishes and the ingestion's polling cycle picks the file up,
**Then** the ingestion's integration tests execute against a **real blob hop** — Azurite in CI, the Epic 0.3 container in dev — rather than a hand-placed test file,
**And** `ctam_sync_status` records the run (source = `mrd-excel`) with the mock's fixture version recorded as the source version,
**And** the same test suite is expected to run unchanged against the real MRD feed — the only change is which container is configured and who drops into it.

**Given** the MRD team's first real workbook eventually lands (gaps.md **G8.1**),
**When** it is compared against this mock's published column dictionary,
**Then** the delta is recorded as an architectural PR per G8.1, listing every sheet/column whose name, type, or vocabulary differs from CTAM's written expectation,
**And** the mock's fixtures and column dictionary are updated to match reality and re-tagged,
**And** **G8.1 remains open until the ingestion has run against a real workbook** — the mock passing is explicitly **not** closure. This AC is the epic's external-dependency gate and is tracked in sprint planning.

**References:** FR6/FR7 tier-(a) (enablement); NFR16, NFR24, NFR25–NFR28, NFR39, NFR42; AR37, AR47, AR48, **AR56 (new)**; gaps.md **G8.1** (de-risked, not closed), **G8.5** (ET vocabulary provisional); D3 (revised), D13.

**Explicitly NOT in scope:**
- The ingestion, the `mrd_*` tables, archive/reject handling — Epic 0.3
- Provisioning the drop container — Epic 0.3, Story 0.3.1
- Mocking MRD's future public APIs — post-MVP (the blob-drop seam is the upgrade point per AR47)
- Closing G8.1 — only a real workbook closes it

[^d3]: Revised D3 (2026-06-10) — no data migration from any legacy system; judicial-holder reference data is ingested from the JOH eLinks API and MRD.
[^d13]: D13 (2026-08-07, supersedes D11) — ET-first pilot: wave 1 = the **Employment Tribunals (ET)** jurisdiction (scheduling incumbent `[ET-INCUMBENT-TBD]` — unidentified, gap G8.4); wave 2 = **SSCS** (replaces **ListAssist**; **GAPS**, SSCS case management, is retained); waves 3+ = Courts jurisdictions per HMCTS judicial region (replacing JI/APEX).
