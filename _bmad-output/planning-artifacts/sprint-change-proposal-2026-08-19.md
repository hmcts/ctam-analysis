---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — Agent delivery rules adopted; test gates amended (TDD evidence, coverage floor, mutation threshold)'
description: 'Date: 2026-08-19 — Adds a binding "how we work" contract for the twelve Java execution units: evidence-based TDD, hard modularity limits, a cite-or-ask uncertainty protocol, and a single pre-handoff quality gate. Authored in ctam-architecture (the context bus) as agent-rules/, with a matching enforcement pack. Amends one existing convention: the behaviour-coverage stance now carries a JaCoCo floor and a PIT mutation threshold. No FR, NFR, epic, story or sequencing change.'
resource: 'sprint-change-proposal-2026-08-19.html'
tags: [ctam-pathfinder, sprint-change, delivery, tdd, quality-gates, agent-rules]
timestamp: '2026-08-19'
parent: 'planning-artifacts/index.md'
project: 'ctam-analysis (CTAM Pathfinder)'
change_scope: 'Minor — additive delivery discipline, one convention amended (documentation only; implementation not started)'
mode: 'Batch'
architectureVersion: 'v4.2'
last_updated: 2026-08-19
---

# Sprint Change Proposal — 2026-08-19

**Agent delivery rules adopted; test gates amended**

---

## Section 1 — Issue Summary

**Trigger:** Delivery is **AI-led** (Claude Code, BMAD method) across a **16-repo polyrepo** with **no shared runtime library**. The artifact set answered *what* to build in detail — `conventions.md`, `data-tables.md`, `project-context.md`, the epics with embedded Gherkin — but nothing stated *how the implementing agent must work*. That gap carries three specific risks, each amplified by the delivery model:

| Risk | Why the delivery model amplifies it |
|---|---|
| **Hallucinated APIs, versions and business rules** | An agent's training data predates the codebase, and there is no human pair mid-session to catch an invented method or an inferred validation threshold |
| **Tests that cannot fail** | Tests written *after* the code describe what the code does, not what the requirement demands. They pass for the life of the codebase without protecting anything, and a coverage percentage will not reveal it |
| **Code that cannot be maintained** | With no shared library, a bad abstraction cannot be fixed centrally — it is duplicated by design across up to twelve repos. Size and boundary discipline is the only defence |

**Disposition agreed at intake (2026-08-19):** eight questions were settled before anything was written.

| Question | Decision |
|---|---|
| TDD rigour | **Evidence-based red-green-refactor.** No production edit without a test that was *run* and failed *on an assertion*; a compile error is not a red test |
| Test gates | **Mutation threshold *and* a JaCoCo floor** — the only answer here that amends an existing convention (see §2.1) |
| API-first | **Contract-test-first, spec still generated** by Swagger Core — no change to AR8 or the producer-owned contract model |
| Uncertainty protocol | **Hard: cite or ask.** Every non-obvious decision names its authority; unknowns stop the thread rather than being inferred |
| Packaging | **Lean always-on core + modular rule files** read on demand — small always-on context budget, detail one hop away |
| Enforcement | **Rules *and* runnable enforcement** — ArchUnit, Checkstyle, Gradle gates, Spectral, plus two Claude Code hooks |
| Modularity limits | **Hard numbers, build-failing.** An agent cannot rationalise past a number the way it can past a principle |
| Scope of the first cut | **Java/Spring services only.** UI (React/TS) and infrastructure (Terraform/Helm) packs are a follow-up |

**Home — a deliberate departure from the usual shard pattern.** The rules were authored **in `ctam-architecture`** (the context bus) as `agent-rules/`, not as a `planning-artifacts/architecture/` shard. Per [`./architecture/delivery-operating-model.md`](./architecture/delivery-operating-model.md), the bus is exactly the mechanism for shared truth that every service repo consumes by pinned submodule: **one authored copy, version-pinned, adopted by a deliberate bump PR.** Authoring here and copying out would have re-created the 12-way drift the operating model exists to prevent. Two consequences, accepted:

- The pack is **not** published to the `docs/` site, because `build_html.py` reads `planning-artifacts/`. When the bus repo gains its own site, the pack publishes there.
- `agent-rules/` is the **first** piece of bus payload to land in `ctam-architecture`. The published architecture set (`architecture.md`, `conventions.md`, `data-tables.md`, `delivery-operating-model.md`) is still canonical here and unpublished there, so the pack's `_arch/architecture/…` citations resolve only after bootstrap step 1 of the operating model. This is recorded at the top of `agent-rules/index.md` rather than left to be discovered.

**Discovery context:** implementation has not started — all six Phase 0 epics remain `status: not-started` in `delivery/ledger/`. Like the SCPs of 2026-07-06 through 2026-08-13, this is a documentation change with no code to unwind. It is the last moment at which a TDD discipline can be adopted for free.

