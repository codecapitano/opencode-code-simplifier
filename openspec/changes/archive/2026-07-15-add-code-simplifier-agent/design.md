# Design: add-code-simplifier-agent

## Context

Claude Code ships an official `code-simplifier` plugin agent (Apache-2.0, `anthropics/claude-plugins-official`). OpenCode supports custom subagents as markdown files with YAML frontmatter, discovered from `~/.config/opencode/agents/` (global) or `.opencode/agents/` (project). This change ports the concept as an original rewrite.

## Goals / Non-Goals

**Goals:**
- Behavior-preserving cleanup subagent for OpenCode, invocable via `@code-simplifier` or Task-tool delegation
- Redistribution-safe: original wording, MIT, contributable upstream to OpenCode
- User-configurable model without editing the agent file
- Safer than the original: mechanical post-edit verification

**Non-Goals:**
- Multi-agent fan-out/debate (subagent→subagent nesting is undocumented in OpenCode; style debate is low-ROI vs mechanical checks; upstream contributions should stay minimal). Future option: a separate `simplify-deep` primary-mode agent that fans out read-only topic reviewers.
- Proactive auto-trigger after every edit (no session hook in OpenCode; delegation intent is carried by the `description` field)
- Packaging/marketplace distribution — plain file copy is the install story for v1

## Decisions

- **Frontmatter**: `description` (tuned for Task-tool delegation), `mode: subagent`, `temperature: 0.1`. Name derives from the filename. No `tools`/`permission` restrictions — the agent must edit files and run checks, so default subagent permissions apply.
- **No pinned model**: inherits session model; override documented via `opencode.json` → `agent.code-simplifier.model` (configs merge; project wins over global).
- **Prompt structure**: what-to-improve / what-not-to-do / style-source priority / scope / verify / workflow. Intentionally different structure and wording from the Apache-2.0 original.
- **Style-source fallback chain**: rules files (AGENTS.md, CLAUDE.md) → surrounding code idiom → language-idiomatic defaults. Handles rule-less repositories explicitly.
- **Verify step**: run project typecheck/lint/tests after edits; revert edits that break previously passing checks; treat pre-existing failures as out of scope.
- **Repo layout**: `agents/code-simplifier.md` + `README.md` + `LICENSE` (MIT) + `openspec/`. Install = copy to `~/.config/opencode/agents/`.

## Risks / Trade-offs

- **Prompt-only guarantees**: behavior preservation is enforced by instructions + verification, not by tooling; a weak session model can still make mistakes. Mitigation: verify step + user can pin a stronger model.
- **Docs drift**: OpenCode's agent schema may change (fields, discovery paths). Mitigation: minimal frontmatter surface.
- **Verification cost**: running full test suites can be slow in large repos; the prompt lets the agent fall back to diff self-review when no cheap checks exist.
