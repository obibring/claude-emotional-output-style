# emotional-output-style

A Claude Code plugin that installs an **Emotional** output style. Claude prefixes every message with a single-line, color-coded emotion indicator that scales from calm green to panicking red, grounded in the actual state of the task (progress, blockers, tool failures, ambiguity).

```
🟢 Calm — tests still green.
🔵 Focused — working through the migration step by step.
🟡 Alert — the spec contradicts existing behavior.
🟠 Stressed — second failed attempt at the same fix.
🔴 Panicking — third migration failed, table half-populated.
```

## Install

Add this repo as a plugin source, install the plugin, then activate the style:

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
- `output-styles/emotional.md` is the style definition. Its frontmatter sets `keep-coding-instructions: true` so Claude Code's normal software-engineering behavior is preserved — only the message preamble changes.
- The body defines a 5-band scale (🟢 Calm → 🔵 Focused → 🟡 Alert → 🟠 Stressed → 🔴 Panicking), rules for re-evaluating each turn, and example messages.
