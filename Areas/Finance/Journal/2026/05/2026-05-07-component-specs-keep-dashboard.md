---
title: "Component specs — Keep dashboard"
date: 2026-05-07
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/software]
status: active
source_file: "3. Personal/Personal Finance/Personal finance dashboard/docs/COMPONENT_SPECS.md"
source_type: md
confidence: 0.8
imported: 2026-05-14
---

# Component specs — Keep dashboard

> **Use:** spec sheet for porting `ui_kits/dashboard/*.jsx` into typed
> production components. Each entry lists props, states, dimensions, tokens
> used, and acceptance checks.
>
> **Authority:** if this file disagrees with `ui_kits/dashboard/`, the kit
> wins. This is a summary; the kit is the source.

---

## Chrome

### `<Sidebar />`
- **Width:** 240px. Sole nav surface — collapses to 0 below 900px viewport.
- **Background:** `var(--bg-1)`. **Right border:** `1px solid var(--border)`.
- **Groups:** "Money" eyebrow → Overview / Cash Flow / Portfolio / Transactions. "Planning" eyebrow → Goals / Subscriptions / Equity. "Review" eyebrow → Review Queue.
- **Eyebrows:** `.t-eyebrow` — 10px / 600 / 0.08em tracking / uppercase / `var(--text-muted)`.
- **Nav item active:** 2px left accent bar + `var(--accent-bg)` fill + `var(--accent)` text.
- **Nav item hover (inactive):** `var(--bg-2)` fill, no border change.
- **Badges:** `<span className="chip chip-red">N</span>` on Transactions and Review Queue when uncategorized count > 0.
- **Keyboard chord pills:** monospace, 10px, `var(--bg-2)` bg, `var(--border)` border, 4px radius.

### `<TopBar />`
- **Sticky** to top of `<main>`. Height: 44px (10px top/bottom padding + content).
- **Background:** `var(--bg-1)`. **Bottom border:** `1px solid var(--border)`.
- **Left:** screen title (`.t-title` — 14px / 600).
- **Right:** period selector (bordered pill: `1px solid var(--border)`, `var(--r-m)`, `0 4px` padding) + ⌘K palette trigger + icon buttons (22px height).
- **No back/forward history arrows.** Primary nav is sidebar + Command Palette (⌘K) + `g o/c/p/t` chords.
- **TopBar overflow ⋯** — secondary actions in three groups: Briefing (Copy Briefing, Briefing Preview, Tax Briefing — visible only when transactions are loaded), Data (Backup data, Restore backup), Labels (Import Labels, Export Labels). All items mirrored in the Command Palette.

### `<StatusBar />`
- **Position:** fixed bottom, full width minus sidebar offset.
- **Height:** 22px. **Background:** `var(--bg-1)`. **Top border:** `1px solid var(--border)`.
- **Left content:** telegraphic mono — `Net worth €284.500 · Surplus +€1.240 · Savings 28,4%`.
- **Right content:** `v0.12.3 · local-only` in `var(--text-faint)`, mono 11px.
- **Font:** mono 11px, `var(--text-muted)`.

---

## Primitives

### `<Button variant>`
- Variants: `primary` | `outline` | `ghost` | `danger`.
- Height: 28px (default), 32px (lg), 24px (sm). Padding: `0 12px`.
- Radius: `var(--r-m)` (6px). Font: UI 13px / 500.
- **Primary:** bg `var(--accent)`, hover `var(--accent-hover)`. No shadow.
- **Outline:** border `var(--border)`, hover border `var(--border-strong)` + bg `var(--bg-2)`.
- **Ghost:** transparent, hover bg `var(--bg-2)`, text muted → full.
- **Danger:** bg `var(--red)`, text `var(--bg-0)`. Use for destructive only.
- **Focus:** `outline: 2px solid var(--accent); outline-offset: 2px`.

### `<Chip variant>`
- Variants: `neutral` | `accent` | `green` | `amber` | `red`.
- Radius: `999px`. Padding: `2px 8px`. Font: 11px / 500.
- Bg: `var(--{hue}-bg)`. Border: `1px solid var(--{hue}-border)`.
- Text: `var(--{hue})` for colored, `var(--text-muted)` for neutral.

### `<Callout variant>`
- Variants: `accent` | `green` | `amber` | `red`.
- **The one place a colored left-border accent is on-brand.**
- Bg: `var(--bg-2)`. Left border: `3px solid var(--{hue})`. Radius: `var(--r-m)`.
- Padding: `12px 16px`. Title 13px/600, body 13px/400.

### `<Input />`
- Height: 28px. Padding: `0 10px`. Radius: `var(--r-m)`.
- Bg: `var(--bg-2)`. Border: `1px solid var(--border)`.
- Focus: border `var(--accent)`, no glow.
- Mono variant for IBAN / amounts.

### `<KpiCard label value delta>`
- Bg: `var(--bg-2)`. Border: `1px solid var(--border)`. Radius: `var(--r-l)` (8px).
- Padding: `16px 20px`.
- Label: `.t-label` (uppercase 11px/600, 0.08em tracking).
- Value: `.t-display` + mono (22px/500, tabular-nums).
- Delta: chip below value (green/red/neutral).

### `<Table />`
- Header: `var(--bg-1)`, sticky. Font: 11px/600 muted, uppercase.
- Row: 36px tall. Bottom border `1px solid var(--border)`.
- Hover: `.row-hover` → `var(--bg-2)` fill.
- Zebra: every other row `var(--zebra)` (2% white).
- All numbers right-aligned and mono.

---

## Overlays

### `<CommandPalette />`
- **Trigger:** `⌘K` / `Ctrl+K`. **Close:** `Esc`.
- Width: 560px. Top offset: 120px. Centered horizontally.
- Bg: `var(--bg-2)`. Border: `1px solid var(--border)`. Radius: `var(--r-l)`.
- Shadow: `var(--shadow-pop)`.
- Animation: `scaleIn` 0.97→1 with opacity, 200ms `var(--ease)`.
- Search input: 14px, mono icons, fuzzy match across routes + actions.
- Result row: 36px, hover `var(--bg-3)`.

### `<ShortcutsOverlay />`
- **Trigger:** `?` (when not in input). **Close:** `Esc`.
- Modal centered, dim overlay `rgba(0,0,0,0.55)` (no blur).
- Bg: `var(--bg-2)`. Shadow: `var(--shadow-modal)`. Radius: `var(--r-l)`.
- Lists: `⌘K`, `g o/c/p/t`, `?`, `Esc`, `←/→` — each rendered as monospace pill.

---

## Acceptance per component

For every ported component, verify:
1. All dimensions match the kit ±1px at 1440px viewport.
2. All colors resolve to CSS variables (no inline hex).
3. All text uses one of `.t-meta` / `.t-label` / `.t-body` / `.t-body-strong` /
   `.t-title` / `.t-heading` / `.t-display` (or the mono equivalents).
4. Hover/focus/active states match the kit's interactions.
5. No drop shadow except popovers/modals.
6. No new icons. No new colors. No new radii.
