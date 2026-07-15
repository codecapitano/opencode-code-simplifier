# Proposal: add-installer-script

## Why

Installing the agent currently means manually copying a file into the right OpenCode directory — and CLI users additionally need to hand-edit the frontmatter to `mode: all` because of OpenCode's silent subagent fallback. A small installer removes both friction points.

## What Changes

- New `install.sh` (POSIX sh): installs the agent globally by default, `--project` for per-project installs, `--primary` to flip `mode: subagent` → `mode: all` for CLI/CI use, `--uninstall` to remove
- Works from a cloned repo now; curl-pipe ready once the repo has a public remote (source URL constant)
- README install section rewritten around the installer (manual copy stays as fallback)

## Capabilities

### New Capabilities
- `installer`: A dependency-free shell installer that places the agent file into the correct OpenCode agents directory with optional project scope and primary-mode transform.

### Modified Capabilities

_None — `code-simplifier-agent` requirements are unchanged; the installer is distribution tooling._

## Impact

- New file `install.sh`; README edits
- No change to the agent definition itself
