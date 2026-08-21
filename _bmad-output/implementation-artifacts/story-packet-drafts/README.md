# Story packet drafts — NOT dispatched

Generated 2026-08-21 via `bmad-correct-course`, at explicit user request, after checking the real
dispatch path and finding it currently blocked for every one of the 28 stories in `epics/phase-0/`
and `epics/phase-1/`:

- Only `ctam-architecture` exists on GitHub today. The other repos these stories target
  (`ctam-shared-infrastructure`, `ctam-reference-data`, `ctam-authorisation`, `ctam-mock-auth`,
  `ctam-ui`, `ctam-notification`) do not exist yet — there is nowhere to land a real packet
  (`docs/stories/<id>.md` in the target repo) for 26 of the 28 stories.
- `scripts/dispatch-preflight.sh` requires a story's epic `depends_on` to already be `done`.
  Today only `epic-1.9` is `in-progress` (and even it depends on `epic-1.0`, which is `backlog`) —
  every other epic is `backlog`. Zero stories would pass preflight right now.

**What this directory is:** every story's packet content, drafted against the canonical template
(`ctam-architecture/agent-rules/templates/story-packet.md` @ `arch-v1.1`) and validated structurally
with `scripts/validate-story-packet.sh`, so the content is ready to move the moment its target repo
exists and its dependencies are actually `done`. **What it is not:** a dispatch. No branch was
created in any target repo, nothing was pushed, and `sprint-status.yaml` was deliberately left at
`backlog` for every story except 1.9.1 (see below) — this directory does not claim any story.

## Layout

```
story-packet-drafts/
├── README.md                     (this file)
├── ctam-shared-infrastructure/docs/stories/1.0.{1-5}.md
├── ctam-reference-data/docs/stories/{0.0,0.1,1.1,1.2,1.3,1.5,1.6}.*.md
├── ctam-authorisation/docs/stories/1.4.{1,3}.md
├── ctam-mock-auth/docs/stories/1.4.2.md
├── ctam-ui/docs/stories/1.4.{4,5}.md
├── ctam-notification/docs/stories/1.8.{1,2}.md
└── ctam-architecture/docs/stories/1.7.1.md, 1.9.{1,2}.md
```

Each subtree mirrors the real target repo's eventual layout exactly (`docs/stories/<id>.md`), so
promoting a draft is a straight file move once the repo exists — no restructuring needed.

## One exception: Story 1.9.1

Story 1.9.1 ("Publish `ctam-architecture` as the official, version-tagged architecture package")
is **already done for real** — `ctam-architecture` exists on GitHub with tags `arch-v1.0` and
`arch-v1.1` published, matching `sprint-status.yaml`'s existing `done` status. Its packet is
written with `Status: done` and a genuine Dev Agent Record citing that evidence, not a fictional
one — everything else in this directory is a forward-looking draft with `Status: ready-for-dev`.

## Before any of this becomes real

1. Confirm the target repo exists (or create it — a human action, `gh` is unavailable to sessions).
2. Run `scripts/dispatch-preflight.sh <story-id>` and resolve anything it flags.
3. Re-verify `bus_version` against the repo's actual `_arch/` submodule pin (these drafts assume
   `arch-v1.1`, the latest tag at drafting time — re-check, don't assume it's still latest).
4. Land it for real per the delivery-operating-model.md "DISPATCH BRANCH" step — `git switch -c
   story/<id>` in the target repo, commit, push — and flip `sprint-status.yaml` to `ready-for-dev`
   in that same change.
