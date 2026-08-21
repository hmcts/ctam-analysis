---
type: 'Sprint Change Proposal'
description: 'Retires the committed bmad-create-story team customization ahead of BMad 7 native polyrepo/multi-user support, and records the nine CTAM deviations from out-of-the-box BMad in a deviation register.'
resource: 'sprint-change-proposal-2026-08-21.html'
tags: [ctam-pathfinder, change-control, delivery, bmad]
timestamp: '2026-08-21'
title: Sprint Change Proposal — 2026-08-21 (bmad-create-story override retired; deviation register added)
last_updated: '2026-08-21'
---

# Sprint Change Proposal — 2026-08-21

**Type:** tooling / delivery-contract simplification. **No** scope, requirement, epic, story or architecture change.

## Trigger

BMad 7 is expected to support polyrepo and multi-user delivery natively. `_bmad/custom/bmad-create-story.toml` had grown to fourteen `activation_steps_append` instructions — rebinding story identity, epic input, output location, packet shape, bus reads, epic guards and branching. Carrying it until v7 would make the migration a rewrite rather than a delete, because the override does not merely redirect paths: it restates BMad's own step logic in prose, which has to be diffed against v7 line by line to know what is still needed.

Delivery state made the decision cheap: **21 stories in `sprint-status.yaml`, one done** (0.6.1). The migration bill scales with the number of packets written under the override, and that number is one.

## Decision

1. **Delete `_bmad/custom/bmad-create-story.toml`.** `bmad-create-story` reverts to stock BMad 6.
2. **Add a deviation register** to [`architecture/delivery-operating-model.md`](architecture/delivery-operating-model.md) — nine rows, each with why CTAM needs the deviation, what stock BMad 6 does instead, and the **v7 exit condition** that retires it.

The register replaces the override's function: the knowledge was previously reconstructable only by reading the override, two scripts and six documents. One table now carries it, and becomes the v7 migration checklist.

## What this costs, stated plainly

**Dispatch is no longer safe unattended.** Six of the nine deviations are live against stock BMad 6. The worst is silent: BMad's epic glob (`*epic*/*.md`) matches no CTAM epic file, a miss is treated as "not an error", and the workflow then has no epic content to read — so **acceptance criteria are invented rather than carried verbatim**. A dispatcher must read the register and handle deviations 1–6 by hand, or wait for v7.

This is accepted deliberately. Nothing is in flight, and no dispatch is planned before v7.

## Retained, and why it costs nothing

`scripts/dispatch-preflight.sh`, `scripts/validate-story-packet.sh` and `scripts/publish-arch.sh` stay. No BMad skill reads them, so they are not extensions of BMad and carry no migration cost — they are invoked by hand from the delivery loop. `scripts/publish-arch.sh` is additionally an acceptance criterion of [Epic 0.6](epics/phase-0/epic-0.6-context-bus-and-shared-baseline.md).

`_bmad/custom/config.toml` (an empty team-override stub) and the `.gitignore` negation that keeps `_bmad/custom/` tracked both remain.

## Deliberately not done

- **Flattening `epics/phase-0/` → `epics/`** and **renumbering story ids to two parts** would delete deviations 1 and 2 outright and are native BMad 6 moves, not v7 bets. Deferred: the flatten is a 29-reference change, the renumber ~314 references plus a bus retag, and neither buys anything while dispatch is paused. Both are recorded as v7 exit conditions instead.
- Removing the polyrepo packet shape from the bus (`ctam-architecture/agent-rules/templates/story-packet.md`). It stays valid; retiring it needs a coordinated bus change and an `arch-vN` tag.

## Sections affected

- `_bmad/custom/bmad-create-story.toml` — **deleted**
- [`architecture/delivery-operating-model.md`](architecture/delivery-operating-model.md) — new *Deviation register*; the enforcement bullet updated
- [`delivery/README.md`](delivery/README.md) — BMad skill mapping note
- `_bmad-output/implementation-artifacts/sprint-status.yaml` — header caveat
- [`architecture/changelog.md`](architecture/changelog.md) — v4.8
