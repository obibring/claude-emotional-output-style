#!/usr/bin/env bash
# SessionStart hook for the Emotional output style plugin.
#
# Injects this project's accumulated memory into the new session:
#   - Long-term themes (.claude/reflection-themes.md) — always
#   - Recent episodic reflections (.claude/reflections.md) — tail
#   - Nudges to /reflect or /dream when work is pending
#
# Output goes to stdout and is automatically included as session context.

set -euo pipefail

THEMES=".claude/reflection-themes.md"
REFLECTIONS=".claude/reflections.md"
SCRATCH=".claude/scratch-reflections.md"

emit_themes() {
  [ -f "$THEMES" ] || return 0
  printf '# Long-term reflection themes\n\n'
  printf 'Accumulated cross-session schemas for this project, written by the `/dream` command (Emotional output style plugin). These are durable patterns and lessons.\n\n'
  cat "$THEMES"
  printf '\n\n'
}

emit_recent_reflections() {
  [ -f "$REFLECTIONS" ] || return 0
  printf '# Recent session reflections\n\n'
  printf 'Recent per-session reflections in this project, written by `/reflect`. Older entries may have been consolidated into the themes above by `/dream`.\n\n'
  tail -c 16000 "$REFLECTIONS"
  printf '\n\n'
}

emit_nudges() {
  local nudges=""

  if [ -s "$SCRATCH" ]; then
    local count
    count=$(grep -c '^## ' "$SCRATCH" 2>/dev/null || echo 0)
    nudges+="- ${count} raw emotional encoding(s) pending in \`${SCRATCH}\` (captured automatically by the Stop hook in prior turn(s)). Run \`/reflect\` at the next natural pause to consolidate them into \`${REFLECTIONS}\`."$'\n'
  fi

  if [ -f "$REFLECTIONS" ]; then
    local size
    size=$(wc -c < "$REFLECTIONS" 2>/dev/null | tr -d ' ' || echo 0)
    if [ "${size:-0}" -gt 30000 ]; then
      nudges+="- \`${REFLECTIONS}\` has grown to ${size} bytes. Run \`/dream\` to consolidate older episodic entries into long-term themes and keep this session's context lean."$'\n'
    fi
  fi

  if [ -n "$nudges" ]; then
    printf '# Plugin nudges\n\n%s\n' "$nudges"
  fi
}

# Compose output. If nothing exists, exit silently.
out=""
out+="$(emit_themes)"
out+="$(emit_recent_reflections)"
out+="$(emit_nudges)"

[ -n "$out" ] && printf '%s' "$out"
exit 0
