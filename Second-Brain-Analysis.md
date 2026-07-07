---
title: "Second Brain Architecture Analysis"
date: 2026-05-14
type: analysis
area: resources
tags: [type/analysis, area/resources, status/draft, topic/obsidian]
---

# Obsidian Vault Architecture Analysis & Second Brain Recommendations

## Current Vault State

### Owner Profile
**Thomas Wielinga**, 25 years old, Dutch, living in Utrecht. Professional identity: strategic generalist with technical fluency in hospitality/finance/real estate/AI. Runs:
- Aedes (hotel development, junior PM)
- AI consulting (Mariam Vossough, Raghav Skills collaborators)
- BeBright (reactivated 2026 as paid cocktail engagement)
- Rental income (property at Arthur van Schendelstraat 197)
- DayVibe (primary product bet - voice-first AI journaling)

### Vault Structure (813 markdown files)

```
ThomasVault/
├── _about-thomas.md          # 274-line personal profile - LLM navigation anchor
├── _registry.md             # Full navigation map with tag taxonomy
├── Archive/                  # Hotel Investment, Education, BMad-Method framework
├── Areas/
│   ├── Finance/              # Budgeting, Net Worth, Reports, Housing, Legal Docs, Journal
│   ├── Health/
│   │   └── Daily/_index.md   # Health tracking template - Garmin biomarkers framework
│   ├── People/               # 33 contacts with relationship context
│   └── Work/                 # AI Consulting, Client Projects, Invoicing, Tenant Communications
├── Brain Dump/               # Quick-capture + routing-rules.md (email triage from brain-dump-dispatch)
├── Daily/                    # 2018-2026 daily entries (~321 total)
│   └── 2026/05/             # Recent entries, mostly project notes not daily journaling
├── Inbox/                    # Unprocessed items
└── Projects/
    ├── DayVibe/              # Primary product (Design, Product, Marketing, Legal, Research)
    ├── Florence Aug 2026/
    ├── MindBoost/
    ├── Park56/
    └── CompanySearcher/
```

### Tag Taxonomy (well-structured)
- `#type/`: daily, note, guide, reference, template, code, contract, meeting, research, legal, financial, journal, index
- `#area/`: finance, work, health, people, projects, resources, education, daily
- `#project/`: dayvibe, hotel-investment, bebright, florence-2026, mindboost, park56, company-searcher
- `#status/`: active, archived, draft
- `#topic/`: ai, strategy, hospitality, software, finance-theory, bpi, marketing, legal, personal

## What's Being Captured

### ✓ Strong Coverage
| Domain | What's Captured | Quality |
|--------|-----------------|---------|
| **People** | 33 detailed person notes with relationship tiers | Excellent - warm/cold distinction, professional/personal registers |
| **Finance** | Budgeting tracker, net worth, annual statements, CFO synthesis (4-playbook analysis) | Excellent - systematic analysis, legal docs organized |
| **Work** | AI consulting methodology, 37 client deliverables archived, invoicing | Good - strong templates, history archived |
| **Projects** | DayVibe (extensive), Florence, MindBoost, Park56, CompanySearcher | Good for DayVibe, others are stubs |
| **Daily Notes** | 321 entries spanning 2018-2026 with decisions/events/reflections | Mixed - many are project refs, not journaling |

### Health/Daily Structure
The `Health/Daily/_index.md` defines a **Garmin biomarker template** but:
- No actual daily health files exist (only `_index.md` in the folder)
- Template includes: Resting HR, HRV, Sleep, Body Battery, Steps, Calories, Stress, Training Status
- Plus subjective check-in: sleep quality, energy, mood, muscle soreness, knee pain
- **This is structured and ready but unused** - missed opportunity

### Brain Dump & brain-dump-dispatch Connection
- `Brain Dump/routing-rules.md` = output from email triage analysis
- Contains routing error patterns and implementation status
- Connects to Yahoo digest runs and email dispatch workflows
- Shows systematic thinking about automation gaps

### QMD Semantic Search
- Script exists: `qmd-index-obsidian.py` 
- Points to `~/.qmd/db.sqlite` (default) or `OBSIDIAN_VAULT_PATH` env var
- Uses `sentence-transformers/all-MiniLM-L6-v2` for embeddings (384-dim)
- **Status**: Not currently indexed (no db.sqlite in ~) - potential to activate

## What's Missing

