---
title: "Dashboard UI kit"
date: 2026-05-06
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/software]
status: active
source_file: "Downloads/Personal Finance Design System/ui_kits/dashboard_v2/README.md"
source_type: md
confidence: 0.8
imported: 2026-05-14
---

# Dashboard UI kit

High-fidelity recreation of the Thomas Finance Dashboard app — the single product surface in this design system.

## Files

- `index.html` — interactive click-through. Run it in any browser.
- `Icon.jsx` — the 22 Lucide-style stroke icons, `currentColor` + 1.7px stroke.
- `Chrome.jsx` — `<Ribbon/>`, `<Sidebar/>`, `<TopBar/>`, `<StatusBar/>`.
- `Screens.jsx` — `<OverviewScreen/>`, `<CashflowScreen/>`, `<PortfolioScreen/>`, `<TxScreen/>`.
- `Overlays.jsx` — `<CommandPalette/>` (`⌘K`) and `<ShortcutsOverlay/>` (`?`).
- `kit.css` — scoped styles. Always load `../../colors_and_type.css` before it.

## Interactions covered

- Nav: sidebar + ribbon routes between Overview / Cash Flow / Portfolio / Transactions.
- `⌘K` opens the command palette, `?` opens the shortcuts overlay, `Esc` closes either.
- Transactions filter updates live; uncategorized rows get the red inline select treatment.
- Current route persists in `localStorage`.

## Scope

Verbatim to the codebase in structure and chrome — the 44px ribbon, 240px labelled sidebar, 22px status bar, ⌘K palette, inline category select on uncategorized rows, and the three-rule overview block with emoji (📈 💰 🛡) are all lifted directly from `src/Dashboard.jsx` and `src/components/*.jsx`. The data is hand-crafted fixtures (March 2026) — the real product runs off a user-uploaded CSV. Goals, Subscriptions, Equity, and Settings are left as empty-state routes.
