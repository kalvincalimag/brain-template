#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  ".gitignore"
  "AGENTS.md"
  "CLAUDE.md"
  "README.md"
  "artifacts/README.md"
  "memory/MEMORY.md"
  "memory/decisions.md"
  "memory/overview.md"
  "memory/project.md"
  "planning/README.md"
  "research/index.md"
  "scripts/validate-brain.sh"
  "sessions/README.md"
  "skills/README.md"
  "templates/decision-record.md"
  "templates/session-summary.md"
)

failures=0

for relative_path in "${required_files[@]}"; do
  if [[ ! -f "$repo_root/$relative_path" ]]; then
    printf 'missing required file: %s\n' "$relative_path" >&2
    failures=$((failures + 1))
  fi
done

if [[ -d "$repo_root/.codex" ]]; then
  printf 'project-local .codex runtime directory must not be committed\n' >&2
  failures=$((failures + 1))
fi

if [[ -f "$repo_root/memory/MEMORY.md" ]]; then
  memory_lines="$(wc -l < "$repo_root/memory/MEMORY.md" | tr -d ' ')"
  if ((memory_lines > 200)); then
    printf 'memory/MEMORY.md exceeds the 200-line limit: %s\n' "$memory_lines" >&2
    failures=$((failures + 1))
  fi
fi

if [[ -f "$repo_root/CLAUDE.md" ]] && ! grep -q 'AGENTS.md' "$repo_root/CLAUDE.md"; then
  printf 'CLAUDE.md must defer to AGENTS.md\n' >&2
  failures=$((failures + 1))
fi

if [[ -f "$repo_root/.gitignore" ]] && ! grep -Eq '^/?\.codex/$' "$repo_root/.gitignore"; then
  printf '.gitignore must exclude the project-local .codex directory\n' >&2
  failures=$((failures + 1))
fi

for heading in 'Scope and precedence' 'Startup protocol' 'Knowledge architecture' 'Verification' 'Session writeback'; do
  if [[ -f "$repo_root/AGENTS.md" ]] && ! grep -Fqi "## $heading" "$repo_root/AGENTS.md"; then
    printf 'AGENTS.md is missing required heading: %s\n' "$heading" >&2
    failures=$((failures + 1))
  fi
done

if find "$repo_root" -path "$repo_root/.git" -prune -o \
  \( -name 'rollout-*.jsonl' -o -name '*.sqlite' -o -name '*.sqlite3' \) -print -quit | grep -q .; then
  printf 'raw Codex rollout or runtime database found in repository\n' >&2
  failures=$((failures + 1))
fi

if ((failures > 0)); then
  printf 'brain structure validation failed with %s issue(s)\n' "$failures" >&2
  exit 1
fi

printf 'brain structure validation passed\n'
