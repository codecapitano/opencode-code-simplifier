# Spec: simplify-command

## ADDED Requirements

### Requirement: /simplify command routes to the code-simplifier subagent
The project SHALL ship `commands/simplify.md`, an OpenCode command with frontmatter `agent: code-simplifier` and `subtask: true`, whose template asks for cleanup of recent changes and forwards `$ARGUMENTS` as optional focus hints.

#### Scenario: Command invocation
- **WHEN** a user with the command installed runs `/simplify` in the OpenCode TUI (or `opencode run --command simplify`)
- **THEN** the code-simplifier subagent executes with its recent-changes default scope, with no fallback to the default agent

#### Scenario: Command with arguments
- **WHEN** a user runs `/simplify focus on the auth module`
- **THEN** the forwarded arguments appear in the subagent's instruction as additional focus
