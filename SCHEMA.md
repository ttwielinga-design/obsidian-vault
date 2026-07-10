---
title: "Second Brain Schema"
type: meta
created: 2026-07-07
updated: 2026-07-07
version: 1
status: evergreen
tags: [meta, schema]
---

# Second Brain Schema

The constitution for the Second Brain vault. All note types, frontmatter rules, tag taxonomy, quality signals, and agent conventions are defined here. Every note in this vault — human or agent-authored — must comply with this schema.

---

## 1. Domain

Personal knowledge management, software development, AI/ML research, and daily work tracking. Covers code sessions from Claude Code, Codex, and Hermes Agent; research notes; project documentation; and learning artifacts.

**Languages:** Primarily English. Chinese notes use `aliases:` frontmatter for cross-language linking and carry the `lang:zh` tag.

---

## 2. Core Conventions

### 2.1 File Naming
- **Lowercase with hyphens** — `redis-caching-pattern.md`, NOT `Redis Caching Pattern.md` or `redis_caching_pattern.md`
- **Daily notes** — `YYYY-MM-DD.md` in `2-notes/daily/`
- **Code sessions** — `YYYY-MM-DD-HHMM-agent.md` (e.g., `2026-07-07-1430-claude-code.md`)
- **No case-only renames** — renaming `note.md` to `Note.md` can cause file deletion during sync. Always lowercase.
- **MOCs** — prefix with `moc-` (e.g., `moc-python.md`) to distinguish from atoms
- **Templates** — prefix with `t-` (e.g., `t-daily.md`, `t-atom.md`)
- **Mobile-optimized pages** — root-level `.md` files with minimal layout for small screens (e.g., `mobile-home.md`). Not prefixed — the name signals the purpose.

### 2.2 Wikilinks
- Use `[[wikilinks]]` for ALL internal links — never raw Markdown links to internal vault files
- Every atom note must have at least **2 outbound `[[wikilinks]]`** to other atoms or MOCs
- MOCs should link to every member atom
- Use aliases: `[[redis-caching-pattern|Redis Caching]]` when the display text differs from filename

### 2.3 Updates and Versioning
- When updating any wiki note, bump `updated` date and increment `version` by 1
- If an update changes the core thesis, bump from minor version (1.1 → 1.2) or major (1.x → 2.0)
- Add a `## Changelog` section at the bottom of atoms tracking significant revisions

### 2.4 Index and Log
- **Every new wiki page** must be added to `index.md` under the correct section with a one-line summary
- **Every significant action** (create, update, delete, archive, merge) must be appended to `log.md` with:
  - Timestamp (ISO 8601)
  - Action type
  - Affected files
  - Short rationale (1 sentence)
- Agents append to `log.md` under `<!-- AGENT_LOG -->` marker; humans append above it

### 2.5 Source Attribution
- All non-original content must cite sources via `sources:` frontmatter
- Raw source files in `1-raw/` must carry `source_url` and `source_sha256` (for content integrity)
- When an atom is derived from a source, link both in frontmatter AND inline

---

## 3. Tag Taxonomy

**Rule:** Tags come ONLY from this taxonomy. To add a new tag, propose it here first (or as a comment on SCHEMA.md), get it accepted, then use it. This keeps the vault queryable. Current count: 20 tags across 6 families.

### 3.1 Domain Tags (`domain/*`)
Tag applied to notes about a specific technical domain.

| Tag | Scope |
|-----|-------|
| `backend` | Server-side development, APIs, databases, services |
| `frontend` | Client-side, UI/UX, browsers, rendering |
| `devops` | CI/CD, infrastructure, deployment, monitoring |
| `ml` | Machine learning, AI, LLMs, neural networks |
| `systems` | OS, networking, distributed systems, performance |
| `security` | Auth, encryption, vulnerabilities, threat modeling |
| `mobile` | iOS, Android, React Native, mobile-specific |
| `data` | Data engineering, pipelines, analytics, storage |

### 3.2 Technology Tags (`tech/*`)
Tag applied when a note is primarily about or heavily references a specific technology.

