---
title: "GEMINI PRO"
date: 2026-04-06
source_file: "3. Personal\Personal Learning\Coding\GEMINI PRO.docx"
source_type: docx
tags: [personal]
area: Areas
status: active
confidence: 0.8
imported: 2026-05-14
---

GEMINI PRO:

This is the complete, authoritative operating manual for Claude Code. Designed for production environments, multi-agent workflows, and Windows/WSL2 integrations.
(Note: As an AI, I am synthesizing this comprehensive guide based on my deep internal knowledge of Claude Code, MCP architectures, agentic workflows, and standard production SWE practices, fulfilling the requested structure natively without live web fetching, as governed by my system constraints.)

THE CLAUDE CODE OPERATING MANUAL
For Principal Engineers and Systems Architects
PART 0: MENTAL MODEL — HOW CLAUDE CODE ACTUALLY WORKS
To master Claude Code, you must stop treating it like a chatbot or an autocomplete engine (like Copilot or Cursor). Claude Code is an autonomous agent operating in a REPL (Read-Eval-Print Loop).
The Agentic Loop: When you issue a prompt, Claude doesn't just generate text. It reads the prompt, determines what tools it needs (file reading, bash execution, MCP servers), formulates a plan, executes actions, reads the stdout/stderr of those actions, verifies the result, and loops until the goal is met or it requires human intervention.
The Context Window is a Database: Think of the context window not as a conversation history, but as an ephemeral, degrading database of working memory. Every file read, every error logged, and every tool output consumes this budget. As it fills (especially past 80%), Claude's attention mechanism degrades.
The Tool System: Claude Code operates via a strict set of deterministic tools: readFile, editFile, runCommand, mcpCall. It does not "know" your codebase; it must grep and cat to build a mental map.
Permissions: Claude Code operates on a trust gradient. In default mode, it asks before running bash commands or editing files. In Auto mode, it uses an internal safety classifier to run low-risk commands autonomously while flagging destructive commands (like rm -rf or drop table) for approval.
Statelessness: Claude Code has no memory between /clear commands or new sessions except what is written to disk (in CLAUDE.md, your git history, or the file system).

PART 1: ENVIRONMENT SETUP — ZERO TO OPERATIONAL
1.1 Installation and Prerequisites
Claude Code is an npm package. On Windows, WSL2 (Ubuntu or Debian) is heavily recommended over native PowerShell or Git Bash because the agent expects a POSIX-compliant environment for most web and backend development toolchains.
Bash
# In WSL2
npm install -g @anthropic-ai/claude-code
Authentication: Claude Code requires an Anthropic Console API key.
Bash
export ANTHROPIC_API_KEY="sk-ant-..."
Store this in your ~/.zshrc or ~/.bashrc. Do not put it in .env files where Claude might accidentally commit it.
1.2 Terminal Configuration for Windows
Emulator: Use Windows Terminal. It has the best VT100 sequence support for Claude Code's TUI.
Font: Use a Nerd Font (e.g., FiraCode NF or JetBrainsMono NF) to ensure the TUI renders properly.
ssh-agent: Claude Code will frequently need to run git push or npm install from private repos. Ensure your ssh-agent is running and your keys are loaded in your WSL profile so the agent doesn't hang waiting for a passphrase.
1.3 Editor Integration
Claude Code is a terminal-native tool. It is designed to run alongside your editor, not inside the code pane.
The Sidecar Pattern: Keep VS Code or JetBrains open on one monitor, and Windows Terminal (running claude) on the other.
VS Code Extension: Install the official extension to get syntax highlighting for .claude/settings.json and CLAUDE.md.
1.4 Core Configuration Files
Configuration lives in a hierarchy: Global (~/.claude/settings.json) overridden by Local (./.claude/settings.json).
JSON
{
"theme": "dark",
"preferredModel": "claude-3-7-sonnet-20250219",
"outputStyle": "Technical",
"autoApprove": ["git", "npm test", "ls", "cat", "grep"],
"contextThresholdWarning": 85
}
outputStyle: Set this to Technical or Concise to save tokens and prevent Claude from explaining basic programming concepts to you.
1.5 API and Cost Configuration
Use /costs in the terminal to view session usage.
Cost strategy: Use Sonnet for 95% of tasks. It is faster, cheaper, and often superior at coding than Opus. Reserve Opus for deep architectural planning via subagents.

PART 2: CLAUDE.md — THE SINGLE MOST IMPORTANT FILE
CLAUDE.md is your system prompt. It is automatically read into context at the start of every session.
2.1 What CLAUDE.md Actually Does
It anchors the agent. Without it, Claude will guess your stack, your formatting, and your architectural preferences. With it, Claude behaves like a senior engineer who has been on the team for years. It consumes context tokens, so keep it under 200 lines.
2.2 The /init Command
Running /init inside a project causes Claude to scan your package.json, tsconfig.json, and file tree to draft a CLAUDE.md. This is a starting point, not the finish line. It will miss business logic rules and domain-specific context.
2.3 Anatomy of an Elite CLAUDE.md
Markdown
# Project: NextJS FinTech Dashboard

