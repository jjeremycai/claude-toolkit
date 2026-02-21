---
name: council
description: Multi-agent codebase exploration and synthesis. Use when the user asks for /council, wants a council-style multi-agent scan, requests a broad codebase exploration and synthesis, asks for a codebase audit, architecture review, CTO-level assessment, or quality/readiness evaluation. Spawns multiple agents (default n=10) with diverse perspectives and synthesizes their findings.
---

# Council

Coordinate a council-style multi-agent exploration of a codebase area of interest, then synthesize findings into the requested output.

## Modes

Council operates in two modes:

| Mode | Trigger | Description |
|------|---------|-------------|
| **Explore** (default) | General questions, investigations, planning | Open-ended multi-agent exploration of an area of interest |
| **Audit** | "audit", "assessment", "review architecture", "codebase quality", "readiness" | Structured CTO-level audit with severity-ranked findings |

Detect the mode from the user's request. If ambiguous, default to Explore.

---

## Core Workflow

### 1. Clarify scope

**Explore mode:** Ask 1-2 questions if the area of interest (AOI) or desired output is unclear.

**Audit mode:** Additionally identify:
- Repositories, services, and environments in scope
- Business goals, scale targets, SLAs/SLOs, regulatory constraints
- Request missing inputs (architecture docs, infra diagrams, deployment details) if needed

### 2. Baseline scan

Use `rg`, `Glob`, and light repo mapping to collect:
- Key files, entry points, and keywords
- Rough architecture snapshot (components, boundaries, data flow)
- Dependency inventory (services, data stores, queues, third-party libs)

### 3. Spawn agents (default n=10)

Use the Task tool to run parallel subagents. If a number is specified, use it; otherwise default to 10. If limited by agent slots, run in batches.

**Explore mode:** Design agent prompts to cover different perspectives on the AOI. Include 1-2 "out of the box" or contrarian prompts for variance.

**Audit mode:** Assign each agent a focused audit dimension. Recommended agent allocation for a full audit:

| Agents | Focus Area |
|--------|------------|
| 2 | Architecture and system design (modularity, coupling, dependency direction, overengineering) |
| 2 | Implementation quality (correctness in critical paths, error handling, edge cases, TODOs, stubs, silent failures) |
| 1 | Performance and efficiency (hot paths, N+1 patterns, memory pressure, scalability limits) |
| 1 | Security and reliability (input validation, authn/authz, secrets handling, resiliency patterns) |
| 1 | Code quality and maintainability (code smells, naming, abstractions, consistency) |
| 1 | Tooling, testing, and ops (test coverage gaps, CI/CD, dependency hygiene, monitoring, alerting) |
| 1 | Elegance and simplicity (what works well, clever solutions, good patterns worth preserving) |
| 1 | Contrarian / devil's advocate (challenge assumptions, find hidden risks, question "obvious" choices) |

Adjust allocation based on scope. Every agent prompt must instruct the agent to cite evidence: file paths, line numbers, configs, or logs.

### 4. Synthesize

Deduplicate and cross-reference findings across all agents, then produce the output.

---

## Output

### Explore mode

- Keywords + quick architecture sketch
- Key files/areas (paths)
- Synthesized findings
- Final answer or plan

### Audit mode

**Summary:**
- Purpose and scope of the audit
- System overview (1-2 sentences)
- Key strengths (2-4 bullets)
- Top risks (2-4 bullets)

**Findings (ordered by severity):**

Use severity buckets: Critical, High, Medium, Low.

For each finding include:
- **Impact:** What breaks or degrades
- **Evidence:** File paths, line numbers, concrete observations
- **Fix direction:** Crisp, actionable recommendation

Separate confirmed issues from hypotheses. State assumptions clearly. No ungrounded claims.

**Recommendations (prioritized):**
1. Immediate fixes (safety and correctness)
2. Near-term improvements (quality, performance, maintainability)
3. Strategic investments (architecture, platform, scale)

**Overall Assessment:**
- Readiness for scale and operational risk
- Short rationale and confidence level
