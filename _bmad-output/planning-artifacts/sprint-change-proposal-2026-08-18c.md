---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — 2026-08-18c: Upstream stand-ins promoted to their own pre-Phase-0 tier (Phase 0-Mock); 0.9/0.10 → 0M.1/0M.2'
timestamp: '2026-08-18'
tags: [ctam-pathfinder, sprint-change-proposal, phase-0-mock, epics, renumbering]
---

# Sprint Change Proposal — 2026-08-18c

## Create `epics/phase-0-mock/` as a distinct pre-Phase-0 phase and move both mock epics into it, renumbered `0M.1` / `0M.2`

## 1. Issue Summary

**Trigger:** a direct request to create `phase-0-mock` and move all the mock epics into it.

**Problem statement.** SCP 2026-08-18b (decision #17, earlier today) added two upstream stand-in epics — `ctam-joh-mock` and `ctam-mrd-mock` — and, to avoid renumbering 23 already-written Phase 0 stories for the **third** time in four days, **appended** them as Epics **0.9** and **0.10** rather than inserting them at 0.2/0.3. That was the right call on churn and the wrong shape to leave standing, because it created a durable trap:

> Two epics whose numbers sort **after** Epic 0.8, but which must build **before** Epic 0.2.

The mitigation was five warning notes — in the dispatch-graph header, the Phase 0 index blockquote, `epics/index.md`, `delivery/README.md`, and the site-NAV section label — each saying some version of *"an epic number is an identifier, not a build position."* That is load-bearing documentation defending against a misreading the identifier itself invites. Anyone reading the epic list without reading the notes draws the wrong conclusion, and sprint planning that trusts the numbering dispatches in the wrong order.

**The deeper point the numbering obscured.** These two epics are not foundations. Epic 0.0 provisions the estate, Epic 0.1 designs the schema, Epics 0.2–0.8 build the platform — all of that is CTAM's own product. The stand-ins are **scaffolding that makes foundations buildable**: the only work in the programme whose sole purpose is to be thrown into contact with a contract nobody has seen (gaps.md **G8.1**), and the only work explicitly guaranteed never to reach production. Filing that alongside "Notification service is scaffolded" flattens a real structural distinction.

**Evidence.**

| Source | What it shows |
|---|---|
| `delivery/dispatch-graph.yaml` (pre-change) | A `NOTE ON EPIC NUMBERS` block existed purely to prevent misreading `epic-0.9`/`epic-0.10` as late work |
| `epics/phase-0/index.md` (pre-change) | Table rows tagged *"(builds before 0.2)"* / *"(builds before 0.3)"* — the number contradicting the annotation beside it |
| `epics/index.md`, `delivery/README.md`, `build_html.py` NAV (pre-change) | The same warning restated three more times |
| Verified topological sort | `… → epic-0.1 → epic-0.9 → epic-0.2 → epic-0.10 → epic-0.3 → …` — numerically non-monotonic by design |
| SCP 2026-08-18b §1, decision 1 | The append choice recorded with its cost accepted explicitly, as a known trade |

**Issue type:** structural / organisational correction of a change made earlier the same day. Not a technical limitation, not a new requirement, not a scope change.

**Three decisions confirmed with the user during analysis:**

1. **`phase-0-mock` is a distinct phase, sequenced before Phase 0** — its own `index.md`, its own row in the epics phase table and in `framework.md`, its own NAV group. Phase 0 reverts to 9 epics / 23 stories; Phase 0-Mock carries 2 epics / 4 stories. (The alternative — a folder that only groups files while the epics stay counted in Phase 0 — was offered and not selected; it would have moved the files without removing the trap.)
2. **Renumber to `0M.1` / `0M.2`**, stories `0M.1.1`, `0M.1.2`, `0M.2.1`, `0M.2.2`. Keeping 0.9/0.10 was offered and not selected.
3. **`ctam-mock-auth` stays as Story 0.4.2 inside Epic 0.4.** The request said "all the mock epics"; there are only **two** mock *epics* — the third mock is a story. Extracting it was offered and not selected.

**On that third point, the reasoning matters** because it defines what this phase is *for*. Epic 0.4's user outcome is *"a user signs in and lands on a role-scoped Home page"* — that demo requires the issuer, `ctam-authorisation` and `ctam-ui` together. Pulling the issuer out would leave Epic 0.4 unable to demo anything on its own, renumber three sibling stories, and buy only folder tidiness. And the two things are not the same kind of mock: `ctam-mock-auth` is an **identity-provider** mock sitting inside a working auth slice; Phase 0-Mock holds **upstream data-source** mocks that stand in for external teams' data contracts. Phase 0-Mock is therefore scoped as *"upstream source stand-ins"*, not *"everything with 'mock' in the name"* — and its index says so explicitly, so the boundary survives the next reader who notices the asymmetry.

## 2. Impact Analysis

### Epic impact

| Epic | Impact |
|---|---|
| **0.9 → 0M.1** (`ctam-joh-mock`) | File moved to `epics/phase-0-mock/epic-0M.1-joh-reference-data-mocked.md`; `epic:`, `parent:`, `resource:`, `tags:` front-matter retargeted; H1 and both story headings renumbered; phase framing added. **Scope, ACs, dependencies, FR/NFR/AR coverage all unchanged.** |
| **0.10 → 0M.2** (`ctam-mrd-mock`) | Same treatment → `epic-0M.2-mrd-reference-data-mocked.md`. **Scope, ACs, dependencies, coverage unchanged.** |
| **Epic 0.2** | `depends_on: epic-0.9` → `epic-0M.1`; five prose/AC cross-references renumbered. No story, AC, or scope change. |
| **Epic 0.3** | `depends_on: epic-0.10` → `epic-0M.2`; four cross-references renumbered. No story, AC, or scope change. |
| **Epic 0.4** | **No change.** Story 0.4.2 (`ctam-mock-auth`) stays; no story renumbered. |
| **Epics 0.0, 0.1, 0.5–0.8** | **No change.** |
| **Phases 1–8, post-MVP** | **No change** — the `future:` nodes never referenced either epic. |

**Totals: Phase 0-Mock 2 epics / 4 stories. Phase 0 back to 9 epics / 23 stories.** No *Phase 0* story id changed; the four *mock* story ids changed as decided.

### Dependency-graph impact

Nodes renamed `epic-0.9` → `epic-0M.1`, `epic-0.10` → `epic-0M.2`, moved into a `phase: 0-mock` block positioned ahead of the Phase 0 nodes, with the `NOTE ON EPIC NUMBERS` block replaced by a factual `PHASES REPRESENTED HERE` note. **Re-verified acyclic**, with both constraints holding: `epic-0M.1` before `epic-0.2`, `epic-0M.2` before `epic-0.3`.

**A documentation error from 18b was corrected in passing.** SCP 2026-08-18b quoted a single topological order (`… 0.1 → 0.9 → 0.2 → 0.10 → 0.3 …`) as if it were *the* build order. It is one of several valid linearizations: both stand-ins share identical prerequisites, so they unblock **together** as soon as Epic 0.1 is `done` and do not wait on each other. Re-running the sort after the move produced `… 0.1 → 0M.1 → 0M.2 → 0.2 → 0.3 …` — equally valid, and proof the single-line form was misleading. The order is now documented as a **partial** order everywhere it appears:

```
epic-0.0 → arch-baseline → epic-0.1 → { epic-0M.1, epic-0M.2, epic-0.8 }
                                          │           │
                                          ▼           ▼
                                      epic-0.2 → epic-0.3 → epic-0.4
                                          → epic-0.5 → epic-0.6 → epic-0.7
```

### Artifact impact (exhaustive)

| Artifact | Change |
|---|---|
| `epics/phase-0-mock/index.md` | **New** — phase index: why the phase exists, what it does *not* do (G8.1 not closed), scope model incl. the `ctam-mock-auth` boundary, epics table, summaries, demo table, partial-order diagram, validation framing |
| `epics/phase-0-mock/epic-0M.1-joh-reference-data-mocked.md` | **Moved + renumbered** from `phase-0/epic-0.9-*` |
| `epics/phase-0-mock/epic-0M.2-mrd-reference-data-mocked.md` | **Moved + renumbered** from `phase-0/epic-0.10-*` |
| `epics/phase-0/index.md` | Two table rows, two summaries and two demo rows removed; totals 27 → 23; "eleven"/"nine" concrete epics; sequencing note rewritten as a cross-phase pointer; mock-first scope bullet retargeted; retirement-path paragraph moved to the new index (one post-MVP item retained); Epic 0.2 demo row mock name |
| `epics/index.md` | New **0-Mock** phase row; phase-0 row reverted to 9/23; story-id convention note extended with the `0M` token; "Phase 0 has completed all four steps" → both phases |
| `epics/framework.md` | New **`## Phase 0-Mock`** heading with the *Upstream Source Stand-Ins* Area moved under it; phase-summary row relabelled `0` → `0-Mock`; phase-level bullet list gains Phase 0-Mock; Phase 0 blockquote "eleven" → "nine" + pointer; ingestion cross-ref |
| `epics/fr-coverage-map.md` | Heading now names both phases; the *epics with no FR of their own* note and the FR6 tier-(a) links retargeted to `phase-0-mock/` |
| `epics/phase-0/epic-0.2-*.md`, `epic-0.3-*.md` | Stand-in references renumbered (9 edits total) |
| `architecture.md` | **Decision #18**; **#17 marked "placement and numbering superseded by #18"** with an in-cell pointer stating what is superseded and what stands; *Phasing of Upstream Integrations* section names the new tier |
| `architecture/gaps.md` | G8.1's epic references and the final-AC citation renumbered |
| `architecture/delivery-operating-model.md` | Illustrative graph's two `epics:` entries |
| `architecture/changelog.md` | **v4.7** entry |
| `delivery/dispatch-graph.yaml` | Nodes renamed + moved to a `phase: 0-mock` block; header note replaced; section banner widened; `epic-0.2`/`epic-0.3` edges |
| `delivery/ledger/epic-0M.1.yaml`, `epic-0M.2.yaml` | **Renamed** from `epic-0.9.yaml` / `epic-0.10.yaml`; `epic:` and `story:` keys renumbered; header comment reframed |
| `delivery/ledger/epic-0.2.yaml`, `epic-0.3.yaml` | Story `note:` references |
| `delivery/README.md` | Two phase lines in *Current state*; the epic-number warning replaced by a two-phase statement plus the partial-order explanation |
| `delivery/ledger/README.md` | Shard range now names the `0M.` shards |
| `scripts/python/build_html.py` | **New Phase 0-Mock NAV group** placed before Phase 0 (build order); the two stale Phase 0 entries removed; Phase 0 section label restored; this SCP's entry added and 18b's relabelled as superseded on numbering |
| `docs/` | Regenerated; the two stale `docs/epics/phase-0/epic-0.9-*.html` / `epic-0.10-*.html` deleted |

### Immutable history — deliberately NOT rewritten

- **`sprint-change-proposal-2026-08-18b.md`** — 25 references to 0.9/0.10 and to "11 epics / 27 stories", preserved verbatim. It is the record of that decision, not a description of today.
- **`architecture/changelog.md` v4.6** — likewise preserved; the new v4.7 row states explicitly that v4.6's counts no longer describe current state, so the discrepancy is documented rather than surprising.
- **`architecture.md` decision #17** — marked superseded **in place** rather than rewritten, following the repo's established D11→D13 and "AR53 (revised)" convention. Its cell now names precisely what #18 supersedes (placement, numbering, counts) and what still stands (the two repos, AR55/AR56, the G5.3 widening, G8.1's position, the mock-first rationale).

### Artifacts checked — no impact

`prd.md`, `business-case.md`, `epics/requirements-inventory.md` (AR55/AR56 describe the repos and their behaviour, not epic numbers — no edit needed), `architecture-summary.md` (its two mock rows cite AR55/AR56, not epic numbers), `architecture/repository-strategy.md` (repo rows, no epic numbers), `architecture/data-tables.md`, `architecture/conventions.md`, `architecture/repo-structure.md`, `architecture/assumptions.md`, all sequence diagrams, `_bmad-output/project-context.md`, root `CLAUDE.md` (the 18-repo list is unaffected — no repo was added or removed), all dated reports and prior SCPs.

**No UX impact.** Neither epic has a UI surface.

### Technical impact

**None.** No FR, NFR, or AR content changed. No schema, API contract, or endpoint change. No repo added or removed — still 18. No code impact: implementation has not started and every epic in both phases is `not-started` in the ledger.

## 3. Recommended Approach

**Selected: Option 1 — Direct Adjustment.** Create the phase, move and renumber the two epics, sweep every live reference, and mark the superseded decision in place.

**Rationale.** Rollback (Option 2) is not applicable — nothing is implemented; and "rolling back" to 0.9/0.10 is precisely what this change corrects. An MVP review (Option 3) is not applicable — no requirement or scope boundary moves.

**Why now rather than later.** This is the cheapest moment it will ever be. Nothing is implemented, no story packet has been dispatched, no service repo exists, and the artifacts being renumbered are less than a day old — so the sweep is 19 files with no code, no PRs and no in-flight work to reconcile. Every day this waits, the five warning notes get read by more people and the trap gets more chances to fire.

**Effort:** Low-Medium — one new index, two file moves with internal renumbering, two ledger renames, and a 19-file reference sweep. **Risk:** Low; the only failure mode is a missed reference, mitigated by a token sweep before and after plus a re-run acyclicity check. **Timeline impact:** none — no epic's scope, dependencies or story count changed, and the build order is semantically identical to what #17 established.

**What this change deliberately does not fix:** G8.1 remains open, both fixture sets remain provisional pending the ET as-is pack (G8.5), and the mock-reality-divergence risk is unchanged. This is an organisational correction, and it should not be read as progress against the underlying upstream-contract risk.

## 4. Detailed Change Proposals

### 4.1 New phase folder and index

```
NEW: _bmad-output/planning-artifacts/epics/phase-0-mock/index.md
```

Front-matter `type: 'Phase Index'`, `phase: 0-mock`, `phaseName: 'Upstream Source Stand-Ins'`, `parent: 'epics/index.md'` — matching `phase-0/index.md`'s shape. Content: why the phase exists (G8.1 quoted), what it does not do (G8.1 not closed; fixtures are not ET evidence), the scope model including the explicit `ctam-mock-auth` boundary, the epics table, both summaries, the demo table, the partial-order diagram, and a validation section framing the real readiness question as *"is every guessed field annotated and is the diff protocol in place"* rather than *"do the mocks work"*.

### 4.2 Epic moves and renumbering

```
OLD: epics/phase-0/epic-0.9-joh-reference-data-mocked.md
NEW: epics/phase-0-mock/epic-0M.1-joh-reference-data-mocked.md

OLD: epics/phase-0/epic-0.10-mrd-reference-data-mocked.md
NEW: epics/phase-0-mock/epic-0M.2-mrd-reference-data-mocked.md
```

Front-matter: `epic: 0.9` → `epic: 0M.1`; `parent:` → `epics/phase-0-mock/index.md`; `resource:` → the new `.html` path; `tags:` `phase-0` → `phase-0-mock`. Headings: `# Epic 0.9:` → `# Epic 0M.1:`; `## Story 0.9.1:` → `## Story 0M.1.1:`; `## Story 0.9.2:` → `## Story 0M.1.2:` (and the 0.10/0M.2 equivalents). Sibling cross-references between the two epics renumbered. One sentence added to each: the epic sits in Phase 0-Mock, the pre-Phase-0 tier. **No acceptance criterion, dependency, or coverage statement changed.**

### 4.3 Ledger shard renames

```
OLD: delivery/ledger/epic-0.9.yaml   NEW: delivery/ledger/epic-0M.1.yaml
OLD: delivery/ledger/epic-0.10.yaml  NEW: delivery/ledger/epic-0M.2.yaml
```

`epic:` keys → `epic-0M.1` / `epic-0M.2`; `story:` keys → `0M.1.1`/`0M.1.2`/`0M.2.1`/`0M.2.2`. Header comments reframed from *"epic number is an identifier, not a build position"* to *"Phase 0-Mock — the pre-Phase-0 tier…"*. `status`, `owner`, `frs`, `bus_version`, `pr` untouched.

### 4.4 Dispatch graph

**Header — OLD:**
> `# NOTE ON EPIC NUMBERS: an epic number is an IDENTIFIER, NOT a position in the build order. … epics 0.9 (ctam-joh-mock) and 0.10 (ctam-mrd-mock) were appended after 0.8 to avoid renumbering 23 existing stories …`

**NEW:**
> `# PHASES REPRESENTED HERE: phase 0-mock (the pre-Phase-0 upstream stand-in tier, epics 0M.x) and phase 0 (foundations, epics 0.x). Phase 0-Mock is NOT a slot in the 0-9 sequence: its epics are dependencies OF epic-0.2 and epic-0.3 and nothing else depends on them. The 0M. prefix marks the tier so sequencing is never inferred from a number.`

**Rationale:** the note changes from a warning about a misleading identifier to a statement of fact about two phases. Both nodes move into a `phase: 0-mock` block ahead of the Phase 0 nodes; `epic-0.2` gains `epic-0M.1` and `epic-0.3` gains `epic-0M.2`.

### 4.5 Phase 0 index — the two epics leave

Table rows, epic summaries and demo-table rows for 0.9/0.10 removed; totals 27 → 23 stories; "eleven concrete user-value epics" → "nine". The old warning blockquote becomes a cross-phase pointer:

**OLD:**
> **An epic number is an identifier, not a position in the build order.** The two upstream stand-in epics were appended as **0.9** and **0.10** rather than inserted at 0.2/0.3, so that 23 already-written stories did not have to be renumbered …

**NEW:**
> **Epics 0M.1 and 0M.2 are not Phase 0 epics** — they live in [**Phase 0-Mock**](../phase-0-mock/index.md), a pre-Phase-0 tier that stands up contract-shaped stand-ins for both upstream sources (gaps.md **G8.1**) before the ingestion epics consume them. They appear in the arrow order above because Epic 0.2 and Epic 0.3 each `depends_on` one of them, but they are counted in Phase 0-Mock's totals, not Phase 0's.

A prerequisite note under the epics table records the cross-phase dependency so a reader of Phase 0 alone still sees it. The sequencing arrow keeps each mock immediately before its consumer — a valid linearization that communicates the pairing — while the two places that *quote the dispatch graph* now show the partial order.

### 4.6 Decision #18 and the supersession of #17

**#17's title cell** gains *"(SCP 2026-08-18b; **placement and numbering superseded by #18**)"*, and its resolution cell gains a closing note naming exactly what is superseded (the tier placement, the 0.9/0.10 numbering, the "9 → 11 epics, 23 → 27 stories" counts, and the append-rather-than-insert rationale) and what still stands (both repos, AR55/AR56, the G5.3 widening, the G8.1 position, the mock-first rationale).

**#18** records the move, the renumbering, the reasoning — that putting sequencing information *in the identifier* makes five warning notes unnecessary rather than load-bearing — the corrected counts, the partial-order clarification, and the explicit statement that `ctam-mock-auth` stays in Epic 0.4.

### 4.7 Site NAV

A new group, **"Implementation — Phase 0-Mock (upstream source stand-ins; pre-Phase-0 tier)"**, placed **before** the Phase 0 group so NAV order matches build order. The two stale Phase 0 entries are removed and the Phase 0 section label reverts to its pre-18b text. 18b's SCP entry is relabelled to flag it as superseded on numbering.

### 4.8 Regenerate `docs/`

Run `scripts/build-html.sh`, then delete the two orphaned `docs/epics/phase-0/epic-0.9-*.html` and `epic-0.10-*.html`.

## 5. Implementation Handoff

**Scope classification: Moderate** — a phase is added and four story ids change, so the backlog view and any sprint-planning tooling reading epic ids must be reconciled; but no requirement, scope boundary, dependency or architectural principle moves, so this is not a replan.

- **PO / DEV (backlog):** two ledger shards renamed with renumbered story ids; Phase 0 totals reverted to 9/23; Phase 0-Mock seeded at 2/4. **Sprint planning must read `dispatch-graph.yaml`** — and must now read it for the *partial* order, not a single sequence: both `0M.` epics unblock together once `epic-0.1` is `done`.
- **Architect:** decision #18; #17's supersession markers; the *Phasing of Upstream Integrations* retargeting; the G8.1 citation updates.
- **Developer agent (control plane):** the 19-file sweep, this SCP, the v4.7 changelog entry, the NAV group, and the `docs/` regeneration incl. deleting the two orphaned pages.
- **Commit:** the user reviews and commits externally via VSCode (git writes are blocked inside Claude).

**Success criteria:**

1. No live artifact references `epic-0.9`, `epic-0.10`, `Epic 0.9`, `Epic 0.10`, or story ids `0.9.x` / `0.10.x` — the only remaining hits are SCP 2026-08-18b, changelog v4.6, and decision #17, all deliberate history.
2. `delivery/dispatch-graph.yaml` parses, is **acyclic**, and satisfies `epic-0M.1 < epic-0.2` and `epic-0M.2 < epic-0.3`.
3. `epics/phase-0/` contains exactly 9 epic files plus `index.md`; `epics/phase-0-mock/` contains exactly 2 epic files plus `index.md`.
4. `delivery/ledger/` contains 9 `epic-0.x.yaml` shards plus `epic-0M.1.yaml` and `epic-0M.2.yaml`; all `not-started`, `owner: null`.
5. Phase counts read consistently: **Phase 0 = 9 epics / 23 stories**, **Phase 0-Mock = 2 epics / 4 stories** in `epics/index.md`, `epics/phase-0/index.md`, `epics/phase-0-mock/index.md`, and `delivery/README.md`.
6. No **Phase 0** story id changed anywhere; Epic 0.4 is unmodified.
7. `scripts/build-html.sh` completes; all three Phase 0-Mock pages render and are reachable from a NAV group ordered before Phase 0; the two orphaned `epic-0.9-*.html` / `epic-0.10-*.html` no longer exist.
8. `prd.md`, `epics/requirements-inventory.md`, `architecture/repository-strategy.md` and root `CLAUDE.md` are unmodified (`git diff` shows no change) — no requirement, AR, repo or repo-count moved.

## 6. Pre-existing Findings — Not Part of This Change

1. **Site NAV is still missing four Sprint Change Proposals** — `2026-08-14`, `2026-08-15`, `2026-08-15b`, `2026-08-15c` — plus `implementation-readiness-report-2026-06-17`, `-2026-08-11`, and both `prd-validation-report-*` files. Flagged in SCP 2026-08-18 §6, re-flagged in 2026-08-18b §6, and **still open**. This change adds only its own entry. 08-15b/c define the current Phase 0 numbering and remain unreachable from the published site.
2. **`architecture/delivery-operating-model.md`'s illustrative dispatch-graph snippet** still carries pre-2026-08-15 epic ids for the non-mock repos. Marked `ILLUSTRATIVE SHAPE ONLY` in 18b; the two mock entries were updated here for consistency, but the surrounding stale ids are left as prose illustration.
3. **`scripts/python/__pycache__/build_html.cpython-314.pyc` is tracked in git** and changes on every site build, adding noise to every diff. Unrelated to this change; worth a `.gitignore` entry.
