---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — 2026-08-18d: eLinks v5 mock adopted brownfield into Epic 0M.1; Node/Express accepted as the one AR2–AR17 exception; four architecture assumptions falsified'
timestamp: '2026-08-18'
tags: [ctam-pathfinder, sprint-change-proposal, phase-0-mock, brownfield-adoption, upstream-integration, findings]
---

# Sprint Change Proposal — 2026-08-18d

## Adopt the existing eLinks v5 mock as `ctam-joh-mock` (Epic 0M.1 rewritten), accept Node/Express as a scoped exception, and record four falsified assumptions

## 1. Issue Summary

**Trigger:** a working set of mock APIs for the upstream source data exists at `ctam-jomockapi`, with a request to create an epic under Phase 0-Mock and adopt the implementation into the framework.

**What was found.** The implementation is a **Node/Express mock of the Judicial Office eLinks People API v5**, and it is substantially more than a stub. It was built from the **real contract documentation** — `Swagger UI.pdf` for the endpoint and parameter surface, `apiresponses.docx` for complete example payloads where the PDF export truncated them — and it serves the **real production reference-data exports** dated 2026-06-01. It is working, tested, and deterministic.

| Capability | State |
|---|---|
| Endpoints | `GET /` · `/api/v5/healthcheck` · `/api/v5/reference_data/:attribute_name[/:reference_id]` · `/api/v5/people/:id` · `/api/v5/people?updated_since=` · `/api/v5/leavers?left_since=` · `/api/v5/deleted?deleted_since=` |
| Base paths | Mounted bare **and** under `/elinks`, matching the swagger server declaration |
| Auth | Bearer gate with the documented `401 Unauthorized. Invalid or missing token.` body; `/` and `/healthcheck` public |
| Validation | Real error envelope (`message` + `errors[]`): required params, `YYYY-MM-DD` validity (rejects `2026-02-31`), positive-integer pagination |
| Pagination | Documented envelope — `current_page`, `more_pages`, `results_per_page`, `pages`, `results` |
| Change-feed semantics | `/people` mixes full profiles with compact leaver/deleted stubs in one `results` array; `/people/:id` 404s a deleted person |
| Reference data | **Real production exports** — Locations 1,999 · BaseLocations 1,461 · AppointmentTitles 193 · JudiciaryRoles 163 · Tickets 158 · TicketCategories 53 · plus fixed vocabularies |
| People | 100 synthetic JOHs, deterministic under seed `20260811`, appointments/roles/authorisations joined against the real reference data; ~85% active / ~10% leaver / ~5% deleted; plus 100 leavers, 100 deleted |
| Tests | 4 `node:test` cases — public endpoints, the 401 path, pagination + `/elinks` base path, validation failures |
| Provenance | `Swagger UI.pdf` + `apiresponses.docx` retained in-repo |

**The problem this creates — and it is not the one the request implies.** Two distinct issues surfaced, and only the first is what was asked about.

**Issue A — an epic exists whose premise is now obsolete.** Epic 0M.1 (written earlier the same day, SCP 2026-08-18b) specifies scaffolding `ctam-joh-mock` greenfield from the HMCTS Crime SpringBoot template and serving fixtures shaped by **guessing** the contract from `architecture/data-tables.md`, publishing that guess as CTAM's "provisional written expectation." Both halves of that premise are dead: the contract is documented, and the mock is built. Leaving Epic 0M.1 as written would have the programme rebuild working software in a different language to satisfy a plan that predates the evidence by hours.

**Issue B — the implementation is evidence, and it contradicts the architecture.** This is the more consequential finding. `ctam-jomockapi` is not just an implementation; it is the first hard evidence CTAM has about what the eLinks contract actually looks like. **Four load-bearing statements in the artifact set are falsified by it.** Because the request was scoped to adoption, these are recorded here in full and corrected in a follow-up — but they must not be allowed to sit quietly inside an epic file.

