---
title: "Portfolio Redesign — Phase 0 Implementation Plan"
date: 2026-04-24
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/software]
status: active
source_file: "3. Personal/Personal Finance/Personal finance dashboard/docs/portfolio-redesign-implementation-plan.md"
source_type: md
confidence: 0.8
imported: 2026-05-14
---

# Portfolio Redesign — Phase 0 Implementation Plan

**PRD:** `docs/prd-portfolio-redesign.md` (Draft v1, 2026-04-23)
**Status:** Phase 0 (research & planning) — awaiting user acknowledgement
**Scope of this doc:** Surface misunderstandings before Phase 1 starts. No source edits made.

---

## 1. Write touch-points for `pf_lots` / `pf_lot_links` / `pf_settings.autoInvest`

All `setLots` / `setLotLinks` / `setSettings(autoInvest…)` call sites found by grep on 2026-04-24. Line numbers from the working tree at branch `main` (commit `76639b0`).

### 1.1 `pf_lots` writers (`setLots`)

| Loc | Call site | Purpose | Phase interaction |
|---|---|---|---|
| [Dashboard.jsx:241](src/Dashboard.jsx:241) | `useState(() => lsGet('pf_lots', {}))` | Initial hydrate from localStorage | none |
| [Dashboard.jsx:312](src/Dashboard.jsx:312) | `setLots(autoInvestUpdate.lotsByHolding ?? lots)` in the `applyAutoInvest` side-effect | Synthetic auto-invest lots when no transfer yet | Phase 4 req 3 must preserve — `reconcileAutoInvestOnMonthReplace` swaps these for real lots on CSV import |
| [Dashboard.jsx:337](src/Dashboard.jsx:337) | `useEffect(() => { lsSet('pf_lots', lots); }, [lots])` | Persistence effect | none |
| [Dashboard.jsx:1148](src/Dashboard.jsx:1148) | `setLots(autoInvestReconciled.lotsByHolding ?? replacementReconciled.lotsByHolding)` inside `handleConfirmUpload` | CSV-upload reconciliation path (where `reconcileAutoInvestOnMonthReplace` lands) | Phase 4 req 3 hooks here — must wrap an `applyAutoConfirm` call alongside `reconcileAutoInvestOnMonthReplace` without double-writing |
| [Dashboard.jsx:1336](src/Dashboard.jsx:1336) | `setLots(restored.lots ?? {})` in backup-restore handler | Restore from backup | Phase 1: v6 restore returns the same `lots` shape — no change needed here |
| [Dashboard.jsx:1525](src/Dashboard.jsx:1525) | `setLots(lotsUpdate)` in `handleAllocateCandidate` | Legacy 6× `window.prompt` flow | **Phase 3 retires this**. New `handleConfirmLedgerMonth` replaces it |
| [Dashboard.jsx:1537](src/Dashboard.jsx:1537) | `setLots(prev => ({ …, [holdingId]: filter(l.id !== lotId) }))` in `handleDeleteLot` | Single-lot delete | Phase 4 req 4 ("uncheck auto") likely reuses this to clear auto lots |
| [Dashboard.jsx:1723](src/Dashboard.jsx:1723) | `setLots(prev => ({ …, [holding.id]: [...prev, newLot] }))` in lot-modal save (`handleOpenLotModal` flow) | Single-row lot add from the manual lot modal | Phase 6 eventually removes the old holdings table; the lot modal itself (sources `manual`, `manual-fallback`, `stooq`) is orthogonal to the ledger and stays for now |

### 1.2 `pf_lot_links` writers (`setLotLinks`)

