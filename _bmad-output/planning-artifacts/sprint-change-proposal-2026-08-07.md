---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — Wave-1 pilot jurisdiction changes from SSCS to Employment Tribunals (ET)'
description: 'Date: 2026-08-07 — The MVP pilot wave retargets from the SSCS Tribunals jurisdiction to the Employment Tribunals (ET) jurisdiction. SSCS is demoted to wave 2; Courts jurisdictions shift to waves 3+. Documentation-only cascade — implementation has not started.'
resource: 'sprint-change-proposal-2026-08-07.html'
tags: [ram-pathfinder, sprint-change, jurisdiction, employment-tribunals, wave-1]
timestamp: '2026-08-07'
parent: 'planning-artifacts/index.md'
project: 'ram-analysis (RAM Pathfinder)'
change_scope: 'Major (documentation only — implementation not started)'
mode: 'Batch'
decision: 'D13 (supersedes D11)'
architectureVersion: 'v4.0 (proposed)'
last_updated: 2026-08-07
---

# Sprint Change Proposal — 2026-08-07

**Wave-1 pilot jurisdiction: SSCS → Employment Tribunals (ET)**

---

## Section 1 — Issue Summary

**Trigger:** Programme direction changed — the MVP pilot rollout (Phase 9, wave 1) targets the **Employment Tribunals (ET)** jurisdiction instead of the **SSCS** Tribunals jurisdiction.

**Disposition agreed at intake (2026-08-07):**

| Wave | Before (D11) | After (D13) |
|---|---|---|
| Wave 1 | SSCS Tribunals | **Employment Tribunals (ET)** |
| Wave 2 | Courts jurisdictions, per HMCTS judicial region | **SSCS Tribunals** |
| Waves 3+ | — | Courts jurisdictions (Civil, Crime, Family, Crown), per HMCTS judicial region |

SSCS is **demoted, not deleted** — its analysis (ListAssist, GAPS, tribunal-member sub-types, Journey 1, the RTJ/Caseworker role set) is preserved and re-sequenced to wave 2. Courts content shifts from "waves 2+" to "waves 3+".

**Discovery context:** Raised as a course-correction while the programme sat between planning and execution. **Implementation has not started** — all six Phase 0 epics are `status: not-started` with `owner: null` in `delivery/ledger/`, and `_bmad-output/implementation-artifacts/` is empty. Like SCPs 2026-07-06 and 2026-07-09, this is a **documentation/architecture change with no code to unwind**: broad surface, low execution risk.

**Evidence — measured surface (repo-wide sweep, 2026-08-07):**

| Signal | Count | Spread |
|---|---|---|
| `SSCS` references | ~250 | 27 files under `planning-artifacts/` + 4 repo-level files |
| `ListAssist` references | ~100 | 21 files |
| Lines carrying `wave 2` / `waves 2+` | 100 | 24 files — **all require renumbering to waves 3+** |
| Lines carrying `wave 1` | 166 | wave number survives; jurisdiction and incumbent do not |
| `D11` citations (incl. `[^d11]` footnote) | ~180 | 23 files — the footnote text itself is wrong in every file |
| `Employment` references **existing today** | **0** | ET is entirely new vocabulary to this repo |

The `[^d11]` footnote is repeated verbatim as a block at the tail of ~20 files. That is a single reusable edit applied many times, not 20 distinct decisions.

---

## Section 2 — Impact Analysis

### 2.1 The central finding — the architecture already absorbs this

**The 16-repo decomposition, the data model, and all 60 FRs / 42 NFRs survive unchanged.** This is not luck; it is D8 working as designed.

D8 (reframed 2026-06-10) made **jurisdiction a first-class hierarchical attribute sourced from upstream `jo_jurisdictions`** — "not invented or tagged by RAM Pathfinder". Every jurisdiction-sensitive mechanism was therefore built to be parameterised, not hardcoded:

| Mechanism | Why ET needs no structural change |
|---|---|
| `jo_jurisdictions` | Hierarchy comes from eLinks. Tribunals/ET is a sibling of Tribunals/SSCS — a data value, not a schema change. |
| `ram_auth_user_activation_flags` | Keyed by the `(jurisdiction, region)` tuple (FR57). Wave cutover is an `UPDATE … WHERE jurisdiction = …`. ET is a different WHERE clause. |
| `ram-authorisation` | Carries the user's jurisdiction alongside roles + Region/Area scope (FR2). Jurisdiction-agnostic. |
| `ram-reference-data` | Filters API responses by requester jurisdiction (FR6/FR7). Jurisdiction-agnostic. |
| `ram_joh_identities` / `joh_id` | RAM-assigned UUID per JOH (D9 as refined by SCP 2026-07-09). Independent of jurisdiction. |
| `ram_jurisdictional_splits` | Per-JOH split percentages (FR16). Already multi-jurisdiction by construction. |
| JOH umbrella term | Adopted precisely because non-judge panel members exist. ET's non-legal members are covered by the same abstraction. |

**Unchanged in full:** the 16-repo polyrepo · the 55-table data model · Phase 0–8 build sequence · all six Phase 0 epics and their 19 stories · `delivery/dispatch-graph.yaml` · `delivery/ledger/` · decisions **D1, D2, D3, D4, D6, D7, D9, D10, D12** · every architecture convention.

**No FR or NFR is added, removed, or renumbered.** Roughly 12 are **reworded** where their prose names SSCS or ListAssist: FR6, FR7, FR44, FR57, FR60, NFR21, NFR24, NFR32, NFR36, NFR38, NFR41.

### 2.2 Epic impact

| Epic | Status | Impact |
|---|---|---|
| 0.0 Platform estate | not-started | **None** — jurisdiction-agnostic infrastructure |
| 0.1 Upstream reference-data ingestion | not-started | **None structurally.** Assumption to re-verify: eLinks `jo_jurisdictions` carries ET (see G8.1) |
| 0.2 User authenticates | not-started | **AC text only** — line 307 names ListAssist/APEX as the incumbents in the not-yet-activated banner scenario |
| 0.3 Reference data read-only API | not-started | **AC text only** — line 59 seeds "SSCS wave-1-relevant entries … flagged for confirmation against the SSCS as-is pack"; line 88 uses an SSCS-scoped requester as the filtering example |
| 0.4 User populations bootstrapped | not-started | **Fixture text only** — line 49 seeds `jo_jurisdictions` covering "Tribunals/SSCS + Courts examples"; add ET |
| 0.5 System dispatches emails | not-started | **None** |
| Phase 9+ (framework only) | not decomposed | **Rewritten** — wave sequence, gates, UAT panels, readiness assessment all retarget |

**No epic is added, removed, re-scoped, or resequenced.** Phase 0 remains 6 epics / 19 stories. Phases 1–8 remain undecomposed and are unaffected.

### 2.3 Artifact conflicts

**Canonical planning artifacts requiring edits (27 files):**

- `prd.md` — heaviest (61 SSCS, 32 ListAssist, 37 wave-2, 75 D-refs): Executive Summary, Target Users working set (lines 91–98), Success Criteria, Measurable Outcomes, Product Scope, Journey 1, Phase-by-Phase mapping, Integration Requirements, FR60, NFR21/24/32/36/38/41, decision table (D5, D8, D11), Glossary
- `business-case.md` — Decision Sought, Strategic Case drivers, Options appraisal, Scope, Benefits, Roadmap, Risks, Assumptions, Recommendation, Asks
- `architecture.md` + `architecture-summary.md` — technical constraints, external systems, deployment topology, wave gates, implementation sequence, TBD #6, validation scope note
- `architecture/` shards (11): `user-types.md`, `data-tables.md`, `gaps.md`, `conventions.md`, `repository-strategy.md`, `repo-structure.md`, `functional-requirements-coverage.md`, `non-functional-requirements-coverage.md`, `sequence-diagrams/payment-batch-flow.md`, `sequence-diagrams/joh-onboarding-and-sitting-generation.md`, `changelog.md` (**append v4.0 entry only**)
- `epics/` (8): `index.md`, `framework.md`, `fr-coverage-map.md`, `requirements-inventory.md`, `phase-0/index.md`, `phase-0/epic-0.2`, `epic-0.3`, `epic-0.4`

**Repo-level files (4):** `CLAUDE.md` (line 9) · `README.md` (line 9) · `_bmad-output/project-context.md` (line 71) · `scripts/python/build_html.py` (add this SCP to `NAV`)

