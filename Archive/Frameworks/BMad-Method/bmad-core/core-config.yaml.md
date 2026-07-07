---
title: "core config"
date: 2025-07-20
source_file: "3. Personal\DEV\BMAD-METHOD-main\bmad-core\core-config.yaml"
source_type: yaml
tags: [personal]
area: Areas
status: active
confidence: 0.5
imported: 2026-05-14
---

```yaml
markdownExploder: true
prd:
  prdFile: docs/prd.md
  prdVersion: v4
  prdSharded: true
  prdShardedLocation: docs/prd
  epicFilePattern: epic-{n}*.md
architecture:
  architectureFile: docs/architecture.md
  architectureVersion: v4
  architectureSharded: true
  architectureShardedLocation: docs/architecture
customTechnicalDocuments: null
devLoadAlwaysFiles:
  - docs/architecture/coding-standards.md
  - docs/architecture/tech-stack.md
  - docs/architecture/source-tree.md
devDebugLog: .ai/debug-log.md
devStoryLocation: docs/stories
slashPrefix: BMad

```