| Loc | Call site | Purpose | Phase interaction |
|---|---|---|---|
| [Dashboard.jsx:242](src/Dashboard.jsx:242) | `useState(() => lsGet('pf_lot_links', {}))` | Initial hydrate | none |
| [Dashboard.jsx:338](src/Dashboard.jsx:338) | `useEffect(() => lsSet('pf_lot_links', lotLinks), [lotLinks])` | Persistence effect | none |
| [Dashboard.jsx:1147](src/Dashboard.jsx:1147) | `setLotLinks(replacementReconciled.lotLinks)` in CSV upload reconciliation | Replace-month rebuild of links | Phase 4 req 3 hooks here |
| [Dashboard.jsx:1337](src/Dashboard.jsx:1337) | `setLotLinks(restored.lotLinks ?? {})` on restore | Restore from backup | none |
| [Dashboard.jsx:1526](src/Dashboard.jsx:1526) | `setLotLinks(prev => ({ …, [candidate.key]: createdLotIds }))` end of `handleAllocateCandidate` | Legacy allocate | **Phase 3 retires** |
| [Dashboard.jsx:1533](src/Dashboard.jsx:1533) | `setLotLinks(prev => ({ …, [candidate.key]: prev[candidate.key] ?? [] }))` in `handleDismissCandidate` | Empty-array marker = reviewed/suppressed | Phase 5 backfill reuses this exact convention (PRD §7 req 2) |
| [Dashboard.jsx:1538](src/Dashboard.jsx:1538) | `setLotLinks(prev => …)` filter inside `handleDeleteLot` | Remove lot id from every link list | Phase 4 req 4 reuses for "uncheck auto" |
| [Dashboard.jsx:1724](src/Dashboard.jsx:1724) | `setLotLinks(prev => ({ …, [candidate.key]: [lotId] }))` end of manual lot-modal save | Single-lot link | untouched by this PRD |

### 1.3 `pf_settings.autoInvest` writers (`setSettings` on autoInvest subtree)

| Loc | Call site | Purpose | Phase interaction |
|---|---|---|---|
| [Dashboard.jsx:313](src/Dashboard.jsx:313) | `setSettings(autoInvestUpdate.settings)` after `applyAutoInvest` | Bumps `lastExecutedMonth` | stays |
| [Dashboard.jsx:1151](src/Dashboard.jsx:1151) | `setSettings(autoInvestReconciled.settings)` after reconcile | Reset `lastExecutedMonth` when a prior month is replaced | stays |
| [Dashboard.jsx:1327](src/Dashboard.jsx:1327) | `setSettings(restored.settings)` restore | Backup restore — v6 migration lands here via `restoreBackupState` | **Phase 1** |
| [Dashboard.jsx:1414](src/Dashboard.jsx:1414) | `setSetting(key, val)` generic helper | Used by Settings pane | stays |
| [Dashboard.jsx:1419](src/Dashboard.jsx:1419) | `setAutoInvestEnabled` | Settings toggle | Phase 4 req 6: Settings panel replaced by redirect |
| [Dashboard.jsx:1427](src/Dashboard.jsx:1427) | `setAutoInvestAmount` | Settings amount input | Phase 4 req 6 |
| [Dashboard.jsx:1435](src/Dashboard.jsx:1435) | `setAutoInvestAllocationWeight` | Settings weight sliders | Phase 4 req 6 |
| [Dashboard.jsx:2628](src/Dashboard.jsx:2628) | inline `onChange` on broker IBANs editor | Currently inside Settings pane — moves to Plan modal in Phase 1 |
| [Dashboard.jsx:3464-3534](src/Dashboard.jsx:3464) | Settings auto-invest panel render block | The whole panel — **deleted in Phase 4** |
| [lib/defaults.js:82](src/lib/defaults.js:82) | `DEF_SETTINGS.autoInvest` | **Phase 1 req 1**: add `autoFromMonth`, `manualMonths`, `autoConfirmTolerance` |
| [lib/defaults.js:228-233](src/lib/defaults.js:228) | `mergeDefaultSettings` autoInvest merge | Must keep the new fields through the deep-merge (spread order already correct) |
| [lib/backup.js:14](src/lib/backup.js:14) | `BACKUP_VERSION = 5` | **Phase 1 req 2**: bump to 6 |
| [lib/backup.js:46](src/lib/backup.js:46) | `if (backup.version < 1 \|\| backup.version > 5)` guard | Widen to `> 6` |
| [lib/finance.js:275-533](src/lib/finance.js:275) | `getAutoInvestPlannedAmount`, `applyAutoInvest`, `reconcileAutoInvestOnMonthReplace` | Read-only for the new fields in Phase 1; `applyAutoInvest` untouched. Phase 4 adds a sibling `applyAutoConfirm` — keep in its own module (`src/lib/autoInvest.js`) per PRD §Phase 4 req 1 to avoid bloating `finance.js` |

### 1.4 Lot `source` field — current vs. PRD vocabulary (flagged risk)

