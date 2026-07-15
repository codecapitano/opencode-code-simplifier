# Tasks: add-installer-script

## 1. Implement

- [x] 1.1 Write `install.sh` (POSIX sh; flags: `--project`, `--primary`, `--uninstall`, `--help`; XDG-aware global path; local-file-first source resolution with AGENT_URL fallback)
- [x] 1.2 Update README install section to lead with the installer

## 2. Verify

- [x] 2.1 Fresh global install + reinstall-overwrite + uninstall round-trip (against a temp HOME)
- [x] 2.2 `--project` install lands in `./.opencode/agents/` only
- [x] 2.3 `--primary` install contains `mode: all`; repo source unchanged; `opencode run --agent code-simplifier` uses the real agent (no fallback warning)
- [x] 2.4 No-source failure path exits non-zero with actionable message
- [x] 2.5 `openspec validate add-installer-script --strict`

## 3. Wrap up

- [x] 3.1 Commit on main
- [x] 3.2 Archive the change
