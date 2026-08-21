---
type: 'Epic'
description: 'User outcome: A CTAM Pathfinder user from either identity population — a JOH (Judge, Tribunal Judge, or Tribunal Member) or HMCTS admin staff (RSU, Court user, Tribunal Caseworker, Finance/Payment Authoriser, or MI/Reporting) — signs into CTAM Pathfinder through a single sign-on flow, has their identity, roles, jurisdiction, and region/area scope worked out automatically, and lands on a Home page showing only the navigation and information tiles they are allowed to see.'
resource: 'epics/phase-1/epic-1.4-user-authenticates.html'
tags: [ctam-pathfinder, epics, phase-1]
timestamp: '2026-06-17'
parent: 'epics/phase-1/index.md'
epic: 1.4
title: 'User authenticates and lands on a role-scoped Home page'
storyCount: 5
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

---

## Story 1.4.1: Scaffold `ctam-authorisation` service from the HMCTS Crime SpringBoot template

As a **platform engineer**,
I want to scaffold `ctam-authorisation` from HMCTS's standard Spring Boot starter template using the shared scaffolding script, connecting into the shared Azure environment already set up earlier,
So that **the authorisation service is built on the same consistent, secure, version-pinned foundation as every other service in the programme**, and the team can prove the whole deployment pipeline works end to end before any actual authorisation logic is written.

**Acceptance Criteria:**

**Given** the engineer has completed the GitHub manual set-up checklist (`ctam-architecture/runbooks/github-setup.md`) before running the scaffold — the same steps used when the very first service in the programme was set up:
  - an empty private GitHub repo `ctam-authorisation` was created under the HMCTS org via the GitHub web UI
  - branch protection was enabled on `main` via Settings → Branches (requiring PR review, status checks, and a linear history)
  - note: the `gh` command-line tool is **not** available here — all GitHub admin set-up is done manually through the web UI, per the runbook,
**And** the engineer has a clean local development environment with Java 25, Gradle Wrapper, and Docker,
**When** the engineer runs `ctam-scaffold.sh ctam-authorisation` from `ctam-architecture/scaffolding/`,
**Then** the script scaffolds a Spring Boot 4.0.x project locally from `https://github.com/hmcts/service-hmcts-crime-springboot-template`, then commits and pushes it to the pre-created remote on a feature branch using plain `git` commands (no `gh` tool involved),
**And** the Gradle build uses the Groovy DSL with Spring Boot Gradle plugin 4.1.0 and `io.spring.dependency-management:1.1.7`,
**And** the Group ID is `uk.gov.hmcts.ctam`, the artefact is `ctam-authorisation`, the base package is `uk.gov.hmcts.ctam.authorisation`, and the default port is 8082,
**And** the initial commit message reads exactly *"Scaffold CTAM Pathfinder authorisation from HMCTS starter"*,
**And** Lombok 1.18.46 and MapStruct 1.6.3 are configured,
**And** JJWT 0.13.0 and OWASP Encoder 1.4.0 are on the classpath,
**And** springdoc-openapi is configured to generate an OpenAPI 3.x specification,
**And** JaCoCo, CycloneDX SBOM generation, gradle-git-properties, gradle-versions, and gradle-docker-compose are all configured,
**And** Spring Boot Test with JUnit 5 (`junit-bom:6.0.3`), Testcontainers PostgreSQL 1.21.4, Spring Boot Testcontainers 4.1.0, and spring-boot-starter-webmvc-test are configured,
**And** Spectral, ArchUnit, Spotless, and Checkstyle are all configured,
**And** a Helm chart skeleton exists at `charts/ctam-authorisation/` with `values-dev.yaml`, `values-staging.yaml`, and `values-production.yaml` overlays,
**And** a `terraform/` directory skeleton exists with separate stacks for `dev`, `staging`, and `production`, covering only this service's own cloud resources (its own Key Vault namespace, its own API-gateway policy) — the shared environment itself is provisioned and managed separately, in the reference-data service's own repository,
**And** GitHub Actions workflows exist at `.github/workflows/ci.yml`, `deploy-dev.yml`, `deploy-staging.yml`, and `deploy-production.yml`,
**And** `CODEOWNERS` and `PULL_REQUEST_TEMPLATE.md` files exist,
**And** a Postman collection skeleton exists at `postman/ctam-authorisation-phase0.postman_collection.json`.

