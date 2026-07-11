#!/bin/sh
# token-lean tripwire (practice #1): after 4 consecutive Read calls inside a
# 90-second window, nudge the orchestrator to spawn a scout instead.
# Advisory only — it never blocks the read (PostToolUse runs after the tool).

input=$(cat)
sid=$(echo "$input" | jq -r '.session_id // "default"' 2>/dev/null) || sid="default"
state="${TMPDIR:-/tmp}/token-lean-reads-${sid}"

now=$(date +%s)
last=0
count=0
[ -f "$state" ] && read -r last count < "$state" 2>/dev/null

# a 90s gap between reads resets the streak
[ $((now - last)) -gt 90 ] && count=0
count=$((count + 1))
printf '%s %s\n' "$now" "$count" > "$state"

if [ $((count % 4)) -eq 0 ]; then
  cat <<'EOF'
{"decision": "block", "reason": "token-lean tripwire: that's 4 consecutive file reads. If these reads are answering a question, stop and spawn a scout (Explore agent or the token-lean scout) to hand back a synthesis instead. If you're reading files you are actively editing, continue — this nudge is advisory."}
EOF
fi
exit 0
