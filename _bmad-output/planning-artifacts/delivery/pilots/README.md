# Delivery pilots

A **pilot** is a deliberately narrowed slice of real work, run to test the *delivery method* rather than to ship the feature. Pilots live here — separate from `../ledger/` — for one reason:

> **A pilot must never be mistaken for its epic.** Its acceptance criteria differ from the authored epic's, so marking the epic's stories `done` would misrepresent what was built and quietly corrupt FR/NFR traceability.

## Rules for a pilot

1. **The authored epic and its ledger shard are read-only.** A pilot never edits `epics/`, `delivery/ledger/`, `dispatch-graph.yaml`, or any FR/NFR.
2. **Every deviation from the epic is written down before work starts**, with who approved it. A deviation nobody recorded is indistinguishable from a defect.
3. **A pilot has its own ledger shard here** (`ledger-pilot-*.yaml`), never a status in `../ledger/`.
4. **A pilot names the hypotheses it tests.** If it does not tell you something about the method, it is not a pilot — it is just unplanned work.
5. **The retro is the deliverable.** Working code is the by-product. Where the rules were silent, wrong, or too strict is the output that changes what happens next.
6. **Pilot code is not production-bound.** Anything built under a waived security or persistence rule is explicitly not deployable, and says so.

## Contents

| Pilot | Tests | Status |
|---|---|---|
| [`pilot-0.5-notification-logonly.md`](./pilot-0.5-notification-logonly.md) | The full BMAD dispatch → execute → signal loop, the `arch-vN` context bus, and the agent-rules enforcement pack, on a log-only slice of Epic 0.5 | see [`ledger-pilot-0.5.yaml`](./ledger-pilot-0.5.yaml) |