**Given** the scaffolded service runs locally via `./gradlew bootRun` after a `docker-compose up postgres`,
**When** the engineer queries `http://localhost:8082/actuator/health`,
**Then** the response is `200 OK` with body `{"status":"UP"}`,
**And** `/actuator/info` returns Git metadata embedded by gradle-git-properties,
**And** `/actuator/readiness` returns `200 OK`,
**And** structured JSON logs via Logstash Logback Encoder 9.0 appear on stdout,
**And** logs include a `correlationId` populated by `CorrelationIdFilter` for each request.

**Given** the shared Azure environment — the Kubernetes cluster, the encrypted-at-rest PostgreSQL database, the container registry, the API gateway, the observability workspace (Application Insights / Log Analytics), and the secrets vault — was already built and independently checked in the shared-infrastructure repo as part of an earlier, foundational epic,
**When** `ctam-authorisation` deploys,
**Then** it uses that shared cluster, database, registry, gateway, and observability workspace without building any of them again,
**And** `ctam-authorisation`'s own `terraform/` directory only ever creates its own resources (its Key Vault namespace, its API-gateway policy),
**And** its dev configuration's database connection string points at the shared encrypted PostgreSQL instance.

**Given** the shared `ctam_configuration_values` table was already created by the programme's baseline database change-log, ahead of the reference-data service being built,
**When** `ctam-authorisation` is granted database access,
**Then** its database role has read-only (`SELECT`) access to `ctam_configuration_values`,
**And** its own service-owned change-log directory (`src/main/resources/db/changelog/`, with a master file `db.changelog-master.yaml`) exists but is still empty — the actual authorisation tables are added in Story 1.4.3.

**Given** the deployed service is publicly reachable through the shared API gateway, built as part of the earlier estate-provisioning epic,
**When** an HTTP request reaches the gateway,
**Then** the connection terminates TLS using the latest TLS version the platform supports,
**And** plain HTTP requests are rejected and redirected to HTTPS,
**And** the gateway's TLS configuration is checked by a CI test using `testssl.sh` (or equivalent) in `ci.yml`, which fails if any TLS version below the platform's current minimum is still accepted.

**Given** the engineer pushes the initial commit to a feature branch via `git push`,
**And** opens a Pull Request from that branch to `main` manually via the GitHub web UI (no `gh` tool involved),
**When** the GitHub Actions `ci.yml` workflow runs,
**Then** the workflow runs build, test, API-spec lint, architecture-rule checks, code-formatting checks, and style checks, plus a Helm chart lint,
**And** all checks pass on the scaffolded baseline,
**And** a code-coverage report is produced by JaCoCo.

**Given** the PR is merged to `main` via the GitHub web UI (no `gh` tool involved),
**When** `deploy-dev.yml` triggers automatically,
**Then** the service deploys to the development Kubernetes cluster in UK South,
**And** the container image is pushed to Azure Container Registry,
**And** the deployed pod passes its liveness and readiness checks,
**And** Azure Application Insights receives structured log entries via the OpenTelemetry Collector.

---

## Story 1.4.2: User can authenticate against `ctam-mock-auth` and receive a security token

As a **CTAM Pathfinder user from either identity population** (a JOH, or HMCTS admin staff — RSU, Court user, Tribunal Caseworker, Finance, or MI/Reporting),
I want to sign in against the stand-in sign-in service (`ctam-mock-auth`) in non-production environments using my email address,
So that **CTAM Pathfinder's development, automated testing, and user-acceptance testing can all proceed end to end before the real HMCTS sign-in system is connected**, while the token it issues has exactly the same shape as the one the real HMCTS system will issue once it's switched in.

**Acceptance Criteria:**

