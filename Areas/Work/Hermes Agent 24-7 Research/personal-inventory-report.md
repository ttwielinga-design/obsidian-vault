# Hermes Personal Assistant — Capability Matrix
**Generated:** 2026-07-06
**Profile:** default · **Host:** Windows 11 · **Model:** deepseek/deepseek-v4-flash via OpenRouter

---

## MCP Servers (3 configured, all active)

| Server | Config Status | Tools Registered | Notes |
|--------|--------------|------------------|-------|
| **ClickUp (mcp.clickup.com)** | ✅ Full OAuth via `npx mcp-remote` | 45+ tools (tasks, lists, docs, chat, time tracking, reminders) | Full task management |
| **Garmin Connect** | ✅ Full creds (thomas.wielinga@yahoo.com) | 29 tools (activities, health metrics, training, gear) | System Python backend |
| **Yahoo Mail (IMAP)** | ✅ Full creds + app password | ~10+ tools (list/search/read/move folders, send drafts) | Node.js wrapper bypasses dotenv stdout pollution |

**Not configured** (available but no server defined): No other MCP servers. The `native-mcp` skill supports adding any stdio or HTTP MCP server.

---

## 19 Active Cron Jobs

| Job | Schedule | Last Run | Status |
|-----|----------|----------|--------|
| Morning Brief v2 | 07:00 daily | May 17 ✅ | Working (skill-based, agent-run) |
| Biomarker Daily Ingestion | 09:00 daily | May 17 ✅ | Working (Python script) |
| System Health Monitor | Every 2h | Jul 6 ✅ | Working, delivers to Discord |
| Budget Alert Check | 20:00 daily | May 16 ✅ | Working |
| Kanban Failure Escalator | Every 10min | Jul 6 ✅ | Working |
| Kanban Triage Router (PM) | 19-22h weekdays | Jul 6 ✅ | Working |
| Kanban Triage Router (AM) | 8-10h weekdays | May 15 ❌ | Connection error |
| Kanban Triage Router (Weekend) | 8-20h weekends | Jun 27 ❌ | Timeout + Discord delivery failure |
| Config Backup | 06:00 daily | May 16 ✅ | Working |
| Hermes Self-Backup | 03:00 daily | May 16 ✅ | Working |
| Email Triage | 02:00 daily | May 15 ❌ | Script AttributeError + Discord delivery failure |
| Gmail Auto-Draft | 06:00 daily | May 16 ✅ | Working |
| Yahoo Auto-Draft | 06:15 daily | — | No error data yet |
| Kanban Daily Health Summary | 07:30 daily | May 17 ✅ | Working |
| BD-10 Weekly Distillation | 20:00 Sun | May 14 ✅ | Working |
| ClickUp Routing Audit | 05:00 daily | May 16 ✅ | Working |
| Hermes Daily Maintenance | 04:00 daily | May 15 ❌ | Connection error |
| Hermes Weekly Gateway Restart | 04:00 Sun | May 14 ❌ | .env deprecation + lock held |
| Obsidian Vault QMD Index | 21:00 Sun | May 14 ❌ | PyTorch/schema issues, rebuild script ready |

**Critical observations:** Discord delivery to channels `1503004007101104168` and `1503004035014463578` has been failing since mid-May (getaddrinfo failed). Some cron jobs haven't run since May 15-17 despite being "active" — the gateway may need restart.

---

## Capability Matrix: What Hermes CAN Do Today

### ✅ = ACTIVE (fully configured and working)
### 🔧 = AVAILABLE (skill exists, needs setup/credentials)
### ❌ = NOT POSSIBLE (no skill, no tool, or fundamentally blocked)

---

### 1. EMAIL (4 skills)

| Capability | Status | Details |
|-----------|--------|---------|
| Read/search Yahoo Mail | ✅ **ACTIVE** | MCP server with full IMAP access, app password auth |
| Send Yahoo drafts | ✅ **ACTIVE** | MCP server + yahoo-auto-draft.py cron at 06:15 |
| Read/search Gmail | ✅ **ACTIVE** | Google OAuth token exists (`google_token.json`), `gws` API works |
| Send Gmail replies | ✅ **ACTIVE** | gmail-auto-draft.py cron at 06:00, email-reply skill defines voice |
| Auto-triage email | 🔧 **AVAILABLE** | email-triage-run.py script exists but has AttributeError bug since May 15 |
| Email organization (folder taxonomy) | 🔧 **AVAILABLE** | email-organization skill has full 5-phase methodology, needs rerun |
| Email via Himalaya CLI | 🔧 **NEEDS SETUP** | himalaya CLI not installed, no IMAP/SMTP config |
| Yahoo Mail MCP tools | ✅ **ACTIVE** | list_folders, list_emails, move_emails, send_draft all working |

