# Auto-Rename

Automatically suggests renaming conversations after 3-5 messages to keep session history organized and searchable.

## When to Activate

This skill activates when:
- The conversation has had 3-5 back-and-forth exchanges
- The conversation still has a generic or auto-generated name
- The main topic/task of the conversation has become clear

## How It Works

After a few messages, Claude evaluates whether the conversation would benefit from a descriptive name. If so, it runs `/rename` with a concise, descriptive title.

## Naming Guidelines

Good conversation names:
- Describe the main task or topic (e.g., "refactor auth middleware", "debug stripe webhook")
- Are concise (2-5 words)
- Use lowercase with spaces or hyphens
- Avoid generic names like "coding help" or "quick question"

## Usage

The hook automatically reminds Claude to evaluate renaming. No manual invocation needed.

To manually trigger:
```
Consider renaming this conversation
```

Or explicitly:
```
/rename <new-name>
```