**Given** the engineer has manually pre-created the private GitHub repo `ctam-mock-auth` with branch protection on `main` via the GitHub web UI (per the runbook; the `gh` tool isn't available, so this follows the same manual pattern used for the very first service built in the programme),
**And** runs `ctam-scaffold.sh ctam-mock-auth` (following that same scaffolding pattern),
**When** the scaffold completes,
**Then** the service has the same baseline as that first service (Spring Boot 4.0.x, Helm chart, GitHub Actions, Actuator endpoints),
**And** the service implements the OIDC "authorization code" sign-in flow for human users,
**And** the service implements the OIDC "client credentials" flow for batch and scheduled components (this flow is only actually used by a much later phase of the programme, but is built now),
**And** a JWKS endpoint serves rotating signing keys at `/.well-known/jwks.json`,
**And** OIDC discovery information is served at `/.well-known/openid-configuration`.

**Given** `ctam-mock-auth` is starting up,
**When** the Spring profile in use is `production`,
**Then** the application refuses to start, with a fatal error message reading exactly *"ctam-mock-auth must not be deployed to production"*,
**And** the production `deploy-production.yml` workflow is configured to never deploy `ctam-mock-auth`.

**Given** `ctam-mock-auth` is seeded with a test-user roster spanning both identity populations:
  - JOH test users (for example `joh.test@example.justice.gov.uk` — a Tribunal Judge whose email matches a seeded judicial-reference-data row with a known personnel number; `tribunal.member.test@example.justice.gov.uk` — a Medical Member)
  - admin-staff test users (for example `caseworker.test@example.justice.gov.uk` — a Tribunal Caseworker; `rsu.test@example.justice.gov.uk` — an RSU Admin; each matched to a seeded staff-identity row),
**When** a user navigates to the OIDC sign-in endpoint with valid client and redirect parameters,
**Then** they see a development-mode login screen (no real password — they pick their identity by email from a seeded list, with a banner reading *"Development authentication only — not for production"*),
**And** after selection, they're redirected back with an authorisation code,
**And** that code can be exchanged for an ID token and access token via the token endpoint,
**And** the returned token contains the standard OIDC claims (`sub`, `email`, `iss`, `aud`, `exp`, `iat`),
**And** the token's signature validates against the JWKS endpoint.

**Given** a service-token client `ctam-payment-batch-client` is seeded in `ctam-mock-auth`,
**When** a "client credentials" grant is requested with valid client credentials,
**Then** a service-principal token is returned, carrying claims that identify the client,
**And** that token also validates against the same JWKS endpoint.

**Given** `ctam-mock-auth` is deployed to the development Kubernetes cluster,
**When** an unauthenticated request reaches a discovery URL,
**Then** the response is `200 OK` (discovery information is public),
**And** every other endpoint requires a valid token and returns a standard (RFC 9457) problem-details error on failure.

---

## Story 1.4.3: `ctam-authorisation` validates security tokens and resolves identity, roles, jurisdiction, and region/area scope (read-only API)

As a **calling service or the front-end application**,
I want every CTAM Pathfinder request to pass through a token-checking filter and have the person's confirmed identity, roles, jurisdiction, and region/area scope resolved through the authorisation service's read-only API,
So that **every action anyone takes is checked against real, already set-up user data, whichever of the two populations they belong to**, and nothing can get through without going via the authorisation service. Updating that user data (roles, scope, or activation status) isn't done through this API at this stage — for now that happens by a database administrator running SQL directly, with a proper admin screen for it planned for later.

**Acceptance Criteria:**

**Given** `ctam-authorisation` is scaffolded as in Story 1.4.1,
**When** the engineer adds the authorisation tables via the service-owned Liquibase change-set `db/changelog/001-init-auth-schema.sql`,
**Then** the six tables `ctam_auth_users`, `ctam_auth_staff_identities`, `ctam_auth_roles`, `ctam_auth_user_roles`, `ctam_auth_user_region_scopes`, and `ctam_auth_user_activation_flags` exist, with the structure set out in the architecture's data-tables reference,
**And** `ctam_auth_users` records which kind of person each row is (`principal_kind`: JOH, staff, or a service account), and links a JOH user to `ctam_joh_identities.id` via a `joh_id` column — `ctam_joh_identities` in turn carries the person's personnel number, which is how it lines up with the judicial reference data — while an admin-staff user links instead to `ctam_auth_staff_identities.id`; both populations end up keyed on a CTAM-assigned unique identifier rather than any externally-supplied one,
**And** `ctam_auth_users` also records the user's jurisdiction, since the programme rolls out one jurisdiction at a time and jurisdiction is treated as a core attribute of every user,
**And** `ctam_auth_user_activation_flags` records the jurisdiction-and-region combination a user's activation status applies to,
**And** the `ctam_authorisation` database role owns all six tables, and has read-only access to the judicial reference data for identity look-ups (that reference data is owned by the reference-data service and kept up to date by the nightly eLinks sync built in an earlier epic),
**And** automated architecture checks in CI confirm that no other service ever writes to these tables.

**Given** the engineer implements the token-checking filter, following the shared authorisation pattern used across the programme,
**When** a request arrives at any endpoint other than `/actuator/health`, `/actuator/readiness`, or `/actuator/info`,
**Then** the filter extracts the security token from the `Authorization: Bearer ...` header,
**And** checks its signature against the sign-in service's published keys (`ctam-mock-auth` for now; switching over to the real HMCTS sign-in system ahead of the wider rollout, configurable via a Spring profile and secrets held in Key Vault),
**And** rejects any request without a valid token with `401 Unauthorized` and a standard (RFC 9457) problem-details error body,
**And**, once the token checks out, calls the service's own `POST /authz/check` endpoint to work out who the person actually is,
**And** makes the result available to the rest of the request as a short-lived object that controllers and services can read.

**Given** an authenticated request reaches `POST /v1/authz/check` with a body `{"principal": "joh.test@example.justice.gov.uk"}` (a JOH user),
**When** the email resolves against the judicial reference data,
**Then** the response is `200 OK` with a body containing `{"principal": "...", "canonicalId": "<ctam_joh_uuid>", "personnelNumber": "...", "population": "joh", "roles": [...], "jurisdiction": "...", "regions": [...], "areas": [...], "activated": true/false}`,
**And** the CTAM-assigned judicial identifier is the one carried forward as the person's canonical identity for the rest of the request; the personnel number is only ever used as the upstream look-up link.

**Given** an authenticated request reaches `POST /v1/authz/check` with a body `{"principal": "caseworker.test@example.justice.gov.uk"}` (an admin-staff user),
**When** the email resolves against `ctam_auth_staff_identities`,
**Then** the response is `200 OK` with `{"canonicalId": "<staff-uuid>", "population": "staff", ...}` and exactly the same shape of roles, jurisdiction, scope, and activation information a JOH user gets back — both populations are handled by the same authorisation model,
**And** roles and scope are worked out by joining `ctam_auth_users` to `ctam_auth_user_roles` and `ctam_auth_roles`, and separately to `ctam_auth_user_region_scopes`,
**And** the response includes the person's activation status for their specific jurisdiction-and-region combination, from `ctam_auth_user_activation_flags`.

**Given** a valid, correctly-signed token whose email matches neither the judicial reference data nor `ctam_auth_staff_identities`,
**When** `POST /v1/authz/check` runs,
**Then** the person is rejected with a standard authorisation problem response — the same handling given to a user who exists but isn't yet activated,
**And** the rejection is logged with a correlation ID, and no account is automatically created.

**Given** an authenticated request reaches `GET /v1/users/{id}/effective-permissions`,
**When** the caller is either looking up their own ID or holds a system-admin role,
**Then** the response is `200 OK` with a structured permissions document,
**And** if neither condition holds, the response is `403 Forbidden` with a standard problem-details body.

**Given** the API specification is generated by springdoc,
**When** the engineer publishes it (via Gradle `maven-publish`) to the internal artefact repository,
**Then** `uk.gov.hmcts.ctam:api-ctam-authorisation:1.0.0` is available there,
**And** the standard API-spec lint passes on it,
**And** the specification uses `/v1/...`-style URL versioning,
**And** it declares the standard (RFC 9457) problem-details schema for error responses,
**And** the gateway's `Deprecation` and `Sunset` header policies for this API are documented.

**Given** the API gateway blocks `/actuator/*` paths from the outside,
**When** an external caller attempts `GET /actuator/health` via the public gateway hostname,
**Then** the request is rejected at the gateway,
**And** internal Kubernetes liveness and readiness checks still reach the pod directly.

**Explicitly not in scope (for later):**
- Endpoints for actually updating user roles, jurisdiction, region/area scope, or activation flags through this service — that's planned for after the initial rollout
- The tables are created here, but they're populated by a later epic's seed scripts (for development and testing) and by a separate production set-up process, not by writes through this API

---

## Story 1.4.4: Scaffold `ctam-ui` repo with React, TypeScript, Vite, a GOV.UK-based design system, and an auth wrapper

As a **front-end engineer**,
I want to scaffold the `ctam-ui` public-facing web application with all of CTAM Pathfinder's shared conventions built in — sign-in, the design system, a shared way of talking to the back end, accessibility checks in CI, and end-to-end tests,
So that **every screen built for each business area over the following phases lands on a stable, checked, accessible foundation**, rather than each phase inventing its own approach from scratch.

**Acceptance Criteria:**

**Given** the engineer has manually created the private GitHub repo `ctam-ui`, with branch protection on `main`, through the GitHub web UI — repo creation, branch protection, team access, and CODEOWNERS set-up are all manual web-UI steps, since the `gh` command-line tool isn't available,
**And** the engineer sets up the `ctam-ui` repo locally from a Vite React-and-TypeScript template and pushes it via plain `git push` to the pre-created remote,
**When** scaffolding completes,
**Then** the repo uses React, TypeScript, Vite, Vitest (for unit tests), and Playwright (for end-to-end tests),
**And** the repo is private, under the HMCTS organisation, with branch protection on `main`,
**And** its dependencies include the GOV.UK Design System base plus HMCTS and CTAM Pathfinder's own extensions,
**And** TanStack Query is configured to manage the lifecycle of requests to the back end,
**And** tooling is set up to automatically generate client code from each back-end service's published API specification, placing the generated code into `src/modules/{domain}/api/` for each business area.

**Given** the engineer implements the sign-in wrapper in `src/shared/auth/`,
**When** the wrapper is complete,
**Then** `HmctsIdpProvider.tsx` exposes the OIDC sign-in context, configurable per environment (pointing at `ctam-mock-auth` in development and CI, and at the real HMCTS sign-in system in later environments),
**And** `ProtectedRoute.tsx` redirects unauthenticated users into the single-sign-on flow,
**And** `useAuth.ts` exposes `{ user, isLoading, isAuthenticated, signIn, signOut }`,
**And** the shared HTTP client in `src/shared/api/httpClient.ts` attaches `Authorization: Bearer ...` to every authenticated request,
**And** `src/shared/api/errorHandling.ts` translates standard (RFC 9457) problem-details error responses into UI-ready error structures, with a title, a detail message, and field-level errors where present.

**Given** the engineer wires up the design-system foundation,
**When** the foundation is complete,
**Then** the GOV.UK Design System base CSS is loaded,
**And** HMCTS and CTAM Pathfinder design tokens (colours, spacing, typography) are applied,
**And** a `<PageLayout>` component exposes a header, a primary-navigation slot, a region selector slot, a main content slot, and a footer,
**And** the layout is responsive across mobile, tablet, and desktop screen sizes.

**Given** the engineer sets up accessibility checks in CI,
**When** the automated accessibility scan (axe-core) runs as part of `ci.yml`,
**Then** the build fails on any new WCAG 2.2 AA violation,
**And** keyboard navigation is verified by a Playwright smoke test (tab order through the navigation, with a visible focus indicator),
**And** screen-reader-relevant ARIA labels are present on tabbed and dynamic content.

**Given** the engineer publishes the first end-to-end test suite,
**When** `tests/e2e/phase-1-foundation.spec.ts` runs in CI,
**Then** the suite verifies the app starts, redirects unauthenticated users to the stand-in sign-in service, and renders a placeholder landing route once signed in — following the shared end-to-end testing pattern used across the programme.

**Given** the engineer sets up deployment, with the Azure Static Web App resource provisioned by Terraform code living in this repo's own `terraform/` directory — the first repo in the programme that needs this particular kind of cloud resource,
**When** the pull request is merged,
**Then** the built application is deployed to that Terraform-provisioned Azure Static Web App, in the UK South development environment,
**And** this deployment is entirely independent of any future separate admin-only web application, which isn't part of this initial rollout,
**And** the development hostname (configurable in production to become `ctam.hmcts.gov.uk`) resolves to the new deployment.

---

## Story 1.4.5: User signs into CTAM Pathfinder via single sign-on and lands on a role-scoped Home page

As a **CTAM Pathfinder user from either identity population** (a JOH or an admin staff member),
I want to sign into CTAM Pathfinder through single sign-on, have my confirmed identity, roles, jurisdiction, and region/area scope worked out, and land on a Home page whose navigation and information tiles match what I'm allowed to do,
So that **I can start using CTAM Pathfinder's day-to-day workflows** — and, by the end of this phase, the whole pattern can be demonstrated working end to end: signing in through the stand-in sign-in service, resolving against judge and tribunal-member data kept up to date by the nightly sync, being authorised, and reaching the web application.

**Acceptance Criteria:**

**Given** the user opens `ctam-ui` while not signed in,
**When** they navigate to any protected page,
**Then** the protected-route guard redirects them to the single-sign-on flow at the stand-in sign-in service (in non-production environments),
**And** the user completes the development-mode login (selecting their seeded test identity — JOH or admin staff),
**And** they're redirected back to `ctam-ui` with an authorisation code in the URL,
**And** the HTTP client exchanges that code for an ID token and access token,
**And** the user is redirected to `/home`.

**Given** the user is signed in,
**When** the Home page renders,
**Then** the page shows a header with the CTAM Pathfinder brand, the user's name, a sign-out button, and a region/area selector populated with the regions and areas the person is authorised for (resolved, together with their identity and jurisdiction, through the authorisation service's check endpoint),
**And** the primary navigation shows only the links the user's roles authorise (for example, a JOH sees "My Itinerary" and "Request Absence" but not operational admin workflows, while a Tribunal Caseworker or RSU Admin sees the operational workflows),
**And** the page shows placeholder summary tiles (JOH count, pending absences, vacancies, payments — all showing "—" or "loading" at this stage, with real figures landing once the relevant features are built),
**And** a contextual help link is present in the footer.

