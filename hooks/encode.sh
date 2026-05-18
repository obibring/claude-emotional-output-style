#!/usr/bin/env bash
# Stop hook for the Emotional output style plugin.
#
# Runs after every assistant turn. If the most recent assistant message
# contains a "💭 Why:" block (a strong-tag encoding moment), append the
# message to .claude/scratch-reflections.md so the raw situational context
# is captured automatically — independent of whether the user runs /reflect.
#
# Silent on every other case (mundane tags, no tags, missing jq, etc.).

set -euo pipefail

command -v jq >/dev/null 2>&1 || exit 0

input=$(cat)
transcript_path=$(printf '%s' "$input" | jq -r '.transcript_path // empty' 2>/dev/null || true)
[ -n "$transcript_path" ] && [ -f "$transcript_path" ] || exit 0

# Concatenated text of the last assistant message in the transcript.
msg=$(jq -rs '
  [.[] | select(.type=="assistant")]
  | last
  | (.message.content // [])
  | map(select(.type=="text") | .text)
  | join("")
' "$transcript_path" 2>/dev/null || true)

[ -n "$msg" ] || exit 0

# Only persist on strong tags (those with a Why block).
printf '%s' "$msg" | grep -q "💭 Why:" || exit 0

# Cap each entry so the scratch file does not bloat with long messages.
truncated=$(printf '%s' "$msg" | head -c 3000)

mkdir -p .claude
{
  printf '\n---\n## %s\n\n' "$(date -Iseconds 2>/dev/null || date -u +%Y-%m-%dT%H:%M:%SZ)"
  printf '%s\n' "$truncated"
} >> .claude/scratch-reflections.md

exit 0
