# emotional-output-style

A Claude Code plugin that turns Claude Code into something with a felt sense of the work — and uses that felt sense as a memory architecture.

## The idea

The human brain tags memories with emotion: the amygdala flags "this matters," the hippocampus encodes the rich situational context, and later (during sleep, during reflection) the lesson is consolidated into long-term memory. Mundane moments fade; emotionally tagged ones stay.

This plugin gives Claude Code the same loop:

1. **Encoding.** Every message starts with a color-coded emotion tag (any emotion, primary plus an optional secondary). Strong tags get a `💭 Why:` block describing the felt sense and what triggered it — situational, not prescriptive.
2. **Consolidation.** `/reflect` scans the session's tags and `Why:` notes, groups them into themes, distills durable learnings, and **appends a timestamped entry to `.claude/reflections.md`** in the project. It also reads prior reflections and surfaces recurring patterns across sessions.
3. **Retrieval.** A SessionStart hook injects `.claude/reflections.md` into every new session's context, so future Claude starts with this project's accumulated memory instead of from scratch.

```
🟢 Content — straightforward edit, tests still green.
🔵 Focused — methodically tracing the call graph for the bug.
🟣 Intrigued — found a cleaner path I didn't notice before.
🟢 Relieved / 🟡 Wary — fix shipped, but the edge case I flagged is untested.
🟠 Sheepish — I misread the spec and went the wrong direction.
💚 Proud — first green run of the full integration suite.
🔴 Alarmed — third migration failed, table is half-populated.
🟤 Deflated — same fix attempted three ways, same failure.
```

Strong tags (🔴 ⚫ 🟠 🟤 💚 🟣) carry a `💭 Why:` block of 2–4 honest sentences at the end of the message. Mundane tags (🟢 🔵 🟡 ⚪) don't.

## Install

```
/plugin marketplace add obibring/claude-emotional-output-style
/plugin install emotional-output-style
/output-style Emotional
```

The style applies on the next session restart.

## Use

- Just work normally. Claude tags and explains as it goes.
- Run **`/reflect`** at any natural pause (end of a feature, after a tough debug, before stopping for the day) — optionally with a focus, e.g. `/reflect the auth refactor`. It writes a TL;DR, learnings, recurring patterns, and notable moments to `.claude/reflections.md`.
- Future sessions in the same project automatically load that file at start, so accumulated lessons inform new work.

## Disable

```
/output-style default
```

Or uninstall the plugin entirely with `/plugin uninstall emotional-output-style`. The SessionStart hook ships with the plugin and is removed when the plugin is uninstalled.

## How it works

- `.claude-plugin/plugin.json` — registers the plugin and points `outputStyles` and `commands` at the directories below.
- `output-styles/emotional.md` — the style definition. Frontmatter sets `keep-coding-instructions: true`, so Claude Code's normal software-engineering behavior is preserved. Defines the format (primary + optional secondary emotion + short why), the color palette by valence/intensity (🟢 💚 🔵 🟣 🟡 🟠 🔴 🟤 ⚫ ⚪), the `💭 Why:` block rules for strong tags, and guidance for using prior-session reflections as context.
- `commands/reflect.md` — the `/reflect` slash command. Reads existing reflections, scans the session for tagged moments, distills learnings, cross-references for recurring patterns and revisions, and appends to `.claude/reflections.md`.
- `hooks/hooks.json` — a SessionStart hook (on `startup|resume|clear`) that, if `.claude/reflections.md` exists, injects the last ~20KB of it into the session as background context.

## Design notes

- **Encoding ≠ consolidation.** The inline `Why:` is deliberately *not* a learning. Demanding a takeaway in the moment forces premature distillation and tempts the model to fabricate. Raw situational material at encoding, distillation only at `/reflect`.
- **Mixed emotions are signal.** "Relieved / Wary" is a different memory than "Relieved." Two-emotion max; three+ is mood theater.
- **Mundane gets no `Why:`.** If everything got a Why block, nothing would stand out — the opposite of what the salience signal is for.
- **Recurring patterns are the highest-value output.** A single learning is useful; recognizing that the same kind of mistake has now happened three times across sessions is much more useful. `/reflect` is built to surface that.
