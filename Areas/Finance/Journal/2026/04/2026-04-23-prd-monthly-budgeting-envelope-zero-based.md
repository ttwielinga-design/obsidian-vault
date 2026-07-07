---
title: "PRD — Monthly Budgeting (Envelope / Zero-based)"
date: 2026-04-23
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/software]
status: active
source_file: "3. Personal/Personal Finance/Personal finance dashboard/docs/prds/01-budgeting-envelope.md"
source_type: md
confidence: 0.8
imported: 2026-05-14
---

# PRD — Monthly Budgeting (Envelope / Zero-based)

**Status:** Draft
**Owner:** Thomas
**Target:** MVP
**Related issues:** (new — to be filed after PRD approval)

---

## 1. Context

The app currently has 11 expense categories and a non-functional "Monthly Budgets" settings stub (rows show "no limit"). Users have no way to plan spending against future income. The data foundation is already strong: `allCategorized` is the single source of truth, `computeCashFlow()` gives per-month income/expense breakdowns, `networthHistory` persists monthly snapshots.

This PRD defines a **zero-based envelope budgeting** system (YNAB / EveryDollar model) — every euro of income is explicitly assigned to a job (spending category, savings, or investing) until unassigned equals zero.

## 2. Why envelope over alternatives

Evaluated three models: Envelope (A), Flex + Rollover (B), Safe-to-Spend (C). User selected A.

- **Why it fits:** gives the strongest discipline signal. Reassignment forces the user to confront trade-offs when they overspend (move money from envelope X to envelope Y), which is exactly the "consciousness about money" outcome the dashboard aims for.
- **Trade-off accepted:** monthly assignment is a real ritual. Mitigation: one-click "copy last month's assignments" + auto-seed from trimmed-mean trends.
- **What we give up by not picking B/C:** rollover buffers (B) and one-number simplicity (C). We can revisit if the ritual becomes unsustainable.

## 3. Goals

- Every euro of monthly income is assigned to a category before month-end feels comfortable.
- Overspending is visible, not silent. Red flag on any envelope where `spent > assigned`.
- User can reassign between envelopes in one interaction.
- First-run setup is under 60 seconds (seeded from 6-mo trend).
- Monthly ritual takes under 90 seconds in steady state.
- Works offline; purely client-side; respects all CLAUDE.md invariants.

## 4. Non-goals (v1)

