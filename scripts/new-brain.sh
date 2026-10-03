#!/usr/bin/env bash
# Creates a new brain from core/ plus any number of profiles.
#
# Usage:
#   bash scripts/new-brain.sh --dest DIR --name NAME --purpose TEXT [--profile NAME]...
#
# The destination must not exist or must be empty. The new brain is a local
# Git repository with no remote and no commits.
set -euo pipefail

template_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

die() { printf 'new-brain: %s\n' "$1" >&2; exit 1; }

dest="" name="" purpose=""
profiles=()
while (($#)); do
  case "$1" in
    --dest) dest="${2:-}"; shift 2 ;;
    --name) name="${2:-}"; shift 2 ;;
    --purpose) purpose="${2:-}"; shift 2 ;;
    --profile) profiles+=("${2:-}"); shift 2 ;;
    -h|--help) sed -n '2,8p' "${BASH_SOURCE[0]}"; exit 0 ;;
    *) die "unknown argument: $1" ;;
  esac
done

[[ -n "$dest" ]] || die "--dest is required"
[[ -n "$name" ]] || die "--name is required"
[[ -n "$purpose" ]] || die "--purpose is required"
if [[ -e "$dest" ]] && [[ -n "$(ls -A "$dest" 2>/dev/null)" ]]; then
  die "destination is not empty: $dest"
fi
for p in ${profiles[@]+"${profiles[@]}"}; do
  [[ -d "$template_root/profiles/$p" ]] || die "unknown profile: $p (see profiles/)"
done

template_ref="unversioned"
if git -C "$template_root" rev-parse --git-dir >/dev/null 2>&1; then
  template_ref="$(git -C "$template_root" rev-parse --short HEAD 2>/dev/null || echo unborn)"
  if [[ -n "$(git -C "$template_root" status --porcelain)" ]]; then
    template_ref="$template_ref with uncommitted template changes"
  fi
fi

# Build in a staging directory so a failure never leaves a half-made brain.
staging="$(mktemp -d)"
trap 'rm -rf "$staging"' EXIT
cp -R "$template_root/core/." "$staging/"

rules="" navigation=""
for p in ${profiles[@]+"${profiles[@]}"}; do
  profile_dir="$template_root/profiles/$p"
  while IFS= read -r -d '' file; do
    rel="${file#"$profile_dir/files/"}"
    [[ -e "$staging/$rel" ]] && die "collision: profile $p would overwrite $rel"
    mkdir -p "$staging/$(dirname "$rel")"
    cp "$file" "$staging/$rel"
  done < <(find "$profile_dir/files" -type f -print0)
  rules+="$(cat "$profile_dir/agents-rules.md")"$'\n\n'
  navigation+="$(cat "$profile_dir/memory-index.md")"$'\n'
done

# Replace each marker line with the profiles' text, or drop it.
export BRAIN_RULES="${rules%$'\n'}"
export BRAIN_NAVIGATION="${navigation%$'\n'}"
perl -0pi -e 's/^<!-- PROFILE RULES -->\n?/$ENV{BRAIN_RULES}/m' "$staging/AGENTS.md"
perl -0pi -e 's/^<!-- PROFILE NAVIGATION -->\n?/$ENV{BRAIN_NAVIGATION}\n/m' "$staging/memory/MEMORY.md"
perl -0pi -e 's/\n{3,}/\n\n/g; s/\n+\z/\n/' "$staging/AGENTS.md" "$staging/memory/MEMORY.md"

profile_list="none"
((${#profiles[@]})) && profile_list="$(IFS=,; echo "${profiles[*]}" | sed 's/,/, /g')"
export BRAIN_NAME="$name" BRAIN_PURPOSE="$purpose" BRAIN_CREATED="$(date +%F)" \
  BRAIN_TEMPLATE_REF="$template_ref" BRAIN_PROFILES="$profile_list"
while IFS= read -r -d '' file; do
  perl -pi -e '
    s/\{\{BRAIN_NAME\}\}/$ENV{BRAIN_NAME}/g;
    s/\{\{PURPOSE\}\}/$ENV{BRAIN_PURPOSE}/g;
    s/\{\{CREATED\}\}/$ENV{BRAIN_CREATED}/g;
    s/\{\{TEMPLATE_REF\}\}/$ENV{BRAIN_TEMPLATE_REF}/g;
    s/\{\{PROFILES\}\}/$ENV{BRAIN_PROFILES}/g;
  ' "$file"
done < <(find "$staging" -type f -name '*.md' -print0)

mkdir -p "$dest"
cp -R "$staging/." "$dest/"
git -C "$dest" init -q
git -C "$dest" symbolic-ref HEAD refs/heads/main

bash "$dest/scripts/validate-brain.sh" >/dev/null
printf 'Created brain "%s" at %s\n' "$name" "$dest"
printf 'Profiles: %s. Template: %s.\n' "$profile_list" "$template_ref"
