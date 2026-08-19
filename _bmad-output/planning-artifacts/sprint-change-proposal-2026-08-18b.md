---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — 2026-08-18b: Contract-shaped mock repos for both upstream sources (Epics 0.9 + 0.10)'
timestamp: '2026-08-18'
tags: [ctam-pathfinder, sprint-change-proposal, phase-0, epics, upstream-integration, mock-first]
---

# Sprint Change Proposal — 2026-08-18b

## Two new Phase 0 epics and two new repos: `ctam-joh-mock` (Epic 0.9) and `ctam-mrd-mock` (Epic 0.10)

## 1. Issue Summary

**Trigger:** a direct request to create two Phase 0 epics for a JOH mock and an MRD mock reference-data source, targeting two new repos — `ctam-joh-mock` and `ctam-mrd-mock`.

**Problem statement.** Phase 0's two ingestion epics are the programme's first external integrations and the foundation everything else stands on: **Epic 0.2** (nightly JOH eLinks sync → the 15 `jo_*` tables, including `jo_people`, without which no JOH can sign in) and **Epic 0.3** (weekly MRD Excel workbook → `mrd_*`). Both are blocked on external teams whose contracts are **unconfirmed**, recorded as gaps.md **G8.1** and promoted to a **wave-1 blocker** on 2026-08-07:

> *"The ingestion design (nightly in-process sync; weekly blob drop) **assumes**: the eLinks API exposes all 15 `jo_*` entities with stable natural keys; the jurisdiction hierarchy's parent-child shape is available; the MRD team can deliver the weekly workbook to an Azure Blob container in an agreed shape."*

Until 2026-08-18 the artifacts handled this with two thin placeholders:

- **Story 0.2.3** — *"dev/CI environments use seeded `jo_*` fixtures loaded by the one-off seed scripts where a live eLinks connection is unavailable (per AR52 — the sync code path is integration-tested against a WireMock/stub eLinks API in CI)."*
- **Story 0.3.1** — *"**When** the weekly workbook lands in the container…"* — with no statement of who or what puts it there before the MRD team exists as a delivery channel.

Both are insufficient for what these epics actually have to prove. An in-process WireMock stub cannot be deployed, cannot be reached over a real network hop, cannot be version-tagged independently, and — most importantly — is an assertion about *CTAM's own test code* rather than a written expectation of *someone else's contract*. Neither placeholder gives Story 0.2.3's four failure-path acceptance criteria (structurally malformed payload, per-record quarantine, unreachable mid-sync, contract-validation gate) or Story 0.3.1's three (whole-file rejection, per-row quarantine, idempotent re-drop) anything reproducible to execute against.

**Evidence.**

| Source | What it says |
|---|---|
| `architecture/gaps.md` **G8.1** | Both upstream contracts unconfirmed; wave-1 blocker since 2026-08-07 |
| `epics/phase-0/epic-0.2-*.md` Story 0.2.3 | The "WireMock/stub eLinks API in CI" clause, and four failure-path ACs with no mechanism to trigger them |
| `epics/phase-0/epic-0.3-*.md` Story 0.3.1 | Three variant-dependent ACs (reject / quarantine / idempotency) with no stated producer of those variants |
| `architecture.md` *Phasing of Authentication: Mock-First, Real IdP Later* | The established precedent: `ctam-mock-auth` reduced HMCTS IdP "from a Phase 0 blocker to a pre-Phase-9 prerequisite" |
| `architecture/repository-strategy.md` | `ctam-mock-auth` is already a first-class repo, not a test fixture — the pattern to generalise |

**Issue type:** new requirement emerged from delivery reality — specifically, an **external-dependency risk mitigation**. Not a technical limitation, not a misunderstanding of requirements, not a strategic pivot.

**Two decisions confirmed with the user during analysis:**

1. **Numbering — append as 0.9 / 0.10, do not insert at 0.2 / 0.3.** Inserting would have been "truer" to execution order but renumbered all 23 existing Phase 0 stories, renamed 7 epic files and 7 ledger shards, and rewritten ~30 cross-references — the third Phase 0 renumbering in four days (after SCPs 2026-08-15b and 2026-08-15c). The user selected append. The cost is accepted and made explicit: **an epic number is now an identifier, not a build position**, and `delivery/dispatch-graph.yaml` is the sole authority on order.
2. **Shape — full standalone deployables, not lightweight fixture repos.** Both are scaffolded from the HMCTS Crime SpringBoot template like every other service, deployed onto the Epic 0.0 estate, and reached over a real HTTP / blob hop. The alternatives offered (fixture-only repos; hybrid deployable-JOH + fixture-MRD) were not selected.

