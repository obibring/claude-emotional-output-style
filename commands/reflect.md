---
description: Consolidate this session's emotional tags and Why notes into durable learnings, recognize recurring patterns from past sessions, append to .claude/reflections.md.
argument-hint: [optional focus, e.g. "the auth refactor"]
---

The user has asked you to reflect on this session, using the emotional tags and inline `💭 Why:` notes from the Emotional output style as salience signals.

This is the **consolidation** step — the analogue of memory consolidation during sleep. The raw, situational material was captured at encoding time (the tags and `Why:` blocks). Your job now is to distill durable learnings and surface recurring patterns.

## What to do

### 1. Read prior reflections

If `.claude/reflections.md` exists, read it. The accumulated entries are this project's memory across sessions. Knowing what was already learned matters for two reasons:

- Avoid re-learning the same thing in slightly different words.
- **Recognize recurring patterns.** If this session's 🟠 Sheepish moment about a misread spec is the third such moment across all reflections, that's a schema — promote it from "single learning" to "recurring pattern" with much higher salience.

### 2. Scan this session's tagged moments

Walk back through the assistant messages and collect those that began with an emotion tag. Focus on the high-salience bands — they're the ones with `Why:` blocks attached, which is where the rich encoding lives:

- 🔴 high-intensity negative — what went wrong, what the misdiagnosis was
- ⚫ stuck / dark — what was blocking, what (if anything) unstuck it
- 💚 warm-positive — what went meaningfully right, worth repeating
- 🟣 surprised / novel — what was unexpected, what the new mental model is
- 🟠 friction / mixed — misreads, tradeoffs, places the path was non-obvious
- 🟤 low-energy negative — patterns of repeated failure, sunk-cost loops

Mundane tags (🟢 🔵 🟡 ⚪) are usually not where learnings live — skim past them unless they cluster around a turning point.

### 3. Group, then distill

Group related moments into themes. Three Sheepish/Frustrated moments about the same misread spec are one theme, not three.

For each theme, distill a learning that is:

- **Concrete** — names files, commands, libraries, table columns, error messages
- **Reusable** — a future session in this repo would benefit from knowing it
- **Specific** — not "be more careful," but "always re-read the failing test output before re-running"
- **Causal where possible** — "X happened because Y" beats "X happened"

### 4. Cross-reference with prior reflections

For each theme, check the prior reflections:

- **Recurrence:** Is this the same kind of moment that's been tagged before? If yes, mark it as a recurring pattern and link the dates.
- **Contradiction:** Does this session's learning revise something an earlier reflection asserted? Note the revision explicitly — re-consolidation matters.
- **Reinforcement:** If this session validated a prior learning under new circumstances, note that too.

### 5. Append to `.claude/reflections.md`

Create the file and any parent directories if missing. Use this format:

```markdown
## <YYYY-MM-DD HH:MM> — <one-line session summary>

**TL;DR:** <one sentence — the single most important thing from this session>

<optional one-paragraph context: what the session was about>

### Learnings

- **<short title>** — <the concrete, reusable learning>. Tagged moments: <emoji> <emoji>…
- **<short title>** — <learning>. Tagged moments: <emoji>…

### Recurring patterns

<only include this section if at least one theme recurs from prior reflections>
- **<pattern>** — seen now and on <date(s) from prior reflections>. Synthesis: <what the schema is>.

### Revisions

<only include this section if this session changes something a prior reflection said>
- **<earlier claim>** (from <date>) — now updated to: <revised understanding>.

### Notable moments

- <emoji> <Emotion> — <what was happening, file/command if relevant>
- <emoji> <Emotion> — <…>
```

Notable moments is a short list (≤ ~8 items) — not a transcript.

### 6. Honor the focus argument

If `$ARGUMENTS` is non-empty, treat it as a focus filter — only include learnings related to that topic. Otherwise cover the whole session.

### 7. Show the user

After writing, show the user the **appended block** in your reply (not the whole file) so they can see what was captured. If you recognized a recurring pattern, call that out explicitly — it's the highest-value outcome of consolidation.

## Tone

This is for future-you and future-them. Be honest. If a stretch of the session was a mess, the learning is "here's what the mess taught us," not a sanitized success story. If nothing genuinely memorable happened, say so plainly and append a short entry that acknowledges that — don't pad. Padding pollutes the memory.
