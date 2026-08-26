---
type: 'Sprint Change Proposal'
description: '4 Sprint Change Proposals from 2026-08-19, consolidated into one file per day. Date: 2026-08-19 — Adds a binding "how we work" contract for the twelve Java execution units: evidence-based TDD, hard modularity limits, a cite-or-ask uncertainty protocol, and a single pre-handoff quality gate. Authored in ctam-architecture (the context bus) as agent-rules/, with a matching enforcement pack. Amends one existing convention: the behaviour-coverage stance now carries a JaCoCo floor and a PIT mutation threshold. No FR, NFR, epic, story or sequencing change.'
resource: 'sprint-change-proposal-2026-08-19.html'
tags: [ctam-pathfinder, sprint-change-proposal]
timestamp: '2026-08-19'
title: 'Sprint Change Proposal — 2026-08-19'
---

# Sprint Change Proposal — 2026-08-19

This file consolidates **4 Sprint Change Proposals** made on **2026-08-19** into one file (previously separate files: `sprint-change-proposal-2026-08-19.md#sprint-change-proposal-2026-08-19`, `sprint-change-proposal-2026-08-19.md#sprint-change-proposal-2026-08-19b`, `sprint-change-proposal-2026-08-19.md#sprint-change-proposal-2026-08-19c`, `sprint-change-proposal-2026-08-19.md#sprint-change-proposal-2026-08-19d`). Each entry below is preserved verbatim from its original file — only frontmatter, heading levels, and the file boundary changed.

## Index

