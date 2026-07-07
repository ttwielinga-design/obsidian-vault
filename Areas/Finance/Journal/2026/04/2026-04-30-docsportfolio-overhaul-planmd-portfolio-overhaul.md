---
title: "docs/portfolio-overhaul-plan.md — Portfolio Overhaul Implementation Plan"
date: 2026-04-30
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/software]
status: active
source_file: "3. Personal/Personal Finance/Personal finance dashboard/docs/portfolio-overhaul-plan.md"
source_type: md
confidence: 0.8
imported: 2026-05-14
---

# docs/portfolio-overhaul-plan.md — Portfolio Overhaul Implementation Plan

**Generated:** 2026-04-25
**Based on:** Full read of CLAUDE.md, Dashboard.jsx (3828 lines), HoldingDrawer.jsx, AddHoldingModal.jsx, HoldingsReference.jsx, lots.js, symbolResolver.js, backup.js, defaults.js, finance.js (header), subscriptions.js, priceLookup.js, priceCache.js, and portfolio-overhaul-prd.md.

---

## Section 1 — File Inventory

### Files to CREATE

| File | Phase | Purpose |
|------|-------|---------|
| `src/lib/priceService.js` | 1 | Pure Twelve Data fetch/cache module — `fetchQuotes`, `searchSymbol`, internal `chunk` helper. No React imports. |
| `src/components/InvestmentInboxCard.jsx` | 6 | New component: unreviewed broker transfers listed above HoldingsReference on the Portfolio page. |

### Files to MODIFY

| File | Phase(s) | Line ranges expected to change |
|------|----------|-------------------------------|
| `src/lib/defaults.js` | 2 | Lines 54–91 (`DEF_SETTINGS` object): add `twelveDataApiKey: ''` and `priceCacheTtlMinutes: 60`. Lines 94–101 (`DEF_PORTFOLIO` holding shape): add optional fields `priceUpdatedAt`, `currentPriceCurrency`, `twelveDataSymbol` (doc-comment only — no default value enforced; undefined is fine). Lines 183–239 (`mergeDefaultSettings`): pass through new keys. Lines 142–153 (`normalizePortfolioHolding`): preserve the three new holding fields. |
| `src/lib/backup.js` | 2 | Line 14 (`BACKUP_VERSION = 6` → `7`). Lines 21–38 (`buildBackupPayload`): unchanged payload shape — new holding fields live on portfolio items, not top-level. Lines 41–92 (`restoreBackupState`): add `backup.version === 7` case and v6→v7 migration (default `twelveDataApiKey: ''` if missing from `backup.settings`; default new holding fields to `null`). Line 46 (`> 6` guard): change to `> 7`. Update `CLAUDE.md` Backup Format section. |
| `src/components/AddHoldingModal.jsx` | 3 | Entire file (~242 lines) touched. New `twelveDataApiKey` prop added. Step 1 gains ticker-search debounce logic (350ms). Dropdown now merges OpenFIGI listings with Twelve Data `searchSymbol` results. Step 2 auto-suggests sleeve from `assetClass`. New state vars: `tickerCandidates`, `tickerSearchStatus`. |
| `src/components/HoldingDrawer.jsx` | 3, 4 | Phase 3: new "Re-enrich" link button at top (~line 98–101 area). Phase 4: field reorder (Identity → Classification → Price → Lots summary → Legacy). Legacy `qty`/`avgPrice` wrapped in `<details>`. "Backfill lots" CTA replaces amber warning banner (lines 106–110). "Last updated" row below price field. Inline single-holding "Refresh" icon button (Phase 5 wiring). |
| `src/Dashboard.jsx` | 2, 5, 6 | Phase 2 (~lines 3506–3555): new Settings block for `twelveDataApiKey` + "Test key" button. Phase 5: new `useState` for `refreshState` (lines ~322–343 block); new `useCallback` for `handleRefreshPrices` (after line ~1924); "Refresh prices" button in portfolio JSX (~line 2863–2873 area). Phase 6: import `InvestmentInboxCard`, render above `HoldingsReference` (~line 2853). |
| `CLAUDE.md` | 2 | Backup Format section: bump version comment to 7, add v7 migration entry. Storage Contract table: add `twelveDataApiKey` and new holding fields. |

---

## Section 2 — Phase-by-Phase Insertion Points in `src/Dashboard.jsx`

