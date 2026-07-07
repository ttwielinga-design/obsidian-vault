---
title: "vault-cleanup-spec"
date: 2026-05-14
type: reference
area: resources/reference
tags: [type/reference, area/resources/reference, status/active]
status: active
---

```

## 6. Confidence rules for Phase 1 classifiers

- **high**: filename + frontmatter + first body line agree unambiguously on the bucket.
- **medium**: bucket is likely but one signal disagrees → treat as `needs-human`.
- **low**: ambiguous → bucket MUST be `needs-human`.

## 7. What classifiers may read

## 8. Output format

```
path	bucket	proposed_new_path	reason	confidence
```

- `path` is the input path verbatim.
- `proposed_new_path` is the destination if bucket implies a move; empty string otherwise.
- `reason` is ≤120 chars, factual, no hedging.
- `confidence` is one of `high`, `medium`, `low`. Anything not `high` → `bucket=needs-human`.

## 9. What executors may do

- `Mover`: `git mv` style move only, against an explicit `src → dst` work order. No content edits.
- `Renamer`: rename only, no content edits.
- `Frontmatter-normalizer`: append missing keys; never modify existing values.
- `Merger`: move into target folder; on collision append `-dup<N>` and add row to collision log.
- `Archiver`: move to `Archive/<original-path>/` preserving sub-structure.
- `Junker`: move to `Archive/Junk/<reason>/` — used for `junk-binary`, `junk-low-confidence`, `duplicate-of`.