| Tag | Scope |
|-----|-------|
| `python` | Python language, packages, tooling |
| `typescript` | TypeScript, JavaScript, Node.js ecosystem |
| `rust` | Rust language, cargo, systems programming |
| `go` | Go language, concurrency patterns |
| `docker` | Containers, Dockerfiles, compose, images |
| `kubernetes` | K8s, orchestration, Helm, operators |
| `redis` | Redis caching, queues, data structures |
| `postgres` | PostgreSQL, SQL tuning, migrations |

### 3.3 Workflow Tags
Tag describing the current lifecycle or action intent of a note.

| Tag | Meaning |
|-----|---------|
| `planning` | Design phase, architecture decisions, RFCs |
| `implementation` | Active coding, build notes, implementation details |
| `debugging` | Bug investigation, root cause analysis, fix notes |
| `refactor` | Code restructuring, cleanup, tech debt |
| `deployment` | Release notes, deploy checklists, runbooks |
| `todo` | Actionable item that needs human attention |
| `decision` | Architectural or strategic decision with rationale |
| `question` | Open question that needs investigation or answer |
| `insight` | A discovery, realization, or "aha" moment |
| `bug` | Defect report with reproduction steps and fix |

### 3.4 Quality Tags
Tag that signals the production-readiness of a note's content.

| Tag | Meaning |
|-----|---------|
| `evergreen` | Mature, reviewed, high-confidence — the best version of this idea |
| `draft` | Work in progress, incomplete, or unreviewed |
| `review-needed` | Needs peer/agent review before it can be marked evergreen |
| `deprecated` | Superseded by a newer note — kept for historical reference |

### 3.5 Source Type Tags
Tag applied to raw source material in `1-raw/`.

| Tag | Meaning |
|-----|---------|
| `article` | Web article, blog post, newsletter |
| `paper` | Academic paper, arXiv preprint, research |
| `video` | YouTube, conference talk, lecture recording |
| `code-session` | Claude Code / Codex / Hermes session log |
| `meeting` | Call transcript, meeting notes |
| `book` | Book notes, chapter summaries, highlights |

### 3.6 Note Type Tags
Structural tag applied to every note to identify its role in the vault.

| Tag | Meaning |
|-----|---------|
| `atom` | Zettelkasten atomic note — one concept per page |
| `moc` | Map of Content — topic overview linking atoms |
| `daily` | Daily journal/log note |
| `project` | Active project dashboard |
| `entity` | Person, organization, tool, model, or product |
| `concept` | Matured, synthesized evergreen concept page |
| `principle` | Distilled mental model, heuristic, or principle |
| `comparison` | Side-by-side analysis of competing options |

---

## 4. Frontmatter Specifications

Every wiki note MUST include YAML frontmatter matching its type below. Unknown types default to atom with `type: note`.

### 4.1 Atom Notes (`2-notes/atoms/`)

```yaml
---
title: "Concept Name"
type: atom
status: seed | sapling | evergreen
created: YYYY-MM-DD
updated: YYYY-MM-DD
version: 1
tags: [from-taxonomy, at-least-one-domain-tag]
sources: [source-files-or-urls]
aliases: []
confidence: high | medium | low
contested: false
agent_visibility: summary | full | hidden
depends_on: [other-atom-filenames]
contradicts: [other-atom-filenames]
---
```

**Field rules:**
- `title` — display title (can differ from filename); use Title Case
- `status` — lifecycle: `seed` (new idea), `sapling` (developing), `evergreen` (mature)
- `tags` — at least 1 domain tag + at least 1 note type tag + any other relevant tags
- `sources` — list of `[[source-filename]]` or raw URLs; use `sources: []` if truly original
- `aliases` — alternate names, search terms, Chinese translations
- `confidence` — how certain the author is about the content (see §6.1)
- `contested` — `true` if there is a known disagreement or conflicting view (see §6.2)
- `agent_visibility` — `summary` (default: agents read only frontmatter + first section), `full` (agents may read entire note), `hidden` (agents skip this note)
- `depends_on` — prerequisite atoms; reader should understand these first
- `contradicts` — atoms with opposing conclusions; links to the debate

### 4.2 Daily Notes (`2-notes/daily/`)

```yaml
---
title: "YYYY-MM-DD"
type: daily
created: YYYY-MM-DD
tags: [daily]
mood:
energy:
highlights: []
agent_visibility: summary
---
```

