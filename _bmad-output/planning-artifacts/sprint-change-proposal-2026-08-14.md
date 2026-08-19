---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — 2026-08-14: Network isolation + edge protections added to Epic 0.0'
timestamp: '2026-08-14'
tags: [ctam-pathfinder, sprint-change-proposal, epic-0.0, security]
---

# Sprint Change Proposal — 2026-08-14

## Add a security-hardening feature to Epic 0.0 (platform estate)

## 1. Issue Summary

**Trigger:** a direct request to add a security feature to Epic 0.0 (Platform estate is provisioned, verifiable, and CNP-compliant), raised via `bmad-correct-course` before any Epic 0.0 story has started (all 5 stories in `delivery/ledger/epic-0.0.yaml` are `status: not-started`).

**Problem statement:** Epic 0.0's five stories provision the shared Azure estate (AKS, PostgreSQL Flexible Server, Key Vault, ACR, App Insights/Log Analytics, APIM) and verify **transport encryption** (NFR10 — TLS-only), **encryption at rest** (NFR11), and **secret management** (NFR16). They do **not** verify any **network-perimeter** control: every data-plane resource (PostgreSQL, Key Vault, ACR) is reachable by public endpoint (protected only by auth/TLS, not network isolation), and APIM's own Story 0.0.5 scope is TLS termination + rate limiting only — no WAF, no DDoS protection.

**Evidence (documented in the artifact set, gathered before drafting this proposal):**
- **NFR15 — Government Functional Standard 7 alignment** (`prd.md`) commits CTAM Pathfinder to GovS7 Security, including "secure development practices" — but no epic 0.0 acceptance criterion currently operationalises a network-perimeter control, and NFR15 is not cited anywhere in epic 0.0.
- **Assumption A22** (`architecture/assumptions.md`) — "HMCTS-approved security tooling is available and integrated at platform level" — exists but is not tied to any Epic 0.0 story or AC.
- No AR (architecture requirement), and no gap in `gaps.md`, currently addresses NSGs, private endpoints, WAF, or DDoS protection anywhere in the artifact set.

This is a **new requirement surfaced by review**, not a failed approach or a misunderstanding of existing scope — it closes a gap between the stated NFR15/A22 intent and what Epic 0.0 actually verifies.

**Scope confirmed with the user:** two specific capabilities —
1. **Network isolation** — NSGs on the AKS subnets; PostgreSQL, Key Vault, and ACR switched to private-endpoint-only access (public network access disabled).
2. **WAF + DDoS protection at the APIM edge** — an Azure-managed WAF policy (OWASP Core Rule Set) in front of APIM, plus a DDoS Protection plan on the VNet.

IaC/container vulnerability scanning, Defender for Cloud, and a CIS/Azure Policy security baseline were considered and **explicitly deferred** (not part of this change) — see §4 alternatives considered.

## 2. Impact Analysis

### Epic impact
- **Epic 0.0** gains a 6th story, **Story 0.0.6: Harden network perimeter and edge protections (dev)**, sequenced after 0.0.2–0.0.5 (it hardens resources those stories provision). Epic 0.0's "vertical slice," "Key NFRs," and "Architecture requirements" summary lines gain NFR15 and a new AR54.
- **Story 0.0.5**'s closing capstone AC ("all five layers … ready for `ctam-reference-data`") is superseded by an equivalent capstone AC moved to the new Story 0.0.6 ("all six layers").
- **No other Phase 0 epic is affected.** Epics 0.1–0.5 consume the estate as a black box; none of their acceptance criteria assume public reachability of PostgreSQL/Key Vault/ACR, so none require rewording. (Worth flagging for the Developer agent building `ctam-reference-data`/`ctam-authorisation` etc.: connection strings must resolve via the private DNS zone, not a public FQDN — this is an implementation detail of consuming the estate, not a scope change to those epics.)
- **No epic becomes obsolete; no resequencing needed.**