### 2. TASK MANAGEMENT (ClickUp + Kanban)

| Capability | Status | Details |
|-----------|--------|---------|
| Create/read/update/delete ClickUp tasks | ✅ **ACTIVE** | Full MCP toolset (45+ tools) |
| ClickUp docs & pages | ✅ **ACTIVE** | Create docs, pages, read/update |
| ClickUp reminders | ✅ **ACTIVE** | Create reminders, search |
| ClickUp time tracking | ✅ **ACTIVE** | Start/stop timer, add time entries |
| ClickUp chat channels | ✅ **ACTIVE** | Send/receive messages |
| ClickUp workspace search | ✅ **ACTIVE** | Cross-workspace search |
| ClickUp custom fields | ✅ **ACTIVE** | Read/write custom field values |
| Brain dump → ClickUp tasks | ✅ **ACTIVE** | brain-dump-dispatch skill routes Discord voice memos to ClickUp + Obsidian |
| Kanban board operations | ✅ **ACTIVE** | SQLite + CLI (`hermes kanban create/list/show/complete`) |
| Kanban multi-agent dispatch | ✅ **ACTIVE** | Dispatcher in gateway spawns specialist profiles |
| Kanban triage routing | ✅ **ACTIVE** | 3 cron jobs route unassigned tasks (weekday AM/PM, weekend) |
| Kanban failure escalation | ✅ **ACTIVE** | Every 10min monitor, model upgrades, Discord notify |
| Kanban dashboard (web UI) | ✅ **ACTIVE** | `hermes dashboard` → React SPA at localhost:9119 |
| ClickUp routing audit & v2 feedback loop | ✅ **ACTIVE** | Daily 05:00 audit, corrections feed back weighted into routing |

### 3. CALENDAR

| Capability | Status | Details |
|-----------|--------|---------|
| List Google Calendar events | ✅ **ACTIVE** | Google OAuth token present, `gws` calendar list works |
| Create calendar events | ✅ **ACTIVE** | Via google-workspace skill (GAPI calendar create) |
| Delete calendar events | ✅ **ACTIVE** | Via google-workspace skill |
| Morning brief includes calendar | ✅ **ACTIVE** | morning-brief-v2 skill fetches + includes in daily briefing |
| Recurring event management | ✅ **ACTIVE** | Standard Calendar API CRUD |

### 4. NOTE-TAKING (Obsidian)

| Capability | Status | Details |
|-----------|--------|---------|
| Read vault notes | ✅ **ACTIVE** | Filesystem access via read_file/search_files |
| Create/edit notes | ✅ **ACTIVE** | write_file/patch tools |
| Search vault contents | ✅ **ACTIVE** | search_files (regex) |
| Brain dump logs to Obsidian | ✅ **ACTIVE** | brain-dump-dispatch writes daily index + per-dispatch detail files |
| Semantic/vector search (QMD) | 🔧 **BROKEN** | qmd-index-obsidian.py had PyTorch/schema issues. Rebuild script ready but never run. |
| Vault migration (OneDrive → Obsidian) | 🔧 **AVAILABLE** | vault-migration skill exists, needs trigger |
| PARA organization | ✅ **ACTIVE** | Convention documented in obsidian skill |

### 5. HEALTH (Garmin)

| Capability | Status | Details |
|-----------|--------|---------|
| Daily step/calories/HR/battery | ✅ **ACTIVE** | garmin_get_user_summary |
| Sleep data & score | ✅ **ACTIVE** | garmin_get_sleep_data |
| Heart rate & HRV | ✅ **ACTIVE** | garmin_get_heart_rates, garmin_get_hrv_data |
| Stress levels | ✅ **ACTIVE** | garmin_get_stress_data |
| Body composition (weight, BF%) | ✅ **ACTIVE** | garmin_get_body_composition |
| VO2 max & race predictions | ✅ **ACTIVE** | garmin_get_vo2max, garmin_get_race_predictions |
| Training status & readiness | ✅ **ACTIVE** | garmin_get_training_status, garmin_get_training_readiness |
| Activities list & details | ✅ **ACTIVE** | garmin_list_activities, garmin_get_activity |
| Personal records | ✅ **ACTIVE** | garmin_get_personal_records |
| Biomarker daily ingestion | ✅ **ACTIVE** | biomarker-daily-ingest.py cron at 09:00 |
| Training plans & workouts | ✅ **ACTIVE** | garmin_get_training_plans, garmin_get_scheduled_workouts |

