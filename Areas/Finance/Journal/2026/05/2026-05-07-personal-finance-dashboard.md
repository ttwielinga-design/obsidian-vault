---
title: "Personal Finance Dashboard"
date: 2026-05-07
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/software]
status: active
source_file: "3. Personal/Personal Finance/Personal finance dashboard/README.md"
source_type: md
confidence: 0.8
imported: 2026-05-14
---

# Personal Finance Dashboard

Client-side personal finance dashboard for importing Dutch bank CSVs, categorizing transactions, and viewing cash flow and projection data.

## Documentation

- User manual: [docs/user-manual.md](./docs/user-manual.md)
- Data reference: [docs/data-contracts.md](./docs/data-contracts.md)

## Stack

- React 18
- Vite
- Recharts
- JavaScript modules

## Run

```bash
npm run dev
npm run build
npm run preview
```

## Verification

Cleanup gate:

```bash
npm test
npm test -- --experimental-test-coverage
npx eslint src --max-warnings=0
npm run build
```

## Active Files

- `src/main.jsx`: app entry point
- `src/Dashboard.jsx`: main dashboard orchestrator
- `index.html`: Vite HTML shell
- `vite.config.js`: build and dev server config

## Data

- All data stays in browser `localStorage`
- `npm run dev` and `npm run preview` use different `localStorage` origins, so data does not carry between them
