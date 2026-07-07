---
title: "PRD: Portfolio Section Redesign (Timeline/Ledger)"
date: 2026-04-24
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/software]
status: active
source_file: "3. Personal/Personal Finance/Personal finance dashboard/docs/prd-portfolio-redesign.md"
source_type: md
confidence: 0.8
imported: 2026-05-14
---

# PRD: Portfolio Section Redesign (Timeline/Ledger)

**Status:** Draft v1
**Owner:** Thomas
**Last updated:** 2026-04-23
**Target executor:** AI coding agent (Claude Code) operating on this repo
**Scope:** `src/Dashboard.jsx` portfolio section + `src/lib/{lots,finance,backup,defaults}.js` + new modules

---

## 1. Problem

The current Portfolio section has five concrete failure modes, confirmed across three independent design reviews:

1. **Auto-invest config lives in Settings** (`src/Dashboard.jsx:3420-3468`) but its synthetic lots land in Portfolio. Cause and effect sit on different screens.
2. **Allocation flow uses `window.prompt` six times** (`src/Dashboard.jsx:1497`) to reconcile one monthly DCA transfer. Unusable for a 6-ETF plan.
3. **Holdings table mixes three jobs** (read value, edit qty/price, add instruments) in a dense 12-col grid. Qty input is disabled when lots exist but still rendered, which reads as broken.
4. **No bulk path for historical sporadic buys.** `handleOpenLotModal` (`src/Dashboard.jsx:1543`) is one lot at a time. Years of legacy buys = death by modal.
5. **No per-month state.** The user thinks in months ("did March get reconciled?") but the UI is holding-first with no chronological narrative.

## 2. User context (ground truth)

- Single user: Thomas. DCAs **€1,000/month** across 6 ETFs with fixed weights: **VWCE 25%, WTAI 10%, EXUS 15%, AVWS 15%, IGLN 20%, ICOM 15%**.
- Has historical sporadic buys pre-plan that are painful to enter one-by-one.
- Fully automatic reconciliation is reliable only **from 2026-03 onward**. Before that, too many irregularities.
- Primary jobs the section must support: (a) accurate net worth contribution, (b) review and reconcile broker transfers.
- Prefers a **guided** flow with an explicit **auto** opt-in, not hidden automation.

## 3. Solution: Timeline/Ledger

Three stacked panes on the Portfolio section:

1. **Summary header** (read-only chips: total value, P&L, weighted TER, drift summary).
2. **Plan bar** (monthly amount, allocation weights, auto-from-month cutoff, edit action). Auto-invest config moves here from Settings.
3. **Holdings reference** (compact, read-only rows per holding with drift; edits move to a side drawer).
4. **Ledger** — reverse-chronological month blocks. Each block shows the broker transfer and the 6 lots with a status chip: `needs review`, `auto ✓`, `confirmed`, `partial`, `historical`. Primary interaction surface.

Historical buys go through a dedicated **Backfill modal** (TSV paste) that marks covered months as `historical` and suppresses matching broker transfers from the reconciliation queue.

**Why this over Inbox-first or Holdings-first:** the user's mental model is per-month ("what happened in March?"), and the `autoFromMonth: 2026-03` cutoff maps directly onto the ledger's status chips. Historical mess is contained in a separate surface instead of nagging inside the live flow.

## 4. Success criteria

Ship is successful if, after one week of use:

- Reconciling a monthly DCA transfer takes **one click from detection to confirmed** when prices lookup succeeds; **≤30 seconds** when the user must enter prices manually.
- Zero `window.prompt` calls in the portfolio flow.
- All historical sporadic buys can be imported in a single paste session (no per-lot modals required).
- Net worth totals match current production values before and after migration (regression-guarded).
- Backup v6 round-trips without data loss from any v1–v5 file.

## 5. Non-goals (explicitly out of scope for this redesign)

