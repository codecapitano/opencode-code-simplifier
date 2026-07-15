#!/bin/sh
# Installer for the code-simplifier OpenCode agent and /simplify command.
#
# Usage:
#   ./install.sh              install globally (~/.config/opencode/)
#   ./install.sh --project    install into ./.opencode/ of the current project
#   ./install.sh --primary    install with mode: all so `opencode run --agent code-simplifier` works
#   ./install.sh --uninstall  remove the installed agent and command (honors --project)
#   ./install.sh --help       show this help
set -eu

AGENT_NAME="code-simplifier.md"
COMMAND_NAME="simplify.md"
# Raw URLs used when the script runs without a local checkout (curl | sh).
AGENT_URL="https://raw.githubusercontent.com/codecapitano/opencode-code-simplifier/main/agents/code-simplifier.md"
COMMAND_URL="https://raw.githubusercontent.com/codecapitano/opencode-code-simplifier/main/commands/simplify.md"

scope="global"
primary=0
uninstall=0

usage() {
  # Self-contained so --help also works when the script is piped (curl | sh).
  cat <<'EOF'
Installer for the code-simplifier OpenCode agent and /simplify command.

Usage:
  install.sh              install globally (~/.config/opencode/)
  install.sh --project    install into ./.opencode/ of the current project
  install.sh --primary    install with mode: all so `opencode run --agent code-simplifier` works
  install.sh --uninstall  remove the installed agent and command (honors --project)
  install.sh --help       show this help
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --project) scope="project" ;;
    --primary) primary=1 ;;
    --uninstall) uninstall=1 ;;
    --help|-h) usage; exit 0 ;;
    *) echo "error: unknown option '$1' (see --help)" >&2; exit 2 ;;
  esac
  shift
done

if [ "$scope" = "project" ]; then
  base_dir="./.opencode"
else
  base_dir="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
fi
agent_target="$base_dir/agents/$AGENT_NAME"
command_target="$base_dir/commands/$COMMAND_NAME"

if [ "$uninstall" = 1 ]; then
  removed=0
  for f in "$agent_target" "$command_target"; do
    if [ -f "$f" ]; then
      rm "$f"
      echo "Removed $f"
      removed=1
    fi
  done
  [ "$removed" = 0 ] && echo "Nothing to remove under $base_dir"
  exit 0
fi

# Source resolution: local checkout first, then download. Resolve both files
# before writing anything so a failed fetch never leaves a partial install.
# tmp_dir and its cleanup trap live in the main shell: resolve() runs inside
# command substitutions, where a subshell-local trap would delete the
# downloaded files before the parent could copy them.
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

resolve() { # $1: local relative path, $2: URL, prints resolved path or fails
  if [ -f "$script_dir/$1" ]; then
    printf '%s\n' "$script_dir/$1"
    return 0
  fi
  out="$tmp_dir/$(basename "$1")"
  if [ -n "$2" ] && command -v curl >/dev/null 2>&1 && curl -fsSL "$2" -o "$out"; then
    printf '%s\n' "$out"
    return 0
  fi
  echo "error: source not found for $(basename "$1")" >&2
  echo "  tried: $script_dir/$1" >&2
  echo "  tried: ${2:-<no download URL configured>}" >&2
  echo "Run this script from a checkout of the repository." >&2
  exit 1
}

agent_source=$(resolve "agents/$AGENT_NAME" "$AGENT_URL")
command_source=$(resolve "commands/$COMMAND_NAME" "$COMMAND_URL")

replaced=0
{ [ -f "$agent_target" ] || [ -f "$command_target" ]; } && replaced=1

mkdir -p "$base_dir/agents" "$base_dir/commands"
if [ "$primary" = 1 ]; then
  sed 's/^mode: subagent$/mode: all/' "$agent_source" > "$agent_target"
else
  cp "$agent_source" "$agent_target"
fi
cp "$command_source" "$command_target"

if [ "$replaced" = 1 ]; then
  echo "Replaced existing install:"
else
  echo "Installed:"
fi
echo "  $agent_target"
echo "  $command_target"
if [ "$primary" = 1 ]; then
  echo "Agent mode: all — usable via Tab, @code-simplifier, /simplify, and 'opencode run --agent code-simplifier'."
else
  echo "Usable via /simplify, @code-simplifier, or Task-tool delegation."
  echo "For CLI use ('opencode run --agent ...'), reinstall with --primary."
fi
command -v opencode >/dev/null 2>&1 || echo "note: 'opencode' not found on PATH — install it from https://opencode.ai" >&2
