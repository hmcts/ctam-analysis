---
type: 'Epic'
description: 'The shared cloud platform that every CTAM Pathfinder service will run on — the Kubernetes cluster, the shared database, the container registry, the API gateway, application monitoring, and the secrets vault — is built in its own dedicated repository, one layer at a time, with each layer proven to actually work before the next one is added or before any other team starts building on top of it.'
resource: 'epics/phase-1/epic-1.0-platform-estate-provisioned.html'
tags: [ctam-pathfinder, epics, phase-1, infrastructure]
timestamp: '2026-07-06'
parent: 'epics/phase-1/index.md'
epic: 1.0
title: 'Platform estate is provisioned, verifiable, and CNP-compliant'
storyCount: 5
repo: ctam-shared-infrastructure
depends_on: []                              # nothing precedes the estate
---

# Epic 1.0: Platform estate is provisioned, verifiable, and CNP-compliant

**Business Goal:** Before any CTAM Pathfinder service can be built, tested, or switched on, there needs to be somewhere for it to actually run — a cluster of servers, a shared database, a place to store container images, a secure front door for API traffic, a way to watch what's happening once it's live, and a safe place to keep passwords and secrets. This epic builds that shared foundation once, properly, and proves every piece of it genuinely works before the first real service — the judicial reference-data service — starts building on top of it. Getting this right up front means later teams inherit a platform they can trust, rather than discovering gaps in it mid-build, which would be far more expensive to fix once other work depends on it. It also follows the government's standard way of organising this kind of shared infrastructure: kept in its own repository, separate from any single service, so it can be looked after and changed independently.

**What this covers:** This is delivered as five stories, each adding one layer of the platform in order: first the repository itself and the safe way changes to it get reviewed and applied; then the Kubernetes cluster that everything will run on; then the shared database and the secrets vault; then the container registry and the monitoring setup; and finally the API gateway that the outside world will actually talk to. Every layer comes with its own hands-on check — run immediately after it's built — so a problem is caught the moment it's introduced, not months later when a real service tries to deploy and fails.

**Outcome:** The shared cloud estate — a Kubernetes cluster, a shared PostgreSQL database, a container image registry, a secure API gateway, application monitoring, and a secrets vault — is built using Terraform (infrastructure defined as code, not clicked together by hand) in its own dedicated repository, `ctam-shared-infrastructure`. It's built layer by layer, and each layer is checked and proven working as it lands, so that every early service — starting with the judicial reference-data service, then authorisation, notifications, and the user interface — has a genuinely tested platform to deploy onto, rather than an assumption that the infrastructure will behave as expected.

**Hosting:** The shared estate lives in its own repository, `ctam-shared-infrastructure`, rather than being tucked inside the first service that happens to need it. Each individual service repository still keeps its own small, service-specific infrastructure (for example, the separate storage account the reference-data service needs for its own weekly data drop) — only the infrastructure genuinely shared across the whole programme lives in the shared repository.

**What's included:**
- A new, dedicated repository, `ctam-shared-infrastructure`, set up by hand through the GitHub website following the programme's standard setup checklist (the `gh` command-line tool isn't available, so this step can't be scripted)
- Everything is defined in Terraform only — no point-and-click portal changes — with a safely-stored history of what's been built (its "state"), and separate, isolated setups for the development, staging, and production environments
- The shared estate itself, built up in order: the Kubernetes cluster spread across multiple UK South data centres for resilience, then the shared PostgreSQL database (also spread for resilience) and the secrets vault, then the container image registry and the monitoring/logging setup, and finally the API gateway that fronts everything
- Every layer comes with its own hands-on check performed right after it's built, so the platform is verified as it's assembled rather than assumed to work

**Technical requirements confirmed along the way:** every request that reaches the API gateway must use an encrypted (TLS) connection; data stored in the database must be encrypted at rest; passwords and secrets are held only in the vault, never committed to code; the platform emits structured logs and health checks into the monitoring system from day one; everything runs in Azure's UK South region to keep data within the UK; and every future service must be deployable onto this shared Kubernetes cluster.

**Why this matters:** This work doesn't deliver a customer-facing feature by itself — it's the foundation everything else in the early phases stands on. The cluster, database, registry, gateway, and monitoring were always going to be needed before the reference-data service could be built; treating them as their own proven, tested piece of work (rather than something assembled informally along the way) means the platform is validated on its own terms first, and the reference-data service stays focused purely on its own domain rather than also carrying the shared plumbing.

