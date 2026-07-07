---
title: "PRD: Thomas Finance Dashboard — v2 Feature Set"
date: 2026-04-01
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/software]
status: active
source_file: "Downloads/PRD_Thomas_Finance_v2.md"
source_type: md
confidence: 0.8
imported: 2026-05-14
---

# PRD: Thomas Finance Dashboard — v2 Feature Set
**Owner:** Thomas
**Status:** Ready for Claude Code implementation
**Date:** April 1, 2026
**Codebase:** `personal-finance-dashboard/src/Dashboard.jsx`
**Stack:** React 18, Recharts, Vite, localStorage

---

## Context & Starting Point

The v1 dashboard is live and working. It parses Rabobank CSV exports (ISO-8859-1, comma-delimited, signed `Bedrag` column), classifies transactions by IBAN and keyword matching, evaluates three financial rules, displays a 10-year net worth projection, and shows an investment portfolio table.

The following localStorage keys are already implemented and persist across page reloads:

| Key | Contents |
|---|---|
| `pf_settings` | All settings panel values |
| `pf_portfolio` | Holdings table (VUSA × 100 at avg €99.1405) |
| `pf_memory` | IBAN + name label memory |
| `pf_overrides` | Per-transaction category overrides |
| `pf_txs` | Parsed CSV transactions (single month only) |
| `pf_csvName` | Last uploaded filename |

**The core gap this PRD addresses:** the app stores one month's data and forgets everything else. The six features below extend it into a multi-month, historically-aware system that gets more useful with every CSV upload.

---

## Feature 1 — Multi-Month CSV Storage

### Problem
Every time a new CSV is uploaded, the previous month's data is overwritten. This means the projection engine has no real historical data, month-over-month comparisons are impossible, and net worth history cannot be built.

### What to Build

Replace `pf_txs` (single array) with `pf_months` — a keyed object where each key is a year-month string and each value is the full parsed transaction array for that month.

**Data structure:**
```json
{
  "2026-01": [ ...transactions ],
  "2026-02": [ ...transactions ],
  "2026-03": [ ...transactions ]
}
```

**Storage key:** `pf_months`

**Logic on CSV upload:**
1. Parse the CSV as today (no change to parsing logic)
2. Detect which month the transactions belong to — read the `Datum` field of the first transaction, extract `YYYY-MM`
3. Store under that key in `pf_months`
4. Never overwrite an existing month without user confirmation — show a toast: *"January 2026 already exists. Replace it?"*
5. Keep `pf_txs` as an alias pointing to the currently selected month (for backward compatibility with all existing display logic)

**Retention:** Keep all months indefinitely. Add a "Remove month" option in the month selector (with confirmation).

**Storage size estimate:** A 3-month Rabobank export is ~150KB as parsed JSON. 24 months of data is well within the 5MB localStorage limit.

### Acceptance Criteria
- Upload February CSV → January data is not lost
- Upload same month twice → confirmation prompt appears
- Deleting a month removes it from storage and switches view to the most recent remaining month
- All existing cash flow, rules, and category logic works on whichever month is selected

---

## Feature 2 — Month Selector

### Problem
With multiple months stored, there needs to be a clear way to navigate between them and understand which month is currently displayed.

### What to Build

A month selector component in the header bar, between the CSV upload button and the settings icon.

**Visual design:**
- Displayed as a pill-shaped selector: `← Jan 2026 →` with left/right arrow buttons
- Clicking the month label opens a dropdown listing all stored months in reverse chronological order
- Each month in the dropdown shows: month name, transaction count, and net surplus (e.g. *"March 2026 · 47 transactions · +€612"*)
- Currently selected month is highlighted
- A small dot or badge indicates months with uncategorized transactions

**Behavior:**
- Switching months updates all dashboard panels instantly — cash flow, rules engine, transaction table, category bars
- The 10-year projection and net worth hero always use the most recent stored month as the base, regardless of which month is selected for viewing
- Uploading a new CSV automatically switches view to the newly uploaded month

**Empty state:**
- If no CSVs are uploaded yet, the selector shows "No data — upload a CSV" and is non-interactive

### Acceptance Criteria
- All stored months are listed and selectable
- Switching months updates cash flow, rules, and transaction data without page reload
- Projection and net worth remain anchored to latest month regardless of selected view month
- Month with uncategorized transactions is visually flagged

---

## Feature 3 — Net Worth History Chart

### Problem
Net worth is currently shown as a static hero number with no sense of trajectory. There is no way to see whether it is growing month over month or whether it is on track.

