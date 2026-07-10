---
title: "{{title}}"
type: moc
status: active
created: <% tp.date.now('YYYY-MM-DD') %>
updated: <% tp.date.now('YYYY-MM-DD') %>
tags: [moc]
domain:
agent_visibility: full
---

# {{title}}

<!-- Map of Content: a curated entry point into a topic area. -->
<!-- Create a MOC when 5+ atoms share a domain tag. -->

## Overview
<!-- 2-3 sentences describing this topic area -->


## Core Concepts
<!-- The most important atoms in this domain -->

- [[]] — 
- [[]] — 
- [[]] — 


## All Pages in This Domain
<!-- Expand as the vault grows -->

```dataview
LIST FROM "2-notes/atoms"
WHERE contains(tags, "{{domain}}")
SORT created ASC
```


## Related MOCs
<!-- Cross-domain connections -->

- [[]]


## Key Questions
<!-- Open questions this domain is exploring -->

- 


## Resources
<!-- Important raw materials, articles, papers in this domain -->

```dataview
LIST FROM "1-raw"
WHERE contains(tags, "{{domain}}")
SORT created DESC
```

