# ctam-analysis

**As-is analysis of the JI (Judicial Information) application** — the Oracle APEX system HMCTS uses today to record Judicial Office Holder (JOH) availability, sittings, bookings, absences, vacancies and fee-paid payments.

This repository captures **how the current system works**: its system context, functional modules, user types, data and integration dependencies, database schema and payment templates. It holds no runtime code. The analysis is published as a browsable static site from the [`docs/`](docs/) folder (GitHub Pages).

## What the as-is pack covers

| Area | Where to look | What it describes |
|---|---|---|
| **System context** | [`docs/asis/system-context.html`](docs/asis/system-context.html) | Actors, external systems and integrations around JI, with interactions numbered |
| **Components** | [`docs/asis/components.html`](docs/asis/components.html) | Internal modules of the APEX application and how they relate |
| **Functional modules** | [`docs/architecture/asis/functional-modules.md`](docs/architecture/asis/functional-modules.md) | Module catalogue — capabilities, key user actions, sources |
| **Function decomposition** | [`function-decomposition.md`](_bmad-output/planning-artifacts/architecture/analysis/function-decomposition.md) | Breakdown of JI functions by business area |
| **User types & access catalogue** | [`user-types.md`](_bmad-output/planning-artifacts/architecture/user-types.md) · source [`JI user types - 2.xlsx`](docs/architecture/asis/JI%20user%20types%20-%202.xlsx) | 17 access types across Court, Regional, Judicial and Finance groups, plus the Payment Authoriser configuration entry; Feb 2026 active-user counts |
| **Data dependencies** | [`docs/architecture/asis/data-dependencies.md`](docs/architecture/asis/data-dependencies.md) | Inbound and outbound data flows, with eight flow diagrams (`flow-1` … `flow-8`) |
| **Integration dependencies** | [`docs/architecture/asis/integration-dependencies.md`](docs/architecture/asis/integration-dependencies.md) | Systems JI exchanges data with and the mechanism for each |
| **Payment templates** | [`docs/architecture/asis/payments/payment-templates.md`](docs/architecture/asis/payments/payment-templates.md) | JFEPS payment-schedule outputs produced for Finance and Liberata |
| **Database schema** | [`docs/architecture/asis/database/README.md`](docs/architecture/asis/database/README.md) | 46 production tables reverse-engineered from the Oracle DDL dump; overview plus six domain-cluster ER diagrams and a companion reference (triggers, inferred FKs, external references) |

## Key as-is processes

- **Judge master data** — judge profiles, working patterns, tickets and jurisdictional splits are maintained by Court and Regional users according to their access scope.
- **Planned activity capture** — sittings and fee-paid bookings are planned against courts and judges.
- **Sitting & booking confirmation** — Court users confirm daily that a sitting or booking took place; Verifiers sign off batches (typically monthly), which locks the records for reporting. Regional (Admin) can re-open a verified record.
- **Absence & vacancy management** — absences are requested at Court level and approved Regionally; approved absences can raise cover vacancies.
- **Fee-paid payment export** — Finance generates JFEPS-compatible Excel schedules, emailed to a configured Payment Authoriser who forwards them to Liberata.
- **Payment reconciliation, MI reporting and notifications** — JFEPS reconciliation back into JI, aggregate MI to DA&I, and email notifications; see the `flow-6` to `flow-8` diagrams in [`docs/architecture/asis/`](docs/architecture/asis/).

## Repository layout

```
ctam-analysis/
├── docs/                                  # PUBLISHED HTML site (generated — do not hand-edit)
│   ├── asis/                              # system-context, components and database schema pages
│   └── architecture/asis/                 # as-is analysis pack: sources (.md/.xlsx/.mmd/.d2/.dot) + renders
│       ├── database/                      # schema model, D2 diagrams, companion reference
│       └── payments/                      # payment templates
├── _bmad-output/planning-artifacts/
│   └── architecture/
│       ├── user-types.md                  # JI user types & access catalogue (as-is)
│       └── analysis/function-decomposition.md
├── scripts/                               # build-html.sh + Python helpers (site + diagram rendering)
├── .claude/
│   ├── commands/ + lib/                   # analysis slash commands used to produce the pack
│   └── hooks/                             # block-git-writes.sh (main is protected)
├── sql/ · queries/ · openspec/            # legacy/exploratory — not part of the current workflow
└── CLAUDE.md                              # operating contract for Claude Code instances
```

## Building the site

The Markdown, spreadsheets and diagram sources are authoritative. Regenerate the HTML rather than editing it:

```
scripts/build-html.sh
```

Requires `pandoc` and Python 3. The sidebar navigation is the `NAV` list in `scripts/python/build_html.py`; add an entry there when a new as-is page is introduced.

New schema or architecture diagrams use **D2 + ELK**; the older Graphviz/DOT files are kept for reference only.

## Analysis toolchain

Claude Code slash commands used to produce parts of the as-is pack from source documents:

| Command | Output |
|---|---|
| `/create-functional-modules-architecture` | Functional module catalogue (Markdown + styled PDF) |
| `/create-data-dependency-architecture` | Inbound/outbound data-dependency catalogue (Markdown + styled PDF) |
| `/check-for-owasp-top10` | Security audit report against the OWASP Top 10 for Agentic Applications 2026 |
| `/docs-to-c4` | *(retired — use the `build_html.py` static-site pipeline instead)* |

Commands live in `.claude/commands/` with pipelines in `.claude/lib/<command>/`; the shared house-style PDF pipeline is in `.claude/lib/_shared/`. Source documents are read-only: distillation and analysis write to `output/` folders, never the originals.

## License

[MIT License](LICENSE).