### Critical Gaps
1. **Health data integration** - Template exists but no actual biomarker ingestion
2. **Calendar/scheduling data** - No iCal/Google Calendar syncing to vault
3. **Automated email capture** - Brain Dump exists but isn't connected to live email
4. **Project status tracking** - Many project indices are stubs
5. **Habit tracking** - No daily habits system despite DayVibe focus on habits
6. **Goal/intention capture** - No explicit OKRs or outcome tracking

### Structural Opportunities
1. **PARA method** - Vault uses PARA but could be stricter:
   - Projects = truly finite-outcome (DayVibe, Florence are good examples)
   - Areas = ongoing responsibilities (Health/Daily should be area, not empty)
   - Resources = reference only (clean)
   - Archives = completed/history (good)

2. **Second-brain connective tissue**:
   - People → Projects: Link collaborators to specific deliverables
   - Health → Work: Energy levels affecting productivity (missing)
   - Finance → Projects: Budget allocation per project (missing)
   - Daily → All: Cross-referencing by date/project/type (partial)

## Recommended Second-Brain Architecture

### Tier 1: Core Infrastructure (Implement Now)
```
Daily/
├── YYYY/MM/YYYY-MM-DD.md              # Standard journaling template
├── Health/                           # MOVE HERE from Areas/Health
│   └── YYYY-MM-DD-health.md         # Daily health + biomarkers (Garmin automated)
├── Projects/                         # Project activity logs
│   └── dayvibe-YYYY-MM-DD.md        # DayVibe-specific daily entries
└── Meetings/                         # Meeting notes with auto-linking

Inbox/
├── Triage/                           # NEW - email triage working docs
└── Processing/                       # Items being actively processed
```

### Tier 2: Connected Systems (Short-term)
1. **Garmin MCP Integration**
   - Daily biomarker ingestion to health template
   - Weekly rollup summaries
   - Trend analysis linking to energy/daily notes

2. **Calendar Integration**
   - Weekly review pulls in calendar events
   - Deadlines → Tasks with date context
   - Meetings → auto-templated notes

3. **Email → Brain Dump**
   - Automated triage from brain-dump-dispatch
   - Weekly distillation reviews
   - Actionable items to Tasks

### Tier 3: Long-term Architecture
```
Resources/
├── Frameworks/
│   ├── Decision Frameworks/            # SCAMPER, RICE, SIPOC templates
│   ├── Review Templates/             # Weekly, Monthly, Quarterly reviews
│   └── Personal OS/                    # Thomas's operating procedures
└── Templates/
    ├── Daily/
    ├── Meetings/
    ├── Project Updates/
    └── Health/

Periodic/                                     # NEW - time-bound reviews
├── 2026/
│   ├── Q2-Weekly-Reviews/
│   ├── Monthlies/
│   └── Quarterlies/
```

## Actionable Recommendations

### Immediate (Do Next)
- [ ] Activate QMD semantic search: run `qmd-index-obsidian.py` to create db.sqlite
- [ ] Connect Garmin MCP to populate Health/Daily template
- [ ] Establish daily journaling habit using `daily.md` template
- [ ] Create explicit link: `Brain Dump` → `Inbox` → `Areas/People` (for new contacts)
- [ ] Build Weekly Review template that pulls from:
  - Recent daily notes (decisions)
  - Garmin trends (energy/productivity)
  - Project progress (status updates)

### Short-term (This Month)
- [ ] Connect calendar to vault (weekly agenda pulls)
- [ ] Create Project Status tracking with explicit fields
- [ ] Build Habit tracker (connects to DayVibe testing)
- [ ] Automate email triage → Brain Dump → Inbox flow

### Long-term (Quarter)
- [ ] Quarterly review system with trend analysis
- [ ] Financial dashboard connecting Net Worth → Budgeting → Consulting income
- [ ] People relationship health scoring (last contact, context, warmth level)
- [ ] Cross-walk: daily energy → work productivity → project velocity

## Key Insights

1. **Thomas thinks in systems** - The CFO synthesis (4 playbooks) proves he wants multiple perspectives before deciding

2. **Register switching is core** - A personal AI assistant must know: Dutch-warm, Dutch-formal-legal, English-structured-professional

3. **The TTI profile (I=93) matters** - High enthusiasm, high optimism, can over-promise. An agent working on his behalf should compensate, not amplify

4. **Building over consulting** - DayVibe and BeBright are the future; consulting funds the building

5. **Vault as infrastructure** - The May 2026 overhaul goal was explicitly to enable AI agents to act on his behalf accurately

---

*Analysis compiled 2026-05-14 from vault inspection. Ready for implementation.*