## 2. Impact Analysis

### Epic impact

| Epic | Impact |
|---|---|
| **New Epic 0.9** — Upstream JOH reference data has a contract-shaped mock source | 2 stories (0.9.1 scaffold + safeguard; 0.9.2 entities, fixtures, fault injection). Repo `ctam-joh-mock`. `depends_on: [epic-0.0, arch-baseline, epic-0.1]` |
| **New Epic 0.10** — Upstream MRD reference data has a contract-shaped mock source | 2 stories (0.10.1 scaffold + safeguard; 0.10.2 workbook generator, fixtures, variants). Repo `ctam-mrd-mock`. `depends_on: [epic-0.0, arch-baseline, epic-0.1]` |
| **Epic 0.2** (JOH ingestion) | `depends_on` gains `epic-0.9`. New *Upstream stand-in* section. Story 0.2.3's WireMock/stub AC **replaced**; its two failure-path Givens and its G8.1 contract-validation AC retargeted at the mock's fault modes and published spec. No story added, removed, or renumbered. |
| **Epic 0.3** (MRD ingestion) | `depends_on` gains `epic-0.10`. New *Upstream stand-in* section. Story 0.3.1's workbook-arrival AC now names the mock as producer; the rejection, quarantine and idempotency Givens retargeted at its variants. No story added, removed, or renumbered. |
| **Epics 0.0, 0.1, 0.4–0.8** | **No change.** Epic 0.4's mock-auth JOH roster and Epic 0.7's bootstrap fixtures are *referenced* by Story 0.9.2 (shared personnel numbers) but neither epic's own text or ACs change. |
| **Phases 1–8, post-MVP** | **No change.** The `future:` nodes in the dispatch graph are untouched — the mocks sit entirely upstream of Epic 0.2/0.3 and add no downstream edges. |

**Phase 0 totals: 9 → 11 epics, 23 → 27 stories.** No existing story ID changed.

### Dependency-graph impact

Two new nodes, two edited `depends_on` lists. **Verified acyclic** — the mocks depend only on Epics 0.0/0.1/arch-baseline and never on the ingestion epics they feed. Topological order:

```
epic-0.0 → arch-baseline → epic-0.1 → epic-0.9 → epic-0.2 → epic-0.10 → epic-0.3
         → epic-0.4 → epic-0.5 → epic-0.6 → epic-0.7 → epic-0.8
```

The mocks correctly sort immediately ahead of their consumers despite their high numbers.

**One cycle was identified during analysis and designed out.** The obvious design has `ctam-mrd-mock` publish into the MRD drop container — but that container is provisioned by **Epic 0.3, Story 0.3.1** (in `ctam-reference-data`'s own `terraform/`, per AR53's first-consumer rule). Epic 0.3 depending on Epic 0.10 while Epic 0.10 depends on Epic 0.3 is a cycle the epic-level dispatch graph cannot express. Resolution: **`ctam-mrd-mock` is container-target-agnostic** — it writes to whichever container its configuration names, targets local **Azurite** in CI (via the `gradle-docker-compose` plugin the starter already carries), and **does not provision** the drop container. Container ownership stays with `ctam-reference-data`, which is correct on the merits too: the consumer should own the resource the real MRD team drops into.

### Artifact impact (exhaustive)

