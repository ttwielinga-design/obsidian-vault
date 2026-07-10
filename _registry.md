---
title: "Vault Registry"
type: index
status: active
tags: [type/index, vault-home]
date: 2026-05-14
---

# ThomasVault Registry

> **For LLMs**: This is your navigation map for Thomas Wielinga's Obsidian vault. Start here. Every section includes the folder path, what lives there, and the tag query to find notes by topic.

**Owner**: Thomas Wielinga  
**Vault span**: 2015–2026  
**Structure**: Hybrid — 3-Layer (Raw → Notes → Knowledge) + Legacy PARA (Projects / Areas / Resources) + Daily journal + Archive  
**Total notes**: ~500 content notes + 321 daily journal entries + ~337 converted work documents  
**Tag taxonomy**: `#type/` · `#area/` · `#project/` · `#status/` · `#topic/` (PARA legacy) + SCHEMA taxonomy (domain, tech, workflow, quality, source, note-type)  

---

## 0. Vault Architecture (v2 — July 2026)

This vault now uses a **hybrid structure** — the new 3-layer system alongside the existing PARA folders.

### 3-Layer System (new)

| Layer | Directory | Purpose | Status |
|-------|-----------|---------|--------|
| 0 | [[0-inbox/]] | Capture zone (fleeting notes) | Active |
| 1 | [[1-raw/]] | Immutable source material | **New** — 337 converted work docs |
| 2 | [[2-notes/]] | Agent-maintained wiki (atoms, MOCs, daily, projects, areas, entities) | **New** — scaffolding |
| 3 | [[3-knowledge/]] | Synthesized evergreen knowledge | **New** — ready |
| 4 | [[4-archive/]] | Cold storage for completed/deprecated | **New** — bridges to legacy [[Archive/]] |

### Legacy PARA (preserved)

| Directory | Purpose | Bridge |
|-----------|---------|--------|
| [[Inbox/]] | Legacy inbox | → 0-inbox |
| [[Projects/]] | Active projects (DayVibe, etc.) | → 2-notes/projects |
| [[Areas/]] | Responsibilities (Finance, Health, People, Work) | → 2-notes/areas, 2-notes/entities |
| [[Resources/]] | Reference material | → 3-knowledge |
| [[Archive/]] | Historical records | → 4-archive |
| [[Daily/]] | 321 daily journals (2018–2026) | → 2-notes/daily |
| [[Brain Dump/]] | Unstructured thoughts | → 0-inbox |

### Key Architecture Docs

- [[SCHEMA]] — Full vault constitution (tag taxonomy, frontmatter specs, page thresholds)
- [[_secondbrain-readme]] — Vault onboarding guide
- [[_secondbrain-index]] — New 3-layer home page
- [[dashboard-home]] — Task/activity dashboard
- [[vault-analytics]] — Note stats
- [[log]] — Changelog (agent + human)

---

---

## 1. Daily Journal

**Path**: `Daily/YYYY/MM/YYYY-MM-DD.md`  
**What**: Append-only dated journal. Every day from 2018 to present. Contains: decisions made, meetings, reflections, life events, project progress.  
**Index**: [[Daily/_index]]  
**Year counts**: 2018(8) · 2019(11) · 2020(17) · 2021(14) · 2022(22) · 2023(37) · 2024(77) · 2025(75) · 2026(60)  
**Tags**: `#area/daily` `#type/daily`  
**Find by date**: navigate `Daily/YYYY/MM/` or search filename `YYYY-MM-DD`

---

## 2. Projects

**Path**: `Projects/`  
**Index**: [[Projects/_index]]  
**What**: Finite-outcome projects Thomas is actively building or recently ran.

### 2.1 DayVibe
**Path**: `Projects/DayVibe/`  
**What**: Voice-first AI journaling app. Thomas's primary product project.  
**Status**: Active  
**Subfolders**:
- `Design/` — brand guidelines, avatar assets, visual identity
- `Content/` — copy, scripts, write copy drafts
- `Legal/` — privacy policy, terms of service
- `Marketing/` — GTM strategy, customer avatars, video assets, social copy
- `Meetings/` — meeting notes
- `Product/` — product brief, PRD, tech stack, wireframes, feature sets
- `Research/` — competitor analysis, market research, AI tools guide  
**Tags**: `#project/dayvibe` `#area/projects`

