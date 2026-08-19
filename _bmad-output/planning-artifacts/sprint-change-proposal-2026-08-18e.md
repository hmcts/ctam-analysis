---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — 2026-08-18e: Phase 0 repo-impact review — ctam-architecture enablement promoted to Epics 0.A/0.B, per-service DB roles assigned, cross-repo story attribution recorded'
timestamp: '2026-08-18'
tags: [ctam-pathfinder, sprint-change-proposal, phase-0, epics, delivery, repos]
---

# Sprint Change Proposal — 2026-08-18e

## Phase 0 reviewed from the perspective of *which repos each epic and story actually touches* — ten findings, all remediated pre-dispatch

## 1. Issue Summary

**Trigger:** a direct request to *"review the phase 0 stories especially from the perspective of which repos are affected by the Phase 0 epics/stories"*.

**Issue type:** pre-dispatch consistency and completeness review of an existing plan. **Not** a technical limitation, a new requirement, or a scope change. No story has been dispatched and no code exists, so every finding is corrected on paper at zero rework cost — which is the whole point of running the review now.

**Problem statement.** Phase 0's *declared* repo attribution — `repo:` in `delivery/dispatch-graph.yaml` and in the twelve ledger shards — is narrower than the repo work its **acceptance criteria actually require**. The gap takes three forms:

1. **Work with no owner.** A whole repo's worth of `ctam-architecture` deliverables that eight stories open by assuming — `ctam-scaffold.sh`, `runbooks/github-setup.md`, the `arch-v1.0` bus tag, `runbooks/terraform.md` — sat inside a single dispatch-graph node marked `decomposed: false`, with no stories, no ledger shard, and no owner. **Per-service PostgreSQL role creation had no owner at all**, while two stories grant privileges to those roles.
2. **Boundaries no story owns.** Per-service APIM registration was excluded by the estate epic and only half-claimed by the service epics. Two publicly-reachable resources are provisioned in *service* repos while the *estate* repo asserts the perimeter is closed.
3. **Attribution the ledger cannot express.** Story-level `repo:` is single-valued, but eight stories commit an artefact into a second repo. Dispatch packets built from the ledger would have been under-scoped, and the claim-before-you-start lock would not have covered the second repo.

**Evidence.**

