# Delta: installer

## MODIFIED Requirements

### Requirement: Idempotent overwrite and uninstall
Re-running the installer SHALL overwrite existing installed files and say so; `install.sh --uninstall` SHALL remove the installed agent file and command file for the selected scope and report when there was nothing to remove.

#### Scenario: Reinstall over existing
- **WHEN** `./install.sh` runs twice
- **THEN** the second run succeeds and notes it replaced an existing install

#### Scenario: Uninstall
- **WHEN** `./install.sh --uninstall` runs after an install
- **THEN** both the installed agent file and command file are gone and the exit code is 0

## ADDED Requirements

### Requirement: Command file installs alongside the agent
The installer SHALL install `commands/simplify.md` to the commands directory of the selected scope (global `${XDG_CONFIG_HOME:-$HOME/.config}/opencode/commands/`, project `./.opencode/commands/`) in the same run that installs the agent, using the same local-first/download-fallback source resolution.

#### Scenario: Both files installed globally
- **WHEN** `./install.sh` runs with no flags
- **THEN** both `agents/code-simplifier.md` and `commands/simplify.md` exist under the global OpenCode config directory