- Debt-payoff scheduling (YNAB's "Age of Money" metric, debt snowball).
- Multi-account envelopes (treating savings account X as envelope Y).
- Goal linking beyond what `settings.goals` already provides.
- Shared budgets (multi-user).
- Notifications / scheduled reminders.

## 5. Mental model

**Income → Envelopes → Spending.**

1. When a paycheck (or any income) lands in a month, the user sees **Unassigned = €X** at the top of the Budget tab.
2. The user distributes € across envelopes (= categories + synthetic envelopes like `Savings`, `Investing`, `Buffer`) until Unassigned = 0.
3. As expenses classify into categories, each envelope shows `assigned → spent → available`.
4. Overspending marks an envelope red with a "Cover from…" action → user picks a source envelope, amount moves.
5. At month-end, the user decides per envelope: **Reset** (leftover returns to income pool for next month) or **Carry** (leftover seeds next month's envelope).

This is opt-in per envelope: some envelopes carry by default (e.g. `Vacation`), others reset (e.g. `Groceries`).

## 6. User flows

### 6.1 First-run (one time)
1. User clicks `Budget` sidebar link.
2. Empty state: "Let's set up your first month." Big primary action.
3. Setup screen seeded with 6-mo trimmed-mean suggestions per category (from `allCategorized` history).
4. User accepts or edits each envelope's starting amount.
5. User toggles `Carry/Reset` per envelope (sensible defaults: Vacation/Buffer carry; Groceries/Dining reset).
6. Save → lands on current-month budget view.

### 6.2 Monthly ritual (recurring)
1. At start of month, top banner: "Assign €3,240 to envelopes" (pulled from that month's income in `allCategorized`).
2. Three assignment options offered inline:
   - **Copy last month's assignments** (default, one click).
   - **Apply trend suggestions** (trimmed mean of last 6 months).
   - **Manual** (opens the distribution UI).
3. User lands on budget view with envelopes pre-filled. Tweaks as needed. Unassigned counter ticks toward 0.
4. Save. Stored under `pf_budgets[YYYY-MM]`.

### 6.3 Mid-month overspend
1. Envelope card shows red `-€42 over`.
2. User clicks `Cover from…` → popover lists envelopes with positive `available`.
3. User picks source + amount; both envelopes update atomically.
4. Logged in the month's `reassignments[]` array for the trend/audit view.

### 6.4 Month-end close
1. When a newer month's data arrives, the just-completed month flips to "closed."
2. Per-envelope close action: `Carry leftover` (fills next month's envelope) or `Reset` (returns to next month's income pool).
3. Default per envelope respects its `Carry/Reset` flag; user can override case-by-case.

## 7. Data model

### 7.1 New storage key: `pf_budgets`

```ts
type BudgetsStore = {
  version: 1;
  months: Record<string /* YYYY-MM */, MonthlyBudget>;
  templates: EnvelopeTemplate[];  // reusable per-envelope defaults
};

type MonthlyBudget = {
  month: string;                  // "2026-04"
  incomeAssigned: number;         // sum of assignments, should === income on close
  envelopes: Envelope[];
  reassignments: Reassignment[];
  closedAt?: string;              // ISO timestamp when user closed the month
};

type Envelope = {
  id: string;                     // stable uuid
  name: string;                   // "Groceries" | "Savings" | "Buffer" | custom
  category: string | null;        // linked to one of the 11 expense categories; null for synthetic envelopes like Savings
  assignmentType: "fixed" | "percent";
  assignmentValue: number;        // € if fixed, 0..1 if percent of income
  assigned: number;               // € resolved at assignment time
  carryLeftover: boolean;         // end-of-month behavior
  carriedIn: number;              // € seeded from prior month (if carried)
  // `spent` and `available` are NOT stored; derived from allCategorized + reassignments
};

type Reassignment = {
  id: string;
  timestamp: string;
  fromEnvelopeId: string;
  toEnvelopeId: string;
  amount: number;
  note?: string;
};

type EnvelopeTemplate = {
  id: string;
  name: string;
  category: string | null;
  assignmentType: "fixed" | "percent";
  assignmentValue: number;
  carryLeftover: boolean;
};
```

### 7.2 Derived values (never stored)

- `envelope.spent` = sum of txs in `allCategorized[month]` whose category matches `envelope.category`.
- `envelope.available` = `assigned + carriedIn + netReassignments - spent`.
- `unassigned` = `monthIncome - sum(envelope.assigned)`.

### 7.3 Storage contract changes

- Add `pf_budgets` key. **No impact on existing keys.**
- `pf_settings.budgets` stub (the "no limit" rows) is **deprecated** — migrated into a default template on first run if the user ever set any value.
- `backup.json` schema bumps **v5 → v6**, adds `budgets: BudgetsStore`. Restore of v5 seeds an empty `BudgetsStore`. No lossy migration. (v4 = ownIbans/IBAN CRUD; v5 = symbolMap — see playbook for the authoritative sequence.)

## 8. Architecture

### 8.1 New files

- `src/lib/budgets.js` — pure functions: `resolveAssignment()`, `computeEnvelopeSpent()`, `computeAvailable()`, `seedFromTrend()`, `closeMonth()`.
- `src/components/BudgetSection.jsx` — top-level section rendered when `activeSection === 'budget'`.
- `src/components/BudgetEnvelopeCard.jsx` — single envelope row.
- `src/components/BudgetAssignModal.jsx` — the assignment UI.
- `src/components/BudgetReassignPopover.jsx` — the "Cover from…" flow.

### 8.2 Dashboard.jsx changes

- Add `budget` to sidebar (`src/components/Sidebar.jsx`), under **PLANNING** section, with keyboard shortcut `g b`.
- Add `budget` case to `activeSection` switch.
- **No changes to `allCategorized`, `classify()`, `computeCashFlow()`, `networthHistory`.** Envelope spending reads from `allCategorized` derivatively — never writes back.
- Declaration order: `budgets` state and memos land **after** `allCategorized` and `computeCashFlow` results but **before** their consumers in render. Verified via `npm run build`.

### 8.3 Trend-seed helper

`seedFromTrend(category, months, allCategorized)`:
1. Pull last `N` months of that category's totals.
2. Discard top and bottom 10% (trimmed mean).
3. Round to nearest €5.
4. Return as suggestion for envelope's `assignmentValue`.

### 8.4 Fixed vs percent

Both supported per-envelope. `assignmentType: 'percent'` resolves against that month's income at assignment time, stored as resolved `assigned` (so historical months don't drift if user later changes income definition).

## 9. UI/UX notes

- Envelope card: name + category pill + `spent / assigned` bar + `available` number + 3-dot menu (Reassign, Edit, Archive).
- Unassigned counter pinned top-right, persistent. Zero-state is visually celebrated (green check, not just white zero).
- Overspending: red left border, red `available` number, `Cover from…` action inline.
- Trend sparkline: 6-month mini chart in each envelope's menu detail. Not on the main card (too dense).
- Copy-last-month button prominent in the assignment flow; it's the 80% case.

## 10. Milestones

### M1 — Foundation (1 PR)
- Create `pf_budgets` key + `src/lib/budgets.js`.
- Add `budget` sidebar entry + empty `BudgetSection`.
- Storage contract v4 + backup/restore updates.
- No UI functionality yet.

### M2 — Core flow (1 PR)
- Envelope card rendering.
- First-run setup + assignment modal.
- `assigned`/`spent`/`available` math.
- Persist and read from `pf_budgets[month]`.

### M3 — Reassignment + month-close (1 PR)
- Cover-from popover.
- Close-month action with Carry/Reset per envelope.
- `reassignments[]` audit log.

### M4 — Trend seeding + templates (1 PR)
- 6-mo trimmed-mean suggestions.
- Copy-last-month action.
- Reusable envelope templates.

### M5 — Polish (0.5 PR)
- Unassigned banner animations, zero-state celebration.
- Sparklines in envelope menus.
- Empty / onboarding states refinement.

## 11. Invariants respected

- `allCategorized` remains the single source of truth for classified transactions. Budgets **read** from it, never write.
- `computeCashFlow()` unchanged — budgets are a UI layer on top.
- `networthHistory` unchanged. Savings rate is not redefined.
- Declaration order in `src/Dashboard.jsx`: budgets state lands after `allCategorized`, before sidebar render.
- Backup v4 is additive; v3 restore seeds empty `BudgetsStore`.

## 12. Verification

### Acceptance tests (manual)
- First-run setup: seed from trend, accept, land on budget view with envelopes pre-filled and `Unassigned = 0`.
- Mid-month: new transaction classifies into `Groceries` → Groceries envelope's `spent` ticks up, `available` ticks down.
- Overspend + reassign: force `spent > assigned`, cover from `Buffer`, both update atomically; check `reassignments[]` has the entry.
- Month-close: complete month, flip to next month's income, choose Carry on `Vacation` + Reset on `Groceries`, verify `carriedIn` on next month's Vacation envelope.
- Backup roundtrip: export, clear, restore, all budgets intact.

### Build checks
- `npm run build` — must pass; verifies no TDZ declaration-order regressions in `Dashboard.jsx`.
- Manual prod preview — verifies no `useMemo`/`useCallback` referencing-later-const errors.

## 13. Open questions

1. Custom envelopes — do we allow envelopes that don't map to one of the 11 expense categories (e.g., a `Wedding 2027` envelope that's just a savings bucket)? My default: yes, with `category: null` and spending entered manually.
2. Income definition — do we use `allCategorized[month].income` directly, or exclude refund-style positives first? My default: use income as currently computed; surface it clearly in the UI so user sees what's being budgeted against.
3. Partial-month start — what if user sets up budgeting mid-month? My default: budget the rest of the month with prorated income, don't back-fill.
4. Linking to existing `settings.goals` (already in the app) — should hitting an envelope's carryover milestone auto-update a linked goal? My default: v1 keeps them independent; revisit in v2.

## 14. Follow-up work (explicitly deferred)

- "Age of Money" metric (YNAB flagship signal).
- Debt-payoff envelopes with auto-minimum calculation.
- Multi-currency envelopes.
- Spending forecasts based on envelope velocity.
- Notification triggers (e.g., "80% of Groceries spent").
