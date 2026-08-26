---
type: 'Sprint Change Proposal Log'
description: 'Consolidated, chronological archive of every CTAM Pathfinder Sprint Change Proposal. Each entry below was previously its own dated file; merged into one file 2026-08-26 (SCP 2026-08-26). Content preserved verbatim per entry - only frontmatter, heading levels, and file boundaries changed.'
resource: 'sprint-change-proposal-log.html'
tags: [ctam-pathfinder, sprint-change-proposal]
timestamp: '2026-08-26'
title: 'Sprint Change Proposal Log'
---

# Sprint Change Proposal Log

This is the **consolidated, chronological archive** of every CTAM Pathfinder Sprint Change Proposal. Each entry below was previously its own file (`sprint-change-proposal-{date}.md`); all 29 were merged into this single file on 2026-08-26 (see the log's own last entry for the merge's own SCP). **Content is preserved verbatim per entry** — only frontmatter (folded into this intro), heading levels (each entry's own `#` demoted to `##` and below, to nest under this file's single H1), and the one-file-per-proposal boundary changed. Nothing about what any entry says has been rewritten.

> **Convention change**: prior entries in this repo's other documents cited these proposals by their old individual filenames (e.g. `sprint-change-proposal-2026-08-25h.md`) — those citations have been updated to anchor links into this file. Going forward, `bmad-correct-course` will still generate a new dated file by default (that default lives in the installed BMad skill, not in this repo); appending new runs into this log instead is a manual step, not automatic.

## Index

