---
title: "Personal Finance Dashboard User Manual"
date: 2026-04-16
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/software]
status: active
source_file: "3. Personal/Personal Finance/Personal finance dashboard/docs/user-manual.md"
source_type: md
confidence: 0.8
imported: 2026-05-14
---

# Personal Finance Dashboard User Manual

## What This Dashboard Is For

This dashboard is a browser-based personal finance workspace for reviewing monthly bank exports, categorizing transactions, tracking cash flow, monitoring net worth, and keeping a simple investment portfolio overview.

It is especially suited to:

- Monthly personal finance reviews
- Dutch bank CSV analysis, especially Rabobank-style exports
- Tracking salary, rental income, living costs, and transfers
- Maintaining a rolling net worth history without a backend
- Building a repeatable labeling system that gets smarter over time

It is less suited to:

- Live bank syncing
- Multi-user collaboration
- Automatic stock price updates
- Tax filing without manual verification
- Enterprise accounting or bookkeeping

## How It Works

The app is fully client-side:

- It runs in your browser
- It stores data in browser `localStorage`
- It does not require a server or database
- Your CSVs, settings, rules, and portfolio stay on the device and browser profile you use

Important consequence:

- `npm run dev` and `npm run preview` use different browser origins, so their stored data is separate
- Clearing browser storage will remove your local dashboard data unless you exported a backup first

## What You Need

Before you start, make sure you have:

- Node.js installed
- `npm` available in your terminal
- A CSV export from your bank

This project already includes the frontend dependencies in `package.json`.

## How To Run The Dashboard

From the project root:

```bash
npm install
npm run dev
```

Then open the local URL shown by Vite in your browser, usually something like:

```text
http://localhost:5173
```

Other useful commands:

```bash
npm run build
npm run preview
npm test
npm run lint
```

What they do:

- `npm run dev`: starts the local development server
- `npm run build`: creates a production build in `dist`
- `npm run preview`: serves the production build locally
- `npm test`: runs the project test suite
- `npm run lint`: checks the codebase with ESLint

## First-Time Setup

When you open the app for the first time, it may look mostly empty. That is normal. The usual first setup flow is:

1. Run the app locally.
2. Upload a bank CSV.
3. Review uncategorized transactions.
4. Open Settings and adjust your financial assumptions.
5. Add or update your portfolio holdings.
6. Export a backup after your first clean setup.

## Supported Import Format

The CSV parser expects a Dutch bank export with fields such as:

- `Volgnr`
- `Datum`
- `Tegenrekening IBAN/BBAN`
- `Naam tegenpartij`
- `Naam initiërende partij`
- `Code`
- `Bedrag`
- `Saldo na trn`
- `Omschrijving-1`

The current parser is designed around comma-separated CSV input and reads the file as `ISO-8859-1`, which is common for Dutch bank exports.

Best practice:

- Export one month at a time when possible
- Keep the original bank column names unchanged
- Do not manually reformat the file before upload unless necessary

## How To Upload A CSV

You can upload from:

- The top bar via `Upload CSV`
- Empty-state prompts in the overview and cash flow sections

What happens on upload:

1. The CSV is parsed into transactions.
2. Transactions are grouped by month using the `YYYY-MM` part of the date.
3. The dashboard tries to auto-categorize them using built-in logic, saved rules, and learned labels.
4. The latest imported month becomes the selected month.

If the uploaded file contains a month that already exists:

- The dashboard shows a warning
- You can cancel the upload or replace the stored month with the new file

## Your Monthly Workflow

The most effective way to use the dashboard is:

1. Upload the latest monthly CSV.
2. Check the red review indicator if there are uncategorized transactions.
3. Open the `Transactions` section or the `Review Queue`.
4. Label uncategorized items.
5. Accept useful bulk matches when offered.
6. Review `Overview` and `Cash Flow`.
7. Update portfolio values if needed.
8. Export a backup.

This gives you a consistent month-end finance review process.

## Understanding Auto-Categorization

The app categorizes transactions using several layers:

1. Own-account detection for transfers between your own IBANs
2. Learned IBAN mappings
3. Learned counterparty-name mappings
4. Saved rules
5. Built-in keyword and IBAN heuristics

If nothing matches, the transaction stays `Uncategorized`.

If multiple saved rules match with different categories, the transaction becomes `Conflicted` and must be reviewed manually.

## Categories Used By The Dashboard

The app currently works with categories such as:

