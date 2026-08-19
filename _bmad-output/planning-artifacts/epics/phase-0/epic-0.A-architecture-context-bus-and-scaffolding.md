---
type: 'Epic'
description: 'User outcome: ctam-architecture is published as the version-pinned context bus (arch-v1.0), the ctam-scaffold.sh toolchain assembles a conformant service repo from the minimal HMCTS starter, and the GitHub + Terraform runbooks exist — so every later Phase 0 story has the enablement it already assumes…'
resource: 'epics/phase-0/epic-0.A-architecture-context-bus-and-scaffolding.html'
tags: [ctam-pathfinder, epics, phase-0, platform, scaffolding]
timestamp: '2026-08-18'
parent: 'epics/phase-0/index.md'
epic: 0.A
title: 'Context bus published, scaffolding toolchain built, and platform runbooks written'
storyCount: 3
---

# Epic 0.A: Context bus published, scaffolding toolchain built, and platform runbooks written

**User outcome:** `ctam-architecture` exists as a real repo and is published as the **version-pinned context bus** (tagged `arch-v1.0`) that every service repo consumes as a submodule; the **`ctam-scaffold.sh`** toolchain assembles a fully conformant service repo from the deliberately-minimal HMCTS Crime SpringBoot template; and the two platform runbooks every other Phase 0 story opens with — **`runbooks/github-setup.md`** (manual GitHub web-UI setup, AR51) and **`runbooks/terraform.md`** (state backend, plan/apply, cross-repo remote-state conventions) — are written and agreed. So that **every subsequent Phase 0 and Phase 0-Mock story has the enablement it already assumes in its first Given clause**, rather than depending on undeclared work.

**Hosting:** `ctam-architecture` — the **context bus** in the delivery operating model. This epic holds no deployable workload and owns no table in the shared schema. It is the only Phase 0 epic that precedes **Epic 0.0**.

