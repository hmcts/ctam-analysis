---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — one branch per story, created at dispatch; story/{story-id} replaces feature/ for story work'
description: 'Date: 2026-08-20 — dispatch now creates story/{story-id} in the target repo, commits the story packet on it and pushes it, and the implementing session continues on that same branch through to the PR. Closes the window in which a dispatched story had no visible claim, and gives the pre-dispatch check a branch that actually exists. BMad performs no version-control operations of any kind, so this is a rules-layer behaviour.'
resource: 'sprint-change-proposal-2026-08-20.html'
tags: [ctam-pathfinder, sprint-change, delivery, git, branching]
timestamp: '2026-08-20'
parent: 'planning-artifacts/index.md'
project: 'ctam-analysis (CTAM Pathfinder)'
change_scope: 'Minor — delivery-workflow convention (documentation + tooling)'
mode: 'Batch'
architectureVersion: 'v4.6'
last_updated: 2026-08-20
---

# Sprint Change Proposal — 2026-08-20

**One branch per story, created at dispatch**

---

## Section 1 — Issue Summary

**Trigger:** a question — *does BMad create a branch so the story is developed on a branch in the target repo?* It does not. Checked directly:

| Skill | Version-control behaviour |
|---|---|
| `bmad-sprint-planning` | none |
| `bmad-create-story` | none. Its only `git` references are **read-only history analysis**, mining past commits for context while writing the packet |
| `bmad-dev-story` | **zero** mentions of git, commit, branch or VCS |
| `bmad-code-review` | none |

BMad writes files and moves statuses. Branching was already a **rules-layer** behaviour — `agent-rules` W7 told the implementing session to cut a branch — which left a gap the pre-flight check could not cover.