### 2.2 Florence Aug 2026
**Path**: `Projects/Florence Aug 2026/`  
**What**: Trip planning for Florence, August 2026.  
**Status**: Active  
**Tags**: `#project/florence-2026` `#topic/travel`

### 2.3 MindBoost
**Path**: `Projects/MindBoost/`  
**Tags**: `#project/mindboost`

### 2.4 Park56
**Path**: `Projects/Park56/`  
**Tags**: `#project/park56`

### 2.5 CompanySearcher
**Path**: `Projects/CompanySearcher/`  
**Tags**: `#project/company-searcher`

---

## 3. Areas

**Path**: `Areas/`  
**Index**: [[Areas/_index]]  
**What**: Ongoing life responsibilities. Not time-bounded — active indefinitely.

### 3.1 Finance
**Path**: `Areas/Finance/`  
**Index**: [[Areas/Finance/_index]]  
**What**: Thomas's personal finances — budgeting, net worth tracking, legal/financial documents.

| Subfolder | What's inside |
|-----------|--------------|
| `Budgeting/` | Monthly budget tracker, trip budgets, planning docs |
| `Net Worth/` | Account statements, EUR conversions, annual statements |
| `Reports/` | CFO synthesis reports |
| `Housing/` | Rental contracts (Berta, Emile, Marieke hospita contracts) |
| `Legal Documents/` | Loan agreements, mortgage (hypothecaire lening), gift declarations (schenking), SEPA mandate, PEP compliance, fund origin declaration |
| `Journal/` | Finance research journal (2023–2026): academic papers, BNP Paribas hotel market reports, dashboard PRDs, investing ideas |

**Key notes**: [[Areas/Finance/Budgeting/Tracker]] · [[Areas/Finance/Net Worth/Account Statements]] · [[Areas/Finance/Reports/CFO Synthesis]]  
**Tags**: `#area/finance` · `#area/finance/budgeting` · `#area/finance/net-worth` · `#area/finance/legal` · `#area/finance/housing`

### 3.2 Work
**Path**: `Areas/Work/`  
**Index**: [[Areas/Work/_index]]  
**What**: Thomas's professional work — AI consulting, client project deliverables, invoicing, tenant management.

| Subfolder | What's inside |
|-----------|--------------|
| `AI Consulting/` | Consulting methodology, client skill assessments, business stage checklist |
| `Client Projects/` | 37 archived client deliverables: table formatting, data extraction, copywriting, research matrices, landing pages |
| `Invoicing/` | CV, billing records |
| `Tenant Communications/` | Tenant coordination docs |

**Tags**: `#area/work` · `#area/work/consulting` · `#area/work/client` · `#area/work/invoicing`

### 3.3 People
**Path**: `Areas/People/`  
**Index**: [[Areas/People/_index]]  
**What**: Contacts and collaborators.

| Person | Context |
|--------|---------|
| [[Areas/People/Mariam Vossough]] | AI consulting collaborator, The Women's AI Voice (Substack) |
| [[Areas/People/Raghav Skills]] | AI consulting collaborator, Cash & Cache newsletter |
| [[Areas/People/Rowin]] | ZUYD BPI project interviewee |

**Tags**: `#area/people`

### 3.4 Health
**Path**: `Areas/Health/`  
**Index**: [[Areas/Health/Daily/_index]]  
**What**: Daily wellness logs.  
**Tags**: `#area/health`

---

## 4. Resources

**Path**: `Resources/`  
**Index**: [[Resources/_index]]  
**What**: Reusable reference material, templates, and code. Not project-specific.

| Subfolder | What's inside |
|-----------|--------------|
| `Reference/` | Guides, frameworks (SIPOC, deep research, pitch deck), AI tools guide, issues-fixes log |
| `Reference/Frameworks/` | Process frameworks and methodology docs |
| `Templates/` | Note and project templates |
| `Code/Python/` | Python scripts |
| `Code/Google Colab/` | Google Colab notebooks (data, analysis) |
| `contract/` | Contract templates |
| `meeting/` | Meeting templates |
| `work/` | Work reference docs |

**Tags**: `#area/resources` · `#area/resources/reference` · `#area/resources/code`

---

## 5. Archive

