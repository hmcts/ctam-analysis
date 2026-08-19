---
type: 'Epic'
description: 'User outcome: The existing Node/Express mock of the Judicial Office eLinks People API v5 — already built against the real documented contract and real production reference data — is adopted into the CTAM delivery framework as ctam-joh-mock: containerised, deployed onto the Epic 0.0 estate, production-refusing, CI-gated, contract-published, and extended with the ET cohort and fault-injection modes Epic 0.2 needs…'
resource: 'epics/phase-0-mock/epic-0M.1-joh-reference-data-mocked.html'
tags: [ctam-pathfinder, epics, phase-0-mock, brownfield-adoption]
timestamp: '2026-08-18'
parent: 'epics/phase-0-mock/index.md'
epic: 0M.1
title: 'Upstream JOH reference data has a contract-shaped mock source'
storyCount: 2
---

# Epic 0M.1: Upstream JOH reference data has a contract-shaped mock source

> **This epic was rewritten on 2026-08-18 (SCP 2026-08-18d, decision #19) from a greenfield build into a brownfield adoption.** A working mock of the eLinks People API v5 already exists at `ctam-jomockapi`, built from the **real** contract documentation (`Swagger UI.pdf`, `apiresponses.docx`) and the **real** production reference-data exports dated 2026-06-01. The original version of this epic assumed CTAM would scaffold a Spring Boot service and serve fixtures shaped by *guessing* the contract from `architecture/data-tables.md`. That premise is obsolete: the contract is documented and the mock is built. What remains is adoption, hardening, and the two capabilities the existing implementation lacks.

**User outcome:** The existing eLinks v5 mock is **adopted into the CTAM delivery framework** as **`ctam-joh-mock`** — containerised, deployed onto the shared Azure estate from **Epic 0.0**, observable, production-refusing, CI-gated, and publishing a **machine-readable contract** — and is **extended** with the two things Epic 0.2 cannot proceed without: a **guaranteed Employment Tribunals cohort** in its data, and **fault-injection modes** that make Story 0.2.3's failure-path acceptance criteria executable. The result is that Epic 0.2's nightly sync is built and negative-tested against a stand-in that reflects the **real** contract over a real HTTP hop, and the cutover to live eLinks is a configuration change.

**What already exists** (working and tested — do not rebuild):

| Capability | State |
|---|---|
| eLinks v5 endpoint surface | `GET /` · `GET /api/v5/healthcheck` · `GET /api/v5/reference_data/:attribute_name[/:reference_id]` · `GET /api/v5/people/:id` · `GET /api/v5/people?updated_since=` · `GET /api/v5/leavers?left_since=` · `GET /api/v5/deleted?deleted_since=` |
| Base paths | Mounted both bare and under `/elinks`, matching the swagger server declaration |
| Auth | Bearer-token gate with the documented `401 Unauthorized. Invalid or missing token.` body; any non-empty token accepted; `/` and `/healthcheck` public |
| Validation | Real error envelope (`message` + `errors[]`): required-param, `YYYY-MM-DD` date validity (rejects `2026-02-31`), positive-integer `page`/`per_page` |
| Pagination | Documented envelope — `current_page`, `more_pages`, `results_per_page`, `pages`, `results` |
| Change-feed semantics | `/people` mixes full profiles with compact `LeaverResponse`/`DeletedResponse` stubs in one `results` array; `/people/:id` 404s for a deleted person |
| Reference data | Served from the **real** production exports: Locations 1,999 · BaseLocations 1,461 · AppointmentTitles 193 · JudiciaryRoles 163 · Tickets 158 · TicketCategories 53 · plus the small fixed vocabularies |
| Generated people | 100 JOHs, deterministic under a fixed seed (`20260811`), appointments/roles/authorisations joined against the real reference data; ~85% active / ~10% leaver / ~5% deleted; 100 leavers, 100 deleted |
| Tests | 4 `node:test` cases covering public endpoints, the 401 path, pagination + `/elinks` base path, and the validation failures |
| Contract provenance | `Swagger UI.pdf` + `apiresponses.docx` in-repo — the evidence base for gaps.md G8.1 |

**What this epic must add** (the actual work):

1. **Framework adoption** — rename to `ctam-joh-mock`, GitHub setup per AR51, container image, Helm chart, deployment onto the Epic 0.0 estate, k8s probes, structured JSON logs + correlation ID into the shared Application Insights workspace, CI workflows with lint/test/audit/SBOM.
2. **The production-refusal safeguard** — currently **absent**. Nothing today prevents this mock running in, or being pointed at from, production. Three guards required per AR55 and gaps.md G5.3.
3. **A machine-readable OpenAPI spec** — the contract exists only as a PDF. AR55 requires a published spec; NFR39 requires API-as-Product treatment.
4. **A guaranteed ET cohort** — people are currently generated with weighted jurisdiction ids and no guarantee that any hold an Employment Tribunals appointment. G8.1's wave-1 condition needs deliberate ET coverage.
5. **Fixture-identity alignment** with `ctam-mrd-mock` (Epic 0M.2), the `ctam-mock-auth` roster (Epic 0.4) and the bootstrap fixtures (Epic 0.7) — currently `personal_code` is a random 10-digit string, shared with nothing.
6. **Fault-injection modes** — **absent**. Without them Story 0.2.3's four failure-path ACs and Story 0.3.1's variants have no mechanism.

**Stack exception — Node/Express, deliberately.** This service is **the one documented exception to AR2–AR17** (revised AR55). It is not scaffolded from the HMCTS Crime SpringBoot template, carries no Gradle build, and runs on Node 22 LTS + Express 4. The house standard's three reasons for mandating the Java scaffold — convention consistency across the deployable estate, a shared supply-chain baseline, and reviewer familiarity — apply weakly here: the mock is **non-production**, owns **no table in the shared schema**, is **not a consumer or producer of any CTAM API contract**, and sits outside the Java dependency graph entirely. Rewriting ~14 working, tested endpoints, a reference-data loader and a seeded generator in Java would buy conformance in a service no user or production system ever reaches. **What the exception does not waive:** containerisation, the Helm chart, k8s probes, structured JSON logging with correlation IDs, App Insights ingestion, the production-refusal guards, CI quality gates, dependency audit + SBOM, and a published API contract. It is an exception on **language and build tooling only** — not on operability, observability, security, or contract discipline.

**Hosting:** deployed onto the shared Azure estate provisioned in **Epic 0.0**. **Never deployed to production** (AR55). **Owns no tables in the shared schema** — reference data is served from in-repo files and people are generated in memory.

**Dependency change:** `depends_on` is now `[epic-0.A, epic-0.0]` (`arch-baseline` was decomposed into Epics 0.A and 0.B by SCP 2026-08-18e; this epic needs 0.A's scaffold/CI/logging conventions, and **not** 0.B, since it owns no table in the shared schema). **Epic 0.1 has been dropped as a prerequisite**, because the reason for it no longer holds: the mock's shape used to be derived from the `jo_*` schema in `architecture/data-tables.md`, and is now derived from the **real eLinks contract**. This inverts the information flow — Epic 0.1's `jo_*` schema design should now be validated *against* this contract rather than the reverse. That inversion is recorded as a finding in §*Findings* below and in gaps.md G8.1; it is **not** actioned here. Epic 0.2 continues to depend on both Epic 0.1 and this epic, so nothing downstream is weakened.

**FRs covered:** none directly — **enablement infrastructure** for FR1 (`jo_people` as the identity-lookup target) and FR6/FR7 tier-(a), in the same sense as Epics 0.0 and 0.1.

**Key NFRs exercised:** NFR10 (TLS at APIM), NFR16 (Key Vault — the outbound token the sync presents), NFR24 (the JOH eLinks MVP integration exercised end-to-end pre-connection), NFR25–NFR28 (structured logs, App Insights ingestion, liveness/readiness), NFR31 (UK South), NFR39 (API-as-Product — a published, versioned contract), NFR40 (per-service deployable), NFR42 (Postman collection).

**Out of scope (explicitly):** the nightly sync, the `jo_*` tables and `ctam_sync_status` (**Epic 0.2**). MRD's mock feed (**Epic 0M.2**). Any production deployment or connection to the live eLinks API (never — AR55). Standing in for the HMCTS IdP (that is `ctam-mock-auth`, Story 0.4.2). **Correcting the four architecture assumptions this implementation falsifies** — recorded below and in gaps.md, actioned in a follow-up SCP per SCP 2026-08-18d decision 4. Rewriting the mock in Java (explicitly not wanted — see the stack exception). Closing G8.1 (only a real eLinks connection closes it).

---

## Findings — what this implementation proves about the real contract

These are **evidence**, not assumptions, and they contradict four load-bearing statements in the current artifact set. They are **recorded here and in gaps.md G8.1; none is actioned in this epic.** A follow-up SCP owns the corrections. Any story dispatched against Epic 0.2, 0.4, 0.5 or 0.7 before that SCP lands must read this section first.

| # | Current artifacts assert | The documented contract + real data show |
|---|---|---|
| **F1** | **AR46** — nightly **full-refresh-upsert** across the 15 `jo_*` tables; rows absent upstream are "marked inactive, never hard-deleted" | The API is a **change feed**. `GET /people?updated_since=` returns only what changed, and departure/deletion arrive as **explicit signals** — dedicated `GET /leavers?left_since=` and `GET /deleted?deleted_since=` feeds, plus compact leaver/deleted stubs mixed into the people feed. Absence carries no meaning, so inferring deactivation from it is both unnecessary and wrong. A full-refresh design also discards the `updated_since` watermark the API is built around. |
| **F2** | **G8.1 / D8 / Story 0.2.2** — `jo_jurisdictions` carries the upstream **parent-child hierarchy** ("natively or derivable on ingest") | `REF_Jurisdiction` is **flat**: 5 rows — Courts (30), Tribunals (34), Magistrates (84), Coroners (86), Skills (87) — with schema `id, name, start_date, end_date, created_at, updated_at`. **There is no `parent_id` and no hierarchy to derive.** The hierarchy CTAM needs exists, but on **other** entities: `locations.parent_id`, `base_locations.parent_id`, and `ticket_categories.parent_category_id`. |
| **F3** | **G8.1 wave-1 blocker** — eLinks must carry the **Employment Tribunals jurisdiction**, with its parent-child shape under Tribunals | **ET is not a jurisdiction.** It is a **Location**: `1036 "Employment Tribunal (England & Wales)"` (`type_id` 4, `parent_id` 1675, `jurisdiction_id` 34 = Tribunals), alongside `1035 "Employment Appeal Tribunal"` and `1037 "Employment Tribunal Scotland"`. ET also surfaces as **tickets** (1413 ET E&W, 380 ET Scotland, 379 EAT, in categories 56/57/58) and **10 appointment titles**. So the wave-1 ET predicate is a *(jurisdiction = Tribunals) + (location subtree / ticket set)* expression, **not** a jurisdiction id. **Consequence: FR57's activation flags, keyed on `(jurisdiction, region)`, cannot express "ET" as specified.** |
| **F4** | **D9 / Story 0.2.2 / AR46** — `jo_people.personnel_number` is the upstream natural key that `ctam_joh_identities` binds to | The API exposes **`per_id`** and **`personal_code`**. **No `personnel_number` field exists anywhere** in the contract or the responses. The two-population identity chain (IdP email → `jo_people` → `personnel_number` → CTAM JOH UUID) needs re-keying onto whichever of these is the stable business identifier. |

**F3 also partially resolves G8.5.** *"Employment Judge"* (48) and *"Regional Employment Judge"* (71) are **confirmed real** appointment titles, as are seven more ET titles and the judiciary role *"Acting Regional Employment Judge"* (90004) — so that half of the provisional ET taxonomy is now evidenced. The other half is **not**: the employer-side / employee-side **lay-member panels** appear nowhere in this reference data. G8.5 stays open for the panel structure, and the ET as-is analysis pack remains a wave-1 deliverable.

**What is NOT resolved.** G8.1 remains **open**. This evidence is contract documentation plus a reference-data export, not a live connection: no one has authenticated against the real API, confirmed the update cadence or SLA, verified that `updated_since` behaves as documented under load, or seen a real person payload. And the MRD half of G8.1 is untouched.

---

## Story 0M.1.1: Adopt `ctam-joh-mock` into the delivery framework and make it deployable, observable, and production-refusing

As a **platform engineer**,
I want the existing eLinks v5 mock adopted as a first-class CTAM repo — renamed, containerised, deployed onto the Epic 0.0 estate, observable, CI-gated, and hard-guarded against ever reaching production,
So that **Epic 0.2's sync can be built against a deployed stand-in over a real HTTP hop** rather than a developer's laptop, and so that no configuration mistake can ever point a production service at synthetic judicial data.

**Acceptance Criteria:**

**Given** the working implementation currently at `ctam-jomockapi`,
**When** it is adopted into the framework,
**Then** the repo is named **`ctam-joh-mock`**, matching AR55, the repository-strategy row, the dispatch-graph `repo:` key and both ledger shards,
**And** the GitHub manual-setup checklist has been performed for it (`ctam-architecture/runbooks/github-setup.md`) — private repo, branch protection on `main` — noting the `gh` CLI is **not** available (per AR51),
**And** `CODEOWNERS` and `PULL_REQUEST_TEMPLATE.md` exist (per AR29),
**And** `.gitignore` covers `node_modules/` **and** `.DS_Store`,
**And** the existing endpoint behaviour, validation shapes, pagination envelope, seeded determinism and 4 passing tests are **preserved unchanged** — this story adds around the implementation, it does not alter its API surface.

**Given** the contract provenance documents `Swagger UI.pdf` and `apiresponses.docx` are the **evidence base for gaps.md G8.1**,
**When** the repo is reorganised,
**Then** both are retained in the repo under a `contract/` directory (not deleted, not moved out),
**And** a `contract/README.md` records their provenance, the date they were obtained, and that they — not CTAM's own guesses — are the source of the implemented shape,
**And** the `ReferenceData/` exports are retained with a note recording their source and export date (2026-06-01).

**Given** the `ReferenceData/` exports are **real production reference data from eLinks**,
**When** the repo is adopted,
**Then** a documented check confirms they contain **organisational reference data only** — appointment titles, locations, base locations, judiciary roles, tickets, ticket categories, contract types, genders, location types, jurisdictions — and **no personal data of any judicial office holder** (verified: no name, contact, or identity columns in any export),
**And** that finding is recorded in the repo alongside the exports, satisfying NFR14 (no forbidden data) for this repo,
**And** a data-owner sign-off that these exports may be held in this repository is obtained **or** recorded as an outstanding action with a named owner — this AC is the story's external-dependency gate and is tracked in sprint planning.

**Given** the service must deploy onto the shared Azure estate provisioned and verified in **Epic 0.0**,
**When** the deployment artefacts are added,
**Then** a `Dockerfile` builds a container on a **Node 22 LTS** base image, running as a non-root user,
**And** a Helm chart exists at `charts/ctam-joh-mock/` with `values-dev.yaml` / `values-staging.yaml` / `values-production.yaml` overlays (per AR24),
**And** the chart declares **liveness** and **readiness** probes (per NFR28) on endpoints that are **outside the mocked `/api/v5` contract surface** — so the mock's own API shape is never polluted by CTAM operational concerns, and `GET /api/v5/healthcheck` continues to mean exactly what the real eLinks API means by it,
**And** the image is pushed to the shared ACR provisioned in Epic 0.0,
**And** the service is reachable over TLS via the shared APIM gateway with HTTP-only requests rejected (per NFR10),
**And** the deployment fails fast with a clear diagnostic if any Epic 0.0 estate dependency is absent.

**Given** the AR55 stack exception waives language and build tooling but **not** observability,
**When** the service runs in any deployed environment,
**Then** it emits **structured JSON logs to stdout** carrying a `correlationId` per request, in the same shape the Java services emit (per AR30–AR32, NFR25),
**And** those logs and traces land in the **shared Application Insights workspace** provisioned in Epic 0.0 (per NFR26, NFR27),
**And** a request that fails validation or auth is logged with its correlation ID so a confusing ingestion result can be traced to the exact request that produced it.

**Given** the production-refusal safeguard is **currently absent from the implementation**,
**When** it is added,
**Then** the service **refuses to start** when its environment indicates production — exiting non-zero with the fatal message *"ctam-joh-mock must not be deployed to production"* (mirroring AR35 and `ctam-mock-auth`'s guard, per AR55 and gaps.md G5.3),
**And** `deploy-production.yml` is configured to **never** deploy `ctam-joh-mock`,
**And** a CI lint check **fails** any production Helm values file that names `ctam-joh-mock` as an eLinks endpoint,
**And** every deployed environment serves an unmissable *"Mock upstream source — synthetic judicial office holder data, not for production"* banner on the `/docs` console,
**And** every generated person payload is identifiable as synthetic on inspection, so a stray record cannot be mistaken for real judicial data.

**Given** CI must gate this repo as it gates every other,
**When** `.github/workflows/ci.yml` runs on a pull request,
**Then** it installs from `package-lock.json` with a reproducible install, runs the `node:test` suite, runs a linter, runs `npm audit` at a defined severity threshold, and runs `helm lint`,
**And** it generates a **CycloneDX SBOM** for the Node dependency tree — the AR10 requirement satisfied with the ecosystem's equivalent tooling rather than the Gradle plugin,
**And** `deploy-dev.yml` deploys to the dev AKS cluster in UK South on merge to `main` (per AR23, NFR31),
**And** all checks pass on the adopted baseline before any behaviour change is made in Story 0M.1.2.

**References:** NFR10, NFR14, NFR25–NFR28, NFR31, NFR40; AR23, AR24, AR28, AR29, AR30–AR32, AR51, **AR55 (revised — Node/Express exception + brownfield adoption)**; gaps.md G5.3 (widened), **G8.7 (new — production reference-data governance)**; **depends on Epic 0.A** (Helm/CI/logging conventions + the GitHub-setup runbook — formerly `arch-baseline`) and **Epic 0.0** (estate).

**Explicitly NOT in scope:**
- The OpenAPI spec, the ET cohort, fixture-identity alignment, and fault injection — Story 0M.1.2
- Any change to the existing endpoint behaviour or response shapes — preserved as-is
- Rewriting in Java — explicitly excluded by the AR55 exception
- Acting on findings F1–F4 — a follow-up SCP owns those

---

## Story 0M.1.2: Publish the contract, guarantee an ET cohort, align fixture identity, and add fault injection

As a **platform engineer building the Epic 0.2 nightly sync**,
I want the mock to publish a machine-readable contract, to guarantee that Employment Tribunals office holders exist in its data, to share identity keys with the other mocks, and to fail on demand in each way the real API could fail,
So that **Epic 0.2's cleanse → transform → persist pipeline and every one of its failure paths are implemented and proven** against a stand-in that reflects the real contract — and so that the wave-1 ET cohort is testable end-to-end across all three mocks.

**Acceptance Criteria:**

**Given** the contract currently exists only as `Swagger UI.pdf`,
**When** a machine-readable spec is produced,
**Then** an **OpenAPI 3.x** document describes every endpoint, parameter, response envelope and error shape the implementation serves,
**And** it is generated from — or verified against — the running implementation, so spec and behaviour cannot silently diverge,
**And** it is published as a versioned artefact consumable by `ctam-reference-data` (per NFR39, mirroring the `api-ctam-{service}` convention),
**And** each field is marked **evidenced** (present in `Swagger UI.pdf` / `apiresponses.docx` / the real reference-data exports) or **inferred** (a documented deviation — the three the README already records: the full reference-data column set rather than the generic schema, `appointments` always an array, and `include_previous_appointments` folded into the same array),
**And** the spec states prominently that it is **CTAM's reading of the eLinks v5 contract from documentation, not a contract agreed with Judicial Office** — so a reader never mistakes it for an upstream commitment,
**And** a Postman collection covering every endpoint exists at `postman/ctam-joh-mock-phase0.postman_collection.json` (per AR41, NFR42).

**Given** gaps.md **G8.1**'s wave-1 condition requires the Employment Tribunals cohort to be present and exercisable, and finding **F3** establishes that ET is expressed as **locations 1035/1036/1037 under `jurisdiction_id` 34 (Tribunals)**, as **tickets 379/380/1413**, and as **10 ET appointment titles** rather than as a jurisdiction,
**When** the generated cohort is made deterministic for ET,
**Then** a **guaranteed, non-zero, documented number** of generated people hold a current appointment at an **ET location** with an **ET appointment title** (e.g. 48 *Employment Judge*, 71 *Regional Employment Judge*) and an authorisation carrying an **ET ticket**,
**And** that cohort is reachable through the change feed, the leavers feed and the deleted feed — so wave-1 scoping is testable across all three, not just the happy path,
**And** the ET predicate the fixtures satisfy is **written down** in the repo — the exact location ids, ticket ids and appointment-title ids that constitute "ET" in this data — so `ctam-reference-data`, `ctam-authorisation` and the FR57 activation work all key off one documented definition instead of three re-derived guesses,
**And** the fixture set is **version-tagged**, so a sync run recorded in `ctam_sync_status` traces to the exact dataset version it consumed,
**And** determinism is preserved — the same fixture version yields byte-identical payloads across restarts, so CI assertions stay stable.

**Given** the same test identities must resolve across all three mocks and the bootstrap,
**When** fixture identity is aligned,
**Then** a documented subset of generated people carries **stable, non-random identity keys** (`per_id` / `personal_code`) that are the same values referenced by `ctam-mrd-mock`'s Specialisations fixtures (**Epic 0M.2**, Story 0M.2.2), the `ctam-mock-auth` JOH test-user roster (**Epic 0.4**, Story 0.4.2) and the bootstrap-verification fixtures (**Epic 0.7**),
**And** the shared identity set is published in the repo as the single reference all four consumers read,
**And** at least one shared identity is an **ET** office holder, so the wave-1 sign-in path is exercisable end-to-end,
**And** the current behaviour of `personal_code` being a random 10-digit string is replaced for that subset only — the remaining generated population may stay randomised.

> **Note on `personnel_number` (finding F4).** The artifact set currently specifies `jo_people.personnel_number` as the upstream natural key; **the contract has no such field**. This story does **not** invent one and does **not** re-key the identity chain — it aligns on the keys the contract actually exposes (`per_id`, `personal_code`) and leaves the D9 correction to the follow-up SCP. Story dispatch for Epic 0.4 Story 0.4.3 must not assume `personnel_number` exists upstream.

**Given** Story 0.2.3's failure-path acceptance criteria need each failure mode to be reproducible, and **no fault injection exists today**,
**When** fault-injection modes are added — selectable by configuration or request header, and **inert unless explicitly selected** so the default behaviour stays clean,
**Then** the mock can return a **structurally malformed payload** (non-parseable JSON, or a missing expected block) — driving Story 0.2.3's "previous good state remains fully in place" AC,
**And** it can return **valid JSON containing individually non-conformant records** — missing required fields, wrong types, unresolvable reference ids, duplicate natural keys within one page — driving the per-record **quarantine** ACs, including that conformant records still persist,
**And** it can be made **unreachable** or return **5xx** — driving the "API is unreachable mid-sync" AC,
**And** it can return a **slow response**, exercising the sync's timeout handling,
**And** it can return a **paginated feed that changes underneath the consumer** between page requests, and a page whose `pagination` envelope is internally inconsistent — the failure modes a change-feed API has and a full-refresh dump does not, which no existing acceptance criterion covers because **finding F1** was unknown when Epic 0.2 was written,
**And** every fault mode is documented in the OpenAPI spec and covered by the Postman collection,
**And** the test suite is extended to cover each fault mode plus the reference-data and single-person endpoints, which the current 4 tests do not reach.

**Given** the Epic 0.2 sync will consume this mock,
**When** the sync's integration tests run in CI,
**Then** they execute against a **real HTTP hop** to a deployed or container-hosted instance, not an in-process stub,
**And** the same suite is expected to run unchanged against the real eLinks API once access exists — the only change being base URL and credential,
**And** the mock's fixture version is recorded against each run in `ctam_sync_status`.

**Given** the real eLinks API eventually becomes reachable (gaps.md **G8.1**),
**When** live behaviour is compared against this mock's published OpenAPI spec,
**Then** the delta is recorded as an architectural PR per G8.1, covering **at minimum** the update cadence and SLA, `updated_since` semantics under load, real pagination behaviour at scale, the authentication scheme, and whether every **inferred** field marked in the spec holds,
**And** the mock's spec, fixtures and ET predicate are updated to match and re-tagged,
**And** **G8.1 remains open until the sync has run against the real API** — a documented contract and a passing mock are explicitly **not** closure. This AC is the epic's external-dependency gate and is tracked in sprint planning.

**References:** FR1 (enablement), FR6/FR7 tier-(a) (enablement); NFR16, NFR24, NFR39, NFR42; AR41, **AR55 (revised)**; gaps.md **G8.1** (contract now documented; three assumptions falsified; still open), **G8.5** (ET titles confirmed; panel structure still open); D8, D13.

**Explicitly NOT in scope:**
- The sync, the `jo_*` tables, `ctam_sync_status` — Epic 0.2
- The MRD workbook mock — Epic 0M.2
- Acting on findings F1–F4 (AR46's sync model, the jurisdiction-hierarchy source, the FR57 ET predicate, the identity re-keying) — follow-up SCP
- Inventing a `personnel_number` field the contract does not have
- Closing G8.1 — only a real eLinks connection closes it

[^d8]: D8 — rollout is jurisdiction-first, then per-region; jurisdiction is a first-class hierarchical attribute. *(Finding F2/F3 above materially qualifies where that hierarchy comes from and how ET is expressed.)*
[^d13]: D13 (2026-08-07, supersedes D11) — ET-first pilot: wave 1 = the **Employment Tribunals (ET)** jurisdiction (scheduling incumbent `[ET-INCUMBENT-TBD]` — unidentified, gap G8.4); wave 2 = **SSCS** (replaces **ListAssist**; **GAPS**, SSCS case management, is retained); waves 3+ = Courts jurisdictions per HMCTS judicial region (replacing JI/APEX).
