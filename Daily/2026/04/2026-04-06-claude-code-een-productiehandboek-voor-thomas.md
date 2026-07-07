---
title: "Claude Code  een productiehandboek voor Thomas"
date: 2026-04-06
source_file: "3. Personal\Personal Learning\Coding\Claude Code_ een productiehandboek voor Thomas (2026).docx"
source_type: docx
tags: [personal]
area: Areas
status: active
confidence: 0.8
imported: 2026-05-14
---

# Claude Code: een productiehandboek voor Thomas (2026)
## Onderzoek: plan, dekking en versheidsnotities
Onderzoeksplan (uitgevoerd). Ik heb eerst alle primaire (officiële) Claude Code-documentatie als “source of truth” gelezen en pas daarna community‑informatie gebruikt om gaten te vullen, patterns te valideren, en trade‑offs te benoemen. Waar community‑advies afwijkt van official behavior, behandel ik het als community‑practice (niet als feit) en leg ik het risico uit. [1]
Officiële bronnen (Anthropic / Claude Code Docs) die zijn gefetcht en gesynthetiseerd.
Dit omvat o.a. Claude Code overview; best practices; “How Claude Code works” (agentic loop, tools, context); memory (CLAUDE.md + auto‑memory); common workflows; features‑overzicht; .claude directory; context window; settings (scopes, precedence, schema, plugins); CLI reference; subagents; hooks guide + hooks reference; skills; permission modes + permissions; costs; changelog + What’s New; tools reference; sandboxing; security; scheduled tasks; VS Code; JetBrains; env‑vars; checkpointing; en GitHub Actions. [2]
Community & creator sources (secundair, expliciet gelabeld).
Gebruikt voor praktische workflows, CLAUDE.md‑voorbeelden, hook‑recepten, en “hoe power users het doen”: Builder.io’s tip‑lijst (incl. verwijzingen naar Boris‑posts), ClaudeLog aggregaties, “How Boris Uses Claude Code” (curatie van Boris‑threads), rosmur best‑practices repo/site, shanraisshan best‑practice repo, FlorianBruniaux “ultimate guide”, en een curated “Awesome CLAUDE.md” verzameling. [3]
Versheidsnotities (relevant voor 2025–2026). - De docs‑map in de officiële documentatie is recent bijgewerkt (2026‑04‑03 UTC), wat aangeeft dat navigatie/structuur en bepaalde features recent zijn. [4]
- De changelog laat actieve release‑cadence zien en bevat in april 2026 nog changes aan o.a. /release-notes en cost‑breakdowns. Neem aan dat behavior kan verschuiven per minor versie; check claude --version. [5]
- Security‑relevant recent event: eind maart/begin april 2026 was er brede berichtgeving over een onbedoelde source‑code leak rond Claude Code en misbruik daarvan via malware‑repos. Dit verandert je threat model rond “download random tooling / ‘unlocked’ builds” drastisch. [6]
## Mentale model: hoe Claude Code echt werkt
Claude Code is geen “chat”. Het is een agentic harness. Claude Code is ontworpen om je codebase te lezen, bestanden te editen, commands te runnen, en door te itereren totdat een taak “klaar” is—met jou als interrupt/steering‑laag. Dat is fundamenteel anders dan een chatbot die alleen tekst teruggeeft. [7]
De agentic loop (wat gebeurt er per cyclus). Officieel wordt de loop beschreven als drie fases die in elkaar overlopen: context verzamelen → actie nemen → resultaten verifiëren, en herhalen tot done. Claude Code beslist per stap welke tools nodig zijn op basis van wat het net geleerd heeft; jij kunt op elk moment onderbreken en bijsturen. [8]
Praktisch betekent dit: Claude’s kwaliteit is begrensd door (a) beschikbare tools + permissions, (b) actuele context, (c) verifieerbaarheid. “Verifieerbaarheid” is de grootste hefboom: als het tests, screenshots of expected output heeft, corrigeert het zichzelf veel vaker. [9]
Context window (wat gaat erin, waarom degradeert het). Claude Code’s context window bevat niet alleen “de chat”, maar ook elke file die Claude leest, command‑output, en ook content die je niet direct ziet (sommige systeem/agent‑interne dingen). Naarmate de context vult, degradeert output: “vergeten” van eerdere instructies en meer fouten is een verwacht failure‑mode. [10]
Je hebt tooling om dit zichtbaar te maken: /context geeft een visuele breakdown en waarschuwingen; en een custom status line kan continu context_window.used_percentage tonen, plus model/cost/git‑status. [11]
Auto‑compaction triggert standaard rond ~95% context; je kunt dat procent overriden met CLAUDE_AUTOCOMPACT_PCT_OVERRIDE (1–100). [12]
Tools (de “armen en benen” van Claude Code). De officiële tools‑set bevat o.a. Read, Edit, Write, Bash, zoektools (Grep, Glob), web (WebSearch, WebFetch), agent tooling (Agent voor subagents, TeamCreate voor agent teams), schedulers (CronCreate enz.), task tracking, en MCP‑resource tools. Tool‑namen zijn exact de strings die je gebruikt in permissions, hook matchers en subagent tool‑lists. [13]
Belangrijke nuance: de Bash tool runt elke command in een apart proces; working directory persisteert, maar export in één command is niet automatisch beschikbaar in de volgende. Als je persistente env wil, moet je je env vóór start klaarzetten, of een SessionStart hook gebruiken, of CLAUDE_ENV_FILE inzetten (zoals beschreven). [14]
Permissions (Claude Code kan veel, maar niet zonder expliciete policy). Claude Code werkt met permission modes + fine‑grained rules. In default mode vraagt het om approval voor edits/commands/netwerk. Modes bepalen hoe vaak dat gebeurt; rules bepalen wat wel/niet mag. [15]
Belangrijk: “bypassPermissions” (via --dangerously-skip-permissions) is expliciet gevaarlijk en bedoeld voor geïsoleerde omgevingen; bovendien blijven writes naar protected directories (o.a. .git, .claude, .vscode, .idea, .husky) alsnog beschermd, met uitzonderingen voor .claude/commands, .claude/agents, .claude/skills omdat Claude daar vaak in moet schrijven. [16]
Memory en persistentie (wat blijft hangen tussen sessies). - CLAUDE.md: instructies/context die bij start van sessies geladen worden. Het is advisory: content wordt als user message na de system prompt aangeleverd; Claude probeert te volgen, maar compliance is niet gegarandeerd, zeker bij vage/tegenstrijdige regels. [17]
- Auto memory: Claude kan “remember” opslaan in markdown files die jij kunt inzien/bewerken via /memory. [18]
- Sessieresume: conversaties worden lokaal opgeslagen; je kunt hervatten met claude -c (continue recent conversation in current directory) of via /resume (picker) of CLI flags. [19]
De harde grenzen (failure‑modes map).
Claude Code “weet” alleen wat het gelezen heeft; het kan aannames doen over je codebase en die kunnen fout zijn. Context‑vervuiling (lange sessies, veel output) is een directe kwaliteitskiller. [20]
Permissions en sandboxing beschermen je, maar zijn geen magie: als Bash te breed is toegestaan, kan Claude nog steeds via curl/wget netwerk op. Daarom benadrukt de officiële permissions doc dat argument‑constraining in Bash patterns fragiel is en dat je beter WebFetch‑domain rules of PreToolUse hooks gebruikt voor URL‑validatie. [21]
## Windows-omgeving: van nul tot operationeel
Platform‑realiteit op Windows. Claude Code ondersteunt Windows 10 1809+ en vereist Git for Windows; shell kan PowerShell/CMD/Bash zijn. [22]
Sandboxing is niet “gratis” op Windows: officiële troubleshooting vermeldt dat sandboxing WSL2 vereist; sandboxed commands kunnen geen Windows binaries onder /mnt/c/ starten. [23]
Daarnaast is er een opt‑in PowerShell tool (preview) die native PowerShell commands kan runnen; beperkingen: auto mode werkt nog niet met PowerShell tool, sandboxing niet supported, en het is alleen native Windows (niet WSL). Git Bash blijft required om Claude Code te starten. [14]
### Installatie en eerste run (Windows)
Aanbevolen install‑pad (2026): native installer. De “Advanced setup” doc noemt native install als recommended, inclusief Windows via WinGet. [24]
# Windows PowerShell (aanbevolen: winget)
winget install Anthropic.ClaudeCode

