---
type: 'Epic'
description: 'Since the MRD teams weekly workbook has no real reference example available (unlike the JOH data source, covered by the sibling epic 0.0), this work proposes a reasoned, clearly-provisional shape for it - grounded only in what the programme already knows it needs from MRD - and builds a realistic sample workbook against that proposal. This gives the MRD data-loading work something concrete to test against now, while flagging clearly that the real shape still needs confirming with the MRD team before go-live.'
resource: 'epics/phase-0/epic-0.1-mrd-reference-data-mock.html'
tags: [ctam-pathfinder, epics, phase-0]
timestamp: '2026-08-21'
parent: 'epics/phase-0/index.md'
epic: 0.1
title: 'A provisional MRD workbook shape is proposed and mocked for CI-only integration testing'
storyCount: 3
repo: ctam-reference-data
depends_on: [epic-1.3]                      # needs the mrd_specialisms database table to exist first, so this proposal can be checked against it
---

# Epic 0.1: A provisional MRD workbook shape is proposed and mocked for CI-only integration testing

> This is the sibling of Epic 0.0, extending the same de-risking approach to MRD. It is materially weaker ground than Epic 0.0: there, a real reference example of the JOH data source existed to confirm against. Here, no such example exists yet — this work proposes a reasoned best guess, not a confirmed fact, and says so throughout.

**Business Goal:** The nightly-equivalent MRD data load is one of only two ways judicial reference data reaches CTAM Pathfinder, and it currently has no test target at all — the shape of the real weekly workbook has never been confirmed with the MRD team. Waiting until that confirmation arrives to write any validation, error-handling, or automated-test code would leave the MRD data-loading work untested and undemonstrated for an unknown length of time. This work breaks that stall: it proposes the most reasonable working assumption available today, builds a realistic practice workbook against it, and makes the assumption itself impossible to miss — so the real MRD team conversation happens sooner, not later, and nothing quietly ships on an unconfirmed guess.

**What this covers:** Three things: **(1)** proposing a specific, concrete shape for the MRD workbook — what it contains and how it's laid out — based only on what the programme already knows it needs from MRD, and writing that proposal down clearly as an assumption, not a fact; **(2)** building a realistic practice copy of a workbook in that shape, at a believable scale, for automated testing; and **(3)** deliberately including realistic mistakes in some of the practice data — a missing value, a reference to something that doesn't exist — so the checks the data-loading work needs to make can be proven to actually catch them.

**Outcome:** The team building the MRD data-loading work gets a realistic practice workbook to test against today, instead of waiting on a real example that doesn't yet exist. The practice workbook is clearly labelled as a working assumption, and the open question it's standing in for — what the real workbook actually looks like — stays visibly tracked until the MRD team confirms or corrects it.

**Hosting:** This practice workbook lives entirely inside the testing setup of the service that will do the real data load — it is not a new system, not something anyone deploys, and nobody outside the automated test suite ever sees it. It exists purely so that automated checks have something realistic to run against, exactly like its sibling epic's practice copy of the JOH data source.

**What's included:**
- A proposed shape for the workbook: one sheet holding **JOH Specialisms** — supplementary judicial attributes not available from the JOH data source at all — with a row per specialism per judge, referencing the judge by their unique reference number, the jurisdiction it applies to, and a description of the specialism itself, plus a date it took effect
- A realistic practice workbook built to that shape, with enough rows to be a believable stand-in for the real thing rather than two or three hand-picked examples
- Deliberately broken practice rows, on top of the good ones: a row missing a required value; a row referencing a judge or jurisdiction that doesn't exist anywhere else in the practice data; a second copy of an already-processed file, to prove re-processing doesn't create duplicates
- **The proposal itself, written down as an open question, not a confirmed fact:** this shape is the programme's best guess, built from what's already documented about what MRD needs to supply — it has not been checked against anything the MRD team has actually produced, and is tracked as an open item until they confirm or correct it

**Why this matters:** Like its sibling epic, this isn't tied to a single customer-facing feature — it unblocks and de-risks the MRD data-loading work everyone else's supplementary judicial data will depend on, without forcing that work to wait on an external confirmation that hasn't happened yet.