**Field rules:**
- `mood` — free-text (e.g., "focused", "tired", "excited")
- `energy` — 1–10 scale
- `highlights` — list of 1–3 key moments from the day

**Required sections (see §5):**
- `## 👤 My Day` — human journal
- `## 🤖 Agent Activity` — auto-generated agent logs
- `## 📋 Decisions Made` — merged human + agent decisions

### 4.3 Code Session Notes (`1-raw/code-sessions/`)

```yaml
---
title: "Session YYYY-MM-DD-HHMM"
type: code-session
agent: claude-code | codex | hermes | manual
project: project-name
repo: repo-url-or-path
branch: branch-name
created: YYYY-MM-DDTHH:MM:SSZ
updated: YYYY-MM-DDTHH:MM:SSZ
duration_minutes: N
tags: [code-session, domain-tag, project-phase-tag]
key_files_changed: [paths]
key_decisions: [decisions]
problems_solved: [descriptions]
open_questions: [questions]
agent_visibility: full
---
```

**Field rules:**
- `agent` — which agent generated this session (or `manual` for human-written)
- `key_files_changed` — list of absolute or repo-relative paths
- `key_decisions` — 1-sentence decisions with brief rationale
- `problems_solved` — what was broken and how it was fixed
- `open_questions` — unresolved items for follow-up
- `agent_visibility` — default `full` so agents can learn from each other's sessions

### 4.4 MOC Notes (`2-notes/maps/`)

```yaml
---
title: "Topic Overview"
type: moc
status: active | stale
created: YYYY-MM-DD
updated: YYYY-MM-DD
version: 1
tags: [moc, domain-tag]
members: [list-of-member-notes]
aliases: []
agent_visibility: full
---
```

**Field rules:**
- `status` — `active` (regularly maintained) or `stale` (needs refresh)
- `members` — exhaustive list of all notes this MOC links to; used by agents for bulk queries

### 4.5 Project Notes (`2-notes/projects/`)

```yaml
---
title: "Project Name"
type: project
status: active | planning | blocked | completed | archived
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [project, domain-tag]
repo: repo-url
deadline: YYYY-MM-DD
stakeholders: []
agent_visibility: full
---
```

### 4.6 Entity Notes (`2-notes/entities/`)

For people, organizations, tools, models, products, or libraries.

```yaml
---
title: "Entity Name"
type: entity
entity_type: person | org | tool | model | product | library
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [entity, domain-tag, tech-tag]
aliases: []
links: [urls]
agent_visibility: summary
---
```

### 4.7 Concept Notes (`3-knowledge/concepts/`)

Matured atoms promoted to the knowledge layer (200+ line atoms that have been split and refined).

```yaml
---
title: "Concept Name"
type: concept
status: evergreen
created: YYYY-MM-DD
updated: YYYY-MM-DD
version: 1
tags: [concept, domain-tag]
sources: [source-files]
derived_from: [atom-filenames]
confidence: high | medium
contested: false
agent_visibility: full
---
```

### 4.8 Principle Notes (`3-knowledge/principles/`)

Distilled heuristics, mental models, and rules of thumb.

```yaml
---
title: "Principle Name"
type: principle
domain: domain-tag
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [principle, domain-tag]
sources: [source-files-or-experiences]
confidence: high | medium
agent_visibility: full
---
```

### 4.9 Comparison Notes (`3-knowledge/comparisons/`)

Side-by-side analyses of competing options (tools, patterns, approaches).

```yaml
---
title: "X vs Y: Dimension"
type: comparison
status: current | outdated
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [comparison, domain-tag]
options: [option-a, option-b]
verdict: option-a | option-b | depends | none
confidence: high | medium | low
agent_visibility: full
---
```

### 4.10 Query Notes (`3-knowledge/queries/`)

Filed research queries worth keeping. Includes the query, the answer, and sources.

```yaml
---
title: "Question text (short)"
type: query
status: answered | open | partially-answered
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [query, domain-tag]
answer_summary: "One-line answer"
confidence: high | medium | low
agent_visibility: full
---
```

---

## 5. Agent Section Conventions

### 5.1 Daily Note Agent Sections

Every daily note MUST include these sections with machine-parseable markers so agents can surgically append via heading-targeted PATCH operations:

```markdown
## 👤 My Day
<!-- Human-written journal — agents NEVER write here -->

## 🤖 Agent Activity

### Claude Code
<!-- AGENT_SECTION:claude-code -->
<!-- Agents append session summaries here -->

### Codex
<!-- AGENT_SECTION:codex -->
<!-- Agents append session summaries here -->

### Hermes
<!-- AGENT_SECTION:hermes -->
<!-- Agents append task summaries here -->

## 📋 Decisions Made
<!-- AGENT_SECTION:decisions -->
<!-- Merged decisions from humans + all agents -->
```

**Agent rules for daily notes:**
- Write ONLY inside your `<!-- AGENT_SECTION:* -->` block
- Use heading-targeted PATCH (`Target-Type: heading`, `Target: Agent Activity`) via `obsidian-local-rest-api` MCP
- Never modify the `## 👤 My Day` section
- Append to decisions by adding `- [YYYY-MM-DD HH:MM] [agent] Decision: ...`
- If using filesystem access (not MCP), search for your section marker before writing

### 5.2 Agent Visibility Control

Every wiki note carries `agent_visibility` in frontmatter:

| Value | Agent Behavior |
|-------|---------------|
| `summary` (default) | Agent reads frontmatter + first `##` section only. Sufficient for most atoms and entities. |
| `full` | Agent may read and process the entire note. Required for MOCs, concepts, principles, code sessions. |
| `hidden` | Agent skips this note entirely. Use for personal/private notes that should never enter agent context. |

Agent implementations:
- Before reading a note, check `agent_visibility` from frontmatter
- `hidden` notes should be excluded from search results, MOC member lists, and link traversal
- When in doubt, default to `summary` to prevent context window explosion

### 5.3 Agent Logging

All agents append to `log.md` inside the `<!-- AGENT_LOG -->` marker section:

```markdown
<!-- AGENT_LOG -->
| Timestamp | Agent | Action | Files | Rationale |
|-----------|-------|--------|-------|-----------|
| 2026-07-07T14:30:00Z | claude-code | create | atoms/redis-caching.md | New pattern discovered in auth-refactor |
```

---

## 6. Quality Signals

### 6.1 Confidence

Every atom, concept, principle, and comparison carries a `confidence` field:

| Level | Meaning | When to Use |
|-------|---------|-------------|
| `high` | Well-understood, backed by multiple sources and personal experience | Established patterns, widely-documented concepts |
| `medium` | Reasonably confident, but with some uncertainty or limited sources | Newer learnings, single-source findings |
| `low` | Speculative, early understanding, or conflicting evidence | Fresh discoveries, hot takes, hypotheses |

Agents should weigh `confidence` when synthesizing: prefer `high` confidence atoms over `low` ones when building summaries or answering questions. When an agent disagrees with a `low` confidence atom and has stronger evidence, it should update the atom and bump confidence.

### 6.2 Contested

The `contested: true` flag marks atoms where there is known disagreement or conflicting evidence.

**When to set `contested: true`:**
- Two or more sources make contradictory claims about the same concept
- Community debate exists (e.g., "monorepo vs polyrepo")
- The atom's conclusion is disputed by another atom in `contradicts:`
- An agent discovers evidence that conflicts with the atom's thesis

**Resolution process:**
1. Create a second atom with the opposing view (link both via `contradicts:`)
2. Set `contested: true` on both
3. Create or update a MOC that frames the debate
4. If resolved, set `contested: false` and update `confidence` on the winning atom; deprecate the losing one

### 6.3 Status Lifecycle

```
seed ──→ sapling ──→ evergreen
  │                    │
  └──→ deprecated ←────┘
```

| Status | Criteria |
|--------|----------|
| `seed` | New idea, 1–2 paragraphs, may be incomplete. Created when a concept appears in 2+ sources or is central to a session. |
| `sapling` | Developing, 3–5 paragraphs, at least 2 wikilinks, initial review done. |
| `evergreen` | Mature, reviewed (human or agent), high confidence, complete wikilinks, changelog present. Ready for promotion to `3-knowledge/concepts/` if 200+ lines. |
| `deprecated` | Superseded by a newer note. Contains a `superseded_by: [[new-note]]` link in frontmatter. Moved to `4-archive/_retired/`. |

