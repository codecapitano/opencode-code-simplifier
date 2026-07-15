# Tasks: add-code-simplifier-agent

## 1. Author deliverables

- [x] 1.1 Write `agents/code-simplifier.md` (frontmatter: description, mode: subagent, temperature: 0.1; body: what-to-improve, what-not-to-do, style-source chain, scope, verify step, workflow — all original wording)
- [x] 1.2 Write `README.md` (what it is, install via copy to `~/.config/opencode/agents/`, usage via `@code-simplifier` and Task delegation, model override via `opencode.json`, inspired-by credit, license note)
- [x] 1.3 Write `LICENSE` (MIT, copyright Marco Schäfer 2026)

## 2. Install and verify

- [x] 2.1 Copy `agents/code-simplifier.md` to `~/.config/opencode/agents/code-simplifier.md`
- [x] 2.2 Verify OpenCode registers the agent (`opencode agent list` or equivalent; fallback: check TUI `@` autocomplete manually)
- [x] 2.3 Validate the OpenSpec change (`openspec validate add-code-simplifier-agent`)

## 3. Wrap up

- [x] 3.1 Commit repo contents on main (initial commit; local only — no remote without visibility decision)
- [ ] 3.2 Archive the change (`openspec archive add-code-simplifier-agent`) once verified
