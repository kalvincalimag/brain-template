#!/usr/bin/env bash
# Builds brains from this template and checks the results.
# Run from anywhere: bash tests/test-template.sh
set -uo pipefail

template_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
new_brain="$template_root/scripts/new-brain.sh"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

passes=0
failures=0
pass() { passes=$((passes + 1)); }
fail() { failures=$((failures + 1)); printf 'FAIL: %s\n' "$1" >&2; }
check() { if "${@:2}" >/dev/null 2>&1; then pass; else fail "$1"; fi; }
check_not() { if "${@:2}" >/dev/null 2>&1; then fail "$1"; else pass; fi; }
# Passes only when the command exits non-zero and its output matches the pattern.
check_refuses() {
  local label="$1" pattern="$2" output
  if output="$("${@:3}" 2>&1)"; then fail "$label (exited 0)"; return; fi
  if grep -qiE -- "$pattern" <<<"$output"; then pass; else fail "$label (no message matching: $pattern)"; fi
}

placeholder_pattern='\{\{(BRAIN_NAME|PURPOSE|CREATED|TEMPLATE_REF|PROFILES)\}\}'
profiles=()
for dir in "$template_root"/profiles/*/; do profiles+=("$(basename "$dir")"); done

# Every profile has the files the instantiator and the skill rely on.
for p in "${profiles[@]}"; do
  for f in PROFILE.md agents-rules.md memory-index.md "files/tests/required/$p.txt"; do
    check "profile $p is missing $f" test -f "$template_root/profiles/$p/$f"
  done
done

# Scripts must run on macOS (bash 3.2, BSD tools) as well as Linux and Git Bash on Windows.
non_portable='declare -A|mapfile|readarray|local -n|\$\{[A-Za-z_]+(,,|\^\^)\}|sed -i|grep -[a-zA-Z]*P|readlink -f|date -d'
check_not "a script uses a bash-4-only feature or a GNU-only flag" \
  grep -nE -- "$non_portable" "$template_root/scripts/new-brain.sh" "$template_root/core/scripts/validate-brain.sh" "$template_root/core/tests/validate-brain-structure.sh"

# Skills are out of scope for brains, so the template ships none.
check "template contains a skill" test -z "$(find "$template_root/core" "$template_root/profiles" -name SKILL.md)"
check_not "core still has a skills/ folder" test -e "$template_root/core/skills"

# The template never carries content from the brain it was derived from.
check_not "template contains source-brain content" \
  grep -rEil --exclude-dir=.git 'source-brain-name' "$template_root/core" "$template_root/profiles"

assert_instance() {
  local label="$1" dest="$2" purpose="$3"
  check "$label: instance validator fails" bash "$dest/scripts/validate-brain.sh"
  check "$label: purpose text not in AGENTS.md" grep -qF -- "$purpose" "$dest/AGENTS.md"
  check_not "$label: placeholder left behind" grep -rEq --exclude-dir=.git "$placeholder_pattern" "$dest"
  check_not "$label: composition marker left behind" grep -rq --exclude-dir=.git '<!-- PROFILE' "$dest"
  check_not "$label: TEMPLATE.md leaked into brain" test -e "$dest/TEMPLATE.md"
  check_not "$label: profiles/ leaked into brain" test -e "$dest/profiles"
  check "$label: brain is not a git repository" test -d "$dest/.git"
  check "$label: brain has a git remote" test -z "$(git -C "$dest" remote)"
  check "$label: private/ is not ignored" git -C "$dest" check-ignore -q private/full-ids.md
  check_not "$label: private/README.md is ignored" git -C "$dest" check-ignore -q private/README.md
}

# Core only, with a purpose full of characters that break naive substitution.
purpose='Track a/b & c \1 $HOME "quoted" things'
dest="$work/core-only"
check "core-only: new-brain.sh failed" bash "$new_brain" --dest "$dest" --name "Test Brain" --purpose "$purpose"
assert_instance core-only "$dest" "$purpose"
check "core-only: origin does not say 'Profiles: none'" grep -q 'Profiles: none' "$dest/memory/overview.md"
check "core-only: brain name not in README" grep -q '^# Test Brain$' "$dest/README.md"

# Each profile alone, then all profiles together.
for p in "${profiles[@]}" all; do
  dest="$work/profile-$p"
  args=()
  if [[ "$p" == all ]]; then
    for q in "${profiles[@]}"; do args+=(--profile "$q"); done
    selected=("${profiles[@]}")
  else
    args=(--profile "$p")
    selected=("$p")
  fi
  check "$p: new-brain.sh failed" bash "$new_brain" --dest "$dest" --name "Brain $p" --purpose "Purpose $p" "${args[@]}"
  assert_instance "$p" "$dest" "Purpose $p"
  for q in "${selected[@]}"; do
    check "$p: required list for $q missing" test -f "$dest/tests/required/$q.txt"
    heading="$(grep -m1 '^## ' "$template_root/profiles/$q/agents-rules.md")"
    check "$p: AGENTS.md lacks rules from $q" grep -qxF -- "$heading" "$dest/AGENTS.md"
    while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      check "$p: MEMORY.md lacks navigation line from $q" grep -qxF -- "$line" "$dest/memory/MEMORY.md"
    done < "$template_root/profiles/$q/memory-index.md"
    check "$p: origin does not list $q" grep -q "Profiles: .*$q" "$dest/memory/overview.md"
  done
done

# Real paths and names have spaces, quotes, and ampersands.
dest="$work/with space/Someone's brain"
odd_name="Someone's \"Admin\" Brain & Co"
check "spaced path: new-brain.sh failed" bash "$new_brain" --dest "$dest" --name "$odd_name" --purpose "Purpose" --profile life-admin
check "spaced path: validator fails" bash "$dest/scripts/validate-brain.sh"
check "spaced path: odd name not in README" grep -qxF "# $odd_name" "$dest/README.md"

# A profile named twice is applied once.
check "repeated profile: new-brain.sh failed" bash "$new_brain" --dest "$work/repeat" --name X --purpose Y --profile life-admin --profile life-admin
check "repeated profile: origin lists it twice" grep -q 'Profiles: life-admin\.$' "$work/repeat/memory/overview.md"

# The new brain lets the agent run its own check and read git state without prompts.
check "settings do not allow the validator" grep -qF '"Bash(bash scripts/validate-brain.sh)"' "$work/core-only/.claude/settings.json"

# The instantiator refuses bad input.
check_refuses "accepted a non-empty destination" "not empty" bash "$new_brain" --dest "$work/core-only" --name X --purpose Y
check_refuses "accepted an unknown profile" "unknown profile" bash "$new_brain" --dest "$work/unknown" --name X --purpose Y --profile no-such-profile
check_refuses "accepted a missing purpose" "--purpose is required" bash "$new_brain" --dest "$work/no-purpose" --name X

# Two profiles that write the same path must collide loudly.
clash_template="$work/clash-template"
cp -R "$template_root/." "$clash_template"
rm -rf "$clash_template/.git"
mkdir -p "$clash_template/profiles/clash/files/memory" "$clash_template/profiles/clash/files/tests/required"
for f in PROFILE.md agents-rules.md memory-index.md; do printf '## Clash\n' > "$clash_template/profiles/clash/$f"; done
printf '' > "$clash_template/profiles/clash/files/tests/required/clash.txt"
printf '# Clash\n' > "$clash_template/profiles/clash/files/memory/overview.md"
check_refuses "a profile overwrote a core file" "collision" bash "$clash_template/scripts/new-brain.sh" --dest "$work/clash" --name X --purpose Y --profile clash

# The instance validator can fail. Each case breaks one rule in a fresh copy.
broken() {
  local name="$1"
  cp -R "$work/core-only" "$work/broken-$name"
  printf '%s' "$work/broken-$name"
}
b="$(broken missing-file)"; rm "$b/memory/decisions.md"
check_refuses "validator passed with a required file missing" "missing required file: memory/decisions.md" bash "$b/scripts/validate-brain.sh"
b="$(broken placeholder)"; printf '{{PURPOSE}}\n' >> "$b/memory/overview.md"
check_refuses "validator passed with a placeholder left" "unfilled placeholder" bash "$b/scripts/validate-brain.sh"
b="$(broken link)"; printf -- '- [Gone](gone.md) - missing\n' >> "$b/memory/MEMORY.md"
check_refuses "validator passed with a broken MEMORY.md link" "broken link.*gone.md" bash "$b/scripts/validate-brain.sh"
b="$(broken long-index)"; for i in $(seq 1 210); do printf 'line %s\n' "$i" >> "$b/memory/MEMORY.md"; done
check_refuses "validator passed with MEMORY.md over 200 lines" "200-line limit" bash "$b/scripts/validate-brain.sh"
b="$(broken private)"; printf 'secret\n' > "$b/private/ids.md"; git -C "$b" add -f private/ids.md
check_refuses "validator passed with a tracked file in private/" "private/ids.md" bash "$b/scripts/validate-brain.sh"
b="$(broken skill)"; mkdir -p "$b/.claude/skills/helper"; printf -- '---\nname: helper\n---\n' > "$b/.claude/skills/helper/SKILL.md"
check_refuses "validator passed with a skill inside the brain" "skills are out of scope.*helper/SKILL.md" bash "$b/scripts/validate-brain.sh"

printf '%s checks passed, %s failed\n' "$passes" "$failures"
((failures == 0))
