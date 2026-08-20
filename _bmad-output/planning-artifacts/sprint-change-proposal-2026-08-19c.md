---
type: 'Sprint Change Proposal'
title: 'Sprint Change Proposal — the human gate moves from every commit to the pull request'
description: 'Date: 2026-08-19 — Claude sessions may now branch, commit and push a feature branch. Writes to a protected branch, force-pushes, tags, work-discarding operations and the GitHub CLI remain denied. The pull request, backed by server-side branch protection, becomes the human review gate.'
resource: 'sprint-change-proposal-2026-08-19c.html'
tags: [ctam-pathfinder, sprint-change, delivery, git, human-gate]
timestamp: '2026-08-19'
parent: 'planning-artifacts/index.md'
project: 'ctam-analysis (CTAM Pathfinder)'
change_scope: 'Minor — delivery-workflow policy (tooling + documentation)'
mode: 'Batch'
architectureVersion: 'v4.4'
last_updated: 2026-08-19
---

# Sprint Change Proposal — 2026-08-19c

**The human gate moves from every commit to the pull request**

---

## Section 1 — Issue Summary

**Trigger:** product-owner decision (Ramnish, 2026-08-19). The original constraint — Claude performs *no* version-control operations, the human commits externally from VSCode — made every commit a manual handoff. In an AI-led delivery model that produces a large uncommitted working tree, reviewed as a single lump, with the red-green sequence invisible.

**Decision:** an agent owns its branch; a human owns `main`. The **pull request** is the review gate, enforced by server-side branch protection as well as by the hook.

| Operation | Before | After |
|---|---|---|
| Branch, stage, commit | denied | **allowed** on a feature branch |
| Push | denied | **allowed** to a non-protected branch |
| Commit / merge / rebase / push / pull while HEAD is `main` | denied | **denied** |
| Push targeting a protected branch, any spelling | denied | **denied** |
| Force-push, `--mirror`, `+refspec` | denied | **denied** |
| Branch delete or rename, `push --delete`, `push :branch` | denied | **denied** |
| Tags, `push --tags` | denied | **denied** |
| `reset --hard`, `clean`, `rm`, `restore`, `checkout -- <path>`, `stash drop`/`clear` | denied | **denied** |
| GitHub CLI (`gh`, `hub`) | denied | **denied** |

---

## Section 2 — Impact Analysis

### 2.1 Why this is still a real gate — and a better one

- **The review boundary is unchanged.** Nothing reaches `main` without a human reading a diff. What changed is *where*: a pull request with commit-by-commit history, rather than an uncommitted working tree in an editor.
- **The history becomes evidence.** Red-green cycles committed as they happen are reviewable. That matters more in AI-led delivery than in hand-written code, because the *sequence* is what a reviewer must inspect to believe a TDD claim (**R2**).
- **Enforcement moves to the mechanism built for it** — branch protection and CODEOWNERS — instead of a convention every agent must remember.
- **Tags stay human** because `arch-vN` is consumed by pinned submodules across the polyrepo: a stray tag silently changes what every downstream repo can adopt.
- **Work-discarding operations stay denied** because uncommitted changes may be the only copy of something.
- **The GitHub CLI stays denied** because opening, approving and merging a pull request *is* the gate, and a text-matching hook cannot safely distinguish creating a PR from merging one with admin override. It also keeps pilot finding **F1** closed — the HMCTS template's own `setup-new-repo.sh` makes a repository **public**, which contradicts the standing rule that CTAM repositories are private.

### 2.2 Implementation and verification

`.claude/hooks/block-git-writes.sh` was rewritten. The filename was **retained deliberately** so that no `settings.json` in any repo needs changing and no session loses its guard mid-run.

Two defects were found by testing rather than by reading, both worth recording:

1. **Unborn-branch detection.** The first implementation resolved the current branch with `rev-parse --abbrev-ref HEAD`, which *fails* in a repository with no commits. `ctam-notification` is exactly that repository — so main protection was silently off in the one situation where a first commit would land on `main`. Fixed by trying `symbolic-ref --quiet --short HEAD` first.
2. **Documentation trips the guard.** The pattern treated a backtick as a command separator, so prose mentioning a blocked command in inline code read as an invocation of it. Writing this SCP was itself blocked by the hook it describes. Command positions are now start-of-line, after a separator, or inside `$( )` / a subshell — a backtick is no longer one.