The file's declaration order (per CLAUDE.md) is:
1. Constants and helpers (lines 1–262)
2. Briefing generators and default data (lines 131–200 embed `DEF_MEMORY`/`DEF_SETTINGS`/`DEF_PORTFOLIO` as local copies — note these are duplicates of what's now in `src/lib/defaults.js`; they are not touched by this overhaul)
3. Component state and persistence effects (lines 265–521)
4. Derived memos (lines 523–1102)
5. Handlers (lines 1153–1924)
6. Render (lines 2005–3828)

### Phase 2 — Settings UI for `twelveDataApiKey`

**New state variable** (none required — the key lives in `settings.twelveDataApiKey`, already covered by the existing `settings` useState at line 297 and persisted by the `useEffect` at line 414)

**New transient UI state** for "Test key" status: insert one `useState` at approximately **line 343** (immediately after `const [showAddHolding, setShowAddHolding] = useState(false)` at line 342, before `const [thirtyDayPrices, ...]` at line 343):
```
const [testKeyState, setTestKeyState] = useState('idle'); // 'idle' | 'ok' | 'error' | 'loading'
```
This respects declaration order — it is a plain `useState`, no dependencies.

**New settings JSX block**: inside the settings panel body, after the Budget Section block (after line 3554, before line 3556 `</div>`). Insert a new `<div>` with title "Twelve Data API" containing a `type="password"` input bound to `settings.twelveDataApiKey` via `setSetting('twelveDataApiKey', val)` — but note that `setSetting` currently coerces to `parseFloat`; a dedicated setter is needed. Insert a helper handler `handleSetTwelveDataKey` as a plain inline callback inside the JSX (or as a named `useCallback` in the handlers block at approximately **line 1924**, after `handleLotModalConfirm`).

**Declaration order check:** The `testKeyState` useState is placed before any memo that could reference it. The `handleSetTwelveDataKey` callback placed at ~line 1924 is after all memos that depend on `settings`, so no TDZ risk.

### Phase 5 — Refresh Prices state and handler

**New state variable** (line ~343, after `testKeyState`):
```
const [priceRefreshState, setPriceRefreshState] = useState({ status: 'idle', rateLimitedUntil: null, updatedCount: 0, totalCount: 0 });
```

**New memo** — none required; `settings.twelveDataApiKey` is directly readable from `settings`.

**New handler** `handleRefreshPrices` — insert at approximately **line 1924** (after `handleLotModalConfirm`, before the `// --- THEME` block at line 1926). The handler:
- Reads `portfolio`, `settings.twelveDataApiKey`, `settings.priceCacheTtlMinutes`
- Calls `fetchQuotes(symbols, apiKey)` from `src/lib/priceService.js`
- On result: calls `setPortfolio(...)` updating `currentPrice`, `priceUpdatedAt`, `currentPriceCurrency` per holding
- Manages `priceRefreshState`

**New handler** `handleRefreshSingleHolding` — insert immediately after `handleRefreshPrices`. Signature: `(holdingId)`.

**Declaration order check:** Both handlers depend on `portfolio`, `settings` (state, declared at lines 297–298) — all declared earlier. No circular references. `fetchQuotes` is a pure module import, not a React hook.

**New JSX** — "Refresh prices" button: inside the portfolio section, in the "Add holding button" `<div>` at approximately **lines 2863–2873**. Change that `<div>` to display both buttons inline (flex row).

### Phase 6 — InvestmentInboxCard

**New import**: add at top of Dashboard.jsx (~line 45 area, after `import AddHoldingModal`):
```js
import InvestmentInboxCard from './components/InvestmentInboxCard.jsx';
```

**No new state**: `brokerCandidates` is already memoized at lines 1567–1571. `handleOpenLotModal` is already defined at line 1747.

**New JSX**: in the portfolio section (line ~2804), insert `<InvestmentInboxCard />` between the Plan bar (ends ~line 2830) and the Summary header card (starts ~line 2832). Per the CLAUDE.md IA ordering: Plan bar → Inbox → Summary → Holdings.

**Declaration order check:** No new state or memos. Only a new JSX reference to existing `brokerCandidates` and `handleOpenLotModal` — both already declared before the render block.

---

## Section 3 — OpenFIGI Cache Audit

**Cache storage key:** `symbolResolver.js` uses a dedicated key `'pf_symbol_map'` (line 3 of symbolResolver.js), NOT `pf_settings.symbolMap`. This is a completely separate localStorage entry from the `symbolMap` state in `Dashboard.jsx`.

**Cache shape:**
```js
{
  [normalizedIsin: string]: {
    fetchedAt: number,           // epoch ms
    expiresAt: number,           // fetchedAt + 30 days in ms
    value: {
      isin: string,
      name: string,
      listings: Array<{
        figi, compositeFigi, shareClassFigi,
        ticker, name, exchange, micCode,
        securityType, securityType2,
        marketSector, securityDescription
      }>
    }
  }
}
```

**TTL:** 30 days (`30 * 24 * 60 * 60 * 1000` ms), enforced on read via `cachedEntry.expiresAt > Date.now()`.

**Is it reading/writing `pf_settings.symbolMap`?** No. It reads/writes its own key `pf_symbol_map` via `lsGet`/`lsSet`. However, `Dashboard.jsx` maintains a parallel `symbolMap` React state (line 322: `const [symbolMap, setSymbolMap] = useState(() => lsGet('pf_symbol_map', {}))`) and syncs it via a persistence `useEffect` at line 419 (`lsSet('pf_symbol_map', symbolMap)`). The `symbolMap` React state is also included in backup export (`handleExportData` at line 1387 and `buildBackupPayload` in `backup.js` line 37).

**Implication for Phase 3:** The `resolveIsin` function from `symbolResolver.js` is self-caching in localStorage. No additional caching layer needed for OpenFIGI lookups. The PRD's reference to "cache results in `pf_settings.symbolMap`" is slightly misleading — the cache lives at `pf_symbol_map` (standalone key), not nested inside `pf_settings`. Do not move it; the current structure works and backup/restore already handles it.

---

## Section 4 — `detectBrokerTransfers` Audit

**Definition location:** `src/lib/lots.js`, lines 76–103. Exported pure function (not a hook).

**Memoized in Dashboard.jsx:** Lines 1567–1571:
```js
const brokerCandidates = useMemo(() => {
  const brokerIbans = settings?.autoInvest?.brokerIbans ?? [];
  if (!brokerIbans.length) return [];
  return detectBrokerTransfers(allCategorizedTxs, brokerIbans, lotLinks);
}, [allCategorizedTxs, settings?.autoInvest?.brokerIbans, lotLinks]);
```

**Shape of items returned:**
```js
{
  key: string,          // `${monthKey}|${tx.id ?? idx}` or row.key
  monthKey: string,     // e.g. '2026-02'
  date: string,         // YYYY-MM-DD
  amountEUR: number,    // positive (Math.abs of the negative tx amount)
  name: string,         // counterparty name
  iban: string,         // normalized broker IBAN (uppercase, no spaces)
  txRef: object,        // the original row object from allCategorizedTxs
}
```

**Existing ledger-confirm UI:**
- Component: `LedgerMonthBlock` (rendered at lines 2987–3001 inside the Investment Ledger card)
- Primary handler: `handleConfirmLedgerMonth` (lines 1592–1605) — takes `(month, transfer, rows)`, calls `createLedgerConfirmLots` from `ledgerConfirm.js`, then `setLots` + `setLotLinks`
- Secondary handler for unreviewed orphan transfers (not in `ledgerMonths`): `handleOpenLotModal` (lines 1747–1767) — opens the lot modal for a candidate
- Dismiss handler: `handleDismissCandidate` (lines 1627–1632)
- The `handleOpenLotModal` is the right entry point for `InvestmentInboxCard`'s "Link to holding…" button, since `brokerCandidates` items are in the same shape as the `candidate` param that `handleOpenLotModal` expects

---

## Section 5 — HoldingDrawer Current Field Order

Fields rendered in `HoldingDrawer.jsx` in current order (lines 104–169):

1. Amber warning banner (shown only when `!hasLots`, lines 106–110)
2. **Ticker** (text input, line 113–115)
3. **Name** (text input, line 118–120)
4. **ISIN** (text input, monospace, lines 123–125)
5. **Exchange** (text input, lines 128–130)
6. **Currency** (text input, lines 133–135)
7. **Current Price (€)** (number input, lines 138–140)
8. **Sleeve** (select, lines 143–151)
9. **TER (%)** (number input, lines 154–156)
10. **Qty (legacy)** (number input, shown only `!hasLots`, lines 159–162)
11. **Avg Price (legacy, €)** (number input, shown only `!hasLots`, lines 163–167)

**Phase 4 target order:**
1. Re-enrich button (new — Phase 3)
2. **Ticker**
3. **Name**
4. **ISIN**
5. **Exchange**
6. **Currency**
7. **Sleeve**
8. **TER (%)**
9. **Current Price (€)** with "Last updated X ago" timestamp and inline Refresh button (Phase 5)
10. **Lots summary** (read-only: effective qty, effective avg price — new, Phase 4)
11. **"Backfill lots" CTA** (shown when `!hasLots` — replaces amber warning, Phase 4)
12. **Legacy fields** (`<details>` collapsed by default, shown only when `!hasLots`):
    - Qty (legacy)
    - Avg Price (legacy, €)

---

## Section 6 — Backup Version Audit

**Current backup version:** `BACKUP_VERSION = 6` (backup.js line 14).

**Current restore guard:** `if (backup.version < 1 || backup.version > 6)` (backup.js line 46) — must be changed to `> 7`.

**Current migration chain in `restoreBackupState`:**
- v1: recomputes history
- v2: defaults `lots`, `lotLinks`, `symbolMap` to `{}`
- v3: restores `lots` + `lotLinks`
- v4: defaults missing `symbolMap` to `{}`
- v5: restores `symbolMap` directly
- v6: v5→v6 defaults three `autoInvest` fields if missing (`autoFromMonth`, `manualMonths`, `autoConfirmTolerance`) — implemented implicitly through `mergeDefaultSettings`

**v6→v7 migration requirements (Phase 2):**
1. In `restoreBackupState`: after all current logic, if `backup.version < 7`, apply:
   - `settings.twelveDataApiKey = backup.settings?.twelveDataApiKey ?? ''`
   - `settings.priceCacheTtlMinutes = backup.settings?.priceCacheTtlMinutes ?? 60`
   - For each holding in `portfolio`: default `priceUpdatedAt: null`, `currentPriceCurrency: null`, `twelveDataSymbol: null` if absent
2. Since `mergeDefaultSettings` is always called during restore, the new settings fields will auto-default if added to `DEF_SETTINGS` in `defaults.js`. No explicit v6→v7 conditional block is required for the settings fields.
3. The holding-level new fields are optional. `normalizePortfolioHolding` uses spread (`...holding`) so they pass through from backup data. Defensive reads as `holding.priceUpdatedAt ?? null` are sufficient.
4. In `buildBackupPayload`: bump version to 7. The `portfolio` array is already spread as-is, so new holding fields will be included automatically once set.

**CLAUDE.md update required (Phase 2):**
- Backup Format block: change `version: 6` to `version: 7`, add v7 migration entry
- Storage Contract table: add row for `pf_settings.twelveDataApiKey`, note optional holding fields

---

## Section 7 — Risk Flags

### Declaration-order risks in Dashboard.jsx

**Risk 1 (High) — `setSetting` coerces to `parseFloat`.**
The current `setSetting` helper coerces all values to `parseFloat(val) || 0`. Adding `twelveDataApiKey` requires either (a) a dedicated setter or (b) extending the string-key whitelist inside `setSetting`. A dedicated inline handler is safer.

**Risk 2 (Medium) — `handleRefreshPrices` dependency on `portfolio`.**
`handleRefreshPrices` will call `setPortfolio` with a derived update. Its `useCallback` dependency array must include `portfolio` and `settings`. These are both state variables declared at lines 297–298, well before any handlers. No TDZ risk. `fetchQuotes` must be imported at the top of the file (line ~59 area), not inside the callback.

**Risk 3 (Low) — `priceRefreshState` useState must precede any memo that reads it.**
If the render block checks `priceRefreshState.status` to conditionally disable the button, this is pure JSX (in the render section) — no memo depends on it. Safe at any position in the state block.

**Risk 4 (Low) — `InvestmentInboxCard` renders `handleOpenLotModal`.**
`handleOpenLotModal` is declared at line 1747, well before the render block at line 2005. Safe.

**Risk 5 (Low) — `testKeyState` useState.**
No memo references it, so placement at line ~343 is fine.

### State shape differences from PRD assumptions

**Finding 1:** `pf_settings.symbolMap` in the PRD refers to the `pf_symbol_map` standalone localStorage key, not a nested key inside settings. Leave the cache location unchanged.

**Finding 2:** `pf_settings.priceCache` mentioned in the PRD refers to TTL config (`priceCacheTtlMinutes`). The `pf_price_cache` sessionStorage key used by the existing `priceCache.js` is for Stooq lot prices, not Twelve Data. Create a separate in-memory cache within `priceService.js`.

**Finding 3:** `EMPTY_HOLDING` at Dashboard.jsx line 121 does not include new fields. Handled correctly by defensive reads (`holding.priceUpdatedAt ?? null`).

**Finding 4:** `DEF_SETTINGS` is duplicated in `Dashboard.jsx` (lines 157–190) AND in `src/lib/defaults.js`. Update only `src/lib/defaults.js`. The stale Dashboard.jsx copy is a latent hazard but out of scope for this PRD.

### Missing files referenced by the PRD

- `src/lib/priceService.js` — must be CREATED in Phase 1
- `src/components/InvestmentInboxCard.jsx` — must be CREATED in Phase 6
- `docs/portfolio-overhaul-test-report.md` — created by the Test Agent in Phase 7