# Updaten (winget auto-updatet niet)
winget upgrade Anthropic.ClaudeCode
Op macOS/Linux/WSL is er een installer script; dat is relevant als je WSL2 gebruikt voor dev. [22]
# macOS/Linux/WSL
curl -fsSL https://claude.ai/install.sh | bash
npm‑install is niet je basisstrategie. Officieel staat “Deprecated npm installation” expliciet in dezelfde setup‑pagina; behandel npm als migratiepad/legacy, niet als default. [24]
Authenticatie (wat gebeurt er). Eerste run (claude) opent een browser login. Als je browser niet opent, kun je een URL kopiëren (c) en handmatig openen. /logout forceert re‑auth. Teams kunnen authen via Claude.ai account, Console, of cloud providers (Bedrock/Vertex/Foundry) via env vars. [25]
claude
# Volg browser login flow
# Logout + re-auth:
#   /logout
### Terminalkeuze op Windows (wat werkt in praktijk)
Drie “modes” die jij bewust kiest:
1) Native Windows (PowerShell + Git Bash aanwezig).
Beste als je tooling Windows‑native is (Visual Studio build tools, .NET, etc.). Je kunt optioneel de PowerShell tool activeren. [26]
2) WSL2 (Ubuntu e.d.).
Beste als je stack Linux‑first is (Node, Python, Go, Rust, Docker workflows) en als je sandboxing serieus wil gebruiken (WSL2 is een voorwaarde). [23]
3) Hybrid: Windows Terminal + WSL2 + editor op Windows.
Meestal de sweet spot: je code op WSL filesystem, editor op Windows. Let op IDE detect/WSL networking issues (JetBrains troubleshooting noemt dit expliciet). [27]
Rendering / UX. Als je flicker of “scroll jumps” ziet, is er een research preview “fullscreen rendering” via CLAUDE_CODE_NO_FLICKER=1. Het gebruikt de alternate screen buffer (zoals vim/htop) en voegt mouse support toe; zoekfunctie verschuift naar transcript mode (Ctrl+o). [28]
# Enable fullscreen rendering voor één sessie
$env:CLAUDE_CODE_NO_FLICKER="1"
claude
### Editor‑integratie (werk “sidecar”: terminal + editor)
VS Code (aanbevolen voor VS Code users). De officiële extension is de aanbevolen manier in VS Code. Je krijgt een native panel, diff review, plan review, @‑mentions van selectie, meerdere sessies in tabs/windows, en de CLI zit erbij (je kunt CLI-only features in de integrated terminal doen). [29]
Cruciaal detail: in VS Code Plan mode opent VS Code het plan als markdown doc waar je inline comments kunt geven vóór execution. [30]
JetBrains. Plugin ondersteunt o.a. quick launch (Ctrl+Esc), diff viewer in IDE, selection context, file reference shortcuts, en diagnostic sharing. /ide kan ook een externe terminal verbinden. JetBrains docs waarschuwen expliciet dat auto‑edit permissions in JetBrains risico’s kan verhogen (IDE config files met auto‑execute gedrag). [31]
### Config‑hiërarchie en “waar zet ik wat”
Scopes (dit is niet optioneel; dit bepaalt team‑discipline). Claude Code heeft scopes: Managed, User, Project, Local. Precedence: Managed > CLI args > Local > Project > User. Project settings zijn deelbaar via git; local is gitignored. [32]
Belangrijke bestanden. - ~/.claude/settings.json (user) en .claude/settings.json (project) en .claude/settings.local.json (local). [32]
- ~/.claude.json: bevat preferences (theme/editor mode), OAuth session, MCP server configs (user/local), trust state, caches; project MCP staat in .mcp.json. [33]
- CLAUDE.md locaties: user (~/.claude/CLAUDE.md), project (CLAUDE.md of .claude/CLAUDE.md), local (CLAUDE.local.md). [34]
### Baseline settings.json (productie‑waardig, Windows‑friendly)
Dit is een volledig werkend startpunt. Zet dit in .claude/settings.json als team‑baseline en override persoonlijk in .claude/settings.local.json. Gebruik $schema voor autocomplete/validatie. [35]
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",

  "defaultMode": "acceptEdits",

  "permissions": {
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Read(./config/credentials.json)",
      "Bash(curl *)",
      "Bash(wget *)",
      "Bash(git push *)"
    ],
    "allow": [
      "Bash(git status)",
      "Bash(git diff *)",
      "Bash(git add *)",
      "Bash(git commit *)",
      "Bash(npm run lint)",
      "Bash(npm test *)",
      "WebFetch(domain:github.com)"
    ]
  },

  "sandbox": {
    "enabled": false,
    "failIfUnavailable": false,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": ["docker *"],
    "filesystem": {
      "allowWrite": ["./.claude/tmp", "/tmp"],
      "denyRead": ["~/.aws/credentials"]
    },
    "network": {
      "allowedDomains": ["github.com", "*.npmjs.org", "registry.yarnpkg.com"],
      "allowUnixSockets": ["/var/run/docker.sock"],
      "allowLocalBinding": true
    }
  },

  "attribution": {
    "commit": "Generated with [Claude Code](https://claude.com/claude-code)\n\nCo-Authored-By: Claude <[email protected]>",
    "pr": "Generated with [Claude Code](https://claude.com/claude-code)"
  },

  "env": {
    "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "90",
    "MAX_MCP_OUTPUT_TOKENS": "25000"
  },

  "statusLine": {
    "type": "command",
    "command": "powershell -NoProfile -File C:/Users/Thomas/.claude/statusline.ps1",
    "padding": 1
  },

  "enabledPlugins": {},
  "extraKnownMarketplaces": {}
}
Waarom deze defaults: - acceptEdits haalt frictie uit iterative coding, maar laat je nog steeds controle houden over Bash/network‑impact via permissions. [36]
- .env/secrets deny rules voorkomen dat Claude ze “per ongeluk” in context trekt via Read/Grep/Glob (let op: dit blokkeert niet cat .env in Bash; daarvoor heb je sandbox nodig). [37]
- Autocompact vroeger (90%) is een kwalitatieve keuze voor lange sessies: minder “laat” compaction‑paniek. De default is ~95%. [12]
- Statusline op Windows draait via Git Bash shell, maar kan PowerShell aanroepen; dit is expliciet gedocumenteerd. [38]
Minimal statusline.ps1 (werkt). [39]
# C:\Users\Thomas\.claude\statusline.ps1
$inputJson = Get-Content -Raw
$data = $inputJson | ConvertFrom-Json

