---
type: 'Delivery Pilot'
title: 'Pilot 0.5 — notification service, log-only slice'
description: 'A deliberately narrowed slice of Epic 0.5, run to test the delivery method: the BMAD dispatch → execute → signal loop, the arch-vN context bus, and the agent-rules enforcement pack. Epic 0.5 itself is NOT being delivered and is not edited.'
tags: [ctam-pathfinder, delivery, pilot, agent-rules]
timestamp: '2026-08-19'
parent: 'delivery/pilots/README.md'
derived_from: 'epics/phase-0/epic-0.5-system-dispatches-emails.md (read-only)'
authorised_by: 'Ramnish, 2026-08-19'
last_updated: 2026-08-19
---

# Pilot 0.5 — notification service, log-only slice

> **Epic 0.5 is not being delivered by this pilot.** [`epic-0.5-system-dispatches-emails.md`](../../epics/phase-0/epic-0.5-system-dispatches-emails.md) and [`ledger/epic-0.5.yaml`](../ledger/epic-0.5.yaml) are untouched, and stories 0.5.1 / 0.5.2 remain `not-started`. This pilot builds a **variant slice** with its own acceptance criteria, recorded below.

## Why this pilot exists

To find out whether the delivery method actually works before committing eight phases of work to it. Three specific mechanisms are unproven:

1. **The dispatch → execute → signal loop** — can a *cold* session in a service repo implement a story from `CLAUDE.md` + the story packet + the pinned bus, with no further context?
2. **The context bus** — does a repo pinned at `arch-v1.0` resolve everything the rules cite?
3. **The enforcement pack** — none of it has ever compiled or run (**G1.4c**). Does it work, and does it catch real violations?

### Hypotheses under test

| # | Hypothesis | How the pilot answers it |
|---|---|---|
| **H1** | A cold session needs nothing beyond `CLAUDE.md`, the packet, and `_arch/` | The story is executed in a **fresh session** in `ctam-notification`, not in the session that authored the rules. Every clarification it needs is a defect in the packet or the rules |
| **H2** | The enforcement pack runs and catches real violations | Run the gate on the bare scaffold first, then per behaviour. Log every enforcer that failed to run, and every violation it caught |
| **H3** | `require-red-test.sh` raises the cost of skipping TDD without obstructing legitimate work | Count denials and note whether any were false positives |
| **H4** | The rules are complete enough to work from | Collect every point where a rule was silent, ambiguous, or wrong |
| **H5** | The gate is fast enough for a per-behaviour loop | Record wall-clock for `check` and for the full gate including PIT |

**The retro is the deliverable.** Working code is the by-product.

## Scope — what is built

A single Spring Boot service, `ctam-notification`, exposing **one** endpoint that records that a notification was requested by writing **one structured log line**. No email, no database, no auth.

```
POST /v1/notifications/send
  request   { "templateId": "absence-ack",
              "recipient":  "someone@example.gov.uk",
              "payload":    { "absenceId": "…" } }
  202       { "deliveryId": "<uuid>", "status": "logged" }
  400       application/problem+json   — body could not be parsed
  422       application/problem+json   — field validation, or unknown template
```

Expected shape, per `_arch/architecture/conventions.md` → *Structure Patterns*:

```
src/main/java/uk/gov/hmcts/ctam/notification/
├── NotificationApplication.java
├── controller/NotificationController.java
├── service/NotificationDispatchService.java        ← the behaviour under test
├── dto/SendNotificationRequest.java                ← record + JSR-380 constraints
│   └── SendNotificationResponse.java               ← record
├── error/NotificationExceptionAdvice.java          ← RFC 9457 @ControllerAdvice
├── exception/UnknownTemplateException.java         ← extends BusinessRuleViolation
└── config/ClockConfig.java                         ← java.time.Clock bean (M20)
    └── CorrelationIdFilter.java                    ← inbound read-or-generate → MDC
```

No `repository/`, no `domain/`, no `client/`, no Liquibase changelog. Anything not on that list needs a citation or a decision (**R6**).

## Acceptance criteria

Numbered `AC-n` and carried into test `@DisplayName`s per **T6**.

### AC-1 — a valid request is accepted and logged