**Evidence.**

| Source | What it establishes |
|---|---|
| `package.json`, `server.js`, `src/routes/*` | Node 22 / Express 4; 14 route handlers; dual base-path mounting |
| `README.md` | Provenance (`Swagger UI.pdf` + `apiresponses.docx`), auth behaviour, the three documented deviations from the swagger schema |
| `src/lib/validation.js`, `src/lib/pagination.js` | The real error and pagination envelopes, reproduced exactly |
| `src/db.js`, `src/lib/personGenerator.js` | Fixed-seed determinism; `per_id` / `personal_code` identity keys; **no `personnel_number`** |
| `ReferenceData/*REF_Jurisdiction.json` | **5 flat jurisdictions**, no `parent_id`: Courts 30, Tribunals 34, Magistrates 84, Coroners 86, Skills 87 |
| `ReferenceData/*REF_Location.csv` | Header `id,name,type_id,parent_id,jurisdiction_id,…`; rows 1035 EAT, **1036 `Employment Tribunal (England & Wales)`** (`parent_id` 1675, `jurisdiction_id` 34), 1037 ET Scotland |
| `ReferenceData/*REF_AppointmentTitle.csv` | `48 Employment Judge`, `71 Regional Employment Judge`, +8 further ET titles |
| `ReferenceData/*REF_Ticket.csv` / `*REF_TicketCategory.csv` | ET tickets 379 / 380 / 1413; `ticket_categories` carries `parent_category_id` |
| `test/api.test.js` | 4 passing tests — and, by omission, the absence of coverage for reference-data and single-person endpoints |
| Absence in the tree | **No** Dockerfile, Helm chart, CI workflows, production-refusal guard, machine-readable OpenAPI, or fault injection |

**Issue type:** new capability arrived from outside the plan (brownfield adoption), **plus** discovery evidence that invalidates prior assumptions. Not a technical limitation, not a scope change, not a pivot.

**Four decisions confirmed with the user during analysis:**

1. **Rewrite Epic 0M.1 as the adoption epic** — it keeps its number, slot and story ids; the story *content* is replaced. Alternatives offered and not selected: a new Epic 0M.3 with 0M.1 retired, or 0M.3 now with 0M.1 surviving as a later Spring Boot port.
2. **Keep Node/Express and document a scoped exception.** Porting to Spring Boot, and adopting silently with no exception recorded, were both offered and not selected.
3. **Rename the repo to `ctam-joh-mock`** to match AR55, the repository-strategy row, the dispatch graph and both ledger shards. Adopting as `ctam-jomockapi` was offered and not selected.
4. **Record the four findings now; correct them in a follow-up SCP.** Folding the AR46 / D8 / D9 / FR57 corrections into this change was offered and not selected; so was mentioning them informally without recording them against the gaps.

**One correction to the request, made explicit.** The request asked to *create* an epic. Decision 1 rewrites the existing Epic 0M.1 instead, so **no new epic file is created** — creating one would have left two epics delivering the same capability, one of them specifying a rebuild in a language we have just agreed not to use.

## 2. Impact Analysis

### Epic impact

