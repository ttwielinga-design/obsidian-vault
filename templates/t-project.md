---
title: "{{title}}"
type: project
status: planning
created: <% tp.date.now('YYYY-MM-DD') %>
updated: <% tp.date.now('YYYY-MM-DD') %>
tags: [project]
repo: 
deadline: 
agent_visibility: full
---

# {{title}}

## Objective
<!-- One sentence: what success looks like -->


## Key Results
<!-- Measurable outcomes with checkboxes -->

- [ ] KR1: 
- [ ] KR2: 
- [ ] KR3: 


## Timeline
<!-- Key milestones and dates -->

| Milestone | Target Date | Status |
|-----------|-------------|--------|
| | | |


## Agent Sessions
<!-- Auto-populated from code-sessions — DO NOT EDIT MANUALLY -->
<!-- AGENT_SECTION:code-sessions -->

```dataview
TABLE agent, key_decisions, duration_minutes
FROM "1-raw/code-sessions"
WHERE project = "{{title}}"
SORT created DESC
```


## Notes
<!-- Free-form project notes -->


