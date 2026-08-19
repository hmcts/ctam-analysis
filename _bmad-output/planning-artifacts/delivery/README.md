# Delivery Control Plane

This folder is the **control plane** for CTAM Pathfinder delivery. It lives in
`ctam-analysis` and orchestrates *what to build next*, *whether it traces to a
requirement*, and *how a finished story reports back* — **without ever editing
service code**. Full rationale: [`../architecture/delivery-operating-model.md`](../architecture/delivery-operating-model.md).

## Files

| File | Role |
|---|---|
| `dispatch-graph.yaml` | Machine-readable build order + dependencies (epic-level). Source of truth for "what is buildable next". |
| `ledger/` | Traceability ledger, **sharded one file per epic** (`ledger/epic-0.x.yaml`) so multiple people update different epics without conflicts. Each shard carries epic-level `status`+`owner` and per-story `status`+`owner`+`pr`, plus optional `touches:` (secondary repos a story lands an artefact in) and `note:` (a cross-repo consumption constraint). Schema + concurrency rules: [`ledger/README.md`](ledger/README.md). |
| `README.md` | This file — the dispatch/signal loop and how it maps to BMad skills. |

Not *executed* here (deliberately): the **context bus** publish and **per-repo scaffolding** run in `ctam-architecture`, not in this repo — the control plane only *references* `bus_version` as a string. They are, however, **tracked** here: as of SCP 2026-08-18e they are Epics **0.A** (bus publish + `arch-v1.0` tag + `ctam-scaffold.sh` + the GitHub/Terraform runbooks) and **0.B** (the `ctam_configuration_values` baseline + per-service DB roles), with their own ledger shards. Before that they sat in an undecomposed `arch-baseline` node with no stories and no owner, while eight Phase 0 / Phase 0-Mock stories already assumed their output.

## The delivery loop

```
[ctam-analysis: control plane]                    [ctam-{service}: execution unit]
  1. SELECT next  ── read dispatch-graph + ledger → next buildable epic/story
        │
  2. DISPATCH ──── compile story packet (story + Gherkin ACs + distilled context
        │          + pinned bus_version) → land as docs/stories/<id>.md in repo
        │          ledger: status not-started → dispatched
        │                                                 ▼
        │                                    3. EXECUTE dev-story in the repo
        │                                       (reads CLAUDE.md → _arch/ bus)
        │                                       ledger: dispatched → in-progress → in-review
        │                                                 │  (human commits via VSCode)
  4. SIGNAL ◄──────────────────────────────────────────────┘
        └ ledger: → done, fill `pr`, record bus_version
```

**Buildable-now rule:** an epic is dispatchable iff every epic in its
`depends_on` is `done` in the ledger. Epics with disjoint dependency sets and no
shared state may run **in parallel** — but check `dispatch-graph.yaml`'s
**`repo_serialisation`** block too: some graph-independent epics share a repo and
share mutable files inside it, so they must still be dispatched in order.

## BMad skill mapping

| Step | Skill | Runs in |
|---|---|---|
| Select / plan | `bmad-sprint-planning` (reads `dispatch-graph.yaml`) | `ctam-analysis` |
| Dispatch | `bmad-create-story` / `compile-epic-context` → story packet | `ctam-analysis` |
| Execute | `bmad-dev-story` → `bmad-code-review` | target repo |
| Signal | `bmad-sprint-status` (updates the epic's `ledger/epic-*.yaml` shard) | `ctam-analysis` |

## Conventions

- **Status lifecycle:** `not-started → dispatched → in-progress → in-review → done`.
- **FR granularity:** epic-level unless a story narrows it. Every FR/NFR should trace to at least one story once all phases are decomposed.
- **Git writes are external.** Claude prepares packets, code, and ledger diffs; the human commits via VSCode (per repo CODEOWNERS/branch protection).
- **Bus pinning:** a story records the `bus_version` it was built against; repos re-sync only via an explicit submodule bump.

## Multi-user & ownership

The ledger is **sharded per epic** for conflict-free concurrent updates, and every epic and story carries a `status` and an `owner` so it is always visible who is driving what. Claim-before-you-start (set story `status: dispatched` + `owner` and push) is the coordination primitive. Full rules and the status vocab: [`ledger/README.md`](ledger/README.md).

## Current state (2026-08-18)

- **Phase 0-Mock fully seeded:** 2 epics, 4 stories (`epic-0M.1`, `epic-0M.2`), all `not-started`, unassigned (`owner: null`).
- **Phase 0 fully seeded:** 11 epics, 27 stories, all `not-started`, unassigned (`owner: null`) — 9 numbered epics (`0.0`–`0.8`) plus the two lettered `ctam-architecture` enablement epics **`0.A`** (3 stories) and **`0.B`** (1 story) added by SCP 2026-08-18e.
- **`0.A` precedes `0.0`.** The letter is an identifier, not a position: the order is `0.A → 0.0 → 0.B → 0.1 → …`. `0.A` is lettered precisely so that adding it moved no existing story id.
- **Two phases are seeded, and the graph — not the numbering — is the order.** **Phase 0-Mock** (epics `0M.1`, `0M.2`) is a pre-Phase-0 tier standing up contract-shaped stand-ins for both upstream sources; **Phase 0** (epics `0.0`–`0.8`) is foundations. The `0M.` prefix marks the tier so sequencing is never inferred from a number (SCP 2026-08-18c, decision #18).
- **Build order is a partial order.** Both `0M.` epics become dispatchable as soon as their dependencies are `done` (`epic-0.A` + `epic-0.0`, and `epic-0.1` for `0M.2`); they do not wait on each other. `epic-0M.1` gates `epic-0.2`, `epic-0M.2` gates `epic-0.3`, and `epic-0.8` is parallelisable with all of them. Any linearization respecting those edges is valid — read `dispatch-graph.yaml`, don't memorise a sequence.
- **Phases 1–8 + post-MVP:** repo-level placeholders in `dispatch-graph.yaml` under `future:` (`decomposed: false`). Promote each to an epic node with a `stories:` list after running `bmad-create-epics-and-stories` for that phase, and add a new `ledger/epic-*.yaml` shard for it.
- **Optional resolver** ("what's buildable now?") is intentionally deferred until dispatch begins.
