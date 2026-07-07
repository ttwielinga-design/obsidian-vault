---
title: "Execution Playbook — MVP Sprint"
date: 2026-04-23
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/software]
status: active
source_file: "3. Personal/Personal Finance/Personal finance dashboard/docs/plans/mvp-execution-playbook.md"
source_type: md
confidence: 0.8
imported: 2026-05-14
---

# Execution Playbook — MVP Sprint

**Audience:** Thomas, running the MVP build across multiple Claude Code + Codex sessions.
**Scope:** 14 GitHub issues (#17–#30) + 3 PRDs (Budgeting, Equity/Investments, Storage ADR).
**Time estimate:** 3–5 weeks calendar, ~8–12 merged PRs.

---

## 0. Tool split — non-negotiable rules

### Use **Claude Code** (interactive, here) when:
- The work touches `src/Dashboard.jsx` declaration order (TDZ traps).
- The work touches `allCategorized`, `classify()`, `computeCashFlow()`, or `networthHistory` math.
- You need to **verify in the browser** via preview tools (UI polish, interaction bugs).
- You're **debugging** (root cause may shift mid-task).
- You're **reviewing a Codex PR** — pull the branch, read it, run the build and preview.

### Use **Codex** (async, parallel) when:
- The work is a **new isolated file** (utility module, new component).
- Acceptance criteria are crisp and don't depend on invariants.
- You can write a self-contained prompt with repo paths + expected outputs.
- Browser verification is not the primary gate (Codex can't preview the UI interactively).

### Never use Codex for:
- Dashboard.jsx declaration-order edits.
- Net worth math / classification pipeline changes.
- Anything where the fix depends on observing a bug interactively.

### Every wave ends with:
1. `npm run build` passes locally.
2. Manual smoke test on dev + preview (different origins, different localStorage — test both).
3. Backup roundtrip test if storage contract touched.
4. PR opened, reviewed, merged to `main`.
5. Next wave starts from a clean rebase of `main`.

---

## 1. Wave map at a glance

| # | Wave | Tool | Issues / PRDs | Prereq | Est. | Status |
|---|---|---|---|---|---|---|
| 1 | Low-risk bug sprint | Claude Code | #19, #20, #21, #23, #24 | — | 1 session | open |
| 2 | Dropdown rebuild | Claude Code | #17, #18 | Wave 1 merged | 1 session | **shipped** |
| 3 | Net worth correctness | Claude Code | #22, #25 | Wave 1 merged | 1 session | open |
| 4 | IBAN CRUD | **Codex** | #28, #29 | Wave 1 merged | 1 Codex run + review | **shipped** |
| 5 | Backup delete popup | **Codex** | #30 | Wave 1 merged | 1 Codex run + review | open |
| 6 | Equity IA foundation | Claude Code | #26, #27 + PRD-02 M1 | Waves 2–5 merged | 1 session | partial — infra shipped |
| 7 | Symbol resolver (openFIGI) | **Codex** | PRD-02 M2 | Wave 6 merged | 1 Codex run + review | **shipped** |
| 8 | Price lookup (Stooq + FX) | **Codex** | PRD-02 M3 part 1 | Wave 7 merged | 1 Codex run + review | **shipped** |
| 9 | Lot modal integration | Claude Code | PRD-02 M3 part 2 | Waves 7, 8 merged | 1 session | open |
| 10 | Equity polish | Claude Code | PRD-02 M4, M5 | Wave 9 merged | 1 session | open |
| 11 | Budgeting foundation | Claude Code | PRD-01 M1 | Wave 6 merged | 1 session | open |
| 12 | Budgeting core flow | Claude Code | PRD-01 M2 | Wave 11 merged | 1 session | open |
| 13 | Budgeting reassign + close | Claude Code | PRD-01 M3 | Wave 12 merged | 1 session | open |
| 14 | Budgeting trend seeds + templates | **Codex** | PRD-01 M4 | Wave 13 merged | 1 Codex run + review | open |
| 15 | Budgeting polish | Claude Code | PRD-01 M5 | Wave 14 merged | 1 session | open |
| 16 | Storage optimizations (if triggered) | Claude Code | PRD-03 §5 | As triggers fire | deferred | open |

**Waves 4 and 5 can run in parallel with Waves 2 and 3** (different files, no conflicts). Everything else is sequential.

> **Shipped waves (2, 4, 7, 8):** skip their prompts below — the code already exists on `main`. For Wave 6, skip the InvestmentInbox creation step only; the sidebar, EquitySection, PropertyDetail, and HoldingDetail work remains.

---

## 2. Opening prompts (paste into each new chat)

Each chat gets a tight, self-contained opener. Do not assume prior chat memory.

### Wave 1 — Low-risk bug sprint (Claude Code)

> Open a new chat in this repo. Paste:

```
I'm starting the MVP bug sprint. Read CLAUDE.md + docs/plans/mvp-execution-playbook.md.

Task: fix GitHub issues #19, #20, #21, #23, #24 in one PR on a new branch
`fix/mvp-bug-sprint-1`.

- #19 Chart color inconsistency — refactor CAT_COLOR_MAP in src/Dashboard.jsx
  (search for `const CAT_COLOR_MAP`) to ensure no near-white bars; Uncategorized
  is muted gray, not red. Verify the palette is complete before touching anything —
  the refactor may already be done.
- #20 Float precision in month selector — round at render in
  src/components/TopBar.jsx via existing euro formatter.
- #21 "???" emoji mojibake — search src/Dashboard.jsx for literal `'???'` strings;
  replace with inline SVG or re-encode as UTF-8. Verify in preview.
- #23 Arrow nav skips by 2 — search src/Dashboard.jsx for `ArrowLeft` / `ArrowRight`
  key handler; likely StrictMode double-fire or duplicate listener. Verify on dev
  AND preview.
- #24 Broker IBAN validation — src/Dashboard.jsx:2130-2146; add mod-97 IBAN
  validator, inline error.

Rules:
- `npm run build` must pass at the end.
- Test each fix in the browser preview before declaring done.
- Reference CLAUDE.md declaration-order rules for any Dashboard.jsx touch.
- One PR at the end, title: "fix: MVP bug sprint — #19, #20, #21, #23, #24".
```

### Wave 2 — Dropdown rebuild (Claude Code) — **SHIPPED**

`src/components/CategoryPicker.jsx` already exists with portal-based overflow escape,
keyboard nav (↑↓ Enter Esc), and type-to-filter. Imported and wired in Dashboard.jsx.

> No action needed. Verify the component works in dev + preview, then move on.

### Wave 3 — Net worth correctness (Claude Code)

> Open a new chat. Paste:

```
Start fresh from main. Read CLAUDE.md + docs/plans/mvp-execution-playbook.md.

Task: fix GitHub issues #22 and #25 in one PR on `fix/networth-by-month`.

- #22 Net worth card must reflect the selected month. When selectedMonth !==
  latest, read from `networthHistory.find(h => h.month === selectedMonth)`.
  When ===, fall back to live netWorth. DO NOT redefine the CLAUDE.md invariant
  that `netWorth` uses `latestCashBal` — this is about historical display only.
- #25 Reconcile: for every month M with history, NW[M] - NW[M-1] must equal
  Savings + Mortgage paydown + Other ± rounding. Likely fix in the
  networthHistory recompute path inside the history-writing useEffect.

Verification:
- Pick 3 random months, hand-reconcile NW[M] - NW[M-1] = attribution.
- Selecting latest still shows live value.
- `npm run build` passes.

PR title: "fix: net worth reflects selected month + attribution reconciliation".
```

### Wave 4 — IBAN CRUD (Codex, async) — **SHIPPED**

`src/components/IbanListEditor.jsx` already exists and is wired for both own and
broker IBANs (Dashboard.jsx imports at line 5, rendered at lines ~2537 and ~3366).
`src/lib/classification.js` already reads from `settings.ownIbans`. Backup is at
`BACKUP_VERSION = 5` — no schema bump needed for this wave.

> No action needed. Verify add/delete/classify behaviour in dev + preview, then move on.

### Wave 5 — Backup delete popup (Codex, async)

> Assign #30 to Codex, or paste:

```
Task: implement GitHub issue #30 in ttwielinga-design/personal-finance-dashboard.
Branch: `feat/backup-delete-popup`.

After src/Dashboard.jsx:1060-1077 `handleExportData` completes, show a modal:
- Title: "Backup downloaded. Wipe local data?"
- Default action: dismiss (no destruction).
- Destructive action behind a two-step confirm (checkbox + "Yes, delete").
- On confirm: clear all `pf_*` localStorage keys, then `window.location.reload()`.
- Use existing modal / popover patterns from the codebase.

Invariants:
- Export behavior unchanged — modal appears AFTER successful export.
- No auto-delete, ever.

PR title: "feat: optional wipe-after-backup modal".
Acceptance: export always works; modal dismissible; confirm wipes and reloads
to empty state; no stale React state after reload.
```

Review the Codex PR in Claude Code same way as Wave 4.

### Wave 6 — Equity IA foundation (Claude Code)

> Open a new chat. Paste:

```
Start fresh from main after Waves 2–5 are merged. Read CLAUDE.md +
docs/prds/02-equity-investments.md §5 and §8.

Task: implement PRD-02 M1 + issues #26, #27 on `feat/equity-ia`.

- Add `equity` to sidebar NAV in src/components/Sidebar.jsx. Remove
  `portfolio`. Add children `property` and `investments`.
- Keyboard shortcut `g e` → equity, `g i` → investments, `g p` → property
  (wire via useKeyboardNav).
- Create src/components/EquitySection.jsx with 3 summary cards
  (per PRD §5.2).
- Create src/components/PropertyDetail.jsx — CUT the Property block from
  src/Dashboard.jsx (search for `🏠 Property` comment, currently ~line 3063)
  and paste here. settings.* keys UNCHANGED.
- Create src/components/HoldingDetail.jsx by relocating the current Portfolio
  per-holding render. `src/components/InvestmentInbox.jsx` already exists —
  do not recreate it; wire it under the new Equity section instead. All storage
  keys unchanged.
- Dashboard.jsx `activeSection` switch learns `equity` (and its children).
- NO price-lookup code in this wave. Manual lot creation still works.

Verification:
- `npm run build` passes (TDZ check).
- Dev AND preview — sidebar shows Equity; Property renders same fields;
  existing lots still show.
- Backup roundtrip: export, clear, restore — no data loss.

PR title: "feat(equity): new Equity section absorbs Portfolio + Property".
```

### Wave 7 — Symbol resolver (Codex) — **SHIPPED**

`src/lib/symbolResolver.js` already exists with openFIGI integration and
`pf_symbol_map` caching. `src/lib/backup.js` is already at `BACKUP_VERSION = 5`
with symbolMap export. Dashboard.jsx manages `symbolMap` state and persists it.

> No action needed. Verify ISIN lookup works in dev + preview, then move on.

### Wave 8 — Price lookup (Codex) — **SHIPPED**

`src/lib/priceLookup.js`, `src/lib/fx.js`, and `src/lib/priceCache.js` all exist,
with unit tests (`priceLookup.test.js`, `fx.test.js`). Session-scoped `pf_price_cache`
is wired. No new files needed.

> No action needed. Run existing tests; verify `fetchCloseOnDate` against a live ticker
> in dev. Then move on to Wave 9.

### Wave 9 — Lot modal integration (Claude Code)

> Open a new chat. Paste:

```
Start fresh from main after Waves 7, 8 merged. Read CLAUDE.md +
docs/prds/02-equity-investments.md §6 and §8.4.

Task: wire symbolResolver + priceLookup + fx into the lot-create modal.
Branch: `feat/lot-modal-integration`.

Scope:
- From the Investment Inbox row's "Create lot" action, open the modal.
- User types ISIN/ticker → listings picker (symbolResolver).
- Listing picked → call priceLookup.fetchCloseOnDate with tx.date → prefill
  pricePerShare. If non-EUR listing, also call fx.getEurRate for conversion.
- Inline manual fallback when any API fails — user can type price; set
  `source: "stooq:manual-fallback"`.
- On confirm: write lot with new optional fields (symbolKey, currency,
  fxConverted, fxRate, source enum). Update pf_lot_links.

This wave is the end-to-end browser test of Waves 6–8. Verify:
- Happy path: transfer → lot → net worth updates.
- Weekend date: walkback + "approximated" badge shown in UI.
- USD listing: fxConverted: true on the stored lot.
- Offline (disable network in DevTools): manual fallback path works.
- `npm run build` passes.

PR title: "feat(equity): lookup-assisted lot creation with Stooq + FX".
```

### Waves 10–15 — pattern repeats

Same opening-prompt shape. Each wave references its PRD milestone, spells out
the branch name, and ends with verification + PR title.

**Wave 10 (Equity polish, Claude Code):** PRD-02 M4 + M5. Holding detail, 30-day
deltas, property amortization chart.

**Wave 11 (Budgeting foundation, Claude Code):** PRD-01 M1. Create `pf_budgets`
store, sidebar entry under PLANNING, empty BudgetSection, backup v5 → v6 bump.

**Wave 12 (Budgeting core flow, Claude Code):** PRD-01 M2. Envelope cards,
assignment modal, spent/available math. Test heavily — this is the user's daily
touchpoint.

**Wave 13 (Budgeting reassign + close, Claude Code):** PRD-01 M3. Cover-from
popover, close-month action, reassignments audit log.

**Wave 14 (Budgeting trend seeds, Codex):** PRD-01 M4. New lib file
`src/lib/budgetTrends.js` with `seedFromTrend` + copy-last-month + templates.
Clean spec, no invariants touched → Codex friendly.

**Wave 15 (Budgeting polish, Claude Code):** PRD-01 M5. Animations, sparklines,
empty states.

---

## 3. Verification rituals

### After every PR merges to main
```bash
git checkout main
git pull
npm install
npm run build
npm run dev       # smoke test: open each section, overview card renders
# optional:
npm run preview   # second origin, second localStorage — important for
                  # verifying backup/restore roundtrip
```

### Full regression ritual (run after Waves 6, 10, 15 at minimum)
- Export backup to JSON.
- Clear localStorage (in DevTools → Application → Storage → Clear site data).
- Restore from backup JSON.
- Walk every section: Overview, Cash Flow, Transactions, Equity (Property +
  Investments), Budgeting, Goals, Subscriptions.
- Spot-check: pick 3 months, verify net worth attribution reconciles.
- Upload a fresh CSV, verify classification still works.

### Triggers for storage migration evaluation (PRD-03)
Track monthly; if any fire, plan Wave 16:
- `pf_months` JSON > 2MB.
- Cold-load parse > 200ms on a mid-range laptop.
- A feature request genuinely needs cross-month indexed queries.
- First `QuotaExceededError` seen in the wild.

---

## 4. Failure modes + recovery

| If this happens… | Do this |
|---|---|
| Claude Code fixes one bug but introduces another | Stop. Open new chat. Paste CLAUDE.md + offending file + describe both the original bug and the regression. Fresh context beats fighting through. |
| `npm run build` fails with TDZ error after a Dashboard.jsx edit | Check declaration order per CLAUDE.md. Move the memo/callback **after** every identifier it references. |
| Codex PR does the work but breaks an invariant | Don't merge. Pull the branch, fix in Claude Code, push back, merge. |
| Backup restore loses data after a schema bump | Keep CLAUDE.md's backup version mapping updated. Test restore of each prior version before merging. |
| You lose track of where you are | Re-read this file. Check which branches exist on GitHub — unmerged branches indicate the last in-flight wave. |

---

## 5. Branch / PR hygiene

- **One wave = one branch = one PR.** Don't pile waves onto one branch.
- Branch naming: `fix/...` (bugs), `feat/...` (features), `refactor/...` (pure moves).
- Always rebase on main before starting a new wave: `git fetch && git rebase origin/main`.
- PR description must list the issues it closes (`Closes #17 #18`).
- Never force-push to main.
- Never merge without `npm run build` green locally.

---

## 6. When you're done

After Wave 15 is merged, this is your MVP:
- 14 issues closed.
- 3 PRDs executed.
- Storage optimizations **not yet applied** (deferred until triggers fire — PRD-03).

Post-MVP candidates already identified in the PRDs:
- Stock splits / dividends (PRD-02 §15).
- Age of Money metric, debt snowball (PRD-01 §14).
- Dexie migration (PRD-03 when triggered).
- The "ugly white box" — still needs a screenshot to specify.

Open a new issue as each surfaces. Keep the MVP milestone closed once all 14
ship; future work uses a new milestone.