$model = $data.model.display_name
$pct = [int]($data.context_window.used_percentage)
$cost = "{0:N2}" -f $data.cost.total_cost_usd
$dir = Split-Path -Leaf $data.workspace.current_dir

Write-Output ("[{0}] {1} | {2}% ctx | ${3}" -f $model, $dir, $pct, $cost)
### Kosten en modelkeuze (realistisch, niet “AI-magie”)
Wat /cost wel/niet betekent. /cost is primair voor API users; Pro/Max subscribers hebben usage “in subscription” en gebruiken /stats voor patronen. /cost toont token usage stats voor de sessie. [40]
De officiële cost guide geeft ook concrete gemiddelden (met variatie): o.a. “~$6 per dev per dag” en “~$100–200/dev per maand met Sonnet 4.6” (variance afhankelijk van instances/automation). [41]
Modelkeuze: Sonnet vs Opus. Officieel: Sonnet is “goed voor meeste coding tasks”; Opus is sterker voor complexe architectuur/reasoning. Je switcht met /model of claude --model. [42]
Effort (denken) is een echte dial. /effort low|medium|high|max|auto bestaat als built‑in command en werkt direct. Gebruik high/max alleen waar reasoning echt de bottleneck is. [43]
## Dagelijkse workflow: van idee naar ship
Hier zit je “elite‑niveau” hefboom: jij bouwt een systeem waarin Claude Code consequent goed werk kan leveren.
### Het kernproces (Explore → Plan → Implement → Verify → Commit)
Explore (altijd eerst, tenzij je 100% zeker bent). Laat Claude zelf files zoeken en lezen; verwijs waar mogelijk met @ naar echte files i.p.v. beschrijven. Best‑practices benadrukken: “Explore first, then plan, then code.” [44]
Plan (Plan mode als safety‑rail, niet als religie). - Plan mode is een permission mode waarin Claude kan analyseren maar niet modifies/commands uitvoert. [45]
- In de CLI cycle je default → acceptEdits → plan met Shift+Tab; twee keer drukken vanaf default brengt je naar plan (zolang auto/bypass niet in cycle zit). [46]
- Je kunt plan mode direct starten met /plan [description]. [47]
Implement (delegate, maar met gates). Laat Claude edits doen, maar forceer gates: “run tests, fix failures, then commit”. Officiële best practices noemen verifieerbaarheid de hoogste hefboom. [48]
Verify (maak het onvermijdelijk). Je prompts moeten succescriteria bevatten: test commands, expected output, screenshot compare voor UI, linter/typecheck. Dit is letterlijk een officiële “single highest‑leverage thing”. [9]
Commit (kleine, veilige stappen). Claude Code kent je git‑state (branch, uncommitted changes, recent commits) en kan staging/commit commands runnen als je het toestaat. [49]
Aanbevolen discipline: commit per “werkend increment” (tests groen). Je combineert dit met checkpoints (rewind) als extra safety net. [50]
### Session management (context is je brandstof)
/clear versus /compact versus rewind summarize. - /clear reset conversation history en maakt context vrij; best practices adviseren dit tussen ongerelateerde taken. [51]
- /compact [instructions] comprimeert de conversation met optionele focus. [51]
- Esc Esc of /rewind geeft een menu per prompt checkpoint met opties: restore code+conversation, restore conversation, restore code, of “Summarize from here” (targeted compaction), etc. [52]
Checkpointing (wat het wel/niet vangt). Checkpoints volgen changes gedaan door Claude’s file editing tools; het is geen vervanger voor git. Externe processen (migrations, DB changes) worden niet automatisch “undo” door checkpointing. [50]
### Resume, parallel work en worktrees (productiviteit zonder chaos)
Resume commands. - CLI: claude -c continue most recent conversation in current directory. [53]
- Built‑in: /resume (alias /continue) opent session picker; /rename labelt sessies. [51]
Worktrees (de juiste manier om parallel te runnen). Officiële workflow: claude --worktree <name> maakt een geïsoleerde checkout onder <repo>/.claude/worktrees/<name> en werkt op een eigen branch worktree-<name>. Branch basis is origin/HEAD (niet configureerbaar via Claude flag); je kunt origin/HEAD resyncen met git remote set-head origin -a, of volledig custom behavior doen via WorktreeCreate hook. [54]
Zet .claude/worktrees/ in .gitignore om te voorkomen dat worktree contents als untracked in je “main” repo verschijnen. [55]
Copy gitignored files naar worktrees. Officieel: .worktreeinclude in project root (gitignore‑syntax) om gitignored files zoals .env te kopiëren naar worktrees; tracked files worden nooit gedupliceerd. [56]
### Prompting patterns die consistent werken (geen fluff)
Het format dat je 80% van de tijd gebruikt:
Doel:
- [wat moet er veranderen]

