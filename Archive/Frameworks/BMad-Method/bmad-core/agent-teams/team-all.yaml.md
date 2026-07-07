---
title: "team all"
date: 2025-07-20
source_file: "3. Personal\DEV\BMAD-METHOD-main\bmad-core\agent-teams\team-all.yaml"
source_type: yaml
tags: [personal]
area: Areas
status: active
confidence: 0.5
imported: 2026-05-14
---

```yaml
bundle:
  name: Team All
  icon: 👥
  description: Includes every core system agent.
agents:
  - bmad-orchestrator
  - '*'
workflows:
  - brownfield-fullstack.yaml
  - brownfield-service.yaml
  - brownfield-ui.yaml
  - greenfield-fullstack.yaml
  - greenfield-service.yaml
  - greenfield-ui.yaml

```
