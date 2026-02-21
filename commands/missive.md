---
description: Review Missive inbox, draft replies, or manage conversations
argument-hint: [all | summary | <subject/sender to reply to>]
allowed-tools: mcp__missive__missive_conversations, mcp__missive__missive_messages, mcp__missive__missive_drafts, mcp__missive__missive_contacts, mcp__missive__missive_labels, mcp__missive__missive_users, mcp__missive__missive_organizations, Task, Skill, AskUserQuestion
---

Handle Missive inbox based on argument: "$ARGUMENTS"

- **No argument or "all"**: Full inbox review — draft replies to all conversations needing responses
- **"summary"**: Show inbox overview without creating drafts
- **Anything else**: Find matching conversation and draft a single reply

## First: Load Skills

```
Skill: missive
```

---

## Summary Mode

Categorize open conversations:
1. **Needs Response**: Last message is from someone else
2. **Waiting**: Last message is from me
3. **FYI Only**: Newsletters, notifications, informational

Show: subject, sender, time ago, brief preview. Don't create drafts.

---

## Single Reply Mode

1. `missive_conversations (action: list, inbox: true)` → filter by argument
2. `missive_conversations (action: messages, id: conversation_id)` → get thread
3. `missive_messages (action: get, id: message_id)` → full body
4. Create draft (never send)

---

## Full Inbox Review (no argument or "all")

### Phase 1: Gather Context
1. List recent inbox conversations using `missive_conversations` (action: list, inbox: true)
2. Get organizations list for context
3. Filter out conversations that don't need responses (see Skip Criteria)

### Phase 2: Analyze Conversations
For each conversation that might need a response:
1. Get ALL messages in the thread using `missive_conversations` (action: messages, id: conversation_id)
2. **Store the ENTIRE message history** — you will need ALL of it for drafting context
3. Determine if it needs a response (see Draft Criteria)

### Phase 2.5: Ask Questions When Needed

**Before drafting, use AskUserQuestion if you need context to write a good reply.**

**ALWAYS ask when:**
- Someone provides their rate → "Accept $X/hr?", "Counter-offer", "Pass"
- Someone expresses interest → "What rate to propose?" or "Ask for their rate?"
- Multiple valid response directions (proceed vs pass, accept vs decline)
- The email asks something only the user can answer
- Any decision that commits to money, time, or next steps

**NEVER autonomously:**
- Accept or reject someone's rate
- Propose a rate without asking user first
- Commit to scheduling or next steps
- Make hiring/pass decisions

**Batch all questions in a SINGLE AskUserQuestion call** — up to 4 per call.

### Phase 3: Create Drafts IN PARALLEL

Spawn one subagent per conversation using the Task tool. Launch ALL in a SINGLE message.

### Phase 4: Report
Summarize: conversations reviewed, drafts created, skipped and why.

---

## Skip Criteria — Do NOT Draft For

- Newsletters/Marketing, automated notifications, spam
- No-reply addresses
- CC'd only (no action needed)
- Already handled (recent reply from user or existing draft)
- FYI/Informational ("no response needed")
- Receipts/Confirmations

## Draft Criteria — DO Draft For

- Direct questions, action requests, follow-ups
- Introduction emails, meeting requests
- Client/customer messages, candidate responses

---

## Draft Format Rules

### Match Sender
Reply from the address it was sent TO (check `to_fields`).

### Reply-All
Include all original recipients when appropriate.

### Paragraph Spacing
ONE `<br>` between paragraphs:
```html
<div>First paragraph</div>
<br>
<div>Second paragraph</div>
<br>
<div>Best,<br>Jeremy</div>
```

### Include Quoted Content (REQUIRED)
Fetch full body via `missive_messages (action: get)`. Include FULL THREAD HISTORY in nested blockquotes with 3x `<br>` between messages:
```html
<div>My response</div>
<br>
<div>Best,<br>Jeremy</div>
<br>
<div>On [Date], [Sender] &lt;[email]&gt; wrote:</div>
<blockquote style="margin:0 0 0 0.5em;padding:0 0 0 0.5em;border-left:2px solid #ccc">
[original message body]
</blockquote>
```

### Content
- Brief: 2-4 sentences, professional but friendly
- Match formality of incoming email
- Sign off with just "Jeremy"
- Don't commit to dates/times, rates, or decisions without user input

## Rules

1. **NEVER SEND** — Only create drafts (action: create, NOT action: send)
2. **Drafts are for review** — User will edit and send themselves
3. **When unsure, skip** — Better to skip than draft something inappropriate
4. **PARALLEL EXECUTION** — Always create multiple drafts in parallel using Task tool
5. **INCLUDE QUOTED CONTENT** — Every reply must include the original message in blockquotes