- Adding a new price data source or historical price API. Reuse existing `priceLookup`.
- Currency conversion logic changes. Existing EUR handling stays.
- Tax reporting, FIFO/LIFO lot-selection for disposals. Out of scope.
- Dividend tracking. Out of scope.
- Brokers other than the user's current one. No broker-specific API integration.
- Multi-user / shared portfolio. Single-user app.
- Mobile-specific layouts. Existing responsive patterns only.
- Changes to transaction categorization or cashflow pipeline.

## 6. Storage contract changes

Additions to `pf_settings.autoInvest`:

| Field | Type | Default | Purpose |
|---|---|---|---|
| `autoFromMonth` | `string` (`YYYY-MM`) | `"2026-03"` | Month at or after which auto-confirm is allowed |
| `manualMonths` | `string[]` (`YYYY-MM`) | `[]` | Per-month overrides forcing guided flow even if ≥ `autoFromMonth` |
| `autoConfirmTolerance` | `number` | `1` | EUR tolerance on transfer-vs-planned amount match for silent confirm |

No new top-level localStorage keys. `pf_ledger_status` is **derivable** from `lot.source` + `pf_lot_links` presence and should NOT be added as storage.

**Backup schema bumps to v6.** Migration v5→v6:
- Default the three new `autoInvest` fields if missing.
- All other fields unchanged.

`buildBackupPayload` and `restoreBackupState` both updated.

## 7. Technology & pattern constraints

- React 18, Vite, no new dependencies unless explicitly justified in the phase.
- Follow existing style: `T` theme tokens, `card()` helper, CSS vars from `src/styles/tokens.css`.
- Respect `CLAUDE.md` declaration-order rules: any new `useMemo`/`useCallback` must appear after every function it names in its dep array.
- Pure view logic (ledger rendering) belongs in new hooks under `src/hooks/`. Storage writes stay in `Dashboard.jsx` handlers to keep persistence effects centralized.
- Ledger is a **read view** over `pf_months`, `pf_lots`, `pf_lot_links`, `settings.autoInvest`. Only `Confirm`, `Backfill`, and `Edit plan` paths write.
- No second lot-creation path. All writes flow through existing `allocateToLots` + `pf_lots` / `pf_lot_links` mutations.

---

## Phase 0 — Research & plan (mandatory before any code)

**Goal:** Surface misunderstandings before they become expensive.

**Deliverable:** A plan document at `docs/portfolio-redesign-implementation-plan.md` covering:

1. A file-by-file list of every write-touch-point that currently mutates `pf_lots` / `pf_lot_links` / `pf_settings.autoInvest`. Include line numbers.
2. A declaration-order audit of new memos and hooks you intend to add to `Dashboard.jsx`, confirming no TDZ hazards.
3. The exact shape of the ledger's derived data: one TypeScript-style sketch of `LedgerMonth = { month, transfers, lots, status, planAmount, ... }`.
4. Migration test cases: one v1, v3, and v5 backup file replayed through v6 restore with expected outputs.
5. Risk log: anything that blocks any later phase.

**Done when:** plan document exists and user has acknowledged it. **Do not start Phase 1 before approval.**

**Non-goals for this phase:** No source-file edits. No refactors. No partial implementation.

---

## Phase 1 — Foundation: storage, migration, Plan bar edit path

**Depends on:** Phase 0 approved.

**Goal:** New `autoInvest` fields round-trip through backup v6; Plan bar UI exists and can edit `autoInvest` in place.

### Requirements

1. **Extend `DEF_SETTINGS.autoInvest`** in `src/lib/defaults.js` with `autoFromMonth: "2026-03"`, `manualMonths: []`, `autoConfirmTolerance: 1`.
   - Acceptance: Given a fresh localStorage, when the app boots, then `settings.autoInvest` contains the three new fields with documented defaults.

2. **Bump backup schema to v6** in `src/lib/backup.js`.
   - `buildBackupPayload` writes `version: 6` and includes the new fields under `settings.autoInvest`.
   - `restoreBackupState` accepts v1–v6. v5→v6 migration defaults missing fields.
   - Acceptance: Given a v5 backup, when restored, then `settings.autoInvest.autoFromMonth === "2026-03"` and `manualMonths === []` and `autoConfirmTolerance === 1`.
   - Acceptance: Given a v6 backup with values set, when restored, then values are preserved verbatim.

