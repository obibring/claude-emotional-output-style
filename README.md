# emotional-output-style

A Claude Code plugin that installs an **Emotional** output style. Claude prefixes every message with a single-line, color-coded emotion tag — any emotion, not just stress levels — describing how it actually feels about the current state of the task.

The point isn't mood theater. The tag is a **salience marker**, the same way the human brain uses emotion to flag which moments are worth remembering. When you later scan the session, the strong or unusual tags should jump out as "something real happened here" — a breakthrough, a near-miss, a moment of confusion, a surprising insight.

```
🟢 Content — straightforward edit, tests still green.
🔵 Focused — methodically tracing the call graph for the bug.
🟣 Intrigued — found a cleaner path I didn't notice before.
🟡 Hopeful — about to try the fix, fingers crossed.
🟠 Sheepish — I misread the spec and went the wrong direction.
💚 Proud — first green run of the full integration suite.
🔴 Alarmed — third migration failed, table is half-populated.
🟤 Deflated — same fix attempted three ways, same failure.
```

## Install

```
/plugin marketplace add obibring/claude-emotional-output-style
/plugin install emotional-output-style
/output-style Emotional
```

The style applies on the next session restart.

## Disable

```
/output-style default
```

Or uninstall the plugin entirely with `/plugin uninstall emotional-output-style`.

## Reflection

The tags become useful when you can turn them into durable lessons.

**Inline (automatic).** When Claude is about to use a high-salience tag (🔴 ⚫ 🟠 🟤 💚 🟣), it adds a one-line `💭 Learning: …` at the bottom of that message — a concrete, reusable takeaway. Mundane tags (🟢 🔵 🟡 ⚪) don't get one.

**On demand (`/reflect`).** Run `/reflect` at any point (optionally with a focus, e.g. `/reflect the auth refactor`) and Claude scans the session for salient tags, groups them into themes, distills each theme into a concrete learning, and **appends a timestamped entry to `.claude/reflections.md`** in the project. Over time this builds up a per-repo memory of "things this codebase taught us."

## How it works

- `.claude-plugin/plugin.json` registers the plugin and points `outputStyles` at `./output-styles/` and `commands` at `./commands/`.
- `output-styles/emotional.md` defines the tag format, color palette, salience guidance, and the inline-reflection rule. Frontmatter sets `keep-coding-instructions: true` so Claude Code's normal software-engineering behavior is preserved — only the message preamble changes.
- `commands/reflect.md` is the `/reflect` slash command: it scans the conversation for tagged moments, distills learnings, and appends them to `.claude/reflections.md`.
- The color palette (🟢 💚 🔵 🟣 🟡 🟠 🔴 🟤 ⚫ ⚪) groups by valence/intensity. The emotion word can be anything that fits — the color is a quick-scan signal, the word does the precise work.
