---
title: "PRD: Portfolio Feature Overhaul"
date: 2026-04-30
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/software]
status: active
source_file: "3. Personal/Personal Finance/Personal finance dashboard/docs/portfolio-overhaul-prd.md"
source_type: md
confidence: 0.8
imported: 2026-05-14
---

# PRD: Portfolio Feature Overhaul

**Version:** 1.0
**Owner:** Thomas
**Status:** Ready for AI-agent execution
**Execution model:** One orchestrator (ultra) agent spawning specialized sub-agents per phase
**Target codebase:** `Personal finance dashboard/` (React 18, Vite, client-side only, localStorage-backed)

---

## 1. Problem

The Portfolio feature forces the user to manually enter 9+ metadata fields per holding (ticker, name, ISIN, exchange, currency, current price, sleeve, TER, legacy qty, legacy avg price). Prices go stale silently. Lots backfill is hidden behind a warning banner. The Investment Inbox (broker transfers detected from CSV imports) is buried in the Ledger and disconnected from the holdings view. Net effect: the user finds the feature painful and avoids using it, which breaks net-worth accuracy.

**Cost of not solving:** Net worth invests-leg drifts, target allocation drift goes unmonitored, and the user manually edits prices instead of using the app.

## 2. Goals (in priority order)

1. **Auto-enrich holding metadata** from ticker or ISIN via OpenFIGI (already partly wired in `src/lib/symbolResolver.js`).
2. **Auto-fetch + refresh prices** via Twelve Data API (free tier, 8 req/min, 800/day). User will supply API key, stored in `pf_settings.twelveDataApiKey`.
3. **Progressive disclosure in `HoldingDrawer`** — hide legacy `qty`/`avgPrice` behind a collapsible "Legacy fields" section when lots exist; show them only as a fallback otherwise.
4. **Make backfill discoverable** — replace the current warning banner with a primary CTA inside the drawer and an empty-state hint on the portfolio page.
5. **Surface Investment Inbox on the Portfolio page** as a prominent card listing unreviewed broker transfers, one-click linkable to a holding.

## 3. Non-Goals (explicit)

- ❌ Do **NOT** add a backend, server, or proxy. App stays static / client-only.
- ❌ Do **NOT** route price requests through a public CORS proxy (e.g., corsproxy.io). Twelve Data has native CORS.
- ❌ Do **NOT** implement Yahoo Finance integration in this phase.
- ❌ Do **NOT** auto-refresh prices on a schedule (no service worker, no cron). Price refresh is **user-triggered** via a "Refresh prices" button. Background scheduling is a future phase.
- ❌ Do **NOT** change the storage contract for `pf_lots` or `pf_lot_links`.
- ❌ Do **NOT** remove the legacy `qty`/`avgPrice` fields from holdings — only hide them in the UI when not needed. Backup/restore back-compat must be preserved.
- ❌ Do **NOT** modify CSV import, classification, cash flow, or net-worth math outside what is required to consume new prices.
- ❌ Do **NOT** introduce new global state libraries (Redux/Zustand). Continue with `useState` + `useMemo` + `localStorage` mirror in `src/Dashboard.jsx`.
- ❌ Do **NOT** add new design tokens. Reuse `T` and `var(--…)` from `src/styles/tokens.css`.

## 4. Constraints & Invariants (from `CLAUDE.md`)

- File order in `src/Dashboard.jsx` matters — TDZ-sensitive. Place new `useMemo`/`useCallback` after every callback they reference.
- All categorized transactions flow through `allCategorized`. Do not add fresh `classify()` loops.
- `latestCashBal` and net-worth semantics are unchanged.
- Storage keys touched: **add** `pf_settings.twelveDataApiKey`, `pf_settings.priceCache`, `holding.priceUpdatedAt`. Bump backup version to **v7**.
- Theme tokens via `T` / `var(--…)`. Reuse `card(extra)`.
- Verification: `npm run build` must pass; UI must be verified in dev server before completion.

## 5. Success Criteria

| # | Outcome | Measurable |
|---|---|---|
| 1 | Adding a holding by ticker auto-fills name, ISIN, exchange, currency, asset class. | Manual fields shown after enrichment ≤ 2 (sleeve, TER). |
| 2 | One-click "Refresh prices" updates `currentPrice` and `priceUpdatedAt` for all holdings with a Twelve Data symbol. | All holdings show "Updated < 1 min ago" after click. |
| 3 | `HoldingDrawer` shows ≤ 6 fields above the fold for a normal (lots-backed) holding. | Visual check: legacy fields hidden by default. |
| 4 | Backfill is reachable in ≤ 1 click from the holding row and from the empty-state portfolio page. | UX walkthrough. |
| 5 | Unreviewed broker transfers are visible on Portfolio page without navigating to Ledger. | Card present when `detectBrokerTransfers()` returns ≥ 1 item. |
| 6 | `npm run build` passes; no TDZ errors; backup v6 files restore correctly under v7 schema. | Verified by Test Agent. |