---

## Section 2 — Impact Analysis

### 2.1 The one genuine conflict — the coverage stance

`conventions.md` → *Test conventions* has said, since v1.8:

> **Coverage target:** behaviour coverage, not line coverage. PRs include behaviour-test rationale, not coverage stats.

The intent was right and is preserved: a percentage is not evidence that a story is tested — the AC → test map is. But as written it left **no deterministic floor at all**, which in AI-led delivery means the only thing standing between the programme and a vacuous suite is a reviewer's attention on every PR.

**Amended to keep the intent and add the floor:**

| Gate | Threshold | Scope |
|---|---|---|
| JaCoCo line coverage | ≥ 85% | `**/service/**`, `**/domain/**` |
| JaCoCo branch coverage | ≥ 75% | `**/service/**`, `**/domain/**` |
| PIT mutation score | ≥ 70% | `**/service/**`, `**/domain/**` |

Excluded from all three: `config/`, `dto/`, `*Application.java`, generated sources, Liquibase changelogs.

**Why mutation testing carries the weight.** Line coverage can be manufactured by executing code without asserting on it — precisely the failure mode an agent falls into when topping up a number. A surviving mutant names a specific statement the tests do not actually check, so it cannot be gamed the same way. The JaCoCo floor is the cheap, fast backstop; PIT is the honest measure. Both are floors, not targets, and the rules say so explicitly.

**What did not change:** behaviour coverage remains the goal, PRs still justify behaviour rather than reciting statistics, and no per-PR coverage reporting ritual is introduced.

### 2.2 Additive — no conflict

| Area | Addition |
|---|---|
| **TDD discipline** | Evidence-based red-green loop (T1–T4), the test taxonomy and when each level is appropriate (T7–T9), test-quality rules (T10–T15). `conventions.md`'s test-type naming (`*Test` / `*IT`) and the Testcontainers/Pact/E2E layers are referenced, not restated |
| **Modularity** | Numeric limits (M1–M8, M23) and layering, injection, time and naming rules (M9–M22). Consistent with the fixed package layout in `conventions.md` → *Structure Patterns*; adds the dependency direction between those packages, which was previously implicit |
| **Uncertainty protocol** | Cite-or-ask (R4), stop-on-unknown (R5), no unsanctioned surface (R6), no memory-asserted APIs (R7), nothing unfinished ships (R8) |
| **Session protocol** | Read order, the plan-before-edit step, `_arch/` read-only, repo boundaries, handoff format, `in-review` never `done` (W1–W13) |
| **Definition of done** | A single gate command and a 13-item checklist, each item evidenced (Q1–Q13) |
| **Enforcement pack** | ArchUnit fitness functions, Checkstyle config + the only sanctioned suppressions, Gradle wiring, Spectral ruleset, `verify.sh` / `red.sh` / `forbidden-patterns.sh`, target-repo `CLAUDE.md` template, hook registration, and two hooks |

The scaffolding overlay in `starter-template.md` §B already listed **Spectral · ArchUnit · Spotless · Checkstyle** as CTAM conventions to be added by `ctam-scaffold.sh` (G1.4a). This SCP supplies the actual configurations those entries anticipated, and adds PIT.

### 2.3 Two defects found in the canonical docs while authoring

Recorded as gaps rather than silently resolved — the same cite-or-ask discipline the rules impose:

- **G6.7 — contradictory status code for optimistic-lock failure.** `conventions.md` → *Process Patterns* maps `OptimisticLockingFailureException` to **409**; `conventions.md` → *Communication Patterns* ("Retry safety and concurrency control") says optimistic locking for lost-update returns **412**. Both are current text. Until resolved, the rules make an optimistic-lock path an explicit stop-and-ask rather than picking one.
- **G1.4c — quality-gate tool versions unproven on the target toolchain.** Versions were verified as released (Checkstyle 14.0.0, Spotless 8.10.0, JaCoCo 0.8.14 — first with official Java 25 support, ArchUnit 1.5.0, gradle-pitest 1.19.0, pitest 1.25.9, pitest-junit5 1.2.3) but **nothing in the enforcement pack has been compiled or executed**, because the control-plane workspace holds no Java build. PIT running *on* a Java 25 toolchain against Spring Boot 4 is the specific unknown. The pack states its own validation status per file, and the first scaffolding story owns making it run and reporting corrections back to the bus.

### 2.4 Enforcement honesty

Two limits are stated in the pack rather than papered over:

- **`require-red-test.sh` is a guardrail, not a proof.** It refuses `src/main/**` edits unless a recent failing test run was recorded by `scripts/red.sh`. It raises the cost of skipping TDD; it cannot verify the failing test was the *right* test. The real evidence is the pasted red/green output, reviewed by a human.
- **Rules with no automated enforcer are listed as such.** `enforcement/README.md` maps every rule id to its enforcer and marks *review only* explicitly, with the four worth mechanising next (the `/v1` append-only check, the authorisation-per-endpoint rule, changeset immutability, and AC → test mapping). A soft spot recorded is a soft spot that can be closed.

### 2.5 What is not covered

`ctam-ui` / `ctam-admin-ui` (React/TypeScript) and `ctam-shared-infrastructure` (Terraform/Helm) have **no language-specific rules or enforcers**. The core rules R1–R14 still govern conduct in those repos. This matters for sequencing: `ctam-shared-infrastructure` is the phase-0 repo built **first** and is not Java, so its stories run without an enforcement pack. Recommended follow-up: an infrastructure pack before Epic 0.0 dispatch, then a UI pack before the Epic 0.ui-shell work.

---

## Section 3 — Recommended Path Forward

**Direct adjustment, single batch.** No epic rollback, no re-planning, no PRD re-validation — no requirement changed, and no product decision was taken. Recorded as an **architecture-practice** change (`changelog.md` v4.2) rather than a PRD locked decision, following the precedent of SCP 2026-07-07.

**Applied:**

1. **`ctam-architecture/agent-rules/`** — nine rule documents (`index.md`, `00-core.md`, `10-tdd.md`, `20-modularity.md`, `30-api-contracts.md`, `40-data-and-liquibase.md`, `50-security-and-logging.md`, `60-session-protocol.md`, `90-definition-of-done.md`).
2. **`ctam-architecture/agent-rules/enforcement/`** — fourteen files: two ArchUnit fitness classes, two Checkstyle configs, the Gradle quality script, the Spectral ruleset, three shell scripts, the target-repo `CLAUDE.md` template, hook registration, two hooks, and the rule → enforcer map.
3. **`conventions.md`** — *Test conventions* coverage bullet amended per §2.1; *Enforcement Guidelines* and *Pattern enforcement mechanisms* gain the agent-rules pack, the JaCoCo floor and the PIT threshold.
4. **`project-context.md`** — *Testing* and *Workflow & enforcement* updated to match, with a pointer to the pack.
5. **`architecture.md`** — a "Published to the context bus" pointer to `agent-rules/`.
6. **`gaps.md`** — **G1.4c** and **G6.7** added.
7. **`changelog.md`** — **v4.2** entry.
8. **This SCP**, plus its `build_html.py` NAV entry; **`docs/` regenerated**.

**Not applied, deliberately:** no FR/NFR change; no epic, story or `dispatch-graph.yaml` change; no ledger status change; no PRD decision; no shard mirrored into `planning-artifacts/` (that would be the copy this model exists to avoid); no UI or infrastructure rules; no `arch-v1.0` tag — publishing the architecture set to the bus and tagging it remains bootstrap step 1, and is a prerequisite before any service repo can pin these rules.

---

## Section 4 — Change Scope Summary

| Artifact | Change |
|---|---|
| `ctam-architecture/agent-rules/` (9 files) | **New** — the how-we-work contract: R (core), T (tests), M (modularity), C (contracts), P (persistence), S (security), W (workflow), Q (done) |
| `ctam-architecture/agent-rules/enforcement/` (14 files) | **New** — runnable enforcement + rule → enforcer map + validation-status table |
| [`architecture/conventions.md`](./architecture/conventions.md) | *Test conventions* coverage bullet **amended** (§2.1); *Enforcement Guidelines* + *Pattern enforcement mechanisms* extended |
| [`architecture/gaps.md`](./architecture/gaps.md) | **G1.4c**, **G6.7** added |
| [`architecture/changelog.md`](./architecture/changelog.md) | **v4.2** entry added |
| [`architecture.md`](./architecture.md) | Context-bus pointer to `agent-rules/` |
| `_bmad-output/project-context.md` | *Testing* + *Workflow & enforcement* updated; pointer to the pack |
| **This SCP** | New |
| Tooling — `scripts/python/build_html.py` | NAV gains this SCP |
| **`docs/`** | **Regenerated** — never hand-edited |
| **Unchanged** | `prd.md`, `business-case.md`, `epics/`, `delivery/` (graph + ledger), `repo-structure.md`, `repository-strategy.md`, `starter-template.md`, FR/NFR coverage, `assumptions.md`, dated reports |

**Handoff:** the pack is drafted, not proven. Two things gate its first real use — (1) publish the architecture set to `ctam-architecture` and tag `arch-v1.0`, per bootstrap step 1; (2) the first scaffolding story compiles and runs the enforcement pack, fixes the API drift its validation-status table anticipates, and reports every correction back to the bus. An infrastructure rules pack is recommended before Epic 0.0 dispatch (§2.5).