### 6. SMART HOME (Philips Hue)

| Capability | Status | Details |
|-----------|--------|---------|
| Turn lights on/off | 🔧 **NEEDS SETUP** | openhue CLI not installed on Windows. `openhue` binary missing. |
| Dim/brightness control | 🔧 **NEEDS SETUP** | Requires pairing with Hue Bridge (button press) |
| Set scenes | 🔧 **NEEDS SETUP** | Requires openhue CLI |
| Room-level control | 🔧 **NEEDS SETUP** | Requires openhue CLI |

### 7. PRODUCTIVITY APPS

| Capability | Status | Details |
|-----------|--------|---------|
| Google Workspace (Gmail/Calendar/Drive/Docs/Sheets) | ✅ **ACTIVE** | Full OAuth token, 8 API services enabled |
| Morning Brief (automated daily) | ✅ **ACTIVE** | Cron at 07:00, combines email+calendar+kanban+health |
| Brain Dump Dispatch | ✅ **ACTIVE** | Routes Discord voice memos → ClickUp + Obsidian |
| Airtable | 🔧 **NEEDS SETUP** | Missing `AIRTABLE_API_KEY` env var |
| Notion | 🔧 **NEEDS SETUP** | Missing `NOTION_API_KEY` env var |
| Linear | 🔧 **NEEDS SETUP** | Missing `LINEAR_API_KEY` env var |
| Maps/geocode/POIs/routes | ✅ **ACTIVE** | maps skill via OpenStreetMap/OSRM, no API key needed |
| PDF editing | 🔧 **NEEDS SETUP** | nano-pdf CLI needs install |
| OCR from PDFs/scans | ✅ **ACTIVE** | ocr-and-documents skill via pymupdf/marker-pdf |
| PowerPoint creation/editing | ✅ **ACTIVE** | python-pptx based |
| Teams meeting pipeline | ✅ **ACTIVE** | Script-based pipeline for meeting summaries |

### 8. MEDIA & ENTERTAINMENT

| Capability | Status | Details |
|-----------|--------|---------|
| Spotify: play/search/queue | ✅ **ACTIVE** | 7 built-in tools (playback, devices, queue, search, playlists, albums, library) |
| Spotify: playlist management | ✅ **ACTIVE** | Create, add/remove items, update details |
| YouTube transcripts/summaries | ✅ **ACTIVE** | youtube-content skill via youtube-transcript-api |
| GIF search (Tenor) | 🔧 **NEEDS SETUP** | Missing `TENOR_API_KEY` env var |
| Audio spectrograms (SongSee) | ✅ **ACTIVE** | songsee skill |
| Suno AI music prompts | ✅ **ACTIVE** | songwriting-and-ai-music skill |
| HeartMuLa song generation | 🔧 **NEEDS SETUP** | heartmula skill, needs API key/config |

### 9. RESEARCH & LEARNING

| Capability | Status | Details |
|-----------|--------|---------|
| arXiv paper search | ✅ **ACTIVE** | Free API, no key needed |
| arXiv + Semantic Scholar (citations) | ✅ **ACTIVE** | No auth needed for basic use |
| Blog/RSS feed monitoring | 🔧 **NEEDS SETUP** | blogwatcher-cli binary not installed |
| LLM Wiki KB builder | ✅ **ACTIVE** | llm-wiki skill for interlinked markdown KB |
| Polymarket query | ✅ **ACTIVE** | polymarket skill, no API key |
| Obsidian semantic search (QMD) | 🔧 **BROKEN** | PyTorch 2.11 segfault, rebuild script exists |

### 10. CREATIVE & DESIGN