Context:
- Lees: @path/naar/belangrijke/file.ts
- Volg pattern uit: @path/naar/referentie-implementatie.ts

Constraints:
- Niet doen: [explicit non-goals]
- Vereist: [libraries, conventions, performance/security constraints]

Verify:
- Run: npm test
- Run: npm run lint
- Expected: [concrete behavior]

Deliver:
- Maak commits per working step met message: "<scope>: <wat>"
Waarom dit werkt: het voedt de agentic loop precies met (1) waar te kijken, (2) wat niet, (3) hoe te checken. Best practices hameren op “be specific upfront” en “give Claude something to verify against”. [57]
Als je prompt lang wordt: open editor. In interactive mode bestaat Ctrl+G (of Ctrl+X Ctrl+E) om je prompt in je default editor te bewerken. Gebruik dit voor specs/plan reviews en voorkom halfbakken multiline input. [58]
## Automatisering en schaal: hooks, subagents, plugins en MCP
### CLAUDE.md en rules (jouw “human policy layer”)
Wat CLAUDE.md doet. Officieel: CLAUDE.md is een markdown file die Claude Code aan het begin van elke sessie leest om coding standards, architecture decisions, preferred libraries, enz. vast te leggen. [59]
Belangrijk detail: CLAUDE.md is advisory (user message na system prompt). Als je 100% determinisme wilt, zet regels in hooks/permissions. [60]
200‑line discipline. Officieel advies: files >200 lines consumeren meer context en kunnen adherence verminderen; splits details uit en verwijs via @path imports. [61]
Path‑specific rules. Officieel: rules kunnen scoped worden naar files via YAML frontmatter met paths. Gebruik dit om niet je hele repo te belasten met elke regel. [62]
### Hooks (deterministische automation)
Wat hooks zijn. Hooks zijn user‑defined shell commands (of HTTP/prompt hooks) die op lifecycle events draaien (pre/post tool use, session start/end, compaction, worktree events, notifications, enz.). Ze zijn bedoeld voor deterministische controle: format/lint, block commands, notify, inject context. [63]
Hook‑pattern: block destructieve commands. Officieel voorbeeld: PreToolUse hook op Bash die rm -rf denyt via JSON output. [64]
Productie hook‑set (copy‑paste, werkt). Zet dit in .claude/settings.json (project) als baseline. Pas commands aan per stack.
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/prevent-dangerous-bash.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/after-edit.sh"
          }
        ]
      },
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/after-write.sh"
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -NoProfile -Command \"[console]::beep(800,200)\""
          }
        ]
      }
    ],
    "PostCompact": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/post-compact-reminder.sh"
          }
        ]
      }
    ]
  }
}
Event‑namen en het feit dat hooks JSON context krijgen en per matcher werken is officieel gedocumenteerd; Notification hooks zijn expliciet een standaard use‑case. [65]
Scripts (volledig).
.claude/hooks/prevent-dangerous-bash.sh (blokkeert rm -rf en git push; uitbreidbaar):
#!/usr/bin/env bash
set -eu

