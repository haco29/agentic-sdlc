#!/usr/bin/env bash
# Vendors skills, agents and references from addyosmani/agent-skills (MIT) at a
# pinned commit, then applies two mechanical rewrites so they fit this kit:
#   1. skill namespace  agent-skills:<skill>  ->  agentic-sdlc:<skill>
#   2. artifact paths   tasks/plan.md, tasks/todo.md, SPEC.md  ->  sdlc/<branch>/...
#
# Usage: scripts/sync-upstream.sh [<commit-or-ref>]
#   UPSTREAM_REPO  git URL or local path (default: the GitHub repo)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
UPSTREAM_REPO="${UPSTREAM_REPO:-https://github.com/addyosmani/agent-skills.git}"
REF="${1:-$(sed -n 's/^Commit: //p' "$ROOT/UPSTREAM.md" 2>/dev/null || true)}"
REF="${REF:-HEAD}"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone --quiet "$UPSTREAM_REPO" "$TMP/upstream"
git -C "$TMP/upstream" checkout --quiet "$REF"
SHA="$(git -C "$TMP/upstream" rev-parse HEAD)"
SRC="$TMP/upstream"

# Replace only what upstream owns; this kit's own skills live alongside them.
for dir in "$SRC"/skills/*/; do
  name="$(basename "$dir")"
  rm -rf "$ROOT/skills/$name"
  mkdir -p "$ROOT/skills"
  cp -R "$dir" "$ROOT/skills/$name"
done
rm -rf "$ROOT/agents" "$ROOT/references"
cp -R "$SRC/agents" "$ROOT/agents"
cp -R "$SRC/references" "$ROOT/references"
cp "$SRC/LICENSE" "$ROOT/licenses/agent-skills-LICENSE"

upstream_skills="$(cd "$SRC/skills" && ls -d */ | tr -d /)"
files=()
for name in $upstream_skills; do
  while IFS= read -r f; do files+=("$f"); done < <(find "$ROOT/skills/$name" -type f -name '*.md')
done
while IFS= read -r f; do files+=("$f"); done < <(find "$ROOT/agents" "$ROOT/references" -type f -name '*.md')

for f in "${files[@]}"; do
  perl -pi -e '
    s/\bagent-skills:(?=[a-z])/agentic-sdlc:/g;
    s#tasks/plan\.md#sdlc/<branch>/plan.md#g;
    s#tasks/todo\.md#sdlc/<branch>/todo.md#g;
    s#`tasks/`#`sdlc/<branch>/`#g;
    s#(?<![/\w-])`SPEC\.md`#`sdlc/<branch>/spec.md`#g;
    s#(?<![/\w`-])SPEC\.md(?![\w`])#sdlc/<branch>/spec.md#g;
  ' "$f"
done

cat > "$ROOT/UPSTREAM.md" <<EOF
# Upstream

The skills, agents and references listed below are vendored from
[addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) (MIT, see
\`licenses/agent-skills-LICENSE\`).

Commit: $SHA

Two mechanical rewrites are applied by \`scripts/sync-upstream.sh\`, nothing else:

1. Skill references \`agent-skills:<skill>\` become \`agentic-sdlc:<skill>\`.
2. Artifact paths \`SPEC.md\`, \`tasks/plan.md\` and \`tasks/todo.md\` become
   \`sdlc/<branch>/spec.md\`, \`plan.md\` and \`todo.md\`.

To update, run \`scripts/sync-upstream.sh <commit>\` and review the diff.

## Vendored skills

$(for n in $upstream_skills; do echo "- $n"; done)

## Vendored agents and references

$(cd "$SRC" && find agents references -type f | sort | sed 's/^/- /')
EOF

echo "Synced agent-skills @ $SHA"