**Path**: `Archive/`  
**Index**: [[Archive/_index]]  
**What**: Finished or stale work. Kept for reference, not actively maintained.

### 5.1 Hotel Investment Project
**Path**: `Archive/Projects/Hotel Investment/`  
**Index**: [[Archive/Projects/Hotel Investment/_index]]  
**What**: Thomas's hotel investment research and due diligence (2022–2024). AI implementation planning, financial models, market research.

| Subfolder | What's inside |
|-----------|--------------|
| `Due Diligence/` | AI implementation phases, DNR VO process |
| `Financial Models/` | Lease vs franchise analysis, occupancy models |
| `Research/` | BNP Paribas market reports, investment memorandum |

**Tags**: `#project/hotel-investment` `#topic/hospitality` `#topic/real-estate` `#status/archived`

### 5.2 Education
**Path**: `Archive/Areas/Work/Education/`  
**Index**: [[Archive/Areas/Work/Education/_index]]  
**What**: All of Thomas's educational history — Hotelschool The Hague, ZUYD University (BPI), Informatica.

| School | Path | What |
|--------|------|------|
| ZUYD University | `Education/ZUYD/` | BPI (Business Process Improvement) project, interviews with Rowin, process documentation |
| Hotelschool The Hague | `Education/Hotelschool/` | Hospitality management, application, reference letters |
| Informatica | `Education/Informatica/` | Computer science coursework |
| Personal Documents | `Education/Personal Documents/` | Spanish certificate, reference letters (Eric, Robin), application docs |

**Tags**: `#area/education` · `#area/education/zuyd` · `#area/education/hotelschool` · `#area/education/informatica`

### 5.3 Frameworks
**Path**: `Archive/Frameworks/BMad-Method/`  
**What**: External BMad AI agent development framework. Reference only — not personal notes.  
**Tags**: `#status/archived`

---

## 6. Tag Quick-Reference

### Query patterns for Dataview / search

```
Find all active finance notes:    area: finance AND status: active
Find all DayVibe research:        project: dayvibe AND type: research
Find all archived education:      area: education AND status: archived
Find all legal documents:         type: legal OR type: contract
Find all work/client deliverables: area: work/client
Find all people notes:            area: people
Find notes about AI:              topic: ai
Find hospitality/hotel notes:     topic: hospitality OR topic: real-estate
```

### Full taxonomy

**#type/** → `daily` `note` `guide` `reference` `template` `code` `contract` `meeting` `research` `legal` `financial` `journal` `index`

**#area/** → `finance` `finance/budgeting` `finance/net-worth` `finance/housing` `finance/legal` `finance/investing` · `work` `work/consulting` `work/client` `work/invoicing` `work/tenant` · `health` `people` `education` `education/zuyd` `education/hotelschool` `education/informatica` · `projects` `resources` `resources/code` `resources/reference` `archive` `daily`

**#project/** → `dayvibe` `hotel-investment` `bebright` `florence-2026` `mindboost` `park56` `company-searcher`

**#status/** → `active` `archived` `draft`

**#topic/** → `ai` `strategy` `hospitality` `software` `finance-theory` `bpi` `marketing` `legal` `personal` `accounting` `investing` `real-estate` `travel` `consulting` `data` `spreadsheet` `copywriting` `design` `ux` `product` `framework` `academic`

---

## 7. Temporal Map (Thomas's life timeline)

| Period | Key Events / Notes Location |
|--------|----------------------------|
| 2015–2018 | Early Daily notes (sparse). Informatica studies. |
| 2018–2020 | Hotelschool The Hague. BeBright project. `Archive/Areas/Work/Education/Hotelschool/` |
| 2020–2022 | ZUYD University (BPI). Hotel Investment research begins. `Archive/Areas/Work/Education/ZUYD/` |
| 2022–2024 | Hotel Investment due diligence. AI Consulting starts. Finance premaster coursework. `Archive/Projects/Hotel Investment/` · `Areas/Finance/Journal/` |
| 2024–2025 | AI Consulting active. Client projects. DayVibe development begins. `Areas/Work/` · `Projects/DayVibe/` |
| 2026 | DayVibe active build. Florence trip planning. Financial dashboard. Legal docs (mortgage, loans). |

---

*Registry last updated: 2026-05-14 — vault overhaul complete.*
