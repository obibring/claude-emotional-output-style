---
description: Consolidate this session's tagged moments (plus any auto-encoded scratch) into a durable per-session reflection appended to .claude/reflections.md.
argument-hint: [optional focus, e.g. "the auth refactor"]
---

The user has asked you to reflect on this session. This is the **per-session consolidation** step — Tier 1 (raw working memory) → Tier 2 (episodic memory).

In the brain analogy: the hippocampus has been silently encoding moments (the Stop hook writes them to `.claude/scratch-reflections.md`). Now you're integrating those raw episodes plus the current session's inline `💭 Why:` notes into a durable episodic record. Cross-session theme distillation (semantic memory) is a separate step — `/dream` — not this one.

## What to do

### 1. Read prior reflections

If `.claude/reflections.md` exists, read it. Knowing what was already recorded matters so you don't restate the same things in slightly different words.

If `.claude/reflection-themes.md` exists, read it too — it tells you which patterns have already been promoted to long-term themes by `/dream`. Don't relearn them; instead, note when *this* session reinforced or contradicted them.

### 2. Read the scratch buffer

If `.claude/scratch-reflections.md` exists and is non-empty, read it. Each `## <timestamp>` block is a raw encoded moment captured automatically by the Stop hook. These are the **strongest signal** for this consolidation — they're the messages where the model thought "this is worth remembering" in the moment.

### 3. Scan the current conversation

Walk back through the session's assistant messages and collect those that began with an emotion tag, paying particular attention to the high-salience bands (🔴 ⚫ 💚 🟣 🟠 🟤). Cross-check against the scratch — most strong-tag turns should already be there; a missing one might mean the hook didn't fire or the user reverted the message.

### 4. Group, then distill

Group related moments into themes. Three Sheepish/Frustrated moments about the same misread spec are one theme, not three.

For each theme, distill a learning that is:

- **Concrete** — names files, commands, libraries, table columns, error messages
- **Reusable** — a future session in this repo would benefit from knowing it
- **Specific** — not "be more careful," but "always re-read the failing test output before re-running"
- **Causal where possible** — "X happened because Y" beats "X happened"

### 5. Cross-reference

For each theme, check prior reflections and themes:

- **Recurrence:** Is this the same kind of moment that's been tagged before? Note it — it's a candidate for `/dream` to promote to a long-term theme.
- **Contradiction:** Does this session's learning revise something earlier? Note the revision (re-consolidation matters).
- **Reinforcement:** Did this session validate a prior learning under new circumstances? Note it.

### 6. Append to `.claude/reflections.md`

Create the file and any parent directories if missing. Use this format:

```markdown
## <YYYY-MM-DD HH:MM> — <one-line session summary>

**TL;DR:** <one sentence — the single most important thing from this session>

<optional one-paragraph context: what the session was about>

### Learnings

- **<short title>** — <the concrete, reusable learning>. Tagged moments: <emoji> <emoji>…
- **<short title>** — <learning>. Tagged moments: <emoji>…

### Recurring patterns

<only if at least one theme recurs from prior reflections>
- **<pattern>** — seen now and on <date(s)>. Synthesis: <what the schema is>. (Candidate for `/dream`.)

### Revisions

<only if this session changes something a prior reflection said>
- **<earlier claim>** (from <date>) — now updated to: <revised understanding>.

### Notable moments

- <emoji> <Emotion> — <what was happening, file/command if relevant>
- <emoji> <Emotion> — <…>
```

Notable moments is a short list (≤ ~8 items) — not a transcript.

### 7. Clear the scratch buffer

After successfully writing the reflection block, truncate `.claude/scratch-reflections.md` to empty. The raw episodes have been integrated; keeping them around would cause the next `/reflect` to double-count them.

If you wrote no learnings (session genuinely had nothing memorable — be honest about this), still clear the scratch.

### 8. Honor the focus argument

If `$ARGUMENTS` is non-empty, treat it as a focus filter — only include learnings related to that topic. Otherwise cover the whole session.

### 9. Show the user

After writing, show the **appended block** in your reply (not the whole file). If you noticed a recurring pattern that's now appeared enough times to be worth promoting, suggest the user run `/dream`.

## Tone

This is for future-you and future-them. Be honest. If a stretch of the session was a mess, the learning is "here's what the mess taught us," not a sanitized success story. If nothing genuinely memorable happened, say so plainly and append a short entry that acknowledges that — don't pad. Padding pollutes the memory.