The PRD introduces three new `source` values (`'inbox'`, `'auto'`, `'backfill'`). Current writers use `'csv'`, `'manual'`, `'manual-fallback'`, `'stooq'`, `'auto-invest'`. The ledger status derivation in `useLedger` (Phase 2 req 1) keys on `source: 'backfill'` and `source: 'auto-invest'` — i.e. it consumes the **existing** `auto-invest` tag, not a new `auto` tag. The PRD text in §Phase 3 req 2 says new confirm lots use `source: 'inbox'`; §Phase 4 req 2 says auto-confirm uses `source: 'auto'`.

**Decision for Phase 1:** no changes to `source` values. Phase 2 reads both `'auto-invest'` and (eventually) `'auto'` as the auto family. Phase 3 introduces `'inbox'`. Phase 4 introduces `'auto'`. No migration of existing rows — old `'csv'`/`'manual'` lots continue to render as `confirmed` once their `pf_lot_links` entry is non-empty.

---

## 2. Declaration-order audit for new `Dashboard.jsx` additions

`src/Dashboard.jsx` is order-sensitive (see `CLAUDE.md` → "Declaration-order pitfalls"). Every `useMemo`/`useCallback` dep-array reference is evaluated eagerly at hook call time. Any forward reference is a TDZ `ReferenceError` that renders as a blank white page in prod.

### Planned new declarations (by phase) and their required position

The existing layout in `Dashboard.jsx` is:

1. Constants/helpers (top)
2. `DEF_SETTINGS`, `DEF_PORTFOLIO` (≈160–185)
3. Component state (190–250)
4. Persistence effects (330–340)
5. `applyAutoInvest` side-effect (300–315)
6. Derived memos — `allCategorizedTxs`, `autoInvestPlannedAmount`, etc. (500–700)
7. Handlers — `handleConfirmUpload`, `handleAllocateCandidate`, `handleDismissCandidate`, `handleDeleteLot`, lot modal handlers (1100–1730)
8. Theme / render (1730+)

### Phase 1 additions

| New symbol | Kind | Deps | Required position | Hazard? |
|---|---|---|---|---|
| — | Plan bar is its own component in `src/components/PlanBar.jsx`; mounts in the render. No new dashboard-level memos. | — | — | no |
| `handleSaveAutoInvest(next)` | `useCallback` | `[]` (calls `setSettings` only) | Anywhere before render | no |

### Phase 2 additions

| New symbol | Kind | Deps | Required position | Hazard? |
|---|---|---|---|---|
| `ledgerMonths` | `useMemo` via `useLedger()` hook | `months`, `lots`, `lotLinks`, `settings.autoInvest`, `portfolio` — all plain state | After state block (safe — all deps are `useState` setters declared at 190–250) | no |

Because `useLedger` is a pure hook defined in `src/hooks/useLedger.js`, it contains its own `useMemo`. Call site inside Dashboard must appear **after** the five inputs are declared, which they are. No forward refs.

### Phase 3 additions

| New symbol | Kind | Deps | Required position | Hazard? |
|---|---|---|---|---|
| `handleConfirmLedgerMonth` | `useCallback` | `[lots, portfolio, settings?.autoInvest?.allocations]` (same as `handleAllocateCandidate`) | Place **next to** `handleAllocateCandidate` at ≈1483, not lower | no — deps already declared above |

### Phase 4 additions

| New symbol | Kind | Deps | Required position | Hazard? |
|---|---|---|---|---|
| `applyAutoConfirm` | pure fn in `src/lib/autoInvest.js` | — | n/a | n/a |
| `autoConfirmEffect` | `useEffect` | `[months, lots, lotLinks, settings.autoInvest, portfolio]` + `handleConfirmLedgerMonth` | **After** `handleConfirmLedgerMonth` (see Phase 3) | **Yes if placed too early** — must appear after the handler it invokes. Mitigation: put this effect immediately below the handler definition |
| `handleUncheckAutoMonth` | `useCallback` | `[settings.autoInvest?.manualMonths, lotLinks, lots]` | Near `handleDeleteLot` | no |

### Phase 5 additions