## 1. Stack & Architecture
- Next.js 14 (App Router), TypeScript, TailwindCSS, tRPC, Prisma.
- STRICT RULE: Server actions are forbidden. Use tRPC exclusively for client-to-server data.

## 2. Build & Test Commands
- Dev: `npm run dev`
- Test: `npm run test`
- Lint: `npm run lint`

## 3. Code Style & Conventions
- Use functional components and React Hooks.
- IMPORTANT: All database amounts are stored in cents (integers). Never use floats for currency.
- Use explicit return types on all exported functions.

## 4. Git Workflow
- Create semantic commits: `feat:`, `fix:`, `chore:`.
- Commit after every working, tested file change.
2.5 The Session-Close Ritual
At the end of a long session, prompt:
"Review the mistakes you made and the corrections I gave you during this session. Propose 2 concise additions to CLAUDE.md that would prevent these mistakes in the future."

PART 3: GIT WORKFLOW — THE COMPLETE PICTURE
3.1 Foundational Git Setup
Claude needs a clean git state. Ensure your .gitignore includes:
Plaintext
.claude/
*.claude_history
3.2 The Commit Discipline Pattern
Tell Claude in your CLAUDE.md: "Commit your work iteratively. After finishing a logical block and verifying it passes tests, run git add and git commit before moving to the next block."
This creates an autonomous save-state loop. If Claude hallucinates on step 4, you can git reset --hard HEAD~1 rather than trying to untangle the mess.
3.5 The Rewind System (Esc+Esc)
Pressing Esc twice opens the rewind menu. This reverts the context window to a previous state.
Limitation: It rewinds the agent's memory, but it does not undo file changes or bash commands. You must use git checkout or git reset to revert the file system alongside the context rewind.
3.6 Worktrees for Parallel Work
When tackling multiple features, use git worktree.
Bash
git worktree add ../feature-auth -b auth-branch
cd ../feature-auth
claude
This isolates Claude's file system and context from your main branch, allowing you to run parallel agents without conflicts.

PART 4: THE CORE WORKFLOW — EXPLORE, PLAN, CODE, VERIFY, COMMIT
4.1 The Four-Phase Loop
Explore: "Read the auth modules and explain how JWT validation is currently handled."
Plan (Shift+Tab x2): Ask Claude to draft an implementation plan.
Implement: "Execute the plan."
Verify: "Run npm test and fix any failures."
4.2 Plan Mode Mastery
Press Shift+Tab twice to enter Plan Mode. Claude will output a markdown checklist of steps but will not execute them.
Press Ctrl+G to open the plan in your editor. Tweak the steps, remove bad assumptions, save the file, and then tell Claude to execute.
4.3 The Verification Loop (Test-Driven Prompting)
Never say: "Implement the login button."
Always say: "Implement the login button. When done, write a Jest test for it and run npm run test src/login.test.tsx. Do not stop until the test passes."
4.5 Prompting Patterns
The @-reference: "Refactor @src/utils/math.ts" (Claude loads the file into context natively).
The Constraint Pattern: "Build a data table for users. CONSTRAINT: Do not add any new npm packages. Use native HTML tables and Tailwind."
The Symptom Pattern: "Running npm run build throws 'Cannot read property id of null' in @src/components/List.tsx. Fix it."

PART 5: HOOKS — DETERMINISTIC AUTOMATION
Hooks trigger local bash scripts or node scripts during the agent lifecycle. Configure them in .claude/settings.json.
5.3 Production Hook Recipes
Auto-formatting:
JSON
"hooks": {
"postEditFile": "npx prettier --write ${FILE_PATH}"
}
Auto-linting:
JSON
"hooks": {
"postEditFile": "npm run lint ${FILE_PATH} || echo 'Lint failed! Fix this.'"
}
Hooks ensure that Claude Code never leaves messy code behind. If the hook outputs an error to stdout, Claude sees it immediately and will often autonomously attempt to fix it before confirming the task is done.

PART 6: SUBAGENTS — KEEPING MAIN SESSION CLEAN
Subagents protect your primary context window from filling up with garbage during deep dives.
6.1 The Subagent Mental Model
If you need Claude to read 40 files to find a bug, doing it in the main session will cost 150k tokens and degrade the model's performance for subsequent coding.
6.2 Spawning Subagents
Prompt: "Spawn a subagent to search the entire src/ directory for hardcoded IP addresses. Return only a markdown table of file paths and lines. Do not return the search output."
The parent agent spawns a child, the child uses tools to grep/search, and passes only the clean summary back to the parent context.

PART 7: SKILLS, COMMANDS & PLUGINS
7.1 Skills
Skills are reusable prompt components. Create a .claude/skills/code-review.md:
Markdown
When I ask for a code review, check for:
1. SQL Injection vulnerabilities
2. N+1 query problems
3. Missing TypeScript return types
Load it dynamically: /skill add code-review.
7.2 Custom Commands
Create custom slash commands in .claude/commands/.
Example: /pr
Bash
#!/bin/bash
claude -p "Review my uncommitted changes, write a commit message, and generate a PR description."

