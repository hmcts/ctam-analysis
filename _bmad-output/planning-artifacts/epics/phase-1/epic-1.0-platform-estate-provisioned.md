---
type: 'Epic'
description: 'The shared cloud platform that every CTAM Pathfinder service will run on — the Kubernetes cluster, the shared database, the container registry, the API gateway, application monitoring, and the secrets vault — is built in its own dedicated repository, one layer at a time, with each layer proven to actually work before the next one is added or before any other team starts building on top of it.'
resource: 'epics/phase-1/epic-1.0-platform-estate-provisioned.html'
tags: [ctam-pathfinder, epics, phase-1, infrastructure]
timestamp: '2026-07-06'
parent: 'epics/phase-1/index.md'
epic: 1.0
title: 'Platform estate is provisioned, verifiable, and CNP-compliant'
storyCount: 0
repo: ctam-shared-infrastructure
depends_on: []                              # nothing precedes the estate
---

# Epic 1.0: Platform estate is provisioned, verifiable, and CNP-compliant

**Business Goal:** Before any CTAM Pathfinder service can be built, tested, or switched on, there needs to be somewhere for it to actually run — a cluster of servers, a shared database, a place to store container images, a secure front door for API traffic, a way to watch what's happening once it's live, and a safe place to keep passwords and secrets. This epic builds that shared foundation once, properly, and proves every piece of it genuinely works before the first real service — the judicial reference-data service — starts building on top of it. Getting this right up front means later teams inherit a platform they can trust, rather than discovering gaps in it mid-build, which would be far more expensive to fix once other work depends on it. It also follows the government's standard way of organising this kind of shared infrastructure: kept in its own repository, separate from any single service, so it can be looked after and changed independently.

**What this covers:** This is planned as five stages (not yet decomposed into stories), each adding one layer of the platform in order: first the repository itself and the safe way changes to it get reviewed and applied; then the Kubernetes cluster that everything will run on; then the shared database and the secrets vault; then the container registry and the monitoring setup; and finally the API gateway that the outside world will actually talk to. Every layer comes with its own hands-on check — run immediately after it's built — so a problem is caught the moment it's introduced, not months later when a real service tries to deploy and fails.

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

