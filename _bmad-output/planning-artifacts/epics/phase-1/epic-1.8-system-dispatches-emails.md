---
type: 'Epic'
description: 'Sets up the CTAM Pathfinder notification service so other services can safely send emails through it from day one: its send endpoint is live, every email attempt is logged in a database table, and it is connected to the real HMCTS email system, all proven end to end through hands-on testing before anything else starts relying on it.'
resource: 'epics/phase-1/epic-1.8-system-dispatches-emails.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-06-17'
parent: 'epics/phase-1/index.md'
epic: 1.8
title: 'Notification service is scaffolded and contractually ready'
storyCount: 2
repo: ctam-notification
depends_on: [epic-1.0]                      # only needs the estate — parallelisable with 1.1/1.2/1.3/1.4
---

# Epic 1.8: Notification service is scaffolded and contractually ready

**Business Goal:** Several parts of CTAM Pathfinder — starting with acknowledging an absence request and confirming a booking — need to send an email to a judge or tribunal member at the right moment. Rather than each of those features building its own way of sending email, the programme wants one shared, dependable notification service that every other team can call in the same way, with a full record of what was sent, to whom, and whether it actually went out. Building and proving that service early — well before the features that will actually use it are ready — means those later teams can start writing their own code against a stable, already-working contract instead of waiting, or worse, building their own one-off email logic.

**What this covers:** This work stands up the notification service itself: publishing its shared address so other services know how to call it, creating the database table that records every email attempt, connecting it to the real HMCTS email system (with a safe stand-in for that connection during testing), and building the actual "send an email" endpoint with automatic retries if something goes wrong along the way. It also includes a way for support staff to look back through what has been sent. For now, only services acting on behalf of a signed-in user (for example, an absence request being acknowledged) can use it; a separate way for fully automated, scheduled processes to call it — needed once automated payment runs arrive later in the programme — is intentionally left for a later phase, since nothing needs it yet. There is also no admin screen for sending test emails yet: proving the service works is done by hand, using a testing tool, during this phase's integration testing.

**Outcome:** By the end of this work, the notification service is deployed and the way it is called is fixed and published, so it can genuinely be depended on: it has been proven, end to end, that a request can be sent in, an email attempt is logged, and the actual email is delivered and can be inspected.

**What's included:**
- The notification service, deployed and running with the platform's standard set-up (logging, health checks, an automated build pipeline, and code-quality checks)
- A database table that records every email attempt: who it went to, what it said, whether it is queued, sending, sent, failed, or given up on, and how many attempts were made
- A real connection to the HMCTS email system for sending, with a safe local stand-in used during testing so no real emails go out by accident
- An automatic retry: if sending fails for a temporary reason, the service tries again several times before giving up and flagging it for someone to look at
- The actual "send an email" endpoint, which only services acting on behalf of a signed-in user can call for now
- A way for authorised staff to look back through what has been sent, filtered by recipient, status, or date
- A published, versioned description of exactly how to call the service, plus a ready-made set of test requests other teams can reuse
- A hands-on test during this phase that proves the whole journey works: send a request in, watch it move through the queue, and see the actual email arrive

**Why this matters:** Nothing in this work is customer-facing on its own — it is foundational plumbing. But because several later features (acknowledging an absence request, confirming a booking, and eventually payment notifications) all depend on being able to send an email reliably, getting this service right early — and proving it actually works rather than just assuming it will — means those later teams can build with confidence instead of discovering email-delivery problems deep into their own work.