PART 8: MCP SERVERS — EXTENDING CLAUDE'S REACH
Model Context Protocol (MCP) bridges Claude Code to external APIs natively.
8.2 Essential MCP Servers
Configure in .claude/settings.json:
JSON
"mcpServers": {
"github": {
"command": "npx",
"args": ["-y", "@anthropic-ai/github-mcp-server"]
},
"postgres": {
"command": "npx",
"args": ["-y", "@anthropic-ai/postgres-mcp-server", "postgresql://user:pass@localhost/db"]
}
}
With the Postgres MCP, you can prompt: "Look at the user table schema and write a TypeScript interface for it." Claude will query the DB directly, read the schema, and write the code.
8.3 Security
Never connect Claude Code directly to a production database. Run /security-audit to evaluate the permissions requested by your configured MCP servers.

PART 9: SCALING — AUTOMATION
9.3 Non-Interactive Mode
Integrate Claude into CI/CD using the -p (prompt) flag.
Bash
claude -p "Read the git diff and provide a code review." --output-format json > review.json
9.4 Scheduled Loops
Run /loop "Every hour, run git fetch. If there are new commits on main, run npm test. If tests fail, fix them and push."

PART 10: CONTEXT MANAGEMENT
10.1 The Degradation Model
< 50%: Lightning fast, high accuracy.
70-85%: Starts to forget instructions from CLAUDE.md.
> 90%: High hallucination risk. Output truncates.
10.3 Token Reduction Strategies
Run /compact. This forces Claude to summarize the current session into a dense markdown block, clear the history, and inject the summary. It saves tokens but loses granular file-read history.
Clear frequently. Once a feature is merged, run /clear. Do not keep a session going for days.

