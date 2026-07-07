---
title: "ADR — Storage: localStorage Now, IndexedDB (Dexie) Later"
date: 2026-04-21
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/software]
status: active
source_file: "3. Personal/Personal Finance/Personal finance dashboard/docs/prds/03-storage-adr.md"
source_type: md
confidence: 0.8
imported: 2026-05-14
---

# ADR — Storage: localStorage Now, IndexedDB (Dexie) Later

**Status:** Accepted
**Date:** 2026-04-18
**Decision-makers:** Thomas
**Related:** CLAUDE.md "Storage Contract" section; all `pf_*` localStorage keys.

---

## 1. Context

The dashboard is client-side only, single-user, localStorage-backed. Current state:

- 10 primary keys (`pf_months`, `pf_rules`, `pf_memory`, `pf_overrides`, `pf_settings`, `pf_portfolio`, `pf_networth_history`, `pf_lots`, `pf_lot_links`, `pf_symbol_map`).
- `pf_months` is the dominant key: all parsed transactions keyed by `YYYY-MM`.
- Current size: ~3k transactions stored, well under quota.
- Projected size at year 5: ~20k transactions, approaching the ~5-10MB localStorage cap.

Question raised by the user: *"Should we move to SQL that runs locally on startup — one for transactions, one for classification?"*

Three architectures evaluated:
- **A** — Stay on localStorage, optimize tactically.
- **B** — Migrate to IndexedDB via Dexie.js.
- **C** — Embedded SQLite (wa-sqlite + OPFS).

## 2. Decision

**Stay on localStorage (Option A) for now. Migrate to IndexedDB (Option B) when any trigger fires. Do not pursue SQLite.**

Rejecting the premise of "two separate databases for transactions and classification" — these concerns belong to one logical store with separate tables, whether that store is localStorage keys, Dexie tables, or SQLite tables.

## 3. Rationale

### Why A wins today

| Dimension | Current (A) | Dexie (B) | SQLite (C) |
|---|---|---|---|
| Tx capacity before pain | ~15k (with optimizations) | millions | millions |
| Bundle size added | 0 | ~22KB gzipped | ~500KB gzipped |
| Cold start overhead | 0 | <50ms | 200-400ms |
| Code churn required | minimal | moderate | large |
| Backup JSON shape change | none | none | none (optional `.db`) |
| Developer velocity impact | none | two-week migration | multi-week rewrite |
| Honest need *today* | yes | no | no |

At 3k transactions and a solid set of in-memory `Map` indexes, we're nowhere near the cliff. The cliff is estimated at ~15k transactions — roughly three more years at current import cadence. Migrating pre-emptively spends complexity we don't have a return on.

### Why not C (SQLite)

- 500KB bundle + 200-400ms cold start is a measurable regression for a single-user tool where the JSON-in-memory model works fine.
- `src/lib/finance.js` and `src/lib/classification.js` would need rewriting as SQL queries. Weeks of work for no user-visible improvement.
- The "real SQL unlocks reporting" argument evaporates when the reports are already working as JavaScript memos.
- Revisit only if multi-device sync becomes real — and by then cr-sqlite / electric-sql may have matured enough that SQLite is the sync layer, not just the storage layer.

### Why B eventually, not never

- Async + GB-scale storage removes the quota cliff entirely.
- Indexed queries make cross-month scans (e.g., "all transactions matching a substring across 5 years") cheap.
- Dexie's `liveQuery` gives us reactive data without refactoring the classify/memo chain.
- Bundle and cold-start cost are both small enough not to bite.
- Sync-ready story is substantially better than localStorage if a backend appears.

## 4. Triggers for migrating to Dexie

Migrate to Option B **when any** of the following becomes true:

1. **Size trigger** — `pf_months` serialized JSON exceeds **2MB**. Measured via `new Blob([JSON.stringify(pfMonths)]).size`.
2. **Latency trigger** — first-paint parse of localStorage on cold load exceeds **200ms** on a mid-range laptop. Measured via `performance.now()` around the initial `lsGet` calls.
3. **Feature trigger** — first feature lands that requires cross-month indexed queries impossible to express cleanly as in-memory scans (e.g., "find all transactions with a description containing X across all time, with pagination").
4. **Quota trigger** — first `QuotaExceededError` thrown anywhere in the app. Hard trigger — migrate before the next release.