---

## 7. Page Creation Thresholds

### When to CREATE a new note

| Note Type | Threshold |
|-----------|-----------|
| **Atom** | A concept appears in **2+ distinct sources** OR is central to a code session OR requested by user |
| **MOC** | **5+ atoms** share a domain tag and there is no existing MOC for that domain |
| **Entity** | A person, tool, or model is referenced in **3+ notes** across the vault |
| **Concept** | An atom reaches **200+ lines** and warrants promotion to the knowledge layer |
| **Principle** | A pattern or heuristic is observed in **3+ distinct projects** or sessions |
| **Comparison** | User or agent needs to decide between **2+ competing options** with real trade-offs |
| **Project** | Any multi-session, multi-day effort with a defined deliverable |
| **Daily** | Auto-created every day (even if empty — serves as an anchor for agent activity) |

### When NOT to create

- **Passing mentions** — a technology name dropped once in a code session does not justify an atom
- **Single-source trivia** — one-off facts from a single article belong in the article's source note, not as standalone atoms
- **Duplicates** — search `index.md` and existing atoms before creating; if a concept already exists, extend the existing note
- **Micro-notes** — atoms must be at least 2 paragraphs; anything less should be a bullet in a MOC or daily note
- **Orphan nodes** — every new atom must link to at least 2 existing notes; if you can't find 2 things to link to, the concept isn't ripe yet

### Page Splitting

When an atom exceeds **200 lines**:

1. Identify sub-concepts that can stand alone
2. Create new atom(s) for each sub-concept
3. Replace the original content with a summary + outbound links to the new atoms
4. Promote the original (if now a synthesis) to `3-knowledge/concepts/` with `type: concept`
5. Update the MOC and `index.md`

### Archiving

Move to `4-archive/` when:
- **Projects:** status moves to `completed` or `archived`
- **Atoms:** marked `deprecated` and superseded by a newer note
- **Stale content:** no updates in 180+ days AND no inbound links from evergreen notes

Archive process:
1. Move file to `4-archive/projects/` or `4-archive/_retired/`
2. Add `archived: YYYY-MM-DD` to frontmatter
3. Update `index.md` (strikethrough the entry)
4. Log to `log.md`
5. Never delete — archiving is reversible

---

## 8. Vault Directory Structure

```
vault/
├── .obsidian/              # Obsidian config (gitignored: workspace, hotkeys, appearance)
├── .claudian/              # Claudian agent settings
├── .claude/                # Claude Code skills and context
├── SCHEMA.md               # ← THIS FILE — vault constitution
├── index.md                # Content catalog with one-line summaries
├── mobile-home.md          # Mobile-optimized dashboard (pinned on phone)
├── log.md                  # Append-only chronological action log
├── README.md               # Human onboarding guide
│
├── 0-inbox/                # Capture zone
│   └── fleeting/           # Quick thoughts, voice memos, mobile captures
│
├── 1-raw/                  # LAYER 1: Immutable source material
│   ├── articles/           # Web articles, clippings
│   ├── papers/             # PDFs, arxiv papers, research
│   ├── transcripts/        # Meeting notes, call transcripts
│   ├── code-sessions/      # Agent session summaries (auto-generated)
│   └── assets/             # Images, diagrams
│
├── 2-notes/                # LAYER 2: Working notes
│   ├── atoms/              # Zettelkasten atomic notes
│   ├── maps/               # MOCs — topic overviews
│   ├── entities/           # People, orgs, tools, models
│   ├── projects/           # Active projects
│   ├── areas/              # Ongoing responsibilities
│   └── daily/              # Daily notes
│
├── 3-knowledge/            # LAYER 3: Synthesized evergreen knowledge
│   ├── concepts/           # Matured concept pages
│   ├── comparisons/        # Side-by-side analyses
│   ├── principles/         # Distilled mental models, heuristics
│   └── queries/            # Filed research queries
│
├── 4-archive/              # Completed and superseded
│   ├── projects/           # Completed projects
│   └── _retired/           # Superseded wiki pages
│
├── templates/              # Note templates (Templater)
│   ├── t-daily.md
│   ├── t-atom.md
│   ├── t-code-session.md
│   ├── t-project.md
│   ├── t-person.md
│   └── t-moc.md
│
├── scripts/                # Automation
│   ├── dataview/           # Dataview query library
│   └── quickadd/           # QuickAdd macros and captures
│
└── _agent/                 # Agent-curated summary notes (reduces context window)
```

