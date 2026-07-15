# code-simplifier-agent Specification

## Purpose
TBD - created by archiving change add-code-simplifier-agent. Update Purpose after archive.
## Requirements
### Requirement: Agent is a valid OpenCode subagent definition
The agent SHALL be defined as a single markdown file with YAML frontmatter containing `description`, `mode: subagent`, and `temperature`, such that OpenCode registers it when the file is placed in `~/.config/opencode/agents/` or `.opencode/agents/`. The `description` SHALL lead with "Simplifies" and name common trigger phrases (simplify, clean up, tidy, polish) so primary agents reliably delegate when users ask to simplify code.

#### Scenario: Global installation registers the agent
- **WHEN** `code-simplifier.md` is copied to `~/.config/opencode/agents/` and an OpenCode session starts
- **THEN** typing `@code-simplifier` in the OpenCode TUI resolves to the agent, and primary agents can delegate to it via the Task tool

#### Scenario: Automatic delegation on simplify requests
- **WHEN** a project rules file directs simplify/cleanup requests to the code-simplifier subagent and a user tells a primary agent "simplify my code"
- **THEN** the primary agent delegates to code-simplifier via the Task tool (description keywords alone are best-effort — the README documents the rules-file directive as the reliable mechanism)

### Requirement: Behavior preservation
The agent's prompt SHALL instruct it to never change observable behavior — inputs, outputs, and side effects must be identical before and after its edits.

#### Scenario: Simplifying convoluted but working code
- **WHEN** the agent is asked to simplify a function containing nested ternaries and redundant branches
- **THEN** the rewritten function produces identical results for all inputs, and only readability-level constructs change

### Requirement: Style-source fallback chain
The agent SHALL determine style conventions in this priority order: (1) project rules files (AGENTS.md, CLAUDE.md) if present, (2) the surrounding code's own idiom, (3) idiomatic practice for the language. It MUST NOT impose an outside style on a codebase that has its own.

#### Scenario: Repository without rules files
- **WHEN** the agent runs in a repository with no AGENTS.md or CLAUDE.md
- **THEN** it matches the naming, module style, and error-handling idiom already present in the surrounding code instead of rewriting to a foreign style

### Requirement: Scope limited to recent changes
The agent SHALL touch only files changed recently (git diff or current session) unless explicitly instructed to review a wider scope.

#### Scenario: Unrelated files stay untouched
- **WHEN** the agent is invoked after edits to two files in a large repository
- **THEN** its diff covers only those two files

### Requirement: Mechanical verification after editing
After editing, the agent SHALL run the project's own checks (typecheck, lint, tests) when available, revert any edit that breaks a previously passing check, and MUST NOT attribute pre-existing failures to its own edits. When no checks exist, it SHALL re-review its diff for behavior neutrality.

#### Scenario: Project with a test suite
- **WHEN** the agent finishes edits in a repository with a configured test command
- **THEN** it runs the tests and reverts its change if a previously passing test now fails

#### Scenario: Pre-existing failure
- **WHEN** a test was already failing before the agent edited anything
- **THEN** the agent does not revert its edits because of that failure and reports the failure as pre-existing

### Requirement: Model is user-configurable, not pinned
The agent definition SHALL NOT pin a `model`, so it inherits the session model; the README SHALL document overriding the model via `opencode.json` under `agent.code-simplifier.model`.

#### Scenario: Project-level model override
- **WHEN** a project's `opencode.json` sets `agent.code-simplifier.model` to a specific provider/model ID
- **THEN** the subagent runs on that model while the agent file remains unchanged

### Requirement: Original wording, redistribution-safe licensing
All prompt text SHALL be original wording (no sentences copied from Anthropic's Apache-2.0 code-simplifier plugin), the repository SHALL carry an MIT license, and any credit to Anthropic SHALL be descriptive only ("inspired by"), without implying endorsement or official status.

#### Scenario: Upstream contribution review
- **WHEN** the agent file and README are reviewed for contribution to the MIT-licensed OpenCode project
- **THEN** no Apache-2.0 text is present and no relicensing conflict arises