### Artifact conflicts / updates required
| Artifact | Change |
|---|---|
| `epics/phase-0/epic-0.0-platform-estate-provisioned.md` | Add Story 0.0.6 (full AC set below); `storyCount` 5→6; epic summary lines gain NFR15, AR54, gaps.md G10; Story 0.0.5 capstone AC trimmed, moved/restated in 0.0.6 |
| `epics/requirements-inventory.md` | New **AR54** under a new "Network & edge security posture" heading |
| `architecture/gaps.md` | New **G10 — Network & Edge Security Posture** section (G10.1, G10.2); title/frontmatter `G1–G9` → `G1–G10` |
| `architecture.md` | New decision **#14** appended to the "Architecture-phase decisions" table (existing rows #1–13 untouched, per changelog convention) |
| `architecture/changelog.md` | New **v4.2** entry (existing entries untouched — immutable history) |
| `delivery/ledger/epic-0.0.yaml` | New story entry `0.0.6`, `status: not-started`, `owner: null` |
| `delivery/dispatch-graph.yaml` | `epic-0.0.stories` gains `0.0.6` |
| `epics/phase-0/index.md` | Story-count propagation: epic table row, epic summary heading/FRs line, epic-stories-summary table row, Total row (19→20 stories) |
| `epics/index.md` | Phase 0 row: "19 stories" → "20 stories" |
| `delivery/README.md` | "Current state" line: "19 stories" → "20 stories"; date bumped |
| `docs/*.html` | Regenerated via `scripts/build-html.sh` (never hand-edited) |

No PRD conflict: NFR15 already exists and covers this; no new NFR is needed, no MVP-scope change, no FR added. No UX/UI impact (backend/infra only). No conflict with `conventions.md`, `data-tables.md`, `repo-structure.md`, or `repository-strategy.md` (Terraform module still lives in `ctam-shared-infrastructure` per AR53; no repo/table/API changes).

### Technical impact
- Purely additive Terraform in `ctam-shared-infrastructure` (not yet scaffolded — Story 0.0.1). No code exists anywhere in the polyrepo yet, so there is **zero migration or rework cost**.
- Two open questions are recorded as gaps rather than blocking the story (pattern precedented by G9.1 for the Terraform state backend):
  - **G10.1** — DDoS Protection plan tier (Standard vs the Azure-default free Basic tier) and WAF policy ownership/cost sign-off are HMCTS platform-team decisions, not yet confirmed.
  - **G10.2** — cross-repo private-DNS-zone resolution: once PostgreSQL/Key Vault/ACR sit behind private endpoints, each service repo's own Terraform (AR53) needs a remote-state or data-source convention to resolve the shared estate's private DNS zones — same class of problem as G9.1's cross-repo remote-state need, not yet agreed.

## 3. Recommended Approach

**Selected: Option 1 — Direct Adjustment** (add a new story within the existing Epic 0.0 structure).

**Rationale:**
- All five existing Epic 0.0 stories are `not-started` — there is nothing to roll back (Option 2 is moot) and no completed work to protect.
- The PRD's MVP and NFR set already anticipate this (NFR15, A22) — no MVP scope reduction or redefinition is needed (Option 3 is moot).
- The change is additive and layer-scoped, consistent with the epic's own "layer-by-layer, independently verifiable" design principle — adding a 6th verifiable layer is a smaller, lower-risk edit than reopening the ACs of Stories 0.0.2–0.0.5.

**Effort:** Low (documentation-only at this stage; the Terraform module itself is a normal-sized addition when Story 0.0.1 work begins — no different in kind from Stories 0.0.2–0.0.5).
**Risk:** Low (no code impact; two open sub-questions tracked as gaps, not blockers, following the existing G9.1 precedent).
**Timeline impact:** None — Epic 0.0 is not yet dispatched.

## 4. Alternatives considered (and deferred, not adopted here)

