---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — new Epic 0.10: JOH eLinks API contract confirmed + CI mock'
description: 'Date: 2026-08-20 — an external reference codebase (ctam-jomockapi, a local mock of the real JOH eLinks People API v5) confirms the eLinks contract structurally, resolving much of gap G8.1. New Epic 0.10 builds a contract-accurate CI-only fixture layer for ctam-reference-datas eLinks sync from this reference. A new gap, G8.7, records that the real APIs natural-key field (per_id/personal_code) does not match CTAMs personnel_number assumption — discovery only, not resolved by this change, per explicit product-owner direction. Numbered 0.10 (quoted as a string) since Phase 0s ten single-digit epic slots are exhausted.'
resource: 'sprint-change-proposal-2026-08-20f.html'
tags: [ctam-pathfinder, sprint-change, epics, phase-0, gaps]
timestamp: '2026-08-20'
parent: 'planning-artifacts/index.md'
project: 'ctam-analysis (CTAM Pathfinder)'
change_scope: 'Moderate — new epic + new tracked gap, no PRD/architecture/FR change, no schema change'
mode: 'Batch'
architectureVersion: 'v4.11'
last_updated: 2026-08-20
---

# Sprint Change Proposal — 2026-08-20 (f)

**New Epic 0.10: the JOH eLinks API contract is confirmed and mocked for CI-only integration testing**

---

## Section 1 — Issue Summary

**Trigger:** *"create a epic for joh api. Use the following codebase as reference /Users/shivakumar/MOJ/ctam-jomockapi"*.

**What the reference codebase is:** `ctam-jomockapi` is a local Node.js mock of the **real** JOH eLinks People API (v5) — built from the real Swagger export (`Swagger UI.pdf`) and complete example payloads (`apiresponses.docx`), with reference-data fixtures loaded from **real production reference-data extracts** (`ReferenceData/*.csv|json`, dated 2026-06-01). This is direct evidence for something the architecture has flagged as unconfirmed since gap **G8.1** was first recorded: the JOH eLinks API contract.

**What it confirms:** the endpoint set (`/api/v5/people`, `/people/:id`, `/leavers`, `/deleted`, `/reference_data/:attribute_name[/:id]`, plus public `/` and `/healthcheck`), bearer-token auth (`401` on missing/malformed token), the pagination envelope (`current_page`/`more_pages`/`results_per_page`/`pages`/`results`), change-feed semantics (`updated_since`/`left_since`/`deleted_since`, required), and validation/404 error shapes — all of this was previously assumption, now confirmed.

**What it refutes:** the person record has **no `personnel_number` field**. The real API returns `per_id` (numeric) and `personal_code` (10-digit string). CTAM's architecture — `data-tables.md`, decision D9, `ctam_joh_identities`, `ctam_auth_users`, and the identity chain FR1 depends on — is built entirely around `personnel_number` as the natural key. This is a genuine, load-bearing discrepancy.

**Clarified directly with the user before drafting:**
1. **Numbering** — Phase 0 has used all ten single-digit epic slots (0.0–0.9). An eleventh epic as bare `0.10` would parse as the YAML float `0.1`, silently colliding with the schema-design epic. Confirmed: number it **0.10**, quoted as a string in frontmatter (`epic: "0.10"`) — verified safe against `dispatch-preflight.sh`, which matches epic ids purely as strings (`epic-${epic_num}`, glob-matched against filenames), never as parsed numbers.
2. **The identity-field discrepancy** — confirmed: **flag it as a new tracked gap only; do not touch the schema.** The natural-key reconciliation (which of `per_id`/`personal_code` CTAM should adopt, and the resulting rename sweep across `data-tables.md`/D9/three tables/five epics) is a separate, larger architectural decision, not made as part of this change.

---

## Section 2 — Impact Analysis

### 2.1 Epic impact

