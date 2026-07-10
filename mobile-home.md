---
title: "Mobile Home"
type: moc
status: evergreen
created: 2026-07-07
updated: 2026-07-07
tags: [mobile, home, dashboard]
aliases: [mobile-home, 📱]
---

# 📱 Mobile Home

> Your Second Brain, tuned for small screens. Open this on iPhone/Android.
> Pin this note: drag right edge → Pin, or star it in the file explorer.

---

## ⚡ Quick Actions

- [ ] **Today's note** → [[2-notes/daily/]]
- [ ] **Quick capture** → use QuickAdd button in toolbar
- [ ] **Search vault** → pull down or tap search icon

---

## 📥 Inbox (Needs Processing)

```dataview
LIST
FROM "0-inbox/fleeting"
SORT created DESC
LIMIT 5
```

*If empty: nothing to process. Keep capturing!*

---

## 📅 Today

```dataview
TASK
FROM "2-notes/daily"
WHERE !completed AND contains(file.name, dateformat(date(today), "yyyy-MM-dd"))
LIMIT 10
```

---

## 🔥 Active Projects

```dataview
LIST
FROM "2-notes/projects"
WHERE status != "archived"
SORT updated DESC
LIMIT 5
```

---

## 🧠 Recent Atoms

```dataview
LIST
FROM "2-notes/atoms"
SORT updated DESC
LIMIT 5
```

---

## 🤖 Agent Inbox

*Drop requests for Claude Code / Codex / Hermes here. Synced back from mobile → agent picks up on desktop.*

```dataview
LIST
FROM "Agent Inbox"
SORT created DESC
LIMIT 5
```

*How to use: Create a new note in "Agent Inbox/" with your request. Desktop agent processes it next run. Results appear in vault and sync back to mobile.*

---

## 📊 Vault Stats

```dataview
TABLE length(rows) AS "Count"
FROM ""
GROUP BY "Total Notes"
```

---

## 🔗 Key Links

- [[index]] — full desktop home
- [[mobile-setup|📖 Mobile Setup Guide]] — sync & install instructions
- [[SCHEMA]] — vault conventions
- [[log]] — recent changes
- [[2-notes/areas/|Areas]] — ongoing responsibilities
- [[2-notes/projects/|Projects]] — active work
- [[3-knowledge/|Knowledge]] — evergreen concepts

---

*Last synced: `= dateformat(date(now), "yyyy-MM-dd HH:mm")`*