**Given** the user is signed in,
**When** they click sign-out,
**Then** the sign-out flow runs against the stand-in sign-in service,
**And** the user is redirected back to `ctam-ui` and lands on an unauthenticated landing page,
**And** the access token and refresh token are cleared from client storage.

**Given** the user's activation record shows their jurisdiction-and-region combination hasn't gone live on CTAM Pathfinder yet,
**When** they land on Home,
**Then** they see a banner reading exactly *"Your jurisdiction/region has not yet moved to CTAM Pathfinder. Please continue using your current system,"* and the workflow navigation is disabled — the full process for switching regions on is planned for much later in the programme; in the meantime, people keep using whichever system they use today (not yet identified for Employment Tribunals, tracked under the placeholder `[ET-INCUMBENT-TBD]`; ListAssist for SSCS; and the Oracle APEX application for the Courts waves that follow after that).

**Given** the automated accessibility scan runs on the rendered Home page,
**When** the page is in a steady state,
**Then** no new WCAG 2.2 AA violations are reported,
**And** keyboard navigation works through the header, the region/area selector, the primary navigation, and the tiles,
**And** focus indicators are visible throughout.

**Given** the end-to-end test suite for this phase runs,
**When** `tests/e2e/phase-1-foundation.spec.ts` executes,
**Then** it covers: an unauthenticated user being redirected → signing in via the stand-in service (one JOH user and one admin-staff user) → Home rendering with role-scoped navigation → the activation banner showing for a not-yet-activated jurisdiction/region → the sign-out flow,
**And** all assertions pass against the development deployment.

**Given** this phase's demonstration milestone,
**When** the engineering lead runs the walkthrough,
**Then** they can show a stakeholder the whole chain working together: the platform foundations and shared cloud environment set up earlier, judge and tribunal-member data flowing in from the eLinks and MRD data feeds, the authorisation service scaffold, signing in through the stand-in sign-in service, authorisation being correctly enforced for both populations of user, the web application foundation, and — the subject of this story — the complete end-to-end sign-in flow,
**And** the Postman collection `ctam-authorisation-phase0.postman_collection.json` exercises `POST /v1/authz/check` (for both populations, and for a principal that can't be resolved) and `GET /v1/users/{id}/effective-permissions`, run against the development deployment.