**Proposed workbook shape (working assumption, not confirmed):**

| Column | Purpose |
|---|---|
| Judge reference number | Identifies which judge the specialism belongs to |
| Jurisdiction | Which jurisdiction the specialism applies to |
| Specialism code | A short, controlled code identifying the specialism |
| Specialism description | The plain-language name of the specialism |
| Effective from | The date the specialism became applicable |

**Explicitly out of scope:** Confirming this shape with the MRD team — that conversation is a separate, real-world activity this work exists to prompt, not to complete. Any changes to the actual database design used elsewhere in the programme. Turning this practice copy into a real, deployed service — it exists purely for automated testing. The equivalent work already done for the JOH data source (that's the sibling epic). Building the real data-loading logic itself — that's separate work this epic exists to support, not replace.

---

## Story 0.1.1: A provisional MRD workbook shape is proposed and documented

As the **engineer building the MRD data-loading work** (and everyone who maintains it afterwards),
I want a specific, concrete proposal for what the MRD workbook contains and how it's laid out, clearly labelled as an assumption rather than a confirmed fact,
So that **there is something concrete to design and test against today, instead of an open-ended unknown that blocks progress indefinitely**.

**Acceptance Criteria:**

**Given** the database table for JOH Specialisms already exists,
**When** the engineer proposes a workbook shape for it,
**Then** the proposal specifies a single sheet with one row per specialism per judge, and names every column needed to populate that table — a judge reference, a jurisdiction, a specialism code and description, and an effective date,
**And** the proposal is written down alongside a clear statement that it is a working assumption, not a confirmed fact, and where the open question is being tracked.

**Given** the proposed shape,
**When** it's reviewed against what the programme already knows it needs from MRD,
**Then** every column in the proposal traces back to something the programme has already documented needing, rather than being invented from nothing.

**Explicitly not in scope:**
- Building the practice workbook itself (covered in the next story)
- Confirming the proposal with the MRD team — a separate, real-world activity

---

## Story 0.1.2: A realistic sample workbook is built for CI at a believable scale

As the **engineer building the MRD data-loading work**,
I want a practice copy of a workbook in the proposed shape, populated at a believable scale rather than a handful of hand-picked rows,
So that **the data-loading work's behaviour can be checked against something that resembles the real thing, not an unrealistically small or convenient test case**.

**Acceptance Criteria:**

**Given** the proposed workbook shape from the previous story,
**When** the engineer builds the practice workbook for automated testing,
**Then** it contains enough rows to be a believable stand-in for a real weekly drop — spanning multiple judges, multiple jurisdictions, and multiple specialism codes — not just two or three examples,
**And** every reference in the practice data (a judge, a jurisdiction) resolves cleanly against the practice data used elsewhere in automated testing, so the good-case rows are internally consistent.

**Given** the practice workbook is used in automated testing,
**When** it's read by the data-loading logic,
**Then** it behaves as a normal, well-formed input file would.

**Explicitly not in scope:**
- Deliberately broken or invalid rows (covered in the next story)
- The proposed shape itself (covered in the previous story)

---

## Story 0.1.3: Deliberately broken practice data proves the validation and rejection logic actually works

As the **engineer building the MRD data-loading work**,
I want the practice workbook to also include realistic mistakes — a missing value, an unresolvable reference, a duplicate drop of the same file — alongside the good data,
So that **the checks the data-loading work needs to make are proven to actually catch problems, rather than only ever being exercised against data that's already correct**.

**Acceptance Criteria:**

**Given** the good-case practice workbook from the previous story,
**When** a second version is prepared for validation testing,
**Then** it includes at least one row missing a value the data-loading work requires, and at least one row referencing a judge or jurisdiction that doesn't exist anywhere in the practice data,
**And** each broken row is clearly documented as intentional, alongside the specific failure it's meant to trigger.

**Given** the same good-case workbook is provided a second time,
**When** it's used to test re-processing behaviour,
**Then** it proves whether processing the same file twice produces duplicate results or correctly recognises it as already handled.

**Explicitly not in scope:**
- The good-case workbook itself (covered in the previous story)
- Fixing or changing the actual data-loading logic — this work only supplies the practice data it's tested against
