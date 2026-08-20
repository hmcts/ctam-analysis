---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — story-packet schema reconciled with the BMad story template; dispatch chain corrected'
description: 'Date: 2026-08-19 — delivery-operating-model.md specified a bespoke story-packet layout while mapping dispatch to bmad-create-story, two incompatible instructions in one file. The packet is now defined as BMad template + CTAM polyrepo fields, with a canonical template on the bus, a committed BMad customization, and a validator. Also records that bmad-create-story cannot run without sprint-status.yaml, which bmad-sprint-planning was never run to produce.'
resource: 'sprint-change-proposal-2026-08-19b.html'
tags: [ctam-pathfinder, sprint-change, delivery, bmad, story-packet]
timestamp: '2026-08-19'
parent: 'planning-artifacts/index.md'
project: 'ctam-analysis (CTAM Pathfinder)'
change_scope: 'Minor — delivery-contract correction (documentation + tooling; implementation not started)'
mode: 'Batch'
architectureVersion: 'v4.3'
last_updated: 2026-08-19
---

# Sprint Change Proposal — 2026-08-19b

**Story-packet schema reconciled with the BMad story template; dispatch chain corrected**

---

## Section 1 — Issue Summary

**Trigger:** The first dispatched story packet (`pilot-0.5.1`, the delivery-method pilot) did not match BMad's story template. The executing session found it had no `## Tasks / Subtasks` to work through and no `## Dev Agent Record` or `### File List` to write into — `bmad-dev-story` reads and writes those by exact heading.

**Root cause is a contradiction inside a single file, not an authoring slip.** [`architecture/delivery-operating-model.md`](./architecture/delivery-operating-model.md) contained both:

- a skills table mapping **"1 · Dispatch → `bmad-create-story`"**, and
- three lines later, a **"Story packet schema"** specifying a bespoke layout — YAML frontmatter, `status: dispatched`, `## Context (distilled…)`, `## Acceptance criteria (Gherkin…)`, `## Out of scope / boundaries`, `## Definition of done` — none of which `bmad-create-story` emits.

The packet was authored to the schema, as the shard instructed. Both instructions were followed as written; they cannot both be satisfied.

**Second, deeper cause — the BMad chain had never been started.** `bmad-create-story`'s workflow refuses to run without `{implementation_artifacts}/sprint-status.yaml` and emits *"Run sprint-planning workflow first to create sprint-status.yaml"*. That file does not exist, because **`bmad-sprint-planning` has never been run**. So at the dispatch step there was no runnable skill to invoke, and the shard's schema was the only usable instruction. The contradiction and the missing prerequisite compounded.

**What should have happened regardless:** the conflict should have been raised as a stop-and-ask rather than silently resolved in favour of one half — exactly what `agent-rules` **R5** requires. Recorded as such.

---

## Section 2 — Impact Analysis

### 2.1 Blast radius

**Contained.** One packet, in a pilot repo, uncommitted at the time of discovery. No epic, story, FR/NFR or ledger entry was affected. Had this reached real delivery, every packet for phases 0–8 would have carried the same defect, and every `bmad-dev-story` run would have had nowhere to record its work — so the cost of finding it now is one file rewrite instead of a programme-wide re-issue.

### 2.2 Why both schemas exist, and what each holds

Neither is redundant, which is why the fix is a reconciliation rather than a winner:

| Concern | Owner | Why |
|---|---|---|
| `Status:`, `## Story`, `## Acceptance Criteria`, `## Tasks / Subtasks`, `## Dev Notes`, `## Dev Agent Record`, `### File List` | **BMad template** | `bmad-dev-story` reads and writes them by exact heading |
| `bus_version`, `repo`, `epic`, `frs`, `nfrs`, `depends_on_stories`, `ledger`, recorded deviations | **CTAM operating model** | Polyrepo facts BMad does not model: which repo, which pinned bus version, which requirements, which ledger shard |
| Packet location `docs/stories/<id>.md` **in the target repo** | **CTAM operating model** | BMad defaults to `{implementation_artifacts}` in the control plane, which assumes a monorepo. A service repo must be independently readable by a fresh session with none of the control plane's context |
| Status vocabulary | **BMad** (`ready-for-dev | in-progress | review | done`) | Two statuses in two vocabularies was itself a defect. The ledger keeps its own vocabulary because it tracks programme progress, a different thing |

### 2.3 A related duplication, not yet resolved

The same pattern appears once more: CTAM's `delivery/ledger/` (per-epic shards with `status` + `owner`, authored 2026-07-07) duplicates what BMad's `sprint-status.yaml` tracks. Two status stores, no stated precedence. This SCP does **not** resolve it — it records it as a decision required before the next real story is dispatched (pilot finding **F13**). The recommended direction is that BMad state owns the story lifecycle and the ledger keeps only what BMad does not model (bus version per repo, PR link, FR/NFR mapping), but that is a decision, not an inference.

---

## Section 3 — Recommended Path Forward

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

## Section 4 — Change Scope Summary

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