3. **Update backup tests** in `src/lib/backup.test.js` to cover the v5→v6 migration and a v6 round-trip.

4. **Update `docs/data-contracts.md`** to reflect the new `autoInvest` fields.

5. **Update `CLAUDE.md`** Storage Contract section and Backup Format section to mention v6 + new fields. One sentence each, no history.

6. **Add a Plan bar component** at `src/components/PlanBar.jsx`:
   - Reads `settings.autoInvest` (amount, allocations, autoFromMonth).
   - Renders a one-line summary: `DCA €{amount}/mo · {top-3 allocations} + N more · Auto from: {autoFromMonth}`.
   - Has an `[Edit plan]` button that opens an existing modal shape (see requirement 7).
   - Acceptance: Given `autoInvest.amount = 1000` and the 6-ETF allocation, when the bar renders, then the summary text matches the format above.

7. **Add a Plan edit modal** at `src/components/PlanEditModal.jsx`:
   - Fields: amount (number), allocations (6 rows: holdingId + weight%, must sum to 100±0.01), broker IBANs (list editor), `autoFromMonth` (month picker, `YYYY-MM`), `manualMonths` (tag-list add/remove).
   - Save writes through an `onSave(nextAutoInvest)` prop; Dashboard owns persistence.
   - Acceptance: Given weights summing to 99.9, when user clicks Save, then save is blocked with a validation error and no persistence occurs.
   - Acceptance: Given valid input, when Save is clicked, then `pf_settings.autoInvest` is updated and the modal closes.

8. **Mount Plan bar** at the top of the Portfolio section in `Dashboard.jsx`, above the existing `InvestmentInbox`. Do not remove anything else yet.

### Non-goals for Phase 1

- Do NOT touch the holdings table, the current InvestmentInbox, `handleAllocateCandidate`, or `applyAutoInvest`.
- Do NOT delete the auto-invest settings panel in Settings yet. Dual-surface is acceptable for one phase.
- Do NOT add ledger rendering.
- Do NOT change net worth math.

### Done when

- `npm run build` passes.
- `npm run test` passes including new backup tests.
- Opening Portfolio shows the Plan bar with correct data. Editing and saving updates localStorage and the bar re-renders.
- Backup export contains `version: 6` and new fields. Restoring a v5 backup fills defaults.

---

## Phase 2 — Ledger view (read-only)

**Depends on:** Phase 1 complete and passing.

**Goal:** Render the month-block ledger as a pure view over existing state. No writes. Existing reconciliation paths continue to work unchanged.

### Requirements

1. **Create `src/hooks/useLedger.js`**:
   - Inputs: `months`, `lots`, `lotLinks`, `settings.autoInvest`, `portfolio`.
   - Output: `LedgerMonth[]` sorted descending by month. Each:
     ```
     {
       month: "YYYY-MM",
       transfers: Array<{ txKey, date, amount, counterparty }>,
       lots: Array<{ holdingId, ticker, lot }>,
       status: "needs_review" | "auto" | "confirmed" | "partial" | "historical",
       planAmount: number,
       planDelta: number,   // transferAmount - planAmount
     }
     ```
   - `status` derivation rules:
     - If any lot in the month has `source: 'backfill'` → `historical`.
     - Else if transfer exists AND `lotLinks[txKey]` is missing/empty AND any lot has `source: 'auto-invest'` → `auto`.
     - Else if transfer exists AND `lotLinks[txKey]` length > 0 AND all lots have prices → `confirmed`.
     - Else if transfer exists AND `lotLinks[txKey]` length > 0 AND any lot missing price → `partial`.
     - Else if transfer exists with no matching lots → `needs_review`.
   - Acceptance: Given a month with one transfer and 6 lots source=`auto-invest`, no link entry, when `useLedger` runs, then `status === 'auto'`.
   - Acceptance: Given a month with backfill lots, when `useLedger` runs, then `status === 'historical'` regardless of other signals.