| Artifact | Change |
|---|---|
| `epics/phase-0/epic-0.9-joh-reference-data-mocked.md` | **New** — 2 stories |
| `epics/phase-0/epic-0.10-mrd-reference-data-mocked.md` | **New** — 2 stories |
| `epics/phase-0/epic-0.2-joh-reference-data-ingested.md` | Stand-in section; Story 0.2.1/0.2.3 scope lists; Story 0.2.3 AC replacement + 3 AC retargets; references |
| `epics/phase-0/epic-0.3-mrd-reference-data-ingested.md` | Stand-in section; out-of-scope; Story 0.3.1 AC retargets ×4; references |
| `epics/phase-0/index.md` | Sequencing narrative; epic-number-vs-build-order note; new scope-model bullet; epics table +2 rows, total 23→27; +2 epic summaries; demo table +2 rows; NFR line; **new retirement-path paragraph** |
| `epics/index.md` | Phase 0 row 9→11 epics, 23→27 stories; epic-number-vs-order note |
| `epics/framework.md` | New Phase 0 Area row + full **Upstream Source Stand-Ins** Area section; "eight"→"eleven" epics; ingestion paragraph cross-ref |
| `epics/fr-coverage-map.md` | Heading `0.1–0.8` → `0.0–0.10` (also fixes a pre-existing off-by-one); new **epics with no FR of their own** note; FR6 tier-(a) row cross-refs the stand-ins |
| `epics/requirements-inventory.md` | **AR55** (`ctam-joh-mock`) + **AR56** (`ctam-mrd-mock`) |
| `architecture.md` | **Decision #17**; eLinks + MRD external-system bullets; **new *Phasing of Upstream Integrations: Mock-First, Real Upstream Later* section**; ingestion failure-handling + non-production-upstream bullets; implementation sequence step 3; validation bullet; structure-alignment sentence |
| `architecture-summary.md` | Non-production support table +2 rows; open-decisions list +1 |
| `architecture/repository-strategy.md` | Frontmatter + strategy line; **2 new repo rows**; 16→18 total; **new rationale paragraph** (why a mock is a repo, not a test fixture) |
| `architecture/gaps.md` | **G5.3 widened** to all three mocks with three named guards each; **G8.1 annotated** de-risked-not-closed, with the diff-on-landing protocol |
| `architecture/data-tables.md` | New **0-table** section for both mocks + inventory line |
| `architecture/delivery-operating-model.md` | Illustrative graph +2 repos and marked illustrative; "16 things"→"18 things" |
| `architecture/changelog.md` | **v4.6** entry |
| `delivery/dispatch-graph.yaml` | 2 new nodes; `epic-0.2`/`epic-0.3` `depends_on`; **NOTE ON EPIC NUMBERS** header block |
| `delivery/ledger/epic-0.9.yaml`, `epic-0.10.yaml` | **New** shards |
| `delivery/ledger/epic-0.2.yaml`, `epic-0.3.yaml` | `note:` on stories 0.2.3 / 0.3.1 |
| `delivery/README.md` | Current state 9→11 epics, 23→27 stories; epic-number-vs-order note + topological order |
| `delivery/ledger/README.md` | Shard range `epic-0.5`→`epic-0.10`; "six shards"→"eleven shards" (both pre-existing staleness) |
| root `CLAUDE.md` | 16-repo → 18-repo polyrepo list |
| `scripts/python/build_html.py` | 2 NAV entries; Phase 0 section label; this SCP's NAV entry |
| `docs/` | Regenerated via `scripts/build-html.sh` |

### Artifacts checked — no impact