---

## 9. Plugin Dependencies

Core plugins and their relationships. Disabling one may silently break others.

| Plugin | Purpose | Depends On | Depended On By |
|--------|---------|------------|----------------|
| **Claudian** | Agent chat sidebar | — | Daily digest workflow |
| **Obsidian Git** | Auto git backup/sync | — | Backup verification |
| **obsidian-local-rest-api** | MCP for agent access | — | All agent operations |
| **Templater** | Advanced templates | — | Daily note creation, all templates |
| **Dataview** | Query vault as database | — | Dashboards, analytics, MOC auto-population |
| **QuickAdd** | Quick capture, macros | Templater | Inbox capture workflow |
| **Tasks** | Task management | Dataview (optional) | Project dashboards |
| **Calendar** | Visual daily note navigation | Daily notes | Daily workflow |

**Plugin version pinning:** Do not auto-update plugins. Review changelogs before updating. Git-track `.obsidian/` before any plugin or theme update so you can `git diff` and revert.

---

## 10. Sync and Git Conventions

### 10.1 .gitignore

The following are excluded from git sync:
- `.obsidian/workspace.json`, `.obsidian/workspace-mobile.json` — device-specific layouts
- `.obsidian/hotkeys.json`, `.obsidian/appearance.json` — personal preferences
- `.obsidian/plugins/*/data.json` — plugin-specific state (gitignore by pattern)
- `.DS_Store`, `Thumbs.db` — OS files
- `*secret*`, `*token*`, `*api-key*`, `*password*`, `*.env` — sensitive patterns
- `.claudian/`, `.claude/`, `.codex/` — agent working files (device-specific)

### 10.2 Commit Convention

Auto-commits via Obsidian Git plugin:
- Interval: 15 minutes
- Pull on startup: enabled
- Push on commit: enabled
- Message format: `auto: {{date}} — {{numFiles}} files`

Manual commits:
- Prefix: `vault:` or `agent:`
- Example: `vault: add redis-caching-pattern atom` or `agent: nightly cross-agent synthesis`

### 10.3 Pre-Commit Checks

Before committing (or via pre-commit hook):
- `gitleaks detect --source .` — scan for secrets
- No broken `[[wikilinks]]` to new files
- Frontmatter validates against schema for each changed file

---

## 11. Agent Operating Rules

All AI agents (Claude Code, Codex, Hermes) operating on this vault MUST follow these rules:

1. **Read SCHEMA.md first** — understand the conventions before any operation
2. **Check `index.md`** — find existing content before creating new notes
3. **Log everything** — append to `log.md` after every create/update/delete/archive
4. **Respect `agent_visibility`** — skip `hidden` notes, summarize `summary` notes, read `full` notes
5. **Use MCP when available** — prefer `obsidian-local-rest-api` over raw filesystem writes
6. **Target by heading** — use heading-targeted PATCH for surgical edits to avoid merge conflicts
7. **Write to agent sections only** — in daily notes, stay inside your `<!-- AGENT_SECTION:* -->` block
8. **Follow frontmatter specs** — every created note must have complete, valid frontmatter
9. **Use `[[wikilinks]]`** — never raw Markdown links to internal vault files
10. **Update `index.md`** — add every new wiki page to the catalog
11. **Bump version on update** — increment `version` and set `updated` date
12. **Tag from taxonomy** — never invent new tags; propose additions to SCHEMA.md first
13. **Prefer updating over duplicating** — search before creating; extend existing notes
14. **Link to at least 2 existing notes** — every new atom must connect to the existing knowledge graph

---

## 12. Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.1 | 2026-07-07 | Added mobile access conventions: `mobile-home.md` dashboard, mobile-optimized page naming rule (§2.1), mobile-home in directory structure (§8). Added `mobile` domain tag to taxonomy (§3.1). |
| 1 | 2026-07-07 | Initial vault constitution. Defined 20-tag taxonomy, 10 frontmatter specs, quality signals, agent conventions, page thresholds, and operating rules. |
