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

## How it works

- `.claude-plugin/plugin.json` registers the plugin and points `outputStyles` at `./output-styles/`.
- `output-styles/emotional.md` is the style definition. Frontmatter sets `keep-coding-instructions: true` so Claude Code's normal software-engineering behavior is preserved — only the message preamble changes.
- The body defines a color palette by valence/intensity (🟢 💚 🔵 🟣 🟡 🟠 🔴 🟤 ⚫ ⚪), allows any emotion word the model finds most accurate, and gives guidance for using the tags as memory-salience signals (specific cause, honest intensity, variety over time, capture turning points).