**Why this epic exists (and why it is lettered, not numbered):** eight stories across Phase 0 and Phase 0-Mock open with *"the engineer has performed the GitHub manual-setup checklist (`ctam-architecture/runbooks/github-setup.md`)"* and five of them continue *"…runs `ctam-scaffold.sh {service}`"* — Stories 0.0.1, 0.2.1, 0.4.1, 0.4.2, 0.8.1, 0M.1.1, 0M.2.1. `ctam-scaffold.sh` is recorded as a **Phase 0 deliverable** in gaps.md **G1.4a**/**G1.4b**, and the bus publish + `arch-v1.0` tag is step 1 of the bootstrapping order in `architecture/delivery-operating-model.md`. None of it had an epic, a story, a ledger shard, or an owner: it sat inside the `arch-baseline` dispatch-graph node, marked `decomposed: false`, whose note covered only the `ctam_configuration_values` table. Lettering (`0.A`) rather than inserting at `0.0` keeps all 23 existing Phase 0 story ids stable — the same convention already used for the `0M.` tier (SCP 2026-08-18c, decision #18). **Sequencing is the graph, never the letter.**

**Why the DB baseline is a separate epic (0.B):** the shared `ctam_configuration_values` baseline and the per-service DB roles are also `ctam-architecture`-owned, but they cannot be applied until Epic 0.0 Story 0.0.3 has provisioned PostgreSQL — while *this* epic must precede Epic 0.0 Story 0.0.1. Keeping both in one epic would make `epic-0.0` and the `ctam-architecture` node mutually dependent — a cycle under the buildable-now rule. They are therefore split: **0.A precedes Epic 0.0; [Epic 0.B](epic-0.B-shared-db-baseline-and-service-roles.md) follows it.**

**Vertical slice:**
- **New repo `ctam-architecture`**, created per the manual GitHub web-UI runbook (AR51 — the `gh` CLI is **not** available), carrying the canonical architecture set published from `ctam-analysis`, tagged **`arch-v1.0`** — the `bus_version` every ledger shard already records
- **`ctam-scaffold.sh`** + the starter-template overlay inventoried in `architecture/starter-template.md` §B: the ~9 capabilities the minimal base does **not** provide (Liquibase, Testcontainers, MapStruct, `JWTFilter` + `jjwt`, OWASP encoder, docker-compose plugin, OpenAPI tooling, Spring Cloud Azure Key Vault, the CI quality gates), plus the Helm chart and per-repo `terraform/` skeleton
- **The CI ruleset bundle** the scaffold wires into every repo it creates: ArchUnit conventions (G4.4), the Spectral OpenAPI ruleset (G4.5), Spotless/Checkstyle, SQLFluff, and the schema-convention fitness function authored in **Epic 0.1, Story 0.1.2** — so a repo scaffolded in Phase 3 picks up the same gates as `ctam-reference-data` without re-deriving them
- **`runbooks/github-setup.md`** (AR51) and **`runbooks/terraform.md`** (gaps.md **G9.1**, **G10.1**, **G10.2** — state backend, per-environment stack isolation, who runs plan/apply, production approval gating, and the cross-repo remote-state/data-source pattern a service's `terraform/` needs to reference the shared estate)

**FRs covered:** none — this is programme enablement with no functional-requirement surface. It is the layer every Phase 0 FR is delivered *through*.

**Key NFRs first exercised here:** none newly introduced. The scaffold is where NFR25–NFR28 (structured logs, App Insights ingestion, probes), NFR39 (API-as-Product tooling) and NFR40 (per-service deployable) become **repeatable** rather than per-repo effort.

**Architecture requirements:** AR2–AR17 (the scaffold assembles them), AR24 (Helm chart), AR28–AR32, AR41, AR51 (manual GitHub setup — non-negotiable), AR53 (revised — per-repo `terraform/` skeleton); gaps.md G1.4, **G1.4a**, **G1.4b**, G4.4, G4.5, **G9.1**, **G10.1**, **G10.2**; `architecture/starter-template.md` §B; `architecture/delivery-operating-model.md` (context bus + bootstrapping order).

**Out of scope (explicitly):** the shared `ctam_configuration_values` Liquibase baseline, per-service DB roles, and the grants convention — **[Epic 0.B](epic-0.B-shared-db-baseline-and-service-roles.md)** (they need the Epic 0.0 PostgreSQL server). Provisioning any Azure resource (Epic 0.0). Scaffolding any actual service repo — each service's scaffold run is a story in its own epic (0.2.1, 0.4.1, 0.4.2, 0.8.1, 0M.2.1); this epic delivers the **tool**, not its invocations. The schema-convention fitness function itself (**Epic 0.1, Story 0.1.2** — this epic wires it into the scaffold). The `reference-data-maintenance.md` (Story 0.5.1) and `identity-bootstrap.md` (Story 0.7.1) runbooks — authored by the stories whose domain they document, into this repo.

---

## Story 0.A.1: Publish `ctam-architecture` as the version-pinned context bus and tag `arch-v1.0`

As **every service repo that will consume shared architecture** (and the control plane that pins a version against each story),
I want `ctam-architecture` created and published with the canonical architecture set, tagged `arch-v1.0`, and consumable as a submodule,
So that **`bus_version: arch-v1.0` — already recorded against all 27 Phase 0 and Phase 0-Mock stories in the ledger — refers to something that exists**, and every repo reads one pinned truth instead of a copy.

**Acceptance Criteria:**

**Given** the engineer has performed the GitHub manual-setup checklist for `ctam-architecture` (Story 0.A.3 — private repo created via the **GitHub web UI**, branch protection on `main`, `CODEOWNERS` scoped to the architecture team; the `gh` CLI is **not** available per AR51),
**When** the canonical architecture set is published from `ctam-analysis`,
**Then** the repo carries the published architecture per `architecture/repo-structure.md`'s `ctam-architecture` layout — `architecture/` (the sharded set incl. `conventions.md`, `data-tables.md`, `delivery-operating-model.md`, `repository-strategy.md`), `decisions/` (ADRs), `runbooks/`, and `scaffolding/`,
**And** the publish is a **one-way projection** from `ctam-analysis` (the canonical author) into `ctam-architecture` (the published mirror) — the direction of travel is documented in the repo README so no one edits architecture in the bus and expects it to survive,
**And** the OpenAPI contract directory is present and documented as a **read-only mirror** of producer-published artefacts (per SCP 2026-07-07) — contracts are owned by their producing service, never authored here.

**Given** the architecture set is published,
**When** the engineer tags the repo,
**Then** the tag **`arch-v1.0`** exists and is the version every Phase 0 story packet pins (matching `bus_version` in `delivery/dispatch-graph.yaml` and all 12 ledger shards),
**And** a `CHANGELOG` or release note records what `arch-v1.0` contains, so a later bus bump is a reviewable diff rather than a moving target,
**And** the submodule consumption pattern is documented: how a service repo wires `_arch/` plus its own `CLAUDE.md`, and that **re-syncing is an explicit submodule bump**, never automatic.

**Given** the bus is tagged,
**When** the control plane dispatches its first story packet,
**Then** the packet's pinned `bus_version` resolves to the `arch-v1.0` tag,
**And** `_bmad-output/project-context.md` is confirmed as the seed for each service repo's `CLAUDE.md` at the pinned version (per its own Usage Guidelines).

**References:** `architecture/delivery-operating-model.md` (context bus; bootstrapping order step 1); `architecture/repo-structure.md`; AR51; SCP 2026-07-07 (contracts are a read-only mirror).

**Explicitly NOT in scope:**
- `ctam-scaffold.sh` — Story 0.A.2
- The runbooks — Story 0.A.3
- The `ctam_configuration_values` baseline and per-service DB roles — Epic 0.B

---

## Story 0.A.2: Build `ctam-scaffold.sh` and the starter-template overlay

As a **platform engineer scaffolding any CTAM Pathfinder service**,
I want `ctam-scaffold.sh` to assemble a fully conformant service repo from the minimal HMCTS Crime SpringBoot template — including every capability the base template omits and every CI gate the programme enforces,
So that **the five stories that invoke it (0.2.1, 0.4.1, 0.4.2, 0.8.1, 0M.2.1) each get an identical, version-pinned baseline** instead of the first service defining conventions the rest re-derive by hand.

**Acceptance Criteria:**

**Given** the HMCTS Crime SpringBoot template base is **deliberately minimal** (reconciled 2026-06-17 per gaps.md **G1.4** — it provides Java 25, Spring Boot 4.1.0, Gradle Groovy DSL, Logstash JSON logging, OpenTelemetry, Lombok, JaCoCo, CycloneDX, gradle-git-properties, ben-manes-versions, Actuator, Dockerfile, `webmvc-test`),
**When** the engineer builds `ctam-scaffold.sh` in `ctam-architecture/scaffolding/`,
**Then** the script overlays every capability listed in `architecture/starter-template.md` §B that the base omits (per **G1.4a**, **G1.4b**): **Liquibase** (a CTAM convention — the HMCTS demo repo's Database branch uses Flyway; **Flyway must not be used**), Testcontainers, MapStruct, the custom `JWTFilter` + `jjwt`, the OWASP Java Encoder, the gradle-docker-compose plugin, springdoc OpenAPI tooling, and `spring-cloud-azure-starter-keyvault-secrets`,
**And** it lays down the **Helm chart** (`charts/{service}/` with `values-dev|staging|production.yaml`, probes, `topologySpreadConstraints` per AR24) and the per-repo **`terraform/`** skeleton with `dev`/`staging`/`production` stacks holding **only that service's own resources** (AR53 revised),
**And** it lays down `.github/workflows/ci.yml` + `deploy-dev|staging|production.yml` (AR28), `CODEOWNERS`, `PULL_REQUEST_TEMPLATE.md` (AR29), and the `postman/` collection skeleton (AR41),
**And** the versions the script pins match the inventory in `architecture/starter-template.md` §B — **one place**, so a version bump is a single reviewable change rather than a sweep across service repos,
**And** the demo-repo branch versions the overlay cherry-picks from are **verified at build time**, not assumed (per G1.4a).

**Given** the programme enforces CI gates in every repo,
**When** the scaffold runs,
**Then** it wires the shared ruleset bundle into the new repo's `ci.yml`: **ArchUnit** convention checks (gaps.md **G4.4**), the **Spectral** OpenAPI ruleset for the API-as-Product standards (**G4.5** — error envelope, RFC 9457 references, `/v1/` versioning prefix, `Deprecation`/`Sunset` headers), **Spotless + Checkstyle**, **SQLFluff**, and the **schema-convention fitness function authored in Epic 0.1, Story 0.1.2**,
**And** the rulesets live in `ctam-architecture` and are **referenced** by each repo at the pinned bus version — not copied per repo, so a rule change does not require editing 15 repos,
**And** the script records, in the repo it creates, which bus version its rulesets came from.

**Given** the `gh` CLI is **not** available in the engineering environment (AR51),
**When** the engineer runs the script,
**Then** it operates **locally only**, then pushes to a remote the engineer has **already created manually via the GitHub web UI**, on a feature branch, via plain `git`,
**And** it makes no GitHub API call and attempts no repo creation, no branch-protection change, and no PR operation,
**And** it fails with a clear diagnostic if the pre-created remote is absent, pointing at `runbooks/github-setup.md`.

**Given** the script is complete,
**When** it is validated before the first real service uses it,
**Then** a throwaway scaffold run produces a project that builds, passes every wired CI gate, serves `/actuator/health` `200 OK`, and emits structured JSON logs with a `correlationId` — the same baseline Story 0.2.1 asserts,
**And** the throwaway repo is discarded; **`ctam-reference-data` (Story 0.2.1) remains the first real service scaffolded**.

**References:** AR2–AR17, AR24, AR28, AR29, AR41, AR51, AR53 (revised); gaps.md **G1.4**, **G1.4a**, **G1.4b**, **G4.4**, **G4.5**; `architecture/starter-template.md` §B; `architecture/conventions.md`; depends on Story 0.1.2 for the schema fitness function it wires (the wiring is here; the rule authoring is there).

**Explicitly NOT in scope:**
- Any actual service scaffold run — Stories 0.2.1, 0.4.1, 0.4.2, 0.8.1, 0M.2.1
- `ctam-shared-infrastructure`'s Terraform skeleton — **Story 0.0.1** lays that down directly; it is Terraform-only with no Java workload, so `ctam-scaffold.sh` does **not** apply to it
- `ctam-joh-mock` — adopted brownfield in Node/Express, the one documented AR2–AR17 exception (AR55.1, Epic 0M.1); it is never scaffolded by this script
- The schema-convention ruleset itself — Epic 0.1, Story 0.1.2

---

## Story 0.A.3: Write the GitHub-setup and Terraform-conventions runbooks

As **every engineer who creates a repo or applies infrastructure in this programme**,
I want the manual GitHub-setup checklist and the Terraform conventions written down in `ctam-architecture/runbooks/`,
So that **the eight stories that open by citing `runbooks/github-setup.md` cite a document that exists**, and the Terraform questions blocking the Epic 0.0 apply (gaps.md G9.1, G10.1, G10.2) are answered once, in one place, before the first `terraform apply`.

**Acceptance Criteria:**

**Given** the `gh` CLI is **not** available and all GitHub admin work is manual (AR51 — a non-negotiable constraint of the engineering environment),
**When** the engineer writes `runbooks/github-setup.md`,
**Then** it documents, as a checklist an engineer can follow without prior context: creating the private repo under the HMCTS org **via the web UI** with the CTAM naming convention, enabling branch protection on `main` (require PR review, require status checks, require linear history), setting team access and `CODEOWNERS`, and the **manual PR-open and merge** steps,
**And** it states explicitly that `ctam-scaffold.sh` performs **no** GitHub admin operation, so the manual steps are never assumed to be automated,
**And** every Phase 0 / Phase 0-Mock story that cites this runbook resolves against the checklist it actually contains (0.0.1, 0.2.1, 0.4.1, 0.4.2, 0.8.1, 0M.1.1, 0M.2.1, and Story 0.A.1's own repo creation).

**Given** Terraform is mandated for all Azure provisioning (2026-06-11 decision) and three gaps block the first apply,
**When** the engineer writes `runbooks/terraform.md`,
**Then** it records the **agreed** answers to gaps.md **G9.1**: the state backend (Azure Storage backend per HMCTS convention vs Terraform Cloud), state isolation per environment stack, who runs plan/apply (per-repo GitHub Actions vs the platform team), and production approval gating,
**And** it records the agreed answer to **G10.1**: the DDoS Protection tier and **who owns/pays for the WAF policy** (product team via `ctam-shared-infrastructure` Terraform vs an HMCTS-central security-managed policy),
**And** it records the agreed **cross-repo reference pattern** for **G10.2**: how a service repo's own `terraform/` resolves the shared estate's outputs — private DNS zones, AKS managed identity, APIM instance id — via remote state or data sources, since every service repo needs this from `ctam-reference-data` (Epic 0.2) onward,
**And** it records the **per-service APIM registration ownership rule** (AR53 clarification, see `architecture/conventions.md`): the **shared** APIM instance and base policies belong to `ctam-shared-infrastructure`; each **service's own API definition and per-API policy** belong to that service's `terraform/`, applied against the shared instance by the documented cross-repo reference pattern,
**And** each answer is marked **agreed with HMCTS** (with date and named contact) or **outstanding** — an outstanding answer is a tracked blocker on Story 0.0.1, not silent inheritance of a default.

**Given** the runbooks are written,
**When** an engineer follows either one end-to-end,
**Then** no step requires knowledge held only by its author,
**And** both are linked from `ctam-architecture`'s README and from the Phase 0 index, so they are discoverable at the point of use,
**And** the remaining two Phase 0 runbooks are noted as authored by their own stories into this repo — `reference-data-maintenance.md` (Story 0.5.1) and `identity-bootstrap.md` (Story 0.7.1).

**References:** AR51 (manual GitHub setup), AR53 (revised — per-repo Terraform; APIM ownership clarification), AR27, AR39; gaps.md **G9.1**, **G10.1**, **G10.2**; D10 (`gh` CLI not available).

**Explicitly NOT in scope:**
- Applying any Terraform — Epic 0.0
- The `reference-data-maintenance.md` runbook (Story 0.5.1) and the `identity-bootstrap.md` runbook (Story 0.7.1) — authored by those stories, into this repo
