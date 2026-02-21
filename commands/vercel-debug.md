---
description: Diagnose and fix Vercel build/deployment failures
argument-hint: [deployment-url]
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, WebFetch, Skill
---

Debug Vercel build failures. Iterative loop: get status, diagnose, fix, redeploy.

## First: Load Skills

```
Skill: vercel-deploy
Skill: frontend-design
```

## Verify Access

```bash
vercel --version
vercel whoami
vercel project ls 2>&1 | head -5
```

If not installed: `npm i -g vercel`. If not authenticated: `vercel login`. If not linked: `vercel link`.

## Iterative Debug Loop

```
1. GET STATUS → 2. DIAGNOSE → 3. FIX → 4. DEPLOY
                      ↑                    │
                      └────────────────────┘
                     (loop until success)
```

### Step 1: Get Failed Deployment

```bash
vercel ls --limit 5
vercel inspect <failed-url>
```

### Step 2: Fetch & Analyze Logs

```bash
vercel logs <deployment-url> --output raw 2>&1 | head -500
```

**Error patterns:**

| Pattern | Issue | Can Fix? |
|---------|-------|----------|
| `Type error:` | TypeScript | YES |
| `Module not found` | Missing import/dep | YES |
| `ENOENT` | Missing file (case sensitivity) | YES |
| `Build exceeded` | Memory/time limit | YES |
| `error Command failed` | Package install | YES |
| `Edge Function` | Runtime compatibility | YES |
| `Environment variable` | Missing env var | **NEEDS USER** |
| `Permission denied` | Auth/access | **NEEDS USER** |

### Step 3: Fix the Issue

- Check files mentioned in stack traces
- Review config: `vercel.json`, `next.config.js`, `package.json`
- Make minimal targeted fixes

### Step 4: Redeploy

```bash
# If production failed:
vercel --prod

# If preview failed:
git push
```

### Step 5: Verify

```bash
vercel ls --limit 1
vercel inspect <new-url>
```

**Stop conditions:**
- Build "Ready" → report success
- Fixable error → back to Step 2
- Needs user action → report what's needed and stop
- Same error after 3 attempts → escalate

## When to Stop

1. Missing environment variable — user must add in Vercel dashboard
2. API key/secret needed
3. Git permissions issue
4. Billing/limits
5. Same error after 3 fix attempts

## Common Fixes

**TypeScript:** Check tsconfig.json strict mode, add missing types
**Missing modules:** Add to dependencies (not devDependencies), check import paths
**Build memory:** Add .vercelignore, optimize imports
**Env vars:** `vercel env add SECRET_KEY` / `vercel env pull .env.local`
