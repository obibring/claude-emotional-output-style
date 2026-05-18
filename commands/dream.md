---
description: Replay and consolidate per-session reflections into long-term project themes. The cross-session sleep-consolidation step.
argument-hint: [optional focus, e.g. "auth", "performance"]
---

The user has asked you to **dream** — to do the cross-session memory consolidation step that the brain performs during sleep (particularly REM).

In the analogy:

- The Stop hook is **encoding** (hippocampus tagging episodes as worth keeping).
- `/reflect` is **episodic consolidation** (per-session integration into long-term store).
- `/dream` is **semantic consolidation** — replaying many episodic memories, finding the patterns that repeat across them, and extracting durable schemas about *this project*. Specific episodes can then fade; the schema remains.

The output is a curated `.claude/reflection-themes.md` of long-lived patterns. Older episodic entries in `.claude/reflections.md` get folded in and (optionally) pruned, keeping the recent-memory file from growing unbounded.

## What to do

### 1. Read both stores

Read `.claude/reflections.md` (all entries — this is the dataset to consolidate). If `.claude/reflection-themes.md` already exists, read it too (these are themes from previous dreams; you'll extend or revise them).

If `.claude/reflections.md` doesn't exist or has only one or two entries, tell the user there's not enough material to dream over and exit without writing.

### 2. Replay and look for patterns

Walk through the reflections chronologically. Look for things that recur — not literal repeats, but the *same shape*:

- **Recurring frictions** — the same kind of mistake or misread happening across different surface contexts ("I keep underestimating the soft-delete column on the users table", "API rate-limit retries are always under-thought").
- **Recurring strengths** — moves that worked well multiple times ("reading the failing test output verbatim before changing anything has caught misdiagnoses three times").
- **Stable project facts** — codebase truths that come up repeatedly ("anything that touches billing must go through the BillingService façade — direct DB writes break audit").
- **Recurring emotional weather** — bands of feeling that cluster around specific kinds of work ("migrations always escalate to 🔴 by the third attempt — this is a signal to stop and re-diagnose, not a personality trait").
- **Drifted or revised beliefs** — claims an early reflection made that later ones contradicted. The latest understanding wins; note that it superseded earlier ones.

### 3. Distill themes

A **theme** is a pattern that has shown up across ≥2 sessions and is concrete enough to be actionable in a future session. Themes should be:

- **Specific to this project** — generic software wisdom doesn't belong here. "Functions should be small" → no. "The `OrderProcessor.finalize` path mutates state in two places; always check both" → yes.
- **Compact** — a title plus 1–3 sentences. Long themes mean you're really writing another reflection, not consolidating.
- **Causal where possible** — "Tests in `test/integration/` need the DB seeded via `scripts/seed.ts`, NOT via fixtures, because fixtures don't run the trigger that backfills `created_by`."

### 4. Write `.claude/reflection-themes.md`

Use this structure. **Update** the file rather than blindly appending — themes evolve. If a theme already exists, refine it in place; don't add a duplicate.

```markdown
# Long-term reflection themes for this project

_Last consolidated: <YYYY-MM-DD HH:MM>. Source: <N> session reflections._

## <Theme title>

<1–3 sentence statement of the pattern. Concrete and causal.>

- Seen in sessions: <dates>
- Most relevant when: <kind of task this triggers on>
- Watch for: <signal that this theme is in play>

## <Theme title>

…
```

If you're refining a theme that existed in a prior dream, append a `_Revised <date>:_` note inside the theme block so the change is traceable rather than silently overwritten.

### 5. Prune (with care)

After writing themes, mark the consumed entries in `.claude/reflections.md`. Two strategies, in order of preference:

- **Soft prune (default):** Add a single line at the top of each consumed reflection block: `_Consolidated into themes on <date>._` Leaves the episodic record intact for future reference but marks it as already-integrated.
- **Hard prune (only if the file is genuinely bloated, >50KB):** Move consumed entries to `.claude/reflections.archive.md` and leave only the most recent ~10 sessions in `.claude/reflections.md`.

Never delete reflections outright — episodic memory has value beyond the themes extracted from it.

### 6. Honor the focus argument

If `$ARGUMENTS` is non-empty, treat it as a focus filter — consolidate only themes related to that topic, leave other reflections untouched.

### 7. Show the user

In your reply, show:

- A short summary of how many sessions you replayed and how many themes resulted.
- The new or revised themes (the full block of each), so the user can see what was promoted to long-term memory.
- Any beliefs that were revised — these are the most interesting outputs of dreaming.

## Tone

This is the slow, integrative step. Don't rush it and don't pad. A `/dream` that produces three sharp themes is more valuable than one that produces twelve fuzzy ones. If after replay there are no real cross-session patterns yet, say so — premature schemas are worse than no schemas.