| Finding | Evidence |
|---|---|
| **F1** `ctam-architecture` load-bearing, no epic | Stories 0.0.1, 0.2.1, 0.4.1, 0.4.2, 0.8.1, 0M.1.1, 0M.2.1 each open with `runbooks/github-setup.md`; five continue "runs `ctam-scaffold.sh`". `arch-baseline` node: `decomposed: false`, `stories: []`, no ledger shard, note covering only `ctam_configuration_values`. gaps.md G1.4a/G1.4b call `ctam-scaffold.sh` a "Phase 0 deliverable" with no story |
| **F2** per-service DB role creation unassigned | Story 0.0.3 *Explicitly NOT in scope*: "Per-service DB roles/grants … (owned by `ctam-architecture`; consumed in Epic 0.1)" — but no Epic 0.1 story delivers them, and the `arch-baseline` note never mentioned roles. Story 0.2.2 then grants SELECT to `ctam_authorisation` "and placeholder roles for future services"; Story 0.5.1 to "every current and placeholder service DB role" |
| **F3** APIM registration ownership contradictory | Story 0.0.5 excludes "per-service API registration in APIM"; Story 0.4.1's `terraform/` lists an "APIM per-API policy"; Story 0.2.1 requires "registers its API through APIM" but describes its `terraform/` as Key Vault + MRD storage only; Epic 0.8 never mentions it. The cross-repo remote-state pattern it needs was only gap G10.2 |
| **F4** ledger cannot express multi-repo stories | Story 0.5.1 AC writes `ctam-architecture/runbooks/reference-data-maintenance.md`; Story 0.8.1 AC says "the schema is documented in `architecture/data-tables.md`" (this repo); Story 0.7.1's scripts write into `ctam_auth_*` and `jo_*`, owned by two other services. All recorded with a single `repo:` |
| **F5** graph permits unsafe within-repo parallelism | Epics 0.5 and 0.6 have disjoint dependency sets, the same `repo: ctam-reference-data`, and Story 0.6.1 states its Postman coverage lands in the "same collection file as Epic 0.5" and its OpenAPI additions in the same `api-ctam-reference-data` artefact — against `ledger/README.md`'s own "serialise within a repo" rule |
| **F6** port `8082` on three services | Stories 0.2.1, 0.4.1, 0.8.1 all state "default port is 8082 (per AR3)"; AR3 itself says "Default port 8082". Raised in `implementation-readiness-report-2026-08-11.md` §2 (under the pre-renumbering ids 0.1.1/0.2.1/0.5.1) and still open. Meanwhile Epic 0M.2 had independently adopted 8091 — no allocation table existed anywhere |
| **F7** ET predicate / identity set not cited | Story 0M.1.2 publishes the ET predicate and shared identity set as "the single reference all four consumers read". Stories 0.4.2, 0.5.1 and 0.7.1 each defined their own alignment; none cited it |
| **F8** public surfaces outside the stated perimeter | Story 0.0.6 asserts the estate is "unreachable from the public internet except through the hardened APIM gateway". Story 0.4.4 provisions an Azure Static Web App in `ctam-ui`'s `terraform/` (hosting choice still open — gaps.md G3.5); Story 0.3.1 provisions a storage container an **external team must write into** |
| **F9** renumbering drift | Epic 0.0 pointed at "Epic 0.1, Story 0.1.1" for the `ctam-reference-data` scaffold, "Story 0.1.4" for MRD storage, "Epic 0.1 onward" for domain services; Epic 0.4 pointed at "Epic 0.6" for the bootstrap (now 0.7) twice; `delivery-operating-model.md`'s ledger example used story `0.1.4`, and its bootstrapping order scaffolded Terraform-only `ctam-shared-infrastructure` with the Java scaffolder and named a parallel set the current graph forbids |
| **F10** `ctam-analysis` not in the repo inventory | `dispatch-graph.yaml` and `ledger/epic-0.1.yaml` name `repo: ctam-analysis`; `repository-strategy.md`'s 18-repo table does not contain it |

**Declared repo coverage — the answer to the question asked.** Phase 0 + Phase 0-Mock touch **9 of the 18 product repos**, plus `ctam-analysis`. Nine repos are untouched until Phase 1+ (`ctam-joh`, `ctam-absence`, `ctam-vacancy`, `ctam-booking`, `ctam-sitting`, `ctam-payment`, `ctam-itinerary`, `ctam-mi-feed`, and post-MVP `ctam-admin-ui`). **That part was correct and consistent with the graph** — no epic reaches into a repo that belongs to a later phase, and no later-phase repo is silently pulled forward. The findings are all about *under*-declaration, never over-reach.

**Three decisions confirmed with the user before drafting:**

1. **F1 → a new decomposed epic**, lettered `0.A`, rather than decomposing the `arch-baseline` node in place or documenting it as untracked programme setup. Lettering keeps all 23 existing Phase 0 story ids stable.
2. **F4 → add an optional `touches:` field** to the ledger story schema, rather than making `repo:` a list or splitting every cross-repo story into per-repo stories. `repo:` stays single-valued so the claim lock remains unambiguous.
3. **F6/F9 → fix all of it now**, including `delivery-operating-model.md`'s stale example and bootstrapping order, rather than deferring either.

**One consequence of decision 1 that emerged during drafting.** The `ctam-architecture` work does not fit in one epic. `runbooks/github-setup.md` must exist **before** Story 0.0.1 creates a repo; the `ctam_configuration_values` baseline and the DB roles cannot be applied **until** Story 0.0.3 has provisioned PostgreSQL. Putting both in one epic makes `epic-0.0` and that epic mutually dependent — a **cycle** under the buildable-now rule, and a latent one that already existed in the old `arch-baseline` node (`depends_on: [epic-0.0]`, while Story 0.0.1 depended on its runbook). It is therefore split in two: **Epic 0.A precedes Epic 0.0; Epic 0.B follows it.**

## 2. Impact Analysis

### Epic impact

