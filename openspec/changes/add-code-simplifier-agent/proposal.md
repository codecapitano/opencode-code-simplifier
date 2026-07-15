# Proposal: add-code-simplifier-agent

## Why

OpenCode has no built-in agent for cleaning up freshly written or AI-generated code the way Claude Code's official `code-simplifier` plugin does. Porting the concept gives OpenCode users a behavior-preserving cleanup subagent — and doing it as an original rewrite (not a copy of the Apache-2.0 prompt) keeps it contributable to the MIT-licensed OpenCode project.

## What Changes

- New OpenCode subagent definition `agents/code-simplifier.md` (markdown + YAML frontmatter, `mode: subagent`)
- Prompt written from scratch expressing: behavior preservation, cleanup targets, over-simplification guardrails, style-source fallback chain, recent-changes scope, and a mechanical verify step (typecheck/lint/tests after edits)
- No pinned model; users override via `opencode.json` (`agent.code-simplifier.model`) — documented in README
- README with install instructions (copy to `~/.config/opencode/agents/`), usage (`@code-simplifier` mention or Task-tool delegation), and model-override snippet
- MIT LICENSE (all wording original; courtesy "inspired by" credit to Anthropic's plugin)
- Explicitly out of scope: multi-agent fan-out/debate (subagent→subagent nesting undocumented in OpenCode; low ROI vs mechanical verification)

## Capabilities

### New Capabilities
- `code-simplifier-agent`: An OpenCode subagent that refines recently modified code for readability and consistency without changing behavior, verifies its edits with the project's own checks, and follows a defined style-source priority.

### Modified Capabilities

_None — greenfield project._

## Impact

- New repo content only: `agents/code-simplifier.md`, `README.md`, `LICENSE`
- User machine: one file copied to `~/.config/opencode/agents/`
- No code dependencies; requires OpenCode to consume the agent definition
- Licensing: original wording throughout; safe for later upstream contribution to OpenCode (MIT)
