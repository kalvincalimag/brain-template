#!/usr/bin/env bash
# Checks this brain's structure. Run: bash scripts/validate-brain.sh
set -uo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
failures=0
report() { printf '%s\n' "$1" >&2; failures=$((failures + 1)); }

# Required files: core.txt plus one list per profile this brain was built with.
for list in "$repo_root"/tests/required/*.txt; do
  while IFS= read -r relative_path || [[ -n "$relative_path" ]]; do
    relative_path="${relative_path%$'\r'}"
    [[ -z "$relative_path" || "$relative_path" == \#* ]] && continue
    [[ -f "$repo_root/$relative_path" ]] || report "missing required file: $relative_path"
  done < "$list"
done

memory_index="$repo_root/memory/MEMORY.md"
if [[ -f "$memory_index" ]]; then
  memory_lines="$(wc -l < "$memory_index" | tr -d ' ')"
  ((memory_lines > 200)) && report "memory/MEMORY.md exceeds the 200-line limit: $memory_lines"

  # Every relative link in the index must point at a file that exists.
  while IFS= read -r target; do
    target="${target%%#*}"
    [[ -z "$target" || "$target" == http* || "$target" == mailto:* ]] && continue
    [[ -e "$repo_root/memory/$target" ]] || report "broken link in memory/MEMORY.md: $target"
  done < <(grep -oE '\]\([^)]+\)' "$memory_index" | sed -E 's/^\]\((.*)\)$/\1/')
fi

if [[ -f "$repo_root/CLAUDE.md" ]] && ! grep -q '^@AGENTS.md' "$repo_root/CLAUDE.md"; then
  report "CLAUDE.md must import AGENTS.md with an @AGENTS.md line"
fi

for heading in 'Scope and precedence' 'Purpose' 'Startup protocol' 'Knowledge architecture' 'Sensitive data' 'Verification' 'Session writeback'; do
  if [[ -f "$repo_root/AGENTS.md" ]] && ! grep -qFx "## $heading" "$repo_root/AGENTS.md"; then
    report "AGENTS.md is missing required heading: $heading"
  fi
done

placeholders="$(grep -rlE --exclude-dir=.git '\{\{(BRAIN_NAME|PURPOSE|CREATED|TEMPLATE_REF|PROFILES)\}\}' "$repo_root" 2>/dev/null)"
[[ -n "$placeholders" ]] && report "unfilled placeholder in: ${placeholders//$'\n'/, }"

skills="$(find "$repo_root" -path "$repo_root/.git" -prune -o -name SKILL.md -print 2>/dev/null)"
[[ -n "$skills" ]] && report "skills are out of scope for a brain; keep them in ~/.claude/skills: ${skills//$'\n'/, }"

if (cd "$repo_root" && git rev-parse --git-dir) >/dev/null 2>&1; then
  tracked_private="$(cd "$repo_root" && git ls-files -- private | grep -vx 'private/README.md')"
  [[ -n "$tracked_private" ]] && report "files in private/ must never be tracked by git: ${tracked_private//$'\n'/, }"
fi

if find "$repo_root" -path "$repo_root/.git" -prune -o \
  \( -name 'rollout-*.jsonl' -o -name '*.sqlite' -o -name '*.sqlite3' \) -print -quit | grep -q .; then
  report "raw agent transcript or runtime database found in the brain"
fi

if ((failures > 0)); then
  printf 'brain structure validation failed with %s issue(s)\n' "$failures" >&2
  exit 1
fi
printf 'brain structure validation passed\n'