- `Income — Salary`
- `Income — Rental`
- `Income — Side`
- `Government Benefit`
- `Other Income`
- `Housing`
- `Utilities`
- `Insurance`
- `Taxes`
- `Groceries`
- `Dining & Going Out`
- `Transport`
- `Health & Fitness`
- `Vacation`
- `Clothing & Accessories`
- `Home Decor & Furnishings`
- `Shopping`
- `Personal Development`
- `Subscriptions`
- `Investments`
- `Other Expense`
- `Transfer`
- `Uncategorized`

These categories drive the dashboard totals, savings rate, budget tracking, and briefing outputs.

## How To Review Transactions

Go to the `Transactions` section to:

- Filter by category
- Search by name, description, or IBAN
- Filter by amount range
- Review paginated transaction lists
- Manually change a transaction category

If you change a category:

- The app stores it as a manual override for that transaction
- An undo toast appears briefly

This is useful when a one-off transaction should not teach the system a broader pattern.

## How The Review Queue Works

When there are uncategorized or conflicted items, the dashboard highlights them in a dedicated `Review Queue`.

Use the queue when you want to clean up imports quickly.

It helps you:

- Focus only on transactions that need attention
- Resolve conflicting rules manually
- Apply one category to many similar transactions
- Export your learned labels afterward

When the app notices a reusable pattern, it can offer a bulk assignment and save a rule for future imports.

## Labels, Rules, And Learning

There are two related concepts in the app:

- Memory: learned mappings for names and IBANs
- Rules: reusable matching rules, especially for description prefixes and bulk matches

Why this matters:

- Memory helps with recurring counterparties
- Rules help with repeating transaction patterns
- Both make future imports cleaner and faster

Over time, your dashboard should require less manual cleanup each month.

## Importing And Exporting Labels

From the overflow menu or review workflow, you can:

- `Import Labels`
- `Export Labels`

Use label export when:

- You want to preserve your learned classification logic
- You want to move label logic to another browser profile
- You want a lightweight backup of categorization memory only

Use full backup export when:

- You want to preserve everything, not just labels

## Backups And Restore

The dashboard supports full JSON backup export and restore.

Backup includes:

- Imported months
- Settings
- Portfolio
- Saved rules
- Learned memory
- Manual overrides
- Net worth history
- Last CSV filename
- Current view mode

How to back up:

1. Open the overflow menu in the top bar.
2. Choose `Export backup`.
3. Save the downloaded JSON file somewhere safe.

How to restore:

1. Open the overflow menu.
2. Choose `Restore backup`.
3. Select a previously exported backup JSON.
4. Confirm the restore.

Important:

- Restore replaces your current dashboard data
- It is not a merge
- If you are unsure, export a fresh backup before restoring

## Using The Main Sections

### Overview

Use `Overview` for the monthly summary:

- Net worth snapshot
- Cash, property, investments, and mortgage context
- Rule progress against goals such as savings rate and investing
- High-level signals on whether the month looks healthy

This is the best place for a quick monthly check-in.

### Cash Flow

Use `Cash Flow` when you want to understand how money moved.

It supports:

- `This Month`
- `Year to Date`
- `vs Last Year`

This section is best for:

- Seeing spending by category
- Comparing current performance with prior periods
- Checking surplus and savings rate
- Monitoring budget pressure

### Portfolio

Use `Portfolio` to track your investment holdings manually.

You can maintain:

- Ticker
- Name
- ISIN
- Exchange
- Quantity
- Average buy price
- Current price
- Target weight
- TER

This section calculates:

- Portfolio total
- Profit and loss
- Profit and loss percentage
- Weighted average TER
- Sleeve mix across equity and real assets

Important:

- Prices are not pulled automatically
- You need to update current prices manually

### Transactions

Use `Transactions` for the detailed audit trail:

- Search specific payments
- Fix wrong categories
- Investigate one-off spikes
- Review all items in a selected month

This is the most useful section when the dashboard totals do not look right.

## Month Selector And Historical Navigation

The month selector in the top bar lets you:

- Switch between stored months
- Move left and right through time
- Open a dropdown with month summaries
- Remove a stored month

Use this when you want to compare months or clean up historical data.

Important:

- Removing a month deletes it from the stored data
- This cannot be undone unless you have a backup

## Settings You Should Review

Open `Settings` from the sidebar to configure the assumptions behind the dashboard.

Key settings include:

- Savings rate target
- Monthly investment target
- Emergency fund target and current balance
- House market value
- WOZ value
- Mortgage outstanding balance
- Mortgage payment
- Mortgage interest rate
- Salary growth assumption
- Investment return assumptions
- Cost inflation
- Passive income target
- Net worth goal
- Rental income
- Monthly budgets by category

