# Agent Visibility System

This directory contains agent-side utilities for the `agent_visibility` frontmatter protocol defined in SCHEMA.md.

## How It Works

Every wiki note carries an `agent_visibility` field in its YAML frontmatter:

| Value     | Agent Behavior |
|-----------|---------------|
| `summary` (default) | Read frontmatter + first `##` section only |
| `full`    | Read the entire note |
| `hidden`  | Skip this note entirely. Exclude from search results and link traversal. |

## Agent Integration Checklist

When an agent reads from this vault, it MUST:

1. **Before reading any note:** Check `agent_visibility` from frontmatter
2. **Hidden notes:** Skip entirely (don't include in search results, MOC members, or link chains)
3. **Summary notes:** Read only frontmatter + first section. Use the rest as reference only if needed.
4. **Full notes:** Read and process the entire note freely.
5. **Unspecified:** Default to `summary` (safe default prevents context explosion).
6. **Default override:** Code sessions, MOCs, concepts, principles, comparisons, and queries default to `full`. Atoms, entities, and daily notes default to `summary`.

## File Structure

```
_agent/
├── README.md                  # This file
└── summaries/                 # Curated agent-friendly summaries (future)
```