- **IaC/container vulnerability scanning** (tfsec/checkov, Defender for Containers) — valuable, but a CI/tooling concern orthogonal to the Terraform-provisioned estate; better scoped to a future change against `conventions.md`'s CI-gates list.
- **Azure Policy / CIS baseline + Defender for Cloud** — broader platform-governance decision likely owned by HMCTS centrally (per A22); revisit once HMCTS's platform-level security tooling stance is confirmed (ties to G10.1).

Both remain candidates for a future Sprint Change Proposal if the user wants to pursue them; they are intentionally out of scope here.

## 5. Detailed Change Proposals

### 5.1 New Story 0.0.6 (added to `epic-0.0-platform-estate-provisioned.md`, after Story 0.0.5)

> ## Story 0.0.6: Harden network perimeter and edge protections (dev), verifiable via isolation and WAF/DDoS smoke tests
>
> As a **platform engineer**,
> I want NSGs and private endpoints applied to the shared estate's data-plane resources, and a WAF + DDoS Protection policy applied at the APIM edge, provisioned via Terraform,
> So that **the shared estate is unreachable from the public internet except through the hardened APIM gateway, and the gateway itself resists common web attacks and volumetric floods, before any service traffic flows through it**.
>
> **Acceptance Criteria:**
>
> **Given** Stories 0.0.2–0.0.5 have provisioned AKS, PostgreSQL, Key Vault, ACR, and APIM,
> **When** the engineer adds the network-hardening module and runs `terraform apply` for the dev stack,
> **Then** Network Security Groups are attached to every AKS subnet, permitting only the documented traffic patterns (cluster-internal + APIM ingress; all other inbound denied by default),
> **And** PostgreSQL Flexible Server, Key Vault, and ACR have public network access **disabled** and are reachable only via **private endpoint** inside the VNet,
> **And** private DNS zones resolve each resource's private endpoint for in-cluster consumers,
> **And** an Azure **DDoS Protection** plan is attached to the VNet (tier per gaps.md G10.1),
> **And** a **WAF policy** (Azure-managed OWASP Core Rule Set, Prevention mode) is attached in front of APIM.
>
> **Given** the network-hardening module is applied,
> **When** the engineer attempts to reach PostgreSQL, Key Vault, or ACR directly from outside the VNet,
> **Then** the connection is refused/times out — no public endpoint is reachable (verified from outside the cluster),
> **And** a WAF-triggering request (an OWASP CRS test payload) sent through APIM is blocked (`403`) before reaching any backend,
> **And** the Story 0.0.5 smoke-API call still succeeds through APIM (the WAF does not false-positive the baseline path),
> **And** these checks are captured as documented post-apply verification steps.
>
> **Given** all six layers are applied,
> **When** the engineer reviews the dev estate,
> **Then** the full shared estate (AKS + PostgreSQL + Key Vault + ACR + App Insights + APIM), each independently verified **and network-hardened**, exists in UK South,
> **And** the estate is ready for `ctam-reference-data` to scaffold and deploy onto (Epic 0.1, Story 0.1.1).
>
> **References:** AR54 (new); NFR15; NFR10, NFR31; gaps.md G10.
>
> **Explicitly NOT in scope:**
> - IaC/container vulnerability scanning, Defender for Cloud, Azure Policy/CIS baseline — deferred, see §4
> - Per-service Kubernetes `NetworkPolicy` — each service repo's own concern
> - Per-service APIM policy additions beyond the shared base WAF/rate-limit policy (AR53)

