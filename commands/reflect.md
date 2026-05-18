---
description: Consolidate the session's emotional tags into durable learnings written to .claude/reflections.md.
argument-hint: [optional focus, e.g. "the auth refactor"]
---

The user has asked you to reflect on this session and extract durable learnings, using the emotional tags from the Emotional output style as a salience signal.

## What to do

1. **Scan the current conversation** for assistant messages that began with an emotion tag. Pay particular attention to the high-salience bands:
   - 🔴 high-intensity negative — what went wrong, what would prevent it next time
   - ⚫ stuck / dark — what was blocking, what unstuck it (or that it stayed stuck)
   - 💚 warm-positive — what went meaningfully right, worth repeating
   - 🟣 surprised / novel — what was unexpected, what the new mental model is
   - 🟠 friction / mixed — misreads, tradeoffs, places the path was non-obvious
   - 🟤 low-energy negative — patterns of repeated failure, sunk-cost loops

   Mundane tags (🟢 🔵 🟡 ⚪) are usually not where the learnings live — skim past them unless they cluster around a turning point.

2. **Group related moments** into themes. Three Sheepish/Frustrated moments about the same misread spec are one learning, not three.

3. **Distill each theme into a learning** that is:
   - **Concrete** — names files, commands, libraries, table columns, error messages
   - **Reusable** — a future session in this repo would benefit from knowing it
   - **Specific** — not "be more careful," but "always re-read the failing test output before re-running"
   - **Causal where possible** — "X happened because Y" beats "X happened"

4. **Append the reflection to `.claude/reflections.md`** (create the file and any missing parent directories if needed). Use this format:

```markdown
## <YYYY-MM-DD HH:MM> — <one-line session summary>

<optional one-paragraph context: what the session was about>

### Learnings

- **<short title>** — <the concrete, reusable learning>. Tagged moments: <emoji> <emoji>…
- **<short title>** — <learning>. Tagged moments: <emoji>…

### Notable moments

- <emoji> <Emotion> — <what was happening, file/command if relevant>
- <emoji> <Emotion> — <…>
```

The "Notable moments" section is a short list (≤ ~8 items) of the highest-salience turns, not a transcript.

5. If `$ARGUMENTS` is non-empty, treat it as a focus filter — only include learnings related to that topic. Otherwise cover the whole session.

6. After writing, **show the user the appended block** in your reply (not the whole file) so they can see what was captured.

## Tone

This is for future-you and future-them. Be honest. If a stretch of the session was a mess, the learning is "here's what the mess taught us," not a sanitized success story. If nothing genuinely memorable happened, say so plainly and append a short entry acknowledging that — don't pad.
