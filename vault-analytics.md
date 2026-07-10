---
title: "Dashboard — Vault Analytics"
type: moc
status: evergreen
created: 2026-07-07
updated: 2026-07-07
tags: [dashboard, analytics]
---

# 📊 Vault Analytics

> High-level stats across the entire Second Brain. For daily pulse, see [[dashboard-home|Home Dashboard]].

## 📝 Total Notes by Type

```dataview
TABLE length(rows) AS "Count"
FROM "1-raw" OR "2-notes" OR "3-knowledge"
WHERE type
GROUP BY type
SORT length(rows) DESC
```

## 📈 Notes Created per Week

```dataview
TABLE length(rows) AS "New Notes"
FROM "1-raw" OR "2-notes" OR "3-knowledge"
WHERE file.cday
GROUP BY dateformat(file.cday, "yyyy-'W'WW") AS "Week"
SORT Week DESC
LIMIT 26
```

## 🔗 Most-Linked Notes

Notes with the highest number of backlinks — the conceptual hubs of your vault.

```dataview
TABLE length(file.inlinks) AS "Inlinks", length(file.outlinks) AS "Outlinks"
FROM "1-raw" OR "2-notes" OR "3-knowledge"
WHERE length(file.inlinks) > 0
SORT length(file.inlinks) DESC
LIMIT 20
```

## 👻 Orphans

Notes that have zero inbound links — candidates for connection or archival.

```dataview
TABLE file.mtime AS "Last Modified", (date(today) - file.mtime).days AS "Days Stale"
FROM "1-raw" OR "2-notes" OR "3-knowledge"
WHERE length(file.inlinks) = 0 AND file.name != "index"
SORT file.mtime ASC
LIMIT 30
```

## 🏷️ Tag Distribution

```dataview
TABLE length(rows) AS "Count"
FROM "1-raw" OR "2-notes" OR "3-knowledge"
FLATTEN file.tags AS tag
WHERE tag
GROUP BY tag
SORT length(rows) DESC
LIMIT 30
```

## 🤖 Agent Activity by Day

Code session summaries generated per day.

```dataview
TABLE length(rows) AS "Sessions"
FROM "1-raw/code-sessions"
WHERE file.cday
GROUP BY file.cday AS "Date"
SORT Date DESC
LIMIT 30
```

## 🗂️ Folder Size Breakdown

```dataview
TABLE length(rows) AS "Notes"
FROM "1-raw" OR "2-notes" OR "3-knowledge"
GROUP BY regexreplace(file.folder, "^.*/([^/]+)$", "$1") AS "Folder"
SORT length(rows) DESC
LIMIT 30
```

## 📏 Vault Totals

```dataview
TABLE
  length(filter(file.tasks.completed, (t) => t)) AS "Tasks Completed",
  length(filter(file.tasks, (t) => !t.completed)) AS "Tasks Open",
  length(flat(filter(file.lists, (l) => meta(l.section).subpath = "Decisions Made"))) AS "Decisions Logged"
FROM "/"
WHERE file.name = "index"
FLATTEN (SELECT file.tasks FROM "/") AS _
```

## 🔗 Quick Links

- [[dashboard-home|Home Dashboard]]
- [[vault-analytics|Vault Analytics]] ← you are here
- [[index|Home]]
- [[SCHEMA|Schema Reference]]
