---
type: 'Architecture Shard'
description: 'As-is catalogue of the 17 JI (Oracle APEX) application access types across four groups, plus 1 configuration entry (Payment Authoriser) that is not an application access type. Feb 2026 snapshot.'
resource: 'architecture/tobe/user-types.html'
tags: [as-is, judicial-information, access-types]
timestamp: '2026-05-12'
parent: ../architecture.md
title: JI User Types & Access Catalogue (as-is)
last_updated: 2026-09-14
sources:
  - ../../../docs/architecture/asis/JI user types - 2.xlsx (authoritative as-is catalogue, Feb 2026 snapshot)
---

# JI User Types & Access Catalogue (as-is)

> This page catalogues the **as-is** user types of the Judicial Information (JI) application (Oracle APEX) as operated by HMCTS. The source is `docs/architecture/asis/JI user types - 2.xlsx` (Feb 2026 snapshot), which is authoritative for the role taxonomy and the active-user counts. It describes the current estate only; it does not define the target design.
>
> **Baseline capability for every access type:** access to standard reports. The capability lists below add to this baseline rather than repeat it.

## At a glance

JI has **17 application access types** across four groups, plus **1 configuration entry** (Payment Authoriser) that is not an application access type. The as-is catalogue records **2,818 active users** as of Feb 2026.