```gherkin
Given the service is running
And the request body is {"templateId":"absence-ack","recipient":"judge@example.gov.uk","payload":{"absenceId":"7f3c…"}}
When POST /v1/notifications/send is called
Then the response status is 202 Accepted
And the response body is {"deliveryId":"<a uuid>","status":"logged"}
And exactly one INFO log entry is written
And that entry contains the deliveryId, the templateId and the correlation id
And that entry does NOT contain the recipient address, nor any value from payload
```

> The last line is **S1** in action: `recipient` is an email address, so it is personal data and must not reach the logs. "Log a line saying we received a request" therefore logs the *identifiers*, never the *content*.

### AC-2 — an unknown template is a business-rule failure

```gherkin
Given the request body carries templateId "no-such-template"
When POST /v1/notifications/send is called
Then the response status is 422 Unprocessable Entity
And the content type is application/problem+json
And the problem type identifies the business-rule category
And no log entry states that a notification request was accepted
```

Permitted templates for the pilot: **`absence-ack` only.** The per-template permitted-callers list from Epic 0.5.2 is out of scope (it needs authorisation).

### AC-3 — field validation failure is 422

```gherkin
Given the request body is well-formed JSON
And recipient is not a valid email address
When POST /v1/notifications/send is called
Then the response status is 422 Unprocessable Entity
And the content type is application/problem+json
And the problem type identifies the validation category
And the problem detail names the offending field
And no INFO log entry states that a notification request was accepted
```

> **This resolves a documented conflict — see Deviation D-4.** Epic 0.5.2's AC says 400 here; `conventions.md` maps `MethodArgumentNotValidException` to 422. **422 wins.**

### AC-4 — an unparseable body is 400

```gherkin
Given the request body is not valid JSON
When POST /v1/notifications/send is called
Then the response status is 400 Bad Request
And the content type is application/problem+json
And the problem detail does not echo the raw body
```

> `conventions.md` defines 400 for "malformed request (parsing failure)" but does not map `HttpMessageNotReadableException` to a `type` category. Pilot decision under **C8**: use the **`validation`** category. Flagged for the retro as a candidate addition to the conventions' exception→status table. The "does not echo the raw body" line is **C10** — a malformed body may contain personal data.

### AC-5 — the correlation id is read or generated, and reaches the log

```gherkin
Given a request arrives with header Correlation-Id: 11111111-2222-3333-4444-555555555555
When POST /v1/notifications/send is called
Then the log entry for that request carries that correlation id

Given a request arrives with no Correlation-Id header
When POST /v1/notifications/send is called
Then a correlation id is generated
And the log entry for that request carries it
```

> Deliberately says nothing about echoing the header back in the response: `conventions.md` specifies inbound read-or-generate, MDC, and outbound propagation only. Adding a response header would be inventing surface (**R6**). There are no outbound calls in this slice.

### AC-6 — the generated spec is convention-clean

```gherkin
Given the OpenAPI spec is generated from the code by Swagger Core
When the CTAM Spectral ruleset is run against it
Then the lint passes with no errors
And the spec documents POST /v1/notifications/send with its 202, 400 and 422 responses
```

## Out of scope — and why

Everything in Epic 0.5 not listed above. Explicitly:

| Epic 0.5 element | Why it is out |
|---|---|
| SMTP / Mailpit / HMCTS email infrastructure | The point of the pilot is to remove external dependencies |
| `ctam_notification_dispatches` table + Liquibase changelog | No container runtime on the authoring machine, so Testcontainers cannot run (**D-2**) |
| `@Scheduled` worker, `FOR UPDATE SKIP LOCKED`, retry budget, `queued → sending → sent / failed / dead-lettered` | Depends on persistence |
| `JWTFilter`, `AuthDetails`, per-template caller roles, 401/403 | Depends on `ctam-authorisation` and `ctam-mock-auth`, neither of which exists (**D-3**) |
| `GET /v1/notifications/delivery-log` | Nothing is persisted, so there is nothing to read |
| Maven spec artefact publish, Helm chart deploy to AKS, Postman collection in CI | Not needed to test the method |
| Actuator SMTP health indicator | No SMTP |

## Deviation register

Each deviation is a rule or an authored AC that this pilot knowingly departs from. **Nothing here may be treated as precedent for real delivery.**

