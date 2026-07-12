#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "$repo_root"

python3 <<'PY'
import json
import tomllib
from pathlib import Path

root = Path.cwd()

for path in sorted(root.rglob("*.json")):
    if ".git" not in path.parts:
        with path.open(encoding="utf-8") as source:
            json.load(source)

for path in sorted(root.rglob("*.toml")):
    if ".git" not in path.parts:
        with path.open("rb") as source:
            tomllib.load(source)
PY

for hook in hooks/*.sh; do
  sh -n "$hook"
done

hook=hooks/scout-nudge.sh
if [ ! -x "$hook" ]; then
  printf '%s\n' "$hook must be executable" >&2
  exit 1
fi

state_dir=$(mktemp -d "${TMPDIR:-/tmp}/token-lean-verify.XXXXXX")
trap 'rm -rf "$state_dir"' EXIT HUP INT TERM

run_hook() {
  TMPDIR=$state_dir
  export TMPDIR
  printf '%s\n' '{}' | "$repo_root/$hook"
}

read_number=1
while [ "$read_number" -le 3 ]; do
  output=$(run_hook)
  if [ -n "$output" ]; then
    printf 'scout nudge emitted on read %s: %s\n' "$read_number" "$output" >&2
    exit 1
  fi
  read_number=$((read_number + 1))
done

expected='{"decision": "block", "reason": "token-lean tripwire: that'"'"'s 4 consecutive file reads. If these reads are answering a question, stop and spawn a scout (Explore agent or the token-lean scout) to hand back a synthesis instead. If you'"'"'re reading files you are actively editing, continue — this nudge is advisory."}'
output=$(run_hook)
if [ "$output" != "$expected" ]; then
  printf 'unexpected scout nudge on read 4\nexpected: %s\nactual:   %s\n' "$expected" "$output" >&2
  exit 1
fi

printf '%s\n' 'verification passed: JSON, TOML, hooks, scout nudge, executable bit'
