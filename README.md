# claudekit

Shared skills, commands, and agents for AI coding harnesses. Synced across machines via iCloud.

## Setup

All directories are symlinked from each harness's config into this repo:

```
~/.claude/skills/    → claudekit/skills/     (Claude Code)
~/.claude/commands/  → claudekit/commands/    (Claude Code)
~/.claude/agents/    → claudekit/agents/      (Claude Code)
~/.codex/skills/     → claudekit/skills/      (Codex)
~/.config/opencode/skills/  → claudekit/skills/   (OpenCode)
~/.config/opencode/agent/   → claudekit/agents/   (OpenCode)
~/.config/opencode/command/ → claudekit/commands/  (OpenCode)
```

Codex only supports skills. Claude Code and OpenCode support all three.

## Skills (21)

Auto-triggered background knowledge loaded when the agent detects a matching task.

| Skill | Description |
|-------|-------------|
| ashby | Ashby ATS API reference and recruiting workflows |
| atlas | macOS AppleScript control for ChatGPT Atlas app |
| cloudflare | Workers, Pages, Sandbox SDK, MCP client, full platform |
| council | Multi-agent codebase exploration (spawns n=10 agents) |
| docs | Write, update, or generate state diagrams for docs |
| figma | Figma-to-code via Figma MCP server |
| frontend-design | Design philosophy, constraints, accessibility, React/Next.js |
| github | Fix CI, address PR comments via gh CLI |
| himalaya | CLI email client (IMAP/SMTP/Maildir) |
| humanizer | Remove AI-writing patterns from text |
| imagegen | Generate/edit images via OpenAI Image API |
| investment | Populate investment memos + add to portfolio database |
| missive | Missive inbox management, drafting, labeling, contacts |
| openai-docs | Query OpenAI developer docs MCP |
| pdf | Read, create, fill, sign PDF/Word documents |
| playwright | Browser automation via playwright-cli |
| shaping | Collaborative solution shaping, breadboarding, slicing |
| spreadsheet | Create/edit/analyze xlsx/csv with Python |
| transcribe | Audio-to-text with diarization |
| vercel-deploy | Deploy to Vercel via bundled deploy script |
| yeet | Stage, commit, push, open PR in one flow |

## Commands (11)

User-invoked `/command` actions.

| Command | Description |
|---------|-------------|
| /ashby | Search candidates, view jobs, manage pipeline |
| /audit | 3x parallel code reviewers on changes or PRs |
| /extract-pattern | Find implementation patterns across your GitHub repos |
| /fal | Generate images, videos, audio, 3D via fal.ai |
| /fix | Auto-fix issues found by /audit |
| /frontend-design | Set up frontend project (shadcn, Tailwind, etc.) |
| /ios-release | Build and upload iOS app to App Store Connect |
| /missive | Review inbox, draft replies, or show summary |
| /restaurant-research | Multi-platform restaurant research with pricing |
| /team | Create an agent team for a task |
| /vercel-debug | Diagnose and fix Vercel build failures |

## Agents (4)

Specialized personas spawned as subagents with specific tools and models.

| Agent | Model | Description |
|-------|-------|-------------|
| engineer | inherit | Implementation, fixes, debugging (4 modes) |
| frontend-engineer | opus | Distinctive UI with browser tools |
| code-reviewer | inherit | Code review and codebase audits |
| auth-expert | opus | Auth debugging (PKCE, OAuth, cookies, sessions) |

## Adding Components

### Skill

Create `skills/<name>/SKILL.md`:

```yaml
---
name: skill-name
description: Triggers for this skill...
---

Instructions here...
```

### Command

Create `commands/<name>.md`:

```yaml
---
description: What the command does
argument-hint: [optional-arg]
allowed-tools: Tool1, Tool2
---

Instructions here...
```

### Agent

Create `agents/<name>.md`:

```yaml
---
name: agent-name
description: When to use this agent...
tools: Read, Write, Edit, Bash
model: inherit
color: red
skills:
  - skill-name
---

Instructions here...
```