| Epic | Impact |
|---|---|
| **NEW 0.A** (`ctam-architecture`, 3 stories) | Bus publish + `arch-v1.0` tag (0.A.1); `ctam-scaffold.sh` + starter overlay + CI ruleset wiring (0.A.2); the GitHub-setup and Terraform-conventions runbooks (0.A.3). `depends_on: []` — **precedes Epic 0.0** |
| **NEW 0.B** (`ctam-architecture`, 1 story) | `ctam_configuration_values` baseline **+ per-service DB role provisioning + the grants convention** (0.B.1). `depends_on: [epic-0.A, epic-0.0]` |
| **0.0** | `depends_on` gains `epic-0.A`. Stale refs fixed (0.1.1 → 0.2.1; Story 0.1.4 → Epic 0.3 Story 0.3.1; "Epic 0.1 onward" → "Epic 0.2 onward"). Story 0.0.1 gains an explicit "not scaffolded by `ctam-scaffold.sh` — Terraform-only" note. Story 0.0.3's exclusion now points at Epic 0.B instead of a story that never existed. Story 0.0.5's APIM exclusion now names what it defers *to*. **Story 0.0.6 gains an AC** requiring the perimeter claim to name its two exceptions with compensating controls and owning repos. No story added, removed or renumbered |
| **0.1** | `repo:` becomes `[ctam-analysis, ctam-architecture]`; `depends_on` gains `epic-0.B`. Story 0.1.1 gains `touches: [ctam-architecture]`; Story 0.1.2 gains a note recording that Story 0.A.2 wires it into every scaffolded repo — closing the "authored but never adopted" gap. No AC change |
| **0.2** | `depends_on` gains `epic-0.A` + `epic-0.B`. Story 0.2.1: port stated as **8082 per the allocation table**; `terraform/` now explicitly includes its own APIM API + per-API policy; the config-values AC rewritten to consume Epic 0.B (role exists, authenticates as it, write refused); the APIM AC rewritten to establish the reusable cross-repo registration pattern; CI gates now include SQLFluff + the schema fitness function. Story 0.2.2: grants now resolve against Epic 0.B roles, plus a `data-tables.md` update AC |
| **0.3** | Story 0.3.1 gains four ACs on the drop container: named perimeter exception, scoped write for the MRD principal only, the `runbooks/terraform.md` cross-repo pattern, and an outstanding-action gate if the access model is unagreed. Grants resolve against Epic 0.B roles; `data-tables.md` update AC added. Within-repo sequencing note added |
| **0.4** | `depends_on` gains `epic-0.A` + `epic-0.B`. Two stale "Epic 0.6" → "Epic 0.7". **Ports: `ctam-authorisation` 8082 → 8083, `ctam-mock-auth` → 8100**, with an AC that it runs alongside `ctam-reference-data` without a clash. Story 0.4.2's roster now drawn from Story 0M.1.2's shared identity set. Story 0.4.4's SWA gains the G3.5 confirmation point and the perimeter-exception controls. A "three repos, one epic" note explains why the span is deliberate |
| **0.5** | Cross-repo shape stated up front (runbook → `ctam-architecture`; first cross-service runtime dependency on `ctam-authorisation`). Grants resolve against Epic 0.B roles. ET seed values now key off Story 0M.1.2's ET predicate. `data-tables.md` update AC added. Within-repo sequencing note added |
| **0.6** | Gains a **"dispatch after Epic 0.5, not alongside it"** section naming the two shared files. No AC change |
| **0.7** | Gains a **"cross-repo shape — read this before implementing"** section: the scripts live in `ctam-architecture` but write into two other services' tables; they run under the Epic 0.B bootstrap role with **no DDL privilege**; identities come from Story 0M.1.2's shared set |
| **0.8** | `depends_on` gains `epic-0.A` + `epic-0.B`. Story 0.8.1: port 8082 → **8084**; the DB role is Epic 0.B's; the `data-tables.md` write is called out as a second repo; its `terraform/` carries its own APIM API + policy |
| **0M.1** | `depends_on: [epic-0.0, arch-baseline]` → `[epic-0.A, epic-0.0]`. No AC change |
| **0M.2** | `depends_on` rewired to `[epic-0.A, epic-0.0, epic-0.1]`. **Port 8091 → 8102** (the allocation gives 8091 to `ctam-itinerary`; the three mocks band at 8100–8102) |
| **Phases 1–8, post-MVP** | **No change.** The `future:` nodes referenced neither `arch-baseline` nor any changed story |

