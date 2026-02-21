# Sandbox SDK – API quick reference

> This is a practical quick-ref, not exhaustive. Prefer the official docs for full details:
> https://developers.cloudflare.com/sandbox/

## Install

```bash
npm i @cloudflare/sandbox
```

## Common imports

```ts
import {
  getSandbox,
  Sandbox,
  proxyToSandbox,
  parseSSEStream,
  type Sandbox as SandboxType,
} from '@cloudflare/sandbox';
```

## Getting a sandbox (Workers)

```ts
const sandbox = await getSandbox(env.SANDBOX, {
  // Reuse across requests (optional)
  id: 'stable-session-id',

  // Environment (optional)
  image: 'nodejs',

  // Limits (optional)
  memoryMB: 256,
  timeoutMs: 60_000,
});
```

## Lifecycle

```ts
const sandbox = new Sandbox(env.SANDBOX, { image: 'nodejs' });
await sandbox.create();
// ...
await sandbox.destroy();
```

## Commands

- `sandbox.exec(cmd, options?)` → `{ exitCode, stdout, stderr }`
- `sandbox.execStream(cmd, options?)` → `ReadableStream<Uint8Array>` (SSE)
- `parseSSEStream(stream)` → async iterable of SSE events
- `sandbox.startProcess(cmd, options?)` → `{ pid, ... }`
- `sandbox.listProcesses()` → running processes
- `sandbox.killProcess(pid, signal?)`

### Networking

Network access is **disabled by default**. Enable per command/process:

```ts
await sandbox.exec('curl https://example.com', { network: true });
```

## Files

```ts
await sandbox.mkdir('/tmp/app');
await sandbox.writeFile('/tmp/app/index.js', 'console.log("hi")');
const bytes = await sandbox.readFile('/tmp/app/index.js');
```

## Ports / previews

```ts
const port = await sandbox.listenPort(3000);
// port.url -> preview URL
await port.close();
```

Proxy Worker traffic to a sandboxed HTTP server:

```ts
return proxyToSandbox(request, sandbox, {
  port: 3000,
  pathPrefix: '/app',
});
```

## Persistent storage

Mount an R2 bucket into the sandbox filesystem:

```ts
await sandbox.mount(env.MY_BUCKET, '/mnt/data');
```
