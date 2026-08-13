---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — Programme renamed RAM → CTAM (Court and Tribunals Availability Management)'
description: 'Date: 2026-08-13 — The programme is renamed from RAM (Resource Availability/Allocation Management) to CTAM (Court and Tribunals Availability Management). Naming-only cascade across every surface — product codename, repository names, table prefix, Java package, artefact coordinates, schema and DNS. No scope, requirement, architecture or sequencing change.'
resource: 'sprint-change-proposal-2026-08-13.html'
tags: [ctam-pathfinder, sprint-change, naming, rename]
timestamp: '2026-08-13'
parent: 'planning-artifacts/index.md'
project: 'ctam-analysis (CTAM Pathfinder)'
change_scope: 'Major surface, zero semantic (documentation only — implementation not started)'
mode: 'Batch'
decision: 'D14'
architectureVersion: 'v4.1'
last_updated: 2026-08-13
---

# Sprint Change Proposal — 2026-08-13

**Programme name: RAM → CTAM (*Court and Tribunals Availability Management*)**

---

## Section 1 — Issue Summary

**Trigger:** The programme is renamed. **RAM** (*Resource Availability/Allocation Management*) becomes **CTAM** (*Court and Tribunals Availability Management*). The new name states the domain — Courts and Tribunals — rather than the generic capability, and aligns the programme's identity with HMCTS's organisational language.

**Disposition agreed at intake (2026-08-13):** full rename, applied in place, across every surface at once. Four points were settled before any edit was made:

| Question | Decision |
|---|---|
| How deep into technical identifiers? | **All the way** — repos, table prefix, Java package, artefact coordinates, schema name and DNS, not just prose |
| Does "Pathfinder" survive? | **Yes** — the product codename is **CTAM Pathfinder** |
| Dated reports / prior changelog entries? | **Rewritten in place**, overriding the standing "immutable history" convention — the git history is the point-in-time record |
| Change record? | **This SCP + a `changelog.md` v4.1 entry + D14 in the PRD** |

**Discovery context:** Raised while the programme still sits between planning and execution. **Implementation has not started** — all six Phase 0 epics are `status: not-started` with `owner: null` in `delivery/ledger/`, and `_bmad-output/implementation-artifacts/` is empty. Like SCPs 2026-07-06, 2026-07-09 and 2026-08-07, this is a **documentation change with no code to unwind**. Unlike those, it carries **no semantic content at all** — it is the largest surface and the smallest risk in the programme's history.

**Evidence — measured surface (repo-wide sweep, 2026-08-13, excluding the generated `docs/` site):**

| Surface | Occurrences | Form |
|---|---|---|
| Product codename | 626 | `RAM Pathfinder` → `CTAM Pathfinder` |
| Repository names (17) | 1,274 | `ram-*` → `ctam-*` |
| Owned-table prefix + index names | 606 | `ram_*` → `ctam_*`, `uq_ram_*` → `uq_ctam_*` |
| Adjectival prose | 214 | `RAM-owned` / `RAM-assigned` / `RAM-internal` / `RAM-overlay` |
| Java root package | 37 | `uk.gov.hmcts.ram` → `uk.gov.hmcts.ctam` (incl. `src/…/uk/gov/hmcts/ram/` paths) |
| API-spec artefact coordinates | 13 | `api-ram-{service}` → `api-ctam-{service}` |
| DNS hostnames + shared schema | 8 + 1 | `ram.hmcts.gov.uk`, `api.ram.{env}.hmcts.gov.uk`, `admin.ram.hmcts.gov.uk`; schema `ram` |
| **Total, across 88 files** | **~2,780** | 60 under `planning-artifacts/`, plus `CLAUDE.md`, `README.md`, `project-context.md`, `sql/`, `queries/`, `scripts/python/`, `.claude/` |

A further **80 files under `docs/`** carried the old name; `docs/` is generated and was **regenerated**, not edited.

**Two paths were renamed on disk:**