| Epic | Impact |
|---|---|
| **Epic 0M.1** | **Rewritten.** Number, title, slot and story ids (`0M.1.1`, `0M.1.2`) unchanged; **both stories' content fully replaced**. Adds a what-exists inventory, a what-must-be-added list, the stack-exception rationale, and a new **Findings** section carrying F1–F4. `depends_on` drops `epic-0.1`. |
| **Epic 0M.2** (`ctam-mrd-mock`) | **No change to its stories.** Its relationship to 0M.1 shifts in one respect worth noting: the two mocks are no longer of equal evidential status — 0M.1 now reflects documented vendor material, 0M.2 is still CTAM's guess. The Phase 0-Mock index records the asymmetry. |
| **Epic 0.2** (JOH ingestion) | **No change in this SCP** — but it is the epic most affected by findings F1–F4, and its Story 0.2.3 acceptance criteria will need rework once the follow-up SCP lands (AR46's full-refresh model does not fit a change-feed API). `depends_on` unchanged: still `[epic-0.0, arch-baseline, epic-0.1, epic-0M.1]`. |
| **Epics 0.4, 0.7** | **No change** — but both key on `personnel_number`, which finding **F4** shows does not exist upstream. Flagged, not actioned. |
| **Epics 0.0, 0.1, 0.3, 0.5, 0.6, 0.8** | **No change.** |
| **Phases 1–8, post-MVP** | **No change.** |

**Totals unchanged: Phase 0-Mock 2 epics / 4 stories; Phase 0 9 epics / 23 stories.** No story added, removed or renumbered.

### Dependency-graph impact

`epic-0M.1.depends_on` becomes `[epic-0.0, arch-baseline]` — **`epic-0.1` dropped**. The justification is specific: that edge existed because the mock's fixtures were to be shaped by the `jo_*` schema in `data-tables.md`. The mock's shape now comes from the real contract, so the dependency has no remaining basis — and the information flow is **inverted**: Epic 0.1's schema design should now be validated *against* this contract. That inversion is recorded as a finding, not actioned. `epic-0.2` still depends on **both** `epic-0.1` and `epic-0M.1`, so nothing downstream is weakened. Graph **re-verified acyclic**; both ordering constraints hold.

Practical effect: Epic 0M.1 becomes dispatchable as soon as `epic-0.0` and `arch-baseline` are `done`, without waiting for the schema-design epic.

### Artifact impact (exhaustive)

| Artifact | Change |
|---|---|
| `epics/phase-0-mock/epic-0M.1-joh-reference-data-mocked.md` | **Full rewrite** — adoption framing, what-exists table, what-must-be-added list, stack-exception rationale, **new Findings section (F1–F4)**, both stories replaced, `depends_on` note |
| `epics/phase-0-mock/index.md` | 0M.1 summary rewritten; epics-table row; demo row; three scope-model bullets (deployables, published contracts, fixture identity); the "does not close G8.1" paragraph qualified for the now-asymmetric evidence; validation section gains the asymmetry and the outstanding-corrections risk |
| `epics/framework.md` | Phase 0-Mock Area scope paragraph and FR/NFR coverage line |
| `epics/requirements-inventory.md` | **AR55 revised** (v5 contract surface, real exports, evidenced/inferred spec marking, ET-as-location, fault modes); **AR55.1 new** (the scoped Node/Express exception) |
| `architecture.md` | **Decision #19**; the *Phasing of Upstream Integrations* `ctam-joh-mock` block rewritten around documented-contract reality |
| `architecture/repository-strategy.md` | `ctam-joh-mock` row rewritten; both mock rows' `Phase` corrected `0` → `0-mock`; new paragraph on why one of the three mocks is not a Java service |
| `architecture/conventions.md` | Scaffold-rule carve-out pointing at AR55.1 |
| `architecture/gaps.md` | **G8.1 major update** (contract documented; F1–F4; revised closure condition; JOH half partly evidenced, MRD half wholly open); **G8.5 partly evidenced**; **G8.7 new** (production-export governance) |
| `architecture/changelog.md` | **v4.8** |
| `delivery/dispatch-graph.yaml` | `epic-0M.1.depends_on`; adoption + inverted-flow note |
| `delivery/ledger/epic-0M.1.yaml` | Both story titles; NFR14 trace on 0M.1.1; adoption + findings note |
| `scripts/python/build_html.py` | This SCP's NAV entry |
| `docs/` | Regenerated |

### Artifacts checked — no impact

`prd.md` (**deliberately untouched** — findings F1–F4 implicate D9, FR57 and NFR24, and correcting them is the follow-up SCP's job; changing the PRD here would exceed the agreed scope), `business-case.md`, `architecture-summary.md` (its mock rows cite AR55/AR56, not epic numbers or stack), `architecture/data-tables.md` (the mock still owns no tables; **the `jo_*` schema itself is implicated by F1/F2/F4 but is the follow-up's scope**), `architecture/starter-template.md`, `architecture/assumptions.md`, `architecture/delivery-operating-model.md`, all sequence diagrams, `epics/fr-coverage-map.md` (0M.1 still bears no FR), `epics/index.md`, `epics/phase-0/*` (all nine epics), `delivery/README.md`, `delivery/ledger/` (other shards), `_bmad-output/project-context.md`, root `CLAUDE.md` (still 18 repos — none added or removed), all dated reports and prior SCPs.

**No UX impact.**

### Technical impact

**No FR or NFR content changed. No schema, CTAM API contract, or endpoint change. No repo added or removed — still 18.** No code impact on any other repo.

**New for the adopted repo:** a container image, a Helm chart, CI workflows, a production-refusal guard, structured logging, an SBOM, an OpenAPI artefact, and a rename. **New infrastructure footprint:** one AKS deployment, one ACR image stream, one APIM registration — all dev/CI/integration only.

**One genuinely new class of technical debt is accepted:** the estate now contains a **Node service in a Java polyrepo**. Its CI, dependency-audit and SBOM tooling are ecosystem-specific and will not be covered by whatever the Java repos standardise on. That cost is accepted knowingly for a non-production service; AR55.1 states it is not precedent.

## 3. Recommended Approach

**Selected: Option 1 — Direct Adjustment.** Rewrite Epic 0M.1 in place, revise AR55 and add AR55.1, record the findings against the gaps, and adjust the dependency edge.

**Rationale.** Rollback is not applicable — nothing is implemented in CTAM, and "rolling back" would mean discarding working software. An MVP review is not applicable — no requirement or scope boundary moves.

The choice that matters is **adopt rather than rebuild**, and it is justified by more than sunk cost. This implementation encodes something CTAM could not otherwise buy: **the real contract's actual shape**. A Spring Boot rewrite would reproduce the endpoints but would re-introduce exactly the risk the mock exists to remove — a CTAM engineer re-deriving payload shapes, and re-guessing wherever the rewrite is ambiguous. Adopting the artefact that was written *against the documentation, with the documentation in the repo* keeps the provenance chain intact.

**The honest cost.** A Node service in a Java estate (accepted, scoped, documented as non-precedent); ecosystem-specific CI tooling; and an adopted codebase that has not been through CTAM code review, has 4 tests covering perhaps a third of its surface, and lacks every operational concern the house standard mandates. Story 0M.1.1 is deliberately weighted toward closing that operational gap rather than toward features.

**Effort:** Medium. **Risk:** Medium, and concentrated in two places worth naming plainly:

- **The production-refusal guard does not exist yet.** Until Story 0M.1.1 lands, nothing prevents this service running anywhere it is deployed, or a misconfigured environment pointing at it. This is the single highest-priority item in the epic, and it is why 0M.1.1 precedes 0M.1.2.
- **Mock-reality divergence, now with a sharper edge.** A mock built from documentation *feels* authoritative in a way a hand-guessed fixture set does not — which makes an unnoticed inference more dangerous, not less. Mitigated by requiring every field to be marked *evidenced* or *inferred*, by keeping the provenance documents in the repo, and by G8.1 remaining explicitly unclosable by mock success.

**Timeline impact:** favourable. Epic 0M.1's build work shrinks substantially, and dropping the `epic-0.1` edge lets it start earlier. Findings F1–F4 will add rework to Epic 0.2 once the follow-up SCP lands — **that rework is discovered, not created, by this change**, and discovering it now is considerably cheaper than discovering it during Epic 0.2's implementation.

## 4. Detailed Change Proposals

### 4.1 Epic 0M.1 — rewritten

Story ids and the epic's identity are preserved; content is replaced.

**Story 0M.1.1 — OLD:** *"Scaffold `ctam-joh-mock` with a production-refusal safeguard"* — scaffold from the HMCTS starter via `ctam-scaffold.sh`, Java/Gradle baseline, package `uk.gov.hmcts.ctam.johmock`, port 8090, no Liquibase changelog, plus the three production guards.

**Story 0M.1.1 — NEW:** *"Adopt `ctam-joh-mock` into the delivery framework and make it deployable, observable, and production-refusing"* — rename; GitHub setup per AR51; `CODEOWNERS`/PR template; `.gitignore` covering `node_modules/` and `.DS_Store`; **preserve the existing API surface, validation shapes, seeded determinism and 4 passing tests unchanged**; retain `Swagger UI.pdf` + `apiresponses.docx` under `contract/` with a provenance README; retain the `ReferenceData/` exports with their source and export date; **an NFR14 forbidden-data check** confirming the exports are organisational-only with **no personal data** (verified during this analysis) plus a **data-owner sign-off or a named outstanding action** (gaps.md G8.7); a non-root Node 22 LTS container; a Helm chart with per-environment overlays; **liveness/readiness probes on endpoints outside the mocked `/api/v5` surface**, so `GET /api/v5/healthcheck` keeps meaning exactly what the real eLinks API means by it; ACR push; TLS via APIM; structured JSON logs with correlation IDs into shared App Insights; **the three production-refusal guards**; and CI running reproducible install + tests + lint + `npm audit` + `helm lint` + a **CycloneDX SBOM**.

**Rationale:** the greenfield scaffold story described work that must not happen. Its one still-valid element — the production guards — is retained and promoted, because it is the gap that carries actual risk today.

**Story 0M.1.2 — OLD:** *"`ctam-joh-mock` serves all 15 `jo_*` entities on the expected eLinks contract, with fault injection"* — build the entity endpoints, author ET-flavoured fixtures, publish an OpenAPI spec as CTAM's provisional expectation, add fault modes.

**Story 0M.1.2 — NEW:** *"Publish the contract, guarantee an ET cohort, align fixture identity, and add fault injection"* — the endpoints already exist, so the story reduces to the four genuine gaps: (a) a **machine-readable OpenAPI 3.x** spec generated from or verified against the implementation, each field marked *evidenced* or *inferred* (including the three deviations the README already documents), stating prominently that it is **CTAM's reading of the contract, not a contract agreed with Judicial Office**, plus a Postman collection; (b) a **guaranteed, documented ET cohort** — a non-zero number of people holding a current appointment at an ET **location** with an ET **appointment title** and an ET **ticket**, reachable through the change, leavers and deleted feeds, with the ET predicate (the exact location/ticket/title ids) **written down** so `ctam-reference-data`, `ctam-authorisation` and the FR57 work all key off one definition; (c) **fixture-identity alignment** so a documented subset carries stable keys shared with `ctam-mrd-mock`, the `ctam-mock-auth` roster and the Epic 0.7 bootstrap, at least one of them an ET holder; (d) **fault injection**, inert unless selected — malformed payload, per-record non-conformance, unreachable/5xx, slow response, **and two change-feed-specific faults** (a feed shifting between page requests; an internally inconsistent pagination envelope) that no existing acceptance criterion covers because finding **F1** was unknown when Epic 0.2 was written. Plus test coverage for each fault mode and for the reference-data and single-person endpoints the current 4 tests never reach.

**Rationale:** "serve the entities" is done. What is missing is the contract artefact, the ET guarantee G8.1's wave-1 condition needs, cross-mock identity, and the failure-path mechanism Epic 0.2's ACs depend on.

### 4.2 AR55 revised; AR55.1 new

**AR55** now describes the adopted reality: the v5 surface including the change feed and the leaver/deleted feeds; real production reference data; an OpenAPI spec that is CTAM's reading of vendor documentation with *evidenced*/*inferred* markers; a guaranteed ET cohort defined as locations under `jurisdiction_id` 34 plus ET tickets and titles, **not** a jurisdiction; fault-injection modes; the three production guards; no shared-schema tables; and that passing against the mock is **not** closure of G8.1.

**AR55.1** records the stack exception: `ctam-joh-mock` is **the single documented exception to AR2–AR17** and to `conventions.md`'s scaffold rule, running Node 22 LTS + Express 4. It states the justification (non-production; no shared-schema table; neither produces nor consumes a CTAM API contract; outside the Java dependency graph; a rewrite would discard working tested code for conformance nothing reaches), enumerates what the exception **does not waive** (container, Helm, probes outside the mocked surface, structured logs with correlation IDs, App Insights, production guards, CI gates, CycloneDX SBOM, published contract), and states that **no other repo may cite it as precedent**.

### 4.3 Gap amendments

**G8.1 — major update.** Records that the eLinks v5 contract is now **documented** and its real reference data in hand, then states plainly that **three of the gap's own stated assumptions are falsified** (F1 change-feed vs full-refresh; F2 flat jurisdiction with hierarchy elsewhere; F3 ET-as-location, which means the gap's wave-1 condition **cannot be satisfied as written** and FR57's activation key cannot express ET) plus F4 (no `personnel_number`). Revises the closure condition — no longer phrased as "ET jurisdiction coverage" — and splits the gap's status: **JOH half partly evidenced, MRD half wholly open**.

**G8.5 — partly evidenced.** ET legal titles are **confirmed real** (`Employment Judge` 48, `Regional Employment Judge` 71, +7 more, judiciary role 90004). The employer-side/employee-side **lay-member panels appear nowhere** in the reference data. Panel composition becomes the substantive remainder of the ET as-is pack.

**G8.7 — new.** Governance of the real production exports held in the repo. Records the verified finding that they are **organisational reference data only, no personal data** (NFR14 satisfied on the forbidden-data test), and identifies what is **not** settled: whether Judicial Office accepts production exports being held in a CTAM repository, and under what refresh/retention terms. Tied to an explicit AC on Story 0M.1.1.

### 4.4 Dependency edge

```
OLD: epic-0M.1  depends_on: [epic-0.0, arch-baseline, epic-0.1]
NEW: epic-0M.1  depends_on: [epic-0.0, arch-baseline]
```

**Rationale:** the `epic-0.1` edge existed so the mock's fixtures would conform to the `jo_*` schema. The mock's shape now comes from the real contract, so the edge has no basis — and the flow is inverted. `epic-0.2` still depends on both, so nothing downstream weakens.

### 4.5 Decision #19 and changelog v4.8

Both record the adoption, the stack exception, the dropped edge, all four findings with their contradicted targets named, the G8.5 partial evidence, the new G8.7, and that **G8.1 stays open**.

## 5. Implementation Handoff

**Scope classification: Moderate**, with an architect-owned tail. An epic's stories are fully replaced, a new architecture rule (AR55.1) is created, three gaps move, and a dependency edge changes — but no requirement or scope boundary moves, so this is not a replan.

- **Developer agent (control plane):** the artifact sweep in §2, this SCP, the v4.8 changelog entry, the NAV entry, and the `docs/` regeneration.
- **Architect:** decision #19; AR55 revision and AR55.1; the `conventions.md` carve-out; the G8.1 / G8.5 / G8.7 amendments. **And the follow-up SCP** — see below.
- **PO / DEV (backlog):** Epic 0M.1's two stories re-scoped in the ledger; 0M.1 becomes dispatchable earlier (drops the `epic-0.1` wait). **Story 0M.1.1 should be treated as the higher priority of the two** — the production-refusal guard does not exist yet.
- **Repo owner:** rename `ctam-jomockapi` → `ctam-joh-mock` locally and on GitHub, per AR51 (manual, web UI; the `gh` CLI is not available).
- **Commit:** the user reviews and commits externally via VSCode (git writes are blocked inside Claude).

**The follow-up SCP is the most important output of this change.** It owns:

1. **AR46** — replace the full-refresh-upsert sync model with a change-feed model: `updated_since` watermarking, consumption of the explicit `leavers` / `deleted` feeds, and removal of the "infer deactivation from absence" rule. Rework Epic 0.2 Story 0.2.3's acceptance criteria accordingly.
2. **D8 / `jo_jurisdictions`** — decide where the jurisdiction hierarchy comes from now that `REF_Jurisdiction` is flat: `locations.parent_id`, `ticket_categories.parent_category_id`, or a CTAM-owned tier-(b) hierarchy. Update Story 0.2.2 and `data-tables.md`.
3. **FR57 / ET scoping** — re-express the wave-1 activation predicate, since `(jurisdiction, region)` cannot say "ET". This touches the PRD.
4. **D9 / identity** — re-key the two-population chain from `personnel_number` onto `per_id` / `personal_code`. This touches the PRD, Epics 0.2, 0.4 and 0.7, and `data-tables.md`.
5. **The Epic 0.1 inversion** — Epic 0.1's `jo_*` schema design should be validated against the documented contract rather than authored independently of it.

**Success criteria:**

1. Epic 0M.1 describes adoption, not a greenfield build; both stories' content is replaced; story ids `0M.1.1`/`0M.1.2` and the epic's number/title are unchanged.
2. Epic 0M.1 carries a **Findings** section stating F1–F4, each naming the artifact it contradicts, and stating that none is actioned in this epic.
3. `gaps.md` G8.1 states the contract is documented, names the three falsified assumptions, revises the closure condition, and still marks the gap **open**; G8.5 records the ET-title evidence and the missing panel structure; **G8.7 exists**.
4. `AR55` is revised and **`AR55.1` exists**, scoping the exception to language and build tooling, enumerating what is not waived, and stating it is not precedent; `conventions.md` carries the matching carve-out.
5. `dispatch-graph.yaml` parses, is **acyclic**, `epic-0M.1.depends_on` is `[epic-0.0, arch-baseline]`, and `epic-0.2.depends_on` still contains **both** `epic-0.1` and `epic-0M.1`.
6. Phase totals unchanged — Phase 0-Mock 2 epics / 4 stories; Phase 0 9 epics / 23 stories. No story added, removed or renumbered.
7. `prd.md` is unmodified (`git diff` shows no change) — the PRD-level corrections belong to the follow-up.
8. `scripts/build-html.sh` completes and this SCP plus the rewritten epic render and are reachable from the NAV.

## 6. Pre-existing Findings — Not Part of This Change

1. **Site NAV is still missing four Sprint Change Proposals** — `2026-08-14`, `2026-08-15`, `2026-08-15b`, `2026-08-15c` — plus `implementation-readiness-report-2026-06-17`, `-2026-08-11`, and both `prd-validation-report-*` files. Flagged in SCP 2026-08-18 §6, 2026-08-18b §6 and 2026-08-18c §6, and **still open**. Fourth time of asking.
2. **`scripts/python/__pycache__/build_html.cpython-314.pyc` is tracked in git** and churns on every site build. Needs a `.gitignore` entry.
3. **`architecture/delivery-operating-model.md`'s illustrative dispatch-graph snippet** still carries pre-2026-08-15 epic ids for the non-mock repos; marked `ILLUSTRATIVE SHAPE ONLY` rather than renumbered.
4. **The adopted repo has not been through CTAM code review**, and its 4 tests do not reach the reference-data or single-person endpoints. Story 0M.1.2 extends coverage; a review pass against the CTAM code-review standard is not currently scheduled by any story and may deserve one.