A **known limit is accepted and documented in the hook**: it matches text, so a blocked command appearing as *data* at a command position (a here-doc line, a test fixture) is still denied. The alternative — ignoring quoted spans — would let a blocked command through inside `sh -c "…"`, which is worse. The workaround is to write such files with an editor tool rather than a here-doc.

Verified against a **46-case matrix** in two contexts: HEAD on a feature branch (39/39), plus 7 cases covering subshells, separators and documentation-in-backticks. On `main` in a repo with no commits, `commit`, `push`, `merge` and `pull` are denied while `status`, `add`, `switch -c` and `stash push` are allowed. All three copies of the hook are byte-identical (verified by checksum). The protected set is overridable per environment via `CTAM_PROTECTED_BRANCHES`.

### 2.3 Standing personal instruction that now conflicts

The user's **global** `~/.claude/CLAUDE.md` still states *"DO NOT PERFORM ANY GITHUB OPERATIONS from within Claude sessions — GitHub commits will be handled externally using VSCode after reviewing the work."* That file governs every project on the machine and was **not** edited by this change, deliberately: narrowing a personal, cross-project instruction is the user's call, not a programme decision. Until it is updated, a session that reads it will be told the opposite of this SCP, and a global instruction outranks a project one.

**Recommended:** amend the global rule to reference branch-protection semantics, or scope it explicitly to non-CTAM projects.

---

## Section 3 — Recommended Path Forward

**Applied:**

1. `.claude/hooks/block-git-writes.sh` rewritten in `ctam-analysis`, and copied byte-identically to the bus (`agent-rules/enforcement/claude/hooks/`) and to `ctam-notification`.
2. **R13** rewritten in `agent-rules/00-core.md` and in the target-repo `CLAUDE.md.template`; stop conditions updated in both.
3. **W7** in `agent-rules/60-session-protocol.md` rewritten as *"the pull request is the human gate"*, with the branch → commit → push → hand-back sequence; the loop's handoff step updated to match.
4. `agent-rules/enforcement/README.md` rule→enforcer rows for R13 and W7 updated.
5. `CLAUDE.md` (repo root), `_bmad-output/project-context.md`, and `architecture/delivery-operating-model.md` → *Human gates and the branch-protection constraint* rewritten with the rationale.
6. `ctam-notification`: `CLAUDE.md` regenerated from the updated template, README's contributing section updated, and the pilot packet's Task 8 now ends with branch → commit → push → surface the compare URL.
7. Housekeeping in the same pass, now that the tag exists: the pilot packet's `bus_version` set to `arch-v1.0` and deviation **D-8** removed.

**Not applied:** the user's global `~/.claude/CLAUDE.md` (§2.3) — flagged for the user to decide.

---

## Section 4 — Change Scope Summary

| Artifact | Change |
|---|---|
| `.claude/hooks/block-git-writes.sh` (all three repos) | **Rewritten** — protected-branch policy, unborn-branch-safe detection, command-position boundaries, `CTAM_PROTECTED_BRANCHES` override |
| `agent-rules/00-core.md` | **R13** rewritten; stop conditions updated |
| `agent-rules/60-session-protocol.md` | **W7** rewritten |
| `agent-rules/enforcement/claude/CLAUDE.md.template` | R13, loop step 8, stop conditions, closing note |
| `agent-rules/enforcement/README.md` | R13 / W7 enforcer rows |
| [`architecture/delivery-operating-model.md`](./architecture/delivery-operating-model.md) | *Human gates* section rewritten |
| `CLAUDE.md` (repo root) · `_bmad-output/project-context.md` | Hard rule and delivery-discipline bullets |
| `ctam-notification` | `CLAUDE.md` regenerated · README · packet Task 8 · packet `bus_version` + D-8 removal |
| [`architecture/changelog.md`](./architecture/changelog.md) | **v4.4** entry |
| **This SCP** | New |
| **`docs/`** | Regenerated |
| **Unchanged** | `prd.md`, `epics/`, `delivery/ledger/`, `dispatch-graph.yaml`, `conventions.md` → *Git conventions* (branch naming and Conventional Commits were already correct), FR/NFR coverage |

**Handoff:** the policy is live in all three repos. The one open item is the global personal instruction in §2.3.