input="$(cat)"
cmd="$(echo "$input" | jq -r '.tool_input.command // ""')"

deny() {
  local reason="$1"
  jq -n --arg reason "$reason" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $reason
    }
  }'
  exit 0
}

if echo "$cmd" | grep -Eq '(^|[[:space:]])rm[[:space:]]+-rf([[:space:]]|$)'; then
  deny "Blocked: rm -rf is forbidden by policy"
fi

if echo "$cmd" | grep -Eq '^git[[:space:]]+push'; then
  deny "Blocked: git push is forbidden; use PR workflow"
fi

exit 0
.claude/hooks/after-edit.sh (run formatter/lint, maar houd het snel; anders hindert het flow):
#!/usr/bin/env bash
set -eu

# Voorbeeld Node/TS. Pas aan per repo.
if [ -f package.json ]; then
  npm run -s lint || exit 0
fi
exit 0
.claude/hooks/post-compact-reminder.sh (herinjecteer “wat is het doel” na compaction):
#!/usr/bin/env bash
set -eu

cat <<'EOF'
[REMINDER AFTER COMPACT]
- Current goal: keep working on the last accepted task.
- Always run tests before declaring done.
- Always list modified files and current branch before final summary.
EOF
Waarom dit niet “over-automation” is: je gebruikt hooks voor regels die je nooit wil laten afhangen van probabilistische compliance (formatting, “no rm -rf”, “geen git push”). Dat is exact de rol van hooks. [66]
### Subagents (context isolatie die je main sessie schoon houdt)
Officieel model. Subagents zijn gespecialiseerde assistants in een eigen context window met eigen system prompt, tool access en (eventueel) eigen model; ze besparen context en kunnen goedkopere modellen gebruiken (bijv. Haiku). Claude gebruikt hun description om te besluiten wanneer te delegeren; er zijn built‑ins zoals Explore en Plan. [67]
Subagent file (volledig, correct frontmatter). Plaats in .claude/agents/code-reviewer.md:
---
name: code-reviewer
description: Reviews code for quality, security, and consistency with repository conventions
tools: Read, Glob, Grep
model: sonnet
---
You are a senior code reviewer.

