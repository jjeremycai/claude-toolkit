---
description: Generate images, videos, audio, or 3D models using fal.ai
argument-hint: <description of what to generate>
allowed-tools: Read, Write, Bash, WebFetch, mcp__fal__SearchFal
---

Generate media assets using fal.ai's model catalog.

## Step 1: Understand the Request

- **Asset type**: Image, video, audio, 3D?
- **Operation**: Generate (text-to-X), transform (image-to-video, style transfer), or utility (upscale, remove BG)?
- **Inputs**: Reference images, source files, or just a text description?

If the request is already clear, skip questions and proceed.

## Step 2: Discover Models

**`SearchFal` MCP tool** — search fal's knowledge base for model recommendations and best practices.

**Platform API** — programmatic discovery:
```bash
curl -s "https://api.fal.ai/v1/models?query=text-to-video" \
  -H "Authorization: Key $FAL_KEY"

# Get model schema
curl -s "https://api.fal.ai/v1/models?query=text-to-image&expand=openapi-3.0" \
  -H "Authorization: Key $FAL_KEY"
```

Present 2-3 model options with tradeoffs (speed vs quality, cost). Recommend one.

## Step 3: Specs

After model selection, confirm format and parameters from the model's OpenAPI schema:
- Dimensions/resolution, format, duration (video/audio), style, number of outputs

## Authentication

```bash
[ -z "$FAL_KEY" ] && echo "MISSING: Set FAL_KEY env var" && exit 1
```

## Generation

### Queue API (default for most models)
```bash
# Submit
curl -s -X POST "https://queue.fal.run/{endpoint}" \
  -H "Authorization: Key $FAL_KEY" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "...", ...}'

# Poll (every 2-3s)
curl -s "https://queue.fal.run/{endpoint}/requests/{request_id}/status" \
  -H "Authorization: Key $FAL_KEY"

# Get result
curl -s "https://queue.fal.run/{endpoint}/requests/{request_id}" \
  -H "Authorization: Key $FAL_KEY"
```

### Sync API (lightweight models only)
```bash
curl -s -X POST "https://fal.run/{endpoint}" \
  -H "Authorization: Key $FAL_KEY" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "...", ...}'
```

## Output

- Present CDN URL from the response
- Offer to download: `curl -o <filename> <url>`
- Offer iteration: adjust prompt, try different model, tweak params, or chain output as input for another generation
