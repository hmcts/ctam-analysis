# Ledger (sharded per epic)

The traceability ledger is **sharded — one file per epic** (`epic-0.0.yaml` … `epic-0.8.yaml`, plus the lettered `ctam-architecture` enablement shards `epic-0.A.yaml` / `epic-0.B.yaml` and `epic-0M.1.yaml` / `epic-0M.2.yaml` for Phase 0-Mock) — so multiple people can update different epics concurrently without git conflicts. Because the dispatch graph pushes work to run in parallel across different epics/repos, concurrent writers naturally touch **different shards**. Rationale and the full concurrency model: [`../README.md`](../README.md).

## Shard schema

```yaml
epic: epic-0.1                 # epic id (matches dispatch-graph.yaml)
title: ...
repo: ctam-reference-data       # owning repo, or a list when the epic spans repos
bus_version: arch-v1.0
status: not-started            # EPIC-LEVEL rollup (see vocab below)
owner: null                    # who is driving this epic (name/handle); null = unassigned
stories:
  - story: 0.1.1
    repo: ctam-reference-data   # per-story repo (may differ from the epic within a multi-repo epic)
    title: ...
    frs: [FR6, FR7, FR8]       # traced requirements (epic granularity unless a story narrows it)
    touches: [ctam-analysis]   # OPTIONAL — secondary repos this story also lands an artefact in
    note: ...                  # OPTIONAL — a cross-repo consumption or sequencing constraint
    bus_version: arch-v1.0     # the ctam-architecture version the story was built against
    status: not-started        # STORY-LEVEL lifecycle (see vocab below)
    owner: null                # who is on this story; null = unassigned
    pr: null                   # PR URL once opened/merged
```

## `repo` vs `touches` vs `note` (added 2026-08-18, SCP 2026-08-18e)

Several Phase 0 stories deliver into **more than one repo** — Story 0.5.1 creates tables in `ctam-reference-data` *and* writes `runbooks/reference-data-maintenance.md` into `ctam-architecture`; Story 0.8.1 creates a table *and* documents it in `architecture/data-tables.md` here in `ctam-analysis`. A single-valued `repo:` hid that, so dispatch packets came out under-scoped.

- **`repo:`** — the **one** repo whose PR this story lands in. This is the claim: it stays single-valued so "claim before you start" locks exactly one repo's history. (Epic-level `repo:` may still be a list when an epic spans repos.)
- **`touches:`** — additional repos where this story lands a **committed artefact** (a runbook, a doc row, a published spec). A dispatch packet must include them; the reviewer of the `repo:` PR should expect a companion diff.
- **`note:`** — a cross-repo **consumption or sequencing** constraint that lands no artefact: "consumes the contract published by 0M.1.2", "runs under the role created in 0.B.1". Not a second repo to write to; context the implementer needs.

Rule of thumb: *do I commit a file there?* → `touches:`. *Do I only read from or depend on it?* → `note:`.

## Status vocab

- **Epic-level** (`status:` at the top): `not-started` · `in-progress` · `blocked` · `in-review` · `done`.
- **Story-level** (`status:` on each story): `not-started` → `dispatched` → `in-progress` → `in-review` → `done`.
  - `dispatched` = story packet generated into the target repo (**this is the claim** — set `owner` and push promptly to prevent double-pickup).

## Ownership & visibility ("who is working on what")

- **Epic `owner`** = the person accountable for the epic end-to-end.
- **Story `owner`** = the person currently implementing that story (lets two people share one epic on different stories).
- To see the whole board at a glance, scan the thirteen shards' epic headers (`status` + `owner`); for finer detail, the per-story `owner`/`status`.

## Concurrency rules

- **Pull `main` before** you select / dispatch / signal.
- **Claim before you start:** set story `status: dispatched` + `owner`, and push, before writing code — that is the lock.
- **One story = one small, atomic commit/PR** to the shard.
- **Work in parallel by epic/repo, not within a repo** — keeps writers off each other's shards. The graph alone does not enforce this: several epics are graph-independent yet share a repo *and* share mutable files in it (Epics 0.5/0.6 both rewrite the one `api-ctam-reference-data` spec and the one Phase 0 Postman collection). `dispatch-graph.yaml`'s **`repo_serialisation`** block is the authority on that ordering — check it as well as `depends_on` before dispatching.
- Roll the epic-level `status`/`owner` up from its stories (e.g. epic → `in-progress` when its first story is `dispatched`; `done` when all stories are `done`).

## Target state (projection)

Once the service repos exist, the authoritative story status will live in each repo (story-packet frontmatter + PR state), and a resolver will **regenerate** these shards as a read-only rollup — no hand-editing, no contention — the same producer-owned / read-only-mirror principle used for API contracts. Until then, these shards are hand-maintained.
