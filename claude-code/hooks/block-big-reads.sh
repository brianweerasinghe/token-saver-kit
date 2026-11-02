#!/usr/bin/env bash
# Token Saver Kit · PreToolUse hook for the Read tool.
# Blocks reading a whole file longer than MAX_LINES and tells Claude to
# search or read a line range instead. Reads that pass offset/limit go through.
# Needs jq.

MAX_LINES="${TOKEN_SAVER_MAX_LINES:-1500}"

input=$(cat)
file=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')
limit=$(printf '%s' "$input" | jq -r '.tool_input.limit // empty')

# Not a regular file, or Claude already asked for a range: allow.
if [[ -z "$file" || ! -f "$file" || -n "$limit" ]]; then
  echo '{}'
  exit 0
fi

lines=$(wc -l < "$file" | tr -d ' ')
if (( lines > MAX_LINES )); then
  reason="$file has $lines lines. Don't read the whole file: use Grep to find the relevant part, then Read with offset and limit (under $MAX_LINES lines)."
  jq -n --arg r "$reason" \
    '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny", permissionDecisionReason: $r}}'
else
  echo '{}'
fi
