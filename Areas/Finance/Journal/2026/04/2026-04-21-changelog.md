---
title: "Changelog"
date: 2026-04-21
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/software]
status: active
source_file: "3. Personal/Personal Finance/Personal finance dashboard/CHANGELOG.md"
source_type: md
confidence: 0.8
imported: 2026-05-14
---

# Changelog

## MVP scope

- CSV import for Dutch bank exports with month-based storage
- Review queue for uncategorized transactions, manual overrides, and saved categorization rules
- Cash flow dashboards for monthly, YTD, and year-over-year views
- Net worth tracking with historical month selection, property and mortgage modeling, and portfolio inclusion
- Equity workflows including holdings, lots, investment inbox detection, holding detail, and mortgage amortization chart
- IBAN management for own accounts and broker accounts with validation
- Backup export, wipe confirmation, and restore for local app state
- Command palette, keyboard navigation, shortcuts overlay, and section navigation for overview, cash flow, transactions, equity, goals, and subscriptions

## Deferred

- Full budgeting/envelope system from the budgeting PRD
- IndexedDB/Dexie storage migration and other storage-scaling work from the storage ADR
- Deeper equity IA cleanup and component extraction beyond the current shipped equity flows
- Hardening of third-party market data dependencies and provenance beyond current Stooq/manual labeling
- Bundle-size optimization and code-splitting for the large Vite output chunk