These values affect projections, net worth calculations, and planning widgets, so they should be updated periodically.

## Budget Tracking

The dashboard supports monthly budgets for selected categories such as:

- Groceries
- Dining & Going Out
- Transport
- Health & Fitness
- Vacation
- Shopping
- Clothing & Accessories
- Personal Development
- Subscriptions
- Utilities
- Insurance

Use this when you want lightweight spending control rather than full envelope budgeting.

Best use:

- Set budgets for variable spending categories
- Review them during or after each month
- Adjust if repeated overspending shows up

## Net Worth And Projection Features

The dashboard estimates net worth from:

- Latest cash balance from the uploaded month
- House value from settings
- Portfolio value from manually maintained holdings
- Mortgage balance from settings and amortization assumptions

It also builds a historical net worth series based on stored months.

This is useful for:

- Tracking long-term progress
- Visualizing momentum
- Stress-testing planning assumptions

Remember:

- Property value is assumption-based
- Mortgage and portfolio values are only as accurate as your inputs

## Briefings And Tax Notes

The overflow menu provides:

- `Copy Briefing`
- `Briefing Preview`
- `Copy Tax Briefing`

These are useful for:

- Monthly journaling
- Personal finance reviews
- Sending yourself a summary
- Preparing for deeper tax review

Important caution:

- The tax briefing is indicative only
- It should not be treated as tax advice
- Always verify tax-related conclusions manually or with an advisor

## Best Use Cases

This dashboard works best when you want:

- A personal monthly money review ritual
- A lightweight net worth tracker
- Better transaction categorization over time
- A manual but clear overview of spending and investing
- A private, local-only finance tool without cloud sync

It is a strong fit if you:

- Prefer exporting CSVs from your bank manually
- Want full control over your data
- Are comfortable updating assumptions and portfolio values yourself
- Care more about monthly insight than accounting perfection

## Tips For Best Results

- Upload regularly, ideally once per month
- Resolve uncategorized items immediately after import
- Use backups before making major changes
- Export labels once your recurring mappings are in good shape
- Keep your settings realistic so projections stay useful
- Update current portfolio prices before relying on net worth charts
- Use the transaction search when totals feel off

## Limitations To Keep In Mind

- No bank API integration
- No automatic market data
- No cloud backup
- No shared accounts or multi-user workflows
- Data depends on the browser profile and origin you use
- CSV import is format-sensitive
- The portfolio and property valuations are manual inputs

## Troubleshooting

### The app opens but shows no data

Possible causes:

- You have not uploaded a CSV yet
- You are using a different browser than before
- You switched between `dev` and `preview`
- Browser storage was cleared

What to do:

- Upload a CSV again
- Restore a backup if you have one

### My old data is gone after switching environments

This usually happens because `localhost` origins differ between dev and preview.

What to do:

- Return to the environment you used before
- Or restore a backup into the current one

### The CSV does not import correctly

Possible causes:

- The bank export format changed
- Required columns are missing or renamed
- The file was edited into a different delimiter or encoding

What to do:

- Re-export directly from the bank
- Avoid manual spreadsheet reformatting
- Compare the CSV columns with the expected headers in this manual

### Too many transactions are uncategorized

What to do:

- Open the review queue
- Label recurring counterparties
- Accept bulk matches where appropriate
- Export labels after cleanup

This usually improves future imports quickly.

### Restore feels risky

That is a good instinct, because restore replaces all current data.

Safe workflow:

1. Export a fresh backup first.
2. Restore the old backup.
3. Check the result.
4. Restore your fresh backup if needed.

## Recommended Operating Routine

For ongoing use, this is a practical routine:

1. At the end of each month, export your latest bank CSV.
2. Upload it to the dashboard.
3. Clear the review queue.
4. Check overview, cash flow, and budgets.
5. Update portfolio prices and holdings.
6. Export a full backup.
7. Optionally copy the monthly briefing into your notes.

## File References

If you want to inspect or extend the implementation, the most relevant files are:

- [README.md](../README.md)
- [docs/data-contracts.md](./data-contracts.md)
- [src/Dashboard.jsx](../src/Dashboard.jsx)
- [src/lib/csv.js](../src/lib/csv.js)
- [src/lib/classification.js](../src/lib/classification.js)
- [src/lib/backup.js](../src/lib/backup.js)

## Short Version

If you only remember five things, remember these:

1. Run the app with `npm run dev`.
2. Upload one monthly bank CSV at a time.
3. Clean up uncategorized items after every import.
4. Keep settings and portfolio values current.
5. Export backups regularly because all data is local.
