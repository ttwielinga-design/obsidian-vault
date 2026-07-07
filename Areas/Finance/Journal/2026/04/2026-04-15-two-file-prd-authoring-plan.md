---
title: "Two-File PRD Authoring Plan"
date: 2026-04-15
type: journal
area: finance
tags: [type/journal, area/finance, status/active, topic/software]
status: active
source_file: "3. Personal/Personal Finance/PLAN.md"
source_type: md
confidence: 0.8
imported: 2026-05-14
---

# Two-File PRD Authoring Plan

## Summary
- Produce **two separate PRD files** as AI-implementation specs, not one combined document.
- Store them at:
  - `docs/prds/dashboard-frontend-prd.md`
  - `docs/prds/dashboard-backend-prd.md`
- Use the `prd-writing` skill workflow: context grounding, targeted subagent drafting, multi-perspective review, then main-agent synthesis.
- Optimize for the choices already locked:
  - split by `UX vs Data/Logic`
  - prioritize `high-impact now`
  - keep quotes `manual for now`
  - model Trading 212 as `tracked recurring buys`
  - add `wealth retention` instead of redefining the current savings-rate metric
  - write both docs as `AI implementation specs`

## File Outputs
- `docs/prds/dashboard-frontend-prd.md`
  - Focus on UI/UX behavior only: readability, layout, controls, charts, typography, visual hierarchy, and user flows
  - Must not redefine finance formulas or storage behavior except where UI behavior depends on them
  - Structure each major feature area in AI-agent format:
    - objective
    - non-goals
    - phased requirements
    - acceptance criteria
    - UX edge cases
    - rollout/verification notes
- `docs/prds/dashboard-backend-prd.md`
  - Focus on domain model, calculations, derived metrics, localStorage contracts, backup/restore, migrations, and future integration seams
  - Must define behavior-level logic for property, mortgage, opening cash, recurring auto-invest, historical snapshots, and metric semantics
  - Structure each major feature area in AI-agent format:
    - current state
    - target model/behavior
    - phased requirements
    - non-goals
    - acceptance criteria
    - migration/compatibility expectations

## Subagent Workflow
- Wave 1: research and outline
  - Subagent A: frontend scope mapper
    - Extract all UI-facing requirements from repo findings and prior discussion
    - Group into coherent sections for the frontend PRD
  - Subagent B: backend scope mapper
    - Extract all model/logic/storage requirements
    - Group into coherent sections for the backend PRD
  - Subagent C: shared glossary and dependency mapper
    - Produce one shared terminology sheet for both files
    - Terms must include `cash surplus`, `invested`, `wealth retention`, `purchaseMonth`, `mortgageOpeningBalance`, `networthHistory`
- Wave 2: first drafts
  - Subagent D: frontend PRD drafter
    - Draft `dashboard-frontend-prd.md` from the frontend outline and shared glossary
  - Subagent E: backend PRD drafter
    - Draft `dashboard-backend-prd.md` from the backend outline and shared glossary
- Wave 3: review
  - Subagent F: engineer reviewer
    - Review both drafts for technical ambiguity, missing dependencies, and poor AI-agent implementability
  - Subagent G: user-research reviewer
    - Review the frontend draft for UX clarity, edge cases, and adoption/readability risks
  - Executive review is optional for this pass because the docs are implementation-oriented and the scope is already prioritized
- Main agent responsibilities
  - Validate all draft claims against repo truth
  - Remove contradictions between the two files
  - Ensure no logic is duplicated inconsistently across files
  - Rewrite both docs into a single consistent voice
  - Add final changelog/version headers and ensure both files are actionable for a future coding agent

## Frontend PRD Contents
- Header and metadata
  - status `Draft`
  - version `v1.0`
  - feature type `Internal tool`
  - note that this document is an AI coding-agent execution spec
- Executive summary
  - explain that the doc covers the dashboard’s visible behavior and interaction changes only
- Problem statement
  - hard-to-read transaction/review queue UI
  - weak dropdown/control styling
  - inconsistent typography
  - awkward cash-flow visual hierarchy
  - poor portfolio table density
  - misleading `vs Last Year` UX
  - missing cash-flow timeline interaction
- Goals and non-goals
  - goals: improve readability, clarify navigation/modes, add timeline visualization, stabilize visual language
  - non-goals: no live quote sync, no broker execution, no backend architecture work beyond UI dependencies
