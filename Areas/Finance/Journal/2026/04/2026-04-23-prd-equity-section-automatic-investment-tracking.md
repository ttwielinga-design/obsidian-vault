---
title: "PRD — Equity Section + Automatic Investment Tracking"
date: 2026-04-23
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/software]
status: active
source_file: "3. Personal/Personal Finance/Personal finance dashboard/docs/prds/02-equity-investments.md"
source_type: md
confidence: 0.8
imported: 2026-05-14
---

# PRD — Equity Section + Automatic Investment Tracking

**Status:** Draft
**Owner:** Thomas
**Target:** MVP
**Related issues:** [#26](https://github.com/ttwielinga-design/personal-finance-dashboard/issues/26), [#27](https://github.com/ttwielinga-design/personal-finance-dashboard/issues/27), [#28](https://github.com/ttwielinga-design/personal-finance-dashboard/issues/28), [#29](https://github.com/ttwielinga-design/personal-finance-dashboard/issues/29)

---

## 1. Context

Two related problems solved as one workstream:

1. **Information architecture:** Property lives under "Settings," the Portfolio is its own sidebar section, and investment tracking is scattered across Portfolio + Inbox. There's no coherent "stuff I own" view.
2. **Investment tracking is manual:** when the user wires money to a broker IBAN, they must manually create a lot with ticker, quantity, and price. This is slow, error-prone, and the reason lots go unentered for months.

This PRD introduces a new **Equity** sidebar section that absorbs the existing Portfolio, moves Property out of Settings, and adds a lookup-assisted investment-creation flow powered by **Stooq + openFIGI + Frankfurter** (all CORS-open, free, keyless, client-side).

## 2. Why Stooq, not Yahoo Finance

Yahoo Finance API (`query1.finance.yahoo.com`) sends **no `Access-Control-Allow-Origin` header**. Browser requests fail from `localhost:5173` and any static host. CORS proxies are against Yahoo ToS and rate-limit aggressively. There is no browser-viable yfinance equivalent.

**Chosen stack:**
- **[Stooq](https://stooq.com/)** — historical daily OHLC via CSV. Example: `https://stooq.com/q/d/l/?s=iwda.uk&d1=20260315&d2=20260315&i=d`. CORS-open. Free. No key. Covers EU tickers (`.uk`, `.de`, `.fr`, `.pl`, etc.) and US.
- **[openFIGI](https://www.openfigi.com/)** — Bloomberg's free ISIN → ticker mapping API. CORS-open. 25 req/min unauthenticated, more with a free key.
- **[Frankfurter](https://www.frankfurter.app/)** — ECB reference FX rates. CORS-open. Free. For rare USD-only listings.

All three respect the CLAUDE.md "client-side only, localStorage-backed" constraint.

## 3. Goals

- Property and Investments live under one **Equity** section.
- Portfolio section collapses into Equity — no duplicate navigation.
- When a broker-bound transfer is detected, the user can create a lot in ≤ 3 interactions, with the market price auto-filled.
- Net-worth attribution correctly reflects every confirmed lot.
- Every price used in a lot is traceable back to its source and date (`lot.source` field).
- Works offline with graceful degradation (no Stooq → manual price entry inline).
- Respects all CLAUDE.md invariants.

## 4. Non-goals (v1)

- Stock splits, spin-offs, corporate actions (requires manual lot adjustment).
- Dividend tracking (reinvested or cash).
- Accumulating vs distributing ETF distinction (irrelevant for NAV tracking).
- Partial fills (if broker combines 3 fills into one wire, user sees one transfer; close enough).
- Recurring-transfer auto-detection with auto-approve (deferred — this is Approach 3 from research, a silent-correctness trap).
- Multi-currency net worth display (EUR base only).
- Real-time / intraday prices (close-of-day is sufficient).

## 5. Information architecture

### 5.1 Sidebar changes

**Before:**
```
MONEY
  Overview
  Cash Flow
  Portfolio       <-- removed
  Transactions
PLANNING
  Goals
  Subscriptions
```

**After:**
```
MONEY
  Overview
  Cash Flow
  Transactions
EQUITY                <-- new section
  Property
  Investments         <-- absorbs Portfolio + Investment Inbox
PLANNING
  Goals
  Subscriptions
```

Keyboard shortcuts: `g e` → Equity root, `g i` → Investments, `g p` → Property (property was not previously navigable by shortcut).

### 5.2 Equity root landing

Cards stacked vertically:
1. **Net equity summary** — `propertyValue - mortgage + investmentsValue` with 30-day delta.
2. **Property card** — current value, mortgage outstanding, LTV, monthly amortization; click to expand into the full Property detail.
3. **Investments card** — total value, pending inbox count, best/worst performer; click to expand into the full Investments detail.

## 6. User flows

### 6.1 Create a lot from the Investment Inbox

1. Transaction to a `brokerIbans` IBAN arrives via CSV import.
2. `detectBrokerTransfers()` surfaces it in the Investments → Inbox tab with a `Create lot →` button.
3. User clicks, modal opens.
4. **Search field** — user types ISIN (`IE00B4L5Y983`) or ticker (`IWDA`).
   - ISIN detected (12-char alphanumeric, starts with 2-letter country code) → openFIGI lookup → list of listings grouped by exchange.
   - Ticker typed → match against local `pf_symbol_map` cache first, fall back to openFIGI.
5. **Listing picker** — shows ISIN → [IWDA.AS (Euronext Amsterdam, EUR), IWDA.L (LSE, USD), IWDA.DE (Xetra, EUR)]. Default-select the first EUR listing. User can pick another.
6. **Price fetch** — Stooq call for `tx.date`, close price shown pre-filled.
   - If `tx.date` is non-trading (weekend/holiday), Stooq returns empty → walk back up to 4 calendar days → flag `source: "stooq:approximated"` on the lot, show "Price from 2026-03-13 (prior trading day)" inline.
   - If non-EUR listing chosen → fetch Frankfurter rate for `tx.date` → convert → flag `fxConverted: true`.
   - If Stooq/openFIGI/Frankfurter fails → inline fallback: user enters price manually, `source: "manual"`.
7. **Quantity** — user enters `qty`, or uses `auto from amount` → `qty = amountEUR / pricePerShare`.
8. **Confirm** — lot written to `pf_lots[holdingId]`, entry in `pf_lot_links[txKey] = [lotId]`, inbox entry disappears.
9. Net worth updates on next memo pass (same render cycle).

### 6.2 Manual lot entry (outside inbox)

- From Investments → Holdings, "Add lot" button on any holding opens the same modal without a pre-filled transfer. `source: "manual"`. No `pf_lot_links` entry (no transfer to link to).

### 6.3 Dismiss a transfer (not an investment)

- Inbox row → "Not an investment" → writes empty `pf_lot_links[txKey] = []` (existing behavior) → suppresses from inbox forever.

### 6.4 Edit / delete a lot

- From holding detail, lot row has edit and delete actions. Delete also cleans up `pf_lot_links` reverse mapping.

## 7. Data model

### 7.1 Existing (unchanged shape, additive fields)

```ts
type Lot = {
  id: string;
  date: string;              // YYYY-MM-DD
  qty: number;
  pricePerShare: number;     // in lot's native currency
  amountEUR: number;
  source: string;            // existing field, now with structured values
  txId?: string;

  // NEW optional fields:
  symbolKey?: string;        // "IWDA.AS" — stable exchange-qualified symbol
  currency?: "EUR" | "USD" | "GBP" | ...;
  fxConverted?: boolean;     // true if priced in non-EUR and converted
  fxRate?: number;           // EUR per foreign unit, used for the conversion
};
```

`source` values become a short enum:
- `"manual"` — user typed everything.
- `"stooq:exact"` — Stooq returned a close for the exact `tx.date`.
- `"stooq:approximated"` — Stooq returned the nearest prior trading day (within 4 days).
- `"stooq:manual-fallback"` — Stooq failed, user entered price manually.

### 7.2 New storage key: `pf_symbol_map`

Cache of ISIN → listing resolutions, to avoid hammering openFIGI.

```ts
type SymbolMap = {
  version: 1;
  byIsin: Record<string, {
    isin: string;
    name: string;
    listings: Listing[];
    cachedAt: string;       // ISO timestamp
  }>;
};

type Listing = {
  symbolKey: string;        // "IWDA.AS"
  ticker: string;           // "IWDA"
  exchange: string;         // "AS" (Euronext Amsterdam)
  currency: "EUR" | "USD" | "GBP" | ...;
};
```

Cache TTL: 30 days (listings rarely change). User can force refresh from holding detail menu.

### 7.3 New cache: `pf_price_cache` (in-memory + sessionStorage, not persisted)

Keyed by `${symbolKey}:${date}` → `{ close, currency, fetchedAt }`. Avoids repeat Stooq calls within a session. Small enough not to need localStorage.

### 7.4 Existing keys unchanged

- `pf_lots`, `pf_lot_links`, `pf_portfolio`, `settings.autoInvest.brokerIbans` all unchanged structurally.
- `effectiveHolding()` in `src/lib/lots.js` unchanged — still reconciles lot-tracked and legacy holdings.

### 7.5 Backup

Schema **v4 → v5**:
- Adds `symbolMap: SymbolMap` to export.
- Existing lots fields are additive (optional), so v4 restore works.
- `pf_price_cache` is not backed up (session cache only).
- (v4 = ownIbans/IBAN CRUD wave; see playbook for the authoritative version sequence.)

## 8. Architecture

### 8.1 New files

**Already shipped (do not recreate):**
- `src/lib/priceLookup.js` — Stooq fetch + non-trading-day walkback + FX reconciliation.
- `src/lib/symbolResolver.js` — openFIGI ISIN lookup + `pf_symbol_map` cache.
- `src/lib/fx.js` — Frankfurter ECB rate fetch + caching.
- `src/lib/priceCache.js` — session-scoped price cache.
- `src/components/InvestmentInbox.jsx` — the Inbox tab (already extracted from Portfolio section).

**Still to build (Wave 6 + Wave 9):**
- `src/components/EquitySection.jsx` — root landing with three cards.
- `src/components/LotCreateModal.jsx` — the 3-interaction create-lot flow.
- `src/components/HoldingDetail.jsx` — per-holding lot list + add/edit/delete.
- `src/components/PropertyDetail.jsx` — moved from Settings, identical fields.

### 8.2 Moved content

- Sidebar NAV in `src/components/Sidebar.jsx` — remove `portfolio`, add `equity` parent with `property` and `investments` children.
- Property block in `src/Dashboard.jsx` (search for `🏠 Property` comment, currently ~line 3063) — cut and relocate into `PropertyDetail.jsx`. `settings.*` keys unchanged.
- Current Portfolio block — relocate render into `InvestmentInbox.jsx` + `HoldingDetail.jsx`.

### 8.3 Stooq API adapter

```js
// src/lib/priceLookup.js
async function fetchCloseOnDate(symbolKey, date) {
  // symbolKey: "IWDA.AS" → Stooq: "iwda.nl" (exchange mapping table)
  // Walk back up to 4 calendar days if empty response.
  // Returns { close, currency, actualDate, approximated: boolean }.
}
```

Exchange suffix mapping table (hand-maintained, ~10 entries covers 95% of EU listings): `.AS → .nl`, `.DE → .de`, `.PA → .fr`, `.MI → .it`, `.L → .uk`, `.SW → .ch`, `.MC → .es`, `.VI → .at`, `.BR → .be`, `.LS → .pt`.

### 8.4 Error surfaces

- **Stooq 404 / empty** → walk back 4 days → if still empty, inline manual fallback.
- **openFIGI throttled (25/min)** → exponential backoff, cache hits prevent most calls.
- **Frankfurter down** → block confirm with "Can't resolve FX, try again or pick a EUR listing."
- **User offline** → all three services unreachable → full manual entry path always works.

### 8.5 Declaration order in Dashboard.jsx

- `equitySectionData` memo lands after `allCategorized`, `portTotal`, `currentPropertyValue`, `currentMortgageOutstanding` — all already defined earlier.
- Verified via `npm run build` — production build catches TDZ errors that dev does not.

## 9. Net worth & invariants

- Lots continue to feed `portTotal` via `effectiveHolding()` in `src/lib/lots.js` — no change to that contract.
- `netWorth = latestCashBal + property - mortgage + portTotal` — unchanged.
- Property enters net worth only at or after `settings.purchaseMonth` — unchanged.
- `computeCashFlow()` still ignores `Transfer` category — broker transfers remain classified as `Transfer` via the classification pipeline.
- No `classify()` changes. No `allCategorized` changes. No `networthHistory` schema changes.

## 10. Milestones

### M1 — IA move (1 PR) — absorbs FEAT-1, FEAT-2
- Add `equity` to sidebar NAV, remove `portfolio`.
- Create `EquitySection.jsx` root with the three summary cards.
- Move Property block from Settings → `PropertyDetail.jsx`.
- Move current Portfolio content → `InvestmentInbox.jsx` + `HoldingDetail.jsx` under Equity.
- **No price-lookup code yet.** Existing manual lot creation flow still works.
- Verification: `npm run build` passes; dev + preview both show Equity section; all storage keys read/write identically.

### M2 — Symbol resolver (1 PR)
- `src/lib/symbolResolver.js` with openFIGI integration.
- `pf_symbol_map` cache + TTL.
- Backup v4 schema bump (additive).
- UI: ISIN/ticker search field in the existing lot-create modal, shows listings picker.

### M3 — Price lookup (1 PR)
- `src/lib/priceLookup.js` with Stooq + walkback.
- `src/lib/fx.js` with Frankfurter.
- Auto-fill price in lot-create modal; show source + date inline; inline manual fallback when API fails.
- `source` / `symbolKey` / `fxConverted` / `fxRate` fields written to lots.

### M4 — Inbox polish (0.5 PR)
- "Create lot" action prominent on inbox rows.
- Holding detail view — list lots with source chips; edit/delete per lot.

### M5 — Equity summary polish (0.5 PR)
- 30-day delta on Equity root card.
- Best/worst performer on Investments card.
- Property amortization preview chart (reuses existing forecasting helpers in `src/lib/finance.js`).

## 11. Edge cases explicitly addressed

| Edge case | Handling |
|---|---|
| Trade date is weekend/holiday | Walk back up to 4 calendar days, flag `source: "stooq:approximated"` |
| USD-only listing (user picked `.L`) | Frankfurter fetch for `tx.date`, `fxConverted: true`, `fxRate` stored |
| Stooq returns empty after walkback | Inline manual price entry, `source: "stooq:manual-fallback"` |
| openFIGI rate-limited | Backoff + cache hits; ultimately fall back to manual ticker entry |
| ISIN with no EUR listing | User warned; FX conversion auto-applied |
| Same ticker on multiple exchanges | openFIGI returns all listings; user picks; preference remembered per-ISIN in `pf_symbol_map` |
| User wires to broker but doesn't buy (cash float) | "Not an investment" → writes empty `pf_lot_links[]`, suppresses forever |
| Lot created, then user deletes transfer | `pf_lot_links` reverse lookup cleans up on tx deletion |

## 12. Edge cases explicitly deferred

| Case | Why deferred | Future handling |
|---|---|---|
| Stock split | Rare; needs manual adjustment | v2: "Apply stock split" action on holding |
| Dividend reinvestment | Separate flow from purchase | v2: dedicated dividend tracker |
| Accumulating vs distributing | Irrelevant to NAV math | Never needed for this use case |
| Partial fills | Broker consolidates in one wire | Acceptable rounding |
| Multiple buys on same date | Multi-lot creation in one modal | v2 |

## 13. Verification

### Acceptance tests (manual, with network)
- Transfer `€500` to broker IBAN → appears in inbox → Create lot → type ISIN `IE00B4L5Y983` → pick `IWDA.AS` → price auto-fills for the transfer date → confirm → net worth updates.
- Transfer on a Saturday → walkback kicks in → source shows "stooq:approximated" → date shown is prior Friday.
- Pick USD listing `IWDA.L` → FX conversion happens → `fxConverted: true` on the stored lot.
- Disable network → Stooq call fails → manual price entry path works → source is "stooq:manual-fallback".
- Backup roundtrip: export with lots + symbolMap, clear, restore, all data intact.

### Build + integration
- `npm run build` — must pass; catches TDZ regressions from relocated components.
- Dev + preview sanity pass — Equity section renders, Property page shows same fields, existing lots still show under holdings.

## 14. Open questions

1. **Price source default — open or close?** Industry convention is **close**. User originally asked for "market open." Default to close unless user objects — more stable, survives intraday volatility, aligns with EOD datasets.
2. **Equity card order** — Property first or Investments first? Default: Investments first (more active, more frequent interaction).
3. **Current-price refresh cadence** — holdings show current value based on most recent Stooq close. Refresh on every mount? Daily? My default: on mount, one call per symbol (cached in `pf_price_cache` for the session).
4. **openFIGI API key** — free tier is 25/min unauthenticated, 1000/min with a free key. Single user won't hit 25/min. Default: no key for MVP; add `settings.openFigiKey` input if anyone hits the wall.
5. **Stale cache invalidation** — if user refreshes "current price," should we invalidate `pf_price_cache` session-wide or per-symbol? Default: per-symbol, on explicit refresh only.

## 15. Follow-up work (explicitly deferred)

- Recurring-transfer auto-ticker heuristic ("last used IWDA for this amount → suggest IWDA").
- Stock split / spin-off handling.
- Dividend tracking (cash + reinvested).
- Cost basis attribution for tax reporting (FIFO/LIFO/HIFO).
- Realized gains from sell transactions (currently we only track buys).
- Multi-currency net worth display (EUR base hard-coded).
- Benchmark comparison (portfolio vs MSCI World).