**Totals: Phase 0 goes from 9 epics / 23 stories to 11 epics / 27 stories.** No pre-existing story id moved. Phase 0-Mock stays at 2 epics / 4 stories.

### Dependency-graph impact

The graph gains a genuine head and loses a latent cycle:

```
epic-0.A  →  epic-0.0  →  epic-0.B  →  epic-0.1  →  ┬→ epic-0M.1 → epic-0.2 → epic-0.4 → epic-0.5 → epic-0.6
(bus,        (estate)     (baseline    (schema      ├→ epic-0M.2 → epic-0.3 ──────┘         └→ epic-0.7
 scaffold,                + roles)      design)     └→ epic-0.8 (parallel throughout)
 runbooks)
```

`epic-0M.1` no longer waits on the DB baseline (it owns no table); `epic-0.8` still parallelises with the ingestion and auth chains. **New:** a `repo_serialisation` block constrains within-repo order for the two repos carrying four epics each.

### Artefact impact

| Artefact | Change |
|---|---|
| `epics/phase-0/epic-0.A-…md`, `epic-0.B-…md` | **New** |
| `epics/phase-0/epic-0.0 … 0.8` | Edits per the table above (all eight touched) |
| `epics/phase-0-mock/epic-0M.2-…md` | Port 8091 → 8102 |
| `epics/phase-0/index.md` | Sequencing blockquote, scope model, epic table (now with a **Repo** column), **new "Repo coverage at a glance" section**, two epic summaries, story-summary rows, totals 23 → 27 |
| `epics/index.md` | Phase 0 row: 9 epics/23 stories → 11/27 |
| `epics/framework.md` | Platform & DevEx scope: scaffold attributed to Epic 0.A; baseline + roles to Epic 0.B; APIM per-service ownership noted |
| `epics/requirements-inventory.md` | **AR3 amended** (port allocation replaces "default port 8082"); AR53 clarified with the APIM ownership split |
| `delivery/dispatch-graph.yaml` | `arch-baseline` → `epic-0.A` + `epic-0.B`; six `depends_on` lists rewired; `epic-0.1` `repo:` becomes a list; **new `repo_serialisation` block**; header note on lettered nodes |
| `delivery/ledger/epic-0.A.yaml`, `epic-0.B.yaml` | **New shards** (11 → 13) |
| `delivery/ledger/epic-0.1/0.2/0.3/0.4/0.5/0.7/0.8.yaml` | `touches:` on six stories; `note:` on five |
| `delivery/ledger/README.md` | `touches:`/`note:` in the schema block + a new section defining `repo` vs `touches` vs `note`; concurrency rule points at `repo_serialisation`; eleven → thirteen shards |
| `delivery/README.md` | Files table; "not executed here" reframed as "tracked as 0.A/0.B"; buildable-now rule cross-refs `repo_serialisation`; current state 11 epics/27 stories |
| `architecture/conventions.md` | **New: per-service port allocation table** (19 rows) and **per-service APIM registration ownership rule** |
| `architecture/repository-strategy.md` | `ctam-analysis` declared as the 19th repo / control plane, with why it is not a product repo |
| `architecture/delivery-operating-model.md` | Ledger example story id + `touches:`; **bootstrapping order rewritten** (7 steps); parallel-execution section gains the within-repo caveat |
| `architecture/gaps.md` | G1.4a, G1.4b, G4.4, G4.5, G9.1, G10.1, G10.2 owners → the specific 0.A stories; G6.4 notes role creation is now 0.B.1 |
| `architecture/changelog.md` | New v-entry |
| `scripts/python/build_html.py` | NAV: two new epics + this SCP |
| `docs/` | Regenerated |

### PRD impact

**None.** No FR, NFR or decision (D1–D13) changes. The only FR touched is **FR8**, which gains a *traceable owner* (Story 0.B.1) rather than a new requirement — it was previously covered by a node with no story. MVP scope, wave ordering, and the ET-first D13 framing are untouched.

### Technical impact

No code exists yet, so there is no rework. Three findings would have caused **hard failures at implementation time** and are worth naming as the review's concrete payoff:

- **F2**: Story 0.2.2's first `liquibase update` would have failed on `GRANT … TO ctam_authorisation` — the role did not exist and nothing created it.
- **F6**: the Phase 0 demo gate requires `ctam-reference-data`, `ctam-authorisation` and `ctam-notification` running together locally; all three were assigned port 8082.
- **F1**: Story 0.0.1 — the first story in the programme — opens by citing a runbook that no story wrote.

## 3. Recommended Approach

**Direct Adjustment** (Option 1). Selected; the other two paths were evaluated and rejected:

- **Rollback** (Option 2) — **not applicable.** Nothing is implemented; every story is `not-started` with `owner: null`.
- **MVP review** (Option 3) — **not warranted.** No finding touches scope, sequence, or deliverable set. All ten are attribution, ownership and consistency defects inside an otherwise sound plan.

**Effort:** Medium — 26 files, all planning artefacts, no code. **Risk:** Low — two additive epics, no story renumbered, no AC removed. Every AC added is either an owner for work already assumed or an explicit statement of a boundary that was previously implied.

**Why now rather than at dispatch:** each finding is a paper edit today. F2 becomes a failed pipeline, F6 a confusing local-environment debugging session, and F1 a blocked first story on day one.

**Alternatives considered and rejected within the chosen path:**

- **Numbering the enablement epics `0.-1`/`0.0` and shifting everything** — rejected: renumbering 23 stories for the fourth time in four days, for zero semantic gain. Lettering is the established local convention (SCP 2026-08-18c).
- **Folding the DB baseline into Epic 0.0** — rejected: `ctam-shared-infrastructure` is Terraform-only and owns no table; the baseline changelog is `ctam-architecture`-owned per FR8/AR19.
- **Making per-service APIM registration `ctam-shared-infrastructure`'s job** — rejected: it would make the estate repo a bottleneck on every service's release and contradict AR53's per-repo ownership. Recording the cross-repo reference pattern (G10.2) is the cheaper fix.
- **Splitting the six cross-repo stories** — rejected with the user (decision 2): it fragments vertical slices and grows Phase 0 to ~30 stories for bookkeeping that `touches:` handles.

## 4. Detailed Change Proposals

Applied in full; the *Artefact impact* table above is the manifest. The four substantive additions:

**(a) Epic 0.A — 3 stories, `ctam-architecture`, `depends_on: []`**