Track these in a quarterly check. Don't add perf instrumentation now — it's premature.

## 5. Optimizations to apply while on localStorage

These extend the life of Option A. Apply as pain emerges; don't preemptively front-load:

### 5.1 Per-year splitting
Split `pf_months` into `pf_months_YYYY` keyed by year. Load current + prior year eagerly; lazy-load older years when user navigates to them. Buys ~3-5x headroom before the quota wall.

### 5.2 Boot-time indexed lookups
Build once, reuse:
- `Map<normalizedIban, category>` for `OWN_IBANS` + `memory.ibans`.
- `Map<normalizedName, category>` for `memory.names`.
- `Map<descPrefix, category>` for prefix rules.

Already partially present; formalize into a single `buildClassificationIndex()` in `src/lib/classification.js`.

### 5.3 Web Worker for import-time classification
`classify()` batch loops at CSV import are the one heavy synchronous operation. Move to a Web Worker; main thread stays responsive during large imports. Steady-state `allCategorized` memos stay on the main thread — they're already fast.

### 5.4 LZ-string compression on `pf_months`
3-5x smaller JSON at ~30ms compression cost per write. Buys 2-3x additional headroom. Apply only if size trigger starts being felt.

### 5.5 Lazy parse
Parse months on demand, not all at once. Keep a `Map<YYYY-MM, string>` of raw JSON, `JSON.parse` only when a month's data is accessed.

## 6. Consequences

### Positive
- No architecture churn during MVP.
- Backup/restore contract stays at v5; no storage-layer-driven schema bump.
- Preserves the current "localStorage is source of truth" mental model documented in CLAUDE.md.
- Classification pipeline, `allCategorized`, and all invariants remain intact.

### Negative
- Kicked-down-road cost: when we do migrate, we'll do it under more pressure than if we did it now.
- Perf wall is a hard failure mode (quota exceeded → user sees an error). Size trigger must be monitored.
- Multi-device sync remains blocked; localStorage can't back that up.

### Neutral
- The user's literal question "one DB for tx, one for classification" is answered in §7 regardless of which option.

## 7. On "one DB or two?"

**One logical store, separate tables — always.** This is true regardless of whether the backing tech is localStorage keys, Dexie tables, or SQLite tables.

Reasons:
- Classification rules reference transactions (via IBAN, name, descPrefix) — joins / cross-reads are natural.
- "Apply rule + update 47 tx categories" must be atomic; two separate stores give you two failure modes.
- Two quotas, two backup files, two migration timelines — zero wins.
- Mental separation is already achieved via distinct keys / tables. The "separation" the user was pointing at is real and already present.

Current localStorage keys map cleanly to tables in a future Dexie schema:

| Current key | Future Dexie table |
|---|---|
| `pf_months` | `txs` (flattened, indexed by date, category, month) |
| `pf_rules` | `rules` |
| `pf_memory` | `memory` |
| `pf_overrides` | `overrides` |
| `pf_settings` | `settings` (singleton row) |
| `pf_portfolio` | `holdings` |
| `pf_lots` | `lots` |
| `pf_lot_links` | `lotLinks` |
| `pf_networth_history` | `networthHistory` |
| (new) `pf_budgets` | `budgets` |
| (new) `pf_symbol_map` | `symbolMap` |

## 8. When we do migrate to Dexie

Compressed migration plan for future reference:

1. **Add Dexie schema** with all tables matching the current keys, version 1.
2. **One-shot seed:** on first load after migration code ships, read all `pf_*` keys from localStorage, write to Dexie, set a `pf_migrated_to_dexie` flag in localStorage.
3. **Keep localStorage as fallback for one release** — if Dexie reads fail, fall back to localStorage so no data loss.
4. **Next release after that:** delete the localStorage fallback + keys; Dexie is sole source of truth.
5. **Backup JSON contract unchanged** — export walks Dexie tables instead of `lsGet`, same shape.
6. **Dev tooling:** add a "Reset to localStorage" escape hatch in case of migration bugs (backup first, delete IndexedDB DB, restore from backup).

Estimated work: one PR for schema + migration, one PR to move `allCategorized` / classification reads to async boot-hydration, one PR to clean up. ~2-3 weeks at a normal pace.

## 9. Revisit date

Re-evaluate this ADR **when any migration trigger fires**, or on **2027-04-18** (12 months), whichever first.
