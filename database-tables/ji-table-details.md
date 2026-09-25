# JI as-is database — table purpose and rationale

**Source:** walkthrough of the JI (Judicial Information, Oracle APEX / "OPT") schema with its creator and sole remaining second-line maintainer, Martin Pewsey, recorded in `JI_tables_discussion.vtt`. Interviewer: Ramnish Kalsi.
**Companion artefacts:** the schema model `ji_schema.json`, the D2/PNG cluster diagrams and `ji_schema_companion.md` under `docs/architecture/asis/database/`. The clusters used below are the same six clusters as those diagrams.

This document records **what the creator said each table is for and why it exists**. Where the transcript says nothing about a table, that is stated explicitly rather than inferred. Where the transcript is ambiguous, or appears to disagree with the DDL, the discrepancy is noted. Direct claims are Martin's unless attributed otherwise.

---

## 1. Design principles that recur across the schema

These came up repeatedly and explain the shape of most of the tables.

1. **Header / detail (one row per period, one row per day).** Bookings, absences, vacancies and work patterns all follow the same pattern: a *header* row covering the whole period (a day, a week, a fortnight, a month, a year) and a *detail* row for every individual day inside it. The stated reason is that a single day can be changed or cancelled **without cancelling and re-creating the whole period** (e.g. a court cancels one day of a two-week booking). Martin likened this to the `TBL_JUDGES_MASTER` / `TBL_JUDGES` split.
2. **Never delete, mark as cancelled.** Rows in the planning tables are never physically deleted. Cancelled days are flagged (`CANCELLED`, `CANCELLED_BY`, `CANCELLED_DATE` etc.) so a full record is kept.
3. **Reference / LOV tables carry an `IN_USE` flag.** The many small "types / cats / reasons" tables are standing data used to populate lists of values (LOVs) in the APEX screens. Rows are occasionally added or removed, but the normal way to withdraw a value is to set `IN_USE` off rather than delete it.
4. **Overnight routines do the heavy lifting.** A nightly batch updates judge roles based on dates (retiring judges at their retirement date, actioning promotions at their promotion date), recalculates annual-leave figures, and pushes read-only copies of tables to the BI server. Martin could not enumerate everything the routines do without reading the code.
5. **JI began as a data-collection tool.** It was originally built to *get data in*; user-facing scheduling functionality was added because users would not have been happy just entering information. Several tables (booking types, the stats tables) exist primarily to serve MI and Power BI rather than the scheduling workflow.
6. **Shared OPT tables are outside this schema.** Courts, areas (now called *clusters*) and regions live in tables shared across all OPT applications (`TABLE_COURTS` → `TABLE_AREAS` → `TABLE_REGIONS`), together with shared PL/SQL packages of up to ~20,000 lines each. These were **not** in the DDL extract; identifying which shared objects JI actually uses is Martin's outstanding task before the GitHub repo is shared.
7. **Confidentiality of future information.** Promotions, retirements and next-year working patterns are known to the RSU before the judges concerned are told. Provisional judge records and the restricted-itinerary-users table both exist to let planners work ahead while keeping that information hidden from ordinary users.
8. **Naming inconsistency is historical.** Two developers built different parts of the schema before naming conventions were agreed, which is why `TBL_JI_VACANCY_GROUPS` / `TBL_JI_VACANCIES` does not follow the `_DETAIL` pattern used elsewhere. Martin said he still regularly forgets `VACANCY_GROUPS` exists when investigating problems, and agreed the `X` / `X_DETAIL` form is the more intuitive one.

---

## 2. Judges Profile & Reference cluster

### `TBL_JUDGES_MASTER` — one row per **person**
The person-level record for a judge: names, titles, contact details, payroll number, current judge type. A person has exactly one row here regardless of how many roles they hold or have held. It is the anchor that lets JI "see the whole record of that judge's career".

### `TBL_JUDGES` — one row per **role**
Links to `TBL_JUDGES_MASTER` by `JUDGES_MASTER_ID`; a person can have many rows. A row represents a role, identified by `JUDGE_CODE`, and can be:
- a role that is still active;
- a role the judge has since been **promoted from**;
- a **provisional** role, set up in advance when the RSU has been notified that a judge is about to be given a role (see promotion, below);
- a **sitting-in-retirement, fee-paid** role that goes live once the salaried roles are marked as retired by the overnight routine.

