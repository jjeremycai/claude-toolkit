#!/bin/bash

# Auto-Rename Activator Hook
# Reminds Claude to consider renaming the conversation after a few exchanges.
#
# Installation:
#   1. Copy this script to ~/.claude/hooks/
#   2. Make it executable: chmod +x ~/.claude/hooks/auto-rename-activator.sh
#   3. Add to ~/.claude/settings.json hooks.UserPromptSubmit

# Track message count in a temp file per session
SESSION_FILE="/tmp/claude-session-$$-rename"
PARENT_SESSION_FILE="/tmp/claude-session-$PPID-rename"

# Use parent PID for consistency across hook invocations
if [ -f "$PARENT_SESSION_FILE" ]; then
    COUNT=$(cat "$PARENT_SESSION_FILE")
else
    COUNT=0
fi

COUNT=$((COUNT + 1))
echo "$COUNT" > "$PARENT_SESSION_FILE"

# Only prompt between messages 3-5, and only once
if [ "$COUNT" -ge 3 ] && [ "$COUNT" -le 5 ]; then
    # Check if we already prompted
    PROMPTED_FILE="/tmp/claude-session-$PPID-rename-prompted"
    if [ ! -f "$PROMPTED_FILE" ]; then
        touch "$PROMPTED_FILE"
        cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 CONVERSATION RENAME CHECK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

After completing this request, briefly consider:
- Does this conversation have a descriptive name yet?
- Is the main topic/task now clear?

If the conversation would benefit from a better name, run:
  /rename <concise-descriptive-name>

Good names: "refactor auth flow", "debug webhook", "add dark mode"
Skip if already well-named or topic is still unclear.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    fi
fi
