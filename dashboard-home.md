---
title: "Dashboard — Home"
type: moc
status: evergreen
created: 2026-07-07
updated: 2026-07-07
tags: [dashboard, home]
---

# 🏠 Home Dashboard

> Auto-updating snapshot of what needs attention. Refresh with `Ctrl+R` in reading view.

## ⚠️ Overdue Tasks

```dataview
TASK
FROM "2-notes"
WHERE !completed AND due AND due < date(today)
SORT due ASC
LIMIT 20
```

## 🧠 Recent Atoms

```dataview
TABLE file.mtime AS "Modified", length(file.outlinks) AS "Links Out"
FROM "2-notes/atoms"
SORT file.mtime DESC
LIMIT 10
```

## 🕸️ Stale Notes

Notes with no modifications in 30+ days (excluding archive and templates).

```dataview
TABLE file.mtime AS "Last Modified", (date(today) - file.mtime).days AS "Days Stale"
FROM "1-raw" OR "2-notes" OR "3-knowledge"
WHERE (date(today) - file.mtime).days > 30
SORT file.mtime ASC
LIMIT 20
```

## 🤖 Agent Activity Today

```dataview
TABLE file.ctime AS "Generated", file.size AS "Size"
FROM "1-raw/code-sessions"
WHERE file.cday = date(today)
SORT file.ctime DESC
```

## 📋 Open Project Tasks

```dataview
TASK
FROM "2-notes/projects"
WHERE !completed
GROUP BY file.link
SORT file.name ASC
```

## 🔗 Quick Links

- [[dashboard-home|Home Dashboard]] ← you are here
- [[vault-analytics|Vault Analytics]]
- [[index|Home]]
- [[SCHEMA|Schema Reference]]
