---
name: himalaya
description: "Use when the user asks to read, send, search, or manage email from the terminal. Himalaya is a CLI email client supporting IMAP, Maildir, Notmuch, SMTP, and Sendmail backends. Trigger on: email, inbox, send email, check mail, reply to email, forward email, email folders."
---

# Himalaya — CLI Email Management

Himalaya is a Rust-based CLI for managing email across multiple accounts.

## Prerequisites

```bash
# Already installed via Homebrew
himalaya --version

# If not installed:
brew install himalaya
```

Config file: `~/.config/himalaya/config.toml`

Setup wizard: `himalaya account configure <name>`

## Key Concepts

- **Account** — A named group of settings (IMAP/SMTP credentials, folders, etc.)
- **Envelope** — Lightweight message summary (id, flags, subject, from, date)
- **Message** — Full email content (headers + body)
- **Folder** — Message container (INBOX, Sent, Drafts, etc.)

## Output Format

Always use `--output json` when parsing results programmatically:
```bash
himalaya envelope list --output json
himalaya message read <id> --output json
```

Use `--output plain` (default) for human-readable display.

## Command Reference

### Accounts
```bash
himalaya account list                    # List configured accounts
himalaya account configure <name>        # Interactive setup wizard
himalaya account doctor <name>           # Diagnose connection issues
```

### Folders
```bash
himalaya folder list                     # List all folders
himalaya folder add <name>               # Create folder
himalaya folder delete <name>            # Delete folder
himalaya folder purge <name>             # Remove all messages
himalaya folder expunge <name>           # Permanently remove flagged-deleted messages
```

### Envelopes (list/search)
```bash
himalaya envelope list                   # List envelopes in INBOX
himalaya envelope list -f Sent           # List in specific folder
himalaya envelope list -q "subject:meeting"  # Search
himalaya envelope list -s date:desc      # Sort by date descending
himalaya envelope list -p 1 -ps 50      # Pagination: page 1, 50 per page
himalaya envelope thread <id>            # Show thread for envelope
```

### Messages
```bash
himalaya message read <id>               # Read message (human-friendly)
himalaya message read <id1> <id2>        # Read multiple messages
himalaya message thread <id>             # Read full thread
himalaya message export <id>             # Export raw message (EML)
himalaya message write                   # Compose new message (opens $EDITOR)
himalaya message reply <id>              # Reply to message
himalaya message reply -a <id>           # Reply all
himalaya message forward <id>            # Forward message
himalaya message copy <id> -t <folder>   # Copy to folder
himalaya message move <id> -t <folder>   # Move to folder
himalaya message delete <id>             # Mark as deleted
himalaya message send < msg.eml          # Send raw message from stdin
himalaya message save -f Drafts < msg.eml  # Save to folder
```

### Flags
```bash
himalaya flag add <id> seen              # Mark as read
himalaya flag add <id> flagged           # Star/flag message
himalaya flag remove <id> seen           # Mark as unread
himalaya flag set <id> seen flagged      # Replace all flags
```

### Attachments
```bash
himalaya attachment download <id>        # Download all attachments
himalaya attachment download <id> -d /tmp  # Download to specific directory
```

### Templates (advanced)
```bash
himalaya template write                  # Generate blank compose template
himalaya template reply <id>             # Generate reply template
himalaya template forward <id>           # Generate forward template
himalaya template send < template.eml    # Send from template
himalaya template save < template.eml    # Save as draft
```

## Common Workflows

### Check inbox
```bash
himalaya envelope list -ps 20
```

### Read and reply
```bash
himalaya message read <id>
himalaya message reply <id>
```

### Search for emails
```bash
himalaya envelope list -q "from:alice subject:project"
```

### Send a quick email via template
```bash
# Generate template, edit, send — all programmatic
himalaya template write | sed 's/To: /To: alice@example.com/' | himalaya template send
```

### Multi-account usage
```bash
himalaya -a work envelope list           # Use "work" account
himalaya -a personal envelope list       # Use "personal" account
```

## Configuration Example

```toml
# ~/.config/himalaya/config.toml

[accounts.default]
email = "user@example.com"
display-name = "User Name"
folder.alias.inbox = "INBOX"
folder.alias.sent = "Sent"
folder.alias.drafts = "Drafts"
folder.alias.trash = "Trash"

# IMAP backend
backend.type = "imap"
backend.host = "imap.example.com"
backend.port = 993
backend.encryption = "tls"
backend.login = "user@example.com"
backend.auth.type = "password"
backend.auth.command = "security find-generic-password -a user@example.com -s himalaya -w"

# SMTP sender
message.send.backend.type = "smtp"
message.send.backend.host = "smtp.example.com"
message.send.backend.port = 465
message.send.backend.encryption = "tls"
message.send.backend.login = "user@example.com"
message.send.backend.auth.type = "password"
message.send.backend.auth.command = "security find-generic-password -a user@example.com -s himalaya-smtp -w"
```

## Tips

- Use macOS Keychain for passwords: `security find-generic-password -a <account> -s <service> -w`
- For Gmail: use app-specific passwords or OAuth 2.0
- For iCloud Mail: use app-specific passwords from appleid.apple.com
- Debug connection issues: `himalaya --debug account doctor <name>`
- Pipe JSON output to `jq` for scripting: `himalaya envelope list -o json | jq '.[].subject'`
