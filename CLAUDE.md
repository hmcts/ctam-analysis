# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working in this repository.

## What this repository is

`ram-analysis` is the **central planning, analysis, and delivery-coordination hub for RAM Pathfinder** — HMCTS's greenfield Judicial Office Holder (JOH) availability-and-scheduling platform. It is **not** the implementation and holds no runtime application code. RAM Pathfinder ships as a **16-repo polyrepo** (`ram-shared-infrastructure`, `ram-architecture`, `ram-mock-auth`, `ram-reference-data`, `ram-authorisation`, `ram-notification`, `ram-joh`, `ram-absence`, `ram-vacancy`, `ram-booking`, `ram-sitting`, `ram-payment`, `ram-itinerary`, `ram-mi-feed`, `ram-ui`, `ram-admin-ui`); this repo is the **control plane** that plans and coordinates building those repos.

- **Programme:** SSCS-first rollout — wave 1 replaces **ListAssist** (SSCS judicial scheduling; GAPS case-management is *retained*), waves 2+ replace the as-is JI application (Oracle APEX) per Courts region. Scope is availability/scheduling only; case/hearing management stay in external systems that consume RAM's APIs.
- **Delivery is AI-led (Claude Code) using the BMAD method** — a structured planning-to-delivery workflow (PRD → architecture → epics/stories → story dispatch → implementation → code review → sprint status). The role split across this repo and the service repos is defined in `_bmad-output/planning-artifacts/architecture/delivery-operating-model.md` — read it before coordinating implementation.

## Where things live

- **`_bmad-output/planning-artifacts/` — the canonical, git-tracked source of truth.** Despite living under `_bmad-output/`, this subtree is committed and authoritative; do NOT treat it as scratch.
  - `prd.md`, `business-case.md`, dated `*-validation-report` / `*-readiness-report` / `sprint-change-proposal-*` (historical records).
  - `architecture.md` + `architecture/` shards: `repository-strategy.md`, `repo-structure.md`, `conventions.md` (the consistency contract), `data-tables.md`, `delivery-operating-model.md`, `gaps.md`, `assumptions.md`, `changelog.md`, `starter-template.md`, `user-types.md`, FR/NFR coverage, plus `diagrams/` and `sequence-diagrams/`.
  - `epics/` — `framework.md` + `phase-0/` epics with **stories embedded inside each epic** (only Phase 0 is decomposed so far; phases 1–8 still need to be broken into epics/stories).
  - `delivery/` — the **delivery control plane**: `dispatch-graph.yaml` (deterministic build order) + `ledger/` (traceability, sharded one file per epic, each with epic/story `status` + `owner`) + `README.md`.
- **`_bmad-output/project-context.md`** — lean, LLM-optimised implementation rules for the RAM Pathfinder *service* code; seeds each target repo's context.
- **`docs/` — the published static HTML site** (GitHub Pages), generated from planning-artifacts by `scripts/build-html.sh`. Never hand-edit; regenerate.
- **The rest of `_bmad-output/`** (e.g. `brainstorming/`) is local scratch, not part of any output contract.
- **Legacy/exploratory at repo root** — `sql/`, `queries/`, `openspec/`, and older `scripts/python/` helpers — earlier iterations, not part of the current delivery workflow. Don't wire new work through them.

## Delivery operating model (the coordination contract)

Full detail in `architecture/delivery-operating-model.md`. In brief:

- **Control plane** (this repo) — canonical planning + dispatch + traceability. Never edits service code.
- **Context bus** (`ram-architecture`) — version-pinned published architecture each service repo consumes as a submodule.
- **Execution units** (the 15 service/UI/infra repos) — where code lands; each gets a self-contained story packet.
- Build order is deterministic via `delivery/dispatch-graph.yaml`; progress lives in `delivery/ledger/` (per-epic shards, `status`+`owner` for multi-user coordination).
- Work moves through three stages: a story is **dispatched** (packaged with full context for a target repo), **executed** (implemented and code-reviewed in that repo), then its status is **signalled** back into the ledger.

## Working conventions

- **BMAD is the methodology** for planning and delivery. `_bmad/` is a gitignored local plugin install — don't add it to the repo.
- **Cross-cutting changes: sweep first, don't blind find-replace.** Run a repo-wide sweep for every affected reference, clarify ambiguous terms, record the change in a new Sprint Change Proposal + a `changelog.md` entry, then regenerate `docs/`. Leave dated reports and existing changelog entries as immutable history — add, don't rewrite.
- **Canonical architecture is sharded.** New architecture docs are shards under `architecture/` (sibling of `architecture.md`, linked from it). When adding a shard or a new SCP, add a matching entry to the `NAV` list in `scripts/python/build_html.py` so it appears on the site, then rebuild.
- **Regenerate the site after editing any planning-artifact markdown:** `scripts/build-html.sh`.

## Hard rules

- **Git/GitHub writes are blocked from inside Claude** — a `PreToolUse` hook (`.claude/hooks/block-git-writes.sh`) denies `git commit/push/pull/merge/rebase/reset/checkout/branch/tag/stash/cherry-pick/clean/rm` and any `gh`/`hub` command. Read-only git is allowed. The user reviews and commits externally via VSCode — surface the diff and stop; do not work around the hook.
- **Source documents are read-only.** Analysis/distillation writes to `output/` folders, never the originals.
- **`docs/*.html` is generated — never hand-edit it;** run `scripts/build-html.sh` (reads planning-artifacts → writes `docs/`; also runs `build_graph.py`). Requires `pandoc` + Python 3.

## Common commands

- **Rebuild the published site:** `scripts/build-html.sh`