**Explicitly out of scope:** Setting up the reference-data service itself, or any other domain service — those come next, once this foundation exists. Any service's own small, service-specific infrastructure — that stays in that service's own repository. Rolling any of this out to a live production region — that's a later-phase decision, gated separately. The database baseline configuration values used across the programme — that's owned separately and lands before the reference-data service is built.

---

## Story 1.0.1: The shared repository and its safe change-management process are set up

As a **platform engineer**,
I want the dedicated `ctam-shared-infrastructure` repository set up correctly from day one, with a working way to safely store and track infrastructure changes, separate setups per environment, and an automated pipeline that checks and applies changes,
So that **the shared estate has a proper home with safe, reviewed, tracked change management before a single piece of it is actually built**.

**Acceptance Criteria:**

**Given** the engineer has completed the manual GitHub setup checklist before doing anything else —
  - creating the `ctam-shared-infrastructure` repository under the HMCTS organisation through the GitHub website (following the standard naming pattern for shared programme infrastructure),
  - turning on branch protection for `main` (pull-request review required, automated checks required, linear history required),
  - setting up `CODEOWNERS` so changes are routed to the platform/infrastructure team,
  - noting that the `gh` command-line tool isn't available, so all of this GitHub setup is done by hand through the website, following the documented runbook,
**When** the engineer lays down the Terraform structure,
**Then** the repository contains separate folders for the development, staging, and production environments, each with pinned versions of the Azure provider it uses,
**And** a remote, shared place to safely store the infrastructure's tracked state is configured (an Azure Storage account and container, following the agreed pattern),
**And** an automated check runs on every pull request that formats and validates the Terraform code and previews what it would change,
**And** a separate, gated step applies changes only once code is merged into `main`, per environment, requiring a manual approval step for staging and production,
**And** a code-ownership file and a pull-request checklist template both exist to guide reviewers.

**Given** the Terraform structure is in place but nothing has actually been built yet,
**When** the engineer opens a pull request,
**Then** the validation check passes and the preview shows a clean, empty result (nothing to change) in the automated pipeline,
**And** once merged, an empty "apply" run against the development environment succeeds and safely records that nothing has been built yet,
**And** the whole run is visible in the pipeline logs, with the preview output attached to the pull request for reviewers to see.

**Explicitly not in scope:**
- Actually building any Azure resources — that's the next four stories
- Setting up any service's own repository — that comes later, once this foundation exists

---

## Story 1.0.2: The network and the Kubernetes cluster are built and checked (development environment)

As a **platform engineer**,
I want the resource group, network, and Kubernetes cluster built through Terraform in the UK South region,
So that **there is a proven, resilient place for every CTAM Pathfinder service to run, checked and working before anything is deployed onto it**.

**Acceptance Criteria:**

**Given** the repository and its change-management process are set up as described in the previous story,
**When** the engineer adds the networking and cluster setup and applies it to the development environment,
**Then** a resource group, virtual network, and subnets are created in the UK South region,
**And** a Kubernetes cluster is built with its worker machines spread across multiple availability zones for resilience,
**And** the cluster and machine sizes match the agreed early-phase baseline,
**And** engineers can retrieve access to the cluster through their own Azure sign-in rather than a shared static password.

**Given** the cluster has been built,
**When** the engineer checks it by running a standard cluster-status command,
**Then** every node reports as ready and is spread across the different availability zones,
**And** a simple throwaway test workload can be started on the cluster and successfully respond to a request sent to it from inside the cluster,
**And** this check is written down as a repeatable verification step that can be run by hand or as part of the pipeline — so the cluster is proven working, not just assumed to be.

**Explicitly not in scope:**
- The database, secrets vault, container registry, monitoring, and API gateway — those are the next three stories
- Deploying any actual CTAM service onto the cluster — that comes later, once this foundation exists

---

## Story 1.0.3: The shared database and secrets vault are built and checked (development environment)

As a **platform engineer**,
I want a shared PostgreSQL database and a secrets vault built through Terraform, with the cluster wired up to read from the vault securely,
So that **services have an encrypted, secure shared database and a safe place to keep secrets — proven reachable and working from inside the cluster before any service actually needs them**.

**Acceptance Criteria:**