## 6. Failure / Edge Cases

- **OpenFIGI rate limit (25/min)** → debounce ticker/ISIN lookups (350ms); cache results in `pf_settings.symbolMap`.
- **Twelve Data rate limit (8/min, 800/day)** → batch quote requests via `/quote?symbol=A,B,C`; show last-success timestamp; on 429, surface inline error and disable button for 60s.
- **Missing API key** → "Refresh prices" button disabled with tooltip linking to settings.
- **Symbol not found on Twelve Data** → leave price unchanged, mark holding with `priceFetchError` (transient); show small ⚠ badge.
- **Network offline** → catch fetch errors, show inline toast; do not corrupt cache.
- **API key invalid (401)** → clear cache, show "Invalid API key" in settings.
- **Currency ≠ EUR** → store native price; conversion is **out of scope** for this PRD (flag with `[OPEN]` below).

## 7. Open Questions

- `[OPEN-1]` Multi-currency holdings: Twelve Data returns price in native currency. Net-worth math currently assumes EUR. **Decision for this phase:** store native `currentPrice` + `currentPriceCurrency`; net-worth continues using existing values; FX conversion is a follow-up.
- `[OPEN-2]` Should "Refresh prices" also re-pull metadata? **Decision:** No — metadata refresh is manual via a separate "Re-enrich" action in the drawer.

---

# 8. Phased Implementation Spec (for AI coding agents)

> **Orchestrator instructions:** Read all phases first. Produce a written plan **before any code edits**. Execute phases sequentially. After each phase, run the Test Agent. Do **not** start a phase until the previous phase's `Done when` checks pass.

---

## Phase 0: Research & Plan (mandatory)

**Agent role:** Planner
**Goal:** Produce an implementation plan with file/line references; no code changes.

**Requirements:**
- Read: `CLAUDE.md`, `src/Dashboard.jsx` (portfolio sections), `src/components/HoldingDrawer.jsx`, `src/components/AddHoldingModal.jsx`, `src/components/HoldingsReference.jsx`, `src/lib/lots.js`, `src/lib/symbolResolver.js`, `src/lib/backup.js`, `src/lib/defaults.js`.
- Identify exact insertion points for new code in `src/Dashboard.jsx` respecting declaration-order rules.
- Confirm OpenFIGI is already used and reusable; identify any cache it already maintains.
- Produce an artifact: `docs/portfolio-overhaul-plan.md` listing every file to be created or edited, with the line ranges expected to change.

**Non-goals for this phase:** No code changes, no test runs.

**Done when:** Plan file exists and the orchestrator has reviewed it.

---

## Phase 1: Twelve Data Price Service

**Depends on:** Phase 0 complete.
**Agent role:** Implementer (services)
**Goal:** Create a pure module that fetches and caches prices from Twelve Data, with no React dependencies.

**Requirements:**
- Create `src/lib/priceService.js` exporting:
  - `fetchQuotes(symbols: string[], apiKey: string): Promise<{ ok: Record<string, {price:number, currency:string, ts:number}>, errors: Record<string, string>, rateLimited: boolean }>`
  - `searchSymbol(query: string, apiKey: string): Promise<Array<{symbol, instrument_name, exchange, currency, country}>>`
  - Internal helper `chunk(arr, n)` to batch ≤ 8 symbols per request.
- Use `https://api.twelvedata.com/quote?symbol=A,B,C&apikey=KEY`. Handle both single-object and keyed-object response shapes.
- Detect HTTP 429 and JSON `code: 429` payload → return `rateLimited: true`.
- No retries inside the service; caller handles UI feedback.
- All fetches `AbortController`-cancellable via an optional `{ signal }` arg.

**Acceptance criteria:**
- Given a valid key and symbols `['VWCE.GY','SGLD.LN']`, when `fetchQuotes` is called, then it returns `ok` with both symbols having numeric `price`.
- Given an invalid symbol, when `fetchQuotes` is called, then `errors[symbol]` contains a string and `ok` does not contain that symbol.
- Given an HTTP 429, when `fetchQuotes` is called, then `rateLimited === true` and `errors` is non-empty.
- Given symbols.length > 8, when called, then exactly `ceil(n/8)` network requests are made.