- [Sprint Change Proposal — 2026-08-19](#sprint-change-proposal-2026-08-19)  — Agent delivery rules adopted; test gates amended (TDD evidence, coverage floor, mutation threshold)
- [Sprint Change Proposal — 2026-08-19b](#sprint-change-proposal-2026-08-19b)  — story-packet schema reconciled with the BMad story template; dispatch chain corrected
- [Sprint Change Proposal — 2026-08-19c](#sprint-change-proposal-2026-08-19c)  — the human gate moves from every commit to the pull request
- [Sprint Change Proposal — 2026-08-19d](#sprint-change-proposal-2026-08-19d)  — bespoke delivery tracking retired in favour of BMad sprint status; dispatch graph retired; arch-baseline promoted to Epic 0.6

---

## Sprint Change Proposal — 2026-08-19

*Agent delivery rules adopted; test gates amended (TDD evidence, coverage floor, mutation threshold)*

**Agent delivery rules adopted; test gates amended**

---

### Section 1 — Issue Summary

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

### Section 2 — Impact Analysis

#### 2.1 The one genuine conflict — the coverage stance

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

#### 2.2 Additive — no conflict

| Area | Addition |
|---|---|
| **TDD discipline** | Evidence-based red-green loop (T1–T4), the test taxonomy and when each level is appropriate (T7–T9), test-quality rules (T10–T15). `conventions.md`'s test-type naming (`*Test` / `*IT`) and the Testcontainers/Pact/E2E layers are referenced, not restated |
| **Modularity** | Numeric limits (M1–M8, M23) and layering, injection, time and naming rules (M9–M22). Consistent with the fixed package layout in `conventions.md` → *Structure Patterns*; adds the dependency direction between those packages, which was previously implicit |
| **Uncertainty protocol** | Cite-or-ask (R4), stop-on-unknown (R5), no unsanctioned surface (R6), no memory-asserted APIs (R7), nothing unfinished ships (R8) |
| **Session protocol** | Read order, the plan-before-edit step, `_arch/` read-only, repo boundaries, handoff format, `in-review` never `done` (W1–W13) |
| **Definition of done** | A single gate command and a 13-item checklist, each item evidenced (Q1–Q13) |
| **Enforcement pack** | ArchUnit fitness functions, Checkstyle config + the only sanctioned suppressions, Gradle wiring, Spectral ruleset, `verify.sh` / `red.sh` / `forbidden-patterns.sh`, target-repo `CLAUDE.md` template, hook registration, and two hooks |

The scaffolding overlay in `starter-template.md` §B already listed **Spectral · ArchUnit · Spotless · Checkstyle** as CTAM conventions to be added by `ctam-scaffold.sh` (G1.4a). This SCP supplies the actual configurations those entries anticipated, and adds PIT.

#### 2.3 Two defects found in the canonical docs while authoring

Recorded as gaps rather than silently resolved — the same cite-or-ask discipline the rules impose:

- **G6.7 — contradictory status code for optimistic-lock failure.** `conventions.md` → *Process Patterns* maps `OptimisticLockingFailureException` to **409**; `conventions.md` → *Communication Patterns* ("Retry safety and concurrency control") says optimistic locking for lost-update returns **412**. Both are current text. Until resolved, the rules make an optimistic-lock path an explicit stop-and-ask rather than picking one.
- **G1.4c — quality-gate tool versions unproven on the target toolchain.** Versions were verified as released (Checkstyle 14.0.0, Spotless 8.10.0, JaCoCo 0.8.14 — first with official Java 25 support, ArchUnit 1.5.0, gradle-pitest 1.19.0, pitest 1.25.9, pitest-junit5 1.2.3) but **nothing in the enforcement pack has been compiled or executed**, because the control-plane workspace holds no Java build. PIT running *on* a Java 25 toolchain against Spring Boot 4 is the specific unknown. The pack states its own validation status per file, and the first scaffolding story owns making it run and reporting corrections back to the bus.

#### 2.4 Enforcement honesty

Two limits are stated in the pack rather than papered over:

- **`require-red-test.sh` is a guardrail, not a proof.** It refuses `src/main/**` edits unless a recent failing test run was recorded by `scripts/red.sh`. It raises the cost of skipping TDD; it cannot verify the failing test was the *right* test. The real evidence is the pasted red/green output, reviewed by a human.
- **Rules with no automated enforcer are listed as such.** `enforcement/README.md` maps every rule id to its enforcer and marks *review only* explicitly, with the four worth mechanising next (the `/v1` append-only check, the authorisation-per-endpoint rule, changeset immutability, and AC → test mapping). A soft spot recorded is a soft spot that can be closed.

#### 2.5 What is not covered

`ctam-ui` / `ctam-admin-ui` (React/TypeScript) and `ctam-shared-infrastructure` (Terraform/Helm) have **no language-specific rules or enforcers**. The core rules R1–R14 still govern conduct in those repos. This matters for sequencing: `ctam-shared-infrastructure` is the phase-0 repo built **first** and is not Java, so its stories run without an enforcement pack. Recommended follow-up: an infrastructure pack before Epic 0.0 dispatch, then a UI pack before the Epic 0.ui-shell work.

---

### Section 3 — Recommended Path Forward

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

### Section 4 — Change Scope Summary

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

---

## Sprint Change Proposal — 2026-08-19b

*story-packet schema reconciled with the BMad story template; dispatch chain corrected*

**Story-packet schema reconciled with the BMad story template; dispatch chain corrected**

---

### Section 1 — Issue Summary

**Trigger:** The first dispatched story packet (`pilot-0.5.1`, the delivery-method pilot) did not match BMad's story template. The executing session found it had no `## Tasks / Subtasks` to work through and no `## Dev Agent Record` or `### File List` to write into — `bmad-dev-story` reads and writes those by exact heading.

**Root cause is a contradiction inside a single file, not an authoring slip.** [`architecture/delivery-operating-model.md`](./architecture/delivery-operating-model.md) contained both:

- a skills table mapping **"1 · Dispatch → `bmad-create-story`"**, and
- three lines later, a **"Story packet schema"** specifying a bespoke layout — YAML frontmatter, `status: dispatched`, `## Context (distilled…)`, `## Acceptance criteria (Gherkin…)`, `## Out of scope / boundaries`, `## Definition of done` — none of which `bmad-create-story` emits.

The packet was authored to the schema, as the shard instructed. Both instructions were followed as written; they cannot both be satisfied.

**Second, deeper cause — the BMad chain had never been started.** `bmad-create-story`'s workflow refuses to run without `{implementation_artifacts}/sprint-status.yaml` and emits *"Run sprint-planning workflow first to create sprint-status.yaml"*. That file does not exist, because **`bmad-sprint-planning` has never been run**. So at the dispatch step there was no runnable skill to invoke, and the shard's schema was the only usable instruction. The contradiction and the missing prerequisite compounded.

**What should have happened regardless:** the conflict should have been raised as a stop-and-ask rather than silently resolved in favour of one half — exactly what `agent-rules` **R5** requires. Recorded as such.

---

### Section 2 — Impact Analysis

#### 2.1 Blast radius

**Contained.** One packet, in a pilot repo, uncommitted at the time of discovery. No epic, story, FR/NFR or ledger entry was affected. Had this reached real delivery, every packet for phases 0–8 would have carried the same defect, and every `bmad-dev-story` run would have had nowhere to record its work — so the cost of finding it now is one file rewrite instead of a programme-wide re-issue.

#### 2.2 Why both schemas exist, and what each holds

Neither is redundant, which is why the fix is a reconciliation rather than a winner:

| Concern | Owner | Why |
|---|---|---|
| `Status:`, `## Story`, `## Acceptance Criteria`, `## Tasks / Subtasks`, `## Dev Notes`, `## Dev Agent Record`, `### File List` | **BMad template** | `bmad-dev-story` reads and writes them by exact heading |
| `bus_version`, `repo`, `epic`, `frs`, `nfrs`, `depends_on_stories`, `ledger`, recorded deviations | **CTAM operating model** | Polyrepo facts BMad does not model: which repo, which pinned bus version, which requirements, which ledger shard |
| Packet location `docs/stories/<id>.md` **in the target repo** | **CTAM operating model** | BMad defaults to `{implementation_artifacts}` in the control plane, which assumes a monorepo. A service repo must be independently readable by a fresh session with none of the control plane's context |
| Status vocabulary | **BMad** (`ready-for-dev | in-progress | review | done`) | Two statuses in two vocabularies was itself a defect. The ledger keeps its own vocabulary because it tracks programme progress, a different thing |

#### 2.3 A related duplication, not yet resolved

The same pattern appears once more: CTAM's `delivery/ledger/` (per-epic shards with `status` + `owner`, authored 2026-07-07) duplicates what BMad's `sprint-status.yaml` tracks. Two status stores, no stated precedence. This SCP does **not** resolve it — it records it as a decision required before the next real story is dispatched (pilot finding **F13**). The recommended direction is that BMad state owns the story lifecycle and the ledger keeps only what BMad does not model (bus version per repo, PR link, FR/NFR mapping), but that is a decision, not an inference.

---

### Section 3 — Recommended Path Forward

Prose alone caused this, so the fix is executable at three of its four layers.

**Applied:**

1. **Canonical template on the bus** — `ctam-architecture/agent-rules/templates/story-packet.md`. BMad's template with CTAM frontmatter and CTAM detail nested under `## Dev Notes`. Versioned with the bus, so every repo gets the same one and a bump is auditable.
2. **Committed BMad customization** — `_bmad/custom/bmad-create-story.toml`, using BMad's own team-customization layer (`activation_steps_append` + `persistent_facts`) to point the skill at the canonical template, at the target-repo output location, and at the validator. `.gitignore` gained a scoped negation (`!_bmad/custom/`) so the team layer is tracked while the installer's files stay ignored — `_bmad/config.toml` itself designates `_bmad/custom/` as committed.
3. **Deterministic validator** — `scripts/validate-story-packet.sh` fails on a missing BMad section, a CTAM section promoted to top level, a missing frontmatter key, a duplicate `status:`, an out-of-vocabulary `Status:`, unnumbered ACs, or absent task checkboxes. Run against the offending packet it reported **18 errors**; the regenerated packet and the template both pass.
4. **The contradiction removed** — `delivery-operating-model.md`'s *Story packet schema* section rewritten as the three-rule contract, with the sprint-planning prerequisite stated explicitly so the next person does not hit the same dead end.
5. **The pilot packet regenerated** in the conforming shape, ACs and deviations preserved, plus the tasks/subtasks and Dev Agent Record scaffolding `bmad-dev-story` needs.

**Not applied — requires a decision:**

- **Run `bmad-sprint-planning`** to create `sprint-status.yaml` and unblock `bmad-create-story` for every real story. This is the remaining half of the root cause: without it, dispatch still has no runnable skill. It also forces the `delivery/ledger/` vs `sprint-status.yaml` precedence decision in §2.3, because sprint planning will create the competing artefact.

---

### Section 4 — Change Scope Summary

| Artifact | Change |
|---|---|
| [`architecture/delivery-operating-model.md`](./architecture/delivery-operating-model.md) | *Story packet schema* section **rewritten** — three-rule contract, canonical template pointer, enforcement pointers, sprint-planning prerequisite |
| `ctam-architecture/agent-rules/templates/story-packet.md` | **New** — canonical packet template on the bus |
| `_bmad/custom/bmad-create-story.toml` | **New** — committed team customization pointing the skill at the template, location and validator |
| `.gitignore` | Scoped negation `!_bmad/custom/` so the team customization layer is tracked |
| `scripts/validate-story-packet.sh` | **New** — deterministic packet validator |
| `ctam-notification/docs/stories/pilot-0.5.1.md` | **Regenerated** in the conforming shape |
| [`delivery/pilots/pilot-0.5-findings.md`](./delivery/pilots/pilot-0.5-findings.md) | **F10–F14 added** |
| [`architecture/changelog.md`](./architecture/changelog.md) | **v4.3** entry |
| **This SCP** | New |
| Tooling — `scripts/python/build_html.py` | NAV gains this SCP |
| **`docs/`** | **Regenerated** |
| **Unchanged** | `prd.md`, `epics/` (including Epic 0.5), `delivery/ledger/`, `dispatch-graph.yaml`, `conventions.md`, all FR/NFR coverage |

**Handoff:** the dispatch chain is correct for packet *shape*; it is still not runnable end-to-end until `bmad-sprint-planning` has produced `sprint-status.yaml` and the ledger-versus-sprint-status precedence is decided. Both are named in the pilot findings and neither should be inferred.

---

## Sprint Change Proposal — 2026-08-19c

*the human gate moves from every commit to the pull request*

**The human gate moves from every commit to the pull request**

---

### Section 1 — Issue Summary

**Trigger:** product-owner decision (Ramnish, 2026-08-19). The original constraint — Claude performs *no* version-control operations, the human commits externally from VSCode — made every commit a manual handoff. In an AI-led delivery model that produces a large uncommitted working tree, reviewed as a single lump, with the red-green sequence invisible.

**Decision:** an agent owns its branch; a human owns `main`. The **pull request** is the review gate, enforced by server-side branch protection as well as by the hook.

| Operation | Before | After |
|---|---|---|
| Branch, stage, commit | denied | **allowed** on a feature branch |
| Push | denied | **allowed** to a non-protected branch |
| Commit / merge / rebase / push / pull while HEAD is `main` | denied | **denied** |
| Push targeting a protected branch, any spelling | denied | **denied** |
| Force-push, `--mirror`, `+refspec` | denied | **denied** |
| Branch delete or rename, `push --delete`, `push :branch` | denied | **denied** |
| Tags, `push --tags` | denied | **denied** |
| `reset --hard`, `clean`, `rm`, `restore`, `checkout -- <path>`, `stash drop`/`clear` | denied | **denied** |
| GitHub CLI (`gh`, `hub`) | denied | **denied** |

---

### Section 2 — Impact Analysis

#### 2.1 Why this is still a real gate — and a better one

- **The review boundary is unchanged.** Nothing reaches `main` without a human reading a diff. What changed is *where*: a pull request with commit-by-commit history, rather than an uncommitted working tree in an editor.
- **The history becomes evidence.** Red-green cycles committed as they happen are reviewable. That matters more in AI-led delivery than in hand-written code, because the *sequence* is what a reviewer must inspect to believe a TDD claim (**R2**).
- **Enforcement moves to the mechanism built for it** — branch protection and CODEOWNERS — instead of a convention every agent must remember.
- **Tags stay human** because `arch-vN` is consumed by pinned submodules across the polyrepo: a stray tag silently changes what every downstream repo can adopt.
- **Work-discarding operations stay denied** because uncommitted changes may be the only copy of something.
- **The GitHub CLI stays denied** because opening, approving and merging a pull request *is* the gate, and a text-matching hook cannot safely distinguish creating a PR from merging one with admin override. It also keeps pilot finding **F1** closed — the HMCTS template's own `setup-new-repo.sh` makes a repository **public**, which contradicts the standing rule that CTAM repositories are private.

#### 2.2 Implementation and verification

`.claude/hooks/block-git-writes.sh` was rewritten. The filename was **retained deliberately** so that no `settings.json` in any repo needs changing and no session loses its guard mid-run.

Two defects were found by testing rather than by reading, both worth recording:

1. **Unborn-branch detection.** The first implementation resolved the current branch with `rev-parse --abbrev-ref HEAD`, which *fails* in a repository with no commits. `ctam-notification` is exactly that repository — so main protection was silently off in the one situation where a first commit would land on `main`. Fixed by trying `symbolic-ref --quiet --short HEAD` first.
2. **Documentation trips the guard.** The pattern treated a backtick as a command separator, so prose mentioning a blocked command in inline code read as an invocation of it. Writing this SCP was itself blocked by the hook it describes. Command positions are now start-of-line, after a separator, or inside `$( )` / a subshell — a backtick is no longer one.

A **known limit is accepted and documented in the hook**: it matches text, so a blocked command appearing as *data* at a command position (a here-doc line, a test fixture) is still denied. The alternative — ignoring quoted spans — would let a blocked command through inside `sh -c "…"`, which is worse. The workaround is to write such files with an editor tool rather than a here-doc.

Verified against a **46-case matrix** in two contexts: HEAD on a feature branch (39/39), plus 7 cases covering subshells, separators and documentation-in-backticks. On `main` in a repo with no commits, `commit`, `push`, `merge` and `pull` are denied while `status`, `add`, `switch -c` and `stash push` are allowed. All three copies of the hook are byte-identical (verified by checksum). The protected set is overridable per environment via `CTAM_PROTECTED_BRANCHES`.

#### 2.3 Standing personal instruction that now conflicts

The user's **global** `~/.claude/CLAUDE.md` still states *"DO NOT PERFORM ANY GITHUB OPERATIONS from within Claude sessions — GitHub commits will be handled externally using VSCode after reviewing the work."* That file governs every project on the machine and was **not** edited by this change, deliberately: narrowing a personal, cross-project instruction is the user's call, not a programme decision. Until it is updated, a session that reads it will be told the opposite of this SCP, and a global instruction outranks a project one.

**Recommended:** amend the global rule to reference branch-protection semantics, or scope it explicitly to non-CTAM projects.

---

### Section 3 — Recommended Path Forward

**Applied:**

1. `.claude/hooks/block-git-writes.sh` rewritten in `ctam-analysis`, and copied byte-identically to the bus (`agent-rules/enforcement/claude/hooks/`) and to `ctam-notification`.
2. **R13** rewritten in `agent-rules/00-core.md` and in the target-repo `CLAUDE.md.template`; stop conditions updated in both.
3. **W7** in `agent-rules/60-session-protocol.md` rewritten as *"the pull request is the human gate"*, with the branch → commit → push → hand-back sequence; the loop's handoff step updated to match.
4. `agent-rules/enforcement/README.md` rule→enforcer rows for R13 and W7 updated.
5. `CLAUDE.md` (repo root), `_bmad-output/project-context.md`, and `architecture/delivery-operating-model.md` → *Human gates and the branch-protection constraint* rewritten with the rationale.
6. `ctam-notification`: `CLAUDE.md` regenerated from the updated template, README's contributing section updated, and the pilot packet's Task 8 now ends with branch → commit → push → surface the compare URL.
7. Housekeeping in the same pass, now that the tag exists: the pilot packet's `bus_version` set to `arch-v1.0` and deviation **D-8** removed.

**Not applied:** the user's global `~/.claude/CLAUDE.md` (§2.3) — flagged for the user to decide.

---

### Section 4 — Change Scope Summary

| Artifact | Change |
|---|---|
| `.claude/hooks/block-git-writes.sh` (all three repos) | **Rewritten** — protected-branch policy, unborn-branch-safe detection, command-position boundaries, `CTAM_PROTECTED_BRANCHES` override |
| `agent-rules/00-core.md` | **R13** rewritten; stop conditions updated |
| `agent-rules/60-session-protocol.md` | **W7** rewritten |
| `agent-rules/enforcement/claude/CLAUDE.md.template` | R13, loop step 8, stop conditions, closing note |
| `agent-rules/enforcement/README.md` | R13 / W7 enforcer rows |
| [`architecture/delivery-operating-model.md`](./architecture/delivery-operating-model.md) | *Human gates* section rewritten |
| `CLAUDE.md` (repo root) · `_bmad-output/project-context.md` | Hard rule and delivery-discipline bullets |
| `ctam-notification` | `CLAUDE.md` regenerated · README · packet Task 8 · packet `bus_version` + D-8 removal |
| [`architecture/changelog.md`](./architecture/changelog.md) | **v4.4** entry |
| **This SCP** | New |
| **`docs/`** | Regenerated |
| **Unchanged** | `prd.md`, `epics/`, `delivery/ledger/`, `dispatch-graph.yaml`, `conventions.md` → *Git conventions* (branch naming and Conventional Commits were already correct), FR/NFR coverage |

**Handoff:** the policy is live in all three repos. The one open item is the global personal instruction in §2.3.

---

## Sprint Change Proposal — 2026-08-19d

*bespoke delivery tracking retired in favour of BMad sprint status; dispatch graph retired; arch-baseline promoted to Epic 0.6*

**Bespoke delivery tracking retired in favour of BMad's own; dispatch graph retired; `arch-baseline` promoted to Epic 0.6**

---

### Section 1 — Issue Summary

**Trigger:** product-owner decision (Ramnish, 2026-08-19) — *"align with the BMad process better rather than adding the additional layer of ledger."*

The control plane had accumulated two bespoke artefacts that duplicated or pre-empted BMad's own:

- **`delivery/ledger/`** — six per-epic YAML shards carrying `status`, `owner`, `pr`, `repo`, `frs` and `bus_version` per story, sharded specifically so that multiple people could update different epics without git conflicts.
- **`delivery/dispatch-graph.yaml`** — an epic-level build-order graph.

**Two findings settled it.** First, `bmad-sprint-planning` had **never been run**, so `sprint-status.yaml` did not exist — and `bmad-create-story` refuses to run without it. The BMad chain was never started, which is why bespoke substitutes grew in its place. Second, **at the point of retirement every ledger entry still read `not-started` / `owner: null` / `pr: null`** — 25 status entries, 25 owners, 19 PR fields, all empty. The ledger was tracking nothing.

**On the dispatch graph:** of its nine fields, five duplicated something else (`title`, `stories`, `phase`, `decomposed` from the epic files; `bus_version` from the tag and each repo's submodule pin — a second claim on the same fact, so a drift risk rather than a convenience). **No BMad skill read it**; `bmad-sprint-planning` parses epic files only. The operating model's claim that *"sprint planning reads dispatch-graph.yaml → next buildable stories"* was never true. Only `repo:` and `depends_on:` were genuinely unique — and both are properties of the epic.

---

### Section 2 — Impact Analysis

#### 2.1 Multi-user coordination: what replaces the ledger's `owner`

The ledger's sharding and `owner` field existed to solve one problem — two people picking up the same work. Options were reviewed (branch-as-claim, GitHub Issues, editing the single BMad file, packet-as-truth with a generated board, one-file-per-claim, one dispatcher). The decision:

**One dispatcher at a time, by convention, with a branch-existence check as the backstop.**

- `sprint-status.yaml` is a single file, so concurrent dispatch would conflict on it. Dispatch is a small fraction of total effort, so serialising it costs little.
- **A branch on the target remote is the claim.** No shared field to contend over, and it is where the work actually is.
- `scripts/dispatch-preflight.sh <story-id>` — new, read-only — checks all three preconditions: the story is still `backlog`; no branch on the target remote names it; the epic's `depends_on` are all `done`. Verified against stories that should pass, stories blocked by prerequisites, epics spanning three repos, and a story already `done`.
- **Execution parallelises freely**, because it happens in different service repos where branches and PRs already show who is doing what.

#### 2.2 A contradiction that disappears

The ledger had its own status vocabulary (`not-started → dispatched → in-progress → in-review → done`) alongside BMad's (`backlog → ready-for-dev → in-progress → review → done`). That mismatch was a recorded wart — `review` versus `in-review` — and the reason agent-rules W13 needed a two-row translation table. **Retiring the ledger collapses the two vocabularies into one.** W13's table becomes a statement of who sets what, `90-definition-of-done.md` Q13 simplifies, and the story-packet template drops its warning about mirroring a second vocabulary.

#### 2.3 Where the ledger's other fields went

| Ledger field | New home |
|---|---|
| `status` | `implementation-artifacts/sprint-status.yaml` (generated by `bmad-sprint-planning`) |
| `repo` | the **epic's frontmatter** (`repo:`), and the packet's `repo:` |
| `frs` / `bus_version` | the **packet's frontmatter** — produced by the service repo that holds the pin |
| `pr` | the PR itself, and the packet's *Dev Agent Record* |
| `owner` | **the branch** on the target remote |

**One capability is genuinely traded away:** reverse lookups (*which stories cover FR6? which repos are on which bus version?*) become a **generated** report over packet frontmatter rather than an always-available table. Deferred deliberately — there are no packets yet to scan. This is the same producer-owned / read-only-mirror principle already used for API contracts.

#### 2.4 `arch-baseline` promoted to Epic 0.6

The graph held one node, `arch-baseline` (`decomposed: false`), covering the context-bus publish plus the shared `ctam_configuration_values` Liquibase baseline (FR8). Because it was a graph node rather than an epic, **it was invisible to every BMad skill** — no sprint-status entry, no stories, not dispatchable.

It is now **Epic 0.6**, with two stories: 0.6.1 (publish the bus and tag `arch-v1.0`) and 0.6.2 (the shared baseline with per-service `SELECT` grants). Story 0.6.1 is recorded **`done`** — the bus is published and `arch-v1.0` is tagged — and the epic is `in-progress`. Phase 0 is now **7 epics, 21 stories**.

**Why 0.6 and not an insertion at 0.0a:** renumbering the authored epics 0.1–0.5 would break every FR mapping and cross-reference for no benefit. **The number is not the order** — sequence comes from `depends_on`, and the epic says so at the top. One honest wrinkle recorded in the epic: `depends_on` is epic-level, but only story 0.6.2 needs Epic 0.0's PostgreSQL, so the pre-flight check will flag Epic 0.0 as a blocker for 0.6.1 even though that story is complete.

#### 2.5 Phases 1–8

The graph's `future:` block held repo-level placeholders and dependency edges for phases 1–8. The repo names duplicated `repository-strategy.md`; only the edges were unique, and they describe undecomposed work. They are folded into `epics/framework.md` → **Phase dependency order** as a table, with the parallelism worth knowing called out (Phase 5 branches off Phase 1 independently of 3 and 4). Each phase gains structured frontmatter when `bmad-create-epics-and-stories` runs for it.

---

### Section 3 — Recommended Path Forward

**Applied:**

1. **`bmad-sprint-planning` run** — `implementation-artifacts/sprint-status.yaml` generated from the epics: 7 epics, 21 stories, 7 retrospectives, 35 entries. Validated for legal statuses and duplicate keys. Its header records two polyrepo caveats: packets live in target repos so BMad's file-existence detection cannot upgrade statuses here, and the packet's `Status:` line is authoritative for a story in flight.
2. **Ledger deleted** — six shards + its README.
3. **`dispatch-graph.yaml` deleted.**
4. **`repo:` + `depends_on:` added to all seven phase-0 epics' frontmatter**, lifted verbatim from the graph (with `arch-baseline` rewritten to `epic-0.6`).
5. **Epic 0.6 authored**, added to `phase-0/index.md` (table, summary, stories summary) and named in `framework.md`'s Platform & DevEx area.
6. **`framework.md`** gains the *Phase dependency order* table.
7. **`scripts/dispatch-preflight.sh`** added; reads epic frontmatter and `sprint-status.yaml`.
8. **`scripts/validate-story-packet.sh`** — required key `ledger` → `sprint_status_key`.
9. **`_bmad/custom/bmad-create-story.toml`** — resolves the target repo from the epic's frontmatter, populates `sprint_status_key`, and runs the pre-flight check before writing a packet.
10. **`delivery/README.md` rewritten**; `architecture/delivery-operating-model.md` — Decision 2 rewritten, the ledger section replaced, control-plane row, flow diagram, skills table, packet schema, bootstrapping order all updated.
11. **`CLAUDE.md`, `README.md`, `build_html.py` NAV** updated; Epic 0.6 added to the nav.
12. **Bus (`agent-rules`)** — packet template (`sprint_status_key`), `00-core.md` (loop step 8, R14), `60-session-protocol.md` (W12 fields, W13 one vocabulary), `90-definition-of-done.md` (Q12, Q13), `enforcement/README.md`. Architecture mirror republished.

**Not applied:** the FR/NFR coverage report (§2.3) — deferred until packets exist.

---

### Section 4 — Change Scope Summary

| Artifact | Change |
|---|---|
| `delivery/ledger/` (7 files) | **Deleted** — held no state; every entry was `not-started` / null |
| `delivery/dispatch-graph.yaml` | **Deleted** — 5 of 9 fields duplicated; no BMad skill read it |
| `implementation-artifacts/sprint-status.yaml` | **New** — generated; 7 epics, 21 stories, 35 entries |
| `epics/phase-0/epic-0.6-context-bus-and-shared-baseline.md` | **New** — `arch-baseline` promoted; 2 stories, 0.6.1 `done` |
| `epics/phase-0/epic-0.{0,1,2,3,4,5}-*.md` | **`repo:` + `depends_on:` frontmatter added** — no body content changed |
| [`epics/phase-0/index.md`](./epics/phase-0/index.md) | Epic 0.6 row, summary, stories-summary row; total 19 → 21 stories |
| [`epics/framework.md`](./epics/framework.md) | *Phase dependency order* table; Epic 0.6 named in Platform & DevEx |
| [`delivery/README.md`](./delivery/README.md) | **Rewritten** around BMad artefacts and one-dispatcher coordination |
| [`architecture/delivery-operating-model.md`](./architecture/delivery-operating-model.md) | Decision 2 rewritten; ledger section replaced; control-plane row, flow, skills table, packet schema, bootstrapping order |
| `scripts/dispatch-preflight.sh` | **New** |
| `scripts/validate-story-packet.sh` · `_bmad/custom/bmad-create-story.toml` | `ledger` → `sprint_status_key`; epic-frontmatter repo resolution; pre-flight step |
| `CLAUDE.md` · `README.md` · `scripts/python/build_html.py` | Updated; Epic 0.6 in the nav |
| `agent-rules/` (5 files, bus) | Packet template, R14, loop step 8, W12, W13, Q12, Q13, enforcer map |
| [`architecture/changelog.md`](./architecture/changelog.md) | **v4.5** entry |
| **This SCP** | New |
| **`docs/`** | Regenerated |
| **Unchanged** | `prd.md`, `business-case.md`, every epic **body**, all FR/NFR coverage, `conventions.md`, `repository-strategy.md`, `gaps.md`, `assumptions.md` |

**Handoff:** the bus edits need an **`arch-v1.1`** tag before any service repo can adopt them, and `ctam-architecture` currently has these plus earlier changes uncommitted on `main` — which the revised git policy correctly refuses, so they need a branch and a PR. Next delivery action is unchanged: Epic 0.0, story 0.0.1, via `scripts/dispatch-preflight.sh 0.0.1` then `bmad-create-story`.
