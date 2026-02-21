---
name: missive
description: This skill should be used when the user asks to "check inbox", "triage inbox", "prioritize emails", "draft reply", "reply all", "label conversation", "tag email", "assign to team", "delegate email", "organize contacts", "add contact", "find contact", "manage contacts", "email management", "route conversation", "organize inbox", "what needs my attention", or any Missive-related task.
---

## Inbox Triage

### Decision Framework

For each conversation, decide: **Respond, Delegate, Schedule, Archive, or Delete.** Avoid "deal with later" piles.

**Priority matrix:**
- **Urgent + Important**: Handle now
- **Important, not urgent**: Schedule time
- **Urgent, not important**: Delegate or quick response
- **Neither**: Archive or delete

### High Priority Signals
- VIPs (executives, key clients)
- Time-sensitive language ("urgent", "ASAP", "by EOD", "deadline")
- Blockers (someone waiting on you)
- Revenue/customer impact, escalations

### Medium Priority Signals
- Direct requests with reasonable timelines
- Follow-ups on ongoing work
- Meeting requests, questions requiring research

### Low Priority Signals
- FYI/informational, newsletters
- Non-urgent internal updates, social/networking messages

### Auto-Archive Criteria
- Spam, unread newsletters, automated notifications with no action needed
- Social media notifications, completed transactions, calendar confirmations

### Triage Workflow
1. Fetch conversations: `missive_conversations` action: `list`
2. Quick scan subjects/senders for priority flags
3. For each conversation, classify and act:
   - **Archive**: Close the conversation
   - **Respond**: Draft reply (see Drafting Replies below)
   - **Delegate**: Assign to team member (see Team Assignment below)
   - **Schedule**: Create task with due date via `missive_tasks` action: `create`

### The 2-Minute Rule
If you can respond in under 2 minutes, do it now (or draft it). Otherwise, schedule dedicated time.

---

## Drafting Replies

Use `missive_messages` action: `create` to draft or send replies.

```
missive_messages action: create
message: {
  conversation: [conversation_id],
  body: "...",
  from_field: { address: "..." },
  to_fields: [{ address: "..." }]
}
```

For reply-all, include all original recipients in `to_fields` and `cc_fields` as appropriate.

---

## Labeling

### Principles
- **Use existing labels only.** Do not create new labels. If none fit, tell the user.
- **Labels are for filtering**, not describing. Ask: "Will I need to find emails like this later?"
- **Apply 1-3 labels** per conversation. Over-labeling creates noise.

### When to Label
- Project/client identification
- Action required (Needs Response, Waiting On, Review)
- Priority (Urgent -- use sparingly)
- Type categorization (Invoice, Contract, Support)

### When to Skip Labels
- One-off conversations you won't search for again
- Spam/newsletters (archive/delete instead)
- Already in a well-organized mailbox

### Workflow
1. List available labels: `missive_labels` action: `list`
2. Check existing labels on the conversation
3. Apply labels: `missive_messages` with `add_shared_labels: [label_id, ...]`

### Querying by Label
```
missive_conversations action: list
shared_label: [label_id]
```
Combine with `closed: false`, `team: [team_id]`, or `assignee: [user_id]`.

### Anti-Patterns
- 5+ labels on one conversation
- Labeling what the mailbox already tells you
- Labeling every conversation indiscriminately

---

## Team Assignment

### Principles
- Every actionable conversation needs **one owner**.
- Always provide context when assigning -- never silently reassign.
- Route by expertise, relationship, availability, then authority.

### Operations

List teams: `missive_teams` action: `list`
List users: `missive_users` action: `list`

Assign conversation:
```
missive_messages action: create
message: {
  conversation: [conversation_id],
  add_assignees: [user_id]
}
```

### Routing Decisions
| Signal | Route To |
|--------|----------|
| Technical question | Technical team member |
| Billing issue | Finance/accounts |
| Sales inquiry | Sales team |
| Support request | Support team |
| Legal/contract | Legal or leadership |
| Existing relationship | Their account manager |
| Previous thread history | Person who handled before |

### Handoff Template
When delegating, post context:
```
missive_posts action: create
post: {
  conversation: [conversation_id],
  markdown: "@[Name] - Assigning to you because [reason]. Action needed: [what]. Timeline: [when]. Context: [background]."
}
```

### Escalation
Escalate when: customer is frustrated, issue exceeds your authority/knowledge, time-sensitive with no owner, legal/PR risk.

Include: situation summary, what's been tried, what you need from the escalation point.

### Monitoring
Your assignments: `missive_conversations` action: `list` with `assignee: [your_id]`, `closed: false`
Team workload: list conversations filtered by each assignee.

### Anti-Patterns
- Assignment ping-pong (discuss ownership first)
- Ghost assignment (no context)
- Assigning trivial things that don't need ownership

---

## Contact Management

### Principles
- **One record per contact.** Search before creating to avoid duplicates.
- **Keep data fresh.** Update when you notice changes in conversations.
- **Organize into books.** Clients, Prospects, Vendors, Partners, Personal, etc.

### Operations

| Action | Command |
|--------|---------|
| List contacts | `missive_contacts` action: `list` (limit, offset for pagination) |
| Get contact | `missive_contacts` action: `get` with `id` |
| Create contact | `missive_contacts` action: `create` with `contact: { email, phone_number, first_name, last_name, company, contact_book }` |
| Bulk create | `missive_contacts` action: `create` with `contacts: [...]` |
| Update contact | `missive_contacts` action: `update` with `id` and `contact: { fields }` |
| List books | `missive_contacts` action: `list_books` |
| List groups | `missive_contacts` action: `list_groups` |

### Deduplication
Before creating:
1. Search by email (most reliable identifier)
2. Search by name + company
3. Check variations (john@ vs john.doe@)

When duplicates found: merge to the most complete record, update references, remove the duplicate.

### Required Fields
At minimum: email or phone number + name (first and/or last).

### Bulk Import
- Validate data before import
- Check for duplicates first
- Import in batches (respect rate limits)
- Assign to appropriate contact book