**Non-goals for this phase:** No React component edits. No persistence. No price refresh button.

**Done when:** Module exists with no React imports; manual smoke via `node --experimental-vm-modules` is not required, but file passes `npm run build`.

---

## Phase 2: Storage & Settings (Twelve Data key + price cache + backup v7)

**Depends on:** Phase 1.
**Agent role:** Implementer (storage)

**Requirements:**
- Extend `pf_settings` defaults (`src/lib/defaults.js` or wherever defaults live) with:
  - `twelveDataApiKey: ''`
  - `priceCacheTtlMinutes: 60`
- Extend holding shape with optional fields (do not require them on existing data):
  - `priceUpdatedAt: number | null` (epoch ms)
  - `currentPriceCurrency: string | null`
  - `twelveDataSymbol: string | null` (e.g., `VWCE.GY`)
- Add a settings UI block: a single password-masked input for the Twelve Data API key. Place it in the existing settings section. Mask with `type="password"`. Add a "Test key" button that calls `fetchQuotes(['AAPL'], key)` and shows ✅ / ❌.
- Bump backup version to **v7** in `src/lib/backup.js`. Update `buildBackupPayload` and `restoreBackupState`. v6→v7 migration: default missing `twelveDataApiKey` to `''`, default new holding fields to `null`.

**Acceptance criteria:**
- Given a v6 backup file, when restored, then app loads with empty API key and no console errors.
- Given a user enters a key and clicks "Test key", when the response is 200, then a green ✅ appears within 5s.
- Given the user reloads the page, when settings are read, then the key persists.
- Update `CLAUDE.md` Storage Contract and Backup Format sections to reflect v7.

**Non-goals:** No price fetch wiring yet outside the test button.

**Done when:** Settings UI shows API key field; backup export is v7; restore handles v1–v7.

---

## Phase 3: OpenFIGI Auto-Enrichment in Add/Edit Flows

**Depends on:** Phase 0.
**Agent role:** Implementer (UI)

**Requirements:**
- In `src/components/AddHoldingModal.jsx`:
  - When the user types a ticker (no ISIN), debounce 350ms then call `searchSymbol` (Twelve Data) **and** the existing OpenFIGI resolver. Merge results.
  - Show a dropdown of candidates: `{ticker} — {name} · {exchange} · {currency}`.
  - On selection, populate `name, isin, exchange, currency, twelveDataSymbol, assetClass`. Suggest a sleeve based on asset class (`equity` → Equity sleeve; `commodity` / `gold` → Real Assets; default → Equity).
  - Allow user to override the suggested sleeve.
- In `src/components/HoldingDrawer.jsx`:
  - Add a "Re-enrich from ticker/ISIN" link button at the top of the drawer. Clicking re-runs OpenFIGI + Twelve Data symbol search and offers to overwrite metadata fields (with confirmation).

**Acceptance criteria:**
- Given the user types `VWCE` in Add Holding, when 350ms passes, then a dropdown shows ≥ 1 candidate including name and exchange.
- Given the user selects a candidate, when the modal advances, then sleeve is pre-selected based on asset class.
- Given an existing holding with empty `isin`, when "Re-enrich" is clicked, then ISIN/exchange/currency populate.

**Non-goals:** No price fetching here.

**Done when:** Adding `VWCE` from a clean state requires only ticker input + sleeve confirmation.

---

## Phase 4: HoldingDrawer Progressive Disclosure + Lots-First UX

**Depends on:** Phase 3.
**Agent role:** Implementer (UI)

**Requirements:**
- In `src/components/HoldingDrawer.jsx`:
  - Reorder fields: **Identity** (ticker, name, ISIN, exchange, currency) → **Classification** (sleeve, TER) → **Price** (current price, last updated) → **Lots summary** (read-only effective qty + avg price from `effectiveHolding`) → **Legacy fields** (collapsed by default).
  - "Legacy fields" section: collapsed `<details>` containing `qty` and `avgPrice` inputs. Header: "Legacy fields (used only when no lots exist)".
  - Replace the current "no lots" warning with a primary CTA: a button labeled **"Backfill lots"** that opens the existing backfill modal pre-filtered to this holding's ticker.
  - Show a "Last updated" relative timestamp under the price field (`X minutes/hours/days ago` or "Never"). Add a small inline "Refresh" icon button that calls Phase 5's price refresh for this single holding.