| New symbol | Kind | Deps | Required position | Hazard? |
|---|---|---|---|---|
| `handleBackfillImport(rows, reconciled)` | `useCallback` | `[portfolio, allCategorizedTxs, settings?.autoInvest?.brokerIbans]` | After `allCategorizedTxs` and `brokerTransferCandidates` | no |

### Summary

No TDZ hazards identified for Phase 1. The one risky spot is Phase 4's `autoConfirmEffect` — it must be declared **after** `handleConfirmLedgerMonth`, which is itself introduced in Phase 3. The implementation rule is to co-locate each new handler with its sibling (`handleConfirmLedgerMonth` next to `handleAllocateCandidate`, the effect next to it) rather than grouping new code at the bottom of the component.

---

## 3. `LedgerMonth` shape (derived, not stored)

TypeScript-style sketch for the output of `useLedger()` consumed by `LedgerMonthBlock`. Matches PRD §Phase 2 req 1 exactly; field names below are the canonical ones Phase 2 implements.

```ts
type LedgerStatus =
  | 'needs_review'   // transfer exists, no lot link
  | 'auto'           // source: 'auto' | 'auto-invest', no link yet (synthetic)
  | 'confirmed'      // linked, every lot has a price
  | 'partial'        // linked but a lot is missing a price
  | 'historical';    // any lot source === 'backfill'

interface LedgerTransfer {
  txKey: string;        // `${monthKey}|${txIndex}` or tx.id
  date: string;         // YYYY-MM-DD
  amount: number;       // EUR, positive magnitude of outgoing transfer
  counterparty: string; // display name from tx
}

interface LedgerLotRow {
  holdingId: number;
  ticker: string;
  lot: {
    id: string;
    date: string;
    qty: number;
    pricePerShare: number | null;
    amountEUR: number;
    source: 'csv' | 'manual' | 'manual-fallback' | 'stooq' | 'auto-invest' | 'inbox' | 'auto' | 'backfill';
    txId: string | null;
  };
}

interface LedgerMonth {
  month: string;                // "YYYY-MM"
  transfers: LedgerTransfer[];  // 0..n outgoing broker-IBAN transfers in that month
  lots: LedgerLotRow[];         // every lot dated in `month`, sorted by holdingId, then date
  status: LedgerStatus;         // derived per §Phase 2 req 1 rules
  planAmount: number;           // getAutoInvestPlannedAmount(settings.autoInvest) at render time
  planDelta: number;            // sum(transfers.amount) - planAmount (0 if no transfer)
}
```

### Status precedence (tie-breakers)

When multiple signals fire in the same month:

1. `historical` wins outright (any `source === 'backfill'` lot).
2. Else if transfers exist and any transfer has an empty-array link (dismissed) or no link AND there are no lots → `needs_review`.
3. Else if all transfers have non-empty links AND every linked lot has `pricePerShare > 0` → `confirmed`.
4. Else if all transfers have non-empty links AND any linked lot has missing/zero price → `partial`.
5. Else if synthetic auto-invest lots exist (`source === 'auto'` or `'auto-invest'`) and no real transfer has landed → `auto`.

Ambiguity case the PRD doesn't spell out: a month with both a backfill lot *and* a pending transfer. Precedence #1 wins — month shows `historical` and the transfer is treated as reviewed via the PRD §Phase 5 req 2 empty-array link.

---

## 4. Backup migration test cases

These land in `src/lib/backup.test.js` in Phase 1 req 3. Each case feeds a fixture through `restoreBackupState` and asserts the `autoInvest` shape.

### 4.1 v1 → v6 restore

Input fixture (minimum viable v1):

```js
{
  version: 1,
  months: { '2024-05': [/* tx… */] },
  settings: {
    // v1 predates autoInvest entirely
    netWorthGoal: 300000,
    ownIbans: [],
  },
  portfolio: [],
  rules: [],
  memory: {},
  overrides: {},
}
```

Expected after `restoreBackupState`:

- `settings.autoInvest.enabled === false`
- `settings.autoInvest.amount === 0`
- `settings.autoInvest.allocations.length === 0`
- `settings.autoInvest.lastExecutedMonth === null`
- `settings.autoInvest.brokerIbans` is an array (length 0)
- `settings.autoInvest.autoFromMonth === '2026-03'` ← new
- `settings.autoInvest.manualMonths` deep-equals `[]` ← new
- `settings.autoInvest.autoConfirmTolerance === 1` ← new (PRD §10 resolved decision)
- `lots === {}` (v1 lacks lots; v2-guard on line 58 of backup.js is `version >= 3`, so v1 lots default to `{}`)
- `lotLinks === {}`
- `networthHistory` is recomputed (v1 always triggers `shouldRecomputeHistory`)

