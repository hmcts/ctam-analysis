---
type: 'Epic'
description: 'User outcome: A CTAM Pathfinder user from either identity population — a JOH (Judge, Tribunal Judge, or Tribunal Member) or HMCTS admin staff (RSU, Court user, Tribunal Caseworker, Finance/Payment Authoriser, or MI/Reporting) — signs into CTAM Pathfinder through a single sign-on flow, has their identity, roles, jurisdiction, and region/area scope worked out automatically, and lands on a Home page showing only the navigation and information tiles they are allowed to see.'
resource: 'epics/phase-1/epic-1.4-user-authenticates.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-06-17'
parent: 'epics/phase-1/index.md'
epic: 1.4
title: 'User authenticates and lands on a role-scoped Home page'
storyCount: 0
repo: [ctam-authorisation, ctam-mock-auth, ctam-ui]
depends_on: [epic-1.0, epic-1.1, epic-1.2]  # needs the estate + the schema (1.1) + jo_people populated by the eLinks sync (1.2.1)
---

# Epic 1.4: User authenticates and lands on a role-scoped Home page

**Business Goal:** CTAM Pathfinder needs a secure, trustworthy front door before any judge-facing or admin-facing feature can be built on top of it. Two genuinely different groups of people will use the system — judges and tribunal members on one side, and HMCTS admin staff on the other — and the platform has to recognise both correctly, work out what each person is allowed to do, and enforce that consistently everywhere, every time. Getting this right early means every feature built afterwards can simply trust that the person in front of it has already been verified and scoped correctly, rather than each team re-inventing sign-in and permission checks for itself. Because the real HMCTS sign-in system isn't ready to connect to yet, this work also builds a temporary, safe stand-in that behaves the same way, so the rest of the programme isn't blocked waiting for it.

**What this covers:** This is a substantial piece of foundational work spanning three new services: the authorisation service that decides who someone is and what they're allowed to do, a temporary stand-in sign-in service used until the real HMCTS one is ready, and the first version of the public-facing web application everyone will actually use. Together they're wired up so a real person can open CTAM Pathfinder, sign in, be recognised and scoped correctly, and land on a Home page tailored to their role — proving the whole platform pattern works end to end before any specific business workflow (itineraries, absences, vacancies, payments, and so on) is built on top of it.

**User outcome:** A CTAM Pathfinder user from either identity population — a JOH (Judge, Tribunal Judge, or Tribunal Member) or HMCTS admin staff (RSU, Court user, Tribunal Caseworker, Finance/Payment Authoriser, or MI/Reporting) — opens CTAM Pathfinder, signs in through single sign-on, and has their identity worked out automatically: for a JOH, by matching their sign-in email against the judicial reference data to a personnel number and then to a CTAM-assigned judicial identity; for admin staff, by matching their sign-in email to a CTAM-assigned staff identity held separately. Once identified, their roles, jurisdiction, and region/area scope are resolved, and they land on a Home page showing the navigation and information tiles they're authorised to see.

**Before this can start:** The shared Azure environment must already exist (built in the platform's foundational estate epic), the underlying database schema must already be in place, and the nightly job that pulls judge and tribunal-member data in from the outside eLinks data source must already have populated the `jo_people` table this epic looks people up against.

**Vertical slice:**
- The authorisation service (`ctam-authorisation`) is scaffolded from HMCTS's standard Spring Boot starter template using the shared scaffolding script, following the same pattern the very first service in the programme used, and connects into the shared Azure environment set up earlier
- A temporary stand-in sign-in service (`ctam-mock-auth`) is built for non-production use, issuing the same shape of security token the real HMCTS sign-in system will eventually issue, seeded with a roster of test users spanning both identity populations
- A six-table database structure is added to the authorisation service (`ctam_auth_users`, `ctam_auth_staff_identities`, `ctam_auth_roles`, `ctam_auth_user_roles`, `ctam_auth_user_region_scopes`, `ctam_auth_user_activation_flags`, the last of which records each user's jurisdiction-and-region combination), built the same way every service in the programme manages its own database changes
- A custom token-checking filter validates every incoming request against the sign-in service's published keys, and a dedicated check endpoint (`POST /authz/check`) performs the two-population identity resolution, populating a short-lived "who is this and what can they do" record the rest of the request can use
- The public-facing web application (`ctam-ui`) is scaffolded using React, TypeScript, Vite, Vitest, and Playwright
- The web application gets a reusable sign-in wrapper (`HmctsIdpProvider`), a way of protecting pages so only signed-in users can reach them (`ProtectedRoute`), a shared way of finding out who's currently signed in (`useAuth`), and a shared HTTP client that turns back-end error responses (in the standard RFC 9457 problem-details shape) into something the screen can display sensibly
- The look and feel is built on the GOV.UK Design System, with HMCTS and CTAM Pathfinder's own visual extensions layered on top
- The Home screen shell shows navigation scoped to the signed-in person's role, plus a region/area selector

**What this delivers against the wider requirements list:** the ability for a person to prove who they are and be recognised as a specific individual; having their roles and permissions resolved automatically; letting a person (or an administrator) look up exactly what someone is allowed to do; and a Home page shell with role-based navigation and a region/area switcher. This is the front-end and business-application slice of that work — the underlying platform and infrastructure pieces are delivered by the earlier epics this one depends on.

**Key quality standards this work has to meet:**
- Sign-in tokens are passed securely between services and checked on every single request
- Access is enforced consistently everywhere, including by jurisdiction, not just by role
- The public web application meets the WCAG 2.2 AA accessibility standard, works properly with assistive technology such as screen readers, and satisfies the government's legal accessibility requirements
- Secrets and credentials are stored safely in Azure Key Vault, never in code
- Sign-in works against a stand-in for the real HMCTS sign-in system for now, built so that switching to the real one later in the programme is a configuration change rather than a rebuild
- Every service can be deployed and run independently on the shared Kubernetes cluster

**Out of scope (for now):** Pulling judge and tribunal-member data in from the eLinks data source, scaffolding the reference-data service, and setting up the shared cloud environment — all handled in earlier epics. CTAM's own reference data and the read API for it — that's a later epic. Machine-to-machine authentication for automated systems calling CTAM directly isn't needed yet and is planned for after the initial rollout. The real HMCTS sign-in system isn't connected yet either — this epic only builds and uses the stand-in, with the real switch-over planned well ahead of the wider rollout. And the work of actually setting up and verifying real production user accounts is a separate, later epic — this epic only builds the database tables and the checking logic, not the process of populating them for real.

