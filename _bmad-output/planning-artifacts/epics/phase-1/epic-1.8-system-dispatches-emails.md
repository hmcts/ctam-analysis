---
type: 'Epic'
description: 'Sets up the CTAM Pathfinder notification service so other services can safely send emails through it from day one: its send endpoint is live, every email attempt is logged in a database table, and it is connected to the real HMCTS email system, all proven end to end through hands-on testing before anything else starts relying on it.'
resource: 'epics/phase-1/epic-1.8-system-dispatches-emails.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-06-17'
parent: 'epics/phase-1/index.md'
epic: 1.8
title: 'Notification service is scaffolded and contractually ready'
storyCount: 0
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