### 4.2 v3 → v6 restore

Input fixture (v3 carries lots/lotLinks but no symbolMap and no new autoInvest fields):

```js
{
  version: 3,
  historyVersion: NETWORTH_HISTORY_VERSION,
  months: { '2026-01': [] },
  settings: {
    autoInvest: {
      enabled: true,
      amount: 1000,
      allocations: [{ holdingId: 1, ticker: 'VWCE', weight: 0.25 }],
      lastExecutedMonth: '2026-01',
      brokerIbans: ['NL91ABNA0417164300'],
    },
  },
  lots: { 1: [{ id: 'l-1', date: '2026-01-05', qty: 1, pricePerShare: 100, amountEUR: 100, source: 'csv' }] },
  lotLinks: { '2026-01|0': ['l-1'] },
  networthHistory: [],
}
```

Expected:

- `settings.autoInvest.enabled === true` (preserved)
- `settings.autoInvest.amount === 1000` (preserved)
- `settings.autoInvest.allocations` deep-equals the v3 input (preserved)
- `settings.autoInvest.lastExecutedMonth === '2026-01'` (preserved)
- `settings.autoInvest.brokerIbans` deep-equals `['NL91ABNA0417164300']` (preserved)
- `settings.autoInvest.autoFromMonth === '2026-03'` ← defaulted
- `settings.autoInvest.manualMonths` deep-equals `[]` ← defaulted
- `settings.autoInvest.autoConfirmTolerance === 1` ← defaulted
- `lots` and `lotLinks` preserved verbatim (v3 stored them)
- `symbolMap === {}` (v3 lacks it; current guard on backup.js:60 defaults it)

### 4.3 v5 → v6 restore

Input fixture: current production backup shape (v5) with all fields populated.

Expected: identical to §4.2 outcomes for `settings.autoInvest.auto*` / `manualMonths`, plus `symbolMap` preserved, `lots`/`lotLinks` preserved. Round-trip: `buildBackupPayload(restoreBackupState(v5Input))` must emit `version: 6`, and a subsequent `restoreBackupState` of that output must round-trip the three new fields verbatim.

### 4.4 v6 → v6 round-trip (must also exist in the test file)

Input: a v6 payload with `autoFromMonth: '2024-12'`, `manualMonths: ['2025-03']`, `autoConfirmTolerance: 2.5`.
Expected: all three values preserved verbatim; no defaults applied.

### 4.5 Negative case — version 7 rejected

Input: `{ version: 7, months: {} }`. Expected: `restoreBackupState` throws `"Unsupported backup version: 7"`. Tests the updated `< 1 || > 6` guard.

---

## 5. Risk log

