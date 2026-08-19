---
type: 'Delivery Pilot Findings'
title: 'Pilot 0.5 findings — running log'
description: 'Findings from the delivery-method pilot, recorded as they are discovered. Seeded during the scaffold phase, before any story code was written. The findings are the deliverable; the code is the by-product.'
tags: [ctam-pathfinder, delivery, pilot, findings]
timestamp: '2026-08-19'
parent: 'delivery/pilots/README.md'
last_updated: 2026-08-19
---

# Pilot 0.5 findings — running log

Findings are recorded **as discovered**, not written up at the end. Each carries what it affects and what it would take to close. `F1–F9` below were all found during **dispatch and scaffold — before a line of story code existed**, which is itself the first result: most of what the pilot has to say about the method surfaced before any TDD happened.

Status vocabulary: `open` · `needs-decision` · `fixed` · `accepted` (a known limitation nobody intends to change).

## Scaffold-phase findings

### F1 — the template's own setup script would make the repository public

`setup-new-repo.sh` in `hmcts/service-hmcts-crime-springboot-template` performs five steps, the last of which is **"Make the repository public"**, and it requires the `gh` CLI. CTAM repositories must be **private**. The script was therefore **excluded from the scaffold**, and the GitHub-side setup (rulesets, team access, secret scanning) it would have automated has to be done by hand.

Separately, [`starter-template.md`](../../architecture/starter-template.md) claims the base template provides "Shell init/rename scripts" and shows `./scripts/rename uk.gov.hmcts.ctam.{service-name}`. **No such script exists.** Package renaming is a manual find-and-replace plus directory moves.

- **Affects:** `starter-template.md` §A, Epic 0.5.1's AC (which references `ctam-scaffold.sh`), G1.4a
- **To close:** correct `starter-template.md`; make `ctam-scaffold.sh` do the rename itself and never call `setup-new-repo.sh`; write down the manual GitHub-setup steps that script would have covered
- **Status:** `open`

### F2 — the template's structural linter is PMD, not Checkstyle

The baseline ships `gradle/pmd.gradle` + `.github/pmd-ruleset.xml`. `starter-template.md` §A does not mention PMD at all, and §B lists Spotless and Checkstyle as CTAM additions — so CTAM now has **two** structural linters with overlapping concerns.