- Phased sections
  - Phase 1: visual system
    - typography token cleanup
    - contrast hierarchy
    - focus states and dark control treatment
  - Phase 2: transaction and review queue UX
    - row hierarchy
    - category assignment control redesign
    - readable metadata and amount emphasis
  - Phase 3: portfolio UX
    - compact instrument cell combining `ISIN` and `Exchange` visually
    - denser edit row and column hierarchy
  - Phase 4: cash-flow UX
    - redesign spending mix chart
    - add timeline control `1M / 6M / YTD / 1Y / 5Y / Max`
    - fix YoY labeling and comparison presentation
- Acceptance criteria
  - controls are keyboard-focus visible
  - small labels no longer rely on low-contrast muted text
  - `vs Last Year` no longer implies unsupported behavior
  - timeline range control is independent from existing cash-flow view mode
  - portfolio table scans cleanly at desktop widths without schema simplification
- UX edge cases
  - missing prior-year data
  - sparse monthly history
  - no transactions uploaded
  - long names/IBANs/ISINs
  - uncategorized/conflicted transactions
- Verification section
  - screenshot-based visual checks
  - browser validation in dev/preview
  - acceptance checks for empty, sparse, and dense states

## Backend PRD Contents
- Header and metadata
  - status `Draft`
  - version `v1.0`
  - feature type `Internal tool`
  - note that this document is an AI coding-agent execution spec
- Executive summary
  - explain that the doc covers data behavior, financial semantics, storage, and compatibility only
- Problem statement
  - property and mortgage semantics are under-modeled
  - opening cash is implicit instead of explicit
  - historical net worth uses ambiguous assumptions
  - metric naming mixes cash and wealth concepts
  - recurring investment tracking is missing
- Goals and non-goals
  - goals: explicit opening/property model, stable monthly derivations, precise metric semantics, tracked recurring auto-invest
  - non-goals: no live quotes in v1, no broker automation, no server-side platform introduction in this PRD
- Phased sections
  - Phase 1: property and opening-state model
    - introduce explicit property/opening fields
    - stop overloading `mortgageOutstanding`
    - define monthly mortgage derivation behavior
  - Phase 2: net-worth and metric semantics
    - preserve `surplus`
    - add `wealthRetentionRate`
    - define relation among cash balance, invested amount, and retained wealth
  - Phase 3: historical consistency
    - define `networthHistory` recomputation rules
    - remove implicit starting-cash fallback
    - clarify selected-month vs latest-month behavior
  - Phase 4: recurring auto-invest tracking
    - add `settings.autoInvest`
    - define execution idempotency with `lastExecutedMonth`
    - define how synthetic `Investments` transactions affect cash-flow and holdings
  - Phase 5: storage and compatibility
    - defaults changes
    - backup/restore changes
    - migration expectations for older local data
- Important interface/type additions
  - property/opening-state fields under settings
  - `wealthRetentionRate` as a derived metric
  - `settings.autoInvest` with recurring-plan metadata
  - optional future-facing quote seam documented as non-goal for v1
- Acceptance criteria
  - monthly net worth before property purchase behaves correctly
  - mortgage balance is derived consistently across overview/history/briefings
  - old backups restore safely with recomputed derived state where required
  - recurring auto-invest cannot double-apply the same month
  - `wealthRetentionRate` is additive from distinct components, not double-counted
- Migration and compatibility notes
  - preserve current user data where possible
  - backfill new settings from existing flat values
  - recompute derived monthly history when assumptions change materially

## Review and Finalization
- Both PRDs must include a short changelog entry for the initial draft
- Both PRDs must be reviewed together before finalization so shared concepts stay aligned
- The main agent should reject any draft section that:
  - contains generic filler not tied to this repo
  - duplicates logic inconsistently across both files
  - leaves AI-agent scope implicit
  - omits non-goals or testable acceptance criteria

## Test Plan
- Authoring quality checks
  - verify each file can stand alone without requiring the other for core understanding
  - verify cross-references use identical terminology
  - verify every major section contains explicit non-goals
- Implementation-readiness checks
  - frontend PRD can be handed to a UI-focused coding agent with no missing interaction decisions
  - backend PRD can be handed to a logic/storage-focused coding agent with no missing behavior decisions
- Consistency checks
  - same-month/YTD/YoY terms match across both files
  - `surplus`, `invested`, and `wealth retention` are defined once and reused consistently
  - property/opening-state fields match the behavior assumed by frontend screens

## Assumptions
- New PRDs should live under a new `docs/prds/` folder, alongside existing repo docs
- The frontend and backend PRDs are separate files, not sections in one master PRD
- The docs are written primarily for future AI-agent implementation, with enough clarity for humans to review them
- Quote sync stays out of v1 requirements, but the backend PRD should leave a clean extension point
- Trading 212 support in v1 means tracking recurring monthly buys in-app, not placing real broker orders