| # | Risk | Blocks phase | Mitigation |
|---|---|---|---|
| R1 | `autoConfirmTolerance` default. PRD §6 table says `0`; PRD §10 says `1 EUR`. Phase 1 req 1 says `0`. | Phase 1 | Follow §10 (resolved decision) — default to `1`. Note the inconsistency in the PR description when Phase 1 lands and ask user to confirm. |
| R2 | Existing lot `source` values (`csv`, `manual`, `auto-invest`) do not include the new `inbox`/`auto`/`backfill` tags referenced by the PRD. | Phase 2, 3, 4, 5 | `useLedger` treats `auto-invest` and `auto` as synonyms for the `auto` family; `csv`/`manual` lots with a non-empty link render as `confirmed`. No back-migration of existing rows needed. Documented in §1.4 above. |
| R3 | `applyAutoInvest` writes `source: 'auto-invest'` today; Phase 4 wants a cleaner `source: 'auto'`. If we write both, two different auto tags coexist. | Phase 4 | Leave `applyAutoInvest` on `'auto-invest'` (stays for mid-month NW estimates per Phase 4 non-goal). `applyAutoConfirm` writes `'auto'`. Ledger accepts both for status derivation. |
| R4 | `handleConfirmUpload` in Dashboard.jsx:1139-1151 already mutates `lots`, `lotLinks`, `months`, `portfolio`, `settings` in one batch. Phase 4's auto-confirm wedges another write into the same transaction. | Phase 4 | Extend `reconcileAutoInvestOnMonthReplace` output (or chain `applyAutoConfirm` on top of it) to produce a single state snapshot. No extra render in between. |
| R5 | PRD §Phase 3 req 1 pre-fill math uses weights *that may not sum to 1* (PlanEditModal validates 100±0.01, but legacy `autoInvest.allocations` in storage may not). | Phase 3 | Normalize weights inside `allocateToLots` (already does — uses `weightTotal`). Phase 1 modal save-validation prevents new invalid writes. Existing bad data is auto-normalized on read. |
| R6 | Ledger rendering on years of data may lag if all month blocks are expanded. | Phase 2 | `useLedger` memoizes on the five inputs. PRD §11 explicitly defers virtualization to >60 months. Acceptable. |
| R7 | `pf_lot_links[txKey] = []` is a dual-purpose sentinel (dismissed by user OR backfill-suppressed). Phase 5 reuses the convention. Ledger status derivation must not mistake a dismissed transfer for a reviewed-historical one. | Phase 2, 5 | The `historical` status keys on `lot.source === 'backfill'`, not on the empty-array marker. An empty-array with no backfill lots still renders the transfer row but with a "dismissed" chip (outside the 5 PRD statuses — deferred; not blocking). |
| R8 | `currentDate` context says 2026-04-24, which is already past the `autoFromMonth: 2026-03` default. First Phase-4 ship will immediately auto-confirm March and April. | Phase 4 | Expected behavior. If user wants a quieter rollout, set `manualMonths: ['2026-03', '2026-04']` before merging Phase 4. Flag in Phase 4 PR. |
| R9 | Deleting the Settings auto-invest panel (Phase 4 req 6) removes the only place broker IBANs are currently edited. If the Plan modal isn't shipped first, the user is stuck. | Phase 4 | Non-issue — Phase 4 depends on Phase 3 which depends on Phase 1 (PlanEditModal). Ordering enforced by phase gates. |
| R10 | Phase 1 ships `autoFromMonth` / `manualMonths` / `autoConfirmTolerance` in `autoInvest` but no code *reads* them yet. A user downgrades by restoring a v5 backup from a v6 install. | Phase 1 | One-way migration (v5→v6 is silent add-defaults; a v6 backup cannot be read by a pre-Phase-1 build — PRD §9 documents this). User acceptable. |
| R11 | `buildBackupPayload` writes `settings` verbatim from state. If Phase 1 req 1 runs but `mergeDefaultSettings` isn't called on save, the new fields might be missing from freshly-created settings. | Phase 1 | `mergeDefaultSettings` already runs on the initial `useState` hydrate (Dashboard.jsx:221) and on restore (backup.js:53). `DEF_SETTINGS.autoInvest` gaining the three fields (Phase 1 req 1) propagates automatically. Verified via `defaults.test.js` — extend that test. |

---

## 6. Open questions for the user (before Phase 1)

1. **R1 — `autoConfirmTolerance` default:** ship as `1` EUR (follow §10) or `0` (follow §Phase 1 req 1 text)? Recommend `1`.
2. **R8 — immediate auto-confirm on first Phase-4 release:** do you want a grace list (`manualMonths: ['2026-03', '2026-04']`) seeded on upgrade, or let auto-confirm fire on whatever CSV is already loaded?
3. **Source-tag policy (R2/R3):** OK to leave existing `'csv'`/`'manual'`/`'auto-invest'` rows untouched forever, with `'inbox'`/`'auto'`/`'backfill'` only appearing on new writes? This means the ledger cannot retroactively distinguish "historical backfill" from a pre-existing manual lot unless the user re-imports via Phase 5.

---

## 7. Phase 0 done checklist

- [x] Write touch-points enumerated with line numbers (§1)
- [x] Declaration-order audit covers every new memo/effect/callback through Phase 5 (§2)
- [x] `LedgerMonth` shape frozen (§3)
- [x] Migration test cases for v1, v3, v5, v6 documented (§4)
- [x] Risk log with 11 items and their phase gates (§5)
- [ ] **User acknowledgement of this plan** (required before Phase 1 starts)
