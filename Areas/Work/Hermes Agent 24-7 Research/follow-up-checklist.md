---
title: "Hermes PA Setup - Action Items for Thomas"
type: checklist
status: active
tags: [hermes, pa-setup]
---

# Hermes 24/7 PA Setup - Action Items for Thomas

## 🔴 Immediate (Today — Boring Reliability First)

- [ ] **Fix Discord delivery** — getaddrinfo failed since mid-May. Blocks ALL cron notifications to Discord (morning brief, kanban alerts, email triage, health monitor). Likely DNS or network config issue.
- [ ] **Restart gateway** — fixes lock issue, picks up MCP servers cleanly, clears stale state from 7 weeks of downtime
- [ ] **Fix email triage script** — AttributeError in Yahoo folder parsing (line ~343 of `email-triage-run.py`). No nightly triage since May 15.
- [ ] **Run QMD rebuild script** — PyTorch segfault broke Obsidian vault semantic search. Rebuild script exists but was never executed post-fix.

## 🟡 Short-term (This Week)

- [ ] **WhatsApp setup — choose adapter:**
  - [ ] **Option A: Baileys bridge** (recommended for quick start) — QR scan via `hermes whatsapp`, supports groups, no public URL needed, ban risk (unofficial API)
  - [ ] **Option B: Cloud API** (official, no ban risk) — Meta Business account + WABA + webhook + cloudflared tunnel, DMs only, 24h conversation window, interactive buttons
- [ ] **Set up missing env vars** (15 min each):
  - [ ] Airtable: `AIRTABLE_API_KEY`
  - [ ] Notion: `NOTION_API_KEY`
  - [ ] Linear: `LINEAR_API_KEY`
  - [ ] Tenor: `TENOR_API_KEY`
- [ ] **GitHub PAT** — Create token with repo scope at https://github.com/settings/tokens for config backup

## 🟢 Medium-term (This Month)

- [ ] **Install process supervisor for 24/7 reliability**
  - [ ] NSSM (Non-Sucking Service Manager) on Windows, or
  - [ ] Windows Task Scheduler with restart-on-failure
- [ ] **Install openhue CLI + pair Hue Bridge** — smart home control
- [ ] **Install blogwatcher-cli** — RSS/blog monitoring
- [ ] **Decide on long-term memory architecture**
  - [ ] Option A: mcpvault + LightRAG (planned, not executed)
  - [ ] Option B: Simpler approach (filesystem-based)
  - Current: Qwen3-Embedding-0.6B on CPU for semantic search (broken, needs rebuild)

## 📊 Status Snapshot (July 6, 2026)

| Component | Status | Notes |
|-----------|--------|-------|
| Discord | ⚠️ Connected but delivery broken | 8 channels, per-channel prompts + skills. getaddrinfo since mid-May |
| Telegram | ✅ Active | Default home channel |
| WhatsApp | ❌ Not configured | Two adapter options available (Baileys or Cloud API) |
| Email Triage | ❌ Broken | AttributeError since May 15 |
| Gmail Auto-Draft | ✅ Stale but working | Last ran May 16 |
| Garmin MCP | ✅ Active | 29 tools registered |
| ClickUp MCP | ✅ Active | 45+ tools via mcp-remote |
| Yahoo Mail MCP | ✅ Active | IMAP via wrapper.cjs |
| Spotify | ✅ Active | 7 built-in tools |
| QMD Semantic Search | ❌ Broken | PyTorch segfault |
| Cron Jobs | ⚠️ 7 of 19 broken | See full status table in HTML overview |
| Gateway | ⚠️ Running but stale | Weekly restart failed since May 14 |

## 🔗 Key Files

- **Config:** `~/AppData/Local/hermes/config.yaml`
- **Scripts:** `~/AppData/Local/hermes/scripts/`
- **Vault:** `C:\Users\thoma\OneDrive\Obsidian\ThomasVault`
- **QMD DB:** `~/.qmd/db.sqlite`
- **Google Token:** `~/AppData/Local/hermes/google_token.json`
- **Full capability matrix:** `~/.hermes/personal-inventory-report.md` (also copied to vault)
- **HTML overview:** `Vault/Areas/Work/Hermes Agent 24-7 Research/hermes-pa-overview.html`

## 🚀 Quick Start for WhatsApp (Baileys — recommended)

```bash
# 1. Run the WhatsApp setup wizard
hermes whatsapp

# 2. Scan QR code with your phone (WhatsApp > Settings > Linked Devices)

# 3. Add to config.yaml:
# whatsapp:
#   allowed_users: ["+31XXXXXXXXX"]  # your phone number
#   policy: "allowlist"               # only respond to allowed users

# 4. Restart gateway
hermes gateway restart
```

## 🚀 Quick Start for WhatsApp (Cloud API — official)

```yaml
# 1. Create Meta app at https://developers.facebook.com/
# 2. Add WhatsApp product, get Phone Number ID + Access Token
# 3. Set up webhook (needs public HTTPS URL via cloudflared/ngrok)
# 4. Add to config.yaml:
whatsapp_cloud:
  phone_number_id: "..."
  access_token: "..."
  app_secret: "..."
  verify_token: "..."
  allowed_users: ["+31XXXXXXXXX"]
# 5. Configure Meta webhook: subscribe to "messages" field
# 6. Restart gateway
```