*(Story 0.0.5's existing final AC block — "Given all five layers are applied… ready for `ctam-reference-data`" — is removed from Story 0.0.5 and superseded by the equivalent six-layer AC above in Story 0.0.6.)*

### 5.2 New AR54 (added to `epics/requirements-inventory.md`, after AR53, new heading)

> ### Network & edge security posture (new 2026-08-14)
>
> - AR54 — **NSGs + private endpoints for the shared estate's data plane; WAF + DDoS Protection at the APIM edge.** PostgreSQL Flexible Server, Key Vault, and ACR (provisioned in `ctam-shared-infrastructure`, Epic 0.0) disable public network access and are reachable only via private endpoint from inside the VNet; AKS subnets carry NSGs restricting inbound traffic to cluster-internal + APIM ingress. APIM carries an Azure-managed WAF policy (OWASP CRS, Prevention mode) and the VNet carries a DDoS Protection plan (tier per gaps.md G10.1). Provisioned in the new **Story 0.0.6**, after Stories 0.0.2–0.0.5. Satisfies **NFR15** (GovS7 alignment) at the network-perimeter layer; complements NFR10 (transport encryption) and NFR31 (UK South residency). Cross-repo private-DNS-zone resolution for services consuming these resources is tracked as gaps.md **G10.2**.

### 5.3 New gap section G10 (added to `architecture/gaps.md`, after G9)

> ## G10 — Network & Edge Security Posture (new 2026-08-14)
>
> | Gap | Detail | Resolution path |
> |---|---|---|
> | **G10.1** | **DDoS Protection tier and WAF policy ownership unconfirmed.** Story 0.0.6 (Epic 0.0) attaches a WAF policy (OWASP CRS) to APIM and a DDoS Protection plan to the VNet, but the tier (Standard, paid, vs the Azure-default free Basic tier) and who owns/pays for the WAF policy (product team via Terraform in `ctam-shared-infrastructure` vs an HMCTS-central security-team-managed policy) are not yet confirmed with HMCTS. | Confirm with the HMCTS platform/security team before the Story 0.0.6 apply; record the agreed tier and ownership model in `ctam-architecture/runbooks/terraform.md` alongside G9.1. |
> | **G10.2** | **Cross-repo private-DNS-zone conventions unconfirmed.** Once PostgreSQL, Key Vault, and ACR sit behind private endpoints (Story 0.0.6), each service repo's own Terraform (AR53 — e.g. a service's own Key Vault namespace or future private-endpoint resources) may need to resolve the shared estate's private DNS zones. The remote-state or data-source pattern for this cross-repo reference is not yet agreed — the same class of problem as G9.1's cross-repo remote-state need for the shared AKS identity. | Agree the pattern alongside G9.1's Terraform state-backend conventions, before the first service (`ctam-reference-data`, Epic 0.1) needs to resolve a private DNS zone. |

## 6. PRD MVP Impact

**MVP is unaffected.** No FR is added, removed, or reworded. NFR15 already exists in the PRD and already anticipated this class of control; no new NFR is required. No change to Success Criteria, Scope, or Phase mapping.

**High-level action plan:**
1. Apply the documentation edits in §5 (this proposal) — epic file, requirements inventory, gaps, changelog, architecture decision log, ledger, dispatch graph, index/count propagation.
2. Regenerate `docs/` via `scripts/build-html.sh`.
3. No dispatch action needed yet — Epic 0.0 (including the new Story 0.0.6) remains `not-started` in the ledger until the team is ready to begin Phase 0 implementation.

## 7. Implementation Handoff

**Change scope classification: Minor** — this is a planning-artifact addition to an epic where no story has started; no backlog reorganisation, resequencing, or PM/Architect strategic replan is needed.

**Handoff:**
- **This session (control-plane edits):** apply all §5 documentation changes directly (this repo holds no runtime code — see CLAUDE.md), then rebuild `docs/`.
- **Developer agent, when Story 0.0.1 is dispatched:** implement the Terraform foundation as normal; Story 0.0.6's module depends on 0.0.2–0.0.5 landing first, per its own acceptance criteria.
- **HMCTS platform/security team:** resolve G10.1 (DDoS tier + WAF ownership) before the Story 0.0.6 `terraform apply`; resolve G10.2 alongside G9.1 before the first service repo needs a private-DNS-zone reference.

**Success criteria:** Story 0.0.6 lands in the epic file, ledger, and dispatch graph consistently with Stories 0.0.1–0.0.5's existing pattern; all story-count references across `epics/index.md`, `epics/phase-0/index.md`, and `delivery/README.md` agree (20 stories, 6 epics); `docs/` regenerates cleanly.