2. **Create `src/components/LedgerMonthBlock.jsx`**:
   - Collapsed header row: month, `€{amount}`, `{n} lots`, status chip.
   - Expanded: transfer detail line(s), lot table (ticker, qty, price, amount EUR), action row.
   - Action row in this phase is stubbed: a disabled `[Confirm]`, a link `[Edit plan]` that opens the Phase-1 Plan modal, and `[View transaction →]` that links to the Transactions section pre-filtered to that tx.
   - Acceptance: Given a `LedgerMonth` with 6 lots, when expanded, then all 6 lot rows render with ticker, qty, price, and computed `qty * price` EUR.

3. **Mount the ledger** below holdings in `Dashboard.jsx`. Keep the existing holdings table and InvestmentInbox mounted for now — the ledger is additive in this phase.

4. **Add unit tests** for the status derivation in `src/hooks/useLedger.test.js`, covering each of the five statuses with minimal fixtures.

### Non-goals for Phase 2

- Do NOT write to storage from the ledger.
- Do NOT replace `InvestmentInbox` or the holdings table yet.
- Do NOT implement confirm/edit actions. Stub them.
- Do NOT auto-confirm anything. `auto` status here reflects existing `applyAutoInvest` behavior only.

### Done when

- `npm run build` passes; tests pass.
- Ledger renders alongside existing surfaces without regressions.
- Status chips match the derivation rules for real user data (spot-check one of each status if available).

---

## Phase 3 — Guided confirm flow replaces `window.prompt`

**Depends on:** Phase 2 complete.

**Goal:** A `needs_review` block becomes actionable inline. One `Confirm` writes all lots atomically. `handleAllocateCandidate`'s 6× `window.prompt` is retired.

### Requirements

1. **Extend `LedgerMonthBlock.jsx`** with a guided form shown when `status === 'needs_review'`:
   - Pre-fills per-ETF allocation using `settings.autoInvest.allocations` applied to the transfer amount.
   - Each row has editable `qty` and `price` inputs. `qty` auto-computes from `allocatedEUR / price` when price is edited, and vice versa. Both can be manually overridden.
   - Price inputs pre-filled from the most-recent lot price for that holding, or empty if none.
   - `[Fetch prices for {date}]` button calls existing `priceLookup` for each holding with the transfer date, fills any empty price inputs, leaves user-edited ones alone.
   - `[Confirm]` disabled until every row has qty and price > 0.
   - Acceptance: Given a €1,000 transfer and the 6-ETF plan, when the block expands, then row EUR values are 250/100/150/150/200/150 and match plan weights.
   - Acceptance: Given a user edits price for VWCE, when the price changes, then qty updates to `250 / newPrice`.

2. **Add handler `handleConfirmLedgerMonth(month, rows)`** in `Dashboard.jsx`:
   - Writes one lot per row to `pf_lots[holdingId]` with `source: 'inbox'`, `date` = transfer date, `txId` = transfer `txKey`.
   - Writes `pf_lot_links[txKey] = [lotId1, ..., lotIdN]`.
   - Operation is atomic: if any write fails, rollback all (use a single state update).
   - Acceptance: Given Confirm clicked with 6 valid rows, when the handler runs, then `pf_lots` has 6 new entries and `pf_lot_links[txKey]` length is 6.

3. **Remove `handleAllocateCandidate`'s `window.prompt` calls** (`src/Dashboard.jsx:1497`). The function stays but delegates to the new handler if still invoked from legacy surfaces; better: delete the function if no callers remain.

4. **Edge case: multiple transfers in same month.** The block shows both transfer rows; user can reconcile each independently. Ledger status reflects the weakest: if any transfer has no link, month stays `needs_review`.

5. **Edge case: amount mismatch.** If `abs(transferAmount - planAmount) > autoConfirmTolerance`, show an amber hint "Amount differs from plan by €X" above the allocation table. Do not block confirm; scale EUR values proportionally by default, user can edit.

6. **Edge case: lots exist but no transfer.** Block status is `confirmed` or `historical` (by source); no form rendered.

