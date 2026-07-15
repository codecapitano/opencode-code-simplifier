# Design: add-simplify-command

## Context

OpenCode commands are markdown files in `~/.config/opencode/commands/` (global) or `.opencode/commands/` (project) with frontmatter (`description`, `agent`, `model`, `subtask`) and a prompt template body supporting `$ARGUMENTS`. `subtask: true` forces subagent invocation, which sidesteps the subagent/primary mode issue entirely for command users. Automatic delegation by primary agents is driven by the subagent's `description` text.

## Goals / Non-Goals

**Goals:**
- `/simplify [optional focus]` in the TUI, no syntax knowledge needed
- "Simplify my code" to the Build agent reliably routes to code-simplifier
- Installer keeps a single entry point for both files

**Non-Goals:**
- Auto-trigger after every edit (no such hook in OpenCode; delegation + command are the supported paths)
- Changing agent behavior — description wording only

## Decisions

- **Command frontmatter:** `agent: code-simplifier`, `subtask: true`, no model pin (inherits/respects `opencode.json` overrides)
- **Template:** instructs the default recent-changes scope and appends `$ARGUMENTS` as optional focus/scope hints
- **Description rewrite:** leads with "Simplifies", enumerates trigger phrases ("simplify", "clean up", "tidy", "polish", "refactor for readability") — description is delegation routing surface, keep it keyword-dense but honest
- **Installer:** installs `simplify.md` to the commands dir next to the agents dir; `--uninstall` removes both; failure to fetch the command file is a hard error (same rule as the agent file)

## Risks / Trade-offs

- Delegation is model-judgment, not keyword matching — the description change raises the hit rate but cannot guarantee routing; `/simplify` is the deterministic path
- Two-file install introduces partial-install states if one download fails; mitigated by installing agent first and failing loudly before writing anything on fetch errors