- [Sprint Change Proposal — 2026-05-15](#sprint-change-proposal-2026-05-15)
- [Sprint Change Proposal — 2026-06-10](#sprint-change-proposal-2026-06-10)
- [Sprint Change Proposal — 2026-06-17](#sprint-change-proposal-2026-06-17)  — Integrations-first Phase 0 carve-out
- [Sprint Change Proposal — 2026-07-06](#sprint-change-proposal-2026-07-06)  — Shared infrastructure to a dedicated repo (CNP alignment)
- [Sprint Change Proposal — 2026-07-07](#sprint-change-proposal-2026-07-07)  — Build-tool terminology clarification (Gradle vs Maven-format) + contract-placement read-only mirror
- [Sprint Change Proposal — 2026-07-09](#sprint-change-proposal-2026-07-09)  — CTAM-assigned JOH identity — personnel_number demoted to upstream link
- [Sprint Change Proposal — 2026-08-07](#sprint-change-proposal-2026-08-07)  — Wave-1 pilot jurisdiction changes from SSCS to Employment Tribunals (ET)
- [Sprint Change Proposal — 2026-08-13](#sprint-change-proposal-2026-08-13)  — Programme renamed RAM → CTAM (Court and Tribunals Availability Management)
- [Sprint Change Proposal — 2026-08-19](#sprint-change-proposal-2026-08-19)  — Agent delivery rules adopted; test gates amended (TDD evidence, coverage floor, mutation threshold)
- [Sprint Change Proposal — 2026-08-19b](#sprint-change-proposal-2026-08-19b)  — story-packet schema reconciled with the BMad story template; dispatch chain corrected
- [Sprint Change Proposal — 2026-08-19c](#sprint-change-proposal-2026-08-19c)  — the human gate moves from every commit to the pull request
- [Sprint Change Proposal — 2026-08-19d](#sprint-change-proposal-2026-08-19d)  — bespoke delivery tracking retired in favour of BMad sprint status; dispatch graph retired; arch-baseline promoted to Epic 0.6
- [Sprint Change Proposal — 2026-08-20](#sprint-change-proposal-2026-08-20)  — one branch per story, created at dispatch; story/{story-id} replaces feature/ for story work
- [Sprint Change Proposal — 2026-08-21](#sprint-change-proposal-2026-08-21)  — 2026-08-21 (bmad-create-story override retired; deviation register added)
- [Sprint Change Proposal — 2026-08-24](#sprint-change-proposal-2026-08-24)
- [Sprint Change Proposal — 2026-08-24b](#sprint-change-proposal-2026-08-24b)
- [Sprint Change Proposal — 2026-08-24c](#sprint-change-proposal-2026-08-24c)
- [Sprint Change Proposal — 2026-08-25](#sprint-change-proposal-2026-08-25)
- [Sprint Change Proposal — 2026-08-25b](#sprint-change-proposal-2026-08-25b)
- [Sprint Change Proposal — 2026-08-25c](#sprint-change-proposal-2026-08-25c)
- [Sprint Change Proposal — 2026-08-25d](#sprint-change-proposal-2026-08-25d)
- [Sprint Change Proposal — 2026-08-25f](#sprint-change-proposal-2026-08-25f)
- [Sprint Change Proposal — 2026-08-25g](#sprint-change-proposal-2026-08-25g)
- [Sprint Change Proposal — 2026-08-25h](#sprint-change-proposal-2026-08-25h)
- [Sprint Change Proposal — 2026-08-25i](#sprint-change-proposal-2026-08-25i)
- [Sprint Change Proposal — 2026-08-25j](#sprint-change-proposal-2026-08-25j)
- [Sprint Change Proposal — 2026-08-25k](#sprint-change-proposal-2026-08-25k)
- [Sprint Change Proposal — 2026-08-25l](#sprint-change-proposal-2026-08-25l)
- [Sprint Change Proposal — 2026-08-25m](#sprint-change-proposal-2026-08-25m)
- [Sprint Change Proposal — 2026-08-26](#sprint-change-proposal-2026-08-26)  — this file's own consolidation

---

## Sprint Change Proposal — 2026-05-15

### 1. Issue Summary

Two product-direction decisions taken on **2026-05-15** require propagation into the PRD, the Phase 0 epics, and supporting reference documents:

#### Trigger A — Admin UI removed from MVP

The product team has decided that **`ctam-admin-ui`** — the entire admin-facing SPA, including its Reference Data maintenance, Users & Roles admin, Migration Reports, and Activation Toggle modules — is **not in scope for MVP** and moves to the post-MVP roadmap. Admin-write API endpoints on `ctam-reference-data` and `ctam-authorisation` likewise move post-MVP. The data layer remains in MVP: reference data and users are loaded via direct-SQL ETLs; ongoing operational maintenance is performed by DBAs via direct SQL per runbooks; named-owner sign-off happens via versioned git commits.

**Evidence:** product-direction decision recorded 2026-05-15 in a prior conversation turn; phase-0 epic stories were already restructured to remove admin UI stories (5 stories cut, 1 moved, count went 18 → 11). PRD and the Decisions Log had not yet been formally updated.

#### Trigger B — `gh` CLI not available in the engineering environment

The engineering environment does not have the GitHub CLI (`gh`) available. All GitHub admin operations (private repo creation, branch protection on `main`, team / CODEOWNERS access, PR open / review / merge) must be performed **manually via the GitHub web UI**. Story 0.1.1 previously specified `gh CLI configured` as a precondition; that and the implicit "scaffold script creates the GitHub repo" assumption are no longer valid.

**Evidence:** direct user statement on 2026-05-15.

### 2. Impact Analysis

#### Epic impact

| Epic | Impact |
|---|---|
| Phase 0 Epic 0.1 (user authenticates) | Story 0.1.1 first AC block rewritten (manual GitHub setup runbook + plain `git push`); Story 0.1.1 third AC block clarifies manual PR open via web UI; Story 0.1.2 scaffold-mock-auth precondition + Story 0.1.4 scaffold-`ctam-ui` precondition updated. Story 0.1.3 already reflects read-only API surface from prior turn. |
| Phase 0 Epic 0.2 (Ref Data) | Story 0.2.1 scaffold precondition updated for manual GitHub web UI. Stories 0.2.2 (read-only API) and 0.2.3 (SQL ETL) already updated in prior turn. |
| Phase 0 Epic 0.3 (Users/Roles) | No further story changes — Story 0.3.1 (SQL ETL) was already updated in prior turn. |
| Phase 0 Epic 0.4 (Notification) | Story 0.4.1 scaffold precondition updated for manual GitHub web UI. Story 0.4.2 already reflects user-JWT-only (no `client_credentials`) from prior turn. |
| Future Phases 1–9+ | Inherit AR2 (revised) + AR51 automatically when storied. Stories generated after 2026-05-15 will pick up the manual-GitHub-setup pattern without per-story restatement. |

#### Artefact conflicts (resolved in this proposal)

| Artefact | Conflict | Resolution |
|---|---|---|
| **PRD** | FR4 / FR6 / FR56 / FR58 wording implied admin UI in MVP. MVP scope section listed "Modern UI for all 11 user roles" without distinguishing business vs admin. Explicit MVP exclusions list did not mention admin UI. Decisions Log lacked the 2026-05-15 decision. | FR4, FR6, FR56, FR58 wording amended with "(scoped 2026-05-15 per D10)" clarifiers. MVP scope tweaked to distinguish business UI (in) vs admin UI (out). Admin UI items added to "Explicit exclusions from MVP". Growth Features section enriched with `ctam-admin-ui` deliverables. **New D10 decision added to the Decisions Log** capturing both Trigger A and Trigger B. D9 wording amended to reference D10 (load via SQL, not via API). Phase 0 "platform smoke-test" characteristic updated. Document Map line updated D1–D9 → D1–D10. |
| **Architecture-derived requirements (AR list)** | AR2 wording implied scaffold script handles repo creation. | AR2 amended; **new AR51 added** documenting the manual-GitHub-setup constraint and runbook. |
| **Phase 0 epic stories** | Story 0.1.1, 0.1.2, 0.1.4, 0.2.1, 0.4.1 implicitly relied on `gh` CLI. | All five scaffold-precondition AC blocks updated with explicit manual web-UI setup steps + reference to `ctam-architecture/runbooks/github-setup.md`. |
| **FR coverage map** | Already reflected MVP/post-MVP split from prior turn. | No further changes needed. |
| **Phase 0 index** | Already reflected the revised story count and FRs deferred post-MVP. | No further changes needed. |
| **Validation report (2026-05-15)** | Already reflected the revised scope from prior turn; the validation report's "Recommend updating the PRD" item is now satisfied by this proposal. | No further changes needed. |

#### Technical impact

- **Branch protection setup** — manual via Settings → Branches on GitHub web UI (per repo)
- **CODEOWNERS, PULL_REQUEST_TEMPLATE.md** — still committed via git as usual; no special tooling needed (just files in the repo)
- **PR open / review / merge** — manual web UI; no `gh` CLI invocations
- **`ctam-scaffold.sh`** — script implementation simplifies (no `gh repo create`, no `gh api` calls for branch protection); plain `git init` + `git remote add` + `git push` only
- **`ctam-architecture/runbooks/github-setup.md`** — new artefact, owned by Story 0.1.1; documents the canonical "before you scaffold" checklist

### 3. Recommended Approach

**Direct Adjustment.** Both triggers can be addressed by amending existing PRD wording + adding a single new decision (D10) + a single new AR (AR51) + targeted scaffold-AC tweaks. No epic reordering, no rollback, no MVP redefinition beyond what was already storied.

- **Effort:** Low — wording-only changes plus the runbook deliverable (Story 0.1.1 picks it up)
- **Risk:** Low — these changes reflect already-made product decisions
- **Timeline:** No impact on Phase 0 sequencing or per-story sizing (the scaffold stories don't grow materially in complexity)

### 4. Detailed Change Proposals (applied in this turn)

#### 4.1 PRD edits

**Document Map** — D1–D9 → D1–D10.

**Executive Summary § Key characteristic 4 (Phase 0 platform smoke-test)** — reword: "via the Reference Data and Authorisation APIs" → "via direct SQL INSERT per D10"; reword API-as-Product exercise from "Reference Data writes" to "Reference Data read endpoints".

**MVP — Minimum Viable Product** bullet 3 — "Modern UI for all 11 user roles replicating APEX layouts (D4)" → "Modern **business-user UI** for all 11 judicial/operational roles replicating APEX layouts (D4) … through `ctam-ui`. Admin UI (`ctam-admin-ui`) is NOT in MVP per D10 (2026-05-15 scope decision); admin tasks in MVP — reference-data maintenance, user/role/scope updates, activation toggles, migration-report review — happen via direct SQL by DBAs per operational runbooks."

**MVP § Explicit exclusions** — added admin UI + admin-write API endpoints to the exclusion list, with the four MVP-deferred admin-UI modules itemised.

**Growth Features (Post-MVP)** — added `ctam-admin-ui` + admin-write API endpoints as the first bullet (with the four MVP-deferred modules itemised) to make the post-MVP commitment explicit.

**FR4 / FR6 / FR56 / FR58** — each amended with "(scoped 2026-05-15 per D10)" qualifier, stating: data layer in MVP, UI surface post-MVP, and pointing to Growth Features for the UI commitment.

**Decisions Log D9** — amended to note D10 supersedes its "load via the CTAM Pathfinder Authorisation API" wording.

**Decisions Log D10 (new)** — captures both Trigger A (admin UI → post-MVP) and Trigger B (no `gh` CLI); references the revised Phase 0 epic plan.

#### 4.2 Architecture-derived requirements edits

**AR2** — added 2026-05-15 revision note: `gh` CLI not available; scaffold script handles only local scaffolding + `git push`; GitHub admin operations are manual web-UI work per `ctam-architecture/runbooks/github-setup.md`.

**AR51 (new)** — codifies the manual GitHub setup constraint as a non-negotiable environment constraint; declares the runbook location; explicitly notes that PRs are opened / reviewed / merged via the web UI.

#### 4.3 Story edits (Phase 0)

**Story 0.1.1 (Scaffold `ctam-authorisation`)** — first AC block rewritten:
- Removed `gh CLI configured` from "Given" environment
- Added a leading precondition AC about the engineer manually creating the empty GitHub repo + enabling branch protection + the runbook reference
- Rewrote the corresponding "Then" line — scaffold script scaffolds locally and pushes via plain `git`; the GitHub repo exists already
- Third AC block (PR + CI) updated to specify "opens a PR via the GitHub web UI"
- Fourth AC block (PR merged) updated to specify "merged via the GitHub web UI"
- Vertical-slice description updated to list the new `ctam-architecture/runbooks/github-setup.md` runbook as a Phase 0 deliverable
- References line updated to include D10 + the runbook reference

**Story 0.1.2 (Scaffold `ctam-mock-auth`)** — first AC block updated to require manual pre-creation of the GitHub repo per the runbook.

**Story 0.1.4 (Scaffold `ctam-ui`)** — first AC block updated to require manual pre-creation of the GitHub repo per the runbook + plain `git push`.

**Story 0.2.1 (Scaffold `ctam-reference-data`)** — first AC block updated to require manual pre-creation per the runbook.

**Story 0.4.1 (Scaffold `ctam-notification`)** — first AC block updated to require manual pre-creation per the runbook.

### 5. Implementation Handoff

**Scope:** Moderate (PRD + architecture-derived requirements + 5 stories — all reflect existing product decisions, not new design work).

**Routed to:**

1. **Developer agent** (Story 0.1.1 first implementation) — picks up the now-explicit GitHub-setup runbook deliverable as part of Story 0.1.1 acceptance. The runbook is a small markdown file documenting the GitHub web-UI steps (~half-hour deliverable).
2. **Sprint planning** (`bmad-sprint-planning`) — can now run cleanly against the revised Phase 0 stories without ambiguity about admin UI scope or `gh` CLI availability.
3. **Future-phase story authors** (`bmad-create-epics-and-stories` for Phases 1–9+) — will inherit AR2 (revised) + AR51 automatically. No per-phase restatement of the manual-GitHub-setup pattern needed; just reference AR51.

**Success criteria:**

- Story 0.1.1's GitHub-setup runbook artefact exists at `ctam-architecture/runbooks/github-setup.md`
- No Phase 0 story AC mentions `gh` CLI or assumes scripted GitHub repo creation
- PRD Decisions Log includes D10 and references it from FR4/FR6/FR56/FR58
- The `epics/fr-coverage-map.md` post-MVP roadmap matches the PRD's Growth Features section
- Re-running `bmad-check-implementation-readiness` no longer flags FR4 / FR6 / FR56 / FR58 as "MVP requirements not delivered" — they're now correctly scoped MVP-data-layer + post-MVP-UI

### 6. Workflow Completion

- **Issue addressed:** (A) Admin UI removed from MVP per 2026-05-15 product-direction decision; (B) `gh` CLI not available in engineering environment
- **Change scope:** Moderate (PRD + AR + 5 stories)
- **Artefacts modified (in this turn):** `prd.md`, `epics/requirements-inventory.md`, `epics/phase-0/epic-0.1-user-authenticates.md`, `epics/phase-0/epic-0.2-admin-manages-ref-data.md`, `epics/phase-0/epic-0.4-system-dispatches-emails.md`
- **Artefacts already updated in prior turn (re-validated by this proposal):** `epics/phase-0/index.md`, `epics/fr-coverage-map.md`, `epics/phase-0/epic-0.3-admin-manages-users-roles.md`, `epics/phase-0/validation-report-2026-05-15.md`
- **Sprint Change Proposal document:** this file (`#sprint-change-proposal-2026-05-15`)

---

## Sprint Change Proposal — 2026-06-10

### 1. Issue Summary

Six product-direction decisions, communicated by the Product Manager during the **Correct Course** workflow run on **2026-06-10**, require structural amendments to the PRD and cascade into multiple downstream artefacts:

#### Trigger A — SSCS-first pilot wave

CTAM Pathfinder's MVP pilot rollout (Phase 9, wave 1) targets the **SSCS** jurisdiction within the Tribunals jurisdiction, not a single HMCTS Courts judicial region as previously documented. CTAM Pathfinder replaces **GAPS** (SSCS's incumbent scheduling system, expected to be decommissioned) for the SSCS cohort in wave 1; APEX/JI continues to serve Courts users in waves 2+. The 11-service architecture and Phase 0–8 build sequence are unchanged.

**Evidence:** direct stakeholder statement, 2026-06-10.

#### Trigger B — No legacy data migration

CTAM Pathfinder does **not** migrate data from any legacy system (APEX, GAPS). Judicial-holder reference data is sourced from upstream APIs — **JOH eLinks API** (canonical source for the 15 `jo_*` entities listed in the revised D3) and **MRD (Master Reference Data)** via a weekly Excel feed pending availability of MRD's public APIs. Historical data stays in the cohort's incumbent system and is accessed there as needed. The Phase 0 Data Migration ETL is retracted; the directory `ctam-architecture/migration/` is no longer a deliverable.

**Evidence:** direct stakeholder statement, 2026-06-10.

#### Trigger C — Two distinct user populations

CTAM Pathfinder serves two distinct user populations, both authenticating via the HMCTS IdP tenant but identified through different lookup paths: (a) **Judicial Office Holders (JOHs)** — IdP email looked up against `jo_people` to resolve the personal number (canonical CTAM identifier); (b) **HMCTS administrative staff** — RSU, Court users, Tribunal Caseworkers, Finance/Payment Authoriser, MI/Reporting users — *not present* in JOH eLinks data; CTAM maintains a separate CTAM-internal staff identity table. Both populations share the same authorisation model.

**Evidence:** direct stakeholder statement, 2026-06-10.

#### Trigger D — Jurisdiction as first-class hierarchical data dimension

Jurisdiction (e.g. Tribunals/SSCS, Courts/Civil, Courts/Crime) is a first-class attribute in `ctam-authorisation` (user scope) and `ctam-reference-data` (API filtering). Modelled as a **hierarchy** where parent jurisdictions (Tribunals, Courts) contain child jurisdictions (SSCS, Civil, Crime, etc.). Sourced from JOH eLinks (`jo_jurisdictions`); the parent-child shape is preserved natively if upstream provides it, or established on ingest. No separate tagging step.

**Evidence:** direct stakeholder statement, 2026-06-10.

#### Trigger E — JOH terminology replaces "judge"

Project-wide adoption of **JOH (Judicial Office Holder)** as the umbrella term where the meaning includes non-judge panel members (Medical Members, Disability-Qualified Members, Disability (Other) Members). "Judge" remains valid where the meaning is specifically a judge (Circuit Judge, Recorder, salaried Tribunal Judge, etc.). Service naming `ctam-judge` → `ctam-joh` (or architecture-phase equivalent) flagged as a follow-up.

**Evidence:** direct stakeholder statement, 2026-06-10.

#### Trigger F — CTAM scope boundary clarification

CTAM Pathfinder is the **system of record** for JOH availability and scheduling — **not** for case management or hearing management. Allocation decisions are made by admin staff via the off-system advertising/matching process (FR27) and recorded in CTAM via the UI by those admin staff. Case management, panel composition for specific cases, and hearing types live in external systems (SSCS case management; Courts Listing systems) that **consume** CTAM's APIs; no external system writes into CTAM.

**Evidence:** direct stakeholder statement, 2026-06-10.

### 2. Impact Analysis

#### Decisions Log impact

| Decision | Impact |
|---|---|
| **D3** | Superseded by D11 — no data migration of any kind; reference data sourced from JOH eLinks + MRD. Multi-paragraph rewrite. |
| **D5** | Reframed per D11 — the cohort's incumbent system is the parity reference (GAPS for wave 1; APEX for waves 2+). |
| **D8** | Reframed per D11 — rollout boundary is jurisdiction first, then per-region within jurisdiction. Jurisdiction is a first-class hierarchical attribute. |
| **D9** | Superseded + restructured 2026-06-10 — no user migration; two distinct user populations (JOH + admin staff) with different identity-lookup paths. |
| **D10** | Amended — SQL-ETL bootstrap sub-clause superseded by D11. Admin-UI-removed-from-MVP part unchanged. |
| **D11** *(new)* | SSCS-first pilot wave. Cascades through D3, D5, D8, D9 (reframed as jurisdiction-aware); JOH terminology; SSCS-cohort readiness assessment required before Phase 9. |
| **D12** *(new)* | CTAM scope boundary — availability/scheduling, not case/hearing management. Bounds the 11-service decomposition. |

#### Functional Requirements impact

| FR | Impact |
|---|---|
| **FR1** | Amended — adds email→personal-number / staff-identifier resolution at authentication time. |
| **FR2** | Amended — adds jurisdiction to authorisation scope. |
| **FR4** | Reframed — role, jurisdiction, Region/Area scope updates for any user; ETL reference removed. |
| **FR6** | Substantially reshaped — RSU can **view** reference data; two ownership tiers (upstream-sourced read-only + CTAM-owned) held in separate tables; corrections at source for tier (a). |
| **FR7** | Reshaped — cross-service direct-SQL reads unchanged; writes follow the tier; `ctam-reference-data` is the single owner of all reference-data tables. |
| **FR10–FR18** | JOH terminology sweep across the JOH Records & Working Patterns section. Section heading renamed (Judge → JOH). FR14 reframed (contract-type is upstream-only). FR15 reshaped (tickets are upstream-sourced + CTAM-overlay layered on top, keyed by personnel_number). FR17 marks location changes as CTAM-owned operational state. |
| **FR23, FR27** | JOH terminology fixes in the Vacancy & Cover section. |
| **FR29, FR32, FR33, FR34** | JOH terminology fixes in the Booking Management section. "court / tribunal" used where venue/jurisdiction-specific. |
| **FR35, FR36, FR39** | JOH terminology fixes in the Sitting Management section. DJ(MC) / Legal Advisers / County Courts kept as Courts-cohort-specific examples. |
| **FR57** *(activation flags — was FR58)* | Reframed — per-jurisdiction, per-region phased activation. Cutover flips include both jurisdiction and region in the SQL `WHERE` clause. |
| **FR60** *(UAT — was FR61)* | Reframed — jurisdiction-incumbent-experienced users perform UAT (GAPS for wave 1; APEX for waves 2+). |
| **FR57 (Phase 0 Data Migration ETL)** | **Retracted entirely**. FR slot removed; FR58–FR61 renumbered to FR57–FR60. |
| **NFR24** | Flipped — JOH eLinks API + MRD are MVP integrations (was "out of MVP"). |

#### User Journeys impact

The User Journeys section restructured to add a wave-1 SSCS journey and re-label existing journeys for waves 2+:

| Old | New |
|---|---|
| *(none)* | Journey 1 — Tribunal Caseworker SSCS panel coverage (wave 1) |
| Journey 1 — RSU cover-creation through payment | Journey 2 — RSU cover-creation through payment, Courts canonical cycle (wave 2+) |
| Journey 2 — Court daily sitting confirmation | Journey 3 — Court daily sitting confirmation (wave 2+) |
| Journey 3 — Judge views itinerary | Journey 4 — Judge views itinerary (wave 2+) |
| Journey 4 — DA&I MI Feed | Journey 5 — DA&I MI Feed (cohort-neutral; post-MVP) |
| Journey 5 — Cross-region edge case | Journey 6 — Cross-region edge case, Courts (Risk #1) |

Phase-by-Phase Journey Mapping table updated accordingly (now 6 rows).

#### Glossary impact

New entries: **GAPS**, **JOH**, **Jurisdiction**, **MRD**, **RTJ**, **SSCS**, **Tribunal Member**, **Tribunal Panel**.

Amended entries: **JI** (now defined as the Courts cohort's legacy system specifically), **CTAM Pathfinder** (replaces GAPS for SSCS wave 1 and JI/APEX for Courts waves 2+).

#### Cascade into separate artefacts (NOT modified in this run)

| Artefact | Required follow-up |
|---|---|
| `epics/index.md` | Phase 0 + Phase 1–8 framework references retracted ETL; Phase 0 epics 0.2 and 0.3 obsolete in their current form |
| `epics/requirements-inventory.md` | Renumber FR58–FR61 → FR57–FR60; carry across the JOH terminology + tier-(a)/tier-(b) reshape |
| `epics/fr-coverage-map.md` | Renumber + reshape per FR amendments |
| `epics/phase-0/*.md` | Stories 0.2.x and 0.3.x assume the ETL exists; fundamentally restructure or remove |
| `architecture.md` + `architecture-summary.md` | Two-tier reference-data ownership; JOH eLinks + MRD facade architecture; D12 scope boundary; `ctam-judge` → `ctam-joh` rename; personnel_number-keyed CTAM-overlay tables |
| `architecture/data-tables.md` | Table inventory needs the two-tier model + overlay-table pattern |
| `README.md` | Programme summary needs SSCS-first reflection; replace Courts-centric framing |
| `docs/architecture/asis/` | **New SSCS as-is analysis pack required** parallel to the existing JI/APEX pack — JOH eLinks data shape, MRD entities, SSCS operational processes, GAPS as-is capture |

#### Implementation Readiness impact

Prior readiness reports (2026-05-05, -06, -15, -15-rev2) assessed the **Courts cohort + ETL bootstrap**. A new **SSCS-cohort readiness assessment** is required before Phase 9, covering:
- JOH eLinks API integration readiness
- MRD Excel feed ingestion readiness
- Two-population identity model implementation
- Jurisdiction-aware authorisation
- SSCS-experienced UAT panel coverage (GAPS users)

### 3. Recommended Approach

**Hybrid: Direct Adjustment as the primary path, with the cohort retarget being the MVP scope change.**

**Rationale:**

- **Option 1 — Direct Adjustment** is viable and the bulk of the work. The 11-service architecture and Phase 0–8 build sequence are preserved per the user's chosen scope. PRD wording, Decisions Log entries, FR text, journeys, and integration requirements can be updated in place.
- **Option 2 — Rollback** is not viable. Per the chosen scope ("11 services preserved, build sequence preserved"), nothing structural needs rolling back. Rolling back would discard the validated PRD and architecture work.
- **Option 3 — MVP Review** is partially in play — the MVP target jurisdiction shifts from a Courts judicial region (wave 1) to the SSCS jurisdiction. This is a *retarget*, not a reduction. Captured as part of the Direct Adjustment.

**Effort estimate:** High — extensive PRD amendments (executed inside this run); cascading follow-up workstreams (epics, architecture, README, SSCS as-is pack) are Medium-High each.

**Risk level:** Medium — the 11-service architecture genuinely fits SSCS workflows per the user's confirmation. The main risks are: (a) the SSCS as-is pack may surface additional concepts not captured here; (b) JOH eLinks API contract details may shift the data-tier design; (c) Phase 0 epics 0.2 and 0.3 need complete restructuring before implementation can resume.

**Timeline impact:** Programme-management territory. The PRD changes themselves do not change Phase 0–8 sequencing; the wave-1 cutover target shifts from a Courts region to SSCS.

### 4. Detailed Change Proposals

All PRD amendments listed in Section 2 (Impact Analysis) were **executed in this workflow run** via 21 numbered edit proposals, each presented to and approved by the Product Manager incrementally. The detailed diffs are in the PRD itself; the high-level summary is captured in `artefactsModified` (frontmatter) and Section 2 (this proposal).

Edit proposals applied (in order):
1. Add D11 to Decisions Log + update Document Map (D1–D11)
2. Executive Summary rewrite + D11 implication amendment (JOH terminology shift)
3. Glossary additions (GAPS, JOH, RTJ, SSCS, Tribunal Member, Tribunal Panel) + JI / CTAM Pathfinder amendments
4. Supersede D3 (no data migration; JOH eLinks API + MRD facade) + add MRD glossary entry
5. Reframe D5 (jurisdiction-incumbent UAT)
6. Reframe D8 (jurisdiction-first rollout; jurisdiction as hierarchical first-class attribute)
7. Restructure D9 (two distinct user populations; email→personal-number lookup at sign-in)
8. D10 supersession note + D9 restructure for two-population identity
9. Retract FR57 (Phase 0 ETL) + renumber FR58–FR61 → FR57–FR60 + cross-reference updates
10. Amend FR4 (jurisdiction-aware admin operations)
11. Terminology sweep: "cohort" → "jurisdiction" globally + add Jurisdiction glossary entry
12. Amend FR6 (two-tier ownership model: upstream-sourced + CTAM-owned, separate tables)
13. Amend FR7 (cross-service reads unchanged; writes follow the tier)
14. FR1 + FR2 + FR57 + NFR24 + FR60 cascade amendments
15. JOH Records & Working Patterns section (FR10–FR18) — JOH terminology + tier-(b) overlay patterns
16. FR23 + FR27 (Vacancy & Cover) JOH terminology
17. Booking + Sitting (FR29, FR32, FR33, FR34, FR35, FR36, FR39) JOH terminology + add D12 (CTAM scope boundary) + Exec Summary char #6 + D11 implication amendments
18. Authentication Model subsection — JI → CTAM Pathfinder, two-population model, jurisdiction added
19. New Journey 1 (SSCS Tribunal Caseworker) + renumber existing journeys 1–5 → 2–6
20. Phase-by-Phase Journey Mapping table update (6 rows)
21. Integration Requirements table restructure (JOH eLinks + MRD + external case-management systems + JFEPS preservation note)

### 5. Implementation Handoff

#### Scope classification: **Major**

- Touches PRD core scope (D11 + D12), multiple decisions (D3, D5, D8, D9, D10 cascade), terminology layer, data ownership model, and downstream user journeys.
- Requires follow-up workstreams in architecture, epics, and supporting artefacts.

#### Recipients and responsibilities

| Recipient | Responsibility |
|---|---|
| **Product Manager** (Ramnish) | Already executed the PRD-level decisions during this Correct Course run. Owns the directional clarity needed for the cascade workstreams. |
| **Solution Architect (Winston, `bmad-agent-architect`)** | Lead architecture document amendments: two-tier reference-data ownership; JOH eLinks API + MRD facade; D12 scope boundary; personnel_number-keyed overlay tables; `ctam-judge` → `ctam-joh` rename evaluation. |
| **Product Owner / Developer agents (`bmad-create-epics-and-stories`)** | Restructure Phase 0 epics 0.2 and 0.3 (ETL stories obsolete). Renumber FR references across `epics/fr-coverage-map.md` and `epics/requirements-inventory.md`. |
| **Tech Writer (Paige, `bmad-agent-tech-writer`)** | Update `README.md` programme summary (SSCS-first framing) and `architecture-summary.md`. |
| **Business Analyst (Mary, `bmad-agent-analyst`)** | Produce the new SSCS as-is analysis pack under `docs/architecture/asis/` (parallel to the JI/APEX pack). Document JOH eLinks data shape, MRD entities, SSCS operational processes, and GAPS as-is. |

#### Success criteria

- PRD internally consistent (verified at the close of this workflow run).
- Architecture documents and epics aligned with PRD before any Phase 0 implementation work resumes.
- SSCS as-is pack complete before Phase 9 wave-1 cutover plan is finalised.
- New SSCS-cohort readiness assessment signed off before Phase 9 wave-1 cutover.

#### Sequencing recommendation

1. **Immediately:** review this Sprint Change Proposal; confirm scope and recipients.
2. **Next:** architecture document updates (highest impact on Phase 0 epic restructuring) — `architecture.md`, `architecture-summary.md`, `architecture/data-tables.md`.
3. **Then in parallel:**
   - Phase 0 epic restructuring (0.2 + 0.3 — ETL stories obsolete);
   - FR-coverage-map and requirements-inventory cleanup;
   - SSCS as-is analysis pack production.
4. **Finally:** SSCS-cohort readiness assessment; `README.md` programme-summary update for external visibility.

---

## Sprint Change Proposal — 2026-06-17

*Integrations-first Phase 0 carve-out*

**Status:** approved-2026-06-17

### 1. Issue Summary

**Trigger.** The first phase of delivery should focus on the **inbound integrations** — ingesting judicial-holder reference data from the **JOH eLinks API** and supplementary data from the **MRD** weekly dataset — and **their associated read APIs**. Two questions were raised:

1. Which service should host the components that orchestrate the JOH and MRD data?
2. Do we need a new **`ctam-integrations`** repository to host those components?

**Context.** The integration components are already designed and storied (architecture v3.0, 2026-06-11; Stories 0.1.3 eLinks, 0.1.4 MRD, 0.2.2 read API). What this change asks is **not new capability** — it is a **re-prioritisation and re-sequencing** of Phase 0 so the integration slice is the first thing built and demoed, decoupled from the authentication/UI vertical slice it is currently bundled into.

**Decisions taken at intake (2026-06-17):**

- **Integration scope** = JO eLinks + MRD inbound only (the two upstream feeds; no outbound, no additional systems).
- **Organisation** = carve out an integrations-first deliverable as the new first epic.
- **Mode** = batch.

### 2. The repository question — resolved

**Decision: No `ctam-integrations` repo. The orchestration components stay in-process inside `ctam-reference-data`.**

This reaffirms architecture v3.0 decisions #9 / #10 (AR46, AR47). Three facts make a separate repo actively harmful at the current scope:

1. **Single-writer ownership invariant.** Tier-(a) tables (`jo_*`, `mrd_*`) are owned exclusively by the `ctam_reference_data` DB role. **AR49** plus a CI ArchUnit/grants fitness function forbid any other role from holding `INSERT`/`UPDATE`. A separate `ctam-integrations` deployable would have to either (a) be granted write access — breaking the invariant and the fitness test — or (b) write through a Reference Data write API that **deliberately does not exist** (the service is read-only by design, Story 0.2.2). Both break current contracts.
2. **No new deployable, no new service principal.** The in-process decision was chosen specifically to avoid both, sidestepping the still-open service-auth gap **G7**. A new repo reopens both.
3. **No resilience gain.** Sign-in already reads CTAM's own `jo_people`, so identity resolution is decoupled from eLinks uptime. A separate service writing the same tables buys nothing.

**Host:** `ctam-reference-data`, via the already-specified in-process `@Scheduled` tasks:
`src/main/java/.../ingestion/JohElinksSyncTask.java` (nightly eLinks pull) and `ingestion/MrdExcelIngestionTask.java` (weekly MRD blob pick-up), with run state in `ctam_sync_status`.

**When to revisit:** only if integration scope later grows beyond these two inbound feeds — outbound flows to external case/hearing systems (D12 external consumers), additional upstream sources, or transformation orchestration spanning multiple domain schemas. That would be a fresh architecture decision (service-auth, cross-schema writes), not a Phase 0 concern.

### 3. Key finding — ingestion decouples cleanly, the read API does not

Mapping the carve-out exposed a dependency split that drives the recommended structure:

| Component | Auth dependency | Can lead the programme? |
|---|---|---|
| eLinks sync (0.1.3), MRD ingestion (0.1.4) | **None** — in-process `@Scheduled`, reads/writes its own tables, no JWT, no caller identity | **Yes** — genuinely first |
| Reference Data **read API** (0.2.2) | **`JWTFilter`** (token validation against JWKS) **+ `authz/check`** for the requester's jurisdiction used in jurisdiction-filtered responses (D8) | **No** — needs `ctam-mock-auth` + the authz mechanism to exist |

**Implication.** "Integrations and their APIs as the literal first thing" cannot be taken at face value: the *secured, jurisdiction-filtered* API is downstream of auth. The honest carve-out delivers **ingestion first** (the true integration win), then the **read API as soon as its auth dependencies are satisfied** — immediately after the auth slice.

### 4. Impact Analysis

#### 4.1 PRD — no change

This is a build-order change, not a requirements change. MVP scope, the 60 FRs, and the 11-service decomposition are **unchanged**. No PRD edit required.

#### 4.2 Epics — restructure (the substance of this proposal)

Phase 0 is re-organised from four epics into five, re-sequenced so ingestion leads. **No stories are added or removed** — they are moved and renumbered. Content is preserved; only sequencing, epic membership, and the relocations in §4.3 change.

| New epic | Title | Stories (source) | Auth dep |
|---|---|---|---|
| **0.1** | Upstream JOH/MRD reference data is ingested | 0.1.1 scaffold `ctam-reference-data` **+ shared-estate Terraform** (from old 0.1.1/0.1.3); 0.1.2 tier-(a) `jo_*` tables + `ctam_sync_status` (from old 0.1.3); 0.1.3 eLinks sync (old 0.1.3); 0.1.4 MRD ingestion (old 0.1.4) | none |
| **0.2** | User authenticates and lands on a role-scoped Home page | scaffold `ctam-authorisation` (old 0.1.1, **minus** shared estate); `ctam-mock-auth` (old 0.1.2); authz + `JWTFilter` (old 0.1.5); `ctam-ui` scaffold (old 0.1.6); sign-in + Home (old 0.1.7) | provides auth |
| **0.3** | Reference data is served read-only via a versioned, jurisdiction-filtered API | tier-(b) tables + seed + runbook (old 0.2.1); read-only API (old 0.2.2) | **consumes** 0.2 |
| **0.4** | Both user populations are bootstrapped and verifiable against the IdP | old 0.3.1 | consumes 0.2 |
| **0.5** | Notification service is scaffolded and contractually ready | old 0.4.1, 0.4.2 | none |

**Story-count check:** 4 + 5 + 2 + 1 + 2 = **14 entries**, mapping 1:1 from the existing 12 stories plus the explicit split of the old 0.1.1 (scaffold) and old 0.1.3 (which both scaffolded `ctam-reference-data` *and* set up tier-(a) + sync) into discrete scaffold / tables / sync stories. No scope added.

**Recommended build sequence:** `0.1 (ingestion)` → `0.2 (auth + UI)` → `0.3 (read API)` → `0.4 (bootstrap)` → `0.5 (notification)`.

#### 4.3 Architecture — amend (rule-driven ripples)

1. **Shared Azure estate Terraform relocates `ctam-authorisation` → `ctam-reference-data`.** Per **AR53** ("Terraform lives in the first repo that needs the resource; the first-consumer carries the shared estate"), `ctam-reference-data` becomes the first service scaffolded and therefore the first consumer of AKS, PostgreSQL Flexible Server, ACR, APIM, App Insights / Log Analytics. The shared-estate provisioning ACs currently in old Story 0.1.1 move to new Story 0.1.1; `ctam-authorisation` becomes a **consumer** of the shared estate, retaining only its own resources.
2. **`ctam_configuration_values` Flyway baseline** (owned by `ctam-architecture`) must run before `ctam-reference-data`; the SELECT-grant for `ctam_reference_data` is added at the baseline. (Was sequenced before `ctam-authorisation`.)
3. **Implementation Sequence** section reordered: `ctam-reference-data` + ingestion first; `ctam-authorisation` second.
4. **New architecture-phase decision recorded** (#12, 2026-06-17): integrations-first Phase 0 sequencing; in-process ingestion reaffirmed; **`ctam-integrations` repo explicitly declined** with rationale (§2) so it is not re-litigated.
5. **Changelog entry** (e.g. v3.3) capturing this SCP.
6. **Repository strategy / repo list:** phase tags unchanged (both remain Phase 0); "first scaffolded service" note flips to `ctam-reference-data`; shared-estate ownership note flips on the two repos.

Files touched: `architecture.md` (Implementation Sequence, architecture-phase decisions table, Integration Points), `architecture/repo-structure.md` (shared-estate ownership line), `architecture/repository-strategy.md` (first-service note), `architecture/changelog.md`, `architecture-summary.md` (sweep).

#### 4.4 UX — no change

No UX artefact exists (accepted gap); unaffected.

#### 4.5 Secondary artefacts

- `epics/index.md`, `epics/phase-0/index.md`, `epics/fr-coverage-map.md`, `epics/requirements-inventory.md` (AR53 wording on which repo carries the shared estate) — updated for the renumber + Terraform relocation.
- The four superseded readiness reports are unaffected (already superseded).
- Terraform stacks: shared-estate stack moves repos; no infra is provisioned yet (greenfield), so this is a documentation/ownership move, not a live-resource migration.

### 5. Recommended Approach

**Path: Direct Adjustment + backlog reorganisation (no rollback, no MVP scope change).**

- Re-sequence Phase 0 into the five-epic structure in §4.2; ingestion leads as the genuine first deliverable.
- Reaffirm in-process hosting; decline `ctam-integrations` (§2).
- Apply the AR53 Terraform relocation and the baseline re-sequence (§4.3).
- Deliver the read API in Epic 0.3, immediately after auth, honouring the dependency in §3.

**Effort:** Medium (documentation/restructure; no code exists yet). **Risk:** Low — nothing is built; this is the cheapest possible moment to re-sequence. **Timeline:** neutral-to-positive — ingestion can start without waiting on the auth slice.

**Open decision for sign-off (one):** the read API's auth dependency (§3). Recommended: deliver it in Epic 0.3 after auth. *Alternative:* pull a minimal auth subset (`ctam-mock-auth` + `JWTFilter` + a jurisdiction-only `authz/check`) forward into the first phase to ship the API earlier — at the cost of dragging ~half the auth slice forward and partially defeating the decoupling. **Recommendation: do not pull forward; keep the read API in 0.3.**

### 6. Implementation Handoff

**Scope classification: Moderate** (backlog reorganisation + architecture amendment; no fundamental replan).

| Recipient | Responsibility |
|---|---|
| **Architect (Winston)** | Apply §4.3 architecture amendments — AR53 Terraform relocation, Implementation Sequence reorder, decision #11 + changelog, repo-strategy/repo-structure notes. |
| **Epics update** (`bmad-create-epics-and-stories` re-run, Phase 0) | Apply the §4.2 restructure — move/renumber stories, split old 0.1.1/0.1.3 scaffold-vs-tables-vs-sync, update epic indexes + fr-coverage-map. |
| **Readiness gate (IR)** | Fold into the already-outstanding **SSCS-cohort `bmad-check-implementation-readiness`** run — it now also validates the integrations-first sequencing and the Terraform relocation. Phase 0 was already `pending-revalidation`; this change feeds that gate rather than adding a new one. |
| **Sprint Planning (SP)** | Runs after IR passes; `implementation-artifacts/` is still empty. Epic 0.1 (ingestion) becomes the first sprint. |

**Success criteria:**

- Phase 0 epics reflect the five-epic, ingestion-first structure; story count reconciles (12 → 14 entries, no scope added).
- Architecture pack reflects the Terraform relocation and records decision #12 (incl. the `ctam-integrations` decline).
- IR (SSCS-cohort) passes against the restructured Phase 0; SP produces a sprint plan leading with Epic 0.1.

**Note:** `sprint-status.yaml` does not yet exist (SP not run), so checklist item 6.4 is N/A — the epic changes land in the epics pack and are picked up at first SP.

---

## Sprint Change Proposal — 2026-07-06

*Shared infrastructure to a dedicated repo (CNP alignment)*

**Date:** 2026-07-06
**Project:** ctam-analysis (CTAM Pathfinder)
**Change scope:** Moderate (backlog reorganisation + architecture doc updates; no code to unwind)
**Mode:** Incremental
**Decision:** #13 · **Architecture version:** v3.8

---

### 1. Issue Summary

**Problem statement.** The HMCTS Cloud Native Platform onboarding guidance for new components ([`new-component/github-repo.html`](https://hmcts.github.io/cloud-native-platform/new-component/github-repo.html)) states that **product-level (shared) infrastructure must live in its own dedicated repository**, named `{product}-shared-infrastructure` — for CTAM Pathfinder, `ctam-shared-infrastructure`.

The current architecture does the opposite. Per **AR53 (the "colocated first-consumer" rule, adopted v3.1 and re-affirmed by decision #12 / SCP 2026-06-17)**, the shared Azure estate — **AKS, PostgreSQL Flexible Server, ACR, APIM, Application Insights** — is provisioned from Terraform **inside `ctam-reference-data/terraform/`**, because that is the first service scaffolded under the integrations-first sequencing. (It was itself relocated there from `ctam-authorisation`.)

**Discovery.** Identified during a review of the CNP new-component standards on 2026-07-06, while orienting Phase 0 for sprint planning.

**Why it matters now.** Phase 0 is at the sprint-planning boundary. Deferring the change means either building the estate the non-standard way and re-homing it later, or blocking sprint planning. Neither is necessary: **no implementation has started** (`implementation-artifacts/` is empty), so this is a re-plan of not-yet-started stories, not a rollback of built work. This is the cheapest possible moment to absorb it.

---

### 2. Impact Analysis

**Epic impact.**
- **New Epic 0.0** — "Platform estate is provisioned, verifiable, and CNP-compliant" (5 stories). Sequenced first in Phase 0.
- **Epic 0.1** — Story 0.1.1 shed its shared-estate provisioning responsibility; it now scaffolds `ctam-reference-data` and **deploys onto** the Epic 0.0 estate. Still 4 stories.
- **Epics 0.2–0.5** — dependency wording repointed from "the estate provisioned in `ctam-reference-data`" to "the estate provisioned in Epic 0.0". No story-count change.
- **Phase 0 totals:** 5 → **6 epics**, 14 → **19 stories**.

**Story impact.** No stories were completed, so none are re-opened. Story 0.1.1 is reduced in scope; five new stories (0.0.1–0.0.5) are added, each carrying a **deploy-time acceptance test** so infrastructure is verified as each Terraform layer lands (the sponsor's explicit requirement).

**Artifact conflicts (all resolved in §4).**
- `requirements-inventory.md` — **AR53 inverted**; incidental AR23/AR27 mentions repointed.
- `architecture/repository-strategy.md` — repo list **15 → 16** (new `ctam-shared-infrastructure` row); `ctam-reference-data` row trimmed; strategy/decision lines updated.
- `architecture/repo-structure.md` — per-service `terraform/` note reworded; **new `ctam-shared-infrastructure` directory structure** added (incl. a `verification/` folder for the Epic 0.0 smoke checks).
- `architecture/framework.md` — Platform scope line repointed.
- `architecture.md` — **new decision #13** (supersedes the relocation part of #12).
- `architecture/changelog.md` — **new v3.8** entry.
- `epics/index.md`, `epics/phase-0/index.md` — epic table, story counts, sequencing narrative, per-epic summaries.

**Technical impact.**
- **Repos:** +1 (`ctam-shared-infrastructure`, Terraform-only, no deployable workload). 16 total.
- **Code:** none written yet — zero rework.
- **Sequencing:** the *domain* deliverable ordering (0.1 → 0.5) is unchanged; a "platform estate stands up and is verified first" unit is inserted ahead of it (it was always an implicit prerequisite of old Story 0.1.1).
- **Cleaner separation:** `ctam-reference-data` is reduced to its domain, consistent with the polyrepo "minimise shared coupling" principle.

**Secondary flag (not blocking).** The CNP page also states *"Repository should be public."* This conflicts with the standing "new repos private" default; HMCTS gov-guidance governs the org here. Flagged for a conscious decision at repo-creation time — recorded, not resolved by this SCP.

---

### 3. Recommended Approach

**Chosen path: Direct Adjustment** — add/modify stories and epics within the existing plan; no rollback, no MVP-scope reduction.

**Rationale.** The change is a repo-topology and doc-wording correction plus one new foundational epic. Because nothing is built, Direct Adjustment carries no rework cost. Structuring the estate as its own independently-verified epic (a) satisfies the CNP standard, (b) makes the platform testable in isolation before a service depends on it, and (c) tightens `ctam-reference-data`'s responsibilities.

- **Effort estimate:** ~1 day of planning/doc edits (this SCP, applied). The engineering effort was always required — it is re-homed and made explicit as Epic 0.0, not net-new.
- **Risk:** Low. No built work touched; the change reduces coupling. Residual risk is the public-vs-private repo policy decision (§2 secondary flag) and the standing G9 Terraform-state/pipeline confirmation.
- **Timeline impact:** Neutral-to-positive — the estate work moves earlier and becomes independently testable, de-risking every downstream Phase 0 epic.

---

### 4. Detailed Change Proposals

All seven edit groups below were reviewed and **approved incrementally**, and have been **applied** to the planning artifacts.

**Stories / Epics**
1. **NEW `epics/phase-0/epic-0.0-platform-estate-provisioned.md`** — 5 stories, each a Terraform layer + deploy-time acceptance test:
   - 0.0.1 Repo + Terraform foundation (state backend, per-env stacks, plan/apply CI) — verify: `validate` passes, clean `plan`, no-op `apply` writes state.
   - 0.0.2 Network + AKS — verify: `kubectl get nodes` Ready across AZs; hello pod schedules.
   - 0.0.3 PostgreSQL + Key Vault — verify: TLS-only connect (plaintext refused, NFR10); scratch DB; Key Vault secret round-trip (NFR16).
   - 0.0.4 ACR + observability — verify: image push/pull; test trace + log land in App Insights (NFR25–28).
   - 0.0.5 APIM + smoke API — verify: gateway → echo 200 over TLS; sub-floor TLS refused (`testssl.sh`); unauth call rejected.
2. **`epic-0.1` Story 0.1.1** — retitled "(onto the Epic 0.0 estate)"; provisioning ACs removed; consume-the-estate ACs added; header/vertical-slice/references updated.

**Architecture**
3. **AR53 inverted** (`requirements-inventory.md`) — shared estate in dedicated `ctam-shared-infrastructure`; per-service repos keep own resources only. AR23/AR27 and `framework.md` repointed.
4. **`repository-strategy.md`** — new `ctam-shared-infrastructure` row; `ctam-reference-data` row trimmed; total 15 → 16; decision/strategy lines updated.
5. **`repo-structure.md`** — per-service `terraform/` note reworded; new `ctam-shared-infrastructure` tree (Terraform modules + `verification/` smoke checks) + rationale.
6. **`epics/phase-0/index.md` + `epics/index.md`** — sequencing blockquote, scope-model bullet, epics table (+0.0), summaries, stories-summary table, totals (6 epics / 19 stories); Epics 0.2 dependency repointed.
7. **Audit trail** — new **decision #13** in `architecture.md` (supersedes #12's relocation); new **changelog v3.8**.

---

### 5. Implementation Handoff

**Change scope classification: Moderate** — backlog reorganisation across epics + architecture doc updates; no code to reorganise (implementation not started).

**Routing:**
- **Product Owner / Dev** — Epic 0.0 enters sprint planning as the **first** Phase 0 unit; Story 0.1.1 re-estimated to its reduced (scaffold-and-deploy) scope.
- **Platform/Infra** — own `ctam-shared-infrastructure`: create the repo (CNP naming, manual GitHub web-UI setup per the runbook; **decide public-vs-private per §2**), stand up the Terraform foundation, and confirm the G9 state-backend/pipeline pattern before the first `apply`.

**Success criteria.**
- `ctam-shared-infrastructure` exists and provisions the dev estate via Terraform.
- Each Epic 0.0 story passes its deploy-time acceptance test (nodes Ready, Postgres TLS-only, Key Vault round-trip, ACR pull, APIM smoke 200).
- `ctam-reference-data` (Story 0.1.1) deploys onto the verified estate with no colocated shared-estate Terraform.
- Architecture pack self-consistent at v3.8; Phase 0 shows 6 epics / 19 stories throughout.

**Deliverables produced:** this Sprint Change Proposal; the seven applied edit groups (§4); the new Epic 0.0 file.

---

> **Next step:** re-run `bmad-check-implementation-readiness` against the updated Phase 0 (it understands the sharded shape), then proceed to `bmad-sprint-planning` with Epic 0.0 sequenced first.

---

## Sprint Change Proposal — 2026-07-07

*Build-tool terminology clarification (Gradle vs Maven-format) + contract-placement read-only mirror*

### Section 1 — Issue Summary

**Trigger:** Requirement to confirm **Gradle (not Maven) as the build tool**, and to make explicit that `ctam-architecture` holds only a **read-only mirror** of API contracts.

**What the change analysis found:** Gradle is *already* the build tool across every artifact — 57 Gradle references, `build.gradle`/`gradlew`, "Gradle Groovy DSL (per HMCTS template)", and `changelog.md` v1.4 records "Build: Gradle Kotlin DSL → Groovy DSL". **There was no "Maven as build tool" statement anywhere.**

All 16 "Maven" occurrences referred to the **OpenAPI spec artefact being published to a Maven-*format* artefact repository** (coordinate system `groupId:artifactId:version`), which is **build-tool-agnostic** — Gradle publishes Maven-format artefacts via its `maven-publish` plugin (already named correctly in `starter-template.md`). A literal "Maven → Gradle" swap would have introduced errors ("Gradle artefact", "internal Gradle repo") and mis-renamed the real `maven-publish` Gradle plugin.

**Resolution chosen (user-approved):** *Clarify the wording* — name Gradle as the build/publish tool and reduce "Maven" to "Maven-format" (the repository/coordinate format) throughout the live docs. Leave the `changelog.md` historical record untouched.

### Section 2 — Impact Analysis

- **PRD impact:** 2 wording clarifications (`prd.md`). No requirement/scope change.
- **Epic/Story impact:** 4 clarifications across `epic-0.2`, `epic-0.3` (×2), `epic-0.5`, plus AR8 in `requirements-inventory.md`. **Acceptance-criteria intent preserved** (publish coordinates and behaviour unchanged; only the publisher/format is named explicitly).
- **Architecture impact:** 9 clarifications across `architecture.md` (×4), `architecture-summary.md`, `conventions.md`, `starter-template.md` (×2), `repo-structure.md`. No component, pattern, or technology decision changed — Gradle + Swagger Core + Maven-format artefact repo were already the design.
- **Delivery operating model:** new **"Contract placement within the bus: producer-owned source, read-only mirror only"** subsection added to `delivery-operating-model.md`.
- **Technical impact:** none to code/infra — this is a documentation-consistency change. The `maven-publish` Gradle plugin and artefact coordinates are unchanged.
- **Not changed (intentional):** `changelog.md:64` — changelogs record the decision as made at the time.
- **Downstream:** published `docs/*.html` must be regenerated from the edited Markdown via `build_html.py`.

### Section 3 — Recommended Approach

**Direct Adjustment** — in-place wording clarification. No rollback, no MVP-scope change. Effort: trivial (documentation). Risk: negligible (no behavioural or requirement change; ACs preserved). Timeline impact: none.

### Section 4 — Detailed Change Proposals

Canonical rewording pattern:

> **OLD:** published as a Maven artefact (`uk.gov.hmcts.ctam:api-ctam-{service}:{version}`)
> **NEW:** published by Gradle (via the `maven-publish` plugin) as a Maven-format artefact (`uk.gov.hmcts.ctam:api-ctam-{service}:{version}`) to the internal artefact repository

Applied edits (15 live references across 10 files):

| File | Ref | Change |
|---|---|---|
| `prd.md` | :400 | "published as a Maven artefact" → "published by Gradle via the `maven-publish` plugin as a Maven-format artefact" |
| `prd.md` | :514 | "(Maven artefact; …)" → "(Maven-format artefact published by Gradle `maven-publish`; …)" |
| `architecture.md` | :224 | "**API spec Maven artefacts**" → "**API spec artefacts (Maven-format, published by Gradle `maven-publish`)**" |
| `architecture.md` | :453 | full canonical rewording (publisher + format + internal artefact repository) |
| `architecture.md` | :649 | table row → "published by Gradle (`maven-publish`) as a Maven-format artefact" |
| `architecture.md` | :761 | "as Maven artefacts" → "as Maven-format artefacts (published by Gradle)" |
| `architecture-summary.md` | :131 | "published per-service as Maven artefacts" → "published per-service by Gradle (via the `maven-publish` plugin) as Maven-format artefacts" |
| `conventions.md` | :302 | full canonical rewording |
| `starter-template.md` | :70 | "`maven-publish` for artefact publication" → "`maven-publish` (the Gradle publishing plugin) for publishing Maven-format artefacts" |
| `starter-template.md` | :97 | "Maven-published spec artefact" → "spec artefact published by Gradle `maven-publish` in Maven format" |
| `repo-structure.md` | :56 | "Swagger Core + Maven-published spec artefact" → "Swagger Core; spec published by Gradle maven-publish as a Maven-format artefact" |
| `requirements-inventory.md` | :198 (AR8) | "published as a Maven artefact" → "published by Gradle (via the `maven-publish` plugin) as a Maven-format artefact" |
| `epic-0.3` | :22 | "published as Maven artefact" → "published (by Gradle `maven-publish`) as a Maven-format artefact" |
| `epic-0.3` | :101 | AC → "published by Gradle (`maven-publish`) to the internal Maven-format artefact repository as …" |
| `epic-0.2` | :203 | AC → "publishes the artefact (via Gradle `maven-publish`) to the internal Maven-format artefact repository" |
| `epic-0.5` | :25 | "published as Maven artefact" → "published (by Gradle `maven-publish`) as a Maven-format artefact" |

**Left untouched (historical):** `changelog.md:64` (v1.4 record).

**New content — `delivery-operating-model.md`:** added subsection **"Contract placement within the bus: producer-owned source, read-only mirror only"** establishing that (a) the delivering service repo is the contract source of truth (Gradle `maven-publish` → Maven-format artefact), (b) consumers pin the producer's versioned artefact, and (c) `ctam-architecture/api-specs/` is a **read-only, automation-regenerated mirror** for discovery/Spectral/diagrams only — never hand-edited, never a build dependency, never a source of truth.

### Section 5 — Implementation Handoff

- **Scope classification: Minor** — documentation-consistency change, implemented directly.
- **Status:** all Markdown edits applied and verified (sweep confirms every live reference now reads "Maven-format" / "`maven-publish`"; changelog historical entry preserved).
- **Remaining step:** regenerate published `docs/*.html` from the edited Markdown via `build_html.py`, then commit (externally, via VSCode, per repo policy).
- **Success criteria:** no reader can mistake "Maven" for a build tool; Gradle is unambiguously the build/publish tool; the read-only-mirror rule for contracts is explicit in the operating model.

---

## Sprint Change Proposal — 2026-07-09

*CTAM-assigned JOH identity — personnel_number demoted to upstream link*

### Section 1 — Issue Summary

**Trigger:** Rather than using `personnel_number` as the JOH identifier *within* CTAM, use it only as the **link to the upstream JO/eLinks system**, and adopt a **CTAM-specific UUID** as CTAM's canonical JOH identifier — so that issues with upstream data (a `personnel_number` reissue, a `jo_people` full-refresh, an upstream key change) cannot negatively affect CTAM services.

**Why it matters:** This reverses the core tenet of decision **D9** — *"`personnel_number` is the canonical JOH identifier referenced by every domain table."* `personnel_number` was threaded through every JOH-touching table, `ctam_auth_users`, all JOH API routes, and both sequence diagrams.

**Discovery context:** Raised as a course-correction. Because implementation has **not started**, this is a **documentation/architecture change with no code impact** (like SCP 2026-07-06) — broad surface, low execution risk.

### Section 2 — Impact Analysis

- **Architecture:** `personnel_number` demoted from canonical identifier to upstream link; new CTAM-owned identity table; FK convention reversed; API keying changed; auth resolution extended. Affected: `architecture.md`, `architecture-summary.md`, `conventions.md`, `data-tables.md`, `repository-strategy.md`, `functional-requirements-coverage.md`, `user-types.md`, `assumptions.md`, both JOH/auth sequence diagrams.
- **Epics/Stories:** Epic 0.1 (`ctam-reference-data`) gains the `ctam_joh_identities` table + eager minting during the eLinks sync; Epic 0.2 auth resolution and `/authz/check` response now carry the CTAM JOH UUID; Epic 0.4 bootstrap seeds/verifies the mapping. Also `framework.md`, `fr-coverage-map.md`, `requirements-inventory.md` (AR22/AR34/AR46), `phase-0/index.md`. **No new stories; story count unchanged (19).**
- **PRD:** JOH endpoints rekeyed to `{johId}`; FR11/FR15 overlay tables rekeyed. Requirement intent unchanged.
- **Data model:** +1 table (`ctam_joh_identities`); `ctam-reference-data` 32 → 33 tables.
- **Technical impact:** none to code (not started). At build time: one new Liquibase table, a minting step in the eLinks sync, `joh_id uuid` FK columns on JOH-touching tables, `UUID` path variables.
- **Not changed (intentional):** dated reports (`sprint-change-proposal-2026-06-10`, `prd-validation-report-2026-06-17`, `implementation-readiness-report-2026-06-17`) left as historical; legitimate *upstream* `personnel_number` uses kept (`jo_people` natural key, MRD workbook validation, PII-in-logs prohibition, JSON casing/wrapping anti-pattern examples).
- **Downstream:** `docs/*.html` regenerated from the edited Markdown via `build_html.py`.

### Section 3 — Recommended Approach

**Direct Adjustment.** Decisions taken (user-approved):

| Decision | Choice |
|---|---|
| Mapping-table owner | **`ctam-reference-data`** — mints the UUID in the same transaction as the `jo_people` upsert (single writer; link-to-upstream stays with the upstream owner) |
| Structure | **New CTAM-owned table `ctam_joh_identities`** (`id uuid PK` + unique `personnel_number` + audit). *Forced:* cannot be a column on `jo_people` (tier-(a) upstream, read-only, full-refresh) |
| API keying | **`/v1/johs/{johId}`** (UUID); `personnel_number` becomes a `?personnelNumber=` filter |
| Mint timing | **Eagerly at ingestion** — every `jo_people` row gets a mapping during the nightly eLinks sync |

Risk: negligible (no code, no requirement change). Effort: documentation sweep across ~20 living files.

### Section 4 — Detailed Change Proposals

**New table (`data-tables.md`):**
> `ctam_joh_identities` — CTAM-assigned canonical JOH identifier. `id uuid PK` + `personnel_number` (unique, link to `jo_people`). Written mint-only by the eLinks sync; SELECT-granted to every domain service. Its own subsection (parallel to `ctam_sync_status`).

**Keystone convention flip (`conventions.md`):**
> OLD: *JOH references use `personnel_number` → `jo_people` (the canonical JOH identifier), not a surrogate id.*
> NEW: *JOH references use `joh_id` (uuid) → `ctam_joh_identities` — the CTAM-assigned canonical JOH identifier. `personnel_number` is the upstream link, stored only on `ctam_joh_identities`, never a domain FK.*

**Representative edits applied:**
- Domain tables (`ctam_absences`, `ctam_bookings`, `ctam_sittings`, `ctam-joh` overlays): "references the JOH by `personnel_number`" → "by `joh_id` → `ctam_joh_identities`".
- API: `/v1/johs/{personnelNumber}` → `/v1/johs/{johId}` (conventions, prd, project-context; Java `@PathVariable UUID johId`).
- Auth resolution (architecture, architecture-summary, requirements-inventory AR34, framework, sequence diagram, epic 0.2/0.4, phase-0 index): IdP email → `jo_people` → `personnel_number` → **`ctam_joh_identities` (CTAM JOH UUID)**; `/authz/check` `canonicalId` = CTAM JOH UUID.
- eLinks sync (architecture, requirements-inventory AR46, epic 0.1, joh-onboarding sequence): now also **mints `ctam_joh_identities` per `jo_people` row**.
- `ctam_auth_users` links JOH principals via `joh_id` → `ctam_joh_identities` (not `personnel_number`).
- `[^d9]` footnote refined across all living files; `ctam-reference-data` count 32 → 33; `data-tables.md` gains the identity subsection.
- Changelog: new **v3.9** entry.

### Section 5 — Implementation Handoff

- **Scope: Major** (identity-model change) but **documentation-only** — no code exists to rework.
- **Status:** all living-doc edits applied and verified; only legitimate upstream/PII/anti-pattern `personnel_number` references remain.
- **Remaining step:** regenerate `docs/*.html` via `build-html.sh`, then commit externally (VSCode).
- **When implementation starts:** Story 0.1.2 creates `ctam_joh_identities` (Liquibase); Story 0.1.3 mints it during the eLinks sync; every JOH-touching domain table carries `joh_id uuid` FK; JOH APIs key on `{johId}`.
- **Success criteria:** no living doc treats `personnel_number` as CTAM's JOH identifier; `ctam_joh_identities` is the single canonical JOH id; CTAM domain data is insulated from upstream churn.

---

## Sprint Change Proposal — 2026-08-07

*Wave-1 pilot jurisdiction changes from SSCS to Employment Tribunals (ET)*

**Wave-1 pilot jurisdiction: SSCS → Employment Tribunals (ET)**

---

### Section 1 — Issue Summary

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

### Section 2 — Impact Analysis

#### 2.1 The central finding — the architecture already absorbs this

**The 16-repo decomposition, the data model, and all 60 FRs / 42 NFRs survive unchanged.** This is not luck; it is D8 working as designed.

D8 (reframed 2026-06-10) made **jurisdiction a first-class hierarchical attribute sourced from upstream `jo_jurisdictions`** — "not invented or tagged by CTAM Pathfinder". Every jurisdiction-sensitive mechanism was therefore built to be parameterised, not hardcoded:

| Mechanism | Why ET needs no structural change |
|---|---|
| `jo_jurisdictions` | Hierarchy comes from eLinks. Tribunals/ET is a sibling of Tribunals/SSCS — a data value, not a schema change. |
| `ctam_auth_user_activation_flags` | Keyed by the `(jurisdiction, region)` tuple (FR57). Wave cutover is an `UPDATE … WHERE jurisdiction = …`. ET is a different WHERE clause. |
| `ctam-authorisation` | Carries the user's jurisdiction alongside roles + Region/Area scope (FR2). Jurisdiction-agnostic. |
| `ctam-reference-data` | Filters API responses by requester jurisdiction (FR6/FR7). Jurisdiction-agnostic. |
| `ctam_joh_identities` / `joh_id` | CTAM-assigned UUID per JOH (D9 as refined by SCP 2026-07-09). Independent of jurisdiction. |
| `ctam_jurisdictional_splits` | Per-JOH split percentages (FR16). Already multi-jurisdiction by construction. |
| JOH umbrella term | Adopted precisely because non-judge panel members exist. ET's non-legal members are covered by the same abstraction. |

**Unchanged in full:** the 16-repo polyrepo · the 55-table data model · Phase 0–8 build sequence · all six Phase 0 epics and their 19 stories · `delivery/dispatch-graph.yaml` · `delivery/ledger/` · decisions **D1, D2, D3, D4, D6, D7, D9, D10, D12** · every architecture convention.

**No FR or NFR is added, removed, or renumbered.** Roughly 12 are **reworded** where their prose names SSCS or ListAssist: FR6, FR7, FR44, FR57, FR60, NFR21, NFR24, NFR32, NFR36, NFR38, NFR41.

#### 2.2 Epic impact

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

#### 2.3 Artifact conflicts

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

#### 2.4 Technical impact

**None.** No code exists. No schema migration, no API contract change, no infrastructure change, no deployment change. The `delivery/` control plane needs no edit — `dispatch-graph.yaml` carries no jurisdiction references and the ledger shards are jurisdiction-neutral.

#### 2.5 New risks and open questions — the substantive cost of this change

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

**Also to confirm:** ET's case-management system — the GAPS analogue that will consume CTAM's APIs per D12 (retained, not replaced).

**Net position on prior work:** the SSCS-cohort readiness assessment and SSCS as-is analysis pack were both *required but never produced*. Demoting SSCS to wave 2 therefore **loses no completed work** — it defers two un-started deliverables and raises two new ET equivalents in their place.

---

### Section 3 — Recommended Approach

#### Options evaluated

| Option | Viable? | Effort | Risk | Notes |
|---|---|---|---|---|
| **1 — Direct Adjustment** | ✅ **Yes** | Medium–High (volume) | Low–Medium | No code, no FR/NFR churn, no epic churn. Risk sits in R1–R5, not in the edits. |
| **2 — Rollback** | ❌ N/A | — | — | Nothing built. Nothing to revert. |
| **3 — MVP Review** | ⚠️ **Partial** | Low | Medium | Not needed for architecture or epics. **Required for the business case** (R5). |

#### Recommended: **Hybrid — Direct Adjustment + business-case evidence refresh, sequenced behind discovery**

**Rationale.** The architecture needs no redesign — D8 anticipated exactly this. But running a 27-file, ~250-reference cascade *before* R1 and R2 are answered would write "TBD" into hundreds of places and force a second full sweep. That is the failure mode the repo's own convention warns against ("sweep first, don't blind find-replace").

**Therefore: parameterise the unknown rather than deferring the cascade.**

Introduce a single placeholder token — **`[ET-INCUMBENT-TBD]`** — for the ET scheduling incumbent, and use it consistently everywhere ListAssist currently appears in a wave-1 role. Everything else (jurisdiction, wave numbering, decision text, roles, journey, glossary, gates) is written definitively in one pass. When R1 resolves, closing it out is a **single mechanical token replacement**, not a re-analysis.

Apply the same discipline to R2: mark every ET role name with an explicit *provisional — pending ET as-is pack* flag rather than presenting assumed names as settled.

#### Proposed sequencing

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

### Section 4 — Detailed Change Proposals

#### 4.1 Decisions

**New D13 — supersedes D11.** *(PRD decision table)*

> **D13 (new 2026-08-07; supersedes D11) — ET-first pilot wave.** CTAM Pathfinder's MVP pilot rollout (Phase 9, wave 1) targets the **Employment Tribunals (ET)** jurisdiction. **Wave 2 = the SSCS Tribunals jurisdiction** (replacing ListAssist; GAPS, the SSCS case-management system, is retained per D11 as amended). **Waves 3+ = Courts jurisdictions** (Civil, Crime, Family, Crown) per HMCTS judicial region, replacing APEX/JI. The 16-repo architecture and the Phase 0–8 build sequence are **unchanged** — jurisdiction is a first-class upstream-sourced attribute per D8, so retargeting the pilot is a data-and-rollout change, not an architectural one.
>
> **ET's judicial-scheduling incumbent is not yet identified** (gap G8.4). Until it is, the wave-1 behavioural reference, manual-UAT parity target, rollback target and historical-data location are recorded as `[ET-INCUMBENT-TBD]`.
>
> **ET JOH type taxonomy is provisional** pending the ET as-is analysis pack (gap G8.5): Employment Judges (salaried and fee-paid), Regional Employment Judges, and non-legal ("lay") members drawn from employer-side and employee-side panels. The JOH umbrella term and the existing `ctam-joh` / `ctam-booking` / `ctam-sitting` decomposition accommodate these without structural change. **Panel composition and hearing types remain out of CTAM scope per D12.**

**D11** — retained as history, re-scoped: "SSCS-first pilot" → "**SSCS wave**", superseded by D13 for wave ordering.
**D5** — parity reference re-parameterised: `[ET-INCUMBENT-TBD]`-experienced users (wave 1) · ListAssist-experienced (wave 2) · APEX-experienced (waves 3+).
**D8** — wave sequence restated: wave 1 = ET, wave 2 = SSCS, waves 3+ = Courts per region. Hierarchy mechanism unchanged.
**D12** — unchanged; the external case-management consumer for wave 1 becomes ET's system (to confirm) rather than GAPS.

#### 4.2 The `[^d11]` footnote — one edit, ~20 files

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

#### 4.3 Wave renumbering — 100 lines across 24 files

Every "waves 2+ (Courts)" becomes "waves 3+ (Courts)", and a new wave-2 (SSCS) tier is inserted. This is **not** a safe find-replace: "wave 2" also appears in phrases like "each subsequent wave" and in the immutable historical reports. Apply file-by-file against the sweep inventory in §2.3.

Canonical three-tier phrasing to use throughout:

> wave 1 = the **Employment Tribunals** jurisdiction; wave 2 = the **SSCS** Tribunals jurisdiction; waves 3+ = **Courts** jurisdictions per HMCTS judicial region

#### 4.4 PRD — Target Users (lines 91–98)

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

#### 4.5 PRD — Journey 1

Journey 1 (Asha, SSCS Tribunal Caseworker, Medical Member cover) **moves to the wave-2 position** and a **new ET Journey 1** is authored covering the same service chain — absence → vacancy → booking → sitting → payment — with ET roles and a lay-member cover scenario. Journey numbering otherwise holds; the Phase-by-Phase mapping table and the "six journeys" count update accordingly.

**Deferred to the ET as-is pack:** the ET journey's persona, panel-composition trigger and off-system advertising process cannot be written credibly until R2 resolves. Draft it as a **structural placeholder** in this cascade and complete it at Step 5.

#### 4.6 PRD — Glossary

**Add:** `Employment Tribunals (ET)` · `Employment Judge` · `Regional Employment Judge` · `Non-legal member (lay member)` · `[ET-INCUMBENT-TBD]` (placeholder entry stating the unknown explicitly).
**Amend:** `SSCS` (wave-1 → wave-2 jurisdiction) · `ListAssist` (wave-1 → wave-2 parity reference) · `GAPS` (retained; wave-2 context) · `RTJ`, `Tribunal Member`, `Tribunal Panel` (relabel as SSCS/wave-2 concepts).
**Unchanged:** `Jurisdiction` — the hierarchy definition already accommodates ET as a Tribunals child.

#### 4.7 Architecture — new gaps

Append to `architecture/gaps.md`:

| Gap | Statement | Resolution path |
|---|---|---|
| **G8.4** | **ET's judicial-scheduling incumbent is unidentified.** Blocks D5 (behavioural reference), FR60/NFR41 (UAT parity target), NFR36 (rollback target), NFR32 (historical-data location), and the business case's benefit statement. Recorded as `[ET-INCUMBENT-TBD]` throughout. | Confirm with the ET programme; settle in the ET as-is analysis pack. Closes when the incumbent is named and the token is swept. |
| **G8.5** | **ET JOH type taxonomy and role set are unconfirmed.** No ET evidence exists in the repo. Working assumption: Employment Judges (salaried/fee-paid), Regional Employment Judges, non-legal members (employer-side / employee-side panels). | **ET as-is analysis pack** — a new wave-1 deliverable, parallel to the JI pack under `docs/architecture/asis/`. The SSCS pack defers to wave 2. |
| **G8.6** | **JFEPS/Liberata applicability to ET is unverified.** SSCS applicability was explicitly verified (2026-06-11, `payment-batch-flow.md`); no ET equivalent exists. If ET lay members are paid by another route, NFR21 weakens and Phase 6 acquires wave-1 risk. | Re-run the payment-flow applicability verification for ET before the Phase 6 gate. |

**Amend G8.1** — eLinks `jo_jurisdictions` coverage of ET is promoted from a general Phase 0 concern to a **wave-1 blocker**.
**Amend G8.3** — retarget from "ListAssist historical access for wave 1" to "`[ET-INCUMBENT-TBD]` historical access for wave 1"; the ListAssist question survives at wave 2.

#### 4.8 Epic AC edits (3 lines, all text-only)

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

#### 4.9 Business case — retarget, with two evidence items outstanding

**ET as wave 1 is a settled programme decision** (confirmed 2026-08-07); the case is written on that basis, not as a proposal. Mechanical retargeting (Decision Sought, Scope, Roadmap, Benefits, Asks) is straightforward. **Two items carry SSCS-gathered evidence that does not transfer, and are flagged inline as outstanding rather than as open questions:**

- **Strategic Case, driver #2** — currently "SSCS scheduling depends on ListAssist, a separate aged tool". The ET equivalent lands with G8.4.
- **Options appraisal, Option C** — the "contained, lower-risk wave" risk profile was assessed for SSCS. ET's equivalent lands with the ET as-is analysis pack (G8.5).

#### 4.10 Repo-level and generated

- `CLAUDE.md` line 9 · `README.md` line 9 — programme summary retargeted to the three-tier wave sequence
- `_bmad-output/project-context.md` line 71 — incumbent-parity rule: `(ET [ET-INCUMBENT-TBD] wave 1 / ListAssist SSCS wave 2 / APEX Courts waves 3+)`
- **`.claude/memory/project_bmad_ctam_pathfinder_state.md`** (git-tracked working-state file) — **highest misdirection risk of any file in this list.** Its "Next" and "Remaining cascade" sections instruct the next session to run an *SSCS-cohort* readiness assessment and commission an *SSCS as-is analysis pack*; both now retarget to ET. Line 10 additionally carries pre-v3.7 staleness ("SSCS jurisdiction (replacing GAPS)") that the 2026-06-18 correction never reached. Retarget the forward-looking sections; leave the dated **Done** entries as history.
- `scripts/python/build_html.py` — add `("Sprint Change Proposal — 2026-08-07 (ET-first pilot)", "sprint-change-proposal-2026-08-07", False)` to `NAV`. Leave the two historical SSCS-labelled `NAV` strings (lines 239, 241) untouched.
- `architecture/changelog.md` — **append v4.0** ("Wave-1 pilot retargets SSCS → Employment Tribunals; SSCS to wave 2; Courts to waves 3+; D13 supersedes D11; new gaps G8.4–G8.6"). Existing rows are immutable history.
- `docs/**` — regenerate via `scripts/build-html.sh`. Never hand-edit.

---

### Section 5 — Implementation Handoff

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

### Appendix — Sweep inventory (2026-08-07)

| File | SSCS | ListAssist | wave 2 | Action |
|---|---:|---:|---:|---|
| `prd.md` | 61 | 32 | 37 | Full cascade |
| `prd-validation-report-2026-06-10.md` | 37 | — | 4 | **Immutable** |
| `#sprint-change-proposal-2026-06-10` | 32 | — | 8 | **Immutable** |
| `architecture.md` | 22 | 13 | 12 | Full cascade |
| `business-case.md` | 18 | 8 | 6 | Cascade + evidence refresh (2 items) |
| `prd-validation-report-2026-06-17.md` | 12 | — | 1 | **Immutable** |
| `implementation-readiness-report-2026-06-17.md` | 9 | — | — | **Immutable** |
| `architecture-summary.md` | 8 | 6 | 4 | Full cascade |
| `epics/framework.md` | 6 | 3 | 3 | Cascade (Phase 9 section rewritten) |
| `epics/requirements-inventory.md` | 5 | 5 | 4 | Cascade |
| `#sprint-change-proposal-2026-06-17` | 4 | — | — | **Immutable** |
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
| `.claude/memory/project_bmad_ctam_pathfinder_state.md` | 6 | — | 1 | Retarget forward-looking sections; **Done** entries immutable |
| `scripts/python/build_html.py` | 2 | — | — | **Add NAV row only** — existing labels immutable |
| `docs/architecture/asis/**` | 10 | — | — | **Read-only source — do not edit** |
| `queries/sscs-locations-queries.md` | n/a | — | — | Legacy/exploratory — out of scope |

---

*Generated by `bmad-correct-course` · Batch mode · 2026-08-07*

---

## Sprint Change Proposal — 2026-08-13

*Programme renamed RAM → CTAM (Court and Tribunals Availability Management)*

**Programme name: RAM → CTAM (*Court and Tribunals Availability Management*)**

---

### Section 1 — Issue Summary

**Trigger:** The programme is renamed. **RAM** (*Resource Availability/Allocation Management*) becomes **CTAM** (*Court and Tribunals Availability Management*). The new name states the domain — Courts and Tribunals — rather than the generic capability, and aligns the programme's identity with HMCTS's organisational language.

**Disposition agreed at intake (2026-08-13):** full rename, applied in place, across every surface at once. Four points were settled before any edit was made:

| Question | Decision |
|---|---|
| How deep into technical identifiers? | **All the way** — repos, table prefix, Java package, artefact coordinates, schema name and DNS, not just prose |
| Does "Pathfinder" survive? | **Yes** — the product codename is **CTAM Pathfinder** |
| Dated reports / prior changelog entries? | **Rewritten in place**, overriding the standing "immutable history" convention — the git history is the point-in-time record |
| Change record? | **This SCP + a `changelog.md` v4.1 entry + D14 in the PRD** |

**Discovery context:** Raised while the programme still sits between planning and execution. **Implementation has not started** — all six Phase 0 epics are `status: not-started` with `owner: null` in `delivery/ledger/`, and `_bmad-output/implementation-artifacts/` is empty. Like SCPs 2026-07-06, 2026-07-09 and 2026-08-07, this is a **documentation change with no code to unwind**. Unlike those, it carries **no semantic content at all** — it is the largest surface and the smallest risk in the programme's history.

**Evidence — measured surface (repo-wide sweep, 2026-08-13, excluding the generated `docs/` site):**

| Surface | Occurrences | Form |
|---|---|---|
| Product codename | 626 | `RAM Pathfinder` → `CTAM Pathfinder` |
| Repository names (17) | 1,274 | `ram-*` → `ctam-*` |
| Owned-table prefix + index names | 606 | `ram_*` → `ctam_*`, `uq_ram_*` → `uq_ctam_*` |
| Adjectival prose | 214 | `RAM-owned` / `RAM-assigned` / `RAM-internal` / `RAM-overlay` |
| Java root package | 37 | `uk.gov.hmcts.ram` → `uk.gov.hmcts.ctam` (incl. `src/…/uk/gov/hmcts/ram/` paths) |
| API-spec artefact coordinates | 13 | `api-ram-{service}` → `api-ctam-{service}` |
| DNS hostnames + shared schema | 8 + 1 | `ram.hmcts.gov.uk`, `api.ram.{env}.hmcts.gov.uk`, `admin.ram.hmcts.gov.uk`; schema `ram` |
| **Total, across 88 files** | **~2,780** | 60 under `planning-artifacts/`, plus `CLAUDE.md`, `README.md`, `project-context.md`, `sql/`, `queries/`, `scripts/python/`, `.claude/` |

A further **80 files under `docs/`** carried the old name; `docs/` is generated and was **regenerated**, not edited.

**Two paths were renamed on disk:**

- `planning-artifacts/briefs/brief-ram-analysis-2026-08-09/` → `brief-ctam-analysis-2026-08-09/`
- `.claude/memory/project_bmad_ram_pathfinder_state.md` → `project_bmad_ctam_pathfinder_state.md`

---

### Section 2 — Impact Analysis

#### 2.1 The central finding — nothing but the name moves

**No FR, NFR, epic, story, decision, gap or assumption changes.** The 16-repo decomposition, the 55-table data model, all 60 FRs / 42 NFRs, the Phase 0–8 build sequence, all 6 Phase 0 epics / 19 stories, `dispatch-graph.yaml`, `delivery/ledger/` and decisions D1–D13 stand exactly as they were. Only the tokens naming them differ.

This is a rename, not a course correction. It is recorded through the SCP machinery because the surface is programme-wide and the artifact set must be traceable — not because anything was reconsidered.

#### 2.2 What was deliberately *not* renamed

The `ram`/`RAM` token was **only** replaced where it names this programme. Three classes were held back:

- **Upstream reference-data prefixes `jo_` and `mrd_`** — these name JOH eLinks and MRD, source systems outside this programme. The two-tier ownership contract in `conventions.md` (tier-(a) upstream, read-only in CTAM; tier-(b) CTAM-owned) is unchanged; only the tier-(b) prefix moves.
- **The dev-only `mock_` prefix** — never production, never programme-named.
- **English words containing the letters `ram`** — `framework`, `parameter`, `diagram`, `reframed`, `FedRAMP`, and the author name `Ramnish`. The sweep used boundary-anchored patterns (`(?<![A-Za-z0-9_])RAM(?![A-Za-z0-9_])` and `(?<![A-Za-z0-9])ram(?![A-Za-z0-9])`), so `ram` was matched only as a standalone token or as the leading segment of a `ram-`/`ram_`/`_ram_` identifier. A blind find-replace would have corrupted all six; a pre-flight sweep enumerated them and a post-flight sweep confirmed none were touched.

#### 2.3 Why now, and why in one pass

**No code exists yet.** Every one of the 16 target repos is unbuilt, no Flyway migration has run, no artefact has been published to the internal repository, and no DNS record has been cut. The rename therefore needs **no migration, no deprecation window, no dual-naming period, and no rollback plan** — the three mechanisms that normally make a platform-wide rename expensive are all inapplicable.

Deferring it does not preserve optionality; it only raises the price. Once `ctam-shared-infrastructure` provisions the estate and `ctam-reference-data` runs its first migration, the table prefix becomes a data-migration problem and the DNS names become a cutover problem.

#### 2.4 The one convention deliberately overridden

`CLAUDE.md` states: *"Leave dated reports and existing changelog entries as immutable history — add, don't rewrite."* That rule was **overridden for this change**, by explicit decision.

The reasoning: those documents record *decisions*, and no decision changed. Preserving `RAM` inside the 7 SCPs, 5 readiness reports and 2 validation reports would leave the artifact set unsearchable under a single name and would strand ~40% of the corpus in vocabulary no one will use again — for the benefit of a point-in-time record that **git already holds exactly**. The rule exists to protect the substance of historical judgements; renaming a token does not touch that substance.

This override is scoped to this change and does not weaken the convention for future SCPs, where the rewritten text *would* carry semantic content.

#### 2.5 Downstream consumers

Nothing is published or consumed yet, so there is no external notification list. Two items are flagged for whoever executes them:

- **GitHub repository names.** `hmcts/ram-analysis` has already been renamed to `hmcts/ctam-analysis` (this repo's `origin` confirms it). The other 16 repos **do not yet exist** — they will simply be created under their `ctam-*` names.
- **Azure DNS.** `ctam.hmcts.gov.uk`, `api.ctam.{environment}.hmcts.gov.uk` and `admin.ctam.hmcts.gov.uk` are now the names to reserve. No existing record needs retiring.

---

### Section 3 — Recommended Path Forward

**Direct adjustment, single batch.** No epic rollback, no re-planning, no PRD re-validation is warranted — validation assesses requirement quality, and no requirement changed.

**Applied:**

1. Boundary-anchored token sweep over all 88 tracked non-`docs/` files (verified clean in both directions: zero residual `RAM`/`ram` programme tokens; zero corrupted `framework`/`parameter`/`diagram`/`reframe`/`Ramnish`/`FedRAMP`).
2. Two on-disk path renames (§1).
3. **PRD** — new decision **D14**; new **CTAM** glossary entry recording both the expansion and the retired one; `[^d14]` footnote; `editHistory` entry.
4. **Architecture** — `changelog.md` **v4.1**.
5. **This SCP**, plus its `build_html.py` NAV entry.
6. **`docs/` regenerated** via `scripts/build-html.sh`.

**Not applied, and deliberately so:** no FR/NFR renumbering, no epic or story edits beyond the token sweep, no new gap or assumption, no readiness re-assessment.

---

### Section 4 — Change Scope Summary

| Artifact | Change |
|---|---|
| [`prd.md`](./prd.md) | **D14 added**; **CTAM** glossary entry added; `[^d14]` footnote; `editHistory` entry; token sweep throughout |
| [`business-case.md`](./business-case.md) | Token sweep |
| [`architecture.md`](./architecture.md) · [`architecture-summary.md`](./architecture-summary.md) | Token sweep — incl. shared schema `ram` → `ctam`, DNS endpoints, `uk.gov.hmcts.ctam.{service}.{layer}`, `api-ctam-{service}` |
| `architecture/` shards | Token sweep across [`conventions.md`](./architecture/conventions.md) (table-prefix rule), [`data-tables.md`](./architecture/data-tables.md) (all 55 tables + `uq_ctam_*` indexes), [`repository-strategy.md`](./architecture/repository-strategy.md), [`repo-structure.md`](./architecture/repo-structure.md) (source-tree paths), [`delivery-operating-model.md`](./architecture/delivery-operating-model.md), [`user-types.md`](./architecture/user-types.md), [`gaps.md`](./architecture/gaps.md), [`assumptions.md`](./architecture/assumptions.md), [`starter-template.md`](./architecture/starter-template.md), FR/NFR coverage, `diagrams/`, `sequence-diagrams/` |
| [`architecture/changelog.md`](./architecture/changelog.md) | **v4.1 entry added**; prior entries token-swept |
| `epics/` | Token sweep — [`framework.md`](./epics/framework.md), [`index.md`](./epics/index.md), [`fr-coverage-map.md`](./epics/fr-coverage-map.md), [`requirements-inventory.md`](./epics/requirements-inventory.md), all `phase-0/` epics. **No epic or story added, removed, re-scoped or resequenced.** |
| `delivery/` | Token sweep — [`dispatch-graph.yaml`](./delivery/dispatch-graph.yaml) (repo targets), `ledger/` shards, [`README.md`](./delivery/README.md). **No status or owner changed.** |
| Dated reports (7 SCPs, 5 readiness, 2 validation) | Token sweep — **rewritten in place** per §2.4 |
| `briefs/` | Directory renamed `brief-ram-analysis-2026-08-09` → `brief-ctam-analysis-2026-08-09`; contents swept |
| **This SCP** | New |
| Repo-level — `CLAUDE.md`, `README.md`, `project-context.md` | Token sweep |
| Legacy/exploratory — `sql/`, `queries/` | Token sweep (mock DDL comments, `psql -d ctam_mock`) |
| Tooling — `scripts/python/` (`build_html.py`, `build_graph.py`, `apply_okf_frontmatter.py`), `scripts/build-html.sh`, `.claude/lib/`, `.claude/memory/` | Token sweep; `build_html.py` NAV gains this SCP; memory file renamed |
| **`docs/`** | **Regenerated** — never hand-edited |

**Handoff:** none required. No agent, epic or repo is blocked by this change; the next action is unchanged from before it — sprint planning on Epic 0.0.

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

---

## Sprint Change Proposal — 2026-08-20

*one branch per story, created at dispatch; story/{story-id} replaces feature/ for story work*

**One branch per story, created at dispatch**

---

### Section 1 — Issue Summary

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

### Section 2 — Impact Analysis

#### 2.1 What changes

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

#### 2.2 A branch-naming convention is amended

`conventions.md` → *Git conventions* previously prescribed `feature/{ticket-id}-{short-description}` for all work. Story work now uses **`story/{story-id}`** — e.g. `story/0.1.4`. `bugfix/`, `chore/` and `feature/` remain for work that is not a dispatched story.

Two reasons for the rename rather than reusing `feature/`:

- **It carries the story id, which is what the claim check matches on.** A `feature/CTAM-123-mrd-ingestion` branch does not tell the pre-flight check which story it claims; `story/0.1.4` does, and the existing regex already matches it.
- **It says what the branch is.** One branch that holds a packet, its implementation and its review is not a generic feature branch, and naming it after the story makes the one-branch-per-story rule self-evident on the branch list.

#### 2.3 What this does not change

The human gate is untouched: `main` stays protected, and opening, approving and merging the pull request remain the human's (SCP 2026-08-19c). An agent still cannot use the GitHub CLI, so it cannot open the PR — it reports the compare URL and stops.

Nor does this reintroduce anything the ledger did. There is still no `owner` field and no shared mutable state to contend over; the branch is the claim, and it now exists from the earliest moment it could.

#### 2.4 Residual weakness, stated plainly

A branch is a *claim*, not a *lock*. Two people dispatching the same story within the same minute can both create it, and the second push simply fails or diverges. The mitigation remains the convention — **one dispatcher at a time** — with the pre-flight check as the backstop rather than a guarantee. That was accepted when the ledger was retired and is unchanged here.

---

### Section 3 — Recommended Path Forward

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

### Section 4 — Change Scope Summary

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

---

## Sprint Change Proposal — 2026-08-21

*2026-08-21 (bmad-create-story override retired; deviation register added)*

**Type:** tooling / delivery-contract simplification. **No** scope, requirement, epic, story or architecture change.

### Trigger

BMad 7 is expected to support polyrepo and multi-user delivery natively. `_bmad/custom/bmad-create-story.toml` had grown to fourteen `activation_steps_append` instructions — rebinding story identity, epic input, output location, packet shape, bus reads, epic guards and branching. Carrying it until v7 would make the migration a rewrite rather than a delete, because the override does not merely redirect paths: it restates BMad's own step logic in prose, which has to be diffed against v7 line by line to know what is still needed.

Delivery state made the decision cheap: **21 stories in `sprint-status.yaml`, one done** (0.6.1). The migration bill scales with the number of packets written under the override, and that number is one.

### Decision

1. **Delete `_bmad/custom/bmad-create-story.toml`.** `bmad-create-story` reverts to stock BMad 6.
2. **Add a deviation register** to [`architecture/delivery-operating-model.md`](architecture/delivery-operating-model.md) — nine rows, each with why CTAM needs the deviation, what stock BMad 6 does instead, and the **v7 exit condition** that retires it.

The register replaces the override's function: the knowledge was previously reconstructable only by reading the override, two scripts and six documents. One table now carries it, and becomes the v7 migration checklist.

### What this costs, stated plainly

**Dispatch is no longer safe unattended.** Six of the nine deviations are live against stock BMad 6. The worst is silent: BMad's epic glob (`*epic*/*.md`) matches no CTAM epic file, a miss is treated as "not an error", and the workflow then has no epic content to read — so **acceptance criteria are invented rather than carried verbatim**. A dispatcher must read the register and handle deviations 1–6 by hand, or wait for v7.

This is accepted deliberately. Nothing is in flight, and no dispatch is planned before v7.

### Retained, and why it costs nothing

`scripts/dispatch-preflight.sh`, `scripts/validate-story-packet.sh` and `scripts/publish-arch.sh` stay. No BMad skill reads them, so they are not extensions of BMad and carry no migration cost — they are invoked by hand from the delivery loop. `scripts/publish-arch.sh` is additionally an acceptance criterion of [Epic 0.6](epics/phase-0/epic-0.6-context-bus-and-shared-baseline.md).

`_bmad/custom/config.toml` (an empty team-override stub) and the `.gitignore` negation that keeps `_bmad/custom/` tracked both remain.

### Deliberately not done

- **Flattening `epics/phase-0/` → `epics/`** and **renumbering story ids to two parts** would delete deviations 1 and 2 outright and are native BMad 6 moves, not v7 bets. Deferred: the flatten is a 29-reference change, the renumber ~314 references plus a bus retag, and neither buys anything while dispatch is paused. Both are recorded as v7 exit conditions instead.
- Removing the polyrepo packet shape from the bus (`ctam-architecture/agent-rules/templates/story-packet.md`). It stays valid; retiring it needs a coordinated bus change and an `arch-vN` tag.

### Sections affected

- `_bmad/custom/bmad-create-story.toml` — **deleted**
- [`architecture/delivery-operating-model.md`](architecture/delivery-operating-model.md) — new *Deviation register*; the enforcement bullet updated
- [`delivery/README.md`](delivery/README.md) — BMad skill mapping note
- `_bmad-output/implementation-artifacts/sprint-status.yaml` — header caveat
- [`architecture/changelog.md`](architecture/changelog.md) — v4.8

---

## Sprint Change Proposal — 2026-08-24

**Status:** approved

**Trigger:** *"We don't have real APIs to consume the data from JOH. We are building a mock API with mock data for consumption."* — evidenced by `/Users/shivakumar/MOJ/ctam-jomockapi`, an already-implemented Node/Express mock of the **Judiciary "E-links" People API v5**, built directly from the real `Swagger UI.pdf` + `apiresponses.docx` and populated from the real `ReferenceData/*.csv|json` exports.

**Mode:** Batch. **Scope classification:** Moderate (backlog reorganisation — new epic + story amendment + architecture-shard updates; no PRD/MVP change).

---

### 1. Issue Summary

Phase 0's foundational data layer (Epic 0.1, `ctam-reference-data`) is built on an **unconfirmed external dependency**: the JOH eLinks API contract (gaps.md **G8.1**, business-case.md risk #1, "Med/High"). The existing mitigation on record is thin — Story 0.1.3's AC and the 2026-06-17 implementation-readiness report both point to *"the sync code path is integration-tested against a WireMock/stub eLinks API in CI"* (AR52-referenced). That mitigation is CI-test-only: it proves the sync *code path* compiles and runs against a canned response, but nothing in the current plan lets the real `@Scheduled` nightly sync job run **end-to-end against a live network endpoint** in dev or staging, and nothing gives Phase 0 a demoable ingestion walkthrough before the real eLinks contract lands.

That gap has now been closed by work already done outside this repo: `ctam-jomockapi` is a complete, runnable mock service — not a test fixture — covering the full documented eLinks v5 contract (auth-token behaviour, `/people` change-feed with `updated_since`/pagination, `/leavers`, `/deleted`, and all 11 `/reference_data/:attribute_name` vocabularies), seeded with 100 realistic JOH profiles joined against the **real** production reference-data exports (2000 locations, 1462 base locations, 194 appointment titles, 164 judiciary roles, 159 tickets, 54 ticket categories, etc.), with a fixed random seed for stable ids across restarts.

**This is a legitimate correct-course trigger, not a scope change:** it doesn't alter any FR/NFR, PRD goal, or the eventual need to confirm the real eLinks contract (G8.1 stays open). It upgrades the *interim substitute* for that contract from "CI-only WireMock stub" to "a deployed, schema-faithful mock service" — which was already the plan's own stated mitigation pattern (business-case.md: *"Build against a WireMock stub now; contract gates production cutover only"*), just not yet reflected as a repo, an epic, or a deployment target in the tracked artifacts.

### 2. Impact Analysis

#### Epic impact

- **Epic 0.1** (`epics/phase-0/epic-0.1-upstream-reference-data-ingested.md`) is **not invalidated** — it proceeds as planned. **Story 0.1.3** gains one new AC block: the dev/staging nightly sync points at the deployed `ctam-jomockapi` endpoint (config-driven base URL + Key-Vault-held bearer token, mirroring the real eLinks credential wiring per NFR16) rather than `localhost`; the existing CI WireMock stub (AR52) is retained for pure unit/integration tests — the two are complementary, not a replacement of one by the other.
- **New Epic 0.7** is added: *"JOH eLinks mock API stands in for the unconfirmed upstream contract."* It onboards `ctam-jomockapi` as a CTAM Pathfinder repo, deploys it onto the shared estate (Epic 0.0), and hands `ctam-reference-data` a live URL to sync against. It is **not numbered 0.1a / inserted mid-sequence** — following the Epic 0.6 precedent ("the number is not the order"; see `depends_on`), it runs in parallel with / shortly after Epic 0.0 and ahead of Story 0.1.3's dev-verification AC.
- No other Phase 0 epic (0.0, 0.2–0.6) changes. No Phase 1–8 epic is affected (none exist yet beyond framework-level prose).

#### Story impact

- **Story 0.1.3** — amended AC (see §4).
- **New Stories 0.7.1–0.7.3** — repo onboarding, dev/staging deployment, and the wiring-in of Story 0.1.3's sync against it.

#### Artifact conflicts / updates needed

| Artifact | Conflict | Change |
|---|---|---|
| `architecture/repository-strategy.md` | States "16 repos total"; `ctam-jomockapi` isn't listed | Add repo row; 16 → 17 |
| `architecture/gaps.md` (G8.1) | Silent on the mock's existence | Append dated note: mock unblocks *dev*, contract confirmation still gates *production* |
| `architecture/assumptions.md` | No assumption records the mock | Add **A38**, mirroring the `ctam-mock-auth` precedent (A26/A27: non-prod only, contract parity claim scoped) |
| `architecture.md` (decision log) | No record of this decision | Add **decision #14** |
| `architecture/changelog.md` | No entry | Add **v4.9** |
| `epics/framework.md` (Phase 0 · Area: Reference Data) | Ingestion narrative doesn't mention a dev/staging network target | One-sentence addition |
| `epics/fr-coverage-map.md` / `architecture/non-functional-requirements-coverage.md` (NFR24) | Coverage row doesn't cite Epic 0.7 | Add cross-reference |
| `epics/phase-0/index.md` | Epic table, summaries, story counts (19 → 22) | Add Epic 0.7 row + summary |
| `epics/phase-0/epic-0.1-...md` | `depends_on` frontmatter unchanged; Story 0.1.3 AC | Add AC block; no `depends_on` change (see below) |
| `CLAUDE.md` | "16-repo polyrepo" repo list | 16 → 17; add `ctam-jomockapi` |
| `_bmad-output/implementation-artifacts/sprint-status.yaml` | No epic-0.7 entries | Add epic-0.7 + 3 stories, `backlog` |
| `docs/*.html` | Generated from the above | Regenerate via `scripts/build-html.sh` after all edits land |

**No PRD, UX, or FR/NFR change.** No change to `data-tables.md` (no new persisted table — the mock is external infrastructure, not a CTAM-owned schema) or to `conventions.md` (the deviation is scoped and justified inline, not a house-wide rule change).

**On `depends_on`:** Epic 0.1's frontmatter is **left unchanged** (`[epic-0.0, epic-0.6]`). Making the whole of Epic 0.1 depend on Epic 0.7 would block Stories 0.1.1 (scaffold) and 0.1.2 (tier-(a) tables) on a repo-onboarding epic they don't need — `depends_on` in this codebase is epic-granularity only (`scripts/dispatch-preflight.sh` gates the *whole* epic on it), so a hard dependency here would be needlessly coarse. Story 0.1.3's new AC instead carries the sequencing note inline — the same pattern already used for its existing G8.1/AR52 callouts. Epic 0.7 itself depends only on `epic-0.0` (needs the shared estate to deploy onto).

#### Technical impact

- `ctam-jomockapi` is Node.js/Express — a **deliberate, explicitly-scoped deviation** from the Java 25/Spring Boot 4 stack baseline in `_bmad-output/project-context.md`. Justification: it delivers no FR/NFR, is never deployed to production, and is not a CTAM Pathfinder domain service — the same category of exception the repository strategy already grants `ctam-mock-auth` (non-prod-only, contract-parity tooling, distinct lifecycle from the 15 production/UI repos). It is **not** rewritten in Java; the existing implementation is onboarded as-is.
- Deploying it onto the shared AKS estate needs: a minimal Helm chart, a Key-Vault-held mock bearer credential (the mock accepts any non-empty token — Key Vault storage is for wiring-realism/parity with the real eLinks credential path, not because the mock enforces anything), and a `values-{env}.yaml` exposing its base URL to `ctam-reference-data`'s config.
- No database, no Liquibase, no tier-ownership — the mock generates its dataset in-memory at startup with a fixed seed; nothing to migrate or grant.

### 3. Recommended Approach

**Selected: Option 1 — Direct Adjustment** (new epic + one story's AC amended within the existing Phase 0 structure).

- **Option 2 (rollback)** — not viable/not applicable: no Epic 0.1 stories are built yet (all `backlog` in `sprint-status.yaml`); there is nothing to roll back.
- **Option 3 (MVP review)** — not needed: no FR/NFR/PRD goal is affected; this closes an execution risk the plan already flagged (business-case.md risk #1), it doesn't reopen it.
- **Option 1** fits cleanly: the architecture already has a precedent shape for exactly this kind of repo (`ctam-mock-auth` — non-prod mock, own epic-adjacent story, deployed onto the shared estate, explicit "never production" guard). Epic 0.7 reuses that shape for the JOH eLinks side.

**Effort:** Low–Medium. Three small stories (repo onboarding, Helm/deploy, wiring), no new production code path, no schema change. **Risk:** Low. The mock is additive infrastructure; if it were deleted tomorrow, Story 0.1.3 falls back to exactly today's plan (CI WireMock stub + real contract when it lands). **Timeline impact:** Positive — it *de-risks* Epic 0.1's dev/staging demo readiness ahead of the ET-cohort implementation-readiness assessment, rather than adding to the critical path (Epic 0.7 can run alongside Epic 0.0/0.6).

### 4. Detailed Change Proposals

#### 4.1 New file — `epics/phase-0/epic-0.7-joh-elinks-mock-api-stands-in.md`

```markdown
---
type: 'Epic'
description: 'User outcome: ctam-reference-data'"'"'s nightly eLinks sync runs end-to-end against a deployed, schema-faithful mock of the JOH eLinks People API v5, so Phase 0 has a demoable ingestion pipeline in dev/staging before the real eLinks contract (gaps.md G8.1) is confirmed.'
resource: 'epics/phase-0/epic-0.7-joh-elinks-mock-api-stands-in.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-24'
parent: 'epics/phase-0/index.md'
epic: 0.7
title: 'JOH eLinks mock API stands in for the unconfirmed upstream contract'
storyCount: 3
repo: ctam-jomockapi
depends_on: [epic-0.0]
---

# Epic 0.7: JOH eLinks mock API stands in for the unconfirmed upstream contract

**User outcome:** `ctam-reference-data`'s nightly JOH eLinks sync (Story 0.1.3) runs **end-to-end against a live, deployed mock** of the eLinks People API v5 — not just a CI-only WireMock stub — so Phase 0 has a genuine, demoable ingestion pipeline in dev/staging while the real eLinks API contract remains unconfirmed (gaps.md G8.1). `ctam-jomockapi` is onboarded as CTAM Pathfinder's 17th repo, non-production-only, in the same category as `ctam-mock-auth` (repository-strategy.md).

**Hosting:** `ctam-jomockapi` is a standalone Node.js/Express service — an explicitly-scoped deviation from the Java/Spring Boot stack baseline (see gaps.md / assumptions.md A38), justified because it delivers no FR/NFR and never deploys to production. It deploys onto the shared estate provisioned in Epic 0.0, alongside `ctam-mock-auth`.

**Vertical slice:**
- Onboard the existing `ctam-jomockapi` codebase as a CTAM Pathfinder GitHub repo, per the manual GitHub-setup runbook (D10 — no `gh` CLI)
- CI: run its existing test suite (`npm test`), build + push a container image to ACR
- A minimal Helm chart deploying it to dev/staging AKS, fronted by the shared APIM gateway
- A Key-Vault-held mock bearer credential, wired the same way the real eLinks credential will be (NFR16) — the mock itself accepts any non-empty token, so this exercises the *wiring*, not an auth check
- `ctam-reference-data`'s eLinks sync (Story 0.1.3) points its dev/staging base URL at the deployed mock instead of `localhost`

**FRs covered:** none directly (infrastructure/tooling, not a product feature). **Supports:** FR1, FR6 tier-(a), FR7 tier-(a), NFR24 (exercised end-to-end pre-contract).

**Key NFRs first exercised here:** NFR16 (Key Vault credential wiring, dev/staging), NFR31 (Azure UK South), NFR40 (per-service deployable).

**Out of scope (explicitly):**
- The real JOH eLinks API contract (gaps.md G8.1 remains open until Judicial Office confirms it; production cutover is gated on that, not on this epic)
- MRD ingestion (Story 0.1.4) — the mock covers eLinks only, not MRD's Excel feed
- Rewriting `ctam-jomockapi` in Java/Spring — it stays Node/Express as already built
- Production deployment of `ctam-jomockapi` — never (same guard as `ctam-mock-auth`, A27-equivalent)

---

## Story 0.7.1: Onboard `ctam-jomockapi` as a CTAM Pathfinder repo

As a **platform engineer**,
I want the existing `ctam-jomockapi` codebase onboarded as a CTAM Pathfinder GitHub repo with CI wired to its existing test suite,
So that **the mock is a tracked, reviewable, CI-gated artifact like every other repo in the polyrepo**, not an out-of-band local tool.

**Acceptance Criteria:**

**Given** the engineer has performed the GitHub manual-setup checklist (`ctam-architecture/runbooks/github-setup.md`),
**When** `ctam-jomockapi`'s existing code (README, `server.js`, `src/`, `test/`, `package.json`, `ReferenceData/*.csv|json`, `Swagger UI.pdf`, `apiresponses.docx`) is pushed to a new private repo under the HMCTS org via a feature branch and PR (no `gh` CLI, per D10),
**Then** branch protection on `main` is enabled (require PR review, require status checks, require linear history),
**And** `.github/workflows/ci.yml` runs `npm install && npm test` plus a container build (`docker build`),
**And** `CODEOWNERS` and `PULL_REQUEST_TEMPLATE.md` exist per CTAM convention.

**Given** the onboarded repo,
**When** a CI run completes on the PR,
**Then** the existing test suite (`test/`) passes,
**And** the container image builds and is pushed to ACR on merge to `main`.

**Given** this is a non-production-only mock,
**When** the Helm values / CI workflow are authored,
**Then** there is **no** `deploy-production.yml` and **no** production Helm values file — mirroring `ctam-mock-auth`'s "never deployed to production" guard.

**References:** repository-strategy.md (new row); D10; **depends on Epic 0.0** is NOT required for this story (no deployment yet — Story 0.7.2 needs the estate).

**Explicitly NOT in scope:**
- Deployment to any environment — Story 0.7.2
- Any change to the mock's existing endpoint behaviour, seeded data, or auth handling

---

## Story 0.7.2: Deploy `ctam-jomockapi` onto the shared dev/staging estate

As a **platform engineer**,
I want `ctam-jomockapi` deployed onto the shared Azure estate (Epic 0.0) in dev and staging, with its mock bearer credential held in Key Vault,
So that **it is reachable over the network by `ctam-reference-data`'s scheduled sync job**, not just runnable locally via `npm start`.

**Acceptance Criteria:**

**Given** `ctam-jomockapi` is onboarded per Story 0.7.1, and the shared estate (AKS, ACR, Key Vault, APIM) is provisioned and verified per Epic 0.0,
**When** a Helm chart (`charts/ctam-jomockapi/` with `values-dev.yaml` / `values-staging.yaml`) is deployed,
**Then** the service runs as a pod in the dev AKS cluster, reachable at a stable in-cluster/APIM-fronted URL,
**And** liveness/readiness probes pass against `GET /api/v5/healthcheck` (public, no auth, per the mock's existing contract),
**And** the deployed pod's logs confirm the mock data was generated with the documented fixed seed (ids stable across restarts).

**Given** the mock requires a bearer token (any non-empty value, per its existing auth behaviour),
**When** a mock credential is provisioned in the shared Key Vault (namespaced to `ctam-jomockapi`, separate from the real eLinks credential slot reserved for `ctam-reference-data`),
**Then** the credential round-trips from a pod via workload identity (same pattern as Epic 0.0's Key Vault verification),
**And** no production Key Vault namespace or profile is created for this credential (non-prod only).

**Given** the deployed mock,
**When** an engineer curls `GET /api/v5/reference_data/jurisdictions` with the Key-Vault-sourced token from within the dev cluster,
**Then** the response matches the documented `ReferenceDataResponse` shape and returns the real jurisdiction reference values.

**References:** NFR16 (Key Vault), NFR31 (UK South), NFR40 (per-service deployable); depends on Epic 0.0.

**Explicitly NOT in scope:**
- Wiring `ctam-reference-data`'s sync to this URL — Story 0.7.3
- Production deployment — never, per this epic's out-of-scope note

---

## Story 0.7.3: `ctam-reference-data`'s eLinks sync runs against the deployed mock in dev/staging

As a **CTAM Pathfinder platform** (and every downstream consumer of JOH identity and reference data),
I want Story 0.1.3's nightly `@Scheduled` eLinks sync to run, in dev and staging, against the `ctam-jomockapi` URL deployed in Story 0.7.2,
So that **the full ingestion pipeline — full-refresh-upsert, `ctam_joh_identities` minting, soft-deactivation of records absent upstream, `ctam_sync_status` logging — is demoable end-to-end before the real eLinks contract (G8.1) is confirmed.**

**Acceptance Criteria:**

**Given** `ctam-jomockapi` is deployed per Story 0.7.2, and the Key Vault credential is available to `ctam-reference-data`'s pod,
**When** `ctam-reference-data`'s dev/staging configuration sets the eLinks base URL to the deployed mock's URL instead of any placeholder/localhost value,
**Then** the nightly (and manually-triggered) sync run in Story 0.1.3 completes successfully against it,
**And** all 15 `jo_*` tables populate from the mock's `/people` change-feed and `/reference_data/*` responses,
**And** `jo_people.personnel_number` upserts correctly and mints `ctam_joh_identities` rows exactly as designed for a real upstream source.

**Given** the mock's `/leavers` and `/deleted` endpoints (100 records each, independent of the 100 `/people` profiles),
**When** the sync's soft-deactivation logic (rows absent upstream marked inactive, never hard-deleted, per AR46) is exercised against them,
**Then** the behaviour is verified against realistic leaver/deleted data — something the CI WireMock stub's canned fixtures don't exercise as thoroughly.

**Given** the CI-only WireMock/stub eLinks API (AR52) used by `ctam-reference-data`'s automated tests,
**When** this story lands,
**Then** the WireMock stub is **retained unchanged** for unit/integration tests — it and the deployed `ctam-jomockapi` are complementary (fast, hermetic CI checks vs. a realistic dev/staging network target), not a replacement of one by the other.

**Given** the real JOH eLinks API contract is still unconfirmed (gaps.md G8.1),
**When** this story's ACs are met,
**Then** G8.1 is **not** closed by this story — it remains open until Judicial Office confirms the real contract and it is validated against the (by-then-live) ingestion mapping; this story closes the *dev/staging demonstrability* gap only, not the *contract-confirmation* gap.

**References:** FR1, FR6 tier-(a), NFR24; gaps.md G8.1 (stays open); AR46, AR48, AR52; depends on Story 0.1.3 and Story 0.7.2.

**Explicitly NOT in scope:**
- Closing G8.1 — that needs the real contract from Judicial Office
- MRD ingestion (Story 0.1.4) — unaffected, no mock exists or is needed for MRD in this SCP
```

#### 4.2 `epics/phase-0/epic-0.1-upstream-reference-data-ingested.md` — Story 0.1.3 amendment

**OLD** (Story 0.1.3, third `Given/When/Then` block):
```
**Given** the sync has run successfully at least once in dev,
**When** `ctam-authorisation` (Epic 0.2, Story 0.2.3) looks up a seeded JOH email,
**Then** the lookup resolves against `jo_people` to a `personnel_number`, and via `ctam_joh_identities` to the CTAM JOH UUID,
**And** dev/CI environments use seeded `jo_*` fixtures loaded by the one-off seed scripts where a live eLinks connection is unavailable (per AR52 — the sync code path is integration-tested against a WireMock/stub eLinks API in CI).
```

**NEW** (adds a sentence + a new block immediately after):
```
**Given** the sync has run successfully at least once in dev,
**When** `ctam-authorisation` (Epic 0.2, Story 0.2.3) looks up a seeded JOH email,
**Then** the lookup resolves against `jo_people` to a `personnel_number`, and via `ctam_joh_identities` to the CTAM JOH UUID,
**And** dev/CI environments use seeded `jo_*` fixtures loaded by the one-off seed scripts where a live eLinks connection is unavailable (per AR52 — the sync code path is integration-tested against a WireMock/stub eLinks API in CI).

**Given** the JOH eLinks mock API (`ctam-jomockapi`, Epic 0.7) is deployed to dev/staging,
**When** the sync's dev/staging base URL is configured to point at it,
**Then** the nightly sync runs end-to-end against a live network endpoint modelling the real eLinks contract — not just the CI WireMock stub — giving Phase 0 a demoable ingestion pipeline ahead of the real contract landing (per Epic 0.7, Story 0.7.3).
```

**References line** — append `; Epic 0.7` after `gaps.md G8.1`.

#### 4.3 `architecture/repository-strategy.md`

- Line 1 decision statement: `11 service repos + 1 mock-auth repo + 1 JOH-mock repo + 2 UI repos (business + admin) + 1 architecture/scaffolding repo.` (frontmatter `description` and body).
- New table row, inserted after `ctam-mock-auth`:

  | Repo | Phase | Purpose | Key Functions |
  |---|---|---|---|
  | **`ctam-jomockapi`** | 0 | Node.js/Express mock of the **JOH eLinks People API v5**, standing in for the unconfirmed upstream contract (gaps.md G8.1). **Never deployed to production.** | Serve the documented eLinks v5 contract (people change-feed, leavers, deleted, 11 reference-data vocabularies) from realistic seeded data joined against real production reference-data exports; give `ctam-reference-data`'s dev/staging eLinks sync a live network target (Epic 0.7). |

- Closing summary line: `**16 repos total**` → `**17 repos total** (11 production services + 2 UI + architecture + mock-auth + JOH-mock + shared-infrastructure). ... \`ctam-jomockapi\` is dev/staging/CI-only and never deploys to production, in the same category as \`ctam-mock-auth\`.`

#### 4.4 `architecture/gaps.md` — G8.1 (append, don't rewrite the row)

Append to the end of the G8.1 **Detail** cell:

> **Mock unblock added 2026-08-24 (SCP 2026-08-24):** a schema-faithful mock of the eLinks People API v5 (`ctam-jomockapi`, built directly from the real Swagger doc + example-response docs, seeded from real reference-data exports) is now deployed to dev/staging (Epic 0.7) so Phase 0's ingestion pipeline is demoable end-to-end without waiting on this gap. **This does not close G8.1** — the mock is built from documentation, not a confirmed live contract, and production cutover still requires the real contract to be confirmed and the ingestion mapping validated against it.

#### 4.5 `architecture/assumptions.md`

New row (title becomes "Assumptions (A1–A38)"):

| **A38** *(new 2026-08-24, SCP 2026-08-24)* | `ctam-jomockapi` provides a schema-faithful mock of the JOH eLinks People API v5 (built from the real Swagger doc + `apiresponses.docx`, seeded from real reference-data exports) for Phase 0 dev/staging/CI consumption. It is **not** a confirmation of the real contract — mirrors A26/A27's mock-auth pattern: non-production only, contract-parity claim is scoped to what the public docs describe, and real-contract confirmation (G8.1) still gates production cutover. | Load-bearing **for Phase 0 dev/staging demonstrability only** | Epic 0.7 deliverable; enforced by CI/deploy guard (no production Helm values, per Story 0.7.1) |

#### 4.6 `architecture.md` — decision log

New row after #13:

| # | TBD | Resolution |
|---|---|---|
| 14 | Interim substitute for the unconfirmed JOH eLinks contract *(SCP 2026-08-24)* | **A deployed, schema-faithful mock — `ctam-jomockapi` (17 repos total)** — replaces "CI-only WireMock stub" as Phase 0's dev/staging demonstrability story, without closing G8.1. Onboarded as a new Epic 0.7, in the same non-production-only category as `ctam-mock-auth` (repository-strategy.md). Story 0.1.3 gains one AC block pointing its dev/staging sync target at the deployed mock; the existing CI WireMock stub is retained unchanged. See [`#sprint-change-proposal-2026-08-24`](#sprint-change-proposal-2026-08-24). |

#### 4.7 `architecture/changelog.md`

New version row:

| **v4.9 — JOH eLinks mock API (`ctam-jomockapi`) onboarded as Epic 0.7** | 2026-08-24 | **Additive, no FR/NFR/PRD change.** Adds a 17th repo, `ctam-jomockapi` (Node/Express, non-production-only — same category as `ctam-mock-auth`), giving `ctam-reference-data`'s eLinks sync (Story 0.1.3) a deployed, schema-faithful dev/staging network target while the real eLinks contract (G8.1) remains unconfirmed. G8.1 is **not closed** by this change. See [`#sprint-change-proposal-2026-08-24`](#sprint-change-proposal-2026-08-24). | `repository-strategy.md`, `gaps.md` (G8.1), `assumptions.md` (A38), decision log (#14), `epics/phase-0/epic-0.1-...md` (Story 0.1.3), new `epics/phase-0/epic-0.7-...md` |

#### 4.8 `epics/framework.md` — Phase 0 · Area: Reference Data

Append one sentence to the existing "Ingestion" paragraph: *"A deployed, schema-faithful mock of the eLinks API (`ctam-jomockapi`, Epic 0.7) gives the dev/staging sync a live network target while the real contract (gaps.md G8.1) remains unconfirmed."*

#### 4.9 `epics/fr-coverage-map.md` and `architecture/non-functional-requirements-coverage.md` (NFR24)

Append `; dev/staging demonstrability via Epic 0.7's deployed mock ahead of the real contract` to the existing NFR24 rows in both files.

#### 4.10 `epics/phase-0/index.md`

- Epic table: add a row `| [0.7](epic-0.7-joh-elinks-mock-api-stands-in.md) | JOH eLinks mock API stands in for the unconfirmed upstream contract | 3 | 🟡 Planned |`; **Total** stories 21 → 24.
- Add an "### Epic 0.7: ..." summary paragraph (mirrors the Epic 0.6 "runs between 0.0 and 0.1 — the number is not the order" framing).
- Phase 0 Epic Stories Summary table: add a `0.7` row (3 stories); **Total** 19 → 22 stories; update the 0.1 row's demo note to mention the deployed mock.

#### 4.11 `CLAUDE.md`

- "ships as a **16-repo polyrepo**" → "**17-repo polyrepo**"; add `ctam-jomockapi` to the parenthetical repo list (after `ctam-mock-auth`, before `ctam-reference-data`, matching the phase-0 grouping used elsewhere).

#### 4.12 `_bmad-output/implementation-artifacts/sprint-status.yaml`

Append after the `epic-0.6` block:

```yaml
  epic-0.7: backlog
  0-7-1-onboard-ctam-jomockapi-as-a-ctam-pathfinder-repo: backlog
  0-7-2-deploy-ctam-jomockapi-onto-the-shared-dev-staging-estate: backlog
  0-7-3-ctam-reference-data-s-elinks-sync-runs-against-the-deployed-mock-in-dev-staging: backlog
  epic-0.7-retrospective: optional
```

#### 4.13 Regenerate the site

Run `scripts/build-html.sh` after all markdown edits land (hard rule — `docs/*.html` is generated, never hand-edited).

### 5. Implementation Handoff

**Scope: Moderate** — backlog reorganisation (one new epic + one story's AC amended) plus a coordinated sweep across architecture shards that reference the repo count, G8.1, and the assumptions/decision/changelog ledgers. No PRD rewrite, no FR/NFR change, no re-plan of programme goals — routed as **Product Owner / Developer**, not Product Manager / Architect.

**Responsibilities:**
- **This session (Developer agent role)**: apply all edits in §4 directly (they're additive, mechanical, and don't touch `main` per the protected-branch hook — all writes are to tracked planning-artifact markdown in the working tree), then run `scripts/build-html.sh` to regenerate `docs/`.
- **Product Owner (human)**: confirm the new Epic 0.7 story numbering doesn't collide with any in-flight dispatch (checked: `sprint-status.yaml` shows Epic 0.1 fully `backlog`, so no collision), and decide when `ctam-jomockapi`'s GitHub-setup runbook step (Story 0.7.1) gets scheduled relative to Epic 0.0.
- **Judicial Office / eLinks liaison (unchanged owner)**: G8.1 remains their gate — this SCP does not change who owns confirming the real contract, only what CTAM can demonstrate before it lands.

**Success criteria:** all thirteen artifact edits in §4 land consistently (cross-references resolve, story/epic counts match across `index.md`, `sprint-status.yaml`, and the epic files themselves), `docs/` regenerates cleanly, and G8.1 in `gaps.md` explicitly still reads as open.

---

## Sprint Change Proposal — 2026-08-24b

**Status:** approved

**Trigger:** *"we are focusing on joh data as phase-0 update epic-0.1 as joh-reference-data-etl process"*

**Clarified via two questions before drafting:**
1. **"ETL" meaning** → **Rename/reframe only.** The technical design (in-process nightly `@Scheduled` sync, decision #9 in `architecture.md`) is unchanged. "ETL" becomes the epic's label for that ongoing pipeline.
2. **"Focusing on JOH data" scope** → **Split MRD out.** Epic 0.1 becomes JOH-eLinks-only (Stories 0.1.1–0.1.3); MRD ingestion (former Story 0.1.4) moves to a new Epic 0.8.

**Mode:** Batch (carried over from the prior SCP this session). **Scope classification:** Moderate (epic retitle + split, story renumbering, coordinated shard sweep; no PRD/FR/NFR change).

**Note on process:** given the two clarifying answers fully scoped this change, edits below were drafted directly rather than staged separately; nothing is committed to git — this document is the record, and anything here can still be adjusted before that happens.

---

### 1. Issue Summary

Epic 0.1 ("Upstream JOH/MRD reference data is ingested") bundled two upstream integrations — the JOH eLinks API sync (Stories 0.1.1–0.1.3) and the MRD weekly Excel ingestion (Story 0.1.4) — under one epic. The team's near-term focus is JOH data specifically; keeping MRD bundled into the same epic obscures that focus and overstates what "Epic 0.1 done" means (an epic-level `depends_on` gate, per `dispatch-preflight.sh`, currently can't distinguish "JOH ETL done" from "JOH ETL done AND MRD done").

Separately, the team wants Epic 0.1 to carry the "ETL" label for communication clarity. This needs care: "ETL" was **explicitly retired** in this repo (D3, 2026-06-10; gaps.md G4.6) when it referred to the **one-shot legacy APEX-migration tool** — retracted because CTAM Pathfinder does no legacy data migration of any kind. Reusing "ETL" for a *different*, ongoing thing (the nightly eLinks sync) is fine, but only if clearly distinguished from that retirement, or it silently reopens a settled decision. Both gaps.md (G4.6) and the new epic file now carry that distinction explicitly.

### 2. Impact Analysis

#### Epic impact

- **Epic 0.1** retitled **"JOH Reference-Data ETL Process"**; narrowed to Stories 0.1.1–0.1.3 (JOH eLinks only). `depends_on` unchanged (`[epic-0.0, epic-0.6]`).
- **New Epic 0.8** ("MRD supplementary reference data is ingested") carries the former Story 0.1.4, renumbered **Story 0.8.1**, content otherwise verbatim. `depends_on: [epic-0.0, epic-0.1]` — same repo (`ctam-reference-data`), needs Epic 0.1's scaffold (0.1.1) and tier-(a) write-protection pattern (0.1.2) established first.
- No other epic's scope changes. Epic 0.2 (auth) still depends on Epic 0.1 for `jo_people` — unaffected, since JOH data (not MRD) is what sign-in needs.

#### Story impact

- Story 0.1.4 → **Story 0.8.1**, moved wholesale (Acceptance Criteria, references, out-of-scope notes carried over unchanged).
- Stories 0.1.1, 0.1.2, 0.1.3 — cross-references to "Story 0.1.4" updated to "Epic 0.8, Story 0.8.1"; no AC content changed.
- No story is added, removed in substance, or has its acceptance criteria altered — this is a **relabelling + regrouping**, not a scope change.

#### Artifact conflicts / updates needed

| Artifact | Change |
|---|---|
| `epics/phase-0/epic-0.1-upstream-reference-data-ingested.md` | Retitled "JOH Reference-Data ETL Process"; naming note added (ETL distinction); Story 0.1.4 removed; storyCount 4→3; cross-references fixed |
| `epics/phase-0/epic-0.8-mrd-supplementary-reference-data-ingested.md` *(new)* | Former Story 0.1.4, now Story 0.8.1, as its own epic; `depends_on: [epic-0.0, epic-0.1]` |
| `epics/phase-0/index.md` | Epic table (0.1 retitled/3 stories, +0.8/1 story); epic summaries (0.1 rewritten, +0.8); Stories Summary table (0.1/+0.8 rows; **total corrected to 24** — the table previously read 22, an arithmetic carry-over error caught while editing it) |
| `epics/framework.md` | Reference Data area: ingestion paragraph split by epic; Phase 0 area-table row updated |
| `epics/fr-coverage-map.md` | FR6 and NFR24 rows: split JOH (0.1.3) vs MRD (0.8.1) |
| `epics/requirements-inventory.md` | MRD storage Terraform cross-reference updated to Epic 0.8 |
| `architecture/non-functional-requirements-coverage.md` | NFR24 bullet: JOH → Epic 0.1, MRD → Epic 0.8 |
| `architecture/repository-strategy.md` | `ctam-reference-data` row: MRD storage cross-reference + "JOH eLinks ETL process" phrasing |
| `architecture/delivery-operating-model.md` | Story-packet template's illustrative example (`story_id`, `epic`, `sprint_status_key`) updated from the now-moved `0.1.4` to `0.8.1` so the worked example stays accurate |
| `architecture/gaps.md` | G4.6: terminology note distinguishing reused "ETL" from the retired legacy-migration ETL. G8.1: epic-split cross-reference (JOH→0.1, MRD→0.8) |
| `architecture.md` | Decision log: new **#15** |
| `architecture/changelog.md` | New **v4.10** entry |
| `sprint-status.yaml` | `0-1-4-...` moved out of `epic-0.1` block into new `epic-0.8` block as `0-8-1-...`, status unchanged (`backlog`) |

**Not touched (deliberately):** dated historical records — `#sprint-change-proposal-2026-05-15`, `-2026-06-17.md`, `-2026-08-20.md`, `implementation-readiness-report-2026-06-17.md`, and the `changelog.md` v3.1/v4.6/v4.7 entries — all correctly describe the state *as of their date* and are left as immutable history per this repo's convention. `assumptions.md` A36/A37 (reference G8.1, not epic numbers — no change needed). No PRD, UX, or FR/NFR change.

#### Technical impact

None. The eLinks sync's implementation (in-process `@Scheduled`, full-refresh upsert, `ctam_sync_status` logging) and MRD's implementation (blob poll, validate, upsert, archive) are unchanged — only which epic tracks each, and what Epic 0.1 is called. `ctam_sync_status` remains a single shared table written by both, now-separately-tracked, processes in the same repo.

### 3. Recommended Approach

**Option 1 — Direct Adjustment.** This is a pure backlog reorganisation: retitle one epic, split one story into a sibling epic, sweep cross-references. Nothing is built yet (`sprint-status.yaml` shows both epics fully `backlog`), so there's no rollback question (Option 2 doesn't apply) and no MVP/FR impact (Option 3 doesn't apply).

**Effort:** Low. **Risk:** Low — relabelling plus a mechanical cross-reference sweep, verified file-by-file rather than blind find-replace (per this repo's cross-cutting-change convention). **Timeline impact:** None — Epic 0.8's `depends_on` on Epic 0.1 preserves the same effective build order MRD already had as Story 0.1.4 (it came after 0.1.1–0.1.3 anyway).

### 4. Detailed Change Proposals

All edits are described in full, with before/after text, in the files themselves (this SCP intentionally doesn't re-paste the whole rewritten epic files — see the two epic files directly for the authoritative before/after). Summary of the key renames:

- **Epic 0.1**: "Upstream JOH/MRD reference data is ingested" → **"JOH Reference-Data ETL Process"**, 4 stories → 3 (0.1.1–0.1.3).
- **Epic 0.8** *(new)*: "MRD supplementary reference data is ingested", 1 story (0.8.1 — was 0.1.4).
- **Decision #15** added to `architecture.md`'s decision log; **v4.10** added to `changelog.md`.
- **G4.6** (gaps.md) gains a terminology note; **G8.1** gains an epic-split cross-reference.
- Phase 0 totals: **9 epics** (was 8), **24 stories** (unchanged — 3+1 replaces the old 4).

### 5. Implementation Handoff

**Scope: Moderate** — backlog reorganisation (epic retitle + split + renumbering) with a coordinated cross-reference sweep. No PRD rewrite, no FR/NFR change. Routed as **Product Owner / Developer**, not Product Manager / Architect.

**Responsibilities:**
- **This session:** all edits above have been drafted directly in the tracked planning-artifact files (nothing committed). Pending final approval, the next step is `scripts/build-html.sh` to regenerate `docs/`.
- **Product Owner (human):** confirm no dispatcher has picked up `0.1.4`/Story 0.8.1 under its old identity outside this control plane (checked: `sprint-status.yaml` shows it was `backlog` under `epic-0.1`, never dispatched).

**Success criteria:** Epic 0.1 and Epic 0.8 files are internally consistent and cross-reference each other correctly; `epics/phase-0/index.md`'s two summary tables agree on totals (24 stories, 9 epics); `docs/` regenerates cleanly; no FR/NFR/PRD text changed.

---

## Sprint Change Proposal — 2026-08-24c

**Status:** proposed

**Trigger:** *"create an epic for postgress-sql-schema-design. This is to design and implement the joh schema in postgres sql database"*

**Clarified via two questions before drafting:**
1. **Which "JOH schema"** → **`ctam-joh`'s own domain schema** — the 5 CTAM-owned overlay tables (working patterns, ticket/location overlays, jurisdictional splits), *not* the tier-(a) `jo_*` eLinks tables (already covered by Epic 0.1 Story 0.1.2).
2. **Scope** → **Schema only** — tables, PKs/FKs, Liquibase changelogs, tier ownership/grants. No working-pattern-generation, overlay-CRUD, or jurisdictional-split-validation *business logic* — that's later Phase 1 work.

**Mode:** Batch. **Scope classification:** Moderate — this is the **first Phase 1 epic ever created** (Phase 1 currently has no epics/stories, only a `framework.md` area description), so it's a bigger step than the Phase-0 backlog edits earlier this session, even though its own content is schema-only.

---

### 1. Issue Summary

Phase 1 (JOH) has never been decomposed into epics — `epics/index.md`'s phase table lists it as "_to be storied_ / ⚪ Framework only," and `architecture/data-tables.md` already fully specifies `ctam-joh`'s 5 domain tables (§"JOH service (`ctam-joh`) — 5 tables") without any story ever scheduling their creation. The team wants to start Phase 1 with the database schema specifically — design and implement `ctam-joh`'s own PostgreSQL tables — before building the working-pattern/overlay business logic on top of them, mirroring the pattern Epic 0.1 already used (Story 0.1.2 "tables" landed before Story 0.1.3 "sync logic").

This SCP creates that one schema-only epic. It does **not** run the full `bmad-create-epics-and-stories` decomposition for Phase 1 — FR12–FR18's behavioral stories (working-pattern management, forward-sitting generation, overlay CRUD, jurisdictional-split workflow) remain undecomposed and are explicitly out of scope here.

### 2. Impact Analysis

#### Epic impact

- **New Epic 1.1** — "JOH domain schema is designed and implemented in PostgreSQL" (file slug: `postgres-sql-schema-design`, per the trigger). First epic in a new `epics/phase-1/` folder.
- **Depends on Epic 0.1** (hard dependency: `ctam_joh_identities` — the FK target for every `ctam-joh` table's `joh_id` column — is minted by Epic 0.1's eLinks sync, Story 0.1.3, and its schema is created in Story 0.1.2). Also depends on **Epic 0.0** (shared estate) and **Epic 0.6** (context bus + config baseline), mirroring Epic 0.1's own dependency set for the same reasons (first `ctam-joh` scaffold needs both).
- **Open item flagged, not resolved here:** some of the 5 tables plausibly carry FK columns into tier-(b) vocabulary tables owned by `ctam-reference-data` (e.g. a working-pattern-type reference into `ctam_working_pattern_types`, landed in Epic 0.3 Story 0.3.1) — `data-tables.md` documents the vocabulary tables and their JOH-consumer relationship but not full column-level DDL, so I'm not asserting a hard Epic 0.3 dependency I can't verify. The new epic's schema story instead carries an explicit AC: verify each such FK against `data-tables.md` and Epic 0.3's landing status at implementation time; raise an architectural PR (same pattern as gaps.md G8.1's "unmapped upstream structure") if a referenced vocabulary table doesn't exist yet.
- No existing epic (0.0–0.8) changes.

#### Story impact

- **New Story 1.1.1** — scaffold `ctam-joh` from the HMCTS starter (mirrors Story 0.1.1's pattern — first time this repo is scaffolded).
- **New Story 1.1.2** — the 5-table domain schema itself, via Liquibase, with tier ownership + grants (mirrors Story 0.1.2's pattern).
- No existing story changes.

#### Artifact conflicts / updates needed

| Artifact | Change |
|---|---|
| `epics/phase-1/index.md` *(new)* | Phase 1 overview — Epic 1.1 only; explicit note that FR12–FR18 behavioral decomposition is still pending |
| `epics/phase-1/epic-1.1-postgres-sql-schema-design.md` *(new)* | The epic itself — 2 stories |
| `epics/index.md` | Phase-level breakdowns table: Phase 1 row updated from "_to be storied_ / ⚪" to link + partial status |
| `epics/framework.md` | Phase 1 · Area: JOH Records & Working Patterns — one-sentence cross-reference to Epic 1.1 |
| `epics/fr-coverage-map.md` | Phases 1–9+ pending table: FR10–FR18 row annotated (schema groundwork landed; behavior still pending) — status stays ⚪, not flipped to ✅ |
| `architecture/changelog.md` | New version entry |
| `sprint-status.yaml` | New `epic-1.1` block, 2 stories, `backlog` |

**Not touched:** `data-tables.md` (already fully specifies these 5 tables — nothing to change, this epic just schedules building what's already documented there). `architecture.md` decision log (no new architectural decision — the schema design was already fixed by `data-tables.md`; this is pure backlog scheduling). No PRD, FR/NFR, or UX change.

#### Technical impact

None beyond what's already documented: `ctam-joh` becomes the second domain service scaffolded (after `ctam-reference-data`), owns 5 tables with the same conventions as every other domain table (`id uuid` PK, `joh_id` FK → `ctam_joh_identities.id`, `created_at`/`updated_at timestamptz NOT NULL`, Liquibase-only DDL, per-service DB role write ownership, ArchUnit grants fitness function). One genuinely open technical question, flagged as a story AC rather than resolved here: `ctam_jurisdictional_splits`' "must total 100%" constraint (FR16) is a **cross-row** invariant — a plain Postgres `CHECK` constraint can't express "this JOH's rows sum to 100," so the story requires the implementer to choose (and justify) a trigger, an application-level enforcement, or a materialized total column, rather than silently assuming one.

### 3. Recommended Approach

**Option 1 — Direct Adjustment (new epic).** Nothing rolls back (Phase 1 has zero stories today, so Option 2 doesn't apply) and nothing touches MVP scope or FR/NFR text (Option 3 doesn't apply). This is additive: one new epic, schema-only, in a phase that's otherwise still framework-only.

**Effort:** Low–Medium (two stories: a scaffold mirroring an already-proven pattern, and a schema migration against an already-fully-specified table set). **Risk:** Low, with one flagged design question (the 100%-sum constraint) that the story surfaces rather than resolves — appropriate for a schema-only epic to hand to the implementer as a cited open item, not something this SCP should invent an answer for. **Timeline impact:** None on Phase 0; this is the first step of Phase 1 and doesn't block anything currently in flight (all Phase 0 epics still `backlog`/`in-progress` per `sprint-status.yaml`).

### 4. Detailed Change Proposals

#### 4.1 New file — `epics/phase-1/epic-1.1-postgres-sql-schema-design.md`

```markdown
---
type: 'Epic'
description: "User outcome: ctam-joh's own PostgreSQL domain schema — 5 tables (working patterns, ticket/location overlays, jurisdictional splits) — is designed and implemented via Liquibase, so later Phase 1 behavioral epics have a schema to build against. Schema only — no business logic."
resource: 'epics/phase-1/epic-1.1-postgres-sql-schema-design.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-08-24'
parent: 'epics/phase-1/index.md'
epic: 1.1
title: 'JOH domain schema is designed and implemented in PostgreSQL'
storyCount: 2
repo: ctam-joh
depends_on: [epic-0.0, epic-0.1, epic-0.6]
---

# Epic 1.1: JOH domain schema is designed and implemented in PostgreSQL

**User outcome:** `ctam-joh`'s own PostgreSQL domain schema — the 5 CTAM-owned overlay tables (`ctam_working_patterns`, `ctam_working_pattern_days`, `ctam_joh_ticket`, `ctam_joh_location`, `ctam_jurisdictional_splits` — per `architecture/data-tables.md`) — is designed and implemented via Liquibase, each keyed by `joh_id` → `ctam_joh_identities.id`, so that later Phase 1 epics (working-pattern management, overlay maintenance, jurisdictional-split workflow — FR12, FR15b, FR16, FR17) have a schema to build against. **Schema only** — no business logic, no API, no UI in this epic.

**Hosting:** `ctam-joh` is the **second** domain service scaffolded (after `ctam-reference-data`, Epic 0.1); it deploys onto the shared Azure estate provisioned in **Epic 0.0** and carries only its own per-repo Terraform. This epic does not build `ctam-joh`'s API or any working-pattern/overlay business logic — those are later Phase 1 epics, run via `bmad-create-epics-and-stories` once Phase 1 is fully decomposed.

**Vertical slice:**
- **Second scaffolded backend service: `ctam-joh`** (HMCTS Crime SpringBoot template + `ctam-scaffold.sh` conventions per AR2–AR4, same pattern as Epic 0.1 Story 0.1.1)
- **Consumes the shared Azure estate** provisioned in Epic 0.0
- The 5 domain tables, service-owned Liquibase changelog (AR18–AR20), keyed by `joh_id` → `ctam_joh_identities.id` (Epic 0.1)
- Tier ownership: only the `ctam_joh` DB role holds INSERT/UPDATE on its own tables; SELECT-granted to `ctam_reference_data` for JOH profile-view composition (per `data-tables.md`'s explicit note)

**FRs covered:** none behaviourally — **schema groundwork only** for FR12 (working patterns), FR15b (ticket overlay), FR16 (jurisdictional split), FR17 (location overlay). Full behavioral coverage is later Phase 1 epics.

**Key NFRs first exercised here (for `ctam-joh`):** NFR10 (TLS at APIM), NFR11 (data-at-rest), NFR25–NFR28 (structured logs + observability), NFR31 (Azure UK South), NFR40 (per-service deployable).

**Out of scope (explicitly):** Working-pattern generation / forward-sitting generation (FR13). Ticket/location overlay CRUD business logic. Jurisdictional-split validation workflow. JOH profile *view* composition itself (only the SELECT grant enabling it is this epic's concern). `ctam-joh`'s REST API. `ctam-ui`'s `joh/` module. All of these are future Phase 1 epics.

---

## Story 1.1.1: Scaffold `ctam-joh` from the HMCTS starter (onto the Epic 0.0 estate)

As a **platform engineer**,
I want to scaffold `ctam-joh` — the second CTAM Pathfinder backend service — from the HMCTS Crime SpringBoot template using `ctam-scaffold.sh`, and deploy it onto the shared Azure estate provisioned in Epic 0.0,
So that **the JOH domain schema (Story 1.1.2) has a service to live in**, following the same proven scaffold pattern Epic 0.1 established for `ctam-reference-data`.

**Acceptance Criteria:**

**Given** the engineer has performed the GitHub manual-setup checklist (`ctam-architecture/runbooks/github-setup.md`) **before** running the scaffold (repo `ctam-joh` created via the GitHub web UI; branch protection on `main`; no `gh` CLI, per D10),
**When** the engineer runs `ctam-scaffold.sh ctam-joh` from `ctam-architecture/scaffolding/`,
**Then** the script scaffolds a Spring Boot 4.0.x project locally from `https://github.com/hmcts/service-hmcts-crime-springboot-template`, commits, and pushes to the pre-created remote on a feature branch via plain `git`,
**And** Group ID is `uk.gov.hmcts.ctam`, artefact is `ctam-joh`, base package is `uk.gov.hmcts.ctam.joh`, default port is 8082 (per AR3),
**And** the same baseline dependency set as every other CTAM service is configured (Liquibase, Testcontainers PostgreSQL, MapStruct, OWASP encoder, docker-compose plugin, OpenAPI tooling, Helm chart, Key Vault, JaCoCo, CycloneDX SBOM — per AR5–AR17),
**And** a `terraform/` directory exists holding only `ctam-joh`'s own resources (Key Vault namespace) — the shared estate lives in `ctam-shared-infrastructure` (per AR53 revised),
**And** GitHub Actions workflows, `CODEOWNERS`, `PULL_REQUEST_TEMPLATE.md`, and a Postman collection skeleton exist (per AR28, AR29, AR41).

**Given** the shared Azure estate provisioned and independently verified in Epic 0.0,
**When** `ctam-joh`'s Helm chart is deployed to the dev AKS cluster,
**Then** the service reaches the shared cluster, database, registry, gateway, and observability estate (this story **consumes** the estate; it does not provision it),
**And** `GET /actuator/health` returns `200 OK`, liveness/readiness probes pass, and structured JSON logs with `correlationId` appear (per NFR25, NFR28, AR30, AR32).

**Given** the `ctam-architecture` Liquibase baseline and shared `ctam_configuration_values` table already exist (Epic 0.6),
**When** `ctam-joh` is scaffolded,
**Then** its DB role has `SELECT` on `ctam_configuration_values`,
**And** its own service-owned Liquibase changelog directory exists but is empty (the 5 domain tables are created in Story 1.1.2).

**References:** AR2–AR17, AR23–AR32, AR41, AR53 (revised); D10; depends on Epic 0.0 (shared estate) and Epic 0.6 (context bus + config baseline).

**Explicitly NOT in scope:**
- The 5 domain tables and tier ownership/grants — Story 1.1.2
- Any `ctam-joh` API, business logic, or UI — future Phase 1 epics

---

## Story 1.1.2: The 5 `ctam-joh` domain tables are designed and implemented

As a **CTAM Pathfinder platform** (and every future Phase 1 story that builds on this schema),
I want the 5 CTAM-owned `ctam-joh` overlay tables created via Liquibase, keyed by `joh_id` → `ctam_joh_identities.id`, with tier ownership and cross-service SELECT grants in place,
So that **later Phase 1 epics (working-pattern management, overlay maintenance, jurisdictional-split workflow) have a correctly-owned schema to build behavior against, and `ctam-reference-data` can compose JOH profile views without a shared code dependency**.

**Acceptance Criteria:**

**Given** `ctam-joh` is scaffolded per Story 1.1.1, and `ctam_joh_identities` exists (Epic 0.1, Story 0.1.2),
**When** the engineer adds the Liquibase changeset `db/changelog/001-init-joh-domain-tables.sql` (formatted-SQL, included from `db.changelog-master.yaml`),
**Then** the 5 tables exist per `architecture/data-tables.md`'s "JOH service (`ctam-joh`) — 5 tables" section:
  - `ctam_working_patterns` — per-JOH working-pattern definition (target sit %, active period; FR12)
  - `ctam_working_pattern_days` — per-day work-type breakdown within a working pattern (FR12)
  - `ctam_joh_ticket` — CTAM-overlay tickets layered on the upstream `jo_tickets` set (FR15 layer (b))
  - `ctam_joh_location` — JOH base-location changes recorded in CTAM, not propagated upstream (FR17)
  - `ctam_jurisdictional_splits` — per-JOH jurisdictional split percentages (FR16)
**And** every table has `id uuid PK`, `joh_id uuid` FK → `ctam_joh_identities.id` (never a bare `personnel_number`), and `created_at`/`updated_at timestamptz NOT NULL`, per house convention,
**And** `ctam_working_pattern_days` FKs to its parent `ctam_working_patterns.id`.

**Given** any of the 5 tables needs a foreign key into a tier-(b) vocabulary table owned by `ctam-reference-data` (e.g. a working-pattern-type reference into `ctam_working_pattern_types`),
**When** the engineer designs that column,
**Then** the referenced vocabulary table's existence and shape is verified against `data-tables.md` and Epic 0.3's landing status **before** the FK is added — an unmapped or not-yet-landed vocabulary table raises an architectural PR rather than being assumed (cite-or-ask; mirrors gaps.md G8.1's "unmapped upstream structure raises an architectural PR" pattern).

**Given** `ctam_jurisdictional_splits`' percentages must total 100% per JOH (FR16) — a **cross-row** invariant a single-row Postgres `CHECK` constraint cannot express,
**When** the engineer designs this table's enforcement,
**Then** the chosen mechanism (a trigger, application-level validation, or an equivalent) is explicit and justified in the migration's accompanying notes — this AC exists precisely so the choice is made deliberately, not defaulted to "no enforcement."

**Given** the tables are created,
**When** grants are configured,
**Then** the `ctam_joh` DB role owns all 5 tables and holds INSERT/UPDATE on them; **no other role holds INSERT/UPDATE** (mirrors AR49's tier-ownership pattern, now for `ctam-joh`'s own tier rather than tier (a)),
**And** `ctam_reference_data`'s DB role holds `SELECT` on all 5 tables (per `data-tables.md`: "the overlay tables are SELECT-granted to `ctam_reference_data`" for JOH profile-view composition),
**And** the ArchUnit/grants fitness function in CI verifies this write-protection + grant rule.

**References:** FR12, FR15b, FR16, FR17 (schema groundwork only — no behavior); NFR15; AR18–AR20, AR22; `architecture/data-tables.md` §"JOH service (`ctam-joh`) — 5 tables"; depends on Epic 0.1 Story 0.1.2 (`ctam_joh_identities`).

**Explicitly NOT in scope:**
- Working-pattern generation / forward-sitting generation (FR13) — future Phase 1 epic
- Ticket/location overlay CRUD, jurisdictional-split validation workflow — future Phase 1 epics
- JOH profile view composition (only the SELECT grant enabling it is here) — future Phase 1 epic
- `ctam-joh`'s REST API — future Phase 1 epic
```

#### 4.2 New file — `epics/phase-1/index.md`

```markdown
---
type: 'Phase Index'
title: 'Phase 1 — JOH'
description: 'Epic 1.1 (schema only) is the first Phase 1 epic. FR10–FR18 behavioral decomposition is still pending a full bmad-create-epics-and-stories run for this phase.'
resource: 'epics/phase-1/index.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-08-24'
parent: 'epics/index.md'
phase: 1
phaseName: 'JOH'
---

# Phase 1 — JOH

> **Partial decomposition.** Only **Epic 1.1** (schema-only) exists so far — added via Sprint Change Proposal 2026-08-24c, ahead of a full Phase 1 decomposition. FR10–FR18's behavioral stories (working-pattern management, forward-sitting generation, overlay CRUD, jurisdictional-split workflow, JOH search/profile views — see [`../framework.md`](../framework.md) → *Phase 1 · Area: JOH Records & Working Patterns*) are **not yet storied**. Run `bmad-create-epics-and-stories` for Phase 1 to decompose the rest; Epic 1.1's schema is what those future epics will build against.

## Epics

| Epic | Title | Stories | Status |
|---|---|---|---|
| [1.1](epic-1.1-postgres-sql-schema-design.md) | JOH domain schema is designed and implemented in PostgreSQL | 2 | 🟡 Planned |
| **Total** | | **2 stories** | |

## Epic summaries

### Epic 1.1: JOH domain schema is designed and implemented in PostgreSQL (2 stories)

**User outcome:** `ctam-joh`'s 5 domain tables — working patterns, per-day pattern breakdown, ticket overlay, location overlay, jurisdictional splits — are designed and implemented via Liquibase, keyed by `joh_id` → `ctam_joh_identities.id`, with tier ownership and a cross-service SELECT grant to `ctam-reference-data`. **Schema only** — the behavioral stories that populate and maintain this schema are future Phase 1 epics.

**FRs covered:** none behaviourally — schema groundwork for FR12, FR15b, FR16, FR17.

→ [Full epic with stories](epic-1.1-postgres-sql-schema-design.md)

## Not yet storied

FR10, FR11, FR13, FR14, FR18, and the behavioral halves of FR12/FR15b/FR16/FR17 — see [`../framework.md`](../framework.md) → *Phase 1 · Area: JOH Records & Working Patterns* for the architectural map. Run `bmad-create-epics-and-stories` for Phase 1 when ready to decompose these.
```

#### 4.3 `epics/index.md` — Phase-level breakdowns table

**OLD:**
```
| **1** — JOH | _to be storied_ | ⚪ Framework only |
```

**NEW:**
```
| **1** — JOH | [phase-1/](phase-1/index.md) | 🟡 Partially planned — 1 epic (schema only, SCP 2026-08-24c); FR10–FR18 behavior still to be storied |
```

#### 4.4 `epics/framework.md` — Phase 1 · Area: JOH Records & Working Patterns

Append one sentence to the existing scope paragraph: *"`ctam-joh`'s own PostgreSQL schema (the 5 tables above) is designed and implemented in [Epic 1.1](phase-1/epic-1.1-postgres-sql-schema-design.md) — schema only; the behavioral stories in this area are not yet storied."*

#### 4.5 `epics/fr-coverage-map.md` — Phases 1–9+ pending table

**OLD:**
```
| FR10–FR18 | 1 | JOH Records & Working Patterns (profiles are *views* over tier (a) + `ctam-joh` overlays; FR14 is display-only — conversions happen upstream) | ⚪ |
```

**NEW:**
```
| FR10–FR18 | 1 | JOH Records & Working Patterns (profiles are *views* over tier (a) + `ctam-joh` overlays; FR14 is display-only — conversions happen upstream). **Schema groundwork landed**: [Epic 1.1](phase-0/../phase-1/epic-1.1-postgres-sql-schema-design.md) (SCP 2026-08-24c) — schema only, behavior still ⚪ | ⚪ |
```

#### 4.6 `architecture/changelog.md`

New version row (above the current top entry):

| **v4.11 — Phase 1's first epic: `ctam-joh` domain schema (schema only)** | 2026-08-24 | **Additive** (SCP 2026-08-24c), no FR/NFR/PRD/architecture-decision change — `data-tables.md` already fully specified these 5 tables. Adds **Epic 1.1** in a new `epics/phase-1/` folder: scaffold `ctam-joh` (Story 1.1.1) + create its 5 domain tables via Liquibase (Story 1.1.2), keyed by `joh_id` → `ctam_joh_identities.id` (Epic 0.1), tier-owned + SELECT-granted to `ctam_reference_data`. Schema only — FR12/FR15b/FR16/FR17's behavioral stories remain unstoried. Flags one open design question for the implementer: `ctam_jurisdictional_splits`' 100%-sum constraint is a cross-row invariant, not a plain `CHECK`. See [`#sprint-change-proposal-2026-08-24c`](#sprint-change-proposal-2026-08-24c). | new `epics/phase-1/index.md`, new `epics/phase-1/epic-1.1-postgres-sql-schema-design.md`; `epics/index.md`; `epics/framework.md`; `epics/fr-coverage-map.md`; `sprint-status.yaml` |

#### 4.7 `sprint-status.yaml`

Append a new block:

```yaml
  epic-1.1: backlog
  1-1-1-scaffold-ctam-joh-from-the-hmcts-starter-onto-the-epic-0-0-estate: backlog
  1-1-2-the-5-ctam-joh-domain-tables-are-designed-and-implemented: backlog
  epic-1.1-retrospective: optional
```

### 5. Implementation Handoff

**Scope: Moderate** — first Phase 1 epic, schema-only, additive. No PRD/FR/NFR/architecture-decision change (the schema itself was already fixed in `data-tables.md`; this only schedules building it). Routed as **Product Owner / Developer**.

**Responsibilities:**
- **This session:** on approval, create the two new files and apply the five edits above, then regenerate `docs/` and add the two new NAV entries (`epics/phase-1/index.md`, `epics/phase-1/epic-1.1-postgres-sql-schema-design.md`) to `scripts/python/build_html.py`, following the same convention as the Phase 0 entries.
- **Implementing engineer (Story 1.1.2):** resolve the two flagged open items at implementation time — (a) verify any tier-(b) vocabulary FK against `data-tables.md`/Epic 0.3's status before adding it, raising an architectural PR if unmapped; (b) choose and justify the `ctam_jurisdictional_splits` 100%-sum enforcement mechanism.
- **Product Owner (human):** decide when to run `bmad-create-epics-and-stories` for the rest of Phase 1 (FR10–FR18 behavior) — not part of this SCP's scope.

**Success criteria:** `epics/phase-1/index.md` and the new epic file are internally consistent; `epics/index.md`'s Phase 1 row links correctly; `docs/` regenerates cleanly with both new pages reachable from the NAV sidebar; no FR/NFR/PRD text changed; `data-tables.md` unchanged (nothing here contradicts it).

---

## Sprint Change Proposal — 2026-08-25

**Status:** proposed

**Trigger:** *"move epic-1.1 to phase-0"*

**Mode:** Batch. **Scope classification:** Minor — a pure relocate/renumber, no story content, no FR/NFR, no architecture-decision change.

### 1. Issue Summary

Epic 1.1 ("JOH domain schema is designed and implemented in PostgreSQL") was added yesterday (SCP 2026-08-24c) as the first — and only — epic in a new `epics/phase-1/` folder. The team wants it filed as a Phase 0 epic instead. Since it was the sole occupant of Phase 1, moving it out leaves Phase 1 with nothing, reverting to its prior "framework only" state.

Nothing about the epic's *content* changes — same 2 stories (scaffold `ctam-joh`; create its 5 domain tables), same dependencies, same open items flagged for the implementer (tier-(b) vocabulary FK verification; the `ctam_jurisdictional_splits` 100%-sum enforcement choice). Only its number, file location, and cross-references change.

### 2. Impact Analysis

- **Epic renumbered:** 1.1 → **0.9** (next free Phase 0 slot). Stories 1.1.1/1.1.2 → **0.9.1/0.9.2**.
- **File moved:** `epics/phase-1/epic-1.1-postgres-sql-schema-design.md` → `epics/phase-0/epic-0.9-postgres-sql-schema-design.md` (via `git mv`, preserving history).
- **`epics/phase-1/` folder removed** — Phase 1 had no other epics, so it reverts to "_to be storied_ / ⚪ Framework only" in `epics/index.md`, same as every other undecomposed phase.
- **`depends_on` unchanged** (`[epic-0.0, epic-0.1, epic-0.6]` — all were already Phase 0 epics, so the dependency set needed no change).
- **`framework.md`'s Phase 1 · JOH area** keeps its cross-reference to this schema epic (the *content* is still JOH-domain schema work, described in that architectural area) — only the link target updates to the new Phase 0 location. This mirrors how Epic 0.6/0.7 already sit in the Phase 0 folder while covering cross-cutting, not purely Phase-0-scoped, concerns.
- **`fr-coverage-map.md`** — the "schema groundwork landed" note under the Phase 1 pending FR10–FR18 row updates its link/label from Epic 1.1 to Epic 0.9; it stays in the *Phase 1 FRs* table (FR-ownership, not file location, drives that table).
- **Caught while editing:** `epics/index.md`'s Phase 0 summary line still read "6 epics, 19 stories" — stale since the Epic 0.6/0.7/0.8 additions earlier this session. Corrected to the actual current total (10 epics, 26 stories, including this move) alongside this change.
- **Not touched:** `data-tables.md` (unaffected — same 5 tables, same design), the epic's own story content/ACs (verbatim, only numbers change), `architecture.md` decision log (a file relocation isn't an architectural decision), and yesterday's SCP 2026-08-24c (left as an immutable historical record of what was proposed and approved that day).

### 3. Recommended Approach

Direct relocate + renumber (Option 1, trivially). No rollback question (nothing built against Epic 1.1 yet — `sprint-status.yaml` shows it `backlog`), no MVP/FR impact.

**Effort:** Low. **Risk:** Low — mechanical, verified file-by-file rather than blind find-replace. **Timeline impact:** None.

### 4. Detailed Change Proposals

| Artifact | Change |
|---|---|
| `epics/phase-0/epic-0.9-postgres-sql-schema-design.md` *(moved + renumbered)* | `epic: 1.1`→`0.9`; `parent`/`resource` → phase-0 paths; H1 "Epic 1.1"→"Epic 0.9"; Stories 1.1.1/1.1.2 → 0.9.1/0.9.2 throughout; body content otherwise verbatim |
| `epics/phase-1/` | Removed (`index.md` deleted — no epics left) |
| `epics/index.md` | Phase 0 row: 6 epics/19 stories → 10 epics/26 stories (corrects stale count + adds this epic). Phase 1 row: reverts to `_to be storied_` / ⚪ |
| `epics/phase-0/index.md` | Epic 0.9 row added to epics table + summary section; Stories Summary table +1 row; totals 24→26 stories, 9→10 epics; "nine demos"→"ten demos" |
| `epics/framework.md` | Phase 1 · JOH area: link updated from `phase-1/epic-1.1-...` to `phase-0/epic-0.9-...` |
| `epics/fr-coverage-map.md` | FR10–FR18 pending row: "Epic 1.1" → "Epic 0.9", link updated |
| `architecture/changelog.md` | New v4.12 entry |
| `sprint-status.yaml` | `epic-1.1`/`1-1-1-...`/`1-1-2-...` renamed to `epic-0.9`/`0-9-1-...`/`0-9-2-...`, status unchanged (`backlog`) |
| `scripts/python/build_html.py` | Remove "Implementation — Phase 1" NAV group; add Epic 0.9 to "Implementation — Phase 0" NAV list |

### 5. Implementation Handoff

**Scope: Minor** — direct implementation, no PO/DEV backlog coordination needed beyond the mechanical sweep above.

**Success criteria:** `epic-0.9`'s file is internally consistent (no leftover "1.1"/"Phase 1" references); `epics/index.md` and `epics/phase-0/index.md` totals agree; `docs/` regenerates cleanly with no dangling Phase 1 nav entries; `data-tables.md` and the epic's ACs are unchanged in substance.

---

## Sprint Change Proposal — 2026-08-25b

**Status:** approved

**Trigger:** *"reorder the epics as follows: postgress-sql-schema-design as 0.1, joh-elinks-mock-api as 0.2, joh-reference-data-etl-process as 0.3"*

**Clarified via two questions before drafting** (the requested target slots 0.1–0.3 were occupied by two other epics not mentioned in the request):
1. **Displaced-epic handling** → **Minimal swap.** Only the 5 involved epics move, as a closed permutation: ETL-process 0.1→0.3, User-authenticates 0.2→0.7, Reference-data-API 0.3→0.9, Mock-API 0.7→0.2, Schema-design 0.9→0.1. Epics 0.0, 0.4, 0.5, 0.6, 0.8 untouched.
2. **Relabeling scope** → **Relabeling only.** Real technical dependencies are unchanged; `depends_on` arrays get rewired to point at the new ids of the same epics, not altered in meaning.

**Mode:** Batch. **Scope classification:** Moderate — mechanically large (touches every Phase 0 epic file plus ~10 supporting artifacts), but conceptually simple (a closed permutation, no content change).

---

### 1. Issue Summary

The team wants three epics — JOH domain schema, JOH eLinks mock API, and the JOH reference-data ETL process — filed at the front of Phase 0's numbering (0.1–0.3), ahead of the auth and reference-data-API epics that currently occupy those slots. Since every epic's `depends_on` array references other epics **by id** (e.g. `depends_on: [epic-0.0, epic-0.1, epic-0.6]`), a renumber isn't just a label change — every epic that depended on one of the 5 moved epics needs its `depends_on` rewired to the new id, or the dependency graph silently breaks (pointing at whatever epic now happens to sit at the old number).

### 2. Impact Analysis

#### The permutation

| Epic | Old → New | Title |
|---|---|---|
| Schema design | 0.9 → **0.1** | JOH domain schema is designed and implemented in PostgreSQL |
| Mock API | 0.7 → **0.2** | JOH eLinks mock API stands in for the unconfirmed upstream contract |
| ETL process | 0.1 → **0.3** | JOH reference-data ETL process |
| User authenticates | 0.2 → **0.7** | User authenticates and lands on a role-scoped Home page |
| Reference data read API | 0.3 → **0.9** | Reference data is served read-only via a versioned, jurisdiction-filtered API |

Unaffected: 0.0 (Platform estate), 0.4 (User populations bootstrapped), 0.5 (Notification), 0.6 (Context bus), 0.8 (MRD ingestion).

#### Dependency graph rewiring

Every `depends_on` array across all 10 Phase 0 epics was checked and rewired where it referenced one of the 5 moved epics (values only — the *files that declare* these arrays, e.g. epic 0.4 or 0.8, were themselves untouched in number):

| Epic (new id) | `depends_on` before | `depends_on` after |
|---|---|---|
| 0.1 (schema) | `[epic-0.0, epic-0.1, epic-0.6]` | `[epic-0.0, epic-0.3, epic-0.6]` |
| 0.2 (mock API) | `[epic-0.0]` | `[epic-0.0]` (unchanged) |
| 0.3 (ETL) | `[epic-0.0, epic-0.6]` | `[epic-0.0, epic-0.6]` (unchanged) |
| 0.4 (bootstrap) | `[epic-0.1, epic-0.2]` | `[epic-0.3, epic-0.7]` |
| 0.7 (auth) | `[epic-0.0, epic-0.1]` | `[epic-0.0, epic-0.3]` |
| 0.8 (MRD) | `[epic-0.0, epic-0.1]` | `[epic-0.0, epic-0.3]` |
| 0.9 (read API) | `[epic-0.1, epic-0.2]` | `[epic-0.3, epic-0.7]` |

Every real technical dependency is unchanged (e.g. the schema epic still needs `ctam_joh_identities`, which the ETL epic mints — it now just cites that epic as `epic-0.3` instead of `epic-0.1`).

#### Story renumbering

Each moved epic's stories move with it (story index within the epic stays the same, only the epic-number prefix changes): 0.1.1–0.1.3 → 0.3.1–0.3.3 (ETL); 0.2.1–0.2.5 → 0.7.1–0.7.5 (auth); 0.3.1–0.3.2 → 0.9.1–0.9.2 (read API); 0.7.1–0.7.3 → 0.2.1–0.2.3 (mock API); 0.9.1–0.9.2 → 0.1.1–0.1.2 (schema).

#### Artifact conflicts / updates needed

| Artifact | Change |
|---|---|
| All 10 `epics/phase-0/epic-0.*.md` | 5 files renamed (slug kept, number changed); every file's cross-references (frontmatter `epic:`/`resource:`, `depends_on:`, prose "Epic 0.X"/"Story 0.X.Y") rewired |
| `epics/phase-0/index.md` | Full rewrite: epics table, summaries, and Stories Summary table reordered/relabeled |
| `epics/framework.md`, `epics/fr-coverage-map.md`, `epics/requirements-inventory.md` | Cross-references rewired |
| `architecture/non-functional-requirements-coverage.md`, `architecture/repository-strategy.md`, `architecture/gaps.md`, `architecture/assumptions.md` | Cross-references rewired |
| `architecture/delivery-operating-model.md` | Illustrative epic-frontmatter/sprint-status examples rewired (see below — also fixed pre-existing staleness) |
| `architecture.md` | New decision **#16**; supersession notes added to #14/#15 (their epic numbers are left as historical record of what was true when each decision was made, per this repo's "add, don't rewrite" convention — mirroring how #12 carries a "superseded by #13" note rather than being rewritten) |
| `architecture/changelog.md` | New **v4.13** entry |
| `sprint-status.yaml` | All `epic-0.X` blocks and story slugs renumbered to match, reordered to ascending numeric order |
| `scripts/python/build_html.py` | NAV list reordered/relabeled to match |

**Not touched:** dated historical records — `changelog.md`'s v4.9–v4.12 entries, all prior dated SCPs, `implementation-readiness-report-2026-06-17.md` — left as accurate point-in-time record of what was true when written. `data-tables.md`, PRD, FR/NFR text — untouched (pure epic-numbering change).

#### Pre-existing staleness caught during the sweep

The mechanical sweep (see §3) surfaced three bugs left over from **earlier** SCPs this session, unrelated to today's renumber but fixed while already touching these files:
1. Several "Story 0.1.4" mentions (in `epic-0.0`, `epic-0.7`'s NOT-in-scope notes, `epic-0.8`'s split note, `gaps.md` G8.1) were never updated to "Story 0.8.1" when MRD split out in SCP 2026-08-24b — because that split's sweep, like this one, needs to distinguish "was called X" (historical, correctly kept as `0.1.4`) from "currently called X" (should say `0.8.1`). Both kinds now read correctly.
2. `delivery-operating-model.md`'s illustrative epic-frontmatter example still carried the **pre-retitle** title ("Upstream JOH/MRD reference data is ingested") and story count (4) from before the SCP 2026-08-24b retitle — corrected to the current title and story count (3).
3. Two **plural** "Stories 0.X.Y/0.X.Z" references (`epic-0.9-reference-data-read-only-api.md`, `epic-0.5-system-dispatches-emails.md`, `fr-coverage-map.md`'s FR1 row) were missed by both today's and the 2026-08-24b sweep's singular-form pattern-matching — found and fixed by hand.

### 3. Recommended Approach

**Direct implementation**, done via a scripted two-pass text substitution rather than manual per-file edits, to guarantee the 5-way permutation applied atomically (no risk of a sequential find-replace re-processing its own output — e.g. mapping 1→3 and then later re-mapping that same 3→9 by accident). Pass A fixed the pre-existing "Story 0.1.4" staleness first (so it couldn't collide with the epic-swap mapping); Pass B applied the 5-way swap to `epic-0.X-` (file links), bare `epic-0.X` (`depends_on` entries), `Epic 0.X` (prose), `epic: 0.X` (frontmatter), and `Story 0.X.Y` (story ids) patterns in one regex pass per file. The 5 files were then renamed via intermediate `.tmp` names to avoid collisions mid-rename (e.g. renaming 0.1→0.3 while 0.3 still existed under its old name). Every result was verified by grep — checking every referenced filename resolves to a real file, and manually reviewing every remaining "0.1.4"/"previously"/"Stories" (plural) occurrence for correctness — before writing this proposal.

**Effort:** Medium (large mechanical surface, low conceptual risk). **Risk:** Low, given the verification pass; the three pre-existing bugs it caught are evidence the verification was worth doing. **Timeline impact:** None — no story content or dependency semantics changed, only labels.

### 4. Detailed Change Proposals

See §2's tables for the full before/after mapping. Full per-file diffs are in the files themselves — given the scale (10 epic files + 9 supporting artifacts), this SCP records the mapping and verification method rather than re-pasting every changed line.

### 5. Implementation Handoff

**Scope: Moderate** — large mechanical footprint, no content/scope change, no PO/DEV coordination needed beyond the sweep itself (already done).

**Success criteria:** every `epic-0.X-slug.md` filename referenced anywhere in the live (non-historical) doc set resolves to a real file on disk (verified via `comm` diff against `ls`); every `depends_on` array's real technical dependency is preserved under its new id; `epics/phase-0/index.md`'s two summary tables agree with each other and with the individual epic files (26 stories, 10 epics); `docs/` regenerates cleanly with no dangling nav links.

---

## Sprint Change Proposal — 2026-08-25c

**Status:** proposed

> **Addendum (approved in the same turn):** the user additionally asked to place the JOH-data read-only API epic at **Epic 0.4** instead of keeping it at 0.9. Epic 0.4 was already occupied ("Both user populations are bootstrapped and verifiable against the IdP") — resolved as a minimal 2-way swap, consistent with this session's established pattern for numbering collisions (see SCP 2026-08-25b): **JOH data read-only API → Epic 0.4**; **User populations bootstrapped → Epic 0.9** (the slot the JOH-data epic vacates). The MRD-data-read-only-api epic is unaffected by this — it lands at **Epic 0.10** exactly as designed below. Every mention of "Epic 0.9" below that refers to the JOH-data-API epic should be read as **Epic 0.4** in the final implementation, and "Epic 0.4" (bootstrap) as **Epic 0.9** — this addendum is the authoritative numbering; the body below is kept as originally drafted/approved for the record rather than rewritten line-by-line.

**Trigger:** *"split epic-0.9 into 2 epics joh-data-read-only-api and mrd-data-read-only-api"*

**Clarified via two questions before drafting** (Epic 0.9 today has no MRD read endpoint at all, so a clean split wasn't mechanical):
1. **Tier-(b) placement** → stays with the **JOH-data** epic (which becomes the "main" reference-data epic — mirrors how Epic 0.3 stayed the main ETL epic when MRD split off as the narrower Epic 0.8 back in SCP 2026-08-24b).
2. **MRD API scope** → **add a new story**, not a placeholder. Epic 0.10 gets a real, designed endpoint for `mrd_specialisms`, not a stub.

**Mode:** Batch. **Scope classification:** Moderate — one new epic with genuinely new story content (an endpoint that didn't exist before), plus a cross-reference sweep.

---

### 1. Issue Summary

Epic 0.9 ("Reference data is served read-only via a versioned, jurisdiction-filtered API") bundles tier-(b) CTAM-owned tables (Story 0.9.1) and a read-only REST API (Story 0.9.2) that, on inspection, only ever defined endpoints for tier-(b) vocab (`/regions`, `/offices`, `/calendar`, `/vocabularies/{list}`) and tier-(a) **JOH** data (`/johs`, `/jurisdictions`, `/tickets`). There is no endpoint anywhere for `mrd_specialisms` (Epic 0.8's MRD ingestion target) — MRD data lands in the database but nothing reads it back out via API today. That's a real gap, not just an organisational one: any Phase 1+ service wanting JOH Specialisations would currently need direct SQL access to `ctam-reference-data`'s schema, breaking the "reads via API" pattern the rest of the read surface follows.

Splitting the epic by upstream source — mirroring the Epic 0.3 (JOH ETL) / Epic 0.8 (MRD ingestion) split already in place on the write side — gives MRD data the same API-as-Product treatment JOH data gets, instead of leaving it as a silent gap.

### 2. Impact Analysis

#### Epic impact

- **Epic 0.9** retitled **"JOH data is served read-only via a versioned, jurisdiction-filtered API"** — keeps Stories 0.9.1 (tier-(b) tables) and 0.9.2 (JOH + tier-(b) read API), content essentially unchanged (it never covered MRD), just reframed from generic "Reference data" to "JOH data" and given an explicit pointer to the new MRD epic. `depends_on` unchanged (`[epic-0.3, epic-0.7]`).
- **New Epic 0.10** — "MRD data is served read-only via a versioned, jurisdiction-filtered API" — one new story (0.10.1) adding `GET /v1/reference-data/specialisms` for `mrd_specialisms`, following the same jurisdiction-filtered/versioned/OpenAPI/RFC-9457/Postman pattern as Epic 0.9's endpoints. `depends_on: [epic-0.7, epic-0.8]` (needs auth for `JWTFilter`/jurisdiction, and Epic 0.8 for `mrd_specialisms` to exist — the JOH-ETL dependency Epic 0.9 has doesn't apply here since this epic never touches `jo_*` data).

#### Story impact

- Story 0.9.1 — unchanged.
- Story 0.9.2 — reworded from "Reference Data" to "JOH data" framing; out-of-scope note added pointing to Epic 0.10 for MRD.
- **New Story 0.10.1** — MRD read-only REST API (real content, not a stub, per your answer).

#### Artifact conflicts / updates needed

| Artifact | Change |
|---|---|
| `epics/phase-0/epic-0.9-reference-data-read-only-api.md` | Retitled/reframed to JOH-specific; unchanged stories, unchanged `depends_on` |
| `epics/phase-0/epic-0.10-mrd-data-read-only-api.md` *(new)* | New epic, 1 story |
| `epics/phase-0/index.md` | Epic 0.9 row/summary updated; new 0.10 row/summary; Stories Summary table +1 row; totals 26→27 stories, 10→11 epics |
| `epics/index.md` | Phase 0 summary line: 10→11 epics, 26→27 stories |
| `epics/framework.md` | Reference Data area: note the JOH/MRD read-API split |
| `epics/fr-coverage-map.md` | FR6/FR7/FR58 rows: note Epic 0.10 covers the MRD read surface |
| `architecture.md` | New decision entry (#17) |
| `architecture/changelog.md` | New version entry |
| `sprint-status.yaml` | `epic-0.9` story list unchanged; new `epic-0.10` block |
| `scripts/python/build_html.py` | NAV: retitle 0.9 entry, add 0.10 entry |

**Not touched:** `data-tables.md` (no new table — `mrd_specialisms` already exists via Epic 0.8; this only adds a read endpoint over it). `gaps.md`/`assumptions.md` (G8.1 is about the ingestion contract, not the read API — unaffected).

### 3. Recommended Approach

**Direct Adjustment** — split one epic into two, with one epic gaining a genuinely new (but small — one endpoint) story. Nothing rolls back (`sprint-status.yaml` shows Epic 0.9 fully `backlog`). No FR/NFR/PRD text changes (FR6/FR7/FR58 already covered "read API" generically; this just fills a coverage gap the epic-level text hadn't caught).

**Effort:** Low–Medium. **Risk:** Low — new story mirrors an already-proven pattern (Epic 0.9's own endpoints) closely enough that there's little design risk. **Timeline impact:** None — Epic 0.10 depends only on Epic 0.7 (auth) and Epic 0.8 (MRD ingestion), both already-planned Phase 0 epics; it doesn't block or get blocked by Epic 0.9.

### 4. Detailed Change Proposals

#### 4.1 `epic-0.9-reference-data-read-only-api.md` — retitle and reframe

**Title:** "Reference data is served read-only via a versioned, jurisdiction-filtered API" → **"JOH data is served read-only via a versioned, jurisdiction-filtered API"**

**User outcome paragraph** — reworded to say tier-(a) **JOH** data + tier-(b) CTAM-owned data (dropping the implication that "reference data" covers MRD too), with an explicit line: *"MRD-sourced data (`mrd_specialisms`) is served by a separate epic, Epic 0.10, since it wasn't covered by any endpoint here."*

**Story 0.9.2**'s AC list is otherwise unchanged (it already only ever listed JOH + tier-(b) endpoints) — just the epic-level framing changes, plus an explicit "Explicitly NOT in scope: MRD read endpoints — Epic 0.10" line.

#### 4.2 New file — `epic-0.10-mrd-data-read-only-api.md`

```markdown
---
type: 'Epic'
description: "User outcome: mrd_specialisms (ingested by Epic 0.8) is queryable read-only via ctam-reference-data's versioned REST API, jurisdiction-filtered, so Phase 1+ services can read JOH Specialisations without direct SQL access. Split out of Epic 0.9 (SCP 2026-08-25c) as new scope - no MRD read endpoint existed before this epic."
epic: 0.10
title: 'MRD data is served read-only via a versioned, jurisdiction-filtered API'
storyCount: 1
repo: ctam-reference-data
depends_on: [epic-0.7, epic-0.8]
---

# Epic 0.10: MRD data is served read-only via a versioned, jurisdiction-filtered API

**User outcome:** `mrd_specialisms` (ingested by Epic 0.8's weekly MRD Excel pick-up) is queryable **read-only** via `ctam-reference-data`'s versioned REST API, **jurisdiction-filtered**[^d8], so Phase 1+ services can read JOH Specialisations at runtime instead of needing direct SQL access. **Split out of Epic 0.9** (SCP 2026-08-25c) — this is genuinely new scope: no endpoint over `mrd_*` data existed before this epic (Epic 0.9's Story 0.9.2 only ever covered tier-(b) vocab and tier-(a) JOH data).

**Vertical slice:**
- Reference Data **read-only** REST API extended with an MRD-sourced resource: `GET /v1/reference-data/specialisms`, jurisdiction-filtered
- Same API-as-Product read-side standards as Epic 0.9: URL versioning, OpenAPI 3.x (springdoc, Spectral-linted), RFC 9457 problem-details, RFC 9745 `Deprecation` + RFC 8594 `Sunset` headers
- Postman collection coverage added to the existing `ctam-reference-data-phase0.postman_collection.json`
- **No write endpoints** — `mrd_*` is tier-(a), corrections happen at source (MRD team), never hand-edited in CTAM (FR6)

**FRs covered:** FR6 (read surface over tier-(a) MRD data), FR7, FR58 (versioned read API contract), FR59 (structured logs).

**Key NFRs:** NFR14 (no forbidden data), NFR40 (per-service deployable), NFR42 (Postman collection).

**Out of scope (explicitly):** JOH data and tier-(b) vocab endpoints — Epic 0.9 (unchanged, already shipped there). Write endpoints for `mrd_*` (never, in any phase). MRD API integration replacing the Excel blob-drop reader (post-MVP, per Epic 0.8).

---

## Story 0.10.1: MRD data read-only REST API with jurisdiction filtering, versioning, OpenAPI, RFC 9457 errors

As an **API consumer** (downstream services from Phase 1+; `ctam-ui`),
I want a versioned **read-only** endpoint over MRD-sourced supplementary reference data (JOH Specialisations), with jurisdiction-filtered responses, full OpenAPI spec, and RFC 9457 error envelopes,
So that **Phase 1+ services can query JOH Specialisations at runtime, scoped to the requester's jurisdiction, without direct SQL access to `ctam-reference-data`'s schema** — closing the gap Epic 0.9's read API left over MRD data.

**Acceptance Criteria:**

**Given** `ctam-reference-data` carries `mrd_specialisms` (Epic 0.8, Story 0.8.1), and `JWTFilter` + jurisdiction resolution are available (Epic 0.7),
**When** the engineer implements the endpoint,
**Then** `GET /v1/reference-data/specialisms` returns `200 OK` with structured JSON,
**And** the endpoint is protected by `JWTFilter` (any authenticated principal can read; per NFR13),
**And** **responses are filtered by the requester's jurisdiction** resolved from `AuthDetails` (D8/FR2) — a specialism record's jurisdiction is resolved via its JOH's `personnel_number` → `jo_people` → `jo_jurisdictions`,
**And** **no write endpoints** (`POST`/`PUT`/`PATCH`/`DELETE`) are implemented — the controller rejects with `405 Method Not Allowed` and an RFC 9457 problem-details body pointing to "corrections at source" (MRD team, per FR6).

**Given** the engineer implements pagination + filtering,
**When** a consumer queries `GET /v1/reference-data/specialisms?personnelNumber=...&page=1&size=50`,
**Then** the response uses the same paginated envelope as Epic 0.9's endpoints (`{items, page, size, totalElements, totalPages}`),
**And** invalid query parameters return `400 Bad Request` with RFC 9457 problem-details.

**Given** the OpenAPI spec is regenerated and Spectral lint runs in CI,
**When** the spec is built,
**Then** it passes Spectral lint, and the `specialisms` resource is documented alongside the existing Epic 0.9 endpoints in the same published `api-ctam-reference-data` artefact (no separate spec — one service, one contract),
**And** `Deprecation`/`Sunset` headers are wired the same way as Epic 0.9's mechanism (none flagged deprecated at Phase 0).

**Given** the existing Phase 0 Postman collection (`postman/ctam-reference-data-phase0.postman_collection.json`, first published in Epic 0.9),
**When** the collection is extended,
**Then** it exercises the new endpoint: happy path + jurisdiction filtering + 400 (invalid query) + 401 (unauthenticated) + 405 (write attempt), per NFR42 — the same collection file, not a new one (one service, one collection).

**References:** FR6 (read surface over `mrd_*`), FR7, FR58, FR59; NFR12, NFR13, NFR14, NFR39, NFR42; AR8, AR17, AR27, AR33, AR37, AR38, AR39, AR41; D8; depends on Epic 0.7 (auth) and Epic 0.8 (`mrd_specialisms` exists).

**Explicitly NOT in scope:**
- JOH data / tier-(b) vocab endpoints — Epic 0.9 (already shipped there)
- Admin write endpoints for `mrd_*` (never, in any phase)
- MRD API integration replacing the blob-drop reader (post-MVP, per Epic 0.8)

[^d8]: D8 — rollout is jurisdiction-first, then per-region; jurisdiction is a first-class hierarchical attribute.
```

#### 4.3 `epics/phase-0/index.md`

- Epics table: retitle 0.9 row to "JOH data is served read-only via a versioned, jurisdiction-filtered API"; add row `| [0.10](epic-0.10-mrd-data-read-only-api.md) | MRD data is served read-only via a versioned, jurisdiction-filtered API | 1 | 🟡 Planned |`; total 26→27 stories.
- Epic 0.9 summary: reworded per §4.1; new Epic 0.10 summary added.
- Phase 0 Epic Stories Summary table: 0.9 row description updated to "JOH"; new 0.10 row (1 story); total 26→27 stories, "ten demos"→"eleven demos".

#### 4.4 `epics/index.md`

Phase 0 row: "🟡 Planned — 10 epics, 26 stories" → "🟡 Planned — 11 epics, 27 stories".

#### 4.5 `epics/framework.md` — Reference Data area

Append: *"The read-only API is split by upstream source: [Epic 0.9](phase-0/epic-0.9-reference-data-read-only-api.md) serves JOH data (tier-(a) + tier-(b)); [Epic 0.10](phase-0/epic-0.10-mrd-data-read-only-api.md) serves MRD data (`mrd_specialisms`) — split 2026-08-25c since no MRD read endpoint existed before."*

#### 4.6 `epics/fr-coverage-map.md`

FR6, FR7, FR58 rows: append "; MRD read surface is [Epic 0.10](phase-0/epic-0.10-mrd-data-read-only-api.md), split out 2026-08-25c" where they cite Epic 0.9's Story 0.9.2.

#### 4.7 `architecture.md` — decision log

New row:

| 17 | Reference Data read API split by upstream source: JOH (0.9) vs MRD (new 0.10) *(SCP 2026-08-25c)* | Epic 0.9's read API never actually covered `mrd_*` data — only tier-(b) vocab and tier-(a) JOH endpoints were ever specified, leaving MRD data reachable only via direct SQL. Split the epic by upstream source, mirroring the Epic 0.3 (JOH ingestion) / Epic 0.8 (MRD ingestion) write-side split: **Epic 0.9** keeps JOH + tier-(b) (unchanged content, retitled); **new Epic 0.10** adds the first `mrd_*` read endpoint (`GET /v1/reference-data/specialisms`), same API-as-Product conventions, published in the same `api-ctam-reference-data` OpenAPI artefact (one service, one contract — no new repo or deployable). See [`#sprint-change-proposal-2026-08-25c`](#sprint-change-proposal-2026-08-25c). |

#### 4.8 `architecture/changelog.md`

New version entry (v4.14) summarising the split and the new-scope MRD endpoint.

#### 4.9 `sprint-status.yaml`

Append:

```yaml
  epic-0.10: backlog
  0-10-1-mrd-data-read-only-rest-api-with-jurisdiction-filtering-versioning-openapi-rfc-9457-errors: backlog
  epic-0.10-retrospective: optional
```

(Epic 0.9's own block is unchanged — same two stories, same slugs.)

#### 4.10 `scripts/python/build_html.py`

NAV: retitle the Epic 0.9 entry; add an Epic 0.10 entry after it.

### 5. Implementation Handoff

**Scope: Moderate** — one new epic with real (if small) new story content, plus a cross-reference sweep. Routed as **Product Owner / Developer**.

**Success criteria:** Epic 0.9 and Epic 0.10 are each internally consistent; `epics/phase-0/index.md`'s two summary tables agree (27 stories, 11 epics); `docs/` regenerates cleanly with Epic 0.10 reachable from the nav; `data-tables.md` unchanged (no new table — this only adds a read endpoint over the existing `mrd_specialisms`).

---

## Sprint Change Proposal — 2026-08-25d

**Status:** approved

**Trigger:** *"retain the epics from 0.0,0.1,0.2,0.3,0.4 and remove all the other epics"*, followed by *"update all the files based on latest changes"* after the initial clarifying questions were declined.

**Mode:** Batch. **Scope classification:** **Major** — this removes real product scope (auth, notification, MRD, user bootstrap) from Phase 0, not just relabeling. Routed as recorded below.

---

### 1. Issue Summary

The team wants Phase 0 narrowed to just epics 0.0–0.4 — the platform estate and the JOH data pipeline (schema, mock API, ETL, read API) — with everything else removed. This is not a pure numbering exercise like the previous several SCPs this session: two of the epics being removed are genuine dependencies of epics being kept:

1. **Epic 0.1** (JOH schema) and **Epic 0.3** (JOH ETL) both `depends_on: epic-0.6` — the context bus (published architecture submodule) and the shared `ctam_configuration_values` baseline table.
2. **Epic 0.4** (JOH data read API)'s stories require `JWTFilter`-protected, jurisdiction-filtered endpoints, sourced from **Epic 0.7** (User authenticates).

I asked clarifying questions about how to resolve these two breaks and about whether "remove" meant permanent deletion or deferral; the questions were declined and the follow-up instruction was to proceed and keep everything else consistent. I resolved the two breaks using the options I'd flagged as recommended:

1. **Context bus folded into Epic 0.0** — its two stories become Stories 0.0.6–0.0.7. This is not just relabeling: Story 0.6.1 (publish `ctam-architecture` as the context bus, tag `arch-v1.0`) was recorded `done` in `sprint-status.yaml` — that status carries forward as Story 0.0.6, it is not reset to `backlog`.
2. **Epic 0.4's read API simplified to open/unauthenticated** — `JWTFilter` protection and jurisdiction-filtering are removed from its acceptance criteria, with an explicit note that re-adding them later (when an auth epic returns) is additive, not a redesign.

### 2. Impact Analysis

#### Epics removed (files deleted, git history retains them)

| Epic | Title | Stories | What happens to its scope |
|---|---|---|---|
| 0.5 | Notification service is scaffolded and contractually ready | 2 | FR9 unimplemented; downstream consumers (booking/absence acks, payment-schedule dispatch) blocked until re-planned |
| 0.6 | Context bus is published and the shared configuration baseline exists | 2 | **Folded into Epic 0.0**, not lost — Stories 0.0.6–0.0.7, `done` status preserved |
| 0.7 | User authenticates and lands on a role-scoped Home page | 5 | FR1–FR3, FR55, FR56, FR58 (auth half) unimplemented; Epic 0.4's API loses auth protection as a direct consequence |
| 0.8 | MRD supplementary reference data is ingested | 1 | `mrd_*` ingestion unimplemented; MRD read API (0.10) loses its data source |
| 0.9 | Both user populations are bootstrapped and verifiable against the IdP | 1 | FR4, FR57 unimplemented |
| 0.10 | MRD data is served read-only via a versioned, jurisdiction-filtered API | 1 | Removed along with its data source (Epic 0.8) |

**Total removed: 12 stories.** Phase 0 goes from 11 epics / 27 stories to **5 epics / 17 stories** (the +2 from folding Epic 0.6 into Epic 0.0 is why it isn't 15).

#### Epics kept, and what changed in them

- **Epic 0.0** — gains Stories 0.0.6–0.0.7 (folded from 0.6), `repo:` becomes a list (`[ctam-shared-infrastructure, ctam-architecture]`), storyCount 5→7.
- **Epic 0.1** — `depends_on` drops `epic-0.6`, now `[epic-0.0, epic-0.3]` (the context bus dependency now resolves through Epic 0.0).
- **Epic 0.2** — unaffected (no cross-references to removed epics).
- **Epic 0.3** — `depends_on` drops `epic-0.6`, now `[epic-0.0]`. All MRD and auth cross-references reworded to reflect their removal (not deletion of the ETL epic's own content — its 3 stories are unchanged).
- **Epic 0.4** — `depends_on` drops `epic-0.7`, now `[epic-0.3]`. Story 0.4.2 rewritten: drops `JWTFilter` protection, jurisdiction-filtering, the 401 Postman case, and the MRD-specific NFR13/NFR12 references. Title drops "jurisdiction-filtered." Explicit scope-reduction note added.

#### Artifact sweep

| Artifact | Change |
|---|---|
| 6 epic files | Deleted |
| `epic-0.0-platform-estate-provisioned.md` | +2 stories (0.0.6–0.0.7), `repo:` → list, scope-reduction note |
| `epic-0.1-postgres-sql-schema-design.md` | `depends_on` fixed, context-bus reference updated to Epic 0.0 |
| `epic-0.3-joh-reference-data-etl-process.md` | `depends_on` fixed; MRD/auth cross-references reworded throughout; one Story 0.3.3 AC reworded (no longer references the removed authorisation service for verification) |
| `epic-0.4-joh-data-read-only-api.md` | `depends_on` fixed; retitled; Story 0.4.2 rewritten to open/unauthenticated; scope-reduction notes added |
| `epics/phase-0/index.md` | Full rewrite: 5 epics, 17 stories |
| `epics/index.md` | Phase 0 count: 5 epics, 17 stories |
| `epics/framework.md` | Phase 0 Areas without a concrete epic marked as such (not deleted — they're still the architectural map); dependency-order table and parallelism note fixed |
| `epics/fr-coverage-map.md` | FR1–FR4, FR9, FR55–FR58 (partial), FR57 marked ⚪ not currently delivered (not deleted — real PRD requirements) |
| `epics/requirements-inventory.md` | MRD storage cross-reference marked not-currently-provisioned |
| `architecture/non-functional-requirements-coverage.md` | NFR24 narrowed to JOH-only |
| `architecture/repository-strategy.md` | `ctam-reference-data` row: MRD/auth cross-references removed |
| `architecture/gaps.md` | G8.1: MRD half marked untracked (gap itself not closed) |
| `architecture/delivery-operating-model.md` | Illustrative examples referencing removed epics swapped for still-valid ones |
| `architecture.md` | New decision **#18** |
| `architecture/changelog.md` | New **v4.15** entry |
| `sprint-status.yaml` | 6 epic blocks removed; Epic 0.0 gains Stories 0.0.6 (**`done`**, carried forward) and 0.0.7; incidental fix of a stale "16-repo" comment to "17-repo" |
| `scripts/python/build_html.py` | NAV: 6 entries removed, Epic 0.0's story count updated |

**Not touched:** dated historical SCPs/changelog entries (immutable record of what was true when written); `data-tables.md` (schema for removed epics' tables is unaffected — the tables just aren't being created by an active epic right now).

### 3. Recommended Approach

**Direct implementation** (the two clarifying questions were declined, so I proceeded using the recommended defaults I'd already identified, rather than blocking further). Deletion was judged safe to do literally (not just deferred) because: this branch's prior commit is already pushed to the remote PR, so the removed epics' content remains fully recoverable via git history without needing an in-repo "deferred" holding area.

**Effort:** High (large mechanical sweep). **Risk:** Medium — this is a real scope cut, not a relabel; FR1–FR4, FR9, FR55–58, FR57 genuinely lose Phase 0 coverage and are flagged as such rather than silently dropped. **Timeline impact:** Reduces Phase 0's build scope by roughly 44% of its stories (12 of 27); nothing currently in flight was disrupted (`sprint-status.yaml` showed only Story 0.6.1 as `done`, now carried forward as 0.0.6).

### 4. Detailed Change Proposals

See §2 for the full before/after mapping. Full diffs are in the files themselves.

### 5. Implementation Handoff

**Scope: Major** — real functional scope removed from an active plan, not a backlog reorganisation. Per the workflow's own classification this would normally route to Product Manager / Solution Architect for a fundamental replan; it was executed directly here per explicit, repeated user instruction (the clarifying questions that would normally precede PM/Architect-level judgment were declined twice).

**Responsibilities:**
- **Product Owner / stakeholders:** confirm this scope cut is intended for the demo/milestone this narrower Phase 0 is meant to support, and decide when (if ever) auth, notification, MRD, and user bootstrap should be re-planned as new epics.
- **This session:** all edits above applied directly; `docs/` regenerated; nothing committed without being asked.

**Success criteria:** all 5 remaining epic files are internally consistent (no dangling references to removed epics); `depends_on` arrays across the 5 epics resolve only to each other; `epics/phase-0/index.md`'s two summary tables agree (17 stories, 5 epics); `fr-coverage-map.md` accurately marks every FR that lost coverage; `docs/` regenerates cleanly with no dangling nav links to deleted epic pages.

---

## Sprint Change Proposal — 2026-08-25f

**Status:** approved

**Trigger:** *"we are deploying the service in local environment remove the dependency on 0.0"*, following a `/bmad-help` exchange about why Epic 0.2 depends on Epic 0.0.

**Mode:** Batch. **Scope classification:** **Moderate** — a deployment-target narrowing within one epic, not a functional cut.

---

### 1. Issue Summary

Epic 0.2 (`ctam-jomockapi`, the JOH eLinks mock API) previously deployed to the shared dev/staging Azure estate (AKS, ACR, Key Vault, APIM) so that `ctam-reference-data`'s eLinks sync could reach it over the network in a shared environment — this was the epic's entire reason for `depends_on: [epic-0.0]`. The team is instead running these services locally during development. Since the mock is never deployed anywhere but a developer's machine in this scope, the shared-estate dependency is not just unnecessary — it doesn't correspond to anything the epic actually does anymore, so it's removed.

### 2. Impact Analysis

#### What changed

- **Epic 0.2** — `depends_on` drops from `[epic-0.0]` to `[]`. Story 0.2.2 rewritten from "Deploy `ctam-jomockapi` onto the shared dev/staging estate" (Helm chart, AKS, Key Vault-held credential) to "Run `ctam-jomockapi` locally via Docker Compose" (a `docker-compose.yml` service, a local `.env` credential). Story 0.2.3 rewritten from "...runs against the deployed mock in dev/staging" to "...runs against the locally-running mock" — the demonstrability claim narrows from "dev/staging" to "local development." Story 0.2.1 (onboarding) is adjusted to drop the ACR registry push and any Helm/deploy-workflow scaffolding, since nothing in this epic deploys anywhere shared.
- **Epic 0.3** — Story 0.3.3's AC block that pointed the sync's "dev/staging base URL" at Epic 0.2's deployed mock is reworded to point the sync's *local* base URL at the locally-running mock instead.
- **NFR16 (Key Vault), NFR31 (Azure UK South), NFR40 (per-service deployable)** — no longer exercised by Epic 0.2 at all (nothing is deployed to the shared estate from this epic). **NFR24**'s "exercised end-to-end pre-contract" claim narrows from a dev/staging demonstration to a local-only one.
- **gaps.md G8.1** and **non-functional-requirements-coverage.md's NFR24 entry** — reworded to say the mock unblock is local, not dev/staging. G8.1 itself (the real eLinks contract confirmation) stays open regardless — unaffected by where the mock runs.

#### Artifact sweep

| Artifact | Change |
|---|---|
| `epic-0.2-joh-elinks-mock-api-stands-in.md` | `depends_on` → `[]`; scope-reduction note added; Hosting/vertical-slice/out-of-scope reworded; Story 0.2.1 (registry push dropped), 0.2.2 (full rewrite to Docker Compose), 0.2.3 (full rewrite to "locally-running mock") |
| `epic-0.3-joh-reference-data-etl-process.md` | Story 0.3.3's mock-target AC reworded from dev/staging to local |
| `epics/phase-0/index.md` | Epic 0.2 summary, sequencing note, Phase 0 Epic Stories Summary table rows for 0.2 and 0.3 |
| `epics/framework.md` | Ingestion area note (Epic 0.2's mock target reworded) |
| `epics/fr-coverage-map.md` | NFR24 row |
| `architecture/gaps.md` | G8.1 |
| `architecture/non-functional-requirements-coverage.md` | NFR24 entry |
| `architecture/repository-strategy.md` | `ctam-jomockapi` row |
| `architecture/assumptions.md` | A38 |
| `architecture/delivery-operating-model.md` | Parallelism illustration (Epic 0.2 has no epic dependency, not "needs only the estate") |
| `architecture.md` | New decision **#19** |
| `architecture/changelog.md` | New **v4.16** entry |
| `sprint-status.yaml` | Epic 0.2's Story 0.2.2/0.2.3 slugs renamed to match the rewritten titles |

**Not touched:** dated historical SCPs/changelog entries and decision-log rows (immutable record); Epic 0.0, 0.1, 0.4 (unaffected — this change is scoped to Epic 0.2 and the one cross-reference in Epic 0.3).

### 3. Recommended Approach

**Direct implementation.** Effort: **Low-Medium** (one epic's deployment model changes, with a small ripple into Epic 0.3's one AC block and several NFR/gap cross-references). **Risk:** Low — nothing was `done` on this epic yet (`epic-0.2: backlog`), so no completed work is disrupted; the real eLinks contract gap (G8.1) is explicitly unaffected.

### 4. Detailed Change Proposals

See §2 for the full before/after mapping. Full diffs are in the files themselves.

### 5. Implementation Handoff

**Scope: Moderate** — one epic's deployment target changes, with cross-references updated to match; not a functional cut.

**Responsibilities:**
- **Product Owner / stakeholders:** confirm local-only is acceptable for Phase 0's demoability goal for this integration — if a shared dev/staging demonstration is later needed, a future epic can add it back (Epic 0.2's out-of-scope note says so explicitly).
- **This session:** all edits above applied directly; nothing committed without being asked.

**Success criteria:** Epic 0.2's `depends_on` is `[]` and every AC in its 3 stories consistently describes a local Docker Compose flow, not a shared-estate deployment; Epic 0.3's Story 0.3.3 cross-reference matches; no remaining "dev/staging" claim tied to this mock anywhere in the sweep list above; `docs/` regenerates cleanly.

---

## Sprint Change Proposal — 2026-08-25g

**Status:** approved

**Trigger:** *"Modify epic-0.2 to build the joh-elinks-mock-api using java springboot applications instead of npm"*.

**Mode:** Batch. **Scope classification:** **Minor** — a build-stack change within Epic 0.2's own repo; no cross-epic dependency, FR/NFR, or PRD impact.

---

### 1. Issue Summary

Epic 0.2's `ctam-jomockapi` was previously scoped as an explicitly-recorded deviation from CTAM Pathfinder's Java/Spring Boot stack baseline (assumptions.md A38) — the existing Node.js/Express codebase at the real `ctam-jomockapi` repo was to be onboarded as-is, justified because it delivers no FR/NFR and never reaches production (mirroring `ctam-mock-auth`'s non-production-only exemption). The team now wants it built with Java/Spring Boot instead, like every other CTAM Pathfinder service — removing that stack deviation entirely.

### 2. Impact Analysis

#### What changed

- **Story 0.2.1** — retitled from "Onboard `ctam-jomockapi` as a CTAM Pathfinder repo" to "Scaffold `ctam-jomockapi` from the HMCTS starter and port the eLinks mock to Java/Spring Boot." Its ACs are rewritten around `ctam-scaffold.sh` (same pattern as `ctam-reference-data`/`ctam-joh`'s scaffold stories): Spring Boot 4.0.x, Gradle Groovy DSL, Group ID `uk.gov.hmcts.ctam`, artefact `ctam-jomockapi`, base package `uk.gov.hmcts.ctam.jomockapi`, port `8090`. The existing Node/Express reference implementation's documented contract — endpoints, fixed-seed data generation, bearer-token handling, the `ReferenceData/*.csv|json` fixtures — is explicitly scoped as a **faithful port**, not a redesign: same request/response shapes, same seed data, same auth behaviour.
- **Deliberately excluded**, unlike every domain service: Liquibase, Testcontainers PostgreSQL, MapStruct (the mock is stateless — no database, no cross-object mapping need), and a Helm chart / per-service Terraform (it still never deploys anywhere but locally, per SCP 2026-08-25f).
- **Story 0.2.2** — updated for the new stack: port references change from Node's `4000` to the new service's `8090`; the `npm start` comparison in the story's "so that" clause becomes `./gradlew bootRun`.
- **Story 0.2.3** — unaffected; it never referenced Node/npm specifically, only "the local instance," which is stack-agnostic.
- **Epic 0.2's Hosting/vertical-slice/out-of-scope sections** — the "standalone Node.js/Express service — an explicitly-scoped deviation" framing is replaced with "scaffolded like every other CTAM Pathfinder backend service — no stack deviation." The old out-of-scope bullet "Rewriting `ctam-jomockapi` in Java/Spring — it stays Node/Express as already built" is **removed** (it's now the literal opposite of what this epic does) and replaced with two new exclusions: no behavioural contract change during the port, and no database of any kind.
- **assumptions.md A38** — revised in place (not superseded via a new row — this is a living reference document, not a dated record) to describe the Java/Spring Boot build instead of the Node/Express deviation.
- **repository-strategy.md's `ctam-jomockapi` row** — revised to describe a Java/Spring Boot service scaffolded via `ctam-scaffold.sh`, ported from an earlier Node/Express reference implementation.

#### Artifact sweep

| Artifact | Change |
|---|---|
| `epic-0.2-joh-elinks-mock-api-stands-in.md` | Stack-change scope-reduction note added; description/User outcome/Hosting/vertical-slice/out-of-scope reworded; Story 0.2.1 fully rewritten (scaffold + faithful port); Story 0.2.2 updated (port 8090, `./gradlew bootRun`) |
| `architecture/assumptions.md` | A38 revised in place |
| `architecture/repository-strategy.md` | `ctam-jomockapi` row revised |
| `architecture.md` | New decision **#20** |
| `architecture/changelog.md` | New **v4.17** entry |
| `sprint-status.yaml` | Story 0.2.1's slug renamed to match the new title |

**Not touched:** `epic-0.3` (its Story 0.3.3 cross-reference to Epic 0.2 doesn't name a tech stack, so it's unaffected by this change — it was already updated for the local-vs-dev/staging change in SCP 2026-08-25f); Story 0.2.3 (stack-agnostic); gaps.md G8.1 (doesn't mention tech stack); `epics/framework.md` (its Epic 0.2 mention doesn't name a stack either); FR/NFR coverage (this mock delivers no FR/NFR directly, unaffected); dated historical SCPs/changelog entries (immutable record).

### 3. Recommended Approach

**Direct implementation.** Effort: **Low** — one story rewritten, one story lightly touched, two reference docs updated in place. **Risk:** Low — `epic-0.2: backlog` in `sprint-status.yaml`, nothing built yet against the old Node-based plan; the actual `ctam-jomockapi` codebase on disk (a real, already-built Node/Express app) is unaffected by this planning-repo change until Story 0.2.1 is actually dispatched and executed against it — at which point the story now instructs a fresh Java/Spring Boot scaffold with the existing app treated as a reference implementation to port, not a codebase to onboard verbatim.

### 4. Detailed Change Proposals

See §2 for the full before/after mapping. Full diffs are in the files themselves.

### 5. Implementation Handoff

**Scope: Minor** — a build-stack change within one epic's own scope, no cross-epic ripple beyond what SCP 2026-08-25f already touched.

**Responsibilities:**
- **Product Owner / stakeholders:** confirm the Java/Spring Boot port is worth the engineering effort versus keeping the existing, already-working Node/Express mock — this SCP does not weigh that trade-off, it only encodes the decision as given.
- **This session:** all edits above applied directly; nothing committed without being asked.

**Success criteria:** Epic 0.2 no longer mentions Node.js/Express as its build stack anywhere except as the explicit port-source; Story 0.2.1's ACs consistently describe a `ctam-scaffold.sh`-based Spring Boot scaffold with a faithful contract port, not an onboarding of the existing codebase as-is; assumptions.md A38 and repository-strategy.md's `ctam-jomockapi` row agree with the epic; `docs/` regenerates cleanly.

---

## Sprint Change Proposal — 2026-08-25h

**Status:** approved

**Trigger:** *"review all the 5 epics and suggest if there are any changes"*, followed by *"fix all the above inconsistencies"* after the review was presented.

**Mode:** Batch. **Scope classification:** **Minor** — documentation/citation fixes within existing epics; no scope change, no FR/NFR change, no `depends_on` change.

---

### 1. Issue Summary

A full read-through of all 5 Phase 0 epics (0.0–0.4) — prompted by a request to review them for consistency — surfaced five concrete inconsistencies, none caught by the narrower per-round sweeps in earlier SCPs because they cut across epics rather than living inside the one epic each prior SCP touched.

### 2. Impact Analysis

#### Finding 1 — Port collision between `ctam-joh` and `ctam-reference-data`

Story 0.1.1 and Story 0.3.1 both hardcoded "default port is 8082 (per AR3)," and AR3 itself just says "Default port 8082" with no per-service override. Two services scaffolded from the same rule would collide the moment they run side by side (locally, or in a cluster without an explicit override).

**Fix:** AR3 revised to say each service gets its own distinct port, starting from 8082 and incrementing per service in scaffold order. `ctam-joh` moves to **8083**; `ctam-reference-data` keeps **8082** (it was scaffolded first, and is referenced by port number in several other places — moving it would have a larger ripple for no benefit); `ctam-jomockapi`'s existing 8090 is called out as consistent with this pattern.

#### Finding 2 — FR8 double-attributed

Epic 0.3's "FRs covered" line claimed *"FR8 (shared `ctam_configuration_values` baseline first lands here)"* — but `fr-coverage-map.md` and Epic 0.0 Story 0.0.7 both correctly show Epic 0.0 as the epic that creates that table. Epic 0.3 only verifies the table is reachable before `ctam-reference-data` proceeds (Story 0.3.1's AC); it doesn't deliver FR8.

**Fix:** Epic 0.3's "FRs covered" line drops the FR8 claim and adds a parenthetical: *"FR8 is delivered by Epic 0.0, Story 0.0.7 — this epic only consumes/verifies the shared baseline."*

#### Finding 3 — Wrong story citation in Epic 0.4, Story 0.4.1

Its lead AC said *"Given `ctam-reference-data` is scaffolded and carries the tier-(a) tables per Story 0.3.3"* — Story 0.3.3 is the nightly sync (populates data); the tables themselves are created in **Story 0.3.2**. Story 0.4.1 only needs the tables to exist (to keep tier-(b) tables separate from them), not populated data.

**Fix:** Citation corrected to Story 0.3.2, with a parenthetical explaining why (doesn't need the sync to have run).

#### Finding 4 — `ctam_joh_identities` never explicitly created

Story 0.3.2's changeset AC enumerated exactly the 15 `jo_*` tables plus `ctam_sync_status` — `ctam_joh_identities` appeared nowhere in either list, despite Story 0.3.3 minting rows into it, Epic 0.1's Story 0.1.2 citing it as an existing FK target (correctly, citing Story 0.3.2), and Epic 0.3's own prose describing binding `personnel_number` to it.

**Fix:** Story 0.3.2's changeset AC now explicitly creates `ctam_joh_identities` (`id uuid PK`, `personnel_number` unique, `created_at`/`updated_at`), stating it's created empty here and populated row-by-row by Story 0.3.3's sync.

#### Finding 5 — Local mock vs. AKS-deployed `ctam-reference-data` unreconciled

Epic 0.2's `ctam-jomockapi` runs **only locally** via Docker Compose (SCP 2026-08-25f). Story 0.3.3's mock-integration AC pointed the sync's "local base URL" at it — but Story 0.3.1 (same epic) also deploys `ctam-reference-data` to the shared AKS dev cluster, and an AKS pod has no network path to a developer's Docker Compose network. Nothing said which run-mode of `ctam-reference-data` the mock-integration AC exercises.

**Fix:** The AC now states explicitly that it exercises `ctam-reference-data` run locally too (`./gradlew bootRun` alongside `docker-compose up`, per Story 0.3.1's local-verification AC) — **not** the AKS-deployed instance.

#### Not fixed — raised as an open question instead

A sixth observation from the review: Epic 0.0 still provisions a full Terraform shared Azure estate (5 stories) for the domain services, while Epic 0.2 just moved to local-only for its mock. Whether that split is intentional (mocks stay local forever; domain services need a real shared environment eventually) or whether the team's local-first practice should extend further is a product/architecture call, not a documentation bug — left open for the user to decide, not fixed here.

#### Artifact sweep

| Artifact | Change |
|---|---|
| `epics/requirements-inventory.md` | AR3 reworded — per-service distinct ports |
| `epic-0.1-postgres-sql-schema-design.md` | Story 0.1.1 port 8082 → 8083 |
| `epic-0.3-joh-reference-data-etl-process.md` | FR8 attribution reworded; `ctam_joh_identities` added to Story 0.3.2's changeset; Story 0.3.3's mock-integration AC clarified (local `ctam-reference-data`, not AKS) |
| `epic-0.4-joh-data-read-only-api.md` | Story 0.4.1's prerequisite citation fixed (0.3.3 → 0.3.2) |
| `architecture.md` | New decision **#21** |
| `architecture/changelog.md` | New **v4.18** entry |

**Not touched:** `epic-0.0`, `epic-0.2` (no findings against them beyond the open question); `fr-coverage-map.md` (already correctly attributed FR8 to Epic 0.0 — Epic 0.3 was the one out of step, now fixed to match); `sprint-status.yaml` (no story added/removed/renamed — only AC text and one port number changed within existing stories); dated historical SCPs/changelog entries (immutable record).

### 3. Recommended Approach

**Direct implementation.** Effort: **Low** — five targeted text edits across three epic files plus one requirements-inventory row, no structural change. **Risk:** Very low — nothing here changes `depends_on`, FR/NFR coverage, or story counts; it only corrects citations, a port number, and an implicit-but-undocumented table creation to match what other stories already assumed.

### 4. Detailed Change Proposals

See §2 for the full before/after mapping. Full diffs are in the files themselves.

### 5. Implementation Handoff

**Scope: Minor** — documentation/citation corrections within the existing plan, no scope or dependency change.

**Responsibilities:**
- **This session:** all edits above applied directly; nothing committed without being asked.
- **Product Owner / Architect (deferred):** decide the open question above — whether Epic 0.0's shared-estate scope should also narrow toward local-first for Phase 0, or stays as-is for the real domain services. Not gating on this SCP.

**Success criteria:** no two Phase 0 services share a hardcoded port; Epic 0.3's FR8 claim matches `fr-coverage-map.md` and Epic 0.0; every story citation in Epic 0.4 points at the story that actually delivers what it depends on; `ctam_joh_identities` has an explicit creation point before anything reads or writes it; Story 0.3.3's mock-integration AC is unambiguous about which `ctam-reference-data` run-mode it exercises.

---

## Sprint Change Proposal — 2026-08-25i

**Status:** approved

**Trigger:** *"review all epics in phase-0"* — a second review pass, following SCP 2026-08-25h's fixes from the first pass.

**Mode:** Batch. **Scope classification:** **Minor** — documentation/citation fixes within existing epics; no scope, FR/NFR, or dependency change.

---

### 1. Issue Summary

A second full review of all 5 Phase 0 epics was requested. Rather than re-checking the same epic-to-epic cross-references already fixed in SCP 2026-08-25h, this pass cross-checked each epic's claims against the two documents epics are supposed to be *derived from*: `architecture/data-tables.md` (the canonical table inventory) and `requirements-inventory.md`'s AR list (the canonical architecture-rule numbering). That angle surfaced two more issues neither epic-to-epic comparison nor the first pass had caught.

### 2. Impact Analysis

#### Finding 6 — `ctam_joh_identities` grant breadth understated

`data-tables.md` documents `ctam_joh_identities` explicitly: *"SELECT-granted to every domain service"* — listing Authorisation, JOH, Absence, Booking, Sitting, Itinerary, and MI Feed as key consumers, because it's the JOH identity spine every domain table keys off of (`joh_id` → `ctam_joh_identities.id`). Story 0.3.2's grants AC (which SCP 2026-08-25h had just extended to also *create* this table) only said SELECT grants exist "for `ctam_joh` (schema composition, Epic 0.1) and placeholder roles for future services" — correct for the `jo_*` tables, but understating `ctam_joh_identities`'s actual grant scope, which isn't `ctam_joh`-specific at all.

**Fix:** Story 0.3.2's grants AC now states explicitly that `ctam_joh_identities` is SELECT-granted to *every* current and placeholder domain service DB role, quoting `data-tables.md`'s own language, and the fitness-function AC now verifies grant breadth as well as the tier-(a) write-protection rule.

#### Finding 7 — AR52 mis-cited for the WireMock/stub testing convention

Three places cite "AR52" for `ctam-reference-data`'s CI-only WireMock/stub eLinks API pattern: Epic 0.3's Story 0.3.3 AC, and Epic 0.2's Story 0.2.3 AC plus its References line. But AR52 in `requirements-inventory.md` is actually: *"User and authorisation records... are strictly CTAM-internal, populated by programme-management / operational mechanisms..."* — completely unrelated to WireMock or eLinks testing. Searching the whole `requirements-inventory.md` for "WireMock" turned up nothing — no architecture rule anywhere actually documents this testing convention, despite three stories treating it as an established, numbered rule.

**Fix:** Added **AR54** to `requirements-inventory.md`, describing the WireMock/stub convention and its relationship to Epic 0.2's locally-run mock (complementary — fast hermetic CI checks vs. a realistic local network target, not a replacement of one by the other). Corrected all three stale "AR52" citations to "AR54," and completed Story 0.3.3's References line, which cited AR46/AR48/AR49 but had omitted AR54/AR52 entirely even though its own AC body referenced it.

#### Artifact sweep

| Artifact | Change |
|---|---|
| `epics/requirements-inventory.md` | New **AR54** added (CI-only WireMock/stub eLinks API convention) |
| `epic-0.3-joh-reference-data-etl-process.md` | Story 0.3.2's grants AC extended for `ctam_joh_identities` breadth; Story 0.3.3's AR52 → AR54 citation fixed; Story 0.3.3's References line completed with AR54 |
| `epic-0.2-joh-elinks-mock-api-stands-in.md` | Story 0.2.3's AR52 → AR54 citation fixed (AC body + References line) |
| `architecture.md` | New decision **#22** |
| `architecture/changelog.md` | New **v4.19** entry |

**Not touched:** `epic-0.0`, `epic-0.1`, `epic-0.4` (no findings against them this pass); `sprint-status.yaml` (no story added/removed/renamed); `fr-coverage-map.md`, `gaps.md`, `assumptions.md` (checked, no discrepancy found this pass); dated historical SCPs/changelog entries (immutable record).

### 3. Recommended Approach

**Direct implementation.** Effort: **Low** — two targeted fixes, one new AR entry, four citation corrections. **Risk:** Very low — no structural change; both fixes make documentation match what other parts of the same epics (and `data-tables.md`) already assumed was true.

### 4. Detailed Change Proposals

See §2 for the full before/after mapping. Full diffs are in the files themselves.

### 5. Implementation Handoff

**Scope: Minor** — documentation/citation corrections within the existing plan, no scope or dependency change.

**Responsibilities:**
- **This session:** all edits above applied directly; nothing committed without being asked.

**Success criteria:** `ctam_joh_identities`'s documented grant scope in Story 0.3.2 matches `data-tables.md`'s "every domain service" note; every citation of the WireMock/stub convention across Epic 0.2 and Epic 0.3 points at a real, existing AR (AR54); Story 0.3.3's References line lists every AR its own ACs actually cite.

---

## Sprint Change Proposal — 2026-08-25j

**Status:** approved

**Trigger:** User request — two Confluence pages (`3.2.1.1 CTAM JO Schema`, `3.2.1.2 CTAM Schema and Source Mapping`) document how the JOH eLinks integration schema was designed; the user wants CTAM's own PostgreSQL schema designed "in the similar way," with Epic 0.1 updated and new stories authored for it.

**Mode:** Incremental (single artifact, iterated live with the user). **Scope classification:** **Moderate** — epic content is substantially rewritten (2 → 4 stories) and Phase 0 story totals shift, but no PRD/FR/NFR change, no new table, no new repo, no dependency-graph change.

---

### 1. Issue Summary

The user supplied two internal HMCTS Confluence pages under the JUDIT space:

- `3.2.1.1 CTAM JO Schema` — ER diagrams (full + transactional-core) for the JOH eLinks integration.
- `3.2.1.2 CTAM Schema and Source Mapping` — the same schema's design decisions (naming, JOH lifecycle, deprecated-attribute exclusion, sync metadata, FK strategy, a documented edge case), a 16-table list, a full column-level mapping per table (CTAM column / type / PK-FK / source attribute / description), a refresh-strategy note, 8 numbered data warnings, and 13 numbered open questions (11 closed, 2 open).

Both pages are behind HMCTS's internal `tools.hmcts.net` Confluence, unreachable from this environment; the user exported them to PDF, which were read in full and distilled to `_bmad-output/source-docs/joh-schema-confluence/`.

Cross-checking the source pages against the current architecture surfaced a structural fact the user's request needed reconciling with: the 16 tables these pages describe are the **tier-(a) `jo_*` upstream-replica schema**, which `architecture/data-tables.md` and decision D3/D9 already assign to **`ctam-reference-data` / Epic 0.3** (Story 0.3.2) — a different repo and a different, non-overlapping table set from **Epic 0.1**'s 5 CTAM-owned tier-(b) `ctam-joh` overlay tables (`ctam_working_patterns`, `ctam_working_pattern_days`, `ctam_joh_ticket`, `ctam_joh_location`, `ctam_jurisdictional_splits`). Duplicating `jo_*` table definitions into Epic 0.1 would put tier-(a) DDL in the wrong repo and break the single-writer tier-ownership rule (AR49: only `ctam_reference_data` holds INSERT/UPDATE on `jo_*`).

The user, on hearing this, directed: keep the update on Epic 0.1, and design `ctam-joh`'s own schema **the same way** the source pages design theirs — i.e. adopt the *documentation rigor* (design-decisions doc → ER diagram → column-level spec → data-warnings/open-questions doc), not the specific `jo_*` tables. This SCP implements that direction.

### 2. Impact Analysis

#### Epic Impact

**Epic 0.1** (`epic-0.1-postgres-sql-schema-design.md`) — substantially rewritten:
- Story count: 2 → 4.
- Story 0.1.1 (scaffold `ctam-joh`) — unchanged content; forward-references to "Story 0.1.2" for table creation corrected to point at the new Story 0.1.3.
- **New Story 0.1.2** — a schema design-decisions doc (`architecture/ctam-joh-schema-design.md`), covering naming/PK/FK conventions, the `ctam_jurisdictional_splits` cross-row invariant decision (carried forward verbatim from the old Story 0.1.2's AC), the tier-(b)-vocabulary FK verification gate (also carried forward), and an explicit restatement of the grant model.
- **Story 0.1.3** (rewritten from the old Story 0.1.2) — the actual DDL, now paired with a D2+ELK ER diagram (house standard, `CLAUDE.md`) and a full column-level reference per table, mirroring the source pages' own column-mapping tables (minus a "source attribute" column, since these are CTAM-native tables with no upstream source).
- **New Story 0.1.4** — a data-warnings/open-questions companion doc, mirroring the source pages' §5–6, seeded with three concrete warning candidates specific to `ctam-joh`'s overlay tables (soft-delete parity on upstream leaver/deleted, split re-validation timing, overlay reconciliation against the tier-(a) baseline).
- Epic-level frontmatter (`description`, `storyCount`), vertical-slice bullets, and out-of-scope note updated to match.

**Epic 0.3** (`ctam-reference-data`, tier-(a) `jo_*` tables) — **not touched by this SCP.** Its Story 0.3.2 already lists the correct 15 `jo_*` table names (matching the source pages' table list exactly) but has no column-level detail. The source pages could supply that detail and may partially close `gaps.md` G8.1 (previously: "the JOH eLinks API contract... is unconfirmed" — these pages are sourced from "eLinks (a.k.a. JHR) REST API, Data Dictionary v2.0, 2025-07-02," i.e. a real, dated contract artefact). This is flagged as a follow-up, not actioned here, since the user's request was explicitly scoped to Epic 0.1.

**`data-tables.md`** — not touched. Its `jo_*` and `ctam-joh` sections both remain accurate at the level of detail they already carry (table names + one-line descriptions); this SCP adds column-level detail to Epic 0.1's own doc set, not to this shard.

#### A naming question surfaced, deliberately not resolved here

The source pages' real natural-key column is `jo_people.personal_code` (VARCHAR(32)) — but 27 files across this repo (PRD, `architecture.md`, `conventions.md`, every Phase-0 epic, decision D9) use `personnel_number` for the same concept, and `personal_code` appears nowhere in the current repo. This is a `jo_*`/Epic 0.3 concern, not an Epic 0.1 one (Epic 0.1's own tables reference `ctam_joh_identities.id` via `joh_id`, never `personnel_number` directly, so the rename — if made — would not change any Epic 0.1 AC). Raised here for visibility; **not actioned**, and left for a future SCP scoped to Epic 0.3 if the user wants it resolved.

#### Artifact sweep

| Artifact | Change |
|---|---|
| `epic-0.1-postgres-sql-schema-design.md` | Full rewrite: 2 → 4 stories, frontmatter, vertical slice, out-of-scope note |
| `epics/phase-0/index.md` | Epic table row (2 → 4 stories), Epic 0.1 summary paragraph, Phase 0 Epic Stories Summary table row, both story totals (17 → 19) |
| `epics/index.md` | Phase 0 status line story total (17 → 19) |
| `architecture.md` | New decision **#23** |
| `architecture/changelog.md` | New **v4.20** entry |
| `_bmad-output/source-docs/joh-schema-confluence/` | New — the two source PDFs, copied in (source documents are read-only elsewhere in the repo; this is the designated distillation location) |

**Not touched:** `epic-0.0`, `epic-0.2`, `epic-0.3`, `epic-0.4` (flagged as a follow-up candidate only, per above); `data-tables.md`; `gaps.md` (G8.1 flagged, not edited); `fr-coverage-map.md` (Epic 0.1's FR coverage claim — "schema groundwork only" — is unchanged by this expansion); `requirements-inventory.md` (no new AR — this epic cites existing AR2–AR32 plus `CLAUDE.md`'s D2+ELK diagram standard, which isn't a numbered AR); `sprint-status.yaml` (out of this session's scope — a sprint-planning concern, not a course-correction one); dated historical SCPs/changelog entries (immutable record).

### 3. Recommended Approach

**Direct Adjustment** — rewrite Epic 0.1 in place; no rollback, no MVP scope change. Effort: **Moderate** (one epic substantially rewritten, two index files updated, one decision-log + changelog entry). Risk: **Low** — additive documentation rigor to an epic with no implementation started yet (per the epic's own "nothing built yet" precedent, decision #8); no FR/NFR/dependency-graph change; the one open naming question is explicitly deferred rather than silently decided.

### 4. Detailed Change Proposals

See §2 for the full before/after mapping; the rewritten epic file carries complete Given/When/Then ACs for all 4 stories.

Story-shape rationale (why 4, not more or fewer): the source pages' own structure has four natural phases — *design decisions* (§1), *ER diagram* (their two diagrams), *column-level mapping* (§3, 16 sub-sections), *data warnings/open questions* (§5–6). Column-level mapping and the ER diagram are combined into one story (0.1.3) because for CTAM-native tables the diagram and the DDL are authored together, not sequentially the way a replicated schema's diagram (fixed by the source) can precede its mapping table.

### 5. Implementation Handoff

**Scope: Moderate** — epic content substantially rewritten (backlog reorganization: story count changes, no code exists yet to migrate). Routed to **Product Owner / Developer agents** for sprint-planning pickup (`bmad-sprint-planning` will need to regenerate `sprint-status.yaml` entries for the new Story ids 0.1.2–0.1.4, since the old 0.1.2 no longer refers to table DDL).

**Responsibilities:**
- **This session:** all edits above applied directly; nothing committed without being asked.
- **Follow-up (not this SCP, flagged for a future one):** an equivalent column-level documentation pass against Epic 0.3 Story 0.3.2 / `data-tables.md`'s `jo_*` section, using the same two source pages; and a decision on the `personnel_number` vs. `personal_code` naming question.

**Success criteria:** Epic 0.1 has 4 stories with complete ACs; every forward/backward story cross-reference within the epic resolves correctly (0.1.1 → 0.1.2/0.1.3/0.1.4; 0.1.3 depends on 0.1.2; 0.1.4 depends on 0.1.2 + 0.1.3); Phase 0 story totals are consistent across `epic-0.1`, `phase-0/index.md`, and `epics/index.md` (19 everywhere); the decision log and changelog both record this as a traceable, dated change; the `jo_*` schema itself is not duplicated anywhere in Epic 0.1.

---

## Sprint Change Proposal — 2026-08-25k

**Status:** approved

**Trigger:** User request — "update epic-0.2 based on the files in `/Users/shivakumar/MOJ/ram_analysis_docs`," a folder containing the real `E-links API v5.0` Swagger doc (`Swagger UI.pdf`) and June 2026 production reference-data exports (`ReferenceData/*.csv|json`) — the same class of source material Epic 0.2's Story 0.2.1 already claims to port "faithfully," but a direct comparison had not previously been done against this specific Swagger export.

**Mode:** Incremental (single artifact, iterated live with the user). **Scope classification:** **Minor** — Story 0.2.1's AC is corrected in place for completeness; no new story, no FR/NFR/PRD change, no dependency-graph change.

---

### 1. Issue Summary

Comparing the real Swagger doc's `Schemas`/`Paths` against Story 0.2.1's endpoint-porting AC (which claims every endpoint is reimplemented with an "identical" request/response shape) surfaced two omissions and several unspecified contract details:

1. **`GET /api/v5/people/{id}`** — a single-person lookup endpoint, distinct from the `/people` change-feed, present in the real contract but never named in the epic.
2. **`GET /api/v5/reference_data/{attribute_name}/{reference_id}`** — a single reference-data-item lookup, companion to the already-named list endpoint, also never named.
3. **Required query parameters** — `updated_since` (`/people`), `left_since` (`/leavers`), and `deleted_since` (`/deleted`) are all `required` in the real contract (missing → `400` validation error, confirmed from the Swagger UI's own "Try it out" error state); the epic didn't say so.
4. **Pagination defaults and metadata** — `per_page` (default 50) and `page` (default 1) are documented optional params, with responses carrying a `PaginationResponse` (`pages`, `current_page`, `results_per_page`, `more_pages`); not previously specified.
5. **Deprecated singular aliases** — the real `attribute_name` path parameter accepts 11 deprecated singular forms (`appointment_title`, `base_location`, …) alongside the 11 canonical plural names; not previously specified.

The real reference-data exports (`AppointmentTitle`, `BaseLocation`, `ContractType`, `Gender`, `JudiciaryRole`, `Jurisdiction`, `Location`, `LocationType`, `Ticket`, `TicketCategory`, `TicketCategoryType` — 11 files) confirm the epic's existing "11 vocabularies" claim is correct; no change needed there.

**Discussed and explicitly decided against:** the real Swagger doc's `Servers` value is `/elinks`, meaning production routes are `{host}/elinks/api/v5/...`. The user confirmed the mock should **not** adopt this prefix — it reads as gateway/ingress routing in front of the real hosted service, not part of the application's own contract, and a local Spring Boot mock has no gateway in front of it. The epic's existing bare `/api/v5/...` routes stand; this is now recorded as an explicit out-of-scope item so it isn't re-litigated later.

### 2. Impact Analysis

**Epic impact:** Epic 0.2 only, Story 0.2.1's endpoint-porting AC. Stories 0.2.2 and 0.2.3 are unaffected — neither depends on the two newly-named endpoints or the parameter detail added here.

**Artifact impact:** no PRD, architecture pattern, or UX change. No new table, repo, or dependency edge.

#### Artifact sweep

| Artifact | Change |
|---|---|
| `epic-0.2-joh-elinks-mock-api-stands-in.md` | Story 0.2.1's endpoint-porting AC rewritten to name all 7 endpoints (was 5 named/6 implied) plus required-param, pagination, and deprecated-alias detail; References line updated; one new out-of-scope bullet (`/elinks` prefix) |
| `_bmad-output/source-docs/joh-elinks-api/` | New — the real Swagger doc + `ReferenceData/*.csv|json` archived for traceability (mirrors the `joh-schema-confluence/` pattern from SCP 2026-08-25j) |
| `architecture.md` | New decision **#24** |
| `architecture/changelog.md` | New **v4.21** entry |

**Not touched:** `epics/phase-0/index.md`, `epics/index.md` (story count unchanged — 19); `sprint-status.yaml` (no story added/removed/renamed); Stories 0.2.2, 0.2.3 (no dependency on the corrected detail); `gaps.md` G8.1 (unaffected — this is mock-fidelity, not real-contract confirmation); `repository-strategy.md`, `assumptions.md` A38 (both already describe the mock at the right level of abstraction; no correction needed).

### 3. Recommended Approach

**Direct Adjustment.** Effort: **Low** — one AC block rewritten, one out-of-scope bullet, one References update, source-doc archival, decision-log + changelog entries. **Risk:** Very low — additive precision to an existing "faithful reimplementation" claim; no behavioural redesign, no story restructuring.

### 4. Detailed Change Proposals

See §1 for the full finding-by-finding rationale; the applied diff is in `epic-0.2-joh-elinks-mock-api-stands-in.md` itself.

### 5. Implementation Handoff

**Scope: Minor** — direct edit to existing epic content, no scope or dependency change.

**Responsibilities:**
- **This session:** all edits applied directly; nothing committed or pushed without being asked.

**Success criteria:** Story 0.2.1's endpoint-porting AC names every endpoint in the real `E-links API v5.0` Swagger doc that Epic 0.2's scope covers (people change-feed, people-by-id, leavers, deleted, reference-data list, reference-data-by-id, healthcheck), with required/optional query-parameter behaviour and pagination shape specified; the `/elinks` prefix question is recorded as a decided out-of-scope item, not left open; the real source material is archived under `_bmad-output/source-docs/` for future traceability; `docs/` regenerated from the updated markdown.

---

## Sprint Change Proposal — 2026-08-25l

**Status:** approved

**Trigger:** User request — "Update epic-0.2 stories with the following details: Acceptance Criteria [already present]; Tasks/Subtasks: API changes, service changes, repository changes, UI changes, tests."

**Mode:** Incremental (single artifact, iterated live with the user). **Scope classification:** **Minor** — additive guidance content within existing stories; no AC change, no FR/NFR/PRD change, no dependency-graph change.

---

### 1. Issue Summary

The literal request — add a `## Tasks / Subtasks` section to Epic 0.2's stories, broken into API/service/repository/UI/test changes — collides with a documented, previously-incident-tested contract in `architecture/delivery-operating-model.md`: **`## Tasks / Subtasks` is a BMad-reserved heading**, generated by `bmad-create-story` into the **story-packet** (`docs/stories/<id>.md` in the *target* repo) at dispatch time, and read/written by exact heading by `bmad-dev-story`. That same file records that SCP 2026-08-19b existed specifically to fix a prior incident where a hand-authored packet omitted `## Tasks / Subtasks` and broke the dev workflow — the rule against improvising that heading elsewhere is not incidental, it's load-bearing.

Epics in this repo (`_bmad-output/planning-artifacts/epics/`) are documented to carry embedded Gherkin Acceptance Criteria only; the task-level breakdown is meant to be produced later, per-story, when `bmad-create-story` actually dispatches that story using the epic's ACs as input.

**Resolution, confirmed with the user:** keep the *content* the user asked for (an API/service/repository/UI/test breakdown per story) but under a **differently-named subsection** — **"Implementation touchpoints"** — so it (a) doesn't collide with the reserved heading `bmad-dev-story` reads/writes, and (b) reads unambiguously as *dispatch guidance for `bmad-create-story`*, not as the dispatch-time artifact itself.

### 2. Impact Analysis

**Epic impact:** Epic 0.2 only, all three stories (0.2.1, 0.2.2, 0.2.3) gain a new "Implementation touchpoints" paragraph each, placed after their existing "Explicitly NOT in scope" bullets. No AC changed, no story added or renumbered.

**Artifact impact:** no PRD, architecture pattern, FR/NFR, or UX change. No new table, repo, or dependency edge. Introduces (but does not mandate elsewhere) a reusable per-story guidance pattern that future epics may adopt the same way — not applied retroactively to any other epic by this SCP.

#### Artifact sweep

| Artifact | Change |
|---|---|
| `epic-0.2-joh-elinks-mock-api-stands-in.md` | New "Implementation touchpoints" paragraph added to each of Stories 0.2.1, 0.2.2, 0.2.3 |
| `architecture.md` | New decision **#25** |
| `architecture/changelog.md` | New **v4.22** entry |

**Not touched:** `epics/phase-0/index.md`, `epics/index.md` (story count unchanged — 19); `sprint-status.yaml` (no story added/removed/renamed); every other Phase 0 epic (this SCP does not retrofit the pattern elsewhere); `epics/framework.md` (no canonical epic-content template exists there to update).

### 3. Recommended Approach

**Direct Adjustment.** Effort: **Low** — three additive paragraphs, decision-log + changelog entries. **Risk:** Very low — purely additive guidance content; the naming choice specifically avoids the one collision risk this kind of change could otherwise create.

### 4. Detailed Change Proposals

Per story, a new paragraph:

> **Implementation touchpoints** *(dispatch guidance for `bmad-create-story` — not the BMad `## Tasks / Subtasks` section itself, which `bmad-create-story` generates in the story-packet at dispatch time, per `delivery-operating-model.md`)*:
> - **API changes:** ...
> - **Service changes:** ...
> - **Repository changes:** ...
> - **UI changes:** ...
> - **Tests:** ...

- **Story 0.2.1:** names the new Spring controllers/services by class name, confirms no repository layer (stateless mock, no DB) and no UI, and describes the ported JUnit test suite.
- **Story 0.2.2:** all categories are "none" except tests (Docker Compose liveness + manual curl verification) — this story is deployment/wiring only.
- **Story 0.2.3:** flagged explicitly that its code changes land in **`ctam-reference-data`**, not `ctam-jomockapi` — config-only service change (base URL), no new repository code (existing Story 0.3.2 repositories), integration test verifying the full sync against the mock.

Full text is in the epic file itself.

### 5. Implementation Handoff

**Scope: Minor** — direct edit to existing epic content, no scope or dependency change.

**Responsibilities:**
- **This session:** all edits applied directly; nothing committed or pushed without being asked.

**Success criteria:** every one of Epic 0.2's three stories carries an "Implementation touchpoints" paragraph covering API/service/repository/UI/test changes; no story acquires a literal `## Tasks / Subtasks` heading; the naming and framing make clear this is dispatch-time guidance, not the BMad-generated artifact itself; `docs/` regenerated from the updated markdown.

---

## Sprint Change Proposal — 2026-08-25m

**Status:** approved

**Trigger:** Explicit user request — first "remove the source-docs folder completely and update," then refined to "move source-docs from this folder to `/Users/shivakumar/MOJ/docs`." The net effect implemented is the second, refined instruction: relocate, not delete.

**Mode:** Direct execution (unambiguous instruction; no judgment call to iterate on). **Scope classification:** **Minor** — file relocation + reference correction; no AC/FR/NFR/PRD change, no dependency-graph change.

---

### 1. Issue Summary

`_bmad-output/source-docs/` held two archives created earlier the same day:

- `joh-schema-confluence/` (SCP 2026-08-25j) — two distilled PDFs of internal HMCTS Confluence pages describing the JOH eLinks integration schema.
- `joh-elinks-api/` (SCP 2026-08-25k) — the real E-links API v5.0 Swagger doc, plus **real HMCTS production reference-data exports** (`eLinks_Pivotl_Production_all-data_2026-06-01_*`, 11 CSV/JSON files) supplied by the user for the mock-API contract correction.

The user asked for this folder to be taken out of the repo and relocated to `/Users/shivakumar/MOJ/docs` on their own machine — outside version control, outside `ctam-analysis` entirely — and for the resulting references to be updated accordingly.

### 2. Impact Analysis

**Epic impact:** none structural — Epic 0.1 and Epic 0.2's *content* (the schema-design pattern adopted, the mock-API contract corrections) stands independently of whether a local copy of the source material is archived inside the repo. Only the two places that claimed an in-repo archived copy needed correcting.

**Artifact impact:**

| Artifact | Change |
|---|---|
| `_bmad-output/source-docs/` | Moved out of the repo to `/Users/shivakumar/MOJ/docs/source-docs/` (both subfolders, 14 files, preserved intact — not deleted, an unrelated pre-existing PDF already in the destination folder is untouched) |
| `epic-0.1-postgres-sql-schema-design.md` | Design-rigor note's "distilled to `_bmad-output/source-docs/joh-schema-confluence/`" claim removed; a dated note added recording the relocation |
| `epic-0.2-joh-elinks-mock-api-stands-in.md` | Story 0.2.1's References line's "archived to `_bmad-output/source-docs/joh-elinks-api/`" claim corrected to note the archive existed in-repo and was later relocated out |
| `architecture.md` | Decisions #23 and #24 get a short bracketed annotation (`*(relocated out of the repo by #26)*`) — matching the existing #14/#16 precedent for a later decision affecting an earlier one — text otherwise left as immutable history; new decision **#26** |
| `architecture/changelog.md` | New **v4.23** entry; v4.20/v4.21 entries left untouched (immutable history, per this repo's convention) |

**Not touched:** `#sprint-change-proposal-2026-08-25j`, `#sprint-change-proposal-2026-08-25k` (dated historical records — immutable, per `CLAUDE.md`'s "leave dated reports and existing changelog entries as immutable history — add, don't rewrite"); the Confluence-page and Swagger-doc *citations themselves* (still valid — only the claim of an in-repo copy is removed); `sprint-status.yaml`, `epics/phase-0/index.md`, `epics/index.md` (no story/count change).

**Not done:** a git-history rewrite. The relocated files remain recoverable from the commits that added them (`a4bd168` for `joh-schema-confluence/`, `3be19ef` for `joh-elinks-api/`) unless the user separately, explicitly requests a history rewrite — not attempted here per this repo's hard rules on destructive git operations.

### 3. Recommended Approach

**Direct Adjustment.** Effort: **Low**. **Risk:** Very low — the relocation was explicitly requested; the only risk was leaving dangling in-repo references, which this SCP corrects.

### 4. Detailed Change Proposals

See §2; full diffs are in the files themselves.

### 5. Implementation Handoff

**Scope: Minor** — direct file relocation + reference correction, no scope or dependency change.

**Responsibilities:**
- **This session:** all edits applied directly; nothing committed or pushed without being asked.

**Success criteria:** `_bmad-output/source-docs/` no longer exists inside `ctam-analysis`; the 14 files are intact at `/Users/shivakumar/MOJ/docs/source-docs/`; no remaining planning-artifact text claims an in-repo archived copy exists; the underlying source citations (Confluence pages, real Swagger doc, real reference-data exports) remain accurately described as sources, just without an in-repo copy; `docs/` (the published site) regenerated from the updated markdown.

---

## Sprint Change Proposal — 2026-08-26

**Status:** approved

**Trigger:** *"consolidate the sprint-change-proposal into a single file"*.

**Mode:** Batch. **Scope classification:** **Moderate** — a documentation-architecture change (one file instead of 29, 111 cross-references rewritten) with no scope, FR/NFR, epic, or dependency impact.

### 1. Issue Summary

29 separate `sprint-change-proposal-{date}.md` files had accumulated in `_bmad-output/planning-artifacts/` since 2026-05-15. The user asked for these to be merged into a single file. Before proceeding, the scope was clarified: merge all 29 (not just a recent subset) into one chronological archive, preserving each entry's content verbatim, and update every cross-reference across the repo to point at the merged file.

This directly touches a documented convention in `CLAUDE.md` — *"Leave dated reports and existing changelog entries as immutable history — add, don't rewrite."* That rule is about not rewriting what a historical entry **says**; this change doesn't do that (every entry's substance is preserved character-for-character, only frontmatter/heading-level/file-boundary changed). But it does retire the *one-file-per-proposal* filing convention itself, which is worth being explicit about.

### 2. Impact Analysis

**What changed:**
- All 29 `sprint-change-proposal-{date}.md` files were merged, in chronological order, into **`sprint-change-proposal-log.md`** — each original file became one `##`-level section (with its own body headings demoted by one level to nest correctly), its frontmatter folded into the log's own intro/index, content otherwise untouched.
- The 29 original files were deleted.
- **111 cross-references** across **7 other files** (`architecture.md` ×34, `architecture/changelog.md` ×47, `prd.md` ×7, `prd-validation-report-2026-06-10.md` ×4, `implementation-readiness-report-2026-05-15-rev2.md` ×2, `epics/phase-0/index.md` ×1, `business-case.md` ×1) plus 15 internal cross-references within the log itself (SCPs that cited each other by filename) were rewritten from `sprint-change-proposal-{date}.md` to `sprint-change-proposal-log.md#sprint-change-proposal-{date}` (or a same-file `#sprint-change-proposal-{date}` anchor for references now living inside the log itself), with the correct relative-path depth per file.
- `scripts/python/build_html.py`'s NAV list: ~18 individual SCP entries under "Change Control & Readiness" replaced with one entry for the log.

**Not touched:** the *content* of any individual proposal — every entry reads exactly as it did in its own file, just renumbered from `#` to `##` and nested under the log's single `#`. Decision-log entries and changelog rows in `architecture.md`/`architecture/changelog.md` keep their original prose; only their SCP link targets were updated (a mechanical consequence of the files they pointed at no longer existing, not a rewrite of what those entries claim).

### 3. Recommended Approach

**Direct implementation**, per the user's explicit scope confirmation (merge all 29, verbatim, full cross-reference sweep). Effort: **Medium** (large mechanical volume — 29 files, 111 references — but low judgment risk, since it's concatenation + link-target rewriting, not content changes). **Risk:** Low-medium — the main risk was a broken link left behind; verified via a full repo grep for the old filename pattern (`sprint-change-proposal-\d{4}-\d{2}-\d{2}[a-z]?\.md`) post-migration, finding zero remaining hits outside one corrected illustrative mention in the log's own intro.

### 4. Detailed Change Proposals

See §2 for the full before/after mapping. Full diffs are in the files themselves — this SCP has no separate story/AC-level changes to itemise.

### 5. Implementation Handoff

**Scope: Moderate** — a repo-wide documentation reorganisation, no functional/epic/dependency change.

**Going forward:** `bmad-correct-course` will still write a new dated `sprint-change-proposal-{date}.md` by default on its next run — that default path lives in the installed BMad skill (gitignored, not part of this repo), not something this consolidation can change. Whether to fold each future run's output into this log (making it a living document again) or let new dated files accumulate until the next manual consolidation is a call for whoever runs `bmad-correct-course` next; this SCP doesn't decide that.

**Responsibilities:**
- **This session:** all edits above applied directly; nothing committed or pushed without being asked.

**Success criteria:** `ls sprint-change-proposal-*.md` in `planning-artifacts/` returns exactly one file; a repo-wide grep for the old per-date filename pattern outside this log returns nothing; every one of the 29 entries' content is present and unedited in the log; `docs/` regenerates cleanly with a single SCP-log page and no dangling links to the 29 deleted individual pages.
