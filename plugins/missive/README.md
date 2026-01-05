# Missive Plugin for Claude Code

Full Missive API integration with drafting assistant and inbox management skills.

## Features

- **MCP Server**: 13 grouped tools covering all Missive API endpoints
- **Draft Assistant Agent**: Autonomous inbox review and draft creation
- **Skills**: draft-reply, labeling, inbox-triage, contact-management, team-assignment

## Prerequisites

- [Missive](https://missiveapp.com) account on Productive plan or higher
- API token from Missive preferences > API tab

## Setup

1. Get your API token from Missive:
   - Open Missive preferences
   - Go to API tab
   - Click "Create a new token"

2. Add token to your environment (`~/.claude/.env`):
   ```
   MISSIVE_API_TOKEN=missive_pat-your-token-here
   ```

3. Install the plugin:
   ```bash
   claude --plugin-dir /path/to/this/plugin
   ```

## Usage

### MCP Tools

Use `/mcp` to see available Missive tools:
- `missive_contacts` - Manage contacts, books, groups
- `missive_conversations` - List/get conversations, messages, comments
- `missive_drafts` - Create, send, delete drafts
- `missive_messages` - Create/get messages
- `missive_teams` - Manage teams
- `missive_users` - List users
- `missive_organizations` - List organizations
- `missive_labels` - Manage shared labels
- `missive_tasks` - Create/update tasks
- `missive_responses` - Manage canned responses
- `missive_analytics` - Create/get reports
- `missive_webhooks` - Manage webhooks
- `missive_posts` - Create/delete posts

### Draft Assistant

Ask Claude to review your inbox and create drafts:
```
Review my inbox and draft replies for conversations that need responses
```

The agent will:
- Fetch conversations needing attention
- Skip spam/newsletters
- Create brief, context-appropriate draft replies

### Skills

Skills load automatically when relevant:
- **draft-reply**: Email drafting patterns and best practices
- **labeling**: Label organization strategies
- **inbox-triage**: Prioritization and decision frameworks
- **contact-management**: Contact organization patterns
- **team-assignment**: Delegation and handoff patterns

## Rate Limits

Missive API limits:
- 5 concurrent requests
- 300 requests/minute
- 900 requests/15 minutes

The MCP server handles rate limiting automatically.