### Non-goals for Phase 3

- Do NOT auto-confirm anything yet. Confirm is always a user click.
- Do NOT implement backfill. That's Phase 5.
- Do NOT remove the legacy InvestmentInbox or holdings table yet.

### Done when

- `npm run build` passes; tests pass.
- Reconciling a monthly DCA takes one click when prices resolve; ≤30s manual.
- No `window.prompt` calls remain in the portfolio flow.
- Confirmed months show `confirmed` chip and persist across reload.

---

## Phase 4 — Auto-from-month cutoff and silent auto-confirm

**Depends on:** Phase 3 complete.

**Goal:** Months at or after `autoFromMonth` with matching transfer and resolvable prices auto-confirm without user action. User can override per-month.

### Requirements

1. **Add `applyAutoConfirm(ledgerMonth, settings)` pure function** in `src/lib/lots.js` or a new `src/lib/autoInvest.js`:
   - Returns proposed lot rows if: `month >= autoFromMonth`, `month not in manualMonths`, one transfer, `abs(transferAmount - planAmount) <= autoConfirmTolerance`, all prices resolvable.
   - Returns null if any precondition fails.

2. **Wire auto-confirm into month-ingestion side effect** in `Dashboard.jsx`: when a month's CSV lands and the ledger would produce `needs_review`, run `applyAutoConfirm`; if non-null, invoke `handleConfirmLedgerMonth` with `source: 'auto'` instead of `'inbox'`.

3. **Reconcile with existing `applyAutoInvest`**:
   - `applyAutoInvest` continues to write synthetic lots when the broker transfer hasn't landed yet.
   - When the real transfer lands and `applyAutoConfirm` runs, it must replace the synthetic lots via the existing `reconcileAutoInvestOnMonthReplace` path, not stack on top.
   - Acceptance: Given synthetic auto-invest lots for 2026-03 and then a CSV upload containing the real €1,000 transfer, when reconciliation runs, then `pf_lots` for March 2026 has 6 lots (not 12) and all are linked to the real transfer.

4. **Per-month override UI**: in each `auto ✓` ledger block, an `[Uncheck auto for this month]` action that adds the month to `manualMonths` and reverts lots to `needs_review` (delete auto lots, clear lot links).
   - Acceptance: Given an auto-confirmed March, when user unchecks auto, then status becomes `needs_review`, lots are cleared, `manualMonths` contains `"2026-03"`.

5. **Undo strip** at the top of the ledger showing the most recently auto-confirmed month with a one-click undo. Clears after 24h or next page reload.

6. **Delete the auto-invest panel in Settings** (`src/Dashboard.jsx:3420-3468`) — it's now fully superseded by the Plan bar/modal. Replace with a single-line redirect: "Auto-invest is configured in Portfolio → Plan." (Keep redirect text for one release, remove in a later cleanup.)

### Non-goals for Phase 4

- Do NOT add per-row tolerance overrides. One global `autoConfirmTolerance` is sufficient.
- Do NOT auto-fetch prices in the background. Auto-confirm only fires when all prices resolve synchronously via the existing `priceLookup`.
- Do NOT remove `applyAutoInvest` entirely. It's still useful for mid-month NW estimates before CSV import.

### Done when

- `npm run build` passes; tests pass.
- Uploading a CSV with a matching March 2026+ transfer auto-creates 6 lots, status is `auto ✓`, no user action needed.
- Unchecking auto reverts cleanly and month becomes editable.
- Settings auto-invest panel is gone/replaced.

---

## Phase 5 — Backfill modal for historical sporadic buys

**Depends on:** Phase 2 complete (Phase 3/4 not required but recommended).

**Goal:** Enter years of historical buys in one paste. Affected months render as `historical` and do not appear in the reconciliation queue.

### Requirements

