---
title: "Entities (Layer 2)"
type: moc
status: active
created: 2026-07-10
tags: [moc, entity]
---

# Entities

People, organizations, tools, models, and products. See [[t-person]] for the person template.

## Bridge to Legacy People

The existing person notes live in [[Areas/People/]] — 33+ individuals. These will gradually be migrated to this directory.

```dataview
LIST FROM "2-notes/entities"
WHERE type = "entity"
SORT updated DESC
```