**Acceptance criteria:**
- Given a holding with lots, when the drawer opens, then `qty` and `avgPrice` inputs are not visible above the fold.
- Given the user clicks "Legacy fields", when expanded, then `qty` and `avgPrice` inputs appear.
- Given a holding with no lots, when the drawer opens, then a "Backfill lots" CTA is visible (no warning yellow banner).

**Non-goals:** No changes to lot logic. No changes to `effectiveHolding`.

**Done when:** Drawer matches the new field order and the user's screenshot complaint is resolved (legacy qty hidden, no warning banner).

---

## Phase 5: Refresh Prices (per-holding + bulk)

**Depends on:** Phase 1, 2, 4.
**Agent role:** Implementer (UI + state)

**Requirements:**
- Add a "Refresh prices" button to the Portfolio section header (next to the existing Add holding button).
- Add a single-holding refresh icon button in the `HoldingDrawer` (Phase 4).
- Both call `fetchQuotes` with `holdings.map(h => h.twelveDataSymbol).filter(Boolean)`.
- On success, update `holding.currentPrice`, `holding.currentPriceCurrency`, `holding.priceUpdatedAt = Date.now()`. Persist via existing portfolio `useEffect` mirror to `pf_portfolio`.
- Disable button when:
  - `pf_settings.twelveDataApiKey` is empty (tooltip: "Add Twelve Data key in Settings"),
  - or a refresh is in-flight (show spinner inline),
  - or rate-limited within the last 60s.
- After refresh: toast "Updated N of M holdings" or "Rate limited — try again in 60s".

**Acceptance criteria:**
- Given holdings with `twelveDataSymbol` set and a valid key, when "Refresh prices" is clicked, then within 5s every such holding has a `priceUpdatedAt` within the last 10s.
- Given no key, when the button is hovered, then a tooltip directs the user to settings.
- Given a 429 response, when triggered, then UI shows a rate-limit message and re-enables the button after 60s.

**Non-goals:** No background refresh. No FX conversion.

**Done when:** Manual click refreshes all eligible prices and updates timestamps visible in the drawer.

---

## Phase 6: Investment Inbox card on Portfolio page

**Depends on:** Phase 4.
**Agent role:** Implementer (UI)

**Requirements:**
- In the Portfolio section of `src/Dashboard.jsx`, render a new `<InvestmentInboxCard />` component (new file `src/components/InvestmentInboxCard.jsx`) **above** the Holdings reference and **below** the Plan bar (per the CLAUDE.md IA: Summary → Plan → **Inbox** → Holdings → Add → Sleeve summary → Ledger).
- The card consumes the existing `detectBrokerTransfers()` output (already memoised in `Dashboard.jsx`).
- Render: count of unreviewed transfers + a list of up to 5 most recent (date, amount, counterparty), each with a "Link to holding…" button that opens the existing ledger-confirm UI prefilled.
- If 0 unreviewed transfers, render a compact empty state ("All broker transfers reviewed ✓").

**Acceptance criteria:**
- Given ≥ 1 unreviewed broker transfer, when the Portfolio page loads, then the Inbox card appears above Holdings reference.
- Given the user clicks "Link to holding…", when the existing ledger-confirm flow opens, then the transfer's amount and date are prefilled.
- Given 0 unreviewed transfers, when the page loads, then the empty-state card is shown.

**Non-goals:** No new ledger logic; reuse existing `ledgerConfirm.js`. No changes to `detectBrokerTransfers`.

**Done when:** Portfolio page has a visible Inbox section that updates as transfers are confirmed.

---

## Phase 7: Test & Verification

**Depends on:** Phases 1–6 complete.
**Agent role:** Tester (separate agent — see prompt below).

**Requirements:**
- Run `npm run build`. Must exit 0.
- Start `npm run dev` via the `preview_*` MCP tools.
- Walk through the verification checklist below in the browser. Capture a screenshot at each checkpoint.
- For each failed step, file a regression note in `docs/portfolio-overhaul-test-report.md` and hand back to the orchestrator.

**Verification checklist (browser):**
1. Settings: enter Twelve Data key, click "Test key" → ✅ within 5s.
2. Add holding by ticker `VWCE` → dropdown appears, candidate selectable, sleeve auto-suggested.
3. After add, holding shows non-empty name, ISIN, exchange, currency.
4. Open holding drawer → no yellow warning, "Backfill lots" button visible, legacy fields collapsed.
5. Expand "Legacy fields" → qty/avgPrice inputs visible.
6. Click "Refresh prices" → all holdings with `twelveDataSymbol` get a recent timestamp.
7. Single-holding refresh button updates only that holding's timestamp.
8. Disable network in devtools → click refresh → graceful error toast.
9. Clear API key → refresh button shows tooltip and is disabled.
10. Investment Inbox card appears above Holdings on Portfolio page (seed test data if none exists).
11. Click "Link to holding…" → ledger confirm opens prefilled.
12. Export backup → reimport → no console errors, all data intact, version reads `7`.
13. Import a v6 backup → loads cleanly with empty API key.