**Explicitly out of scope (left for later phases):**
- A way for fully automated, scheduled processes (rather than a signed-in user's action) to call the service — this is left until the point in the programme when the first such automated process actually needs it
- An admin screen for sending a test email by hand — not needed in this early phase, since the same check can be done with a testing tool instead; day-to-day admin tasks in this phase are instead handled directly by the database team, following the programme's standard operational procedures, rather than through a screen
- A screen for browsing the sent-email history — the same testing tool covers this need for now

---

## Story 1.8.1: The notification service, its delivery-history table, and its connection to email are set up

As a **platform engineer**,
I want to set up the notification service following the programme's established pattern, create the table that will record every email attempt, and connect the service to the HMCTS email system,
So that **the later features that need to send email** (acknowledging an absence request, confirming a booking, and eventually payment notifications) **can rely on a consistent, ready-made way of doing so from the very start**, rather than each one building its own.

**Acceptance Criteria:**

**Given** the engineer has manually created the notification service's own private code repository, with the standard protections on its main branch, following the same manual set-up process already used for the platform's very first services,
**And** runs the standard scaffolding script for it,
**When** the scaffolding completes,
**Then** the new repository has the same baseline as every other service built so far — the standard application framework, deployment packaging, automated build pipeline, health checks, structured logging, API documentation tooling, and code-quality checks,
**And** it is registered under the group `uk.gov.hmcts.ctam`, named `ctam-notification`, using the package `uk.gov.hmcts.ctam.notification`, and defaults to port 8082,
**And** the very first commit is recorded as *"Scaffold CTAM Pathfinder notification from HMCTS starter"*.

**Given** the engineer adds the database change that creates the delivery-history table,
**When** that change is applied,
**Then** a `ctam_notification_dispatches` table exists, recording for every email attempt: a unique id, which template was used, who it was sent to, what data it contained, its status (queued, sending, sent, failed, or given up on), how many attempts have been made, when the last attempt happened, what the last error was (if any), when the record was created, when it was actually sent, which signed-in user's action triggered it (for audit purposes), and a version marker used to prevent two processes updating the same record at once,
**And** the table is owned by the notification service's own database role,
**And** its structure is documented alongside the rest of the programme's database documentation.

**Given** the engineer configures the connection to the email system,
**When** the service starts up in a development environment,
**Then** its email settings are loaded from the environment's configuration and from the programme's secure secret storage,
**And** in every non-production environment, a safe local stand-in for the real email system intercepts anything the service tries to send, so no real emails ever go out during testing,
**And** in production, the same configuration points at the real HMCTS email system.

**Given** the service is deployed to the development environment,
**When** its health-check address is queried,
**Then** it responds successfully, including the current health of its connection to the email system,
**And** it reports itself as degraded if that email connection cannot be reached.

---

## Story 1.8.2: The "send an email" endpoint delivers, retries, and logs every request, with a way to review what was sent

As a **calling service** (for example, the later work that acknowledges an absence request or confirms a booking, both triggered by a signed-in user's own action),
I want a single endpoint that accepts a template, a recipient, and the data to fill it with, checks that the caller is a genuine signed-in user, records the attempt, sends the email with automatic retries if something temporarily goes wrong, and gives a clear, standard error response if the request is invalid,
So that **sending a transactional email is a single, dependable, observable action** that every later, user-triggered feature can use in exactly the same way. A way for fully automated, unattended processes to call this same endpoint is intentionally left for later in the programme, once the first such process (an automated payment run) actually needs it.

**Acceptance Criteria:**

**Given** the notification service has been set up as described in the previous story,
**When** the engineer builds the send endpoint,
**Then** `POST /v1/notifications/send` accepts a request containing a template identifier, a recipient, and a data payload,
**And** the endpoint only accepts requests carrying a genuine signed-in user's identity, passed through from the calling service,
**And** the calling user's role is checked against who is allowed to trigger that particular template (for example, in this phase only the roles responsible for absence handling, plus system administrators, may trigger the absence-acknowledgement email),
**And** on a valid request, a new row is recorded in the delivery-history table with status "queued" and the triggering user's identity attached, and the caller receives back an acknowledged-and-queued response along with a reference id for that delivery.

**Given** a background process regularly checks for queued rows, picking each one up safely so that two processes never work on the same row at once,
**When** it picks up a row,
**Then** it marks that row as "sending",
**And** attempts to send the actual email,
**And** on success, marks it "sent" and records when it was sent,
**And** on a temporary failure, records the attempt and the error, and puts it back in the queue to try again — up to five attempts in total, waiting progressively longer between each,
**And** once all five attempts are used up, marks it as given-up-on, keeping the last error visible for someone to investigate.

**Given** an invalid request reaches the send endpoint,
**When** something required is missing or malformed — the template, the recipient, or the data payload,
**Then** the response is a clear, standard "bad request" error explaining exactly which field was wrong,
**And** nothing is recorded in the delivery-history table.

**Given** a request reaches the send endpoint without a genuine signed-in user's identity attached,
**When** that identity is missing or cannot be verified,
**Then** the response is a clear, standard "not authenticated" error,
**And** nothing is recorded in the delivery-history table.

**Given** a request arrives claiming to be from a fully automated, unattended process rather than a signed-in user,
**When** the service checks its identity,
**Then** the request is turned away with a clear, standard error explaining that automated callers are not supported yet, and that this capability will arrive later in the programme once the first such caller needs it,
**And** that rejection is itself logged, so the attempt remains visible.

**Given** a delivery-history lookup endpoint is added,
**When** it is called by someone with a system-administrator role,
**Then** it returns the delivery history, page by page, filterable by recipient, status, date range, or triggering user,
**And** anyone without that role is turned away with a clear, standard "not allowed" error.

**Given** the service's published description of how to call it is regenerated,
**When** the new version is published,
**Then** it passes the programme's standard documentation-quality check,
**And** it documents both the send endpoint and the delivery-history lookup endpoint,
**And** it clearly notes that support for fully automated callers is intentionally left for a later version, and that only signed-in-user calls are supported for now.

**Given** a ready-made set of test requests for this service is published,
**When** it is run automatically as part of the build,
**Then** it covers: the normal successful path; a bad request; a not-authenticated request; an admin-only check on the history lookup; an automated-caller request being correctly turned away; and the retry behaviour, using a removable test-only endpoint that deliberately triggers a failure,
**And** the hands-on check for this phase is: open the testing tool, sign in as a test user, send a request, watch the delivery-history entry move to "sent", then open the email stand-in tool and confirm the email rendered correctly. (There is no admin screen for this check in this phase.)

**Explicitly not in scope (left for later phases):**
- A way for fully automated, scheduled processes to call this endpoint — left until the point in the programme when the first such process actually needs it
- An admin screen for sending a test email by hand — not needed in this early phase; in the meantime, any admin operations that would otherwise need a screen are handled directly by the database team through the programme's standard operational procedures
- A screen for browsing the delivery history — the testing tool covers this need for now