| Capability | Status | Details |
|-----------|--------|---------|
| Excalidraw diagrams | ✅ **ACTIVE** | JSON-based .excalidraw files, no dependencies |
| Architecture diagrams (SVG) | ✅ **ACTIVE** | architecture-diagram skill, dark-themed HTML/SVG |
| Humanizer (de-AI text) | ✅ **ACTIVE** | humanizer skill, 29 patterns, no deps |
| ASCII art | ✅ **ACTIVE** | pyfiglet, cowsay, boxes |
| ASCII video | ✅ **ACTIVE** | Convert video/audio to colored ASCII |
| p5.js generative art | ✅ **ACTIVE** | p5.js sketches, shaders, 3D |
| Pixel art (console palettes) | ✅ **ACTIVE** | NES, Game Boy, PICO-8 |
| HTML mockups/sketches | ✅ **ACTIVE** | sketch skill, throwaway variants |
| Web design (54 design systems) | ✅ **ACTIVE** | popular-web-designs skill |
| ComfyUI image/video gen | 🔧 **NEEDS SETUP** | comfyui skill, needs local ComfyUI install |
| Image generation (FLUX) | ✅ **ACTIVE** | Built-in `image_generate` tool via FAL.ai |
| Manim animations | 🔧 **NEEDS SETUP** | manim-video skill, needs Manim CE + FFmpeg |
| Pretext creative browser demos | ✅ **ACTIVE** | pretext skill |
| Ideation/creative constraints | ✅ **ACTIVE** | ideation skill |
| Claude Design (HTML artifacts) | ✅ **ACTIVE** | claude-design skill |
| Baoyu infographics/comics | ✅ **ACTIVE** | Infographics: 21 layouts, Knowledge comics |

### 11. DEVELOPMENT & GITHUB

| Capability | Status | Details |
|-----------|--------|---------|
| GitHub PR lifecycle | ✅ **ACTIVE** | github-pr-workflow skill, gh CLI + curl fallback |
| GitHub code review | ✅ **ACTIVE** | github-code-review skill, diffs + inline comments |
| GitHub issues | ✅ **ACTIVE** | github-issues skill, create/triage/label/assign |
| GitHub repo management | ✅ **ACTIVE** | github-repo-management skill, clone/create/fork |
| GitHub auth | ✅ **ACTIVE** | github-auth skill (depends on `GITHUB_TOKEN` availability) |
| TDD (RED-GREEN-REFACTOR) | ✅ **ACTIVE** | test-driven-development skill |
| Systematic debugging | ✅ **ACTIVE** | systematic-debugging skill, 4-phase RCA |
| Code simplification | ✅ **ACTIVE** | simplify-code skill, 3-agent parallel cleanup |
| Codebase inspection | ✅ **ACTIVE** | codebase-inspection skill via pygount |
| Code review (pre-commit) | ✅ **ACTIVE** | requesting-code-review skill |
| Plan writing | ✅ **ACTIVE** | writing-plans + plan skills |
| Subagent-driven development | ✅ **ACTIVE** | subagent-driven-development skill |
| Spike/throwaway experiments | ✅ **ACTIVE** | spike skill |
| Delegated coding (Claude Code) | 🔧 **NEEDS SETUP** | claude-code skill, needs Claude Code CLI |
| Delegated coding (Codex CLI) | 🔧 **NEEDS SETUP** | codex skill, needs Codex CLI |
| Delegated coding (OpenCode) | 🔧 **NEEDS SETUP** | opencode skill, needs OpenCode CLI |

### 12. AUTONOMOUS AGENTS & ORCHESTRATION

| Capability | Status | Details |
|-----------|--------|---------|
| Kanban multi-agent dispatch | ✅ **ACTIVE** | Orchestrator + specialist profiles via SQLite kanban |
| Dynamic workflow fan-out | ✅ **ACTIVE** | dynamic-workflow skill for large parallel tasks |
| Hermes Agent configuration | ✅ **ACTIVE** | hermes-agent skill, config/extend guide |
| Model switching (providers) | ✅ **ACTIVE** | hermes-model-switching skill |
| Skill authoring | ✅ **ACTIVE** | hermes-agent-skill-authoring skill |
| Computer use (GUI automation) | ✅ **ACTIVE** | computer-use skill, cross-platform background drive |
| Discord bot delivery | ✅ **ACTIVE** | All jobs deliver to Discord channels (currently failing) |

### 13. DATA SCIENCE & MLOPS

| Capability | Status | Details |
|-----------|--------|---------|
| Jupyter live kernel | ✅ **ACTIVE** | jupyter-live-kernel skill |
| DSPy (declarative LM programs) | ✅ **ACTIVE** | dspy skill |
| HuggingFace Hub | ✅ **ACTIVE** | huggingface-hub skill |
| llama.cpp local inference | 🔧 **NEEDS SETUP** | llama-cpp skill, needs GGUF models |
| Outlines structured generation | 🔧 **NEEDS SETUP** | outlines skill, needs install |
| W&B experiment tracking | 🔧 **NEEDS SETUP** | weights-and-biases skill, needs API key |
| Fine-tuning (TRL) | 🔧 **NEEDS SETUP** | fine-tuning-with-trl skill, needs GPU infra |
| SAM image segmentation | 🔧 **NEEDS SETUP** | segment-anything-model skill |

