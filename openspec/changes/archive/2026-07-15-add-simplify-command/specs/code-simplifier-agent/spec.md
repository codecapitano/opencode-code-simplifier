# Delta: code-simplifier-agent

## MODIFIED Requirements

### Requirement: Agent is a valid OpenCode subagent definition
The agent SHALL be defined as a single markdown file with YAML frontmatter containing `description`, `mode: subagent`, and `temperature`, such that OpenCode registers it when the file is placed in `~/.config/opencode/agents/` or `.opencode/agents/`. The `description` SHALL lead with "Simplifies" and name common trigger phrases (simplify, clean up, tidy, polish) so primary agents reliably delegate when users ask to simplify code.

#### Scenario: Global installation registers the agent
- **WHEN** `code-simplifier.md` is copied to `~/.config/opencode/agents/` and an OpenCode session starts
- **THEN** typing `@code-simplifier` in the OpenCode TUI resolves to the agent, and primary agents can delegate to it via the Task tool

#### Scenario: Automatic delegation on simplify requests
- **WHEN** a project rules file directs simplify/cleanup requests to the code-simplifier subagent and a user tells a primary agent "simplify my code"
- **THEN** the primary agent delegates to code-simplifier via the Task tool (description keywords alone are best-effort — the README documents the rules-file directive as the reliable mechanism)
