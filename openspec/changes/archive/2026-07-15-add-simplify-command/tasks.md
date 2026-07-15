# Tasks: add-simplify-command

## 1. Implement

- [x] 1.1 Write `commands/simplify.md` (agent: code-simplifier, subtask: true, $ARGUMENTS forwarding)
- [x] 1.2 Reword agent `description` to lead with "Simplifies" + trigger phrases
- [x] 1.3 Extend `install.sh`: install/uninstall the command file for both scopes; add COMMAND_URL
- [x] 1.4 README: document /simplify and automatic delegation

## 2. Verify

- [x] 2.1 `opencode run --command simplify` executes the code-simplifier subagent (no fallback) and cleans up a scratch change
- [x] 2.2 Automatic delegation: AGENTS.md directive verified — Build announced delegation to code-simplifier (vs inline editing without the rule); headless run then hung on an OpenCode CLI quirk, task→subagent execution separately proven by the /simplify test
- [x] 2.3 Installer round-trip covers both files (install, reinstall, uninstall) in temp HOME + project scope
- [x] 2.4 `openspec validate add-simplify-command --strict`

## 3. Wrap up

- [x] 3.1 Commit on main, push
- [x] 3.2 Archive the change
