---
name: github
description: "Use when working with GitHub PRs via the gh CLI: fixing failing CI checks, addressing review comments, inspecting PR status, or debugging GitHub Actions workflows. Trigger on: fix CI, failing checks, PR comments, address review, GitHub Actions."
---

# GitHub PR Workflows

Tools for managing GitHub PRs using the `gh` CLI. Covers CI debugging and review comment handling.

## Prerequisites

```bash
gh auth status  # Verify authenticated (repo + workflow scopes)
# If not: gh auth login
```

---

## Part 1: Fix Failing CI Checks

Debug and fix failing GitHub Actions checks on a PR.

### Quick Start

```bash
python "<path-to-skill>/scripts-ci/inspect_pr_checks.py" --repo "." --pr "<number-or-url>"
# Add --json for machine-friendly output
```

### Workflow

1. **Resolve the PR** — `gh pr view --json number,url` (current branch) or use provided PR number
2. **Inspect failing checks** (GitHub Actions only):
   - Preferred: run the bundled script (handles field drift and job-log fallbacks)
   - Manual fallback:
     ```bash
     gh pr checks <pr> --json name,state,bucket,link,startedAt,completedAt,workflow
     gh run view <run_id> --log
     ```
3. **Scope external checks** — If `detailsUrl` is not GitHub Actions, report the URL only. Don't attempt Buildkite or other providers.
4. **Summarize failures** — Check name, run URL, concise log snippet. Call out missing logs.
5. **Create a fix plan** — Draft concise plan, request approval before implementing.
6. **Implement after approval** — Apply fixes, summarize diffs/tests.
7. **Recheck** — `gh pr checks` to confirm.

### Bundled Scripts

- `scripts-ci/inspect_pr_checks.py` — Fetch failing checks, pull GitHub Actions logs, extract failure snippets. Exits non-zero when failures remain.
  ```bash
  python "<path-to-skill>/scripts-ci/inspect_pr_checks.py" --repo "." --pr "123" --json
  python "<path-to-skill>/scripts-ci/inspect_pr_checks.py" --repo "." --max-lines 200 --context 40
  ```

---

## Part 2: Address PR Review Comments

Find the open PR for the current branch and address its review comments.

### Workflow

1. **Fetch comments** — Run `scripts-comments/fetch_comments.py` to print all comments and review threads
2. **Present to user** — Number all threads with a short summary of what each fix requires
3. **User selects** which comments to address
4. **Apply fixes** for selected comments

### Bundled Scripts

- `scripts-comments/fetch_comments.py` — Print all comments and review threads on the PR

### Notes

- If `gh` hits auth/rate issues mid-run, prompt user to re-authenticate with `gh auth login`, then retry.
