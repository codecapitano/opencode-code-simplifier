# Spec: installer

## ADDED Requirements

### Requirement: Global install by default
Running `install.sh` with no flags SHALL copy the agent file to `${XDG_CONFIG_HOME:-$HOME/.config}/opencode/agents/code-simplifier.md`, creating the directory if needed.

#### Scenario: Fresh global install
- **WHEN** `./install.sh` runs on a machine without the agent installed
- **THEN** the file exists at the global agents path afterwards and the script reports the installed location

### Requirement: Project-scoped install
`install.sh --project` SHALL copy the agent file to `./.opencode/agents/code-simplifier.md` relative to the current working directory.

#### Scenario: Project install
- **WHEN** `./install.sh --project` runs inside a project directory
- **THEN** `.opencode/agents/code-simplifier.md` exists in that project and the global location is untouched

### Requirement: Primary-mode transform
`install.sh --primary` SHALL install the agent with frontmatter `mode: all` instead of `mode: subagent`, leaving the repository source file unchanged.

#### Scenario: CLI-ready install
- **WHEN** `./install.sh --primary` runs
- **THEN** the installed file contains `mode: all`, the repo's `agents/code-simplifier.md` still contains `mode: subagent`, and `opencode run --agent code-simplifier` does not fall back to the default agent

### Requirement: Idempotent overwrite and uninstall
Re-running the installer SHALL overwrite an existing installed file and say so; `install.sh --uninstall` SHALL remove the installed file for the selected scope and report when there was nothing to remove.

#### Scenario: Reinstall over existing
- **WHEN** `./install.sh` runs twice
- **THEN** the second run succeeds and notes it replaced an existing install

#### Scenario: Uninstall
- **WHEN** `./install.sh --uninstall` runs after an install
- **THEN** the installed file is gone and the exit code is 0

### Requirement: Fails loudly without a source
When the agent file is neither present next to the script nor downloadable, the installer SHALL exit non-zero with an actionable error message.

#### Scenario: No source available
- **WHEN** the script runs outside the repo and the download URL is unreachable
- **THEN** it exits non-zero and names both locations it tried