1. **Create `src/lib/lotImport.js`** with `parseBackfillTSV(text)`:
   - Accepts headered or headerless rows with columns: `ticker, date (YYYY-MM-DD), qty, price`.
   - Returns `{ rows: ParsedRow[], errors: ParseError[] }`.
   - Resolves `ticker → holdingId` using current `pf_portfolio`. Unresolved rows flagged with an error suggesting mapping.
   - Acceptance: Given `VWCE,2024-07-03,2.10,98.40` with VWCE in portfolio, when parsed, then a row with `holdingId`, `amountEUR=206.64` is produced.

2. **Create `src/components/BackfillModal.jsx`**:
   - Tab 1: paste TSV/CSV textarea.
   - Tab 2: stub with text "Broker statement presets — coming later." (Do not implement in this phase.)
   - Preview table after parse: date, ticker (with map-to dropdown if unresolved), qty, price, amount, remove-row button.
   - Checkbox: "These months are already reconciled — don't surface matching bank transfers."
   - `[Import all]` writes lots with `source: 'backfill'`, `txId: null`. If the reconciled checkbox is set, for each covered month find outgoing broker-IBAN transfers and set `pf_lot_links[txKey] = []` (empty array = reviewed/suppressed marker).
   - Acceptance: Given 10 parsed rows across 3 months with reconciled box checked, when Import is clicked, then 10 lots exist, 3 months show `historical` status, and any matching broker transfers no longer appear as `needs_review`.

3. **Mount `[Backfill historical buys]` button** at the top of the ledger.

4. **Unit tests** in `src/lib/lotImport.test.js` covering: happy path, header detection, unresolved ticker, malformed date, negative qty rejection, duplicate-row detection (same holding+date+qty within the paste — warn but allow).

### Non-goals for Phase 5

- Do NOT implement broker-specific statement parsers. Tab 2 is a stub.
- Do NOT attempt to fetch historical prices. User enters price per row.
- Do NOT merge / dedupe against existing lots. New paste always creates new lots; user removes dupes in preview.

### Done when

- `npm run build` passes; tests pass.
- Pasting 30+ historical rows produces 30+ lots in one commit. Affected months chip as `historical`. Reconciled-box behavior verified.

---

## Phase 6 — Holdings reference pane + streamlined add-holding

**Depends on:** Phase 3 complete.

**Goal:** Replace the dense editable holdings table with a read-only reference pane. Editing moves to a side drawer. Adding a holding becomes a single search field.

### Requirements

1. **Create `src/components/HoldingsReference.jsx`**:
   - One row per holding: ticker, name, current price, market value, qty (derived from `effectiveHolding`), `[Edit]` button that opens the side drawer.
   - **No `Act Wt` or `Drift` columns.** Do not render target-weight UI anywhere.
   - Read-only. No inputs.
   - Collapsible.

2. **Create `src/components/HoldingDrawer.jsx`**:
   - Edits: ticker, ISIN, sleeve, TER, currency, exchange. **Not** qty, avgPrice, or targetWeight.
   - Legacy holdings with `{qty, avgPrice}` and no lots: show a warning "This holding has no lots. Use Backfill to add lots." and keep qty/avgPrice inputs for back-compat, but mark as deprecated.

3. **Streamline add-holding**:
   - Replace the inline add row (`src/Dashboard.jsx:2812-2908`) with a `[+ Add holding]` button.
   - Single-field dialog: "Search symbol or paste ISIN." Uses existing `symbolResolver`.
   - After resolve: second step picks sleeve only. No target-weight field. If the holding should participate in the Plan, the user adds it via Plan modal (Phase 1) allocations list.

4. **Deprecate `holding.targetWeight`**: stop reading it in all UI paths. Leave the field in storage for back-compat with older backups, but no code path writes or reads it after this phase.

5. **Remove the current editable holdings table and the `InvestmentInbox` component from the Portfolio section.** Keep the sleeve summary card.

6. **Update `CLAUDE.md`** `activeSection` list and Where-to-edit table to reflect the new component boundaries. Note `holding.targetWeight` as deprecated.

### Non-goals for Phase 6

- Do NOT delete `InvestmentInbox.jsx` file yet — other surfaces may reference it. Just stop mounting it in Portfolio.
- Do NOT remove legacy `{qty, avgPrice}` fallback from `effectiveHolding`. Back-compat required.
- Do NOT change `holding.targetWeight` field shape. Plan allocations write through to it for now.