| ID | Deviation | Rule / source affected | Approved by | Consequence |
|---|---|---|---|---|
| **D-1** | Epic 0.5's SMTP dispatch replaced by a single log line | Epic 0.5 vertical slice, FR9 (partial) | Ramnish, 2026-08-19 | FR9 is **not** covered by this pilot. `ledger/epic-0.5.yaml` stays `not-started` |
| **D-2** | No persistence, no Liquibase, no integration tests | **P1–P16**, **T8**, **P6** not exercised | Ramnish, 2026-08-19 | The persistence half of the rules is **untested by this pilot**. Highest-value follow-up once a container runtime exists |
| **D-3** | **The endpoint is unauthenticated.** No `JWTFilter`, no `AuthDetails` | **S9**, **S10**, **S11** waived | Ramnish, 2026-08-19 | **This build must never be deployed anywhere.** Recorded as `not_production_bound: true` in the pilot ledger. The first real story on this repo must add the filter before anything else |
| **D-4** | Field validation returns **422**, not the 400 that Epic 0.5.2's AC states | Epic 0.5.2 AC vs `conventions.md` → *Process Patterns* | Ramnish, 2026-08-19 | `conventions.md` wins. Epic 0.5.2's wording should be corrected by a later SCP — a real defect this pilot surfaced, not a pilot-only choice |
| **D-5** | Parse failure mapped to 400 with the `validation` category | **C8** — no mapping exists in `conventions.md` for `HttpMessageNotReadableException` | agent, pending confirmation | Candidate addition to the conventions' exception→status table. Raise in the retro |
| **D-6** | No Pact contract test; `verify.sh` Pact step will fail by design | **C2**, **T9**, **Q6** | Ramnish, 2026-08-19 | Nothing consumes this service yet, so there is no contract to verify against. The gate being unrunnable for a first-in-line service is itself a finding |
| **D-7** | No Maven spec artefact published, no Helm deploy | Epic 0.5.2 AC, **C5** | Ramnish, 2026-08-19 | No internal artefact repository is reachable from a local pilot |

## Definition of done for this pilot

The standard checklist in `_arch/agent-rules/90-definition-of-done.md` applies, with these recorded exceptions:

- **Q6 (contract tests)** — waived per **D-6**. Spectral must still pass.
- **Q7 (schema change proved from an empty database)** — not applicable per **D-2**.
- Everything else stands: every AC has a named test (**Q1**), every behaviour was driven red-first with pasted evidence (**Q2**), the rest of the gate passes with pasted output (**Q3**), no leftovers (**Q4**), no unsanctioned surface (**Q5**), the diff is minimal (**Q10**), and status ends at `in-review` (**Q13**).

Plus, uniquely for a pilot:

- **A retro document** recording, per hypothesis H1–H5: what the cold session had to ask for, which enforcers failed to run, which violations were genuinely caught, every place a rule was silent or wrong, and the measured gate timings.

## Execution protocol

The sequencing matters — it is the thing being tested.

1. **Dispatch** *(control plane, `ctam-analysis`)* — this document, plus the packet generated into the service repo as `docs/stories/pilot-0.5.1.md`.
2. **Prerequisites** *(human)* — publish and tag `arch-v1.0`; create the private `ctam-notification` repo; install JDK 25.
3. **Scaffold** *(service repo)* — clone the HMCTS Crime template, rename to `uk.gov.hmcts.ctam.notification`, install the enforcement pack, add `_arch/` at `arch-v1.0`, **then run the gate on the bare skeleton and fix what breaks.** De-risking **G1.4c** before the story starts is what stops a Checkstyle typo from being mistaken for a finding about the method.
4. **Execute** *(a **fresh** session, in `ctam-notification`)* — `bmad-dev-story` against the packet. **Not** the session that authored the rules: an author cannot test their own instructions, because everything the packet omits is already in their head.
5. **Review** — `bmad-code-review`, then the human commits and raises the PR.
6. **Signal** *(control plane)* — update [`ledger-pilot-0.5.yaml`](./ledger-pilot-0.5.yaml); write the retro.

## What this pilot cannot tell you

Worth stating plainly so its result is not over-read. It says nothing about persistence, Liquibase, transactions, optimistic locking (so **G6.7** stays open), Testcontainers, contract testing, deployment, or the observability estate. It tests the **code-shape and discipline** half of the method on a service small enough to read in full — not the integration half.
