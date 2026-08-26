---
type: 'Sprint Change Proposal'
description: 'Fixes two more cross-epic inconsistencies found by cross-checking all 5 Phase 0 epics against architecture/data-tables.md and requirements-inventory.mds AR list directly: understated ctam_joh_identities grant breadth, and a stale AR52 citation for the WireMock/stub testing convention (no AR previously documented it).'
resource: 'sprint-change-proposal-2026-08-25i.html'
tags: [ctam-pathfinder, sprint-change-proposal]
timestamp: '2026-08-25'
title: 'Sprint Change Proposal — 2026-08-25i'
status: 'approved'
---

# Sprint Change Proposal — 2026-08-25i

**Trigger:** *"review all epics in phase-0"* — a second review pass, following SCP 2026-08-25h's fixes from the first pass.

**Mode:** Batch. **Scope classification:** **Minor** — documentation/citation fixes within existing epics; no scope, FR/NFR, or dependency change.

---

## 1. Issue Summary

A second full review of all 5 Phase 0 epics was requested. Rather than re-checking the same epic-to-epic cross-references already fixed in SCP 2026-08-25h, this pass cross-checked each epic's claims against the two documents epics are supposed to be *derived from*: `architecture/data-tables.md` (the canonical table inventory) and `requirements-inventory.md`'s AR list (the canonical architecture-rule numbering). That angle surfaced two more issues neither epic-to-epic comparison nor the first pass had caught.

## 2. Impact Analysis

### Finding 6 — `ctam_joh_identities` grant breadth understated

`data-tables.md` documents `ctam_joh_identities` explicitly: *"SELECT-granted to every domain service"* — listing Authorisation, JOH, Absence, Booking, Sitting, Itinerary, and MI Feed as key consumers, because it's the JOH identity spine every domain table keys off of (`joh_id` → `ctam_joh_identities.id`). Story 0.3.2's grants AC (which SCP 2026-08-25h had just extended to also *create* this table) only said SELECT grants exist "for `ctam_joh` (schema composition, Epic 0.1) and placeholder roles for future services" — correct for the `jo_*` tables, but understating `ctam_joh_identities`'s actual grant scope, which isn't `ctam_joh`-specific at all.

**Fix:** Story 0.3.2's grants AC now states explicitly that `ctam_joh_identities` is SELECT-granted to *every* current and placeholder domain service DB role, quoting `data-tables.md`'s own language, and the fitness-function AC now verifies grant breadth as well as the tier-(a) write-protection rule.

### Finding 7 — AR52 mis-cited for the WireMock/stub testing convention

Three places cite "AR52" for `ctam-reference-data`'s CI-only WireMock/stub eLinks API pattern: Epic 0.3's Story 0.3.3 AC, and Epic 0.2's Story 0.2.3 AC plus its References line. But AR52 in `requirements-inventory.md` is actually: *"User and authorisation records... are strictly CTAM-internal, populated by programme-management / operational mechanisms..."* — completely unrelated to WireMock or eLinks testing. Searching the whole `requirements-inventory.md` for "WireMock" turned up nothing — no architecture rule anywhere actually documents this testing convention, despite three stories treating it as an established, numbered rule.

**Fix:** Added **AR54** to `requirements-inventory.md`, describing the WireMock/stub convention and its relationship to Epic 0.2's locally-run mock (complementary — fast hermetic CI checks vs. a realistic local network target, not a replacement of one by the other). Corrected all three stale "AR52" citations to "AR54," and completed Story 0.3.3's References line, which cited AR46/AR48/AR49 but had omitted AR54/AR52 entirely even though its own AC body referenced it.

### Artifact sweep

| Artifact | Change |
|---|---|
| `epics/requirements-inventory.md` | New **AR54** added (CI-only WireMock/stub eLinks API convention) |
| `epic-0.3-joh-reference-data-etl-process.md` | Story 0.3.2's grants AC extended for `ctam_joh_identities` breadth; Story 0.3.3's AR52 → AR54 citation fixed; Story 0.3.3's References line completed with AR54 |
| `epic-0.2-joh-elinks-mock-api-stands-in.md` | Story 0.2.3's AR52 → AR54 citation fixed (AC body + References line) |
| `architecture.md` | New decision **#22** |
| `architecture/changelog.md` | New **v4.19** entry |

**Not touched:** `epic-0.0`, `epic-0.1`, `epic-0.4` (no findings against them this pass); `sprint-status.yaml` (no story added/removed/renamed); `fr-coverage-map.md`, `gaps.md`, `assumptions.md` (checked, no discrepancy found this pass); dated historical SCPs/changelog entries (immutable record).

## 3. Recommended Approach

**Direct implementation.** Effort: **Low** — two targeted fixes, one new AR entry, four citation corrections. **Risk:** Very low — no structural change; both fixes make documentation match what other parts of the same epics (and `data-tables.md`) already assumed was true.

## 4. Detailed Change Proposals

See §2 for the full before/after mapping. Full diffs are in the files themselves.

## 5. Implementation Handoff

**Scope: Minor** — documentation/citation corrections within the existing plan, no scope or dependency change.

**Responsibilities:**
- **This session:** all edits above applied directly; nothing committed without being asked.

**Success criteria:** `ctam_joh_identities`'s documented grant scope in Story 0.3.2 matches `data-tables.md`'s "every domain service" note; every citation of the WireMock/stub convention across Epic 0.2 and Epic 0.3 points at a real, existing AR (AR54); Story 0.3.3's References line lists every AR its own ACs actually cite.