Rules:
- Only review; do not propose large refactors unless there is a concrete bug/security risk.
- Prefer actionable, file/line-specific feedback.
- Call out: unsafe input handling, auth gaps, logging of secrets, injection risks.
- End with: "Approve" or "Request changes" and a numbered list of blocking items.
Deze structuur (YAML frontmatter + markdown body) en velden (name, description, tools, model, etc.) zijn officieel gespecificeerd. [68]
Inline MCP servers scoped to subagent (clean main context). Officieel kan mcpServers in frontmatter een inline server definitie bevatten (bijv. Playwright) zodat tool schemas niet je hoofdcontext vervuilen. [69]
### Agent teams (experimental, duurder, soms goud)
Wat het is. Agent teams orkestreren meerdere Claude Code sessies als team; één lead, teammates met eigen context, shared task list, en directe messaging tussen teammates. Experimental; enable met CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS. Verwacht limitations rond resumption/coordination/shutdown. [70]
Officieel advies: gebruik teams voor parallel research/review, debugging met competing hypotheses, of cross‑layer werk; niet voor sequential/same‑file coordination. [71]
### Skills, commands en plugins (herbruikbare expertise)
Skills. Officieel: skills zijn markdown instructies; je maakt een SKILL.md file en Claude voegt het toe aan toolkit; Claude kan skills automatisch gebruiken of jij invoked met /skill-name. [72]
De Agent SDK overview laat de conventie zien: .claude/skills/*/SKILL.md en slash commands in .claude/commands/*.md. [73]
Plugin system. Officieel: plugins bundelen skills, agents/subagents, hooks en MCP servers en kunnen via marketplaces geïnstalleerd worden; plugin skills zijn namespaced (/my-plugin:review) zodat meerdere plugins kunnen co‑existeren. [74]
Je kunt marketplaces centraal beheren (managed settings) en restricties zetten (strictKnownMarketplaces, allowlists). [75]
### MCP servers (Claude’s bereik vergroten)
Wat MCP is in Claude Code context. MCP is de open standaard waarmee Claude Code tools/resources/prompts van externe servers kan gebruiken. Claude Code kan MCP servers configureren via claude mcp ...; project scope configs staan in .mcp.json (check in git), user/local in ~/.claude.json. Project‑scoped servers vereisen approval voor gebruik; je kunt approval resetten met claude mcp reset-project-choices. [76]
Minimal .mcp.json (project‑shared, met env var expansion). [77]
{
  "mcpServers": {
    "sentry": {
      "type": "http",
      "url": "https://mcp.sentry.dev/mcp"
    },
    "db": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@bytebase/dbhub", "--dsn", "${READONLY_DSN}"],
      "env": {}
    },
    "api-server": {
      "type": "http",
      "url": "${API_BASE_URL:-https://api.example.com}/mcp",
      "headers": {
        "Authorization": "Bearer ${API_KEY}"
      }
    }
  }
}
MCP output discipline. Claude Code waarschuwt bij MCP tool output >10k tokens; default max is 25k; overridable met MAX_MCP_OUTPUT_TOKENS. [78]
### Non‑interactive / programmatic usage (CI, scripts)
CLI/SDK mode. claude -p "query" runt via SDK en exit; dit is de basis voor CI automation. “Headless mode” is nu gedocumenteerd als Agent SDK usage; flags blijven hetzelfde. [79]
### Scheduled tasks (/loop, /schedule)
Drie schedulings: Cloud, Desktop, /loop. Officieel overzicht: cloud tasks runnen op Anthropic infra (machine hoeft niet aan), desktop tasks op jouw machine (app open), /loop is session‑scoped (verdwijnt bij exit). [80]
/loop is een bundled skill; minimum interval 1 minute; scheduled tasks vereisen Claude Code v2.1.72+. [81]
## Security en safety: agentic tooling zonder spijt
### Permission modes en rules (de echte veiligheidsgrens)
Modes (officieel). default, acceptEdits, plan, auto, dontAsk, bypassPermissions; switch in CLI met Shift+Tab (default→acceptEdits→plan). Auto mode vereist opt‑in (--enable-auto-mode of setting). dontAsk zit niet in cycle. [82]
Auto mode is een research preview met classifier checks; het laat meer autonoom werk toe maar blokt risk‑achtige acties/scope escalations. [83]
Rule‑syntax (officieel en belangrijk). Rules zijn Tool of Tool(specifier); evaluatie: deny → ask → allow; first match wins. Bash wildcards zijn glob‑based; “space before *” is semantisch (word boundary). Claude is aware of shell operators (&&) zodat prefix‑match niet triviaal bypassed wordt, maar argument‑constraining blijft fragiel—voor URL filtering: liever WebFetch domain rules of PreToolUse hooks. [84]
### Sandboxing (OS‑level enforcement voor Bash)
Wat sandboxing oplost. Permissions blokkeren tool‑calls; sandboxing beperkt Bash subprocesses op OS‑niveau (filesystem + network) en is bedoeld als defense‑in‑depth. Je kunt sandbox filesystem paths configureren en die worden gemerged met paths uit Read/Edit permission rules. [85]
### Secrets en gevoelige files (praktisch beleid)
Zonder sandbox is .env deny niet genoeg. Officieel: Read/Edit deny rules gelden voor built‑in file tools, niet voor Bash subprocesses (cat .env). Als je echt wilt afdwingen dat secrets niet uitlekken via shell, moet je sandboxing gebruiken of Bash network/file access beperken. [37]
Repository hygiene (minimaal). - .gitignore: voeg .claude/worktrees/ toe (officiële guidance). [55]
- Zet secrets niet in .mcp.json; gebruik env var expansion en inject keys via env/secret stores. [86]
### Prompt injection (realistisch threat model)
Claude Code is gevaarlijker dan een chat omdat het tools heeft. Prompt injection kan binnenkomen via: - bestanden in je repo (malicious docs / instructions), - dependencies / generated files, - tool output (web fetch, MCP output), - third‑party skills/plugins.
Officiële mitigaties: permissions, sandboxing, managed settings, hook allowlists voor HTTP hooks, en het beperken van environment variable exposure (bijv. CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1 om credentials uit subprocess envs te strippen). [87]
### Plugins/skills/mcp supply chain: harde regels (2026 realiteit)
Nooit “random binaries”. Door de recente leak‑hype is er actief misbruik met malware repos die “unlocked enterprise features” beloven. Dat is geen hypothetisch risico; het is actueel. [88]
Pre‑install checklist (5 minuten, maar je doet ’m altijd): - Is de source officieel (Anthropic marketplace / bekende org) of een repo met reputatie/logging? - Is installatie “source‑based” (git) vs “download exe”? Exe = nee. - Beperk plugin marketplaces via managed settings of team policy (strictKnownMarketplaces). [75]
- Zet permissions tight (+ PreToolUse hooks) vóór je auto/bypass modes gebruikt. [89]
### Data usage en retentie (wat blijft waar)
Claude Code heeft enterprise features zoals Zero Data Retention (ZDR) voor Enterprise; data usage doc beschrijft o.a. lokale caching van sessions tot 30 dagen (configurable) voor resumption, en dat je sessions kunt verwijderen. [90]
## Archetypen en naslag: templates, checklists en referenties
### Project archetypen (snelle, complete startpunten)
Alle archetypen hieronder volgen dezelfde structuur: (1) repo layout, (2) CLAUDE.md template, (3) hooks, (4) MCP, (5) git discipline, (6) failure modes, (7) opening prompt.
TypeScript / Node.js backend API
Directory layout (minimaal).
.
├─ src/
├─ test/
├─ package.json
├─ tsconfig.json
├─ CLAUDE.md
└─ .claude/
   ├─ settings.json
   ├─ hooks/
   │  ├─ prevent-dangerous-bash.sh
   │  └─ after-edit.sh
   └─ agents/
      └─ code-reviewer.md
CLAUDE.md (compact, production). Officieel: CLAUDE.md wordt aan start geladen; houd kort voor adherence. [59]
# Project rules (Node/TS API)

## Non-negotiables
- ALWAYS run: `npm test` and `npm run lint` before declaring done.
- NEVER run: `git push` (PR-only workflow).
- Do not read or print secrets: `.env*`, `secrets/**`.

## Stack
- TypeScript, Node.js. Prefer existing patterns in `src/`.
- Use existing logging/error middleware patterns.

## Conventions
- Prefer small commits (one logical unit, tests green).
- If uncertain: enter plan mode first (`/plan ...`).

## Common commands
- Install: `npm ci`
- Test: `npm test`
- Lint: `npm run lint`
Hooks. PostToolUse on Edit/Write triggers lint; PreToolUse blocks git push/rm -rf (zie hook set). Hooks zijn bedoeld om format/lint/block deterministic te maken. [91]
MCP. Alleen als nodig: Sentry (prod errors), DB readonly (via stdio server), GitHub tooling via gh CLI of MCP. Let op: MCP tool output caps. [92]
Opening prompt.
Explore the codebase and explain:
- how requests flow through middleware
- where auth is enforced
Then propose a plan for adding <feature>. Include exact files and test commands.
React / Next.js frontend
Key advice: UI werk vereist verifieerbaarheid (screenshots/visual diffs). Best practices noemen expliciet screenshot‑based verification. [93]
Opening prompt (UI).
I will paste a screenshot. Implement the UI to match it.
Verify by taking a screenshot of the result and listing differences to the target.
Full‑stack (Next.js + tRPC of vergelijkbaar)
Failure mode: Claude “verliest” cross‑layer constraints (API contract ↔ UI). Mitigatie: specs + tests + subagent reviewer die contract checkt. Subagents zijn officieel bedoeld om research/verification te isoleren. [94]
Python backend / FastAPI
Hook focus: ruff/pytest run na edits; sandboxing nuttig als je veel CLI‑tooling runt. [95]
Python data / ML project
Context discipline: veel notebooks/outputs → context bloat. Gebruik subagents voor exploration en beperk wat je in chat plakt; statusline helpt. [96]
Monorepo (Turborepo / Nx)
Belangrijk: file discovery en typed diagnostics. Officiële docs adviseren code intelligence plugins voor typed languages voor automatische error detection na edits. [97]
Infrastructure / DevOps (Terraform, Docker, CI/CD)
Non‑negotiable: permissions & sandboxing streng; block destructive commands; laat Claude in plan mode starten en laat het expliciet zeggen welke commands het wil runnen. [98]
Real estate / finance tooling (jouw domein)
Dominante risico’s: privacy/PII, audit trails, “prod data veilig”. Officiële guidance rond permissions + ZDR + data usage is relevant; daarnaast: “never connect direct to prod DB” als policy afdwingen door MCP servers alleen readonly/staging te maken en .mcp.json via env vars te laten injecten. [99]
### MCP server bouwen (minimal working example, TypeScript)
Als je eigen tooling wilt exposen (intern API, indexer, feature flags), bouw je een MCP server. Officiële MCP SDK voor TypeScript: @modelcontextprotocol/sdk + zod (peer dependency). [100]
Project setup.
mkdir my-mcp-server && cd my-mcp-server
npm init -y
npm install @modelcontextprotocol/sdk zod
npm install -D tsx typescript
Server: stdio transport (lokaal, veiligst). Dit voorbeeld expose’t één tool ping die een string teruggeeft. Het gebruikt de SDK‑lijn die de officiële docs noemen (McpServer uit @modelcontextprotocol/sdk/server/mcp.js, stdio transport). [101]
// src/index.ts
import { z } from "zod";
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

const server = new McpServer({
  name: "my-mcp-server",
  version: "0.1.0"
});

server.tool(
  "ping",
  { message: z.string() },
  async ({ message }) => {
    return {
      content: [{ type: "text", text: `pong: ${message}` }]
    };
  }
);

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch((err) => {
  // Schrijf naar stderr; stdio protocol moet stdout schoon houden
  console.error(err);
  process.exit(1);
});
Run.
npx tsx src/index.ts
Claude Code koppelen (project‑scoped via .mcp.json). [77]
{
  "mcpServers": {
    "myserver": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "tsx", "src/index.ts"],
      "env": {}
    }
  }
}
### Quick reference (dagelijks)
CRITICAL / HIGH / POWER / TIP matrix (korte waarheid). - CRITICAL: “Geef Claude iets om te verifiëren” (tests/screenshot/expected output). [9]
- CRITICAL: Permissions + deny secrets + block destructive Bash (rules + PreToolUse hook). [102]
- HIGH: /clear tussen ongerelateerde tasks; context bloat is real. [103]
- HIGH: Worktrees voor parallel sessions (claude --worktree). [104]
- POWER: Statusline met context/cost; beslis vroeg, niet bij 99%. [105]
- POWER: Subagents voor research/verification (context isolatie). [94]
- TIP: Fullscreen rendering als je terminal bottlenecked (CLAUDE_CODE_NO_FLICKER=1). [28]
Essentiële built‑ins (onthouden).
/plan, /permissions, /context, /cost (API), /stats (subs), /compact, /clear, /rewind, /hooks, /mcp, /statusline, /effort, /install-github-app. [106]
Session startup checklist (60 sec). 1) Ben je in de juiste directory (project root)? (Claude’s default file access is start directory + subdirs.) [107]
2) Check mode: default/acceptEdits/plan? (Shift+Tab). [108]
3) Check statusline/context: <70%? (Heuristiek: als >80%: compact/rewind summarize/clear plannen.) [109]
4) Run in plan mode als scope onduidelijk is (/plan). [110]
Session close checklist (2 min). - /diff en sanity check wat er veranderd is. [111]
- Zorg dat tests groen zijn (jouwe policy; maar verification is official best practice). [9]
- Commit(s) per increment (en push via PR). [112]
- Vraag Claude: “Welke 5 regels moeten in CLAUDE.md zodat dit morgen sneller/veiliger is?” (CLAUDE.md is bedoeld voor conventions/checklists). [59]
Nieuwe project checklist (15 min). - Maak .claude/settings.json + .claude/hooks/* + .claude/agents/code-reviewer.md. [113]
- Voeg .claude/worktrees/ toe aan .gitignore. [55]
- Schrijf CLAUDE.md <200 lines met non‑negotiables + verify commands. [17]
- Kies MCP alleen als het echt waarde levert; cap outputs. [114]
Deze gids is gebouwd rond het officiële model: agentic loop + tools + context + permissions, met deterministische enforcement via hooks en schaal via subagents/worktrees/agent teams. [115]

[1] [4] https://code.claude.com/docs/en/claude_code_docs_map
https://code.claude.com/docs/en/claude_code_docs_map
[2] [7] [59] https://code.claude.com/docs/en/overview
https://code.claude.com/docs/en/overview
[3] https://www.builder.io/blog/claude-code-tips-best-practices
https://www.builder.io/blog/claude-code-tips-best-practices
[5] https://code.claude.com/docs/en/changelog
https://code.claude.com/docs/en/changelog
[6] [88] https://www.techradar.com/pro/security/be-careful-what-you-click-hackers-use-claude-code-leak-to-push-malware
https://www.techradar.com/pro/security/be-careful-what-you-click-hackers-use-claude-code-leak-to-push-malware
[8] [42] [49] [57] [115] https://code.claude.com/docs/en/how-claude-code-works
https://code.claude.com/docs/en/how-claude-code-works
[9] [10] [20] [44] [48] [83] [93] [96] [97] [103] https://code.claude.com/docs/en/best-practices
https://code.claude.com/docs/en/best-practices
[11] [43] [47] [51] [106] [110] [111] https://code.claude.com/docs/en/commands
https://code.claude.com/docs/en/commands
[12] https://code.claude.com/docs/en/env-vars
https://code.claude.com/docs/en/env-vars
[13] [14] [26] https://code.claude.com/docs/en/tools-reference
https://code.claude.com/docs/en/tools-reference
[15] [46] [82] [108] https://code.claude.com/docs/en/permission-modes
https://code.claude.com/docs/en/permission-modes
[16] [21] [36] [37] [45] [84] [87] [89] [98] [102] [107] [112] https://code.claude.com/docs/en/permissions
https://code.claude.com/docs/en/permissions
[17] [18] [60] [61] [62] https://code.claude.com/docs/en/memory
https://code.claude.com/docs/en/memory
[19] [53] [79] https://code.claude.com/docs/en/cli-reference
https://code.claude.com/docs/en/cli-reference
[22] [24] https://code.claude.com/docs/en/setup
https://code.claude.com/docs/en/setup
[23] https://code.claude.com/docs/en/troubleshooting
https://code.claude.com/docs/en/troubleshooting
[25] https://code.claude.com/docs/en/authentication
https://code.claude.com/docs/en/authentication
[27] [31] https://code.claude.com/docs/en/jetbrains
https://code.claude.com/docs/en/jetbrains
[28] https://code.claude.com/docs/en/fullscreen
https://code.claude.com/docs/en/fullscreen
[29] [30] https://code.claude.com/docs/en/vs-code
https://code.claude.com/docs/en/vs-code
[32] [33] [34] [35] [75] [85] [113] https://code.claude.com/docs/en/settings
https://code.claude.com/docs/en/settings
[38] [39] [105] [109] https://code.claude.com/docs/en/statusline
https://code.claude.com/docs/en/statusline
[40] [41] https://code.claude.com/docs/en/costs
https://code.claude.com/docs/en/costs
[50] [52] https://code.claude.com/docs/en/checkpointing
https://code.claude.com/docs/en/checkpointing
[54] [55] [56] [104] https://code.claude.com/docs/en/common-workflows
https://code.claude.com/docs/en/common-workflows
[58] https://code.claude.com/docs/en/interactive-mode
https://code.claude.com/docs/en/interactive-mode
[63] [65] [66] [91] [95] https://code.claude.com/docs/en/hooks-guide
https://code.claude.com/docs/en/hooks-guide
[64] https://code.claude.com/docs/en/hooks
https://code.claude.com/docs/en/hooks
[67] [68] [69] [94] https://code.claude.com/docs/en/sub-agents
https://code.claude.com/docs/en/sub-agents
[70] [71] https://code.claude.com/docs/en/agent-teams
https://code.claude.com/docs/en/agent-teams
[72] https://code.claude.com/docs/en/skills
https://code.claude.com/docs/en/skills
[73] https://docs.claude.com/en/docs/agent-sdk/overview?_bhlid=d3a87e1e395f16df49ee4296fc8c6532e776f4e6
https://docs.claude.com/en/docs/agent-sdk/overview?_bhlid=d3a87e1e395f16df49ee4296fc8c6532e776f4e6
[74] https://code.claude.com/docs/en/discover-plugins
https://code.claude.com/docs/en/discover-plugins
[76] [77] [78] [86] [92] [99] [114] https://code.claude.com/docs/en/mcp
https://code.claude.com/docs/en/mcp
[80] [81] https://code.claude.com/docs/en/scheduled-tasks
https://code.claude.com/docs/en/scheduled-tasks
[90] https://code.claude.com/docs/en/zero-data-retention
https://code.claude.com/docs/en/zero-data-retention
[100] https://ts.sdk.modelcontextprotocol.io/
https://ts.sdk.modelcontextprotocol.io/
[101] https://ts.sdk.modelcontextprotocol.io/documents/server.html
https://ts.sdk.modelcontextprotocol.io/documents/server.html