| Group | Access types | Active users (Feb 2026) |
|---|---|---|
| [Court](#court-access-types) | 5 | 2,196 |
| [Regional](#regional-access-types) | 5 | 195 |
| [Judicial](#judicial-access-types) | 6 | 386 |
| [Finance](#finance-access-types) | 1 | 39 |
| **Application access types — total** | **17** | **2,816** |
| Configuration: [Payment Authoriser distribution list](#payment-authoriser-configuration-not-an-access-type) | — | 2 |
| **Catalogue total** | — | **2,818** |

## Sitting & booking lifecycle (Confirm → Verify → Re-open)

Several access types are defined by their position in the sittings/bookings release lifecycle. Recording this once here so the per-role capability lists can refer to it.

1. **Confirm** — A Court user (Full Access, Enhanced CJ, Limited) records that yesterday's sitting / booking took place, with actual work type and any AM/PM split. Performed daily.
2. **Verify** — A Verifier (Court or Regional) signs off batches of confirmed sittings / bookings, typically monthly. Verification locks the records and releases them to be reported on.
3. **Re-open** — Privileged correction action against a verified record. Granted to **Regional (Admin)** only. The re-opener must be different from the original confirmer; a justification is captured and the action is audited.

A Verifier **cannot** confirm sittings or bookings — confirmation and verification are separated by design (segregation of duties).

## Court access types

5 access types, 2,196 active users. Scope is the **office(s)** the user is assigned to.

### Court (Full Access) — 1,442 active users

Standard access level for users in the courts.

**Capabilities:**

1. Full access (view, create, maintain) to **District Judge** judge profiles only.
2. Confirm sittings for **all judge types** at assigned location(s).
3. Confirm bookings for **all judge types** at assigned location(s).
4. Request absences for judges at assigned location(s) — Regional team approval required.
5. Request vacancies for judges at assigned location(s) — Regional team approval required.

> Q2 resolution (2026-05-12): the xlsx description is not contradictory. Profile-maintenance access (full edit) is limited to DJ; sittings/bookings *confirmation* is location-scoped and works against all judge types. These are two distinct capabilities.

### Court (Enhanced CJ) — 224 active users

Enhanced access for court users in certain regions where Circuit Judge cover is required.

**Capabilities:**

1. All capabilities of Court (Full Access).
2. Additionally: full access (view, create, maintain) to **Circuit Judge** profiles.

### Court (Limited) — 132 active users

Limited access for court users. Same daily operational footprint as Full Access but without the judge-profile maintenance privilege.

**Capabilities:**

1. Confirm sittings for all judge types at assigned location(s).
2. Confirm bookings for all judge types at assigned location(s).
3. Request absences for judges at assigned location(s) — Regional team approval required.
4. Request vacancies for judges at assigned location(s) — Regional team approval required.

> Q3 resolution (2026-05-12) — *inferred from the xlsx description "as per Full Access but doesn't include full access to any judge types"*: the **only material difference** between Court (Limited) and Court (Full Access) is that Limited cannot maintain District Judge profiles. Confirmation of sittings/bookings, absence and vacancy requests are unchanged. Flagged for confirmation with JI-experienced users.

### Court (Read-only) — 27 active users

Read-only access for court users.

**Capabilities:**

1. View the same data set Court (Full Access) can view, with no write actions (no profile maintenance, no confirm, no requests).

### Court (Verifier) — 371 active users

Verifier access for court users. Performs step 2 of the sittings/bookings release lifecycle.

**Capabilities:**

1. **Cannot** confirm sittings or bookings.
2. Verify sittings that have been confirmed by another user (typically monthly).
3. Verify bookings that have been confirmed by another user.
4. View the same data set Court (Full Access) can view.

> Verification releases verified records for reporting. See [Sitting & booking lifecycle](#sitting--booking-lifecycle-confirm--verify--re-open).

## Regional access types

5 access types, 195 active users. Scope is the **Region** the user is assigned to, optionally narrowed by Area.

### Regional (Admin) — 75 active users

Regional user with elevated administrative powers.

**Capabilities:**

1. All capabilities of Regional (Full Access).
2. Send user-creation requests to the Advice Point (operational process to create new JI users for the region).
3. Re-open verified sittings / bookings (privileged action). Justification captured, must differ from original confirmer, audited.

> Q11 from the xlsx (whether Regional Admin should create users directly without an external operational process) remains an open question against the as-is catalogue.

### Regional (Full Access) — 68 active users

Standard access level for regional users.

**Capabilities:**

1. Full access (view, create, maintain) to records for **all judge types** in the region.
2. Create bookings for fee-paid judges.
3. Amend bookings for fee-paid judges.
4. Create absences for judges in the region.
5. Approve absences requested by Court users.
6. Create vacancies in the region.
7. Approve vacancies (including those auto-created from approved absences).
8. **Cannot** confirm sittings or bookings — confirmation is a Court-level function only.

### Regional (No Fees) — 14 active users

Restricted access for Regional users who must not transact on fee-paid bookings.

**Capabilities:**

1. All capabilities of Regional (Full Access) **except**:
2. Cannot create bookings for fee-paid judges.
3. Cannot amend bookings for fee-paid judges.

### Regional (Read-only) — 23 active users

Read-only access for Regional users.

**Capabilities:**

1. View the same data set Regional (Full Access) can view, with no write actions.

### Regional (Verifier) — 15 active users

Verifier access at Regional scope.

**Capabilities:**

1. All capabilities of Regional (Full Access).
2. Verify confirmed sittings for all courts in the region.
3. Verify confirmed bookings for all courts in the region.

> Q12 from the xlsx (national-level access): no national-level access type exists in the as-is catalogue except Finance. All other roles are scoped by Region/Area or by judge linkage.

## Judicial access types

6 access types, 386 active users. Scope varies — see each entry.

### Judge — 273 active users

Standard access level for a judge.

**Scope:** the judge's own record only (R2 — no case-level data, no access to other judges' data).

**Capabilities:**

1. View own record (profile, working pattern, tickets).
2. View own itinerary and forward look.
3. Request absences against own record where permitted — Regional team confirmation may be required.

### Judge's Clerk — 2 active users

Clerk to a salaried judge, acting on the judge's behalf.

**Scope:** the linked judge(s) the clerk supports.

**Capabilities:**

1. Same capability surface as Judge, but exercised on behalf of the linked judge(s).

> Q7 from the xlsx (whether Judge's Clerk differs from Judge): the as-is catalogue records them as functionally identical from an access-control standpoint — the only distinction is *which* judge's record(s) the principal is linked to. The separation exists for audit clarity (the Clerk acts on someone else's behalf).

### Presiding Judge — 2 active users

Leadership judge with oversight of a group of judges (typically a Circuit's salaried judges).

**Scope:** all judges who fall under the Presiding Judge's leadership.

**Capabilities:**

1. Same capability surface as Judge, exercised across all judges under their leadership.

> Q9 from the xlsx (why so few users): low headcount is structurally expected — there are very few presiding judges nationally.

### Presiding Judge's Clerk — 0 active users

Clerk to a Presiding Judge.

**Scope:** the linked Presiding Judge's leadership group.

**Capabilities:**

1. Same capability surface as Presiding Judge, exercised on behalf of the linked Presiding Judge.

> **No active users in the as-is catalogue (Feb 2026).** The access type exists in JI (Q6 confirmed) and is provisioned but currently unused.

### Judge Itin View Only — 107 active users

CTSC (Courts and Tribunals Service Centre) operational users who need to know whether and where a judge is working.

**Scope:** national, but with significant data restrictions (see below).

**Capabilities:**

1. View judges' itineraries only — no profile, working pattern, absence, vacancy, booking, or sitting detail.
2. Massively cut-down information surface. Used operationally to identify (a) whether a judge is working on a given date and (b) where they are sitting.

> Q8 from the xlsx (exact contents of "very limited information"): the precise field set is not specified in the as-is catalogue. Recorded as an open question against the as-is catalogue.

### Judicial College — 2 active users

Users within the Judicial College (training body for judges).

**Scope:** national, read-only.

**Capabilities:**

1. View a cut-down version of Court itineraries.
2. View Absences associated with those itineraries.
3. View Vacancies associated with those itineraries.
4. View Bookings associated with those itineraries.
5. **All views are read-only** — no write actions of any kind.

> Q5 from the xlsx (exact contents of the cut-down Court itinerary view): not specified in the as-is catalogue. Recorded as an open question.

## Finance access types

1 access type, 39 active users.

### Finance — 39 active users

Users within HMCTS finance who generate JFEPS payment schedules.

**Scope:** **National** — no Region/Area scoping. A Finance user can produce payment schedules covering all Regions/Areas.

**Capabilities:**

1. Produce payment schedules — JFEPS-compatible Excel — across all courts and circuits nationally.
2. Each generated schedule is automatically emailed to a configured Payment Authoriser (see [Payment Authoriser configuration](#payment-authoriser-configuration-not-an-access-type)).

> Q4 from the xlsx (scope of payment schedules): confirmed national — a Finance user can produce schedules across all areas (2026-05-12).

## Payment Authoriser (configuration, not an access type)

The Payment Authoriser is **not a JI application access type**. It is a **configuration entry** — the addressable identity (name + email) to whom Finance-generated JFEPS payment schedules are emailed for forwarding to Liberata.

1. The Payment Authoriser is held as configuration in JI, not as an authenticated user.
2. Finance users select a Payment Authoriser when generating a payment schedule; JI emails the JFEPS Excel to that recipient.
3. The recipient does **not** log into JI. They receive the JFEPS Excel by email and forward it to Liberata out-of-system.
4. 2 individuals are recorded against this entry in the as-is catalogue (Feb 2026).

## Source

- `docs/architecture/asis/JI user types - 2.xlsx` — authoritative as-is catalogue (Feb 2026 snapshot)