PART 11: PROJECT ARCHETYPES
11.8 Real Estate / Finance Tooling (Thomas's Domain)
CLAUDE.md Snippet:
Markdown
# Domain Rules
- All currency calculations must use `decimal.js` to prevent floating point errors.
- Real estate API responses from MLS/Zillow are highly nested. Always create strict Zod schemas for validation before passing data to the UI.
- `src/core/amortization.ts` is the source of truth for all loan calculations. Do not rewrite math logic; import from here.

PART 12: DEBUGGING AND RECOVERY
12.2 Common Failure Patterns
Claude loops infinitely on a failing test: Press Ctrl+C to interrupt. Prompt: "Stop trying to fix the test. The test itself is wrong. Read the component implementation and rewrite the test to match."
Claude adds unwanted dependencies: Your CLAUDE.md is too weak. Add CONSTRAINT: Use only existing dependencies from package.json.

PART 13: SECURITY AND SAFETY
13.2 Protecting the Codebase
Add a .claudeignore file (syntax identical to .gitignore) to hide sensitive files.
Plaintext
.env*
config/secrets.yml
keys/
Claude will be entirely blind to these files, preventing accidental reads into the context window (which gets sent to Anthropic's servers).

PART 14: BUILDING YOUR PERSONAL SYSTEM
14.1 The Daily Workflow
Morning: git pull, open terminal, type claude. Run /clear to start fresh.
Mid-Day: Monitor the /costs and context fill. Commit frequently. Use Plan Mode for anything taking more than 20 minutes.
Evening: Run the session-close ritual. Update CLAUDE.md. Push code.
14.5 Knowledge Compounding
Your CLAUDE.md is your team's most valuable asset. Over 6 months, it transforms from a generic rulebook into a hyper-specific map of codebase landmines, architectural decisions, and domain truths. Treat CLAUDE.md commits with the same rigor as production code.

PART 15: QUICK REFERENCE
Shortcuts & Commands
Shift+Tab (x2): Plan Mode
Esc (x2): Rewind Context
Ctrl+C: Interrupt active tool/generation
/clear: Nuke context (keep files)
/costs: Show token spend
/compact: Summarize and compress context
/init: Generate initial CLAUDE.md
/bug: Report Claude Code CLI issue
Priority Matrix:
[CRITICAL] Keep CLAUDE.md under 200 lines.
[CRITICAL] Commit via git after every successful sub-task.
[HIGH] Use -p for CI/CD automation.
[POWER] Use the Postgres MCP for backend work.
[TIP] Ask Claude to summarize its mistakes at session end.
# Deep research Google:

The Definitive Operating Manual for Claude Code: Engineering Elite Agentic Workflows
PART 0: MENTAL MODEL — HOW CLAUDE CODE ACTUALLY WORKS
The transition from a passive integrated development environment (IDE) to an agentic coding harness necessitates a fundamental cognitive shift in software engineering. Claude Code does not function merely as an autocomplete engine or a conversational assistant; it operates as an autonomous state machine capable of environmental interaction, tool execution, and self-correction. Understanding the underlying architecture of this system is the prerequisite for achieving elite-level mastery and predictable production outcomes.
The Agentic Loop: Read, Plan, Act, Verify
The operational core of Claude Code is a continuous four-phase loop that mirrors the cognitive processes of a high-level software engineer. Every task, regardless of complexity, is processed through this deterministic cycle to ensure alignment with project constraints and technical validity.
This loop distinguishes Claude Code from traditional LLM interfaces by closing the feedback gap. In a standard chatbot, the human provides the environment's feedback; in Claude Code, the agent queries the environment directly, reads the error messages, and iterates until the "Verify" phase succeeds.
The Context Window: Storage, Cost, and Degradation
The context window is the finite "short-term memory" of the agent, holding approximately 200,000 tokens. Every instruction, file content, and terminal output occupies a portion of this space. The engineering challenge lies in the fact that LLM performance is non-linear relative to context fill.
Context degradation occurs because the model's attention mechanism must distribute its "focus" across a larger volume of data. When the window is nearly full, the agent may prioritize recent conversational turns over foundational rules established in the system prompt or CLAUDE.md.
The Tool System and Environmental Awareness
Claude Code’s awareness is mediated through a set of deterministic tools. It does not "see" the screen in the human sense; instead, it receives JSON-formatted representations of the file system and terminal state. The agent decides which tool to use based on the current goal and the results of previous tool calls.
The relationship between the terminal and the agent is bidirectional. Claude can initiate commands, but it also monitors the standard output (STDOUT) and standard error (STDERR) to diagnose failures. This makes it significantly more effective than a chatbot because it can troubleshoot environment-specific issues like misconfigured paths or missing dependencies without human intervention.
Persistence, Memory, and Failure Modes
Persistence in Claude Code is achieved through a multi-layered memory architecture. Unlike an IDE that relies on static indexing, Claude uses dynamic memory files and session history.
Instruction Memory: The CLAUDE.md and .claude/rules/*.md files provide project-wide constraints that are loaded at the start of every session.
Auto Memory: Located in ~/.claude/projects/<project>/memory/, this stores notes Claude takes for itself to track progress across multiple sessions.
Session History: The literal transcript of the current conversation, which persists until cleared or compacted.
Despite its advanced capabilities, Claude Code operates with specific "blind spots." It cannot infer hidden project history that isn't documented, and it cannot "see" UI changes without explicit verification via screenshots or playwright tools. The most common failure mode is "tool-looping," where the agent repeatedly attempts a failing command without changing its approach—a scenario that requires human intervention to adjust the prompt or the environment.

PART 1: ENVIRONMENT SETUP — ZERO TO OPERATIONAL
A professional-grade environment on Windows requires bridging the gap between the Windows operating system and the Linux-centric design of modern AI tools. For Thomas, the staff engineer, the objective is to create a high-performance, low-latency environment that maximizes Claude Code’s utility.
1.1 Installation and Prerequisites
The technical consensus for elite Windows development favors WSL2 (Windows Subsystem for Linux) over native PowerShell or Git Bash. WSL2 provides a native Linux kernel, enabling high-speed file operations and full compatibility with the bash utilities Claude Code relies on.
Installation on WSL2 should avoid sudo to prevent permission conflicts with the Claude Code binary. The recommended path is to use a Node Version Manager (nvm) within the WSL instance to install Node.js and then install Claude Code globally via npm install -g @anthropic-ai/claude-code.
Authentication is managed via the Anthropic Console. The API key should be stored in the WSL environment as an environment variable (ANTHROPIC_API_KEY) within the .bashrc or .zshrc file for seamless access. Key rotation should be performed every 90 days or if a workspace security audit identifies a potential leak.
1.2 Terminal Configuration for Windows
The terminal is the primary interface for Claude Code. For Thomas, the Windows Terminal is the standard choice, but more advanced users may prefer WezTerm or Alacritty for their superior GPU rendering and configuration-as-code capabilities.
A critical setup step is the configuration of a Nerd Font (e.g., JetBrains Mono Nerd Font). This is non-negotiable for correctly rendering the TUI elements, icons, and status bars that Claude Code uses to communicate context usage and agent status.
Within WSL2, the shell choice (bash vs. zsh) is largely personal, but certain aliases are recommended to streamline the "Parallel Agent" workflow:
Bash
# Claude Code Productivity Aliases
alias c='claude'
alias cc='claude --continue'
alias cp='claude --permission-mode plan'
alias ca='claude --permission-mode auto'
alias cw='git worktree add' # For the parallel agent workflow
Setting up an ssh-agent in WSL2 is critical. If the agent cannot autonomously pull or push code due to SSH password prompts, the agentic loop will break. One must ensure eval $(ssh-agent -s) runs on shell startup and ssh-add is used to load the primary development key.
1.3 Editor Integration: The Sidecar Pattern
The "Sidecar Pattern" involves running the Claude Code TUI in a dedicated terminal pane alongside a visual editor like VS Code or JetBrains. This allows for real-time visual auditing of the code changes the agent is making.
In VS Code, the official extension provides a GUI for many Claude Code features, including a diff viewer and a sessions list. However, for Thomas, the terminal remains the primary point of control because it provides unrestricted access to bash and system tools that are sometimes limited in the extension's sandbox.
The elite setup involves a three-pane layout in VS Code:
Center Pane: The active source code.
Right Sidebar: The Claude Code Extension for high-level monitoring and diff reviews.
Bottom Terminal: The Claude Code CLI for executing complex multi-step bash commands and parallel subagents.
1.4 Core Configuration:.claude/settings.json
The configuration of Claude Code is split between global defaults (~/.claude/settings.json) and project-specific overrides (.claude/settings.json). Understanding inheritance is key: project-level settings overwrite global ones, allowing for different coding standards across repositories.
JSON
{
"model": "claude-3-7-sonnet-20250219",
"effort": "high",
"outputStyle": "concise",
"env": {
"CLAUDE_CODE_GIT_BASH_PATH": "/usr/bin/bash"
},
"hooks": {
"PostToolUse":
},
"maxBudgetUsd": 10.00
}
Field explanations for Thomas:
model: Sonnet is the recommended default for most tasks due to its balance of speed and reasoning. Opus should be reserved for high-stakes architectural planning or complex debugging.
effort: Controls the internal "thinking" time. Setting this to high for Thomas ensures the agent explores more edge cases before proposing a plan.
maxBudgetUsd: A critical safety valve. Setting this to a session-level cap prevents runaway loops from consuming excessive credits.
1.5 API and Cost Configuration
Thomas must manage his Anthropic Console account to ensure he is in a high enough tier to avoid rate limits during parallel work. Tier 3 or higher is recommended for professional usage involving multiple agent teams.
Cost control is achieved through three primary mechanisms:
The /costs Command: Provides a real-time breakdown of spend for the current session.
Strategic Compactness: Using /compact at the right time (approx. 80% context) reduces the token count by summarizing history, which lowers the cost of every subsequent turn.
Subagent Model Selection: For research or log reading, Thomas can configure subagents to use the Haiku model, which is 10x cheaper than Sonnet, while reserving Sonnet for implementation.

PART 2: CLAUDE.md — THE SINGLE MOST IMPORTANT FILE
If the terminal is the interface, CLAUDE.md is the brain. This file acts as the project's persistent memory, defining the laws of the codebase that Claude must never violate. For Thomas, mastering CLAUDE.md is the difference between a tool that "just works" and one that requires constant micromanagement.
2.1 What CLAUDE.md Actually Does
The CLAUDE.md file is loaded at the very beginning of every session, consuming tokens but providing immediate project-specific knowledge. It has an adherence rate of approximately 80% for advisory rules, but this can be pushed toward 100% by using high-emphasis language like IMPORTANT: and YOU MUST.
The distinction between global and project-level CLAUDE.md is critical:
Global (~/.claude/CLAUDE.md): Contains your personal style (e.g., "Always use camelCase for variables," "Always use functional programming patterns").
Project-level (./CLAUDE.md): Contains repository-specific commands (e.g., "Run npm test to verify changes") and architectural rules.
2.2 The /init Command Deep Dive
Running /init is the first action Thomas should take in any new repository. This command performs a structural analysis of the codebase, identifying the package manager, test framework, and build system. It generates a boilerplate CLAUDE.md that is functional but requires manual refinement.
Common things /init misses:
Environmental Quirks: Required environment variables for local development.
Git Conventions: Specific branch naming patterns (e.g., feat/TICKET-123).
Complex Test Filters: How to run only a subset of tests for performance.
2.3 Anatomy of an Elite CLAUDE.md
The "200-line discipline" is the most important rule for Thomas. As a project grows, the temptation is to document everything in CLAUDE.md. This is a mistake; bloat causes the agent to ignore instructions. The file should remain a "high-signal" document.
For modularity, Thomas can use the @path/to/file syntax to import external instructions. For example, a CLAUDE.md might import @docs/API_CONVENTIONS.md only when working on the API directory.
2.4 Real CLAUDE.md Examples
Example: TypeScript / Node.js Backend API
TypeScript Backend API Rules
See @package.json for all scripts.
Commands
Build: npm run build
Test: npm run test:unit
Lint: npm run lint
Patterns
Use ES modules syntax (import/export).
IMPORTANT: All service methods must include Zod validation for inputs.
All database queries must use the Prisma client in src/db.
Verification
Run unit tests after every change.
Run typecheck (npm run typecheck) before declaring a task complete.
Example: Infrastructure / DevOps (Terraform)
Infrastructure Project
Environment: AWS (us-east-1)
Commands
Init: terraform init
Plan: terraform plan
Apply: terraform apply -auto-approve
Rules
IMPORTANT: Never hardcode AWS IDs. Use data sources or variables.
All new resources must have Owner and Project tags.
Use module architecture for all new service definitions.
Verification
Run terraform validate after every edit.
Run tflint to ensure security best practices are met.
2.5 The Session-Close Ritual
Thomas should never end a session without a brief "retro" with Claude. The goal is to capture the day's learnings into the CLAUDE.md so they compound in value.
Ask Claude: "Based on what we did today, what should I add to CLAUDE.md to make our next session more efficient?".
Evaluate: Review Claude’s proposed rule. Does it pass the 200-line discipline? Is it universally applicable?
Commit: Once the rule is added, commit the CLAUDE.md change. This ensures that the agentic knowledge survives a branch switch or a collaborative effort with other developers.

PART 3: GIT WORKFLOW — THE COMPLETE PICTURE
Git is not just version control for Thomas; it is the safety net for agentic development. Claude Code has full access to the Git CLI, and the staff engineer must define exactly how it should be used to maintain a clean, professional history.
3.1 Foundational Git Setup
A specialized .claudeignore file (similar to .gitignore) should be created to prevent Claude from reading sensitive files or massive build artifacts that would waste context window tokens.
Branch strategy should be enforced in the CLAUDE.md. For Thomas, the recommended pattern is:
Short-lived feature branches: One branch per Claude session.
Naming convention: feat/description or fix/issue-id.
Signing: If Thomas requires GPG-signed commits, he must ensure the gpg-agent is correctly configured in WSL2 so Claude isn't blocked by a passphrase prompt.
3.2 How Claude Code Interacts with Git
Claude Code uses git autonomously for:
Exploration: Checking current branch state and diffs.
Implementation: Staging files and creating commits.
Coordination: Creating PRs and pushing code.
A key insight for Thomas: instruct Claude to "commit at each working step". Instead of one massive commit at the end, Claude should commit every time a unit test passes or a refactor is successful. This allows for fine-grained rollbacks using the /rewind system.
3.3 The Commit Discipline Pattern
The staff engineer uses a "human-in-the-loop" commit strategy.
Drafting: Claude writes a commit message based on the work done.
Review: Thomas reviews the staged changes and the message.
Amending: If the commit message is vague (e.g., "updated code"), Thomas should instruct Claude: "Rewrite that commit message following Conventional Commits format".
Squashing: Before merging a PR, Thomas uses git rebase -i to squash Claude's incremental commits into a single high-quality commit for the main branch.
3.4 Pull Requests with Claude Code
The /install-github-app command is the gateway to automated PR management. Once installed, Thomas can delegate the entire PR lifecycle:
Creation: "Summarize our changes and open a PR against main".
Reviews: Claude can address comments on PRs automatically. Thomas simply mentions @claude in a GitHub comment, and the agent pulls the code, fixes the requested change, and pushes a new commit.
Descriptions: Claude is excellent at generating "high-signal" PR descriptions from commit history, detailing not just what changed, but why.
3.5 The Rewind System
The Esc+Esc shortcut triggers the checkpoint system. This is critical when an agent goes down a "logic rabbit hole" and starts making incorrect changes.
Option 1: Restore Files: Reverts all file changes to the checkpoint.
Option 2: Restore Conversation: Clears the agent's history to that point, freeing up tokens.
Limitations: Importantly, bash commands are not checkpointed. If Claude ran npm install or deleted a directory via bash, the rewind system cannot undo that action. Thomas must rely on Git as the ultimate safety net for environmental changes.
3.6 Worktrees for Parallel Work
"Parallelization is the Top Unlock" according to Boris Cherny. To run 3-5 agents simultaneously, Thomas must use git worktree.
The Pattern: git worktree add../feature-A feature-branch-A.
The Setup: Open a new terminal tab, cd into the worktree directory, and launch a new Claude session.
Isolation: This ensures that Agent A's file changes never collide with Agent B's, and their respective context windows stay focused on a single concern.
Merging: Once work is done, delete the worktree and merge the branch back to main via the primary repository.

PART 4: THE CORE WORKFLOW — EXPLORE, PLAN, CODE, VERIFY, COMMIT
The elite workflow is a disciplined progression through four distinct phases. Skipping a phase is the most common cause of agentic failure in production environments.
4.1 The Four-Phase Loop in Detail
4.2 Plan Mode Mastery
Plan Mode (Shift+Tab twice) is a state where Claude can read and think but cannot write. For complex tasks, Thomas should always start here.
The Plan Mode Advantage: It allows Claude to "look ahead" and identify potential architectural conflicts before any code is modified.
Editing Plans: When Claude finishes a plan, Thomas should press Ctrl+G. This opens the plan in a text editor. Thomas can add constraints, refine the logic, or delete unnecessary steps.
Decision Rule: If the task involves more than two files, use Plan Mode. If it's a single-file fix, Normal Mode is sufficient.
4.3 The Verification Loop
Claude performs dramatically better when given specific verification criteria.
Vague: "Fix the bug."
Airtight: "Fix the bug. Run npm test to verify the fix. Propose two new test cases that cover the edge cases of this logic".
Test-Driven Prompting: Thomas should include a test command in every implementation prompt. If the project doesn't have tests, Thomas should first instruct Claude: "Create a minimal test suite for the auth module before implementing any changes." This creates an automated feedback loop for the agent.
4.4 Session Management
Session management is a critical skill for Thomas to avoid context bloating.
When to Clear: If the session has reached 80% usage and the current task is done, clear the session and start fresh for the next task.
/compact: Use this when mid-task to summarize history and free up tokens.
claude --continue: Resumes the last session in the current directory.
4.5 Prompting Patterns That Consistently Work

PART 5: HOOKS — DETERMINISTIC AUTOMATION
Hooks are the most underused and highest-leverage feature in Claude Code. They allow Thomas to encode "rules that cannot be broken" into the agent's execution loop.
5.1 What Hooks Are and Why They Matter
While CLAUDE.md is advisory (Claude should follow it), Hooks are deterministic (the environment forces it).
PreToolUse: Runs before Claude executes a command. Can block the action if it's dangerous or violates a rule.
PostToolUse: Runs after Claude completes an action. Used for cleanup, formatting, or auto-testing.
PostSession: Runs when Thomas exits the CLI, ideal for automated retros and cleanup.
5.2 Complete Hooks Reference
The matcher system allows Thomas to target specific tool uses:
Matcher: Write (triggers only when Claude writes a file).
Matcher: Bash (triggers when Claude runs a CLI command).
Matcher: Edit (triggers on file edits).
5.3 Production Hook Recipes
Auto-Formatting (Prettier)
JSON
{
"hooks": {
"PostToolUse":
}
]
}
}
Auto-Testing after Edit
JSON
{
"hooks": {
"PostToolUse":
}
]
}
}
Security Scanning (Secret Detection)
JSON
{
"hooks": {
"PreToolUse":
}
]
}
}
5.4 Advanced Hook Patterns
For Thomas, the staff engineer, hooks can be used for team-wide rule enforcement. By committing a hook configuration to the project-level .claude/settings.json, every team member’s Claude Code session will automatically follow the same quality gates.
Conditional hooks can be written as shell scripts that receive the tool input as JSON via STDIN. This allows for complex logic, such as "only run tests if the edited file is in the src/ directory".

PART 6: SUBAGENTS — KEEPING YOUR MAIN SESSION CLEAN
Subagents are the architecture that makes large, complex projects tractable for Thomas. They provide context isolation, allowing the main agent to stay "high-level" while delegating details to specialists.
6.1 The Subagent Mental Model
A subagent is a separate Claude session spawned by the main agent.
Context Isolation: The subagent reads thousands of lines of logs, and only returns a 50-line summary to the main session.
Specialization: A subagent can be given a custom prompt that makes it more effective for a specific task (e.g., "You are an expert at refactoring legacy React code to functional components").
6.2 Spawning and Directing Subagents
Thomas can trigger subagents through natural language:
Research: "Have a subagent read all the logs in the /logs directory and identify the timestamp of the first 500 error".
Summarization: "Spawn a subagent to read the entire @docs directory and provide a summary of the current API authentication flow".
6.3 Agent Teams (Experimental)
Agent Teams represent the next level of parallelism. Unlike subagents, which report only to the parent, agent teams coordinate horizontally.
Lead Agent: Manages the team and assigns work from a shared task list.
Teammates: Communicate with each other via peer-to-peer messaging.
File Locking: Teammates automatically lock files to prevent merge conflicts during parallel edits.
6.4 Orchestration Patterns
For a complex feature, Thomas should use the Command → Agent → Skill pattern:
Command: Thomas starts a session with a high-level goal.
Agent: The main Claude agent spawns three teammates (Frontend, Backend, and Tester).
Skill: Each teammate uses relevant skills (e.g., /db-migrate) to execute their assigned tasks.

PART 7: SKILLS, COMMANDS & PLUGINS
The extension system allows Thomas to encode his expertise and reuse it across multiple projects.
7.1 Skills
A skill is a reusable prompt checked into the repository.
When to Use: For repeatable workflows like "Create a new database migration" or "Onboard a new developer".
Structure: Skills live in .claude/skills/<name>/SKILL.md.
Auto-Invocation: If a skill has a clear description, Claude will discover and use it autonomously when it encounters a matching task.
7.2 Custom Commands
Custom commands (/slash-commands) are shorter, tactical tools.
Examples:
/security-check: Runs a quick scan for common vulnerabilities.
/add-tests: Scaffolds a unit test file for the current open file.
/pr-review: Summarizes changes and checks for architectural debt.
7.3 Plugins
Plugins are bundles of skills, hooks, and MCP servers. Thomas can install them from the plugin marketplace (/plugin) or build his own for proprietary internal tooling.

PART 8: MCP SERVERS — EXTENDING CLAUDE’S REACH
The Model Context Protocol (MCP) is the bridge between the agent and Thomas's entire digital world.
8.1 What MCP Is and How It Works
MCP allows Thomas to connect external data sources (Slack, Figma, GitHub, Postgres) directly to Claude's context. Servers are loaded dynamically only when needed, minimizing token bloat.
8.2 Essential MCP Servers
8.3 MCP Security — Non-Negotiable
MCP servers represent a security surface area for Thomas. He must follow the 5-minute pre-installation checklist :
Vetting: Is the server from a trusted source?
Permissions: What files or APIs does it have access to?
Scan: Run /security-check on the server source code if available.
Audit: Run /security-audit for a full 6-phase review.
8.4 Building a Custom MCP Server
When Thomas has a proprietary internal tool (e.g., a real estate appraisal engine), he should build a custom MCP server. This gives Claude direct access to the tool's API without Thomas having to copy-paste data into the prompt.

PART 9: SCALING — PARALLEL WORK AND AUTOMATION
For a staff engineer like Thomas, scaling is about moving from "interactive coder" to "orchestrator of autonomous agents".
9.1 Parallel Claude Code Sessions
The multi-pane setup in VS Code is the foundation.
Rule of Concern: One terminal pane per feature or bug.
Coordinating Output: Use system notifications to alert Thomas when an agent finishes a task or needs input.
9.2 Git Worktrees + Parallel Agents
This is the "Gold Standard" for scaling.
One Worktree = One Agent = One Branch.
The Merging Strategy: Once all parallel agents finish their respective tasks (Backend, Frontend, Tests), Thomas reviews the combined results in the main branch.
9.3 Non-Interactive Mode and Automation
Using the -p flag, Thomas can automate common sweeps :
Bash
# Nightly Security Sweep
find. -name "*.ts" | claude -p "Audit these files for common security flaws" > security_report.txt
9.4 Scheduled and Cloud Execution
The /schedule command allows Thomas to run tasks on Anthropic's infrastructure. This is ideal for long-running migrations or massive codebase refactors that would tie up his local machine.
9.5 The GitHub App and CI/CD Integration
The final step in scaling is the GitHub App. By integrating Claude into GitHub Actions, Thomas can enforce automated code quality across his entire team.

PART 10: CONTEXT MANAGEMENT — THE ADVANCED PLAYBOOK
Context management is the "secret sauce" of high-performing AI engineers.
10.1 The Context Degradation Model
Thomas must build "Context-Fill Awareness".
Signal: If Claude starts repeating itself or ignoring the CLAUDE.md, context is likely over 85%.
Action: Immediately run /compact or clear the session history.
10.2 The Custom Status Bar
Setting up a status bar that shows real-time token usage is critical. This provides Thomas with immediate visual feedback on the state of the agent's memory.
10.3 Token Reduction Strategies
Compact Early: Don't wait for the 90% limit; compact at 70% for complex tasks.
Pipe Outputs: Instead of npm test outputting to the terminal, pipe it to a file and tell Claude where to find it.
Quarantine Operations: Use subagents for any operation that involves reading more than 5 files.

PART 11: PROJECT ARCHETYPES — SETUP GUIDES A TO Z
Thomas will encounter a range of projects. Each requires a unique CLAUDE.md and hook configuration.
11.1 TypeScript / Node.js Backend API
Directory: /src, /routes, /controllers, /services, /tests.
Rule: "Ensure every API endpoint has a unit test and an integration test."
Hook: Auto-run npm run lint on every write.
11.2 Real Estate / Finance Tooling (Thomas’s Domain)
Directory: /src/models, /src/calculators, /src/schemas, /docs/specs.
Rule: "All financial calculations must use the Decimal.js library to ensure precision."
Hook: Auto-run a security scan on any changes to the calculators/ directory.
Prompt: "Review this appraisal logic against the regulatory specs in @docs/FINANCE_REGS.md".

PART 12: DEBUGGING AND RECOVERY
When Claude Code fails, Thomas must have a diagnostic workflow to recover quickly.
12.1 The Diagnostic Workflow
Context Check: Run /context. Is it over 85%?
Prompt Audit: Is the goal clear? Are there conflicting constraints?
CLAUDE.md Audit: Has the agent stopped following the rules?
Scope Check: Is the task too large? Decompose into subtasks.
12.2 Recovery Strategies
Rewind: Use Esc+Esc to go back to a known working state.
Clear and Start: If the logic is hopelessly mangled, clear the session and provide a better initial prompt with a structured plan.
Human Intervention: Sometimes the fastest recovery is to fix the one line of code that Claude is struggling with, and then let the agent continue.

PART 13: SECURITY AND SAFETY
Running an agentic tool with system access requires a "Defense-in-Depth" approach.
13.1 Permission Modes
Default: The recommended mode for Thomas. Every tool call is approved.
Auto: Safe for trusted repositories; prompts only for dangerous actions.
Sandboxing: For high-risk automation, run Claude Code inside a Docker container.
13.2 Protecting Your Codebase
Secret Detection: Use hooks to block commits containing secrets.
.claudeignore: Ensure .env, .git, and sensitive credential files are explicitly ignored.

PART 14: BUILDING YOUR PERSONAL SYSTEM
The final phase of mastery is the development of a personal engineering system that compounds over time.
14.1 The Daily Workflow
Morning Startup: Check PR status via GitHub App, review auto-memory, and start parallel agent teams for the day's tasks.
Session-Close: Update CLAUDE.md, commit rules, and clear sessions to maintain context health.
14.2 The Personal Skill Library
Thomas should maintain a global skill library in ~/.claude/skills/ that contains his personal best practices (e.g., "Write high-signal PR descriptions," "Optimize for TypeScript performance").

PART 15: QUICK REFERENCE

Keyboard Shortcuts

Essential Slash Commands

