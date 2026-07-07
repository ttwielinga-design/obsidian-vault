---
title: "HANDOFF Verification Checklist"
date: 2026-05-07
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/software]
status: active
source_file: "3. Personal/Personal Finance/Personal finance dashboard/HANDOFF.md"
source_type: md
confidence: 0.8
imported: 2026-05-14
---

# HANDOFF Verification Checklist

Run these before every PR to verify design-system compliance.
All commands run from the repo root.

## 1. Build

```bash
npm run build
```

Must exit 0 with no errors or missing-module warnings.

## 2. Grep checks

### Inline hex outside token definitions

```bash
grep -rn '#[0-9a-fA-F]\{3,6\}' src --include='*.tsx' --include='*.jsx' --include='*.ts' --include='*.js' \
  | grep -v tokens.css \
  | grep -v 'CATEGORY_COLORS\|CAT_COLORS' \
  | grep -v 'const T = {' \
  | grep -vE '^\s*[a-zA-Z]+:\s*"#[0-9a-fA-F]+",?\s*//.*token'
```

**Expected:** no output after fixes. Known benign residuals:
- `Dashboard.jsx` — the `T` object body (lines defining the JS token palette) and `CATEGORY_COLORS` chart-series entries. These are the token definitions, not inline overrides.
- `Dashboard.jsx` — `&#9888;` HTML entity (matches hex pattern, not a color).

Any hit outside those locations must be replaced with a token before merging.

### Box-shadow outside token variables

```bash
grep -rn 'box-shadow:\|boxShadow' src \
  | grep -vE '(shadow-pop|shadow-modal|--shadow)' \
  | grep -v 'inset 3px 0 0 var(--red)'
```

**Expected:** no output.
**Known exception:** `src/styles/base.css:198` — `box-shadow: inset 3px 0 0 var(--red)` is a left-border accent stroke rendered as an inset shadow for layout reasons (not an elevation shadow). Whitelisted above.

### Network calls outside src/lib/

```bash
grep -rn 'fetch(\|XMLHttpRequest' src --include='*.jsx' --include='*.tsx'
```

**Expected:** no output. Permitted market-data fetches (`fx.js`, `priceLookup.js`, `priceService.js`, `symbolResolver.js`) live exclusively in `src/lib/` — see CLAUDE.md § Data & Privacy for the contract.

### Backdrop-filter

```bash
grep -rn 'backdrop-filter\|backdropFilter' src
```

**Expected:** no output.

### Google Fonts

```bash
grep -rn 'fonts.googleapis' src
```

**Expected:** no output. Geist and Geist Mono are self-hosted in `public/fonts/`.
Note: scope to `src/` (not `.`) — docs and worktree artifacts may reference the old CDN URL.