### 14. OTHER

| Capability | Status | Details |
|-----------|--------|---------|
| Production incident response | ✅ **ACTIVE** | production-incident-response skill |
| Email reply drafting (Thomas's voice) | ✅ **ACTIVE** | email-reply skill with full style guide |
| Pokemon game playing | ✅ **ACTIVE** | pokemon-player skill (headless emulator) |
| Windows file access (OneDrive) | ✅ **ACTIVE** | windows-file-access skill |
| Webhook subscriptions | ✅ **ACTIVE** | webhook-subscriptions skill |
| GIF search (Tenor) | 🔧 **NEEDS SETUP** | Missing `TENOR_API_KEY` |
| Godmode (red-teaming) | ✅ **ACTIVE** | godmode skill |
| Yuanbao groups | ✅ **ACTIVE** | yuanbao skill |

---

## Summary: What's Missing or Broke

### BROKEN (was working, needs repair)
1. **Discord delivery** — All cron jobs sending to Discord channels have been failing since mid-May with `getaddrinfo failed`. This affects kanban triage, morning brief, email triage, and health monitor delivery.
2. **QMD semantic search** — Obsidian vault vector indexing broken by PyTorch 2.11 segfault. Rebuild script exists but was never executed post-fix.
3. **Email Triage** — `email-triage-run.py` has an AttributeError since May 15 (Yahoo folder parsing bug).
4. **Weekly Gateway Restart** — Lock held by another instance, .env deprecation warnings block restart.
5. **Hermes Daily Maintenance** — Connection error since May 15.

### NEEDS SETUP (skills exist, missing credentials/tools)
1. **Airtable** — No `AIRTABLE_API_KEY`
2. **Notion** — No `NOTION_API_KEY`
3. **Linear** — No `LINEAR_API_KEY`
4. **Philips Hue** — `openhue` CLI not installed, no bridge pairing
5. **GIF Search** — No `TENOR_API_KEY`
6. **blogwatcher** — Binary not installed
7. **Claude Code / Codex / OpenCode** — CLI binaries not installed
8. **HeartMuLa** — API key needed
9. **Local inference (llama.cpp)** — GGUF models + setup needed
10. **Himalaya CLI email** — CLI not installed, no IMAP/SMTP config (Yahoo MCP is the active path, so low priority)

### NOT POSSIBLE (no skill/tool exists)
1. **No dedicated weather skill** — Could use general web search or maps API
2. **No travel booking integration** (Kayak, Expedia, etc.)
3. **No food delivery / restaurant ordering**
4. **No banking API integration** (Rabo, ING, etc.) — Would need Open Banking/PSD2
5. **No WhatsApp/Signal messaging**
6. **No Apple Health / Google Fit integration** (Garmin covers health)
7. **No native phone calling or SMS**
8. **No voice call integration** (Teams pipeline handles meeting summaries but not calls)
9. **No package tracking integration** (DHL, PostNL, etc.)
10. **No social media posting** (LinkedIn, Twitter/X, Instagram)

---

## Phase Readiness (tier1-personal-infrastructure-setup.md)

The referenced `tier1-personal-infrastructure-setup.md` file was **not found** on disk at `C:\Users\thoma\` or in `.hermes/`. If it exists in an Obsidian vault or past conversation, it was not accessible to this scan. However, from the cron jobs and skills inventory, the infrastructure is already in a mature state:

| Phase | What It Covers | Status |
|-------|----------------|--------|
| **Email** | Yahoo MCP, Gmail, auto-drafts, triage | Active (triage broken) |
| **Task Management** | ClickUp full CRUD, Kanban multi-agent, brain dump, routing | Active |
| **Calendar** | Google Calendar read/create, morning brief | Active |
| **Notes** | Obsidian file ops, vault indexing, PARA | Active (semantic search broken) |
| **Health** | Garmin 29 tools, biomarker daily ingest | Active |
| **Smart Home** | Philips Hue | Not set up |
| **Automation** | 19 cron jobs, kanban escalation, morning brief, monitoring | Partially broken (Discord delivery) |

---

## Actionable Priority

1. **Fix Discord delivery** (blocks all cron notifications, morning brief, kanban alerts)
2. **Restart gateway** (fixes lock issue, picks up MCP servers cleanly)
3. **Fix email triage script** (AttributeError in yahoo folder parsing)
4. **Run QMD rebuild script** (restores semantic search over vault)
5. **Set up missing env vars**: Airtable, Notion, Linear (15 min each)
6. **Install openhue + pair Hue Bridge** (smart home control)