- `planning-artifacts/briefs/brief-ram-analysis-2026-08-09/` → `brief-ctam-analysis-2026-08-09/`
- `.claude/memory/project_bmad_ram_pathfinder_state.md` → `project_bmad_ctam_pathfinder_state.md`

---

## Section 2 — Impact Analysis

### 2.1 The central finding — nothing but the name moves

**No FR, NFR, epic, story, decision, gap or assumption changes.** The 16-repo decomposition, the 55-table data model, all 60 FRs / 42 NFRs, the Phase 0–8 build sequence, all 6 Phase 0 epics / 19 stories, `dispatch-graph.yaml`, `delivery/ledger/` and decisions D1–D13 stand exactly as they were. Only the tokens naming them differ.

This is a rename, not a course correction. It is recorded through the SCP machinery because the surface is programme-wide and the artifact set must be traceable — not because anything was reconsidered.

### 2.2 What was deliberately *not* renamed

The `ram`/`RAM` token was **only** replaced where it names this programme. Three classes were held back:

- **Upstream reference-data prefixes `jo_` and `mrd_`** — these name JOH eLinks and MRD, source systems outside this programme. The two-tier ownership contract in `conventions.md` (tier-(a) upstream, read-only in CTAM; tier-(b) CTAM-owned) is unchanged; only the tier-(b) prefix moves.
- **The dev-only `mock_` prefix** — never production, never programme-named.
- **English words containing the letters `ram`** — `framework`, `parameter`, `diagram`, `reframed`, `FedRAMP`, and the author name `Ramnish`. The sweep used boundary-anchored patterns (`(?<![A-Za-z0-9_])RAM(?![A-Za-z0-9_])` and `(?<![A-Za-z0-9])ram(?![A-Za-z0-9])`), so `ram` was matched only as a standalone token or as the leading segment of a `ram-`/`ram_`/`_ram_` identifier. A blind find-replace would have corrupted all six; a pre-flight sweep enumerated them and a post-flight sweep confirmed none were touched.

### 2.3 Why now, and why in one pass

**No code exists yet.** Every one of the 16 target repos is unbuilt, no Flyway migration has run, no artefact has been published to the internal repository, and no DNS record has been cut. The rename therefore needs **no migration, no deprecation window, no dual-naming period, and no rollback plan** — the three mechanisms that normally make a platform-wide rename expensive are all inapplicable.

Deferring it does not preserve optionality; it only raises the price. Once `ctam-shared-infrastructure` provisions the estate and `ctam-reference-data` runs its first migration, the table prefix becomes a data-migration problem and the DNS names become a cutover problem.

### 2.4 The one convention deliberately overridden

`CLAUDE.md` states: *"Leave dated reports and existing changelog entries as immutable history — add, don't rewrite."* That rule was **overridden for this change**, by explicit decision.

The reasoning: those documents record *decisions*, and no decision changed. Preserving `RAM` inside the 7 SCPs, 5 readiness reports and 2 validation reports would leave the artifact set unsearchable under a single name and would strand ~40% of the corpus in vocabulary no one will use again — for the benefit of a point-in-time record that **git already holds exactly**. The rule exists to protect the substance of historical judgements; renaming a token does not touch that substance.

This override is scoped to this change and does not weaken the convention for future SCPs, where the rewritten text *would* carry semantic content.

### 2.5 Downstream consumers

Nothing is published or consumed yet, so there is no external notification list. Two items are flagged for whoever executes them:

- **GitHub repository names.** `hmcts/ram-analysis` has already been renamed to `hmcts/ctam-analysis` (this repo's `origin` confirms it). The other 16 repos **do not yet exist** — they will simply be created under their `ctam-*` names.
- **Azure DNS.** `ctam.hmcts.gov.uk`, `api.ctam.{environment}.hmcts.gov.uk` and `admin.ctam.hmcts.gov.uk` are now the names to reserve. No existing record needs retiring.

---

## Section 3 — Recommended Path Forward

**Direct adjustment, single batch.** No epic rollback, no re-planning, no PRD re-validation is warranted — validation assesses requirement quality, and no requirement changed.

**Applied:**

1. Boundary-anchored token sweep over all 88 tracked non-`docs/` files (verified clean in both directions: zero residual `RAM`/`ram` programme tokens; zero corrupted `framework`/`parameter`/`diagram`/`reframe`/`Ramnish`/`FedRAMP`).
2. Two on-disk path renames (§1).
3. **PRD** — new decision **D14**; new **CTAM** glossary entry recording both the expansion and the retired one; `[^d14]` footnote; `editHistory` entry.
4. **Architecture** — `changelog.md` **v4.1**.
5. **This SCP**, plus its `build_html.py` NAV entry.
6. **`docs/` regenerated** via `scripts/build-html.sh`.

**Not applied, and deliberately so:** no FR/NFR renumbering, no epic or story edits beyond the token sweep, no new gap or assumption, no readiness re-assessment.

---

## Section 4 — Change Scope Summary

| Artifact | Change |
|---|---|
| [`prd.md`](./prd.md) | **D14 added**; **CTAM** glossary entry added; `[^d14]` footnote; `editHistory` entry; token sweep throughout |
| [`business-case.md`](./business-case.md) | Token sweep |
| [`architecture.md`](./architecture.md) · [`architecture-summary.md`](./architecture-summary.md) | Token sweep — incl. shared schema `ram` → `ctam`, DNS endpoints, `uk.gov.hmcts.ctam.{service}.{layer}`, `api-ctam-{service}` |
| `architecture/` shards | Token sweep across [`conventions.md`](./architecture/conventions.md) (table-prefix rule), [`data-tables.md`](./architecture/data-tables.md) (all 55 tables + `uq_ctam_*` indexes), [`repository-strategy.md`](./architecture/repository-strategy.md), [`repo-structure.md`](./architecture/repo-structure.md) (source-tree paths), [`delivery-operating-model.md`](./architecture/delivery-operating-model.md), [`user-types.md`](./architecture/user-types.md), [`gaps.md`](./architecture/gaps.md), [`assumptions.md`](./architecture/assumptions.md), [`starter-template.md`](./architecture/starter-template.md), FR/NFR coverage, `diagrams/`, `sequence-diagrams/` |
| [`architecture/changelog.md`](./architecture/changelog.md) | **v4.1 entry added**; prior entries token-swept |
| `epics/` | Token sweep — [`framework.md`](./epics/framework.md), [`index.md`](./epics/index.md), [`fr-coverage-map.md`](./epics/fr-coverage-map.md), [`requirements-inventory.md`](./epics/requirements-inventory.md), all `phase-0/` epics. **No epic or story added, removed, re-scoped or resequenced.** |
| `delivery/` | Token sweep — [`dispatch-graph.yaml`](./delivery/dispatch-graph.yaml) (repo targets), `ledger/` shards, [`README.md`](./delivery/README.md). **No status or owner changed.** |
| Dated reports (7 SCPs, 5 readiness, 2 validation) | Token sweep — **rewritten in place** per §2.4 |
| `briefs/` | Directory renamed `brief-ram-analysis-2026-08-09` → `brief-ctam-analysis-2026-08-09`; contents swept |
| **This SCP** | New |
| Repo-level — `CLAUDE.md`, `README.md`, `project-context.md` | Token sweep |
| Legacy/exploratory — `sql/`, `queries/` | Token sweep (mock DDL comments, `psql -d ctam_mock`) |
| Tooling — `scripts/python/` (`build_html.py`, `build_graph.py`, `apply_okf_frontmatter.py`), `scripts/build-html.sh`, `.claude/lib/`, `.claude/memory/` | Token sweep; `build_html.py` NAV gains this SCP; memory file renamed |
| **`docs/`** | **Regenerated** — never hand-edited |

**Handoff:** none required. No agent, epic or repo is blocked by this change; the next action is unchanged from before it — sprint planning on Epic 0.0.
