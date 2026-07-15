#!/bin/sh
# Installer for the code-simplifier OpenCode agent.
#
# Usage:
#   ./install.sh              install globally (~/.config/opencode/agents/)
#   ./install.sh --project    install into ./.opencode/agents/ of the current project
#   ./install.sh --primary    install with mode: all so `opencode run --agent code-simplifier` works
#   ./install.sh --uninstall  remove the installed agent (honors --project)
#   ./install.sh --help       show this help
set -eu

AGENT_NAME="code-simplifier.md"
# Raw URL used when the script runs without a local checkout (curl | sh).
# TODO: set once the repository has a public remote.
AGENT_URL=""

scope="global"
primary=0
uninstall=0

usage() {
  sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'
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
  target_dir="./.opencode/agents"
else
  target_dir="${XDG_CONFIG_HOME:-$HOME/.config}/opencode/agents"
fi
target="$target_dir/$AGENT_NAME"

if [ "$uninstall" = 1 ]; then
  if [ -f "$target" ]; then
    rm "$target"
    echo "Removed $target"
  else
    echo "Nothing to remove at $target"
  fi
  exit 0
fi

# Source resolution: local checkout first, then download.
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source_file="$script_dir/agents/$AGENT_NAME"
tmp_file=""

if [ ! -f "$source_file" ]; then
  tmp_file=$(mktemp)
  trap 'rm -f "$tmp_file"' EXIT
  if [ -n "$AGENT_URL" ] && command -v curl >/dev/null 2>&1 && curl -fsSL "$AGENT_URL" -o "$tmp_file"; then
    source_file="$tmp_file"
  else
    echo "error: agent file not found" >&2
    echo "  tried: $script_dir/agents/$AGENT_NAME" >&2
    echo "  tried: ${AGENT_URL:-<no download URL configured>}" >&2
    echo "Run this script from a checkout of the repository." >&2
    exit 1
  fi
fi

replaced=0
[ -f "$target" ] && replaced=1

mkdir -p "$target_dir"
if [ "$primary" = 1 ]; then
  sed 's/^mode: subagent$/mode: all/' "$source_file" > "$target"
else
  cp "$source_file" "$target"
fi

if [ "$replaced" = 1 ]; then
  echo "Replaced existing install at $target"
else
  echo "Installed $target"
fi
if [ "$primary" = 1 ]; then
  echo "Installed with mode: all — usable via Tab, @code-simplifier, and 'opencode run --agent code-simplifier'."
else
  echo "Usable via @code-simplifier in the TUI or Task-tool delegation."
  echo "For CLI use ('opencode run --agent ...'), reinstall with --primary."
fi
command -v opencode >/dev/null 2>&1 || echo "note: 'opencode' not found on PATH — install it from https://opencode.ai" >&2
