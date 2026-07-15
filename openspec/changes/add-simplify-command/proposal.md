# Proposal: add-simplify-command

## Why

Users want a `/simplify` command in the OpenCode TUI and automatic delegation when they ask OpenCode to "simplify my code". Today the agent requires knowing the `@code-simplifier` mention syntax, and its description never contains the word "simplify", weakening Task-tool routing.

## What Changes

- New `commands/simplify.md`: OpenCode command with `agent: code-simplifier` and `subtask: true` (runs as subagent regardless of mode), template forwards `$ARGUMENTS`
- Agent `description` reworded to lead with "Simplifies" and name the trigger phrases (simplify, clean up, tidy, polish) for reliable automatic delegation
- `install.sh` installs/uninstalls the command file alongside the agent (global and `--project`)
- README documents `/simplify` and automatic delegation

## Capabilities

### New Capabilities
- `simplify-command`: A `/simplify` OpenCode command that routes to the code-simplifier subagent.

### Modified Capabilities
- `code-simplifier-agent`: The agent description requirement gains delegation-keyword wording (behavior of the agent itself is unchanged).
- `installer`: Install/uninstall now covers the command file in addition to the agent file.

## Impact

- New file `commands/simplify.md`; edits to `agents/code-simplifier.md` (description only), `install.sh`, README
- Installed users need to re-run the installer to get the command
