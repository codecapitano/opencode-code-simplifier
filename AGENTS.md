# Contributor rules

This repo is spec-driven with [OpenSpec](https://github.com/Fission-AI/OpenSpec). The source of truth for behavior lives in `openspec/specs/`; completed changes are archived under `openspec/changes/archive/`.

## When to use OpenSpec

Most changes need an OpenSpec change; trivial ones don't.

**Required** — anything that changes behavior or adds capability:

- The agent prompt's semantics (`agents/code-simplifier.md`) — verification flow, scope rules, style-source chain
- Installer behavior (`install.sh`) — flags, install targets, source resolution
- The `/simplify` command's behavior (`commands/simplify.md`)
- New capabilities of any kind

**Not required** — direct PR is fine:

- Typos, grammar, wording polish in docs or comments
- README updates that describe existing behavior more accurately
- CI/tooling chores that don't touch shipped files

Rule of thumb: if a requirement or scenario in `openspec/specs/` would need to change (or a new one would be needed), use OpenSpec. Bug fixes restoring specced behavior may go as direct PRs referencing the violated scenario.

## Workflow

1. `openspec new change <kebab-case-name>` → author proposal, design, specs (delta), tasks
2. Implement per tasks; check them off as they genuinely complete
3. Verify: every spec scenario needs a real exercised check, not an assumption — see the archived changes for examples
4. `openspec validate <change> --strict` must pass
5. PR to `main` (branch-protected — no direct pushes)
6. After merge and verification: `openspec archive <change> --yes` (syncs deltas into `openspec/specs/`) in a follow-up PR

## Repo-specific facts agents should know

- `mode: subagent` agents silently fall back to the default agent under `opencode run --agent` — test agent changes via the `/simplify` command (`subtask: true`) or a project-level `mode: all` copy; check stderr for the fallback warning
- The shipped default stays `mode: subagent`; CLI users opt in via `install.sh --primary`
- All prompt text must remain original wording (MIT-clean, no text from Anthropic's Apache-2.0 plugin) — see the licensing requirement in `openspec/specs/code-simplifier-agent/spec.md`
- Test installer changes against a temp `$HOME` (see archived installer change for the pattern); the curl download path must be tested from a directory without a checkout

## Code style

- `install.sh` is POSIX sh — no bashisms; keep it dependency-free beyond coreutils and curl
- When asked to simplify, clean up, tidy, or polish code, delegate to the code-simplifier subagent via the task tool instead of editing inline