Example given: a judge sitting as a District Judge in one circuit and a Deputy District Judge in another has one `JUDGES_MASTER` row and two `TBL_JUDGES` rows. Status changes (retired, promoted, etc.) are applied by the overnight routines based on the dates held on the record.

### `TBL_JUDGES_USER_LINKS` — judge self-service login
Only populated when a judge has asked for a JI login. Links the judge's application `USER_ID` to their `JUDGES_MASTER_ID` (Martin first said judge code, then corrected himself to master ID) so that the judge can **only see their own data** on screen. Purely a login/authorisation mapping.

### `TBL_JUDGE_TYPES` — reference data
Metadata listing every judge type and its ID, from District Judge / Deputy District Judge / District Judge (Magistrates' Courts) through Circuit Judge "all the way up to … lords" holding high-ranking roles. The transcript does not discuss the individual flag columns (`COUNTY`, `CROWN`, `RCJ`, `MAGS`, `FWR`, `SALARIED`, `PROFILE_JUDGE_TYPE_ID`, `MINIMUM`).

### `TBL_JUDGE_STATUSES` — reference data
Metadata for a role's current status. Examples given: active, promoted, retired, deleted, deceased. Martin noted there are "quite a number" of statuses.

### `TBL_JUDGE_CIRCUITS` — reference data (and a terminology trap)
HMCTS organises the country into six or seven **regions**, but the judiciary still uses **circuits**, which is what regions were called 15+ years ago. Circuits **do not line up with regions**, so JI must hold the list of circuits separately to know which of the two is being referred to. A judge's circuit denotes the area in which they are employed (distinct from the *Circuit Judge* rank).

### `TBL_LEADERSHIP_JUDGE_TYPES` — reference data
Some judges have a degree of control over other judges. This metadata table lists those leadership types, e.g. Regional Family Judge, Regional Civil Judge, Regional Crime Judge.

### `TBL_JUDGE_TYPE_PROMOTION` — valid promotion paths
Holds the **promotion paths available** from each judge type to another (`CURRENT_JUDGE_TYPE_ID` → `PROMOTED_JUDGE_TYPE_ID`). It is used by the **help-desk application** rather than the scheduling screens: when a help-desk user opens a judge's record and clicks *Promote*, this table restricts the options offered to valid promotions. Its purpose is to save users time and prevent invalid promotions.

**How promotion works end to end (as described):**
- A judge is promoted, e.g. District Judge → Circuit Judge, and the RSU is notified.
- Some regions notify **before** names are published. In that case a *new* `JUDGES_MASTER` row and a *new* `TBL_JUDGES` row are created as a **placeholder** so users can set up working patterns and allocate work to the judge in the new role without revealing who they are. Once the promotion is announced, the placeholder `TBL_JUDGES` record is **merged** into the judge's original `JUDGES_MASTER` record so the full career is preserved.
- Other regions notify only after publication; the help-desk (Vicky's team) then opens the existing judge record and uses the *Promote* button.
- Actioning of promotion and retirement dates happens in the overnight routines.
- Martin confirmed there is never a contradictory state where the same judge has both an active role row and an outstanding promotion-path entry that would conflict.

---

## 3. Working Patterns, Tickets & Stats cluster

### `TBL_JUDGES_WORK_PATTERNS` (header) and `TBL_JUDGES_WP_DETAIL` (detail)
A judge's standing work pattern. Patterns can be daily, weekly, two-weekly, three-weekly or monthly. Following the header/detail principle there is one row for the pattern and one row per day within the pattern cycle in the detail table (the detail's `WEEK_SORT` / `DAY_SORT` columns position the day in the cycle). Working patterns for the next financial year are set up in advance and must be kept confidential until each judge has been told (see `TBL_JI_RESTR_ITIN_USERS`).

### `TBL_JUDGES_JURIS_SPLIT` — jurisdictional split
Records how a judge's time is divided between jurisdictions, e.g. "40% family, 30% civil". Martin's recollection was that it is held **per judge role** (linked via judge code), and that it has a start and end date so the split can change at any point in the year. *(The DDL links it to `JUDGES_WORK_PATTERN_ID` rather than directly to a judge code, so the split is scoped by work pattern; Martin was recalling from memory and did not check.)*

### `TBL_JUDGE_JURIS` — reference data
Reference list of jurisdictions. Martin checked it live: it contains just **three rows — Crime, Civil and Family**.

### `TBL_JUDGE_TICKET_TYPES` — reference data
Lists all the ticket types (authorisations) a judge can hold; "there's quite a lot of them".

### `TBL_JUDGES_TICKETS` — tickets actually held
Links ticket types to a judge and records which tickets the judge holds, with start/end dates. Martin's assessment of tickets in the as-is:
- Tickets are **not critical** in JI as it stands.
- Tickets are **not linked to booking or work types**. This was always the plan but was never implemented because of concern that a judge might have to sit on something they were technically not ticketed for.
- Some regions prefer to maintain tickets themselves, but tickets should be available from the Judicial Office system.

### `TBL_JUDGE_COURTS_LINK` — sharing agreements (which courts a judge may sit at)
Records the courts a judge can sit at, and is **mostly used for shared judges**. A judge can be shared between courts or between regions. The sharing agreement is set up inside JI: the user picks a scope type (courts, areas/clusters, or regions) in a first select list, then the specific item(s) in a second list. On saving, the system **expands the scope to one row per court** — sharing a South East judge with the North West region inserts a row for every court in the North West. The user thinks in terms of "anyone in region X can access this judge"; the system only ever stores court-level rows.

The court → area → region expansion is done in a PL/SQL package using the **shared OPT tables** `TABLE_COURTS` (all courts and tribunals, with `AREA_ID`), `TABLE_AREAS` (areas, now called clusters, each with a `REGION_ID`) and `TABLE_REGIONS`. Those tables are not in this schema extract. JI otherwise works almost entirely at **court level** rather than region level "because it's simpler that way"; each user's record carries a location set listing the courts they can access.

Martin identified sharing agreements as **the one thing definitely not available from the Judicial Office (JOH) data**, because they are a local business-process construct.

### `TBL_JUDGE_FEE_RATES` — fee rates for fee-paid judges
One row per (fee-paid) judge type per time period, normally a financial year, holding the daily fee. Fees rise every year, so a full history of rates is kept. **Martin populates this manually** once a year when Finance or the Judicial Office notify him of the new rates; he has never fully trusted end users with it. He doubted fee rates would be in JOH data because they are finance data, but expected they could be sourced from JFEPS (the judicial fee payment system). The booking type does *not* hold the fee; the rate is looked up here by judge type and date.

### `TBL_JUDGES_ANNUAL_LEAVE` — cached leave calculation
One row per `JUDGES_MASTER_ID` per leave year, **salaried judges only**. Populated by the overnight routines, which calculate the values needed for the leave balance (brought forward, carried forward, sitting commitment, working days in year, days in lieu, balance). It exists **to speed things up** — a precomputed cache — and is also updated in-line by the bookings/sittings change code as users make changes.

Context Martin gave on why this is awkward:
- Judges do not have an annual-leave entitlement in the normal sense; their contract is to sit a set number of days per year, so the "leave" figure is really *non-sitting days* and differs slightly every year. It is called annual leave because that is what everyone calls it.
- Leave can be carried forward, including **negative** carry-forward with the presiding judge's permission.
- JI has in practice become the system of record for judges' leave balances even though it was never intended to be. Three or four years ago roughly 90% of second-line queries were judges disputing their balance; that has since largely stopped.

### `TBL_JUDGES_MONTHLY_STATS` — MI feed, per person per month
New within the last year. One row per `JUDGES_MASTER_ID` per month recording how many days the judge sat, broken down by jurisdiction and by type of sitting, **and including absences**. It is per *person*, not per role: it does not matter whether the days were sat as a DJ or a DDJ. Used to feed a Power BI dashboard.

### `TBL_JUDGES_BOOKING_STATS` — MI feed, per role
Similar in spirit but for **bookings only** (excludes absences) and held **per judge role**: a judge who is both a DJ and a Recorder has two rows. Also feeds a Power BI dashboard. Martin described the two stats tables as "probably the key tables as far as we're concerned".

**How the stats reach Power BI:** a read-only schema on the live server (`OPTLIVE_RO`) mirrors a number of tables; an overnight routine copies their current content across a database link to the BI server, from where it is pulled into Power BI. Four servers exist in total (JI dev with dev/training/test schemas, BI dev, Ops Live, BI Live) linked by database links. `OPTLIVE_RO` is also used to give new staff read-only access and for dashboard teams to look at data. This is all within the OPT estate, not the enterprise Power BI.

---

## 4. Absence & Cover Workflow cluster

"ABS_OB" stands for **Absences and Official Business**.

### `TBL_JI_ABS_OB` (header) and `TBL_JI_ABS_OB_DETAIL` (detail)
Works exactly like bookings/booking detail. An absence can be a day, a week or a year; one row covers the whole absence in the header and there is one row per day in the detail. The reason is the same: a single day can be changed without cancelling the whole absence. For salaried judges an absence also causes the corresponding `TBL_JI_PLANNED_SITTINGS` rows to be marked cancelled.

Other absence context from the conversation:
- Only **sickness** absences are currently received from the Judicial Office HR system (JHR); it holds other absences but does not expose them through the eLinks API. Leave is therefore entered and monitored in JI.
- **Judicial College** training is a distinct absence type. The College has its own system separate from the Judicial Office. A judge may attend as a *delegate* or as the *trainer*, and both must be recorded (the Judicial Office may want to know a judge is a trainer, but not how many training days they do).

### `TBL_JI_ABS_OB_CATS`, `TBL_JI_ABS_OB_TYPES` — reference data
Absence categories and absence types. Standing data used for LOVs, maintained via the `IN_USE` flag. The type-level flags in the DDL (`INCL_IN_ITIN`, `FEE_PAYABLE`, `ALLOW_WEEKEND`, `SD_STATUS`, `MI_TYPE_ID` etc.) were not discussed.

### `TBL_JI_ABS_OB_VAC_OPTS` — "vacancy options"
Martin listed this together with the cats, types and cancel reasons as standing/LOV data. *Note: the DDL shows it keyed to a specific `JI_ABS_OB_ID` with vacancy date, location and status columns, and it carries triggers, so structurally it looks like per-absence vacancy option data rather than reference data. Treat the transcript's classification as unverified and confirm with Martin.*

### `TBL_JI_VAC_CANCEL_REASONS` — reference data
Reasons a vacancy was cancelled; LOV standing data with `IN_USE`.

### `TBL_JI_VACANCY_GROUPS` (header) and `TBL_JI_VACANCIES` (detail)
Created when there is, or will be, an absence and the user decides to raise a **vacancy** for cover. `VACANCY_GROUPS` is the header (one row for the whole vacancy period); `VACANCIES` is the detail (one row per day). It is the same header/detail design as everywhere else but with **inconsistent naming**, explained in §1 point 8.

---

## 5. Bookings & Sittings cluster

**Bookings are for fee-paid judges; sittings are for salaried judges.**

### `TBL_JI_PLANNED_SITTINGS` — salaried judges
One row per salaried judge per working day. Users can add rows for non-working days (e.g. a weekend sitting). When an absence is recorded the affected rows are **marked cancelled, never deleted**, so a complete record remains.

### `TBL_JI_FP_BOOKINGS` (header) and `TBL_JI_FP_BOOKING_DETAIL` (detail) — fee-paid judges
"FP" = fee paid. Core details of a booking (which may span a day to a month) are in the header; one row per day in the detail. This lets a court cancel one day of a two-week booking without rebooking the rest. The detail row holds all cancellation information, including the date the cancellation email was sent to the judge.

### `TBL_JI_FP_BOOKING_TYPES` — reference data
Metadata listing booking types: the normal fee-paid booking, plus variants such as **urgent court business** (e.g. called in at a weekend) and others. Different types can attract different payment, and the type also matters for MI — it goes back to JI's origin as a data-collection tool. The table does **not** hold fee amounts; those come from `TBL_JUDGE_FEE_RATES`.

### `TBL_JI_FP_CANCELLERS` — reference data (LOV)
Lists **who** cancelled a booking: the judge, the local office, or the judicial team. This matters because a fee-paid judge can still claim their fee for a late cancellation unless the judge themselves cancelled. It dates from when late-cancellation payments were made through the system; JFEPS still looks at it. It is purely a list of values — the cancellation itself, and its details, are stored on the booking detail row.

---

## 6. Reference Data — Work, Durations, Areas, Links cluster

Martin read this cluster's table names out but explained only one of them in detail; he noted that some of these tables are ones "you just never go to".

### `TBL_JI_UA_JT_LINKS` — user access level → judge types
Defines **which judge types each user access level can see**. This implements the rule discussed the previous day that court users can see District Judges but not normally Circuit Judges.

### Named but not explained
The following were listed by name only, with no purpose stated in the transcript. Their role can be read from the DDL but was not confirmed by the creator:
- `TBL_JI_PLANNED_WORK_TYPES`, `TBL_JI_PLANNED_WORK_CATS`, `TBL_JI_ACTUAL_WORK_TYPES`, `TBL_JI_ACTUAL_WORK_CATS` — planned vs. actual work type reference data.
- `TBL_JI_SITTING_DURS` — sitting durations.
- `TBL_JI_EXTRA_NWDS` — extra non-working days (keyed by judge type and circuit in the DDL).
- `TBL_JI_LOC_JT_AWD_LINKS`, `TBL_JI_LOC_JT_PWD_LINKS`, `TBL_JI_LOC_JT_SD_LINKS` — Martin read these as "actual working day links", "planned working day links" and "sitting day links", i.e. which actual work types / planned work types / sitting durations are valid per location type and judge type.
- `TBL_JI_AREAS` — not discussed as such. Martin explained the **shared** `TABLE_AREAS` (areas = clusters, each within a region); `TBL_JI_AREAS` carries `REGION_ID` and is probably JI's own area list, but this was not confirmed.

---

## 7. Audit & Cross-cutting cluster

### `TBL_JI_CHANGES` and `TBL_JI_CHANGE_TYPES` — semi-obsolete audit log
Built at go-live to give a **full change history**: every change to a key table was to get a change ID with the previous values recorded. Because of the volume of urgent changes in the first month after go-live it "dropped by the side" and never worked as intended. They are kept because some code paths still log to them, but they are **semi-obsolete** and no longer relied upon.

### `TBL_JI_RESTR_ITIN_USERS` — users allowed to see future itineraries
Most users can only see the **current financial year**, because next year's working patterns must stay secret until each judge has been personally informed. This table lists the individual **user IDs** (not user types) permitted to view future itineraries. It fills up towards the end of the financial year (around 50 rows mid-year; almost every user by March) and one of Martin's **1 April tasks is to wipe it back to RSU users only**. The RSU maintains the list themselves via a dedicated user; second line does not manage it.

---

## 8. `TMP_JI_*` tables

`TMP_JI_ABS_OB_DETAIL`, `TMP_JI_ABS_OB_LINKS`, `TMP_JI_FP_BOOKINGS`, `TMP_JI_JUDGE_LINKS`, `TMP_JI_LOC_LINKS`, `TMP_JI_PLANNED_SITTINGS`, `TMP_JI_VAC_BLOCKS`, `TMP_JI_VACANCIES` were **not discussed**. From their columns they are session-scoped working tables (`SESSION_ID`) and source-to-OPT mapping tables (`SRC_*` / `OPT_*`) — the latter likely from the original regional data migrations — but that is inference, not the creator's statement.

---

## 9. Implications noted for the replacement system (CTAM)

Points Martin made when asked what JI masters that the JOH feed will not supply:

| Data | Martin's view |
|---|---|
| Sharing agreements (`TBL_JUDGE_COURTS_LINK`) | **Definitely not** in JOH data — local business process; must be mastered locally. |
| Fee rates (`TBL_JUDGE_FEE_RATES`) | Probably not in JOH (finance data); should be obtainable from JFEPS. A finance-user screen would be preferable to the current manual load. |
| Tickets | Should be in the Judicial Office system, though some regions prefer to maintain them locally. Not critical in JI today. |
| Absences | Only sickness comes from JHR; leave, Judicial College (delegate vs. trainer) and other official business are entered in JI. |
| Everything else (contact details, roles, appointments) | Available from JOH. |

Other design lessons offered: JI was built with no expectation that anyone else would ever consume its data; business logic embedded in PL/SQL packages makes change and testing hard; and JI has become a de facto system of record for things (notably leave balances) it was never meant to own.

---

## 10. Open points to confirm with the creator

1. `TBL_JI_ABS_OB_VAC_OPTS` — reference data or per-absence data? (transcript vs. DDL disagree).
2. `TBL_JUDGES_JURIS_SPLIT` — keyed by judge code or by work pattern? (Martin recalled judge code; DDL says work pattern).
3. Purpose of the reference-work tables listed in §6 and all `TMP_JI_*` tables.
4. Exactly which shared OPT tables and packages JI depends on (Martin is compiling this for the GitHub repo).
5. What the overnight routines do in full, in particular around promotion/retirement date processing and how placeholder promotion records are merged.
