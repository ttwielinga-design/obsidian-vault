---
title: "Data Contracts"
date: 2026-05-07
source_file: "3. Personal\Personal Finance\Personal finance dashboard\docs\data-contracts.md"
source_type: md
tags: [work, contract]
area: Areas
status: active
confidence: 0.8
imported: 2026-05-14
---

# Data Contracts

Concise reference for the repo's browser-local data shapes.

## Transaction Object

Transactions are parsed from CSV into objects with these fields:

```js
{
  id: string,
  date: string,
  cIBAN: string,
  cName: string,
  iName: string,
  code: string,
  amount: number,
  balance: number,
  desc: string,
  descPrefix: string
}
```

`descPrefix` is a normalized prefix derived from `desc` and used by saved rules.

## Saved Rule

Saved auto-categorization rules are stored as:

```js
{
  id: string,
  matchType: 'counterparty_name' | 'counterparty_iban' | 'description_prefix',
  matchValue: string,
  category: string,
  createdAt: string
}
```

## localStorage Keys

- `pf_months`: uploaded transactions, grouped by `YYYY-MM`
- `pf_rules`: saved categorization rules
- `pf_memory`: learned IBAN and counterparty-name mappings
- `pf_overrides`: manual per-transaction overrides
- `pf_settings`: dashboard settings and budgets
- `pf_portfolio`: portfolio holdings
- `pf_networth_history`: monthly net worth snapshots
- `pf_csvName`: last imported CSV filename
- `pf_view_mode`: cash flow view mode (`monthly`, `ytd`, or `yoy`)
- `pf_lots`: lot-level investment tracking by holding
- `pf_lot_links`: legacy reviewed broker-transfer to lot linkage map; current backup v9 does not write or restore it
- `pf_symbol_map`: OpenFIGI ISIN lookup cache used by `src/lib/symbolResolver.js`; current backup v9 does not write or restore it
- `pf_txs`: legacy alias for the selected month's raw transactions

## Portfolio Holding

Portfolio holdings in `pf_portfolio` and backups are stored as objects. The default holdings live in `src/lib/defaults.js`.

```js
{
  id: number | string,
  ticker: string,
  name: string,
  isin: string,
  qty: number,
  avgPrice: number,
  currentPrice: number,
  exchange: string,
  assetClass: string,
  sleeve: 'equity' | 'real_assets' | '',
  targetWeight: number,
  ter: number,
  priceUpdatedAt?: string,
  currentPriceCurrency?: string,
  priceSymbol?: string
}
```

`targetWeight` and `ter` are stored as decimals (`0.25` means 25%). Restore/default merging normalizes legacy percentage-style values between `1` and `100` into decimals and backfills missing default-holding metadata by `id`, `isin`, or `ticker`.

## Backup JSON

`handleExportData()` now writes backup format `version: 9` via `buildBackupPayload()`:

```js
{
  version: 9,
  historyVersion: NETWORTH_HISTORY_VERSION,
  exportedAt: string,
  months: Record<string, Transaction[]>,
  settings: object,
  portfolio: Array<object>,
  rules: SavedRule[],
  memory: object,
  overrides: Record<string, string>,
  networthHistory: NetWorthHistoryEntry[],
  csvName: string,
  viewMode: 'monthly' | 'ytd' | 'yoy',
  lots: Record<string, Array<object>>
}
```

`settings.autoInvest` is normalized to:

```js
{
  brokerIbans: string[]
}
```

`settings.brokerCashAdjustment` is a number stored on `settings` and defaults to `0`.

Restore accepts backup `version`s `1` through `9`.

- `v9` is the current schema. It does not write `brokerCash`, `lotLinks`, or `symbolMap`.
- `v8` and older backups may contain `brokerCash`, `lotLinks`, or `symbolMap`; restore ignores those fields and keeps `brokerCashAdjustment` in `settings`.
- `v8` and older backups migrate the legacy portfolio price-symbol field into `priceSymbol` without overwriting an existing `priceSymbol`.
- `v7` and older backups default missing `brokerCashAdjustment` to `0` through `mergeDefaultSettings`.
- `v3` and newer backups restore `lots`; older versions default `lots` to `{}`.
- `v2` restores `csvName`, `viewMode`, and `networthHistory` directly.
- `v1` remains backward compatible. When `networthHistory` is missing, empty, or on an older history version, restore recomputes it from the restored months, rules, memory, overrides, settings, portfolio, and lots.
- After restore, the latest stored month becomes the selected month.

## Net Worth History Entry

Each `pf_networth_history` entry has this shape:

```js
{
  month: string,
  netWorth: number,
  cash: number,
  property: number,
  investments: number,
  mortgage: number,
  income: number,
  surplus: number,
  savingsRate: number,
  invested: number,
  wealthRetentionRate: number,
  exp: Record<string, number>,
  historyVersion: number
}
```

The app reads these entries as monthly snapshots for net worth, cash flow, and anomaly/projection views.
