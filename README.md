# opencode-code-simplifier

A behavior-preserving code cleanup subagent for [OpenCode](https://opencode.ai). It refines recently changed code — readability, redundancy, naming, structure — without altering what the code does, then verifies its edits with the project's own checks.

Inspired by the concept of [Anthropic's code-simplifier plugin](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/code-simplifier) for Claude Code. All prompt text here is written from scratch; this project is not affiliated with or endorsed by Anthropic.

## Install

One-liner (no checkout needed):

```sh
curl -fsSL https://raw.githubusercontent.com/codecapitano/opencode-code-simplifier/main/install.sh | sh
```

Pass flags through sh, e.g. `... | sh -s -- --primary`.

From a checkout of this repository:

```sh
./install.sh              # global (~/.config/opencode/agents/)
./install.sh --project    # this project only (./.opencode/agents/)
./install.sh --primary    # global, with mode: all for CLI use (see below)
./install.sh --uninstall  # remove
```

Or copy the file manually:

```sh
cp agents/code-simplifier.md ~/.config/opencode/agents/code-simplifier.md   # global
cp agents/code-simplifier.md .opencode/agents/code-simplifier.md            # per-project
```

## Usage

- **Manual:** mention it in any OpenCode session — `@code-simplifier clean up my recent changes`
- **Delegated:** primary agents (e.g. Build) can route cleanup work to it automatically via the Task tool, based on the agent's description

By default it only touches recently changed files (git diff / current session). Ask explicitly if you want a wider sweep.

## What it does — and won't do

- Flattens needless nesting, cuts duplication, clarifies names, removes noise comments
- Follows your project's conventions: rules files (`AGENTS.md`/`CLAUDE.md`) first, then the surrounding code's idiom, then language defaults
- Runs your typecheck/lint/tests before editing to record a baseline, re-runs them after, and reverts anything that breaks a check that passed in the baseline (pre-existing failures are reported, not blamed on its edits)
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

Most other agent options (`temperature`, `permission`, …) can be overridden the same way — but not `mode`: OpenCode resolves subagent-vs-primary from the agent file itself, so a JSON `mode` override won't take effect (verified on OpenCode 1.18.1).

**Heads-up for CLI use:** `opencode run --agent code-simplifier` silently falls back to the default agent, because this agent ships as `mode: subagent`. For non-interactive runs (scripts, CI, pre-commit hooks), install with `./install.sh --primary`, which flips the frontmatter to `mode: all`; in the TUI, the `@code-simplifier` mention works as-is.

## License

[MIT](LICENSE)