`prd.md` (no FR/NFR changes — the mocks introduce no requirement and satisfy none; NFR24's *"JOH eLinks API + MRD are MVP integrations"* is unaffected, the integrations are unchanged, only what they point at in non-production), `business-case.md`, `architecture/conventions.md`, `architecture/repo-structure.md` (both mocks follow the standard per-service structure unmodified), `architecture/assumptions.md`, `architecture/user-types.md`, `architecture/starter-template.md`, `architecture/non-functional-requirements-coverage.md`, all `architecture/sequence-diagrams/*` (no runtime flow changes — non-production upstream substitution is a configuration concern, not a flow), `_bmad-output/project-context.md` (governs service code; the mocks follow the same rules with no exception needed), all dated readiness/validation reports and prior SCPs (**immutable history — not rewritten**).

**No UX impact.** Neither epic has a UI surface; NFR17–NFR19 do not apply.

### Technical impact

**No FR or NFR changes. No schema changes** — neither mock owns a table, so `data-tables.md`'s inventory is unchanged and the Epic 0.1 fitness function needs no exception. **No change to any CTAM API contract.** **No code impact** — implementation has not started; every Phase 0 epic is `not-started` in the ledger.

**New infrastructure footprint:** two additional AKS deployments in dev/CI/integration only, two ACR image streams, two APIM registrations. Nothing in production, by construction and by three enforced guards.

## 3. Recommended Approach

**Selected: Option 1 — Direct Adjustment.** Add two epics within the existing Phase 0 structure; adjust the two consuming epics' dependencies and the acceptance criteria that referenced the placeholder stubs.

**Rationale.** Rollback (Option 2) is not applicable — nothing is implemented. An MVP review (Option 3) is not applicable — no FR, NFR, or scope boundary moves; MVP is unchanged. What this change does is convert an already-identified, already-accepted risk (G8.1) from a *schedule dependency on two external teams* into a *deliverable CTAM controls*, which is precisely the trade the programme already made for identity with `ctam-mock-auth`.

**The honest cost.** Four extra stories and two repos to maintain, in exchange for: Epics 0.2 and 0.3 becoming buildable and demoable **without external-team access**; seven previously-unexecutable failure-path acceptance criteria becoming executable; and the first real contract arriving as a **diff against a written, version-controlled expectation** rather than an open discovery. Two things are deliberately *not* claimed:

- **G8.1 does not close.** The mocks encode CTAM's assumptions about the upstreams, not evidence about them. Both epics' final ACs state this explicitly, and G8.1's own text now says closure requires real upstream data plus confirmed ET jurisdiction coverage.
- **The fixtures are not ET evidence.** Per **G8.5**, the repository holds no ET as-is analysis pack. Every ET role name and vocabulary value in both fixture sets is marked **provisional**.

**Effort:** Medium (2 new repos, 4 stories; documentation sweep across 20 artifacts). **Risk:** Low-Medium. The genuine risk is **mock-reality divergence** — a mock that encodes a wrong assumption can make a broken integration look finished. Three mitigations are built into the ACs: every guessed field is pre-annotated in the published contract; the final AC of each epic requires a formal diff-and-architectural-PR when the real contract lands; and G8.1 is explicitly not closable by mock success. **Timeline impact:** adds two epics to the critical path ahead of Epic 0.2 — but they are parallelisable with Epic 0.8 and with each other, and they *remove* the external-team wait that currently gates Epics 0.2 and 0.3 entirely.

## 4. Detailed Change Proposals

### 4.1 New Epic 0.9 — `ctam-joh-mock`

**File:** `epics/phase-0/epic-0.9-joh-reference-data-mocked.md`. Slug follows the established `{source}-reference-data-{what}` pattern, completing the symmetry set:

| Layer | JOH | MRD |
|---|---|---|
| Mock | `epic-0.9-joh-reference-data-mocked` | `epic-0.10-mrd-reference-data-mocked` |
| Ingestion | `epic-0.2-joh-reference-data-ingested` | `epic-0.3-mrd-reference-data-ingested` |
| Read API | `epic-0.5-joh-reference-data-read-only-api` | `epic-0.6-mrd-reference-data-read-only-api` |

**Story 0.9.1 — Scaffold `ctam-joh-mock` with a production-refusal safeguard.** HMCTS starter baseline per Story 0.2.1 (AR2–AR17), package `uk.gov.hmcts.ctam.johmock`, port **8090**, no Liquibase changelog. Three production guards: `production`-profile startup refusal with the message *"ctam-joh-mock must not be deployed to production"*, `deploy-production.yml` exclusion, CI lint against production Helm values naming it as an eLinks endpoint. Deployed to dev AKS with probes, structured logs into the shared App Insights workspace, TLS via APIM, and a *"Mock upstream source — synthetic judicial data, not for production"* banner on its OpenAPI landing page.

**Story 0.9.2 — Serves all 15 `jo_*` entities on the expected eLinks contract, with fault injection.** All 15 entities as JSON, field-complete against `data-tables.md`; every guessed field name/type/cardinality annotated in the published OpenAPI spec (`uk.gov.hmcts.ctam:api-ctam-joh-mock`), labelled **provisional**. ET-flavoured fixtures carrying the **Employment Tribunals jurisdiction with its parent-child shape under Tribunals** (G8.1's wave-1 condition) and stable personnel numbers **shared with the Epic 0.4 mock-auth roster and Epic 0.7 bootstrap fixtures**. Deterministic payloads per fixture version. Fault modes: malformed payload, per-record non-conformance, unreachable/5xx, slow response. Final AC: diff-against-real-contract protocol, with G8.1 explicitly not closed by mock success.

### 4.2 New Epic 0.10 — `ctam-mrd-mock`

**File:** `epics/phase-0/epic-0.10-mrd-reference-data-mocked.md`.

**Story 0.10.1 — Scaffold with a production-refusal safeguard.** As 0.9.1, package `uk.gov.hmcts.ctam.mrdmock`, port **8091**, plus: an Excel-writing library **matching the reader Epic 0.3 uses**, so producer and consumer cannot disagree about workbook encoding; Azurite as the local publish target; Key Vault for any non-local storage credential; startup failure with a clear diagnostic if the configured container is absent; a *"Mock MRD feed — synthetic judicial data"* marker in every generated workbook.

**Story 0.10.2 — Publishes conformant and deliberately-malformed workbooks.** Sheets/columns derived from `mrd_*` in `data-tables.md`; a published **column dictionary** (sheet, column, type, vocabulary, required/optional, natural key) as the provisional contract, guesses annotated. Specialisations reference the **same personnel numbers as the Epic 0.9 fixtures**, so Epic 0.3's referential checks resolve against JOH data that exists. On-demand trigger + weekly `@Scheduled` publish. Variants: conformant; per-row non-conformant; structurally invalid (missing sheet/column); cross-sheet lookup failure; byte-identical re-drop. Final AC: the same diff protocol and the same explicit non-closure of G8.1.

### 4.3 Epic 0.2 — Story 0.2.3 acceptance-criteria change

**OLD:**
> **And** dev/CI environments use seeded `jo_*` fixtures loaded by the one-off seed scripts where a live eLinks connection is unavailable (per AR52 — the sync code path is integration-tested against a WireMock/stub eLinks API in CI).

**NEW:**
> **And** dev and CI run the sync against **`ctam-joh-mock`** (**Epic 0.9**) — a deployed, contract-shaped stand-in reached over a real HTTP hop, not an in-process stub — so the whole cleanse/transform/persist path is exercised end-to-end while real eLinks access does not exist,
> **And** the fixture version served by the mock is recorded against the run in `ctam_sync_status`, so a result can always be traced to the exact upstream payload set that produced it,
> **And** switching to real eLinks changes **configuration only** — the base URL and the Key Vault credential — with no change to the sync code or its test suite.

**Rationale:** an in-process stub cannot prove the integration; a deployed stand-in can, and makes the cutover configuration rather than code. Two further Givens (unreachable / malformed payload; per-record non-conformance) now name the mock's fault modes as the mechanism, and the G8.1 contract-validation AC now diffs against the mock's published spec — turning three aspirational criteria into executable ones.

### 4.4 Epic 0.3 — Story 0.3.1 acceptance-criteria change

**OLD:**
> **When** the weekly workbook lands in the container,
> **Then** a `@Scheduled` task in `ctam-reference-data` detects it on its polling cycle (per AR47).

**NEW:**
> **When** the weekly workbook lands in the container — published in dev and CI by **`ctam-mrd-mock`** (**Epic 0.10**) on its weekly `@Scheduled` cadence or via its on-demand trigger, so the drop is a **real blob hop** rather than a hand-placed test file,
> **Then** a `@Scheduled` task in `ctam-reference-data` detects it on its polling cycle (per AR47),
> **And** the mock's fixture version is recorded against the run in `ctam_sync_status`, so a result can always be traced to the exact workbook that produced it,
> **And** switching to the real MRD feed changes only **who drops into the container** — no change to the ingestion code or its test suite.

**Rationale:** the story previously had no stated producer of the workbook. Its rejection, quarantine and idempotency Givens now name the corresponding mock variants, making all three executable. The container stays provisioned here, in `ctam-reference-data`'s `terraform/` — unchanged.

### 4.5 New ARs

**AR55** — `ctam-joh-mock` is the dev/CI/integration stand-in for the JOH eLinks API: standalone deployable, all 15 `jo_*` entities, ET-flavoured fixtures, fault-injection modes, published OpenAPI spec as CTAM's provisional written expectation, three production guards, no shared-schema tables, cutover is configuration. Passing against it is **not** closure of G8.1.

**AR56** — `ctam-mrd-mock` is the dev/CI/integration stand-in for the MRD weekly Excel feed: standalone deployable, workbook generator with five variants, personnel numbers shared with AR55's fixtures, published column dictionary, **container-target-agnostic** (does not provision the drop container — that stays with `ctam-reference-data` per AR47/AR53), three production guards, no shared-schema tables. Passing against it is **not** closure of G8.1.

### 4.6 Gap amendments

**G5.3 widened** — was mock-auth-specific; now covers all three mocks, with the three guards named per mock (profile refusal, pipeline exclusion, CI lint).

**G8.1 annotated** — records that both upstream sources now have contract-shaped stand-ins that make the ingestion buildable and negative-testable pre-contract, and states in terms that **this does not close the gap**: the mocks are CTAM's assumptions, not evidence. Closure still requires both ingestion paths running against **real** upstream data with ET jurisdiction coverage confirmed. Adds the landing protocol: diff the real contract against the mock's published contract, raise the delta as an architectural PR.

### 4.7 Numbering decision, recorded explicitly

Appending at 0.9/0.10 means epic number no longer tracks build order. Rather than leave that as a trap, it is stated in five places: the dispatch graph's header (**NOTE ON EPIC NUMBERS**), the Phase 0 index blockquote, `epics/index.md`, `delivery/README.md` (with the full topological order), and decision #17. The site NAV's Phase 0 section label carries the same warning.

### 4.8 Regenerate `docs/`

Run `scripts/build-html.sh` after the two NAV entries and the section-label change.

## 5. Implementation Handoff

**Scope classification: Moderate** — two epics and four stories enter the backlog and two existing epics' dependencies change, so the delivery plan is reorganised; but no requirement, scope boundary, or architectural principle moves, so this is not a replan.

- **PO / DEV (backlog):** two new ledger shards seeded `not-started`/unassigned; `depends_on` edits on Epics 0.2 and 0.3; Phase 0 totals updated to 11 epics / 27 stories in the phase index, epics index and `delivery/README.md`. Sprint planning must read the topological order from the dispatch graph, **not** from epic numbers — Epics 0.9 and 0.10 are dispatchable as soon as Epic 0.1 is `done`, and they gate Epics 0.2 and 0.3.
- **Architect:** decision #17 and the new *Phasing of Upstream Integrations* section in `architecture.md`; AR55/AR56; the G5.3 widening and G8.1 annotation; the repository-strategy rationale for mock-as-repo.
- **Developer agent (control plane):** the artifact sweep in §2 plus this SCP, the v4.6 changelog entry, and the `docs/` regeneration.
- **Commit:** the user reviews and commits externally via VSCode (git writes are blocked inside Claude).

**Success criteria:**

1. `delivery/dispatch-graph.yaml` parses, is **acyclic**, and its topological sort places `epic-0.9` before `epic-0.2` and `epic-0.10` before `epic-0.3`.
2. `delivery/ledger/` holds 11 epic shards; `epic-0.9.yaml` and `epic-0.10.yaml` are `not-started`, `owner: null`; no existing story ID changed anywhere in the repo.
3. A repo-wide sweep for `WireMock` in `epics/` returns nothing (the placeholder is gone).
4. Every live reference to the 16-repo count is updated to 18: `repository-strategy.md`, `delivery-operating-model.md`, root `CLAUDE.md`.
5. Phase 0 reads **11 epics / 27 stories** consistently in `epics/index.md`, `epics/phase-0/index.md` and `delivery/README.md`.
6. G8.1 explicitly states the mocks do not close it; G5.3 names all three mocks.
7. `scripts/build-html.sh` completes and both new epic pages render, reachable from the site NAV.
8. `prd.md` is unmodified (`git diff` shows no change) — no FR or NFR moved.

## 6. Pre-existing Findings — Not Part of This Change

1. **Site NAV is still missing four Sprint Change Proposals** — `2026-08-14`, `2026-08-15`, `2026-08-15b`, `2026-08-15c` — plus `implementation-readiness-report-2026-06-17`, `-2026-08-11`, and both `prd-validation-report-*` files. Flagged in SCP 2026-08-18 §6 and **still open**; this change adds only its own NAV entry. Notably `2026-08-15b`/`c` define the current Phase 0 numbering and remain unreachable from the published site.
2. **`architecture/delivery-operating-model.md`'s illustrative dispatch-graph snippet carries pre-2026-08-15 epic ids** (e.g. `ctam-mock-auth: epics: [epic-0.2]`). Marked **ILLUSTRATIVE SHAPE ONLY** with a pointer to the live file rather than renumbered, since it is prose illustration, not the authority.
3. **`delivery/ledger/README.md` and `fr-coverage-map.md` carried stale ranges** (`epic-0.0 … epic-0.5`; "six shards"; "concrete epics 0.1–0.8") that pre-date this change. Corrected in passing since they would otherwise have been made *more* wrong by it.