### What to Build

A net worth history chart that plots one data point per stored month, overlaid with the existing 10-year projection line.

**Data source:**
For each stored month, calculate net worth using:
- Last `Saldo na trn` balance in that month's transactions (cash position at end of month)
- `pf_settings.houseValue` (static — changes only when user updates settings)
- Portfolio value at time of that month (use current portfolio value for all historical points — we do not store historical prices)
- `pf_settings.mortgageOutstanding` minus months of amortization paid since purchase (May 2025)

**Chart design:**
- Replaces or sits above the existing 10-year projection line chart
- X-axis: months (historical) seamlessly continuing into years (projected)
- Historical portion: solid dots connected by a solid line in the primary color
- Projected portion: dashed line with scenario band shading (Conservative to Optimistic range shown as a light fill)
- Goal markers remain: net worth milestone (€500k default) and semi-remote threshold
- Tooltip on historical dots: shows exact net worth, cash, investments, and mortgage balance for that month

**New localStorage key:** `pf_networth_history`
- Updated automatically each time a CSV is uploaded
- Structure: `[{ month: "2026-01", netWorth: 285000, cash: 18500, investments: 11200, mortgage: 267800 }]`

### Acceptance Criteria
- Historical dots appear for every stored month
- Dots connect seamlessly into the projection dashed line
- Hovering a dot shows the breakdown for that month
- Chart re-renders correctly when a new month is uploaded
- Goal markers remain visible and accurate

---

## Feature 4 — Year-to-Date Summary

### Problem
There is no way to see cumulative performance across the year — how much has been saved in total, what the average savings rate is, or whether investment contributions are on track annually.

### What to Build

A YTD summary panel that aggregates all stored months within the current calendar year.

**Placement:** A new card in the dashboard, positioned between the Rules Engine and the Cash Flow panel. Collapsed by default on first load; expanded once 2+ months are stored.

**Metrics displayed:**

| Metric | Calculation |
|---|---|
| Total income YTD | Sum of all inflows (excl. transfers) across all months in current year |
| Total spent YTD | Sum of all outflows across all months in current year |
| Total saved YTD | Total income − total spent |
| Average savings rate | Mean savings rate across stored months in current year |
| Total invested YTD | Sum of all outflows categorized as "Investments" |
| Best month | Month with highest savings rate |
| Worst month | Month with lowest savings rate |
| Months on track | Count of months where all 3 rules passed |

**Visual treatment:**
- Large numbers for the four primary metrics (total income, total spent, total saved, total invested)
- Savings rate shown as a horizontal bar with the monthly target (25%) as a reference line
- Best/worst month shown as colored chips (green / amber)
- "X of Y months fully on track" shown as a row of filled/empty circles (one per stored month)

**Empty state:** If fewer than 2 months are stored in the current year, show: *"Upload 2 or more months to see year-to-date performance."*

### Acceptance Criteria
- All calculations use only months within the current calendar year (2026)
- Savings rate bar shows target reference line
- Panel updates immediately when a new month is uploaded
- Months on track indicator accurately reflects rule pass/fail for each stored month

---

## Feature 5 — Month-over-Month Comparison Charts

### Problem
It is currently impossible to know whether spending in a category is increasing or decreasing. There is no way to identify trends like "dining is creeping up" or "transport spiked last month."

### What to Build

A comparison view that shows category spending side by side across all stored months.

**Placement:** A new section at the bottom of the dashboard, below the transaction table. Visible only when 2+ months are stored.

**Primary chart — Grouped bar chart:**
- X-axis: expense categories
- Y-axis: amount in euros
- One bar per stored month per category, grouped and color-coded by month
- Months shown in chronological order within each group
- Maximum 6 months shown simultaneously; if more exist, a month range selector filters which 6 are shown

**Secondary view — Category trend lines:**
- A toggle switches between the grouped bar chart and a multi-line chart
- Each line represents one category over time
- Useful for spotting gradual drift (e.g. subscriptions slowly growing)
- Lines colored using the existing category color map

**Delta indicators:**
- Below the grouped bar chart, a table shows each category with:
  - Last month spend
  - Month before spend
  - Delta (€ and %)
  - Arrow indicator: ↑ ↓ → (up, down, flat within ±5%)
  - Color: red if up more than 10%, green if down more than 10%, neutral otherwise

**Filters:**
- Toggle to exclude Transfer category (on by default)
- Toggle to show income categories alongside expense categories (off by default)

