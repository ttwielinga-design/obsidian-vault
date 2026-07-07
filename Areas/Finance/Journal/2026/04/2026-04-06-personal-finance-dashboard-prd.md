---
title: "Personal Finance Dashboard — PRD"
date: 2026-04-06
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/software]
status: active
source_file: "3. Personal/Personal Finance/PRD-briefing-and-ytd.md"
source_type: md
confidence: 0.8
imported: 2026-05-14
---

# Personal Finance Dashboard — PRD
## Feature A: Monthly Briefing Export · Feature B: YTD & Year-over-Year View

**Status:** Ready for build
**Version:** v1.0
**Last Updated:** 2026-04-06
**Executed by:** AI coding agent (Claude Code)

---

## 0. Executive Summary

This PRD covers two features for a personal finance dashboard built as a single React component (`src/Dashboard.jsx`). **Feature A** adds a "Copy Briefing" button that generates a structured, human-readable snapshot of the month's finances, designed to be pasted directly into a Claude conversation for AI analysis — without exposing raw transaction data. **Feature B** adds a YTD toggle and year-over-year comparison to the spending/income views, letting the user benchmark the current month or year against the prior period.

The user checks the dashboard once a month (on the 1st) after uploading the previous month's CSV. Their core questions are: what did I spend, what did I invest, and did my net worth go up? Both features serve this exact flow.

---

## 1. Codebase Context (read before coding)

**Single-file architecture.** The entire app lives in `src/Dashboard.jsx`. Do not create new files unless absolutely necessary. All additions go into this file.

**Key state (all in the `Dashboard` component):**

