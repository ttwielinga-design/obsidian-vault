---
title: "codex pr body"
date: 2026-04-22
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/software]
status: active
source_file: "3. Personal/Personal Finance/Personal finance dashboard/.git/codex-pr-body.md"
source_type: md
confidence: 0.8
imported: 2026-05-14
---

## Summary
- stabilize imported transaction IDs so the same bank rows keep the same identity across normal re-imports
- reconcile overrides and lot links when a month is replaced, while pruning references for rows that truly disappeared
- add regression tests covering reordered imports and replace-flow state preservation

## Root cause
The import path generated transaction IDs from positional row data. Re-importing the same logical transactions from a reordered or regenerated CSV changed those IDs, which orphaned identity-based state like manual overrides and investment lot links.

## Impact
Routine month-replace flows now preserve linked transaction state for rows that still exist, which makes repeated imports feel reliable and keeps manual cleanup work attached to the right transactions.

## Validation
- npm run lint
- npm test
- npm run build