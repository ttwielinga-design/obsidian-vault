---
title: "Agent Knowledge Graph"
type: moc
status: active
created: 2026-07-15
updated: 2026-07-15
tags: [agent, knowledge-graph, cross-agent, moc]
agent_visibility: summary
---

# Agent Knowledge Graph MOC

> **Purpose:** Track agent specializations, recurring patterns, cross-agent insights, and knowledge transfer. Updated nightly by the cross-agent synthesis cron job and incrementally by the evening wrap-up.

## Agent Specializations

### Claude Code
- **Strengths:** Full-stack development, complex refactoring, architectural reasoning
- **Patterns observed:** _None yet — 0 sessions logged since vault creation._
- **Last session:** _N/A_

### Codex
- **Strengths:** Feature development, PR generation, code review
- **Patterns observed:** _None yet — 0 sessions logged since vault creation._
- **Last session:** _N/A_

### Hermes Agent
- **Strengths:** Vault automation, cron orchestration, email archiving, daily briefings
- **Patterns observed:**
  - Evening wrap-up consistently finds 0 code sessions from other agents
  - Hermes is the only agent actively writing to the vault
  - Cron job resilience: gaps occur when host is offline (e.g., Jul 12-15, 2026)
- **Last session:** 2026-07-15 (evening wrap-up)

## Cross-Agent Insights

- **Knowledge transfer:** No cross-agent transfers detected yet.
- **Convention discovery:** Hermes automation follows the daily rhythm quartet pattern (morning note → briefing → evening wrap-up → nightly synthesis).
- **Conflict/resolution:** No conflicts to report.

## Related Atoms

- [[cross-agent-knowledge-base]]
- [[cross-agent-handoff-protocol]]
- [[agent-learning-transfer-loop]]

## Last Synthesis

- **Date:** 2026-07-15
- **By:** Hermes (nightly cross-agent synthesis cron)
- **Summary:** 0 code sessions across all agents (0 Claude Code, 0 Codex, 0 Hermes coding). Vault dormant Jul 12-15 — 4-day cron gap. Hermes remains sole active agent. No cross-agent patterns to synthesize. Missing base atom recreated (pitfall #13).

---

## Agent Knowledge Graph

```dataview
TABLE agent, status, created
FROM "2-notes/atoms"
WHERE contains(tags, "cross-agent") OR contains(tags, "agent")
SORT created DESC
```