| Variable | Type | Description |
|---|---|---|
| `months` | `{ [YYYY-MM]: tx[] }` | All uploaded transaction data, persisted to `pf_months` in localStorage |
| `selectedMonth` | `string \| null` | Currently viewed month key, e.g. `"2026-03"` |
| `sortedMonthKeys` | `string[]` | All stored month keys, sorted ascending |
| `categorized` | `tx[]` | Transactions for `selectedMonth` with `.cat` applied |
| `cashFlow` | `object` | `{ inc: { salary, rental, side, total }, exp: { [cat]: amount }, totalExp, surplus, savingsRate }` — computed from `categorized` |
| `invested` | `number` | Total invested this month (Investments category, negative amounts) |
| `portTotal` | `number` | Portfolio market value from `portfolio` state |
| `cashBal` | `number` | End-of-month bank balance (last transaction's `.balance` field) |
| `netWorth` | `number` | `latestCashBal + settings.houseValue + portTotal - settings.mortgageOutstanding` |
| `settings` | `object` | User config: `houseValue`, `mortgageOutstanding`, `savingsTarget`, `investTarget`, etc. |
| `memory`, `overrides`, `savedRules` | various | Used by `classify()` for categorization |
| `ytdStats` | `object \| null` | Already computed YTD stats for the current calendar year (see existing code) |
| `INCOME_CATS` | `Set<string>` | Categories that count as income |
| `CAT_COLORS` | `object` | Color per category |
| `ALL_CATS` | `string[]` | All valid category names in logical order |

**Key helper functions:**
- `computeCashFlow(categorized)` — returns the `cashFlow` shape above
- `classify(tx, memory, savedRules)` — categorizes a single transaction
- `fmt(n)` — formats as `€ 1.234` (nl-NL, no decimals)
- `fmtMonth(key)` — formats `"2026-03"` → `"maart 2026"`

**localStorage keys:** `pf_months`, `pf_rules`, `pf_memory`, `pf_overrides`, `pf_settings`, `pf_portfolio`, `pf_networth_history`

**Styling:** Inline styles only. Colors come from the `T` theme object defined inside the component. No external CSS files or Tailwind. The `.chip` class (defined in a `<style>` tag inside the JSX) is already available.

---

## 2. Goals and Non-Goals

**Goals:**
- [ ] User can copy a complete, structured monthly briefing to clipboard with one click
- [ ] Briefing contains all financially meaningful aggregates — no raw transactions
- [ ] User can toggle between monthly view and YTD view for any year
- [ ] User can see the current month compared to the same month last year
- [ ] User can see YTD compared to the same YTD period last year

**Non-goals (do not build these):**
- Do NOT include individual transaction rows in the briefing
- Do NOT add a new page, route, or tab — all UI stays on the single-page dashboard
- Do NOT add any network requests, external APIs, or AI integration — the briefing is plain text for the user to paste manually
- Do NOT redesign existing sections; only add the toggle and the button
- Do NOT add a print or PDF export — clipboard copy only
- Do NOT build a full two-year comparison chart — only the numeric comparison column is needed
- Do NOT change how `computeCashFlow`, `classify`, or any existing pure function works

---

## 3. Feature A — Monthly Briefing Export

### 3.1 What the briefing contains

The briefing is a plain-text markdown document generated from the currently selected month's data. It must include:

1. **Header:** Month name + year (e.g. `# Financial Briefing — maart 2026`)
2. **Net Worth block:**
   - Total net worth
   - Delta vs previous stored month (e.g. `+€ 1.243 vs februari 2026`)
   - Breakdown: Cash | Property | Investments | Mortgage
3. **Cash Flow block:**
   - Total income, total expenses, net surplus/deficit, savings rate %
4. **Income breakdown table:** one row per income source (Salary, Rental, Government Benefit, Other Income, Side) — only include rows where amount > 0
5. **Expenses by category table:** sorted descending by amount, only categories with spend > 0, include % of total income column
6. **Investments block:** amount invested this month + portfolio total value
7. **Footer flag (only if applicable):** number of uncategorized transactions remaining

The briefing must NOT include individual transaction descriptions, counterparty names, IBANs, or any row-level data.

### 3.2 User stories

**Story A1:** As a user, I want to click "Copy Briefing" so that I get a complete structured snapshot of my finances on the clipboard, ready to paste into Claude.

- Acceptance: Given the selected month has transactions, when I click "Copy Briefing", then the clipboard contains a formatted markdown document matching the spec in 3.1
- Acceptance: Given the copy succeeds, then the button label temporarily changes to "Copied ✓" for 2 seconds, then reverts
- Acceptance: Given the clipboard API is unavailable, then the button shows "Copy failed" and does nothing else — no alert, no crash

**Story A2:** As a user, I want the briefing to show net worth delta so I can see at a glance whether my financial position improved this month.

- Acceptance: Given there is a previous stored month, when the briefing is generated, then the net worth delta line shows `+€ X vs [previous month name]` (green-coded in text if positive, no color in plain text output since it's markdown)
- Acceptance: Given the selected month is the only stored month (no prior month to compare), then the delta line is omitted from the briefing entirely

**Story A3:** As a user, I want the expense table sorted by largest to smallest so I can see where money went most quickly.

- Acceptance: Given expenses exist in multiple categories, when the briefing is generated, then the expense table rows are sorted descending by amount

### 3.3 UI placement

- Add the "Copy Briefing" button to the **top toolbar area** where the month selector and Import/Export Labels buttons already live
- Button style: use the existing `.btn.btn-outline` class
- Only show the button when `txs.length > 0` (same condition as the transactions card)

---

## 4. Feature B — YTD & Year-over-Year View

### 4.1 Overview

Add a **view toggle** to the monthly cash flow / spending section that switches between three modes:

| Mode | Label | What it shows |
|---|---|---|
| `monthly` | This Month | Current behavior — selected month data only |
| `ytd` | Year to Date | Aggregated data for all stored months in the selected year |
| `yoy` | vs Last Year | Two-column layout: selected month vs same month last year; YTD vs same YTD window last year |

The toggle must work for any selected year, not just the current year (the user may browse historical months).

### 4.2 Data derivation

**YTD aggregation** for a given year:

```
ytdMonthKeys = sortedMonthKeys.filter(k => k.startsWith(selectedYear))
ytdCategorized = flatten all txs for ytdMonthKeys, each with classify() applied
ytdCashFlow = computeCashFlow(ytdCategorized)
ytdInvested = sum of abs(amount) for Investments category, amount < 0, across ytdCategorized
ytdCashBal = last tx balance of the last month in ytdMonthKeys
```

**Year-over-year (YoY) derivation:**

For "same month last year":
```
priorMonthKey = (selectedYear - 1) + "-" + selectedMonthNumber  // e.g. "2025-03"
priorCategorized = months[priorMonthKey] with classify() applied (or null if key doesn't exist)
priorCashFlow = computeCashFlow(priorCategorized) if data exists
```

For "YTD last year" (same window — up to the same month number):
```
priorYtdKeys = sortedMonthKeys
  .filter(k => k.startsWith(selectedYear - 1) && k <= priorMonthKey)
priorYtdCashFlow = computeCashFlow(flatten all priorYtdKeys txs)
```

### 4.3 User stories

**Story B1:** As a user, I want a toggle to switch between monthly, YTD, and year-over-year views so I can understand my finances in multiple time frames.

- Acceptance: Given I am viewing any month, when I click "Year to Date", then all income/expense figures update to reflect the full year so far (all stored months in that year)
- Acceptance: Given I switch to YTD, then the section header updates to e.g. "Jan – Mar 2026 (Year to Date)"
- Acceptance: Given I switch back to "This Month", then figures revert to the selected month only

**Story B2:** As a user, I want to see how this month compares to the same month last year so I can track whether my spending is trending up or down.

- Acceptance: Given I select "vs Last Year" and data exists for the same month in the prior year, then the income and expense figures show as two columns: current month | same month last year
- Acceptance: Given no data exists for the same month last year, then the prior-year column shows "—" for all values and a note "No data for [month] 2025"
- Acceptance: Given I select "vs Last Year" and data exists for prior YTD, then a second comparison row shows current YTD total vs prior YTD total (up to the same month)

**Story B3:** As a user, I want the expense category rows to show a delta (+ / −) in YoY mode so I can instantly see which categories grew.

- Acceptance: Given YoY mode is active and both current and prior data exist, then each expense category row shows: category | current amount | prior amount | delta (e.g. `+€ 45` in red or `−€ 30` in green)
- Acceptance: Given a category appears in the current month but not in the prior month, then the prior amount shows as `€ 0` and delta equals the current amount
- Acceptance: Given a category appears in the prior month but not in the current month, then it is omitted from the table (we only show what was spent this period)

**Story B4:** As a user, I want the toggle state to persist across page refreshes so I don't have to re-select my preferred view every time I open the dashboard.

- Acceptance: Given I set the view to "Year to Date", when I refresh the page, then the view starts in "Year to Date" mode
- Acceptance: Persist to localStorage key `pf_view_mode` with values `monthly | ytd | yoy`

### 4.4 UI placement

- Place the three-button toggle (This Month | Year to Date | vs Last Year) directly above the income/expense summary card, aligned right — matching the style of the existing `[conservative | base | optimistic]` scenario toggle
- The toggle affects: income/expense summary numbers, the expense bar breakdown, and income sub-breakdown (Salary / Rental / etc.)
- The toggle does NOT affect: net worth hero, portfolio table, transactions table, or the review queue

### 4.5 Edge cases

| Situation | Expected behavior |
|---|---|
| Only 1 month stored in the selected year | YTD mode works (single month = YTD of 1); YoY shows "—" if no prior year data |
| No months stored at all | Toggle is not rendered (same condition as transactions card) |
| selectedYear has data but prior year has zero stored months | YoY prior column shows all dashes with a note |
| User selects a month in a prior year (e.g. browsing 2025 data in April 2026) | YTD and YoY both compute relative to 2025 as the "current" year |

---

## 5. Implementation Phases

> **Start here:** Before writing any code, read `src/Dashboard.jsx` in full to understand the existing structure, then produce an implementation plan and confirm it before coding. The file is large — read it in chunks using offset/limit.

---

### Phase 1 — Feature A: Briefing Generator Function

**Goal:** A pure function that takes dashboard state and returns the briefing as a markdown string.

**Depends on:** Nothing — this is purely additive logic.

**Requirements:**

1. Add a function `generateBriefing({ selectedMonth, months, categorized, cashFlow, invested, portTotal, cashBal, netWorth, settings, sortedMonthKeys, memory, overrides, savedRules, uncatList })` above the component or as a standalone utility inside the file
2. The function returns a markdown string
3. It must compute the net worth delta by finding the previous stored month key (the one immediately before `selectedMonth` in `sortedMonthKeys`) and calculating `netWorth - prevNetWorth`. `prevNetWorth` = prevCashBal + settings.houseValue + portTotal - settings.mortgageOutstanding, where prevCashBal is the last tx's balance in the previous month
4. Format all currency values with `fmt()` (already defined: nl-NL, no decimals)
5. Expense table must be sorted descending by amount, skip categories with 0 spend
6. Income table must skip rows where amount = 0
7. If `uncatList.length > 0`, append a warning line at the bottom

**Acceptance:**
- Given valid dashboard state, when `generateBriefing()` is called, then it returns a non-empty string starting with `# Financial Briefing`
- Given `selectedMonth` is the only stored month, when the function runs, then no delta line appears in the output
- Given a category has zero spend, when the function runs, then it does not appear in the expense table

**Non-goals for this phase:** No UI changes yet. No clipboard interaction yet. Just the pure function.

**Done when:** Function exists and produces correct output for a manually verified test case (you can `console.log` the output during development).

---

### Phase 2 — Feature A: Copy Briefing Button

**Goal:** Wire the generator to a button in the toolbar.

**Depends on:** Phase 1 complete.

**Requirements:**

1. Add a `copyBriefingState` state: `'idle' | 'copied' | 'failed'` initialized to `'idle'`
2. Add a `handleCopyBriefing` callback that calls `generateBriefing()` with current state, writes to `navigator.clipboard.writeText()`, and sets state to `'copied'` on success or `'failed'` on error. Reset to `'idle'` after 2000ms using `setTimeout`
3. Add the button to the toolbar row (where Import/Export Labels buttons already live). Only render the button when `txs.length > 0`
4. Button labels: idle → `"Copy Briefing"`, copied → `"Copied ✓"`, failed → `"Copy failed"`
5. Use class `btn btn-outline` for styling, matching the existing toolbar buttons

**Acceptance:**
- Given `txs.length > 0`, when I look at the toolbar, then "Copy Briefing" button is visible
- Given I click it and clipboard write succeeds, then the button shows "Copied ✓" for 2 seconds
- Given the clipboard API throws, then the button shows "Copy failed" for 2 seconds and does not throw to the console

**Non-goals for this phase:** No YTD data in the briefing yet (that comes after Feature B if desired).

**Done when:** Button renders, clicking it puts correct markdown on the clipboard, label transitions work.

---

### Phase 3 — Feature B: YTD & YoY Data Computation

**Goal:** Compute YTD and YoY aggregates as derived state, without any UI changes yet.

**Depends on:** No dependency on Phases 1–2.

**Requirements:**

1. Add a `viewMode` state: `'monthly' | 'ytd' | 'yoy'`, initialized from localStorage key `pf_view_mode` (default `'monthly'`)
2. Add a `useEffect` that persists `viewMode` to `pf_view_mode` whenever it changes
3. Derive `selectedYear` from `selectedMonth`: `selectedMonth?.slice(0, 4)` (e.g. `"2026"`)
4. Add `ytdCategorized` useMemo: all txs for months in `selectedYear` with `classify()` applied. Return `[]` if no months exist for that year
5. Add `ytdCashFlow` useMemo: `computeCashFlow(ytdCategorized)`
6. Add `ytdInvested` useMemo: sum of `Math.abs(tx.amount)` where `tx.cat === 'Investments' && tx.amount < 0` across `ytdCategorized`
7. Derive `priorMonthKey`: `(parseInt(selectedYear) - 1) + "-" + selectedMonth?.slice(5)` — e.g. `"2025-03"`
8. Add `priorCategorized` useMemo: `months[priorMonthKey]?.map(tx => ({ ...tx, cat: overrides[tx.id] || classify(tx, memory, savedRules) })) ?? []`
9. Add `priorCashFlow` useMemo: `computeCashFlow(priorCategorized)` — will return zeroes if prior data is empty
10. Derive `priorYtdKeys`: all keys in `sortedMonthKeys` where `key.startsWith(String(parseInt(selectedYear) - 1)) && key <= priorMonthKey`
11. Add `priorYtdCategorized` useMemo: flatten txs for `priorYtdKeys` with classify applied
12. Add `priorYtdCashFlow` useMemo: `computeCashFlow(priorYtdCategorized)`

**Acceptance:**
- Given `selectedMonth = "2026-03"` and months `"2026-01"`, `"2026-02"`, `"2026-03"` exist, when `ytdCategorized` is computed, then it contains all transactions from all three months
- Given `selectedMonth = "2026-03"` and `"2025-03"` does not exist in `months`, when `priorCategorized` is computed, then it is an empty array
- Given `viewMode` is set to `"ytd"`, when the page is refreshed, then `viewMode` loads as `"ytd"` from localStorage

**Non-goals for this phase:** No UI changes yet. Just the computed values.

**Done when:** All new useMemo/state values are defined without runtime errors (check browser console).

---

### Phase 4 — Feature B: View Toggle UI & Conditional Rendering

**Goal:** Wire the computed values to the UI with the three-mode toggle.

**Depends on:** Phase 3 complete.

**Requirements:**

1. Add the three-button toggle group `[This Month | Year to Date | vs Last Year]` directly above the income/expense summary card (ROW 3 area). Style matches the existing `[Cons. | Base | Opt.]` scenario toggle — three adjacent buttons, active one filled dark
2. Only render the toggle when `txs.length > 0`
3. In **monthly mode** (default): no change to existing rendering
4. In **YTD mode**: replace `cashFlow` with `ytdCashFlow` and `invested` with `ytdInvested` for the income/expense summary numbers and the expense bar chart. Update the section label to show the YTD range, e.g. `"Jan – Mar 2026 (Year to Date)"`. Compute the label from the first and last keys in `sortedMonthKeys.filter(k => k.startsWith(selectedYear))`
5. In **YoY mode**: render a two-column comparison layout for the income/expense summary section:
   - Left column header: selected month name (e.g. `"maart 2026"`)
   - Right column header: prior month name (e.g. `"maart 2025"`) — if no prior data, show `"No data"`
   - Each income/expense row shows: category | current amount | prior amount | delta
   - Delta = current − prior; show as `+€ X` or `−€ X`; color green if delta < 0 (spent less), red if delta > 0 (spent more), for expenses. Reverse for income (green if delta > 0)
   - Below the monthly comparison, add a second "YTD comparison" sub-section showing aggregate totals only (income, expenses, net, savings rate) for current YTD vs prior YTD
6. The expense bar chart (`expBars`) should also respond to the view mode: use `ytdCashFlow.exp` in YTD mode, `cashFlow.exp` in monthly mode. In YoY mode use current month's `cashFlow.exp`
7. If prior data is entirely absent in YoY mode, show a muted notice: `"No data for [priorMonthKey] — comparison unavailable"` in place of the prior column

**Acceptance:**
- Given I click "Year to Date", then the income total reflects the sum of all months in the selected year, not just the selected month
- Given I click "vs Last Year" and prior month data exists, then I see two columns of numbers side by side for each income and expense category
- Given I click "vs Last Year" and prior month data does not exist, then I see a notice instead of dummy zeros
- Given I am on YTD mode and switch the selected month (via the month selector), then the YTD figures update to reflect the newly selected year
- Given the expense bar chart is visible in YTD mode, then it shows YTD category totals, not just the selected month

**Non-goals for this phase:** Do not add YoY columns to the transactions table. Do not add YoY to the net worth chart.

**Done when:** All three toggle states render without errors, figures are correct for each mode, and the toggle persists across refresh.

---

## 6. Verification Checklist

After completing all phases, verify each of the following before closing the turn:

- [ ] "Copy Briefing" button appears only when transactions are loaded
- [ ] Clipboard content is valid markdown with correct figures (spot-check against visible UI numbers)
- [ ] Button label transitions: idle → Copied ✓ → idle (2 sec)
- [ ] Clipboard failure is handled silently
- [ ] Toggle renders above the income/expense card
- [ ] Monthly mode is unchanged from before
- [ ] YTD mode aggregates correctly across multiple months
- [ ] YTD label shows the correct date range
- [ ] YoY mode shows two-column layout when prior data exists
- [ ] YoY mode shows unavailability notice when prior data is absent
- [ ] View mode persists to localStorage and survives refresh
- [ ] No console errors in any mode
- [ ] No existing features broken (net worth hero, projection chart, transactions table, review queue)

---

## 7. Open Questions

- [OPEN: Should the briefing include a "vs last month" delta for each expense category, or just the total net worth delta? Current spec: net worth delta only. Revisit after first build.]
- [OPEN: In YoY mode, should the expense bar chart show grouped bars (current vs prior) or just current? Current spec: current month only. Revisit after first build.]

---

## Changelog

| Version | Date | Summary |
|---|---|---|
| v1.0 | 2026-04-06 | Initial draft covering Feature A (briefing export) and Feature B (YTD + YoY toggle) |