**Given** the cluster from the previous story exists,
**When** the engineer adds the database and vault setup and applies it to the development environment,
**Then** a PostgreSQL database is provisioned with a resilient, zone-spread setup, with its stored data encrypted at rest, and set up so that only encrypted connections are accepted and any unencrypted connection attempt is refused,
**And** a secrets vault is provisioned with protections against accidental or malicious permanent deletion,
**And** the cluster is configured so that workloads running on it can securely read secrets from the vault without needing a stored password of their own,
**And** no database or vault secrets are ever committed into the repository — everything sensitive lives only in the vault.

**Given** the database and vault have been built,
**When** the engineer runs the verification from a workload running inside the cluster,
**Then** an encrypted connection to the database succeeds, and an unencrypted connection attempt is correctly refused,
**And** a scratch database can be created and then removed again, confirming basic connectivity and permissions work as expected,
**And** a test secret written into the vault can be successfully read back by the workload using its secure identity, confirming the secret-reading setup genuinely works,
**And** these checks are written down as repeatable verification steps.

**Explicitly not in scope:**
- The individual database access permissions each service will need, and the shared baseline configuration values used across the programme — those are set up separately, ahead of the reference-data service being built
- The container registry, monitoring, and API gateway — the next two stories

---

## Story 1.0.4: The container registry and monitoring setup are built and checked (development environment)

As a **platform engineer**,
I want a container image registry and an application-monitoring setup built through Terraform and connected to the cluster,
So that **there's a proven way to distribute container images and a proven place for logs and traces to land, before any service ships a container or writes a log line**.

**Acceptance Criteria:**

**Given** the cluster exists as described in the earlier story,
**When** the engineer adds the registry and monitoring setup and applies it to the development environment,
**Then** a container image registry is provisioned, with a resilient setup, and the cluster is granted permission to pull images from it using its own managed identity rather than a stored registry password,
**And** an application-monitoring workspace (backed by a log-analytics store) is provisioned in the UK South region,
**And** how long logs are kept is set to the agreed early-phase default of 90 days for non-production environments (subject to final confirmation), configured through Terraform,
**And** the connection details for the monitoring workspace are stored in the vault, not committed to the repository.

**Given** the registry and monitoring setup have been built,
**When** the engineer runs the verification,
**Then** a test container image can be pushed to the registry and then successfully pulled back down into the cluster, confirming the image supply chain works end to end,
**And** a test trace and a structured log entry sent from a workload running inside the cluster both show up in the monitoring workspace within the expected time window, confirming the logging and tracing pipeline genuinely works,
**And** these checks are written down as repeatable verification steps.

**Explicitly not in scope:**
- Dashboards or alerts specific to any individual service — those get added as each service is built
- The API gateway — the next story

---

## Story 1.0.5: The API gateway is built and checked end to end (development environment)

As a **platform engineer**,
I want the API gateway built through Terraform, with baseline security policies and a simple test API, so it can be proven working end to end,
So that **the shared public-facing gateway is proven to handle encrypted traffic and correctly route it into the cluster, before any real service publishes an API through it**.

**Acceptance Criteria:**

**Given** the cluster exists as described in the earlier story,
**When** the engineer adds the gateway setup and applies it to the development environment,
**Then** an API gateway is provisioned, with a resilient setup and baseline policies in place — encrypted connections terminated at the latest supported security level, a tracking identifier passed through on every request, and sensible default limits on how many requests can be made,
**And** a simple test API is registered on the gateway, pointing at a basic echo service running inside the cluster,
**And** any request made over an unencrypted connection is rejected or automatically redirected to an encrypted one.

**Given** the gateway and the test API have been set up,
**When** the engineer calls the test operation through the gateway,
**Then** the call succeeds over an encrypted connection and gets a response back from the echo service running inside the cluster, confirming the whole path from the outside world into the cluster works end to end,
**And** a request made using a connection weaker than the platform's minimum accepted security level is correctly refused, checked automatically as part of the pipeline,
**And** a call made to a protected route without the right credentials is correctly rejected,
**And** these checks are written down as repeatable verification steps.

**Given** all five layers have now been built,
**When** the engineer reviews the finished development environment,
**Then** the complete shared estate — cluster, database, secrets vault, registry, monitoring, and gateway — exists in the UK South region, with every layer independently checked and proven working,
**And** the platform is ready for the team building the judicial reference-data service to set up their own service and deploy it onto this foundation.

**Explicitly not in scope:**
- Registering any individual service's own API on the gateway — each service publishes its own, once it exists
- Building any domain service itself — that comes next, once this foundation exists
