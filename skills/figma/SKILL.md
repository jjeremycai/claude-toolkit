---
name: figma
description: "Translate Figma designs into production-ready code using the Figma MCP server. Trigger on: Figma URLs, node IDs, 'implement design', 'design to code', Figma MCP setup/troubleshooting, or any Figma-related task."
---

# Figma

Structured workflow for translating Figma designs into production code with 1:1 visual fidelity via the Figma MCP server.

For MCP setup, env vars, and troubleshooting, see `references/figma-mcp-config.md`.
For the full tool catalog and prompt patterns, see `references/figma-tools-and-prompts.md`.

## Prerequisites

- Figma MCP server connected and accessible
- Figma URL in the format `https://figma.com/design/:fileKey/:fileName?node-id=1-2`, **or** a node selected in the Figma desktop app (when using `figma-desktop` MCP)
- Project with an established design system or component library (preferred)

## Required Workflow

**Follow these steps in order. Do not skip steps.**

### Step 0: Verify Figma MCP is Connected

If any MCP call fails because the server is not connected, ask the user to configure the Figma MCP server in their settings and restart their session.

### Step 1: Get Node ID

**Option A -- Parse from URL:**

- URL: `https://figma.com/design/kL9xQn2VwM8pYrTb4ZcHjF/DesignSystem?node-id=42-15`
- File key: `kL9xQn2VwM8pYrTb4ZcHjF` (segment after `/design/`)
- Node ID: `42-15` (value of `node-id` query param)

Note: With `figma-desktop` MCP, only `nodeId` is needed -- the server uses the currently open file.

**Option B -- Current Selection (figma-desktop MCP only):**

Tools automatically use the currently selected node in the desktop app. No URL required.

### Step 2: Fetch Design Context

```
get_design_context(fileKey=":fileKey", nodeId="1-2")
```

Returns layout properties, typography, colors/tokens, component structure, spacing/padding.

**If truncated:** Run `get_metadata` first to get the node map, then re-fetch specific child nodes individually.

### Step 3: Capture Visual Reference

```
get_screenshot(fileKey=":fileKey", nodeId="1-2")
```

This screenshot is the source of truth for visual validation. Keep it accessible throughout implementation.

### Step 4: Download Assets

- If the Figma MCP server returns a `localhost` source for an image or SVG, use it directly
- DO NOT import/add new icon packages -- all assets come from the Figma payload
- DO NOT create placeholders when a `localhost` source is provided

### Step 5: Translate to Project Conventions

- Treat the Figma MCP output (React + Tailwind) as a representation of design intent, not final code
- Replace Tailwind utility classes with the project's design system tokens/utilities
- Reuse existing components (buttons, inputs, typography, icon wrappers) instead of duplicating
- Use the project's color system, typography scale, and spacing tokens
- Respect existing routing, state management, and data-fetch patterns

### Step 6: Achieve 1:1 Visual Parity

- Match the Figma design exactly -- avoid hardcoded values, use design tokens
- When project tokens conflict with Figma specs, prefer project tokens and adjust spacing/sizing minimally
- Follow WCAG accessibility requirements

### Step 7: Validate Against Figma

Before marking complete, validate against the screenshot from Step 3:

- [ ] Layout (spacing, alignment, sizing)
- [ ] Typography (font, size, weight, line height)
- [ ] Colors match exactly
- [ ] Interactive states (hover, active, disabled)
- [ ] Responsive behavior follows Figma constraints
- [ ] Assets render correctly
- [ ] Accessibility standards met

## Implementation Rules

- Place components in the project's designated design system directory
- Follow the project's naming conventions
- Map Figma design tokens to project design tokens
- Extend existing components rather than creating duplicates
- Avoid inline styles unless needed for dynamic values
- Avoid hardcoded values -- extract to constants or tokens
- Add TypeScript types for component props

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Output truncated | Use `get_metadata` for the node map, then fetch child nodes individually |
| Visual mismatch | Compare side-by-side with Step 3 screenshot; check spacing, colors, typography values |
| Assets not loading | Verify MCP server assets endpoint is accessible; use `localhost` URLs directly |
| Token values differ from Figma | Prefer project tokens for consistency, adjust spacing/sizing to maintain visual fidelity |

## References

- `references/figma-mcp-config.md` -- setup, verification, troubleshooting
- `references/figma-tools-and-prompts.md` -- tool catalog and prompt patterns
