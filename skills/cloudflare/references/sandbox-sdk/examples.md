# Sandbox SDK – examples

## 1) Minimal Worker: run a command

```ts
import { getSandbox } from '@cloudflare/sandbox';

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const sandbox = await getSandbox(env.SANDBOX, {
      image: 'nodejs',
      memoryMB: 256,
      timeoutMs: 30_000,
    });

    const { stdout, stderr, exitCode } = await sandbox.exec('node -v');

    return Response.json({ exitCode, stdout, stderr });
  },
};
```

## 2) Write a file and run it

```ts
await sandbox.mkdir('/tmp/app');
await sandbox.writeFile('/tmp/app/index.js', 'console.log("hello from sandbox")');

const res = await sandbox.exec('node /tmp/app/index.js');
```

## 3) Stream output (SSE)

```ts
const sse = await sandbox.execStream(
  'bash -lc "for i in 1 2 3 4; do echo $i; sleep 1; done"'
);

return new Response(sse, {
  headers: {
    'content-type': 'text/event-stream',
    'cache-control': 'no-cache',
  },
});
```

## 4) Start a long-running process and stop it

```ts
const { pid } = await sandbox.startProcess('node server.js');

// ... later
await sandbox.killProcess(pid);
```

## 5) Enable outbound network access for a single command

```ts
const res = await sandbox.exec('curl https://example.com', {
  network: true,
});
```

## 6) Proxy requests to an app running inside the sandbox

```ts
import { getSandbox, proxyToSandbox } from '@cloudflare/sandbox';

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const sandbox = await getSandbox(env.SANDBOX);

    // Ensure your sandbox is running an HTTP server on port 3000.
    // For example: await sandbox.exec('node /tmp/server.js');

    return proxyToSandbox(request, sandbox, {
      port: 3000,
      pathPrefix: '/app',
    });
  },
};
```

## 7) Run OpenCode inside a sandbox (agent / CI helper)

```ts
import { getSandbox } from '@cloudflare/sandbox';

const sandbox = await getSandbox(env.SANDBOX, {
  image: 'opencode',
  timeoutMs: 120_000,
});

// Sanity check
await sandbox.exec('opencode --version');

// Then run whatever OpenCode command your workflow needs.
// (Prefer passing structured input via files/stdin over shell interpolation.)
```
