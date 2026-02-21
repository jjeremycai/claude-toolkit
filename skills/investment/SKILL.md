---
name: investment
description: |
  Use when the user says "investment memo", "fill out the memo", "populate the memo",
  "write up the deal", "add investment", "log investment", "add to portfolio",
  or provides a Notion memo link with a deck to process.
  Covers both populating investment memos from pitch decks and adding investments to the portfolio database.
---

# Investment Workflows

## Part 1: Investment Memo (from Pitch Deck)

Populate a Madrona/Pioneer Fund investment memo in Notion from a pitch deck and deal context.

### Inputs

The user will provide some combination of:
- A Notion page URL (the blank or partially filled memo)
- A PDF deck path (the company's pitch deck)
- Deal context (investment amounts, how they met the founder, any email/message context)

If any of these are missing, ask the user before proceeding.

### Steps

#### 1. Read the deck

Use the Read tool on the PDF path. Extract:
- Company name and description
- Founders and team bios
- Market overview and problem statement
- Product description and how it works
- Traction (ARR, customers, pipeline, growth)
- Competitive landscape
- Raise details (amount, security type)

#### 2. Fetch the Notion memo template

Use `mcp__claude_ai_Notion__notion-fetch` on the Notion URL. Standard Pioneer Fund memo sections:
- Company Name, Description, Location
- Founder(s), Contact Info
- Summary of Team / Market / Product
- Key Strengths / Key Challenges
- Proposed Deal Terms, Type of Security, Investment Rights
- Pioneer Co-Investment Amount, Investment from Pioneer Fund
- Board of Directors & Advisors
- Other Relevant Information

Note: Template may vary. Always read the actual page structure and preserve any fields the user already filled in.

#### 3. Fill in the memo

Use `mcp__claude_ai_Notion__notion-update-page` with `replace_content`.

**Write like the scout actually wrote it, not like an AI summarized a deck.**

Writing rules:
- Plain, direct language. No promotional adjectives.
- State facts concisely. "Team of 7, 5 technical" not "an exceptional team."
- For market: explain the problem simply, then list tailwinds.
- For product: describe what it does step by step.
- For strengths/challenges: be honest and specific. Cite concrete evidence.
- No em dash overuse, no rule-of-three, no AI vocabulary.
- Vary sentence length. Short sentences are fine.

#### 4. Update properties

- Summary: One-line description (plain language)
- Status: "Researching"
- Tags: Add "Finance" if not tagged

#### 5. Final check

Re-read the page. Scan for AI-isms and fix in place.

---

## Part 2: Add Investment to Portfolio

Add a new row to the Portfolio database in Notion.

### Parse Arguments

Extract from user input:
- **Company name** (required)
- **Amount** — dollar amount (e.g. "10k" = 10000, "25k" = 25000)
- **Cap/Price** — valuation cap (e.g. "25m" = 25000000)
- **--type** — Scout, LP, Direct, Syndicate, SPV (default: Direct)
- **--entry** — Pre-Seed, Seed, Seed+, Series A/B/C/D/E, HF, Rolling, Fund 1/2 (default: Pre-Seed)
- **--co-investor** — comma-separated names
- **--status** — Alive, Died, Acquired, IPO (default: Alive)

If amount or cap are missing, ask the user.

### Research the Company

Search Notion for existing memos/notes:
```
notion-search: <company name>
```

If found, extract description, deal terms, stage, co-investor info. Present to user before creating.

### Create the Row

Portfolio database data_source_id: `9bb2360b-c387-47b0-88ad-8be2971c75f7`

Properties:
- **Name** (title): Company name
- **Amount** (number): Investment amount in dollars
- **Price** (number): Valuation cap in dollars
- **Description** (text): From memo or user input
- **Entry** (select): Stage at entry
- **Current** (select): Same as Entry for new investments
- **Type** (select): Investment type
- **Status** (status): Default "Alive"
- **Co-Investor** (multi_select): If provided
- **Link** (url): If found

### After Creation

1. Show a summary table of what was added
2. Link to the new Notion page
