---
title: "Daily Notes (Layer 2)"
type: moc
status: active
created: 2026-07-10
updated: 2026-07-10
tags: [moc, daily]
members: []
---

# Daily Notes

New daily notes should be created here following the `t-daily` template from [[templates/]].

## Bridge to Legacy Daily

The existing daily journal lives in [[Daily/]] — organized as `YYYY/MM/YYYY-MM-DD.md` spanning 2018–2026 (321 entries).

Going forward, new daily notes will be created here as flat `YYYY-MM-DD.md` files. See [[t-daily]] for the template with agent sections.

```dataview
LIST FROM "2-notes/daily"
WHERE type = "daily"
SORT file.name DESC
LIMIT 30
```
