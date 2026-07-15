# opencode-code-simplifier

A behavior-preserving code cleanup subagent for [OpenCode](https://opencode.ai). It refines recently changed code — readability, redundancy, naming, structure — without altering what the code does, then verifies its edits with the project's own checks.

Inspired by the concept of [Anthropic's code-simplifier plugin](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/code-simplifier) for Claude Code. All prompt text here is written from scratch; this project is not affiliated with or endorsed by Anthropic.

## Install

Copy the agent file to your global OpenCode agents directory:

```sh
cp agents/code-simplifier.md ~/.config/opencode/agents/code-simplifier.md
```

Or per-project:

```sh
cp agents/code-simplifier.md .opencode/agents/code-simplifier.md
```

## Usage

- **Manual:** mention it in any OpenCode session — `@code-simplifier clean up my recent changes`
- **Delegated:** primary agents (e.g. Build) can route cleanup work to it automatically via the Task tool, based on the agent's description

By default it only touches recently changed files (git diff / current session). Ask explicitly if you want a wider sweep.

## What it does — and won't do

- Flattens needless nesting, cuts duplication, clarifies names, removes noise comments
- Follows your project's conventions: rules files (`AGENTS.md`/`CLAUDE.md`) first, then the surrounding code's idiom, then language defaults
- Runs your typecheck/lint/tests after editing and reverts anything that breaks a previously passing check
- Never changes behavior, dissolves useful abstractions, or trades readability for line count

## Configuration

No model is pinned — the agent inherits your session model. To pin one, add to `opencode.json` (global `~/.config/opencode/opencode.json` or per-project; project wins on conflicts):

```json
{
  "agent": {
    "code-simplifier": {
      "model": "anthropic/claude-opus-4-8"
    }
  }
}
```

Any other agent option (`temperature`, `permission`, …) can be overridden the same way.

## License

[MIT](LICENSE)
