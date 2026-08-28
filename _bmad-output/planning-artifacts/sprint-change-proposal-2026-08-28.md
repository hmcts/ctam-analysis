---
type: 'Sprint Change Proposal'
description: 'Flattens the phase-nested epic tree to stock BMad shape — epics/epic-<n>-<slug>.md with two-part story ids and phase in frontmatter — retiring deviations 1 and 2 of the delivery-operating-model register.'
resource: 'sprint-change-proposal-2026-08-28.html'
tags: [ctam-pathfinder, change-control, delivery, bmad, epics]
timestamp: '2026-08-28'
title: Sprint Change Proposal — 2026-08-28 (epics flattened to stock BMad shape)
last_updated: '2026-08-28'
---

# Sprint Change Proposal — 2026-08-28

**Type:** artefact-shape conformance. **No** scope, requirement, epic-content, story-content or architecture change. Epics and stories are renumbered, not rewritten.

## Trigger

BMad 6.11 replaced the epic parse with a deterministic script, `bmad-sprint-planning/scripts/sprint_plan.py`. Its regexes are hard:

| Regex | Effect on the phase-nested shape |
|---|---|
| `^#{1,3}\s*Epic\s+(\d+)` | `# Epic 0.1:` parses as epic **0**, title `.1: …` — all seven phase-0 epics collapse into one |
| `^#{2,4}\s*Story\s+(\d+)\.(\d+[a-z]?)` | `## Story 0.1.4:` parses as epic 0, story 1, title `.4: …` |
| `^epic-(\d+)$` | `epic-0.0`…`epic-0.6` **unrecognized** — `validate` reported 8 problems, `generate` dropped them as orphans |
| `^epic-(\d+)-retrospective$` | same for the seven retrospective keys |

Separately, `bmad-create-story`'s sharded epic glob is `{planning_artifacts}/*epic*/*.md`. The epic files sat one level deeper under `phase-0/`, so the glob matched four index/map files and **no epic**. A glob miss is not an error, so acceptance criteria would be **invented rather than carried verbatim**. `bmad-build` derives its epic-context cache key and its sprint-status epic lift from the same leading numeric segment.

These are deviations **1 and 2** of the register in [`architecture/delivery-operating-model.md`](architecture/delivery-operating-model.md). Row 1 already named this change as its exit condition: *"CTAM renumbers epics flat and moves the phase into frontmatter."*

Cost of acting is at its floor: **21 stories, one done** (old 0.6.1).

## Decision

**`epics/phase-0/` is flattened into `epics/`. Phase becomes frontmatter, not path.** Mapping — strip the leading `0.`:

| Was | Now |
|---|---|
| `epics/phase-0/epic-0.N-<slug>.md` | `epics/epic-N-<slug>.md` (N = 0…6) |
| `# Epic 0.N: <title>` | `# Epic N: <title>` |
| `## Story 0.N.M: <title>` | `## Story N.M: <title>` |
| `epic: 0.1` | `epic: 1` + `phase: 0` |
| `depends_on: [epic-0.0, epic-0.6]` | `depends_on: [epic-0, epic-6]` |
| `epics/phase-0/index.md` | `epics/phase-0-overview.md` |
| sprint-status `epic-0.N` / `epic-0.N-retrospective` | `epic-N` / `epic-N-retrospective` |
| sprint-status `0-N-M-<slug>` | `N-M-<slug>` |
| packet `story_id: 0.1.4`, `docs/stories/0.1.4.md` | `story_id: 1.4`, `docs/stories/1.4.md` |

Epic numbering is now **global and monotonic** — phase 1 continues from **7**. Phase is a grouping attribute (`phase:`), never a path segment.

**Epic 0 is deliberate.** `\d+` accepts `0`, and stripping the prefix is a reversible mechanical mapping. Renumbering 1–7 would shift every digit against fourteen immutable SCPs and readiness reports for no functional gain.

## Explicitly not done

| Left alone | Why |
|---|---|
| `requirements-inventory.md`, `fr-coverage-map.md` kept as shards, not folded into `index.md` | The template's `## Requirements Inventory` / `### FR Coverage Map` headings appear only in `bmad-create-epics-and-stories`' **authoring** steps. Nothing reads them by heading at consumption time; `*epic*/*.md` globs the whole folder. Folding is 385 lines of churn for nothing |
| `framework.md` | Phase × Area map is CTAM-specific context, inert to BMad |
| Polyrepo machinery — `repo:`/`depends_on:` frontmatter, `delivery/`, the three shell scripts, the sprint-status caveat comments | Verified inert w.r.t. BMad; unaffected. Deviations 3–6 remain live |
| Twelve SCPs, two readiness reports, the existing changelog entries — **prose and numbering verbatim** | Immutable history — one new changelog entry is added |
| **Exception: dead link *targets* in three history files** were repointed (`changelog.md`, SCP 2026-08-19d, SCP 2026-08-21) | Removing `epics/phase-0/` left 15 dead links on the published site. Only the path inside `](…)` changed; every word of the surrounding entry is untouched. A pre-existing typo target (`epic-0.1-user-authenticates.md` — no such epic) was corrected to `epic-2-…` in the same pass |
| `architecture/index.md` (missing; `bmad-create-epics-and-stories` step-01 looks for `*architecture*/index.md`) | Separate concern, separate change |
| `sprint-status.yaml`'s stock `story_location` | Known-inert falsehood — packets live in target repos. Documented in the file's caveat block |

