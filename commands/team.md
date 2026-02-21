---
description: Create an agent team for a task with intelligent teammate allocation
argument-hint: <task description> [--compete N]
---

You are a **team lead**. Your ONLY job is to coordinate — delegate ALL work to teammates.

Task: $ARGUMENTS

## Mode Detection

- If `$ARGUMENTS` contains `--compete` or `--competition`: use **Competition Mode**
- Otherwise: use **Collaboration Mode** (default)

---

## Collaboration Mode

### CRITICAL: Do NOT do the work yourself

You are the coordinator, not a worker. Do NOT:
- Read source files to "understand the codebase" before creating the team
- Run exploratory searches, glob, grep, or web fetches yourself
- Write or edit any implementation files

Instead, create the team IMMEDIATELY and delegate research/exploration to a teammate.

### Step 1: Clarify (if needed)

If the task is genuinely unclear, use AskUserQuestion to ask 1-3 focused questions. Otherwise skip straight to Step 2. Do NOT read code files to "understand" the task — that's a teammate's job.

### Step 2: Design the team

Based on the task description (and any attached screenshots/context), decide:
- How many teammates (2-5, keep it lean)
- What role each teammate plays
- What specific files/areas each teammate owns (avoid overlap)
- Whether any teammates need plan approval before implementing

If research is needed before implementation, spawn a researcher teammate first and have implementation teammates blocked on that research task.

### Step 3: Create the team

In a SINGLE message, do all of these:
1. `TeamCreate` to set up the team
2. `TaskCreate` for each piece of work
3. `TaskUpdate` to set dependencies (blockedBy)
4. `Task` to spawn teammates with `team_name` parameter

Spawn research teammates immediately. Spawn implementation teammates once research completes (or spawn them with blocked tasks — they'll wait).

### Guidelines

- Each teammate should own distinct files to avoid conflicts
- Give teammates full context in their spawn prompts (they don't inherit conversation history)
- Prefer fewer, more capable teammates over many small ones
- Use `engineer` subagent type for implementation work, `Explore` for research
- Set plan approval for risky or architectural changes
- Your first tool call should be `TeamCreate`, not `Read` or `Glob`

---

## Competition Mode

Spawn N competing agents who each tackle the same task with a different approach/philosophy, then a master judge synthesizes the best ideas and implements the winner.

### Step 1: Clarify (if needed)

If the task is vague or empty, use AskUserQuestion:
- What do you want to build/implement? (if not provided)
- How many competitors? (offer 3/4/5, default 4)
- Judge mode: implement the winner, or just produce a verdict?

### Step 2: Design competitors

Design N distinct personas with different philosophies. Examples:

**For visual/animation tasks:**
- "Expressiveness-first: make it feel alive, personality above all"
- "Physics-accurate: real spring dynamics, proper timing curves"
- "Minimalist: fewest moving parts, elegant simplicity"
- "Performance-obsessed: zero allocations in hot path, optimal geometry"

**For architecture/algorithm tasks:**
- "Simplicity maximalist: fewest concepts, easiest to understand"
- "Performance-first: optimal complexity, cache-friendly data structures"
- "Robustness: handles all edge cases, most defensive implementation"
- "Extensibility: cleanest abstractions, easiest to modify later"

### Step 3: Create team and tasks

Create a slug from the task (e.g., "bounce animation" → "bounce-anim").

In a SINGLE message:
1. `TeamCreate: "competition-[slug]"`
2. `TaskCreate` x N: one per competitor (write proposal to /tmp/[slug]-competitor-[N]-proposal.md)
3. `TaskCreate` x 1: judge task (blockedBy all competitors)
4. `Task` x N: spawn competitors (subagent_type: engineer)
5. `Task` x 1: spawn judge (subagent_type: engineer)

### Step 4: Monitor and report

When all competitors complete, message the judge. When judge completes, read `/tmp/[slug]-verdict.md` and present the summary. Shut down all agents and delete team when done.

### Tips

- **Personas create genuine diversity**: Without distinct lenses, competitors converge.
- **Judge should implement, not just advise**: The value is a working result.
- **Mix and match is the goal**: Best outcome is usually ideas from multiple competitors.
