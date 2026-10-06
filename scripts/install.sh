#!/usr/bin/env bash
# Installs the kit without the plugin system: for Cursor, or for Claude Code when
# plugins aren't available. Prefer the plugin install in the README when you can.
#
# Usage: scripts/install.sh [--cursor] [--force]
#   default   copies into ~/.claude/{commands,skills,agents}
#   --cursor  copies into ~/.cursor/{commands,skills}
#   --force   overwrite files that already exist (otherwise they are skipped)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="$HOME/.claude"
FORCE=0
for arg in "$@"; do
  case "$arg" in
    --cursor) TARGET="$HOME/.cursor" ;;
    --force) FORCE=1 ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

copied=0
skipped=0
copy() { # <src> <dest>
  if [[ -e "$2" && $FORCE -eq 0 ]]; then
    echo "skip (exists): $2"
    skipped=$((skipped + 1))
    return
  fi
  mkdir -p "$(dirname "$2")"
  cp -R "$1" "$2"
  copied=$((copied + 1))
}

for f in "$ROOT"/commands/*.md; do copy "$f" "$TARGET/commands/$(basename "$f")"; done
for d in "$ROOT"/skills/*/; do copy "${d%/}" "$TARGET/skills/$(basename "$d")"; done
if [[ "$TARGET" == "$HOME/.claude" ]]; then
  for f in "$ROOT"/agents/*.md; do copy "$f" "$TARGET/agents/$(basename "$f")"; done
fi
# Skills point at references/ next to them in the plugin; keep a copy alongside.
copy "$ROOT/references" "$TARGET/agentic-sdlc/references"

echo "agentic-sdlc: $copied copied, $skipped skipped, into $TARGET"
echo "Restart your editor, then type / and look for /spec ... /pr."
