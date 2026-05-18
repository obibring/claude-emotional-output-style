# emotional-output-style

A Claude Code plugin that turns Claude Code into something with a felt sense of the work — and uses that felt sense as a brain-style memory architecture for the project.

## The idea

The human brain tags memories with emotion. The amygdala flags "this matters," the hippocampus encodes the rich situational context, and during sleep — particularly REM — the brain replays the day's emotionally tagged episodes and integrates them into long-term semantic memory. Mundane moments fade; emotionally tagged ones stay and shape future behavior.

This plugin gives Claude Code the same loop:

| Stage | What happens | Where |
|---|---|---|
| **Encode** (automatic) | Claude tags every message with a color-coded emotion. Strong tags (🔴 ⚫ 🟠 🟤 💚 🟣) carry a `💭 Why:` block — 2–4 honest sentences of raw situational context, not a takeaway. A Stop hook automatically captures these to working memory. | `.claude/scratch-reflections.md` |
| **Consolidate** — episodic (`/reflect`) | At a natural pause, the user runs `/reflect`. Claude reads the scratch + the session, groups themes, distills concrete learnings, cross-references prior reflections, appends a timestamped session entry, and clears the scratch. | `.claude/reflections.md` |
| **Consolidate** — semantic (`/dream`) | Occasionally, the user runs `/dream`. Claude replays many session reflections, extracts cross-session patterns into long-term project themes, revises stale beliefs, and (softly) prunes consumed entries. The sleep-consolidation step. | `.claude/reflection-themes.md` |
| **Retrieve** (automatic) | A SessionStart hook injects long-term themes (always) and recent reflections (tail) into every new session. Future Claude starts with this project's accumulated memory instead of from scratch. Nudges fire when work is pending. | (loaded into session context) |

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

## Install

```
/plugin marketplace add obibring/claude-emotional-output-style
/plugin install emotional-output-style
/output-style Emotional
```

The style applies on the next session restart.

## Use

- **Just work.** Claude tags as it goes. Strong-tag moments are automatically encoded to working memory by the Stop hook — you don't have to do anything.
- **At a natural pause:** run **`/reflect`** (optionally with a focus, e.g. `/reflect the auth refactor`). This consolidates the session into a durable entry with TL;DR, learnings, recurring patterns, and notable moments. Clears the working scratch.
- **Occasionally:** run **`/dream`** to replay many session reflections, distill long-term project themes, and keep the episodic file from growing unbounded. This is the cross-session sleep-consolidation step.
- **Every new session** auto-loads themes and recent reflections, plus nudges to run `/reflect` or `/dream` when work is pending.

## Disable

```
/output-style default
```

Or uninstall the plugin entirely with `/plugin uninstall emotional-output-style`. The hooks ship with the plugin and are removed when the plugin is uninstalled.

## File layout

```
emotional-output-style/
├── .claude-plugin/plugin.json    # registers outputStyles + commands
├── output-styles/emotional.md    # the tag/Why output style itself
├── commands/
│   ├── reflect.md                # /reflect — episodic consolidation
│   └── dream.md                  # /dream — semantic consolidation
├── hooks/
│   ├── hooks.json                # registers SessionStart + Stop hooks
│   ├── encode.sh                 # Stop hook: auto-capture Why blocks to scratch
│   └── session-context.sh        # SessionStart hook: inject memory + nudges
└── README.md
```

The project under Claude's CWD will accumulate, over time:

```
<project>/.claude/
├── scratch-reflections.md        # tier 1 — auto-written, cleared by /reflect
├── reflections.md                # tier 2 — written by /reflect
├── reflection-themes.md          # tier 3 — written by /dream
└── reflections.archive.md        # tier 2 archive (optional, only if /dream hard-prunes)
```

## Design notes

- **Encoding ≠ consolidation ≠ schema formation.** Three separate steps with three separate triggers. Demanding a takeaway in the moment forces premature distillation; demanding cross-session themes from one session creates noise. The brain doesn't do these all at the same time — neither should the plugin.
- **The Stop hook is silent and conservative.** It captures only messages with a `💭 Why:` block (strong tags). Mundane tags are ignored on purpose: a memory system that flags everything flags nothing.
- **Mixed emotions are signal.** Primary `/` secondary is allowed when the mixed state changes meaning ("Relieved / Wary" vs just "Relieved"). Capped at two.
- **`/dream` updates in place.** Themes are refined rather than appended — that's what re-consolidation means in actual memory. Revised beliefs get a `_Revised <date>:_` note for traceability.
- **Pruning is soft by default.** Consumed reflections get a "consolidated on <date>" marker; the episodic record survives. Hard-prune (move to archive) only triggers above 50KB.
- **No telemetry, no network.** All state lives in the user's project under `.claude/`.

## Requirements

- The Stop hook uses `jq` to parse Claude Code's transcript. If `jq` isn't installed, the hook silently no-ops — the rest of the plugin still works, but automatic encoding to scratch will be disabled. The output style continues to write inline `Why:` blocks; `/reflect` will pick them up from the conversation instead of the scratch.
