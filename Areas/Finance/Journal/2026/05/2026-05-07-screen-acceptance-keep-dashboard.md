---
title: "Screen acceptance — Keep dashboard"
date: 2026-05-07
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/software]
status: active
source_file: "3. Personal/Personal Finance/Personal finance dashboard/docs/SCREEN_ACCEPTANCE.md"
source_type: md
confidence: 0.8
imported: 2026-05-14
---

# Screen acceptance — Keep dashboard

> Per-section layout spec and acceptance criteria. Reflects the deliberate product decisions in the app as of Wave 5.

---

## Chrome (all screens)

- TopBar title uses `.t-title` (14px / 600), not `.t-heading`.
- Period picker is wrapped in a bordered pill: `1px solid var(--border)`, `var(--r-m)`, `padding: 0 4px`.
- TopBar icon buttons (help, overflow) are 22px tall.
- Sidebar eyebrows are `.t-eyebrow` (10px / 600 / uppercase / 0.08em tracking).
- Sidebar Planning group order: Goals → Subscriptions → Equity.
- Sidebar badges use `chip chip-red` on Review Queue and Transactions (when uncategorized count > 0).
- StatusBar right side shows `v0.12.3 · local-only` in `var(--text-faint)` mono 11px.

---

## Overview

**Layout:** Net Worth card + History & Projection card side-by-side (or stacked on narrow). No three-flat-KPI layout.

**Net Worth card:** Displays total net worth as primary value. Sub-lines: Cash · Property · Investments · Mortgage. Emergency fund progress bar.

**History & Projection card:** Net worth chart with history + cone projection. Scenario toggle: Cons. / Base / Opt. Goal line annotation. FIRE target sub-line.

**Lower row:** Rules Engine status · Savings Rate KPI · Monthly Investment KPI · Emergency Fund KPI · Cash Flow callout · Upload prompt (when no data).

---

## Cash Flow

**Section layout:** Flat — `padding: 24px 28px`, no card wrapper around the section content.

**Stats row:** 4 KPIs — Income · Expenses · Surplus · Savings Rate. "Surplus" (not "Net").

**View-mode switcher:** This Month / Year to Date / vs Prior Year — pill buttons in topbar-right of the stats area.

**Expense bars:** Horizontal `<BarChart layout="vertical">` per category, color-coded. Click bar filters Transactions by category.

**Cash Flow History card** (when ≥ 2 months available): Separate sub-card. ComposedChart (income/expense bars + surplus line). Range picker: 1M / 6M / YTD / 1Y / 5Y / Max.

**YTD summary card** (collapsible): Total Income · Total Spent · Total Saved · Total Invested.

---

## Portfolio

**Summary header card:** Three stat columns — Investment Portfolio (+ P&L delta + TER) · Cash at Broker (editable adjustment) · Portfolio Total.

**Holdings table:** Always visible — no collapse/expand toggle. Columns: Instrument (ticker + name + ISIN) · Avg Cost · Qty · Price · Value · P&L · P&L % · TER · actions.

**Action row:** + Add holding · Refresh prices · Import broker trades (primary).

**Missing price symbol callout** shown inline when any holding lacks `priceSymbol`.

---

## Transactions

**Section layout:** Flat — `padding: 24px 28px`, no card wrapper around the section content.

**Section header pattern:** `TRANSACTIONS (22) · 2 UNCATEGORIZED` — telegraphic, mono label style.

**Columns:** COUNTERPARTY (with date + IBAN sub-lines) · DESCRIPTION · CATEGORY (inline `<CategoryPicker>`) · AMOUNT.

**Filters:** Text search · €min / €max amount inputs · Category dropdown · Review Queue trigger button (shown when uncategorized > 0).

**Row cap:** 100 rows visible; "Load N more" button to paginate.

---

## Goals

Read-only progress bars against targets from `settings`. Goals: Net worth · Savings rate · Emergency fund · Passive income · Savings-rate streak.

---

## Subscriptions

Auto-detected recurring charges via `detectSubscriptions()`. Cards show name, estimated monthly amount, IBAN. Click → jumps to Transactions filtered by that counterparty.

---

## Equity

Long-term equity tracking section (mortgage amortization, property value, net equity over time).

---

## Acceptance checklist (per section)

1. Section renders without a white-box card border around the entire content area (Cash Flow, Transactions).
2. All KPI labels use `.t-label` or `.t-eyebrow` — no raw inline uppercase strings.
3. Stat labels match: "Surplus" not "Net" in Cash Flow.
4. Portfolio Holdings table is immediately visible — no "Show/Hide" toggle.
5. No hardcoded hex colors — all colors via `var(--…)` tokens or `T.*` object.
6. Chips use `chip chip-red` / `chip chip-green` / etc. — no bespoke inline badge styles.