`0.A.1` bus publish + `arch-v1.0` tag (one-way projection from `ctam-analysis`; submodule consumption documented; contracts a read-only mirror per SCP 2026-07-07). `0.A.2` `ctam-scaffold.sh` + the starter overlay (every G1.4a/G1.4b capability; Liquibase not Flyway; versions pinned in one place; **wires the shared CI ruleset bundle including Story 0.1.2's schema fitness function**; local-only, no `gh` CLI; validated by a throwaway run so `ctam-reference-data` stays the first real service). `0.A.3` `runbooks/github-setup.md` + `runbooks/terraform.md` (G9.1, G10.1, G10.2 recorded as **agreed-with-date-and-contact or outstanding-with-owner**, never a silent default; carries the APIM ownership rule).

**(b) Epic 0.B — 1 story, `ctam-architecture`, `depends_on: [epic-0.A, epic-0.0]`**

`0.B.1` the `ctam_configuration_values` baseline (applied by a repeatable pipeline job, not from a laptop; no write path for any service) **plus** roles for the four Phase 0 services and forward-declared roles for Phases 1–8, each `SELECT`-granted on the baseline table, credentials in Key Vault; `ctam-joh-mock`/`ctam-mrd-mock` documented as holding **no role and no table**; the grants convention (owner-writes-the-grant, the tier-(a) rule, the Day-1 broad-then-tighten posture, the PR grants checklist).

**(c) `touches:` / `note:` in the ledger schema**

`repo:` = the one repo whose PR the story lands in (the claim). `touches:` = additional repos where it commits an artefact. `note:` = a cross-repo consumption or sequencing constraint that lands no artefact. Rule of thumb documented: *do I commit a file there?* → `touches:`; *do I only read from it?* → `note:`.

Applied to **eight stories** — 0.1.1 → the bus · 0.2.2 / 0.3.1 / 0.4.3 / 0.8.1 → `data-tables.md` in `ctam-analysis` · 0.5.1 → both (`runbooks/reference-data-maintenance.md` **and** `data-tables.md`) · 0.A.1 / 0.B.1 → `ctam-analysis` — and **six `note:` entries** (0.1.2's scaffold wiring, 0.2.1's consumed prerequisites, 0.2.3's and 0.3.1's mock consumption, 0.4.2's roster alignment, 0.7.1's write-into-two-services shape). Stories 0.2.3 and 0.3.1 deliberately carry `note:` rather than `touches:` for their mocks: they *consume* a published contract, they do not commit into that repo.

**(d) `repo_serialisation` in the dispatch graph**

`ctam-reference-data`: `0.2 → 0.3 → 0.5 → 0.6`, with the shared artefacts named (one OpenAPI spec, one Postman collection, one changelog sequence). `ctam-architecture`: `0.A → 0.B → 0.1 (story 0.1.2) → 0.7`. Dispatch must satisfy this **and** `depends_on`.

## 5. Implementation Handoff

**Scope classification: Moderate** — backlog and control-plane reorganisation. No code, no PRD change, no strategic replan.

| Recipient | Responsibility |
|---|---|
| **Product Owner / Delivery (control plane)** | Own Epics 0.A and 0.B as the new head of the Phase 0 queue; assign `owner` on both before the first dispatch. `bmad-sprint-planning` must read `repo_serialisation` as well as `depends_on` |
| **Solution Architect** | Two items need an external answer before their story can complete, both pre-existing gaps now attached to a story: **G9.1/G10.1/G10.2** (Terraform state backend, DDoS tier + WAF ownership, cross-repo reference pattern) → Story 0.A.3, blocking the Epic 0.0 apply; and the **G3.5** hosting choice + the two perimeter exceptions → Stories 0.4.4 / 0.3.1 / 0.0.6, needing HMCTS security sign-off |
| **Developer (execution)** | Nothing yet — no story is dispatchable until Epic 0.A is owned and 0.A.1 is dispatched |
| **Tech writer / control plane** | `docs/` regenerated via `scripts/build-html.sh`; the human commits the diff via VSCode per the git-write constraint |

**Success criteria for this change:**

1. Every Phase 0 / Phase 0-Mock story's first `Given` clause names an artefact some story in the graph delivers. *(Verified for all 27.)*
2. No story grants a privilege to a DB role that no story creates. *(Verified: 0.2.2, 0.3.1, 0.5.1, 0.8.1 all resolve to 0.B.1.)*
3. No two services share a local port. *(Verified against the new allocation table.)*
4. Every story that commits into a second repo carries `touches:`. *(Six stories.)*
5. `dispatch-graph.yaml` is acyclic and has exactly one zero-dependency node (`epic-0.A`). *(Verified.)*

## 6. Deferred — recorded, not actioned

Two items surfaced in the review, are **not** repo-attribution defects, and are deliberately left for a separate pass rather than widened into this one:

| Item | Detail | Owner |
|---|---|---|
| **`authz/check` path inconsistency** | Story 0.4.3 uses `POST /authz/check` in its `JWTFilter` AC and `POST /v1/authz/check` in its endpoint ACs — within one story. `architecture/conventions.md` and `architecture.md` (5 occurrences) use the unversioned form, while **AR38 mandates a `/v1/` prefix on every resource**. Every service's `JWTFilter` calls this path, so it needs one deliberate sweep, not a find-replace | Solution Architect — sweep `architecture.md`, `conventions.md`, `project-context.md` and Epic 0.4 together; recommend standardising on `POST /v1/authz/check` per AR38 |
| **`FR59` / `NFR59` mix-up** | Epic 0.2's *Key NFRs* line reads "NFR59 (structured logs first exercised at scaffold)"; structured logging is **FR59** (there is no NFR59). Cosmetic, in one line of one epic | Control plane — fold into the next epic-text pass |

---

**Change log entry:** `architecture/changelog.md` — v3.x (2026-08-18e).

**Immutability note:** this proposal *adds*. Prior SCPs, readiness reports and changelog entries are historical record and are not rewritten. The 2026-08-11 readiness report's port-collision finding (its §2, item 2) is **now remediated** — that report stands as written, and this document is where the fix is recorded.
