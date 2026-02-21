---
description: Set up a frontend project or initialize UI framework (shadcn, Tailwind, component library)
argument-hint: [shadcn | tailwind | init] [--new | --existing]
allowed-tools: Bash, Read, Glob, Grep, AskUserQuestion, WebFetch, WebSearch, Skill
---

Frontend project setup and initialization. Detect the subcommand from "$ARGUMENTS":

- **shadcn [--new|--existing]**: Initialize shadcn/ui with Base UI or Radix
- **tailwind**: Set up or configure Tailwind CSS
- **init**: General frontend project scaffolding
- **No subcommand**: Ask the user what they want to set up

## CRITICAL: Fetch Current Docs First

Your training data about frontend tools is likely outdated. Before doing anything:

1. **Fetch current CLI options:**
   ```bash
   npx shadcn@latest --help
   npx shadcn@latest init --help
   ```

2. **Load frontend-design skill:**
   ```
   Skill: frontend-design
   ```

3. **Fetch official docs via Context7 or WebFetch as needed**

4. **Search for latest updates if docs are insufficient:**
   ```
   WebSearch: "shadcn base-ui setup 2026"
   ```

Always trust fetched docs over static content below.

---

## shadcn/ui Setup

### New Projects
```bash
npx shadcn@latest create <name> --template next --preset base-lyra
```

### Existing Projects
```bash
npx shadcn@latest init
```

### Add Components
```bash
npx shadcn@latest add --all
# Or specific: npx shadcn@latest add button card dialog
```

### Visual Styles

| Style | Description |
|-------|-------------|
| Vega | Classic shadcn |
| Nova | Compact |
| Maia | Soft, rounded |
| Lyra | Boxy, sharp |
| Mira | Ultra-compact |

### Key Facts
- shadcn has native Base UI support
- Package: `@base-ui/react`
- Presets format: `{library}-{style}` e.g., `base-lyra`
- Base UI uses render props, Radix uses `asChild`

---

## After Setup

Check existing patterns in the project:
- Design tokens, theme, colors
- Component conventions
- Spacing/typography scales

Install commonly needed community components:
- **sonner** — toast notifications
- **cmdk** — command palette
- **vaul** — drawer
- **novel** — rich text editor
