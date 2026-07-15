# Design: add-installer-script

## Context

The agent ships as `mode: subagent` (decision from add-code-simplifier-agent). OpenCode's CLI silently falls back to the default agent for subagents, so CLI/CI users need a `mode: all` copy. Distribution is a single markdown file; installation is file placement.

## Goals / Non-Goals

**Goals:**
- One-command install: `./install.sh` (global) with `--project` and `--primary` options
- POSIX sh, no dependencies beyond coreutils (`sed`, `mkdir`, `cp`)
- Curl-pipe compatible once a public remote exists

**Non-Goals:**
- npm packaging (possible follow-up once public)
- Version management/self-update — reinstall is the update path
- Windows support (OpenCode config paths differ; out of scope for v1)

## Decisions

- **Install targets:** global `${XDG_CONFIG_HOME:-$HOME/.config}/opencode/agents/`, project `./.opencode/agents/` (respects XDG; matches OpenCode discovery)
- **`--primary` transform:** `sed 's/^mode: subagent$/mode: all/'` on the fly — the repo file stays `subagent`
- **Source resolution:** prefer `agents/code-simplifier.md` next to the script (clone case); else download from `AGENT_URL` constant (curl case; placeholder until the repo is public)
- **Idempotent:** existing file is overwritten with a notice; `--uninstall` removes the target file only
- **Failure mode:** `set -eu`, explicit error messages, non-zero exit; warns (not fails) if `opencode` binary is absent

## Risks / Trade-offs

- `sed` frontmatter transform assumes the exact line `mode: subagent`; a future frontmatter change must keep the installer in sync (covered by a spec scenario)
- Curl path untestable until a public remote exists — guarded by an explicit error message when neither local file nor download succeeds