### Done when

- `npm run build` passes; tests pass.
- Portfolio section final IA: Summary header → Plan bar → Holdings reference (collapsed by default) → Ledger → Sleeve summary.
- Adding a holding is one search + sleeve pick. No dense inline row.
- Editing a holding happens in a drawer, not inline.

---

## 8. Measurement plan

Add instrumentation events (console-only if no analytics wired; use `debug` namespace `pf:portfolio`):

| Event | Fields | Purpose |
|---|---|---|
| `portfolio.ledger.rendered` | month count, status breakdown | Verify ledger loads with expected data |
| `portfolio.ledger.confirm` | month, lot count, autoConfirm: bool, duration_ms | Measure reconcile time |
| `portfolio.ledger.unconfirm` | month | Catch regret / friction |
| `portfolio.backfill.import` | row count, month span | Usage of backfill |
| `portfolio.plan.edit` | changed fields | Plan churn |
| `portfolio.autoConfirm.applied` | month, priceSources | Auto success rate |
| `portfolio.autoConfirm.rejected` | month, reason | Auto miss reasons |

## 9. Rollout

This is a single-user local app. Rollout = merge to `main`. No feature flag. Safety net:

- Each phase ships as its own PR with passing `npm run build` and tests.
- Backup v6 migration is reversible in the sense that v5 backups keep working; v6 backups are readable only by post-Phase-1 builds. User should export a v5 backup before upgrading.
- Phase 6 is the only destructive UI change (removes the holdings table). Confirm with user before merging Phase 6.

## 10. Resolved decisions

- **`autoConfirmTolerance` defaults to `1` EUR** (rounding tolerance). Matches real-world broker cent-rounding.
- **Incoming broker→bank transfers** do not need reconciliation logic. They already land in cash via the normal cashflow pipeline. The ledger only surfaces **outgoing** transfers as reconciliation tasks; incoming ones are ignored by `detectBrokerTransfers` (already the case) and no special "disposal" handling is introduced. Effect on net worth: cash goes up, and since no lots are consumed, investments stay flat unless the user manually adjusts — acceptable for now; lot-disposal is explicitly out of scope (section 5).
- **Drop target-weight and drift entirely.** Remove the `Act Wt` and `Drift` columns from the holdings view. `holding.targetWeight` field is deprecated and no longer read by the UI. Sleeve summary stays (it uses sleeve membership, not per-holding target). Plan allocations remain the single source for reconciliation proposals only.

## 11. Risks

| Risk | Mitigation |
|---|---|
| Declaration-order TDZ hazard in `Dashboard.jsx` | Phase 0 audit; extract ledger logic into hooks under `src/hooks/`. |
| Double-write between `applyAutoInvest` and auto-confirm | Phase 4 req 3 tests reconcile-on-replace explicitly. |
| Backup v6 migration corrupts old files | Phase 1 req 3 adds explicit migration tests covering v1, v3, v5 inputs. |
| User pastes malformed backfill TSV | Phase 5 parser returns errors; preview table surfaces them before commit. |
| Auto-confirm silently writes wrong lots if plan changed mid-month | `source: 'auto'` + undo strip + per-month override (Phase 4 req 4-5). |
| Performance regression on large ledgers (many months) | `useLedger` memoized on `months`, `lots`, `lotLinks`; virtualize if > 60 months (defer to measurement). |

## 12. Out-of-scope cleanups (future PRDs)

- Broker statement presets (DeGiro, IBKR) for Backfill Tab 2.
- Historical price fetch for backfill rows.
- Remove `holding.targetWeight` field from storage + backup payload (deprecated in Phase 6, safe to delete after one release).
- Remove `InvestmentInbox.jsx` file after confirming no other consumers.
- Mid-month NW estimation without `applyAutoInvest` fabrication.

---

## Changelog

- **v1 (2026-04-23)** — Initial draft. Derived from three parallel research agents + user workflow sign-off on Option C (Timeline/Ledger).
