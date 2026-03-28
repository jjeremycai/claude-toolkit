---
name: "gh-fix-ci"
description: "Use when a user asks to debug or fix failing GitHub PR checks that run in GitHub Actions; use `gh` to inspect checks and logs, summarize failure context, draft a fix plan, and implement only after explicit approval. Treat external providers (for example Buildkite) as out of scope and report only the details URL."
---


# Gh Pr Checks Plan Fix

## Overview

Use gh to locate failing PR checks, fetch GitHub Actions logs for actionable failures, summarize the failure snippet, then propose a fix plan and implement after explicit approval.
- If a plan-oriented skill (for example `create-plan`) is available, use it; otherwise draft a concise plan inline and request approval before implementing.
- After identifying the failing check, reproduce the exact repo command locally when feasible before editing. Prefer the same command CI runs (`bun run lint`, `pnpm test`, `npm run build`, etc.) so you can confirm the failure and verify the fix without depending solely on remote logs.
- If the user has already explicitly approved implementation or explicitly asked you to land the fix directly on `main`, do not stop to re-request approval. Implement the fix, then stage only the files relevant to that approved change.

Prereq: authenticate with the standard GitHub CLI once (for example, run `gh auth login`), then confirm with `gh auth status` (repo + workflow scopes are typically required).

## Inputs

- `repo`: path inside the repo (default `.`)
- `pr`: PR number or URL (optional; defaults to current branch PR)
- `gh` authentication for the repo host

## Quick start

- `python "<path-to-skill>/scripts/inspect_pr_checks.py" --repo "." --pr "<number-or-url>"`
- Add `--json` if you want machine-friendly output for summarization.

## Workflow

1. Verify gh authentication.
   - Run `gh auth status` in the repo.
   - If unauthenticated, ask the user to run `gh auth login` (ensuring repo + workflow scopes) before proceeding.
2. Resolve the PR.
   - Prefer the current branch PR: `gh pr view --json number,url`.
   - If the user provides a PR number or URL, use that directly.
3. Inspect failing checks (GitHub Actions only).
   - Preferred: run the bundled script (handles gh field drift and job-log fallbacks):
     - `python "<path-to-skill>/scripts/inspect_pr_checks.py" --repo "." --pr "<number-or-url>"`
     - Add `--json` for machine-friendly output.
   - Manual fallback:
     - `gh pr checks <pr> --json name,state,bucket,link,startedAt,completedAt,workflow`
       - If a field is rejected, rerun with the available fields reported by `gh`.
     - For each failing check, extract the run id from `detailsUrl` and run:
       - `gh run view <run_id> --json name,workflowName,conclusion,status,url,event,headBranch,headSha`
       - `gh run view <run_id> --log`
     - If the run log says it is still in progress, fetch job logs directly:
       - `gh api "/repos/<owner>/<repo>/actions/jobs/<job_id>/logs" > "<path>"`
4. Scope non-GitHub Actions checks.
   - If `detailsUrl` is not a GitHub Actions run, label it as external and only report the URL.
   - Do not attempt Buildkite or other providers; keep the workflow lean.
5. Reproduce locally before editing.
   - If the workflow or logs make the failing command clear, run the same command locally and capture the concrete failure.
   - Prefer local reproduction before code changes because it is faster to iterate and gives a direct verification target.
   - If local reproduction is blocked by missing secrets, unavailable services, or purely remote-only infrastructure, say so and continue with the best evidence from GitHub logs.
6. Summarize failures for the user.
   - Provide the failing check name, run URL (if any), and a concise log snippet.
   - Include the local reproduction result when you have one, especially if it narrows the problem more clearly than the remote logs.
   - Call out missing logs explicitly.
7. Create a plan.
   - Use the `create-plan` skill to draft a concise plan and request approval.
8. Implement after approval.
   - Apply the approved plan and summarize diffs/tests.
   - If the user explicitly asked to land on `main`, commit and push directly to `main`.
   - If the repo has unrelated dirty or untracked changes, stage only the files for the approved fix. Do not sweep in unrelated work.
   - Otherwise, ask about opening a PR.
9. Recheck status.
   - After changes, suggest re-running the relevant tests and `gh pr checks` to confirm.

## Bundled Resources

### scripts/inspect_pr_checks.py

Fetch failing PR checks, pull GitHub Actions logs, and extract a failure snippet. Exits non-zero when failures remain so it can be used in automation.

Usage examples:
- `python "<path-to-skill>/scripts/inspect_pr_checks.py" --repo "." --pr "123"`
- `python "<path-to-skill>/scripts/inspect_pr_checks.py" --repo "." --pr "https://github.com/org/repo/pull/123" --json`
- `python "<path-to-skill>/scripts/inspect_pr_checks.py" --repo "." --max-lines 200 --context 40`
