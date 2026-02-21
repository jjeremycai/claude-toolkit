---
name: cloudflare
description: |
  Build, deploy, and operate on the Cloudflare platform. Use when the user asks to:
  deploy/host/publish to Cloudflare (Workers, Pages, or any platform service),
  run untrusted code in a sandboxed environment (Sandbox SDK),
  or build AI agents with MCP client connections in Cloudflare Workers.
---

# Cloudflare

Unified skill for building on the Cloudflare platform. Covers deployment, sandboxed code execution, and MCP client integration in Workers.

---

## Prerequisites

- When sandboxing blocks deployment network calls, rerun with `sandbox_permissions=require_escalated`.
- Deployments may require extended timeout values.

## Authentication (Required Before Deploy)

Verify auth before `wrangler deploy`, `wrangler pages deploy`, or `npm run deploy`:

```bash
npx wrangler whoami    # Shows account if authenticated
```

Not authenticated? See `references/wrangler/auth.md`
- Interactive/local: `wrangler login` (one-time OAuth)
- CI/CD: Set `CLOUDFLARE_API_TOKEN` env var
- Sandbox SDK local dev: Set `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` in `dev.vars`

---

## Part 1: Deploy (Workers, Pages, and Platform Services)

Use the decision trees below to find the right product, then load detailed references.

### Quick Decision Trees

#### "I need to run code"

```
Need to run code?
├─ Serverless functions at the edge → workers/
├─ Full-stack web app with Git deploys → pages/
├─ Stateful coordination/real-time → durable-objects/
├─ Long-running multi-step jobs → workflows/
├─ Run containers → containers/
├─ Multi-tenant (customers deploy code) → workers-for-platforms/
├─ Scheduled tasks (cron) → cron-triggers/
├─ Lightweight edge logic (modify HTTP) → snippets/
├─ Process Worker execution events (logs/observability) → tail-workers/
└─ Optimize latency to backend infrastructure → smart-placement/
```

#### "I need to store data"

```
Need storage?
├─ Key-value (config, sessions, cache) → kv/
├─ Relational SQL → d1/ (SQLite) or hyperdrive/ (existing Postgres/MySQL)
├─ Object/file storage (S3-compatible) → r2/
├─ Message queue (async processing) → queues/
├─ Vector embeddings (AI/semantic search) → vectorize/
├─ Strongly-consistent per-entity state → durable-objects/ (DO storage)
├─ Secrets management → secrets-store/
├─ Streaming ETL to R2 → pipelines/
└─ Persistent cache (long-term retention) → cache-reserve/
```

#### "I need AI/ML"

```
Need AI?
├─ Run inference (LLMs, embeddings, images) → workers-ai/
├─ Vector database for RAG/search → vectorize/
├─ Build stateful AI agents → agents-sdk/
├─ Gateway for any AI provider (caching, routing) → ai-gateway/
└─ AI-powered search widget → ai-search/
```

#### "I need networking/connectivity"

```
Need networking?
├─ Expose local service to internet → tunnel/
├─ TCP/UDP proxy (non-HTTP) → spectrum/
├─ WebRTC TURN server → turn/
├─ Private network connectivity → network-interconnect/
├─ Optimize routing → argo-smart-routing/
├─ Optimize latency to backend (not user) → smart-placement/
└─ Real-time video/audio → realtimekit/ or realtime-sfu/
```

#### "I need security"

```
Need security?
├─ Web Application Firewall → waf/
├─ DDoS protection → ddos/
├─ Bot detection/management → bot-management/
├─ API protection → api-shield/
├─ CAPTCHA alternative → turnstile/
└─ Credential leak detection → waf/ (managed ruleset)
```

#### "I need media/content"

```
Need media?
├─ Image optimization/transformation → images/
├─ Video streaming/encoding → stream/
├─ Browser automation/screenshots → browser-rendering/
└─ Third-party script management → zaraz/
```

#### "I need infrastructure-as-code"

```
Need IaC? → pulumi/ (Pulumi), terraform/ (Terraform), or api/ (REST API)
```

### Product Index