**Done when:** Every checklist item passes and report is committed.

---

# 9. Sub-Agent Prompts (verbatim, for the orchestrator to use)

## 9.1 Orchestrator (Ultra) Prompt

> You are the orchestrator for the Portfolio overhaul described in `docs/portfolio-overhaul-prd.md`. Your job is to execute Phases 0–7 sequentially, spawning a fresh sub-agent per phase and a Test Agent at the end.
>
> Rules:
> - Read the full PRD before starting. Confirm the Twelve Data API key is set in `pf_settings.twelveDataApiKey` (ask the user if missing).
> - Spawn one Implementer sub-agent per phase. Pass the entire phase block (Goal, Requirements, Acceptance criteria, Non-goals, Done when) verbatim plus the relevant `CLAUDE.md` invariants.
> - After each phase, run `npm run build`. If it fails, hand back to the same Implementer with the error trace; do not advance.
> - After Phase 6, spawn the Test Agent (Section 9.3). Do not declare done until its report has zero failures.
> - Never modify the storage contract beyond what Phase 2 specifies. Never add a backend.
> - End-of-run output: a short summary of files changed, build status, and the test report path.

## 9.2 Implementer Sub-Agent Prompt Template

> You are implementing **Phase {N}: {Title}** of the Portfolio overhaul. Working dir: the project root.
>
> Required reading before any edit:
> 1. `docs/portfolio-overhaul-prd.md` — full PRD.
> 2. `CLAUDE.md` — invariants (especially declaration order in `src/Dashboard.jsx`).
> 3. The files listed in your phase's `Requirements` section.
>
> Constraints:
> - Stay strictly within this phase's `Requirements`. Do not refactor unrelated code. Do not "improve" things that are not broken.
> - Honor every `Non-goals` bullet.
> - Every acceptance criterion must be satisfiable by inspection or a manual click test.
> - Run `npm run build` before reporting done. If it fails, fix and re-run.
> - Do not run `git commit` unless explicitly asked.
>
> Output:
> - List of files created/modified with one-line rationale.
> - Confirmation that `npm run build` passed.
> - Any deviations from the PRD with justification.

## 9.3 Test Agent Prompt

> You are the verification agent for the Portfolio overhaul. The implementation is complete and you must independently verify it.
>
> Steps:
> 1. Read `docs/portfolio-overhaul-prd.md` Section 7 (Phase 7 verification checklist).
> 2. Run `npm run build` and confirm exit 0. Capture warnings.
> 3. Start the dev server using `preview_start`. Open the app via `preview_snapshot`.
> 4. For each checklist item (1–13): perform the action with `preview_click` / `preview_fill` / `preview_eval`, then verify with `preview_snapshot` and `preview_console_logs`. Capture a `preview_screenshot` for visual checks.
> 5. For Twelve Data calls, ask the user for an API key if `pf_settings.twelveDataApiKey` is empty before running checks 1, 6, 7, 8.
> 6. For backup checks (12, 13), use `preview_eval` to read/write `localStorage.pf_*` keys.
>
> Output: write `docs/portfolio-overhaul-test-report.md` with one section per checklist item: PASS / FAIL, evidence (screenshot reference or console excerpt), and a regression note if FAIL. Do not modify source code — only report.

## 9.4 Code-Review Sub-Agent Prompt (optional, run before Test Agent)

> You are reviewing the Portfolio overhaul implementation against `docs/portfolio-overhaul-prd.md`. You do not run code; you read it.
>
> Check for:
> - Declaration-order violations in `src/Dashboard.jsx` (TDZ risk).
> - Stale `pf_settings` shape mismatches between defaults, persistence effects, and backup migration.
> - Hardcoded colors instead of `T` / `var(--…)`.
> - New `classify()` loops outside `allCategorized`.
> - API keys logged to console or persisted outside `pf_settings`.
> - Missing `Non-goals` adherence per phase.
>
> Output: a bulleted list of findings with `file:line` references. No code edits.

---

# 10. Changelog

- **v1.0** (2026-04-25) — Initial PRD authored from Explore + research agent reports. Goals, non-goals, 7 phases, sub-agent prompts.