| Epic | Change |
|---|---|
| **Epic 0.10 (new)** | `joh-elinks-api-contract-mock` — 1 story; `depends_on: [epic-0.1]` (needs the tier-(a) schema to exist for the mock's field mapping to be cross-checked against); lives inside `ctam-reference-data`'s test infrastructure, not a new repo or deployable |
| **Epics 0.0–0.9** | **Unaffected in substance.** No existing epic's `depends_on`, stories, or ACs change. Epic 0.2 (JOH ETL) is not modified — this epic *supports* Epic 0.2's existing Story 0.2.1 promise of CI testing "against a WireMock/stub eLinks API," it doesn't restructure it |

### 2.2 Story impact

One new story, **0.10.1**: builds the CI-only mock/fixture layer reproducing the confirmed contract (endpoints, auth, pagination, error shapes, change-feed semantics), cross-checks fixture volumes against the real production reference-data extracts this discovery is built from, and records the `personnel_number` mismatch as gap G8.7 with a grep-able `// TODO: gaps.md G8.7` marker in the sync's field-mapping code — without changing the schema.

### 2.3 Artifact conflicts

New `epics/phase-0/epic-0.10-joh-elinks-api-contract-mock.md` · `architecture/gaps.md` (new **G8.7**; one-line cross-reference added to G8.1's existing body — its resolution-path text is otherwise untouched, per "leave gap history as record, add don't rewrite") · `epics/phase-0/index.md` (epic table, epic-summary block, stories-summary table, totals 10→11 epics / 22→23 stories) · `epics/fr-coverage-map.md` (NFR24 row gains a reference to Epic 0.10) · `scripts/python/build_html.py` `NAV` list · `_bmad-output/implementation-artifacts/sprint-status.yaml` (new `epic-0.10` block) · a new `architecture/changelog.md` entry (v4.11) · `docs/` regenerated.

**Not touched:** `data-tables.md`, decision D9, `ctam_joh_identities`/`ctam_auth_users` schema, and every existing epic's story text that names `personnel_number` — per the explicit "don't touch the schema" direction. G8.7's resolution path names exactly what a future change would need to touch, so that work is scoped but not started.

### 2.4 Technical impact

None — no code exists for `ctam-reference-data` yet, and this epic's own deliverable is CI-only test infrastructure, never deployed.

---

## Section 3 — Recommended Approach

**Direct adjustment** — add the new epic and the new gap as described. No PRD, architecture, or FR/NFR change (the epic supports existing FR1/NFR24 rather than adding new ones); no schema change (per explicit direction, deferred to a future decision tracked as G8.7). Effort: new-content authorship grounded in a concrete reference codebase, not a mechanical split; risk: low — additive only, nothing existing is restructured.

---

## Section 4 — Verification performed

Same checklist as the prior renumbering SCPs, adapted for an addition rather than a renumber: every markdown link in `epics/phase-0/*.md` resolves to an existing file (including the new `epic-0.10-...` filename); `storyCount:` matches the actual `## Story` heading count; the story heading (`## Story 0.10.1`) matches the file's own `epic: "0.10"`; `depends_on: [epic-0.1]` is a real, existing epic; `scripts/build-html.sh` runs clean, and `epic-0.10`'s quoted frontmatter does not break either `build_html.py` (which never parses the `epic:` field — NAV entries are hardcoded) or `build_graph.py` (which sorts epic ids as strings, never as parsed floats).

---

## Section 5 — Implementation Handoff

**Scope classification: Moderate** — a new epic plus a new tracked gap, no PRD/architecture/FR change, no schema change, no code exists yet.

**Route:** Developer agent (this session) implements directly. **Escalation flagged, not routed:** gap **G8.7** (the `personnel_number` → `per_id`/`personal_code` reconciliation) is a genuine architectural decision that needs Judicial Office input and a coordinated rename across `data-tables.md`, D9, and several epics — that follow-up work is **not** part of this change and should be picked up separately (PM/Architect involvement) once the real natural key is confirmed with the upstream team.

**Success criteria:** the verification checks in Section 4 pass; `git status` shows the new epic file, gap additions, and the small set of connective-file edits, with no unrelated changes; the published `docs/` site includes Epic 0.10 with no broken links.