#### Compute & Runtime
| Product | Reference |
|---------|-----------|
| Workers | `references/workers/` |
| Pages | `references/pages/` |
| Pages Functions | `references/pages-functions/` |
| Durable Objects | `references/durable-objects/` |
| Workflows | `references/workflows/` |
| Containers | `references/containers/` |
| Workers for Platforms | `references/workers-for-platforms/` |
| Cron Triggers | `references/cron-triggers/` |
| Tail Workers | `references/tail-workers/` |
| Snippets | `references/snippets/` |
| Smart Placement | `references/smart-placement/` |

#### Storage & Data
| Product | Reference |
|---------|-----------|
| KV | `references/kv/` |
| D1 | `references/d1/` |
| R2 | `references/r2/` |
| Queues | `references/queues/` |
| Hyperdrive | `references/hyperdrive/` |
| DO Storage | `references/do-storage/` |
| Secrets Store | `references/secrets-store/` |
| Pipelines | `references/pipelines/` |
| R2 Data Catalog | `references/r2-data-catalog/` |
| R2 SQL | `references/r2-sql/` |

#### AI & Machine Learning
| Product | Reference |
|---------|-----------|
| Workers AI | `references/workers-ai/` |
| Vectorize | `references/vectorize/` |
| Agents SDK | `references/agents-sdk/` |
| AI Gateway | `references/ai-gateway/` |
| AI Search | `references/ai-search/` |

#### Networking & Connectivity
| Product | Reference |
|---------|-----------|
| Tunnel | `references/tunnel/` |
| Spectrum | `references/spectrum/` |
| TURN | `references/turn/` |
| Network Interconnect | `references/network-interconnect/` |
| Argo Smart Routing | `references/argo-smart-routing/` |
| Workers VPC | `references/workers-vpc/` |

#### Security
| Product | Reference |
|---------|-----------|
| WAF | `references/waf/` |
| DDoS Protection | `references/ddos/` |
| Bot Management | `references/bot-management/` |
| API Shield | `references/api-shield/` |
| Turnstile | `references/turnstile/` |

#### Media & Content
| Product | Reference |
|---------|-----------|
| Images | `references/images/` |
| Stream | `references/stream/` |
| Browser Rendering | `references/browser-rendering/` |
| Zaraz | `references/zaraz/` |

#### Real-Time Communication
| Product | Reference |
|---------|-----------|
| RealtimeKit | `references/realtimekit/` |
| Realtime SFU | `references/realtime-sfu/` |

#### Developer Tools
| Product | Reference |
|---------|-----------|
| Wrangler | `references/wrangler/` |
| Miniflare | `references/miniflare/` |
| C3 | `references/c3/` |
| Observability | `references/observability/` |
| Analytics Engine | `references/analytics-engine/` |
| Web Analytics | `references/web-analytics/` |
| Sandbox | `references/sandbox/` |
| Workerd | `references/workerd/` |
| Workers Playground | `references/workers-playground/` |

#### Infrastructure as Code
| Product | Reference |
|---------|-----------|
| Pulumi | `references/pulumi/` |
| Terraform | `references/terraform/` |
| API | `references/api/` |

#### Other Services
| Product | Reference |
|---------|-----------|
| Email Routing | `references/email-routing/` |
| Email Workers | `references/email-workers/` |
| Static Assets | `references/static-assets/` |
| Bindings | `references/bindings/` |
| Cache Reserve | `references/cache-reserve/` |

---

## Part 2: Sandbox SDK (Secure Code Execution)

Build secure, sandboxed applications that execute untrusted code safely using Cloudflare's Sandbox SDK.

Official docs:
- https://sandbox.cloudflare.com
- https://developers.cloudflare.com/sandbox/

### When to Use

- Run **untrusted code** safely (CI/CD tasks, code review, evals, custom agents)
- Provide a **code interpreter** / REPL-like experience
- Spin up **ephemeral environments** (Node/Python/other images) to run scripts
- Proxy traffic to an app running inside a sandbox (preview URLs)

### Setup

1. Install the SDK:

```bash
npm i @cloudflare/sandbox
```

2. Add the Sandbox service binding to `wrangler.jsonc`:

```jsonc
{
  "services": [
    { "binding": "SANDBOX", "service": "sandbox" }
  ]
}
```

3. Set credentials for local dev in `dev.vars`:

```bash
CLOUDFLARE_API_TOKEN=...
CLOUDFLARE_ACCOUNT_ID=...
```

### Core Workflow

#### Get (or create) a sandbox

```ts
import { getSandbox } from '@cloudflare/sandbox';

const sandbox = await getSandbox(env.SANDBOX, {
  id: 'stable-session-id',  // Reuse across requests (optional)
  image: 'nodejs',           // Environment (optional)
  memoryMB: 256,             // Limits (optional)
  timeoutMs: 60_000,
});
```

To **reuse** the same sandbox across requests, pass a stable `id` (e.g. per user/session).

#### Run a command

```ts
const result = await sandbox.exec('echo hello world');
// result: { exitCode, stdout, stderr }
```

#### Write files and execute scripts

```ts
await sandbox.mkdir('/tmp/app');
await sandbox.writeFile('/tmp/app/index.js', 'console.log("hi from sandbox")');
await sandbox.exec('node /tmp/app/index.js');
```

#### Stream output for long-running tasks

Use `execStream(...)` when you want progressive output (SSE):

```ts
const sse = await sandbox.execStream('bash -lc "for i in 1 2 3; do echo $i; sleep 1; done"');
return new Response(sse, { headers: { 'content-type': 'text/event-stream' } });
```

#### Manage background processes

```ts
const { pid } = await sandbox.startProcess('node server.js');
const procs = await sandbox.listProcesses();
await sandbox.killProcess(pid);
```

#### Expose ports / proxy requests

- Use `listenPort(port)` to obtain a preview URL.
- Use `proxyToSandbox(request, sandbox, { port, pathPrefix })` to forward Worker traffic to the sandbox.

### Security Checklist

- Keep **network disabled** unless you explicitly need it (`network: true` per exec/process).
- Set strict **resource limits** (CPU/memory/timeouts) appropriate to your use case.
- Avoid interpolating user input into shell commands; prefer templates/allowlists.
- Treat `/tmp` as ephemeral. Use `mount(...)` for persistence.

### Sandbox SDK References

- `references/sandbox-sdk/api-quick-ref.md` -- API quick reference
- `references/sandbox-sdk/examples.md` -- Code examples
- `references/sandbox/` -- Platform-level sandbox reference (config, gotchas, patterns)

### Sandbox SDK Troubleshooting

- **"SANDBOX is undefined"**: missing `services` binding in `wrangler.jsonc`.
- **401 / auth failures**: missing/invalid `CLOUDFLARE_API_TOKEN` + `CLOUDFLARE_ACCOUNT_ID`.
- **No output / truncated output**: prefer `execStream(...)` for large logs.

---

## Part 3: MCP Client in Workers (Agents SDK)

Build AI agents in Cloudflare Workers that connect to remote MCP (Model Context Protocol) servers for tool access.

Official docs:
- https://developers.cloudflare.com/agents/model-context-protocol/
- https://developers.cloudflare.com/agents/guides/connect-mcp-client/
- AI SDK v6 Migration Guide: https://ai-sdk.dev/docs/migration-guides/migration-guide-6-0

### When to Use

- Build a Cloudflare Worker that acts as an MCP client
- Connect an AI agent to remote MCP servers (Streamable HTTP transport)
- Use the Vercel AI SDK with Cloudflare's Agents framework
- Implement tool-calling agents with external MCP tool providers

### Step 1: Use the Correct Package

The `@cloudflare/agents` package is **deprecated**. Use the community `agents` package:

```bash
npm install agents@^0.3.6
```

```typescript
// CORRECT
import { Agent, getAgentByName, routeAgentRequest } from 'agents';

// DEPRECATED - DO NOT USE
// import { Agent } from '@cloudflare/agents';
```

### Step 2: AI SDK v6 Breaking Changes

AI SDK v6 replaced `maxSteps` with `stopWhen` and a step counter function:

```typescript
// BEFORE (AI SDK v5)
const result = await generateText({
  model: anthropic('claude-sonnet-4@latest'),
  tools: mcpTools,
  maxSteps: 10,
  prompt: userMessage,
});

// AFTER (AI SDK v6)
import { generateText, stepCountIs } from 'ai';

const result = await generateText({
  model: anthropic('claude-sonnet-4@latest'),
  tools: mcpTools,
  stopWhen: stepCountIs(10),  // Default is now 20 steps
  prompt: userMessage,
});
```

### Step 3: MCP Client Manager API

The Agent class has an `mcp` property with `MCPClientManager`. Key details:

- Use `this.mcp.mcpConnections` (not `mcpServers`)
- `MCPClientConnection` has `url` (URL object) and `connectionState` properties
- Use `this.mcp.getAITools()` to get tools for AI SDK

```typescript
export class MyAgent extends Agent<Env, AgentState> {
  getMcpStatus() {
    const connections = this.mcp.mcpConnections;

    for (const [id, connection] of Object.entries(connections)) {
      if (connection.url.toString().includes("my-server")) {
        return {
          connected: connection.connectionState === "ready",
          serverId: id,
          state: connection.connectionState,
        };
      }
    }
    return { connected: false };
  }

  async callWithTools(prompt: string) {
    const tools = this.mcp.getAITools();
    // Use tools with generateText...
  }
}
```

### Step 4: Fix AgentNamespace Type Issues

The `AgentNamespace` generic doesn't properly infer agent types with `getAgentByName`. Use type assertions as a workaround:

```typescript
import { getAgentByName } from 'agents';

const agent = (await getAgentByName(
  env.MY_AGENT as any,
  "agent-name"
)) as unknown as MyAgent;

const result = await agent.myCustomMethod();
```

### Step 5: Workers Compatibility Date

Set compatibility date to `2024-09-23` or later for automatic `node:` prefix resolution:

```toml
# wrangler.toml
name = "my-agent"
compatibility_date = "2024-09-23"
compatibility_flags = ["nodejs_compat"]

[[durable_objects.bindings]]
name = "MY_AGENT"
class_name = "MyAgent"

[[migrations]]
tag = "v1"
new_sqlite_classes = ["MyAgent"]
```

Without this, imports like `path` from dependencies (e.g., mime-types) will fail with:
```
Could not resolve "path"
The package "path" wasn't found on the file system but is built into node.
```

### MCP Client Verification

After implementation:

1. **Build succeeds**: `wrangler deploy --dry-run`
2. **Local dev works**: `wrangler dev --local`
3. **MCP connection**: Check logs for successful connection to MCP server
4. **Tool discovery**: Verify `this.mcp.getAITools()` returns expected tools

```bash
wrangler dev --local --port 8799
curl http://localhost:8799/
curl http://localhost:8799/api/status
```

### MCP Client Notes

- **Package confusion**: `@cloudflare/agents` was an early experiment; `agents` is actively maintained
- **AI SDK migration**: v6 was a major refactor; check migration guide for other breaking changes
- **MCP OAuth**: Use `this.addMcpServer(name, url, callbackHost)` for OAuth-protected MCP servers -- returns `authUrl` if authentication needed
- **Connection persistence**: MCP connections are persisted in Agent's SQL storage and automatically restored on restart

---

## Troubleshooting

### Escalated Network Access

If deployment fails due to network issues (timeouts, DNS errors, connection resets), rerun the deploy with escalated permissions (use `sandbox_permissions=require_escalated`).

### Common Issues

| Problem | Cause | Fix |
|---------|-------|-----|
| Deploy network timeout | Sandbox blocks outbound | Use `sandbox_permissions=require_escalated` |
| `SANDBOX is undefined` | Missing service binding | Add `services` entry in `wrangler.jsonc` |
| 401 / auth failures | Missing credentials | Set `CLOUDFLARE_API_TOKEN` + `CLOUDFLARE_ACCOUNT_ID` |
| `Could not resolve "path"` | Old compatibility date | Set `compatibility_date = "2024-09-23"` + `nodejs_compat` flag |
| Truncated sandbox output | Large output in `exec()` | Use `execStream(...)` instead |
| `@cloudflare/agents` errors | Deprecated package | Switch to `agents` package |