**The gap.** `scripts/dispatch-preflight.sh` treats *a branch on the target remote* as the claim on a story (that is what replaced the retired ledger's `owner` field, SCP 2026-08-19d). But nothing created a branch until the implementing session started. So between dispatch and execution a story read `ready-for-dev` with **no visible claim**, and the packet existed only as an uncommitted file on the dispatcher's disk — lost if that person's machine or attention moved on.

**Decision (Ramnish, 2026-08-20):** dispatch creates the branch, and there is **one branch per story**, using the `story/{story-id}` name.

---

## Section 2 — Impact Analysis

### 2.1 What changes

Dispatch gains four steps in the target repo, after the packet is written and validated:

```bash
git switch main && git pull
git switch -c story/0.1.4
git add docs/stories/0.1.4.md
git commit -m "docs: land story packet 0.1.4"
git push -u origin story/0.1.4
```

**Pushing is the point.** The pre-flight check reads the *remote*, so an unpushed branch claims nothing.

The implementing session then **continues on that branch** and must not cut another. This is the substance of "one branch only": the branch is simultaneously the claim, the home of the packet, and the home of the work, from dispatch through to the PR a human opens.

### 2.2 A branch-naming convention is amended

`conventions.md` → *Git conventions* previously prescribed `feature/{ticket-id}-{short-description}` for all work. Story work now uses **`story/{story-id}`** — e.g. `story/0.1.4`. `bugfix/`, `chore/` and `feature/` remain for work that is not a dispatched story.

Two reasons for the rename rather than reusing `feature/`:

- **It carries the story id, which is what the claim check matches on.** A `feature/CTAM-123-mrd-ingestion` branch does not tell the pre-flight check which story it claims; `story/0.1.4` does, and the existing regex already matches it.
- **It says what the branch is.** One branch that holds a packet, its implementation and its review is not a generic feature branch, and naming it after the story makes the one-branch-per-story rule self-evident on the branch list.

### 2.3 What this does not change

The human gate is untouched: `main` stays protected, and opening, approving and merging the pull request remain the human's (SCP 2026-08-19c). An agent still cannot use the GitHub CLI, so it cannot open the PR — it reports the compare URL and stops.

Nor does this reintroduce anything the ledger did. There is still no `owner` field and no shared mutable state to contend over; the branch is the claim, and it now exists from the earliest moment it could.

### 2.4 Residual weakness, stated plainly

A branch is a *claim*, not a *lock*. Two people dispatching the same story within the same minute can both create it, and the second push simply fails or diverges. The mitigation remains the convention — **one dispatcher at a time** — with the pre-flight check as the backstop rather than a guarantee. That was accepted when the ledger was retired and is unchanged here.

---

## Section 3 — Recommended Path Forward

**Applied:**

1. **`_bmad/custom/bmad-create-story.toml`** — new `CTAM DISPATCH BRANCH` activation step spelling out the four commands, the push requirement, the one-branch rule and the prohibition on opening the PR. The seven activation steps were also **reordered into execution order** (pre-flight → packet contract → output location → frontmatter → context depth → validation gate → dispatch branch), and the file was verified to parse as TOML.
2. **`architecture/conventions.md`** → *Git conventions* — `story/{story-id}` for story work, with the claim rationale; `bugfix/` / `chore/` / `feature/` retained for other work.
3. **`agent-rules/60-session-protocol.md`** → **W7 step 1 inverted**: it no longer tells the session to create a branch. It says *you are already on `story/<id>`, confirm and continue, do not cut another* — and to stop and ask if HEAD is on a protected branch, because that means dispatch went wrong.
4. **`agent-rules/00-core.md`** → **R13** now permits commits and pushes on *this story's* branch rather than "a feature branch".
5. **`agent-rules/enforcement/claude/CLAUDE.md.template`** — R13 and the loop's handoff step.
6. **`delivery/README.md`** — the loop diagram shows the branch created at dispatch and the claim it constitutes; the multi-user section and the conventions list say who creates it.
7. **`architecture/delivery-operating-model.md`** — the per-story flow's LAND step and the skills table.
8. **`scripts/dispatch-preflight.sh`** — its success message now prints the exact four-step sequence, including the reminder that the check reads the remote.
9. **`_bmad-output/project-context.md`** — the git bullet.

**Not changed:** the pre-flight check's matching logic. `story/0.1.4` already satisfies its existing pattern, so no code change was needed — verified rather than assumed.

---

## Section 4 — Change Scope Summary

| Artifact | Change |
|---|---|
| `_bmad/custom/bmad-create-story.toml` | **`CTAM DISPATCH BRANCH` step added**; steps reordered into execution order; TOML validated |
| [`architecture/conventions.md`](./architecture/conventions.md) | *Git conventions* — `story/{story-id}` for story work |
| `agent-rules/60-session-protocol.md` (bus) | **W7 step 1 inverted** — continue on the dispatch branch, never cut a second |
| `agent-rules/00-core.md` (bus) | R13 wording |
| `agent-rules/enforcement/claude/CLAUDE.md.template` (bus) | R13 + handoff step |
| [`delivery/README.md`](./delivery/README.md) | Loop diagram, multi-user section, conventions list |
| [`architecture/delivery-operating-model.md`](./architecture/delivery-operating-model.md) | Per-story flow LAND step, skills table |
| `scripts/dispatch-preflight.sh` | Success message spells out the branch sequence |
| `_bmad-output/project-context.md` | Git bullet |
| [`architecture/changelog.md`](./architecture/changelog.md) | **v4.6** entry |
| **This SCP** | New |
| **`docs/`** | Regenerated |
| **Unchanged** | `prd.md`, every epic, `sprint-status.yaml`, FR/NFR coverage, the pre-flight matching logic |

**Handoff:** the bus changes join those already waiting on `chore/agent-rules-and-bmad-alignment` in `ctam-architecture`. They need that PR merged and a new **`arch-v1.1`** tag before a service repo can pin them — `arch-v1.0` still carries the old R13 and W7, and no story-packet template at all.
