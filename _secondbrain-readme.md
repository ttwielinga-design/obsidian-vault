# Second Brain — Vault Onboarding

A hybrid three-layer Obsidian vault for knowledge management with AI agent integration. This guide covers everything from first launch to recovery.

---

## 1. Quick Start

### Open the Vault

1. Launch **Obsidian** (install from [obsidian.md](https://obsidian.md) if needed).
2. Click **"Open folder as vault"** and select `~/Documents/SecondBrain`.
3. When prompted about community plugins, click **"Trust author and enable plugins"** — all plugins are pre-configured.

### Capture Something Fast

- Press **Ctrl+Shift+C** (QuickAdd capture shortcut) to open a quick-capture window. Jot down a thought and hit Enter — it lands in `0-inbox/fleeting/`.
- Alternatively, create a note directly in **0-inbox/** for anything you want to file later.

### Open Today's Daily Note

- Press **Ctrl+Shift+D** or click the calendar icon in the left ribbon. The daily note opens in `2-notes/daily/YYYY-MM-DD.md`.
- Write your journal under `## 👤 My Day`. Don't touch the `## 🤖 Agent Activity` section — agents maintain that.

### Agent Chat (Claudian / Codex / Hermes)

- The vault exposes a **local REST API** (port 27124 by default, via obsidian-local-rest-api). AI agents read and write notes through it.
- Agents read `_agent/` summaries first for context awareness, then drill into specific notes.
- Agent session summaries auto-appear in `1-raw/code-sessions/` and daily notes get populated under `## 🤖 Agent Activity`.

---

## 2. Daily Workflow

### Morning Dashboard (5 minutes)

1. Open today's daily note (`Ctrl+Shift+D`).
2. Review `## 🎯 Today's Focus` — set 2-3 priorities.
3. Glance at `index.md` for active projects and areas.
4. Check `log.md` for what changed overnight (agents or manual edits).

### Inbox Processing (throughout the day)

1. Open `0-inbox/` and triage each item:
   - **Actionable?** → Turn it into a project note in `2-notes/projects/` or a task on the daily note.
   - **Reference material?** → Save to `1-raw/` (articles, papers, transcripts).
   - **Concept or insight?** → Create an atom in `2-notes/atoms/`.
   - **Not useful?** → Delete it.
2. Link new notes to at least one MOC in `2-notes/maps/` or an existing atom.

### Evening Review (10 minutes)

1. Update today's daily note with what actually happened (under `## 👤 My Day`).
2. Log any key decisions under `## 📋 Decisions Made`.
3. Add an entry to `log.md` summarizing significant vault changes.
4. Commit and push: `cd ~/Documents/SecondBrain && git add -A && git commit -m "daily update" && git push`.
5. Preview tomorrow's daily note and pre-populate `## 🎯 Today's Focus` if helpful.

---

## 3. Agent Instructions

> For AI agents integrating with this vault. Humans can skip this section.

### Before You Start

1. **Read `SCHEMA.md` first** — it defines the three-layer structure, frontmatter convention, linking strategy, and page thresholds. Everything below depends on it.
2. Read `_agent/` summaries for cached context (avoids scanning the full vault).
3. Read `index.md` for the home page and quick-link map.

### Core Rules

| Rule | Detail |
|------|--------|
| **Frontmatter on every note** | Follow the schema in SCHEMA.md — `title`, `type`, `status`, `created`, `updated`, `tags` are required. |
| **Wikilinks for references** | Use `[[Note Name]]` syntax, not markdown links. |
| **Minimum 2 outbound links** | Every atom note must link to at least 2 other notes (prevents orphan knowledge). |
| **Log everything** | Append every significant action to `log.md` with timestamp. |
| **Use templates** | `Templates/` folder has `t-atom.md`, `t-moc.md`, `t-project.md`, `t-code-session.md`, `t-daily.md`, `t-person.md`. Use the correct one per note type. |
| **Never touch agent sections** | Daily notes have `<!-- AGENT_SECTION:... -->` markers — only append within those boundaries, don't edit human content. |
| **Frontmatter status progression** | `seed` → `sapling` → `evergreen` (knowledge maturity). Use `draft` for in-progress, `archived` for done. |

### Agent Output

- **Session summaries** → `1-raw/code-sessions/` with the `t-code-session` template. Include: agent name, project, files changed, key decisions, learnings.
- **Daily activity** → Append to today's daily note under the correct `## 🤖 Agent Activity` subsection (Claude Code, Codex, or Hermes).
- **New atoms** → `2-notes/atoms/` when a concept appears in 2+ sources.
- **MOCs** → `2-notes/maps/` when 5+ atoms share a domain tag.
- **Evergreen promotion** → Move matured atoms (200+ lines, high confidence) to `3-knowledge/concepts/`.

### Context-Window Gate

The `_agent/` directory exists to reduce context-window cost. Before reading the full vault, agents should:
1. Read `_agent/` summaries for relevant domains.
2. Only then open specific files in `1-raw/`, `2-notes/`, or `3-knowledge/`.

---

## 4. Sync Setup

### Local Git (already configured)

The vault is initialized as a git repo on branch `main`. Core Obsidian config (plugins, templates, scripts) is tracked; device-specific files (workspace layout, hotkeys, cache) are in `.gitignore`.

### Setting Up a Remote

1. Create a private repo on GitHub/GitLab/Bitbucket.
2. Add the remote:
   ```bash
   cd ~/Documents/SecondBrain
   git remote add origin git@github.com:YOUR_USER/SecondBrain.git
   ```
3. Push:
   ```bash
   git push -u origin main
   ```

### Obsidian Git Plugin

The **obsidian-git** plugin is pre-installed:
- Open Command Palette (`Ctrl+P`) → search "Obsidian Git: Commit and push"
- Configure auto-backup interval: Settings → Obsidian Git → **Auto backup** (suggest 15-30 minutes)
- The `.gitignore` already excludes secrets (`*secret*`, `*token*`, `*api-key*`, `.env`, `.pem`, `.key`)

### Multi-Device Setup

1. On a new device, clone the repo: `git clone <remote-url> ~/Documents/SecondBrain`
2. Open the folder in Obsidian as an existing vault.
3. Enable community plugins when prompted.
4. Obsidian Git will prompt to pull on launch — accept to get the latest.

### Conflict Prevention

- Commit and push before switching devices.
- Pull before editing if you've been away.
- The `.obsidian/workspace*.json` is gitignored, so window layouts don't conflict across devices.
- File renames that only change capitalization will cause sync issues — use a different name instead.

---

## 5. Emergency Recovery

### Vault Won't Open / Obsidian Crashes

1. **Disable all plugins:** Rename `.obsidian/plugins` to `.obsidian/plugins.bak` and restart Obsidian.
2. If it opens, re-enable plugins one by one to find the culprit.
3. Restore: rename `.obsidian/plugins.bak` back to `.obsidian/plugins` and disable the broken plugin from Obsidian's settings.

### Git Merge Conflicts

1. Obsidian Git will show an error in the status bar. Open a terminal:
   ```bash
   cd ~/Documents/SecondBrain
   git status                    # see conflicted files
   git diff                      # inspect the conflicts
   ```
2. For simple conflicts in a note, edit it manually and remove the `<<<<<<<` / `=======` / `>>>>>>>` markers.
3. After resolving:
   ```bash
   git add <resolved-file>
   git commit -m "resolve merge conflict"
   git push
   ```

### Lost or Deleted Notes

1. Check git history:
   ```bash
   git log --oneline --all -- <path-to-note>
   ```
2. Restore the note:
   ```bash
   git checkout <commit-hash> -- <path-to-note>
   ```
3. Commit the restored file and push.

### Corrupted Vault Config (.obsidian)

1. Back up your notes:
   ```bash
   cp -r ~/Documents/SecondBrain ~/Documents/SecondBrain-backup
   ```
2. Delete `.obsidian/` and re-open the folder in Obsidian — it regenerates a fresh config.
3. Reinstall plugins from Community Plugins:
   - **Templater** — template system for new notes
   - **QuickAdd** — capture shortcut (Ctrl+Shift+C)
   - **Dataview** — live queries across notes
   - **Obsidian Git** — auto backup and sync
   - **Local REST API** — agent integration
4. Your notes, templates, and `.gitignore` are all intact — only the Obsidian app config was reset.

### Plugins Out of Sync Across Devices

If `git pull` didn't update plugins:
```bash
cd ~/Documents/SecondBrain
git checkout main -- .obsidian/plugins/
```

### API Key / Secret Accidentally Committed

1. **Immediately rotate the key** on the provider's dashboard.
2. Remove from git history:
   ```bash
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch <path-to-file-with-secret>" \
     --prune-empty --tag-name-filter cat -- --all
   git push --force --all
   ```
3. Verify `.gitignore` has the secret patterns (`*secret*`, `*token*`, etc.).

---

## Reference

| What | Where |
|------|-------|
| Full vault schema | `SCHEMA.md` |
| Home page | `index.md` |
| Change log | `log.md` |
| Note templates | `Templates/` |
| Agent summaries | `_agent/` |
| Dataview queries | `Scripts/dataview/` |
| QuickAdd macros | `Scripts/quickadd/` |

---

*Vault initialized 2026-07-07. Maintained by human + AI agents. Keep this README updated as the vault evolves.*