## Changes

**Epics** — `git mv` of seven epic files out of `phase-0/`; H1s, story H2s and every in-file cross-reference renumbered; `phase: 0` added to each epic's frontmatter. `phase-0/index.md` → `phase-0-overview.md`, with its `### Epic N:` summary headings demoted to `####` — `EPIC_RE` matches `#{1,3}`, so at h3 they would register as a second set of epic definitions. `index.md` gains a flat epic table and corrects the stale "6 epics, 19 stories" to **7 epics, 21 stories**; `phase-0-overview.md`'s "19 stories" total corrected likewise.

**`sprint-status.yaml`** — regenerated by the stock script over the seven flattened files. The two non-backlog statuses (`epic-6: in-progress`, story `6-1-…: done`) were re-set explicitly, because every key changed and the merge could not carry them. Caveat comment block preserved.

**Scripts**

| File | Change |
|---|---|
| `scripts/validate-story-packet.sh` | `story_id` and `depends_on_stories` shape checks: three-part → two-part |
| `scripts/dispatch-preflight.sh` | Intra-epic ordering reads the story leaf at dashed-key field **2**, not 3; id shape check two-part; `epic_dashed` no longer needs dot substitution |
| `scripts/python/build_html.py` | NAV section flattened (8 entries) |
| `scripts/python/apply_okf_frontmatter.py` | Phase tag derived from frontmatter `phase:`, falling back to the path for `phase-<n>-overview` shards |
| `scripts/python/build_graph.py` | Comment only — parent/tag resolution is generic and needed no change |

**Documents** — references renumbered in `prd.md` (D3, D10), `architecture.md`, `architecture-summary.md`, `architecture/{gaps,repo-structure,repository-strategy,conventions,assumptions}.md`, `delivery/README.md`, `CLAUDE.md`, `README.md`. `conventions.md` (branch example `story/0.1.4`) and `assumptions.md` (A34's Story 0.1.1 verification hook) were found by the post-change residual scan rather than the initial sweep — a token-shape sweep must cover `story/<id>` and bare `Story <id>`, not only `Epic`/`epics/` paths.

**`architecture/delivery-operating-model.md`** — epic-frontmatter and story-packet examples updated; deviation-register rows **1** and **2** struck through and marked **RETIRED 2026-08-28**; the "read before dispatching" warning now scopes the live deviations to **3–6**.

**Drive-by, caused by the directory removal:** `prd.md` cited `epics/phase-0/validation-report-2026-05-15.md`, a file that has never existed. Retargeted to `implementation-readiness-report-2026-05-15-rev2.md`.

## Verification

| Check | Result |
|---|---|
| `sprint_plan.py generate` | 7 epics, 21 stories, 7 retrospectives; 26 backlog / 7 optional / 1 in-progress / 1 done |
| `sprint_plan.py validate` | `valid: true`, **0 problems** (was 8 unrecognized keys) |
| `scripts/dispatch-preflight.sh 1.4` | Resolves `epic-1`, reads its frontmatter `depends_on`, correctly names 1.1–1.3 as unbuilt prerequisites |
| Markdown link integrity across all of `planning-artifacts/` | 0 dead links introduced. Four remain, **all pre-existing at HEAD** and unrelated: `pilot-0.5-findings.md` (×2, never existed) and two `../sprint-change-proposal-*.md` in `architecture.md` at the wrong relative depth |
| Residual `0.<0-6>` scan across live artefacts | Only legitimate epic-0 story ids remain |
| `bash -n` on both shell scripts, `ast.parse` on the Python scripts | Clean |

## Risk and follow-up

**One story packet exists in a target repo** — old `0.6.1` in `ctam-architecture`, status `done`. Its `story_id`, filename and `sprint_status_key` change to `6.1`. It is complete, so the rename is bookkeeping, but the packet lives in another repo and this control-plane change cannot reach it. **Follow-up, tracked here.**

The published site is **not** regenerated by this change. `scripts/build-html.sh` runs as a separate commit so the markdown diff can be reviewed on its own.