They coexist mechanically (the template's `pmdMain` only runs when explicitly invoked, `pmdTest` is disabled, and `pmd.gradle` already configures `tasks.withType(Checkstyle)`), but nobody has decided which one owns which rule, and two rule sets can disagree.

- **Affects:** `starter-template.md` §A/§B, `conventions.md` → *Pattern enforcement mechanisms*, `agent-rules/enforcement/`
- **To close:** decide — Checkstyle as the CTAM structural gate with PMD left dormant (current de-facto position), or adopt PMD and port the M-series limits to `pmd-ruleset.xml`
- **Status:** `needs-decision`

### F3 — the template's house pattern is spec-as-input; CTAM's is spec-as-output

The template carries an `apiSpec` Gradle configuration (`gradle/apispec-validation.gradle` validates that `apiSpec` dependencies use fixed `X.Y.Z` versions, and `gradle/test.gradle` passes `API_SPEC_VERSION` into the test JVM). That is the shape of a service that **consumes a published OpenAPI spec artefact** — spec-first.

CTAM's conventions (AR8) go the other way: the spec is **generated from the code** by Swagger Core and published as `uk.gov.hmcts.ctam:api-ctam-{service}`. Both models distribute specs as versioned artefacts, so this is not a contradiction — but CTAM is working against the template's grain and gets no spec tooling for free. The pilot had to add springdoc itself and generate the spec from a test.

- **Affects:** AR8, `conventions.md`, `agent-rules/30-api-contracts.md` (C1, C5)
- **To close:** an explicit decision recorded in the architecture: stay code-first and accept the overlay cost, or adopt the template's spec-first pattern. The choice affects all twelve Java repos and the two UIs that generate clients
- **Status:** `needs-decision`

### F4 — G1.4a confirmed precisely

Absent from the baseline `build.gradle`, as G1.4a predicted: OpenAPI tooling, validation starter, PostgreSQL driver, Liquibase, Testcontainers, MapStruct, `jjwt`, OWASP encoder, docker-compose plugin, Spotless, Checkstyle, ArchUnit, Pact. Present and correctly documented: Java 25, Spring Boot 4.1.0, Gradle Groovy DSL + wrapper, Logstash encoder 9.0, Lombok, Actuator, OpenTelemetry, JaCoCo, `maven-publish`, CycloneDX, git-properties, ben-manes-versions, pinned `tomcat-embed-core`.

- **Affects:** G1.4, G1.4a — both accurate on this point
- **Status:** `accepted` (documentation matches reality)

### F5 — JDK 25 is a hard prerequisite, not a preference

`gradle/java.gradle` pins `JavaLanguageVersion.of(25)` and adds `-Werror -Xlint:unchecked`. With no toolchain auto-provisioning configured, a machine holding only JDK 21 **cannot build at all** — Gradle fails to resolve a toolchain. There is no partial-capability fallback.

- **Affects:** developer onboarding, CI images, `starter-template.md`
- **To close:** state JDK 25 as a hard prerequisite in the service README and the onboarding runbook, or add the Foojay toolchain resolver to `settings.gradle` in `ctam-scaffold.sh`
- **Status:** `open`

### F6 — `application.yaml` vs `application.yml`

The template ships `src/main/resources/application.yaml`; `conventions.md` → *Structure Patterns* specifies `application.yml`. Cosmetic, but it is exactly the kind of small mismatch that makes an agent guess.

- **To close:** one word in `conventions.md`, matching the template
- **Status:** `open`

### F7 — the template's own integration test breaks the CTAM test-naming convention

`ActuatorIntegrationTest` is a Spring-context integration test, but `conventions.md` mandates `*IT` for integration tests. It slips through `TestConventionsFitnessTest` because the rule accepts any class ending in `Test` or `IT`.

- **Affects:** `conventions.md` → *Naming Patterns*, `agent-rules/enforcement/java/TestConventionsFitnessTest.java`
- **To close:** either accept `*IntegrationTest` as an alias in the convention, or tighten the fitness function to fail a class that boots a Spring context and is not named `*IT` — and rename the template's test
- **Status:** `needs-decision`

### F8 — the gate cannot pass for the first service in the polyrepo

`scripts/verify.sh` fails when no Pact task exists, on the reasoning that every endpoint needs both sides of a contract test (C2). For `ctam-notification` — the first service built, with no consumers — there is no contract to verify against, so the gate is **unpassable by construction**. Editing the gate to get past it is prohibited (R9), which leaves no legitimate path.

**Fixed in the pilot** by introducing `docs/gate-waivers.txt`: a committed, reviewable file whose entries let a named step be waived, printed loudly on every run and visible in the PR diff. A waiver is auditable; a quiet script edit is not.

- **Affects:** `agent-rules/enforcement/scripts/verify.sh`, C2, T9, Q6
- **To close:** promote the waiver mechanism into the bus copy of `verify.sh` so every repo gets it, and document it in `90-definition-of-done.md`
- **Status:** `fixed` in the service repo, `open` for the bus

### F9 — the forbidden-pattern scan does not know that `recipient` is personal data

`forbidden-patterns.sh` looks for `payrollNumber`, `personnelNumber`, `firstName`, `lastName`, `dateOfBirth`, bank fields and credentials inside log statements. This service's most obvious leak is `recipient` — an email address. The very first story exposes the list as too narrow, which suggests the approach (an enumerated field-name list) is the weak part, not the specific omission.

- **Affects:** `agent-rules/enforcement/scripts/forbidden-patterns.sh`, S1
- **To close:** add `recipient`, `email`, `emailAddress`, `addressLine`, `postcode`, `phone`, `mobile`, `nino`; and consider inverting the rule — log statements may reference only an allow-list of identifier fields (`joh_id`, `correlationId`, ids, template names, statuses)
- **Status:** `open`

## Execution-phase findings

*To be completed by the fresh session that implements `pilot-0.5.1`, and the review that follows. Structure by hypothesis.*

### H1 — was `CLAUDE.md` + the packet + `_arch/` enough?

*Every question the executing session had to ask a human goes here, with what it needed.*

### H2 — did the enforcement pack run, and did it catch anything real?

*Per enforcer: did it run at all (G1.4c), and which genuine violations did it catch?*

### H3 — did `require-red-test.sh` help or obstruct?

*Denial count; false positives; whether the human override was needed.*

### H4 — where were the rules silent, ambiguous or wrong?

*Add to F1–F9.*

### H5 — is the gate fast enough for a per-behaviour loop?

*Wall-clock for `check` and for the full gate including PIT.*
