---
description: Extract implementation patterns from your GitHub repos
argument-hint: <keyword or pattern to find>
allowed-tools: Bash, Read, Glob, Grep, WebFetch, mcp__claude_ai_Context7__resolve-library-id, mcp__claude_ai_Context7__query-docs
---

Search GitHub repos for how something was implemented in your other projects.

## Process

### 1. Determine search scope
If not specified, find accessible orgs:
```bash
gh api user/orgs --jq '.[].login'
gh repo list {org} --limit 50 --json name
```

### 2. Search strategically

Think first: what variations of this pattern might exist? What file names/structures would contain it? Which repos are most likely to have it?

```bash
gh search code "{keyword}" --owner {org}
gh api repos/{org}/{repo}/contents/{path}  # base64 encoded
echo "{base64}" | base64 -d
```

### 3. Fetch library docs (if relevant)
If the pattern uses a library, use Context7 to get current docs:
- `resolve-library-id` then `query-docs`

Compare the implementation against official patterns.

### 4. Synthesize findings

Return a clean summary:
- **Where found**: repo/path/file.ts
- **Implementation approach**: how it works
- **Key snippets**: minimal, relevant code
- **Library docs**: if applicable