**Immutable — add, never rewrite** (per the repo's working conventions): the 6 prior Sprint Change Proposals, the 5 Implementation Readiness Reports, the 2 PRD Validation Reports, and all existing `architecture/changelog.md` rows. Their SSCS content is a correct record of what was decided then. The two SSCS-labelled `NAV` strings in `build_html.py` (lines 239, 241) are historical labels and stay.

**Out of scope — read-only sources:** `docs/architecture/asis/**` (the JI/Courts as-is pack — source documents), `queries/sscs-locations-queries.md` (legacy/exploratory root).

**Generated:** `docs/**` — regenerate via `scripts/build-html.sh`; never hand-edit.

### 2.4 Technical impact

**None.** No code exists. No schema migration, no API contract change, no infrastructure change, no deployment change. The `delivery/` control plane needs no edit — `dispatch-graph.yaml` carries no jurisdiction references and the ledger shards are jurisdiction-neutral.

### 2.5 New risks and open questions — the substantive cost of this change

The edits are mechanical. **The risk is in what we do not yet know about ET.** Five items, ranked:

**R1 — ET's judicial-scheduling incumbent is unidentified.** *(Severity: High — blocking)*
ListAssist was SSCS's scheduling incumbent and is load-bearing across **D5** (behavioural reference), **FR60** and **NFR41** (manual UAT parity target), **NFR36** (rollback target), **NFR32** (where historical data stays), **G8.3** (historical-access window), and the business case's benefit statement ("retirement of ListAssist"). Until ET's equivalent is named, all seven remain parameterised. Note the business case already records that even SSCS scheduling is fragmented — ListAssist is "used by Cardiff only … and other legacy systems used by other SSCS jurisdictions" — so ET may likewise have no single incumbent.

**R2 — ET's JOH type taxonomy is unconfirmed.** *(Severity: High)*
The repo holds **zero** ET evidence. Working understanding, **requiring confirmation against an ET as-is analysis pack**: Employment Judges (salaried and fee-paid), Regional Employment Judges, and **non-legal ("lay") members** drawn from two panels — one with employer-side experience, one with employee-side experience. This is structurally analogous to SSCS's Medical / Disability-Qualified / Disability (Other) members and fits the existing JOH abstraction, but the specific types, panel-composition rules and role names must be verified, not assumed. Treat every ET role name in the cascade as provisional until the pack lands.

**R3 — JFEPS/Liberata applicability to ET is unverified.** *(Severity: Medium–High)*
NFR21 asserts the JFEPS Excel → Payment Authoriser → Liberata path is preserved unchanged for wave 1. That was **explicitly verified for SSCS** — `sequence-diagrams/payment-batch-flow.md` records "SSCS applicability verified (2026-06-11) … tribunal-member payments use the same JFEPS Excel + email-to-Authoriser + Liberata path". **No equivalent verification exists for ET.** If ET lay members are paid through a different route, NFR21 weakens and Phase 6 acquires wave-1 risk it does not currently carry. This verification must be redone.

**R4 — eLinks `jo_jurisdictions` coverage of ET is unverified.** *(Severity: Medium)*
G8.1 already flags the eLinks contract as unconfirmed. ET's presence, and its parent-child shape under Tribunals, is now a **wave-1 blocker** rather than a general Phase 0 concern.

**R5 — the business case's supporting evidence was gathered for SSCS.** *(Severity: Low–Medium; downgraded 2026-08-07 on confirmation that ET is a settled programme decision)*
Option C was recommended on the grounds that "SSCS is a contained, lower-risk wave that exercises the full platform end-to-end and de-risks every subsequent wave". **The choice of ET is settled and not reopened by this SCP.** What remains is *evidence*: the wave-1 replacement driver and ET's quantified risk profile, both of which the ET as-is analysis pack (G8.5) supplies. The business case is retargeted with those two items flagged as outstanding evidence rather than open questions.

**Also to confirm:** ET's case-management system — the GAPS analogue that will consume RAM's APIs per D12 (retained, not replaced).

**Net position on prior work:** the SSCS-cohort readiness assessment and SSCS as-is analysis pack were both *required but never produced*. Demoting SSCS to wave 2 therefore **loses no completed work** — it defers two un-started deliverables and raises two new ET equivalents in their place.

---

## Section 3 — Recommended Approach

### Options evaluated

| Option | Viable? | Effort | Risk | Notes |
|---|---|---|---|---|
| **1 — Direct Adjustment** | ✅ **Yes** | Medium–High (volume) | Low–Medium | No code, no FR/NFR churn, no epic churn. Risk sits in R1–R5, not in the edits. |
| **2 — Rollback** | ❌ N/A | — | — | Nothing built. Nothing to revert. |
| **3 — MVP Review** | ⚠️ **Partial** | Low | Medium | Not needed for architecture or epics. **Required for the business case** (R5). |

### Recommended: **Hybrid — Direct Adjustment + business-case evidence refresh, sequenced behind discovery**

**Rationale.** The architecture needs no redesign — D8 anticipated exactly this. But running a 27-file, ~250-reference cascade *before* R1 and R2 are answered would write "TBD" into hundreds of places and force a second full sweep. That is the failure mode the repo's own convention warns against ("sweep first, don't blind find-replace").

**Therefore: parameterise the unknown rather than deferring the cascade.**

Introduce a single placeholder token — **`[ET-INCUMBENT-TBD]`** — for the ET scheduling incumbent, and use it consistently everywhere ListAssist currently appears in a wave-1 role. Everything else (jurisdiction, wave numbering, decision text, roles, journey, glossary, gates) is written definitively in one pass. When R1 resolves, closing it out is a **single mechanical token replacement**, not a re-analysis.

Apply the same discipline to R2: mark every ET role name with an explicit *provisional — pending ET as-is pack* flag rather than presenting assumed names as settled.

### Proposed sequencing

| Step | Action | Blocked by |
|---|---|---|
| **1** | Approve this SCP | — |
| **2** | Open four discovery items: R1 incumbent · R2 role/panel taxonomy · R3 JFEPS applicability · R4 eLinks ET coverage | — |
| **3** | Run the documentation cascade with `[ET-INCUMBENT-TBD]` + provisional role flags; add `architecture/changelog.md` **v4.0**; regenerate `docs/` | Step 1 |
| **4** | Refresh the business case's ET evidence (R5) — driver + risk profile; the jurisdiction choice itself is settled | Step 5 |
| **5** | Commission the **ET as-is analysis pack** (replaces the SSCS pack as the wave-1 blocker; the SSCS pack defers to wave 2) | Step 2 |
| **6** | Resolve `[ET-INCUMBENT-TBD]` → single token sweep | Step 5 |
| **7** | Re-run `bmad-check-implementation-readiness` — an **ET-cohort** assessment | Steps 3, 6 |

**Timeline impact on the build:** **none.** Phases 0–8 are jurisdiction-agnostic and can proceed on the current dispatch graph regardless. Only the **Phase 9 cutover** depends on ET discovery — and Phase 9 was already gated on a cohort readiness assessment that had not begun.

**Note on readiness:** the last Implementation Readiness Report (2026-06-17) already predates SCPs 2026-07-06, -07-07 and -07-09. Step 7 closes all four gaps in one pass.

---

## Section 4 — Detailed Change Proposals

### 4.1 Decisions

**New D13 — supersedes D11.** *(PRD decision table)*

> **D13 (new 2026-08-07; supersedes D11) — ET-first pilot wave.** RAM Pathfinder's MVP pilot rollout (Phase 9, wave 1) targets the **Employment Tribunals (ET)** jurisdiction. **Wave 2 = the SSCS Tribunals jurisdiction** (replacing ListAssist; GAPS, the SSCS case-management system, is retained per D11 as amended). **Waves 3+ = Courts jurisdictions** (Civil, Crime, Family, Crown) per HMCTS judicial region, replacing APEX/JI. The 16-repo architecture and the Phase 0–8 build sequence are **unchanged** — jurisdiction is a first-class upstream-sourced attribute per D8, so retargeting the pilot is a data-and-rollout change, not an architectural one.
>
> **ET's judicial-scheduling incumbent is not yet identified** (gap G8.4). Until it is, the wave-1 behavioural reference, manual-UAT parity target, rollback target and historical-data location are recorded as `[ET-INCUMBENT-TBD]`.
>
> **ET JOH type taxonomy is provisional** pending the ET as-is analysis pack (gap G8.5): Employment Judges (salaried and fee-paid), Regional Employment Judges, and non-legal ("lay") members drawn from employer-side and employee-side panels. The JOH umbrella term and the existing `ram-joh` / `ram-booking` / `ram-sitting` decomposition accommodate these without structural change. **Panel composition and hearing types remain out of RAM scope per D12.**

**D11** — retained as history, re-scoped: "SSCS-first pilot" → "**SSCS wave**", superseded by D13 for wave ordering.
**D5** — parity reference re-parameterised: `[ET-INCUMBENT-TBD]`-experienced users (wave 1) · ListAssist-experienced (wave 2) · APEX-experienced (waves 3+).
**D8** — wave sequence restated: wave 1 = ET, wave 2 = SSCS, waves 3+ = Courts per region. Hierarchy mechanism unchanged.
**D12** — unchanged; the external case-management consumer for wave 1 becomes ET's system (to confirm) rather than GAPS.

### 4.2 The `[^d11]` footnote — one edit, ~20 files

**OLD** (repeated verbatim across ~20 files):
```
[^d11]: D11 (2026-06-10, amended 2026-06-18) — SSCS-first pilot: wave 1 replaces
**ListAssist** (the SSCS judicial-scheduling tool); **GAPS (SSCS case management)
is retained, not replaced**; waves 2+ replace JI/APEX per Courts region.
```

**NEW:**
```
[^d13]: D13 (2026-08-07, supersedes D11) — ET-first pilot: wave 1 = the **Employment
Tribunals** jurisdiction (incumbent `[ET-INCUMBENT-TBD]`, gap G8.4); wave 2 = **SSCS**
(replaces **ListAssist**; **GAPS**, SSCS case management, is retained); waves 3+ replace
JI/APEX per Courts region.
```

*Rationale:* retains the SSCS/ListAssist/GAPS relationship correctly at its new wave position while retargeting wave 1. Citations change `[^d11]` → `[^d13]` in running text; the `[^d11]` definition is retained where a passage genuinely refers to the original decision.

### 4.3 Wave renumbering — 100 lines across 24 files

Every "waves 2+ (Courts)" becomes "waves 3+ (Courts)", and a new wave-2 (SSCS) tier is inserted. This is **not** a safe find-replace: "wave 2" also appears in phrases like "each subsequent wave" and in the immutable historical reports. Apply file-by-file against the sweep inventory in §2.3.

Canonical three-tier phrasing to use throughout:

> wave 1 = the **Employment Tribunals** jurisdiction; wave 2 = the **SSCS** Tribunals jurisdiction; waves 3+ = **Courts** jurisdictions per HMCTS judicial region

### 4.4 PRD — Target Users (lines 91–98)

**OLD:**
```
*SSCS Tribunals jurisdiction (wave 1) — applicable roles will be enumerated against
the ListAssist as-is analysis pack (parallel to the JI pack under
`docs/architecture/asis/`). Working set:*

- Regional Tribunal Judges (RTJ) — JOHs
- Tribunal Judges, salaried and fee-paid — JOHs
- Tribunal Members — Medical, Disability-Qualified, Disability (Other) — JOHs
- Tribunal Caseworkers / scheduling admin
- Finance / Payment Authoriser (shared with Courts jurisdiction — JFEPS path preserved)
- MI / Reporting User (shared with Courts jurisdiction)
```

**NEW:**
```
*Employment Tribunals jurisdiction (wave 1) — **PROVISIONAL**; applicable roles will be
enumerated against the **ET as-is analysis pack** (gap G8.5; parallel to the JI pack
under `docs/architecture/asis/`). Working set, pending confirmation:*

- Regional Employment Judges — JOHs
- Employment Judges, salaried and fee-paid — JOHs
- Non-legal ("lay") members — employer-side and employee-side panels — JOHs
- ET scheduling / listing admin staff
- Finance / Payment Authoriser (shared — JFEPS path applicability to ET pending
  verification, gap G8.6)
- MI / Reporting User (shared across jurisdictions)

*SSCS Tribunals jurisdiction (wave 2) — as previously enumerated: Regional Tribunal
Judges (RTJ), Tribunal Judges (salaried and fee-paid), Tribunal Members (Medical,
Disability-Qualified, Disability (Other)), Tribunal Caseworkers, Finance / Payment
Authoriser, MI / Reporting User.*
```

*Rationale:* preserves the SSCS working set verbatim at wave 2 (no analysis lost), marks the ET set provisional so downstream readers do not treat assumed role names as settled, and links each unknown to a numbered gap.

### 4.5 PRD — Journey 1

Journey 1 (Asha, SSCS Tribunal Caseworker, Medical Member cover) **moves to the wave-2 position** and a **new ET Journey 1** is authored covering the same service chain — absence → vacancy → booking → sitting → payment — with ET roles and a lay-member cover scenario. Journey numbering otherwise holds; the Phase-by-Phase mapping table and the "six journeys" count update accordingly.

**Deferred to the ET as-is pack:** the ET journey's persona, panel-composition trigger and off-system advertising process cannot be written credibly until R2 resolves. Draft it as a **structural placeholder** in this cascade and complete it at Step 5.

### 4.6 PRD — Glossary

**Add:** `Employment Tribunals (ET)` · `Employment Judge` · `Regional Employment Judge` · `Non-legal member (lay member)` · `[ET-INCUMBENT-TBD]` (placeholder entry stating the unknown explicitly).
**Amend:** `SSCS` (wave-1 → wave-2 jurisdiction) · `ListAssist` (wave-1 → wave-2 parity reference) · `GAPS` (retained; wave-2 context) · `RTJ`, `Tribunal Member`, `Tribunal Panel` (relabel as SSCS/wave-2 concepts).
**Unchanged:** `Jurisdiction` — the hierarchy definition already accommodates ET as a Tribunals child.

### 4.7 Architecture — new gaps

Append to `architecture/gaps.md`:

| Gap | Statement | Resolution path |
|---|---|---|
| **G8.4** | **ET's judicial-scheduling incumbent is unidentified.** Blocks D5 (behavioural reference), FR60/NFR41 (UAT parity target), NFR36 (rollback target), NFR32 (historical-data location), and the business case's benefit statement. Recorded as `[ET-INCUMBENT-TBD]` throughout. | Confirm with the ET programme; settle in the ET as-is analysis pack. Closes when the incumbent is named and the token is swept. |
| **G8.5** | **ET JOH type taxonomy and role set are unconfirmed.** No ET evidence exists in the repo. Working assumption: Employment Judges (salaried/fee-paid), Regional Employment Judges, non-legal members (employer-side / employee-side panels). | **ET as-is analysis pack** — a new wave-1 deliverable, parallel to the JI pack under `docs/architecture/asis/`. The SSCS pack defers to wave 2. |
| **G8.6** | **JFEPS/Liberata applicability to ET is unverified.** SSCS applicability was explicitly verified (2026-06-11, `payment-batch-flow.md`); no ET equivalent exists. If ET lay members are paid by another route, NFR21 weakens and Phase 6 acquires wave-1 risk. | Re-run the payment-flow applicability verification for ET before the Phase 6 gate. |

**Amend G8.1** — eLinks `jo_jurisdictions` coverage of ET is promoted from a general Phase 0 concern to a **wave-1 blocker**.
**Amend G8.3** — retarget from "ListAssist historical access for wave 1" to "`[ET-INCUMBENT-TBD]` historical access for wave 1"; the ListAssist question survives at wave 2.

### 4.8 Epic AC edits (3 lines, all text-only)

```
Epic 0.2 — line 307 · Acceptance criteria, not-yet-activated banner
OLD: … the incumbent is ListAssist for SSCS wave 1, APEX for Courts waves 2+
NEW: … the incumbent is [ET-INCUMBENT-TBD] for ET wave 1, ListAssist for SSCS
     wave 2, APEX for Courts waves 3+
```
```
Epic 0.3 — line 59 · Acceptance criteria, reference-data seed values
OLD: … include the SSCS wave-1-relevant entries (e.g. session and work types
     applicable to tribunal sittings) flagged for confirmation against the SSCS
     as-is pack
NEW: … include the ET wave-1-relevant entries (e.g. session and work types
     applicable to Employment Tribunal sittings) flagged for confirmation against
     the ET as-is pack (G8.5)
```
```
Epic 0.3 — line 88 · Acceptance criteria, jurisdiction filtering example
OLD: … e.g. an SSCS-scoped requester sees Tribunals/SSCS-relevant entries
NEW: … e.g. an ET-scoped requester sees Tribunals/ET-relevant entries
```
```
Epic 0.4 — line 49 · Acceptance criteria, jo_jurisdictions fixtures
OLD: … `jo_jurisdictions` covering Tribunals/SSCS + Courts examples
NEW: … `jo_jurisdictions` covering Tribunals/ET + Tribunals/SSCS + Courts examples
```

*Rationale:* these are illustrative examples inside acceptance criteria. **No story is added, removed, or re-scoped; no acceptance criterion changes shape.** Phase 0 stays at 6 epics / 19 stories.

### 4.9 Business case — retarget, with two evidence items outstanding

**ET as wave 1 is a settled programme decision** (confirmed 2026-08-07); the case is written on that basis, not as a proposal. Mechanical retargeting (Decision Sought, Scope, Roadmap, Benefits, Asks) is straightforward. **Two items carry SSCS-gathered evidence that does not transfer, and are flagged inline as outstanding rather than as open questions:**

- **Strategic Case, driver #2** — currently "SSCS scheduling depends on ListAssist, a separate aged tool". The ET equivalent lands with G8.4.
- **Options appraisal, Option C** — the "contained, lower-risk wave" risk profile was assessed for SSCS. ET's equivalent lands with the ET as-is analysis pack (G8.5).

### 4.10 Repo-level and generated

- `CLAUDE.md` line 9 · `README.md` line 9 — programme summary retargeted to the three-tier wave sequence
- `_bmad-output/project-context.md` line 71 — incumbent-parity rule: `(ET [ET-INCUMBENT-TBD] wave 1 / ListAssist SSCS wave 2 / APEX Courts waves 3+)`
- **`.claude/memory/project_bmad_ram_pathfinder_state.md`** (git-tracked working-state file) — **highest misdirection risk of any file in this list.** Its "Next" and "Remaining cascade" sections instruct the next session to run an *SSCS-cohort* readiness assessment and commission an *SSCS as-is analysis pack*; both now retarget to ET. Line 10 additionally carries pre-v3.7 staleness ("SSCS jurisdiction (replacing GAPS)") that the 2026-06-18 correction never reached. Retarget the forward-looking sections; leave the dated **Done** entries as history.
- `scripts/python/build_html.py` — add `("Sprint Change Proposal — 2026-08-07 (ET-first pilot)", "sprint-change-proposal-2026-08-07", False)` to `NAV`. Leave the two historical SSCS-labelled `NAV` strings (lines 239, 241) untouched.
- `architecture/changelog.md` — **append v4.0** ("Wave-1 pilot retargets SSCS → Employment Tribunals; SSCS to wave 2; Courts to waves 3+; D13 supersedes D11; new gaps G8.4–G8.6"). Existing rows are immutable history.
- `docs/**` — regenerate via `scripts/build-html.sh`. Never hand-edit.

---

## Section 5 — Implementation Handoff

**Change scope: Major.** Documentation-only with zero code impact, but it supersedes D11 — the decision that drove the largest cascade in this project's history (architecture v3.0) — re-sequences every rollout wave, and reopens the business case's core justification. It needs PM/Architect judgement, not just an editor.

| Recipient | Responsibility |
|---|---|
| **Product Manager** | Own D13. Refresh the business case's ET evidence once G8.4/G8.5 land (R5 / §4.9) — the jurisdiction choice is settled; the driver and risk profile are the outstanding inputs. Confirm SSCS's wave-2 position with the programme. |
| **Solution Architect** | Own the cascade across `architecture.md`, the 11 shards, and the epics. Append changelog v4.0. Raise G8.4–G8.6; amend G8.1 and G8.3. |
| **Business Analyst** | Commission and produce the **ET as-is analysis pack** — the long pole. It gates G8.4, G8.5 and the ET Journey 1. |
| **Product Owner** | Apply the four epic AC edits (§4.8). Confirm the ledger and dispatch graph need no change (verified: they do not). |

**Success criteria**

1. `grep -ri "sscs" _bmad-output/planning-artifacts/` returns hits **only** in wave-2 contexts and in immutable historical reports.
2. No line asserts "waves 2+ = Courts". The three-tier sequence reads consistently in all 24 affected files.
3. `[ET-INCUMBENT-TBD]` appears wherever wave 1 needs an incumbent, and **nowhere is an ET incumbent asserted as fact**.
4. Every provisional ET role name carries its *pending ET as-is pack* flag.
5. Phase 0 is still 6 epics / 19 stories; `dispatch-graph.yaml` and `delivery/ledger/` are unchanged.
6. `architecture/changelog.md` has a v4.0 row; no prior row is altered.
7. `scripts/build-html.sh` runs clean and this SCP appears in the site nav.
8. G8.4, G8.5, G8.6 are open with named owners.

**Explicitly not done in this run:** resolving G8.4–G8.6 · producing the ET as-is pack · the ET-cohort readiness assessment · decomposing phases 1–8.

---

## Appendix — Sweep inventory (2026-08-07)

| File | SSCS | ListAssist | wave 2 | Action |
|---|---:|---:|---:|---|
| `prd.md` | 61 | 32 | 37 | Full cascade |
| `prd-validation-report-2026-06-10.md` | 37 | — | 4 | **Immutable** |
| `sprint-change-proposal-2026-06-10.md` | 32 | — | 8 | **Immutable** |
| `architecture.md` | 22 | 13 | 12 | Full cascade |
| `business-case.md` | 18 | 8 | 6 | Cascade + evidence refresh (2 items) |
| `prd-validation-report-2026-06-17.md` | 12 | — | 1 | **Immutable** |
| `implementation-readiness-report-2026-06-17.md` | 9 | — | — | **Immutable** |
| `architecture-summary.md` | 8 | 6 | 4 | Full cascade |
| `epics/framework.md` | 6 | 3 | 3 | Cascade (Phase 9 section rewritten) |
| `epics/requirements-inventory.md` | 5 | 5 | 4 | Cascade |
| `sprint-change-proposal-2026-06-17.md` | 4 | — | — | **Immutable** |
| `epics/fr-coverage-map.md` | 4 | 2 | 2 | Cascade |
| `architecture/user-types.md` | 4 | 2 | 2 | Cascade + ET role placeholder |
| `architecture/data-tables.md` | 4 | 2 | 1 | Cascade (text only — no schema change) |
| `epics/phase-0/epic-0.3-…md` | 3 | 1 | 1 | 2 AC lines |
| `epics/index.md` | 3 | 2 | 2 | Cascade |
| `architecture/sequence-diagrams/payment-batch-flow.md` | 3 | — | — | Cascade + **G8.6 re-verification** |
| `architecture/non-functional-requirements-coverage.md` | 3 | 2 | 2 | Cascade |
| `architecture/gaps.md` | 3 | 2 | 1 | Cascade + G8.4–G8.6 |
| `epics/phase-0/index.md` | 2 | 2 | 1 | Cascade |
| `epics/phase-0/epic-0.4-…md` | 2 | — | — | 1 AC line |
| `architecture/functional-requirements-coverage.md` | 2 | 2 | 2 | Cascade |
| `architecture/conventions.md` | 2 | 2 | 2 | Cascade |
| `architecture/changelog.md` | 2 | 1 | 1 | **Append v4.0 only** |
| `epics/phase-0/epic-0.2-…md` | 1 | 1 | 1 | 1 AC line |
| `architecture/sequence-diagrams/joh-onboarding-…md` | 1 | 1 | 1 | Footnote |
| `architecture/repository-strategy.md` | 1 | 1 | 1 | Footnote |
| `architecture/repo-structure.md` | — | 1 | 1 | UAT-path note |
| `CLAUDE.md` | 1 | 1 | 1 | Programme summary |
| `README.md` | 1 | 1 | 1 | Programme summary |
| `_bmad-output/project-context.md` | 1 | 1 | — | Parity rule |
| `.claude/memory/project_bmad_ram_pathfinder_state.md` | 6 | — | 1 | Retarget forward-looking sections; **Done** entries immutable |
| `scripts/python/build_html.py` | 2 | — | — | **Add NAV row only** — existing labels immutable |
| `docs/architecture/asis/**` | 10 | — | — | **Read-only source — do not edit** |
| `queries/sscs-locations-queries.md` | n/a | — | — | Legacy/exploratory — out of scope |

---

*Generated by `bmad-correct-course` · Batch mode · 2026-08-07*