### Acceptance Criteria
- Chart renders correctly with 2, 3, and 6 months of data
- Toggle between grouped bars and trend lines works without data loss
- Delta table shows correct direction and magnitude for every category
- Adding a new month updates both charts instantly
- Transfer category excluded by default but togglable

---

## Feature 6 — Projection Engine Upgrade (Real Data Mode)

### Problem
The current 10-year projection uses manually configured assumptions (monthly savings, rental income) rather than actual observed data from uploaded CSVs. As more months accumulate, the projection should become increasingly grounded in real behavior.

### What to Build

Upgrade the projection engine to prefer real observed data over assumptions when sufficient history exists.

**Triggering condition:** Real data mode activates automatically when 3 or more months are stored.

**What changes:**

| Input | Before (assumption mode) | After (real data mode) |
|---|---|---|
| Monthly savings | Settings input (manual) | 3-month rolling average of actual surplus |
| Monthly investment | Settings target | 3-month rolling average of actual investment outflows |
| Rental income | Settings input (manual) | 3-month rolling average of actual rental inflows |
| Monthly expenses | Not used | 3-month rolling average of actual total outflows |

**Display:**
- A subtle label on the projection chart: *"Based on 3 months of real data"* or *"Based on your settings (upload 3 months to use real data)"*
- In the Settings panel, the affected fields are grayed out with a note: *"Auto-calculated from your last 3 months — override in settings to use a manual value"*
- A toggle in the projection panel to switch between Real Data Mode and Settings Mode for comparison

**Scenario recalibration:**
- Conservative scenario uses real data × 0.8 (assumes 20% worse savings behavior)
- Base scenario uses real data as-is
- Optimistic scenario uses real data × 1.2 (assumes 20% better savings behavior)

**Net worth history integration:**
- The projection starting point is now the most recent stored net worth data point, not a manually entered value

### Acceptance Criteria
- Real data mode activates at exactly 3 stored months
- Label on chart accurately reflects which mode is active
- Toggle between modes updates projection chart instantly
- Settings fields gray out in real data mode but remain editable as overrides
- Removing a month below the 3-month threshold reverts to settings mode with a warning toast

---

## Non-Goals for This Release

The following are explicitly out of scope and should not be built as part of this feature set:

- Streak tracker (deferred to v3)
- Automatic price fetching for investment holdings
- Dark mode
- Multi-account consolidation (second Rabobank account)
- Tax calculation or export
- Mobile-optimized layout

---

## Implementation Order

Build features in this sequence to minimize rework:

1. **Feature 1** (multi-month storage) — everything else depends on this
2. **Feature 2** (month selector) — makes multi-month data navigable
3. **Feature 3** (net worth history chart) — replaces projection chart; highest visual impact
4. **Feature 4** (YTD summary) — additive panel, no dependencies on 5 or 6
5. **Feature 5** (comparison charts) — depends on Feature 1 data structure
6. **Feature 6** (projection upgrade) — depends on Features 1, 3, and 5 being stable

---

## How to Hand This to Claude Code

Open Terminal, navigate to the project folder, and run `claude`. Then paste:

> "Please read PRD_Thomas_Finance_v2.md and implement the features in the order specified. Start with Feature 1. Before writing any code, show me your implementation plan for that feature and confirm the data structure. Then implement, test locally, and confirm before moving to Feature 2."

Work through one feature at a time. After each feature is implemented and visually confirmed in the browser (`npm run dev`), commit it to Git before moving to the next:

```bash
git add .
git commit -m "feat: add multi-month CSV storage (Feature 1)"
```

This ensures every feature is independently recoverable if something breaks later.

---

## Acceptance Test — End-to-End

When all six features are implemented, the following should work as a single uninterrupted flow:

1. Open the dashboard at `localhost:5173`
2. Upload `CSV_A_accounts_20260101_20260330.csv` — January data loads, labels auto-apply from memory
3. Upload a February CSV — month selector now shows two months; January data is not lost
4. Upload a March CSV — month selector shows three months; real data mode activates on projection
5. Switch to January view — cash flow, rules, and category bars all show January data
6. Switch back to March — everything updates instantly
7. YTD summary shows totals across all three months with savings rate average
8. Comparison chart shows three grouped bars per category
9. Net worth history chart shows three historical dots leading into projection line
10. Close browser completely, reopen — all data, labels, and settings are still there

If all ten steps complete without errors, the feature set is ready for production deployment via `vercel --prod`.
