#!/usr/bin/env bash
# Checks for the two Claude Code hooks. Run: bash tests/hooks.test.sh
# Needs jq.
set -u

root="$(cd "$(dirname "$0")/.." && pwd)"
hooks="$root/claude-code/hooks"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

fails=0
check() {
  local name="$1" expected="$2" actual="$3"
  if [[ "$actual" == "$expected" ]]; then
    echo "ok   $name"
  else
    echo "FAIL $name: expected '$expected', got '$actual'"
    fails=$((fails + 1))
  fi
}

# block-big-reads.sh
seq 1 2000 > "$tmp/big.txt"
seq 1 10 > "$tmp/small.txt"

read_hook() { printf '%s' "$1" | "$hooks/block-big-reads.sh"; }

out=$(read_hook "{\"tool_input\":{\"file_path\":\"$tmp/big.txt\"}}")
check "big file is denied" "deny" "$(printf '%s' "$out" | jq -r '.hookSpecificOutput.permissionDecision')"

out=$(read_hook "{\"tool_input\":{\"file_path\":\"$tmp/big.txt\",\"offset\":1,\"limit\":100}}")
check "big file with a line range is allowed" "{}" "$out"

out=$(read_hook "{\"tool_input\":{\"file_path\":\"$tmp/small.txt\"}}")
check "small file is allowed" "{}" "$out"

out=$(read_hook "{\"tool_input\":{\"file_path\":\"$tmp/missing.txt\"}}")
check "missing file is allowed" "{}" "$out"

out=$(printf '%s' "{\"tool_input\":{\"file_path\":\"$tmp/big.txt\"}}" | TOKEN_SAVER_MAX_LINES=5000 "$hooks/block-big-reads.sh")
check "TOKEN_SAVER_MAX_LINES raises the limit" "{}" "$out"

# filter-test-output.sh
bash_hook() { printf '%s' "$1" | "$hooks/filter-test-output.sh"; }

out=$(bash_hook '{"tool_input":{"command":"npm test"}}')
check "test command is rewritten" "allow" "$(printf '%s' "$out" | jq -r '.hookSpecificOutput.permissionDecision')"
cmd=$(printf '%s' "$out" | jq -r '.hookSpecificOutput.updatedInput.command')
if [[ "$cmd" == *"TESTS_EXIT_CODE"* ]]; then kept="yes"; else kept="no"; fi
check "rewrite keeps the exit code" "yes" "$kept"

out=$(bash_hook '{"tool_input":{"command":"npm test | tee log.txt"}}')
check "piped test command is left alone" "{}" "$out"

out=$(bash_hook '{"tool_input":{"command":"ls -la"}}')
check "other commands are left alone" "{}" "$out"

# The rewritten command still runs and reports failures.
out=$(bash_hook '{"tool_input":{"command":"pytest"}}')
cmd=$(printf '%s' "$out" | jq -r '.hookSpecificOutput.updatedInput.command')
result=$(cd "$tmp" && bash -c "pytest() { echo 'test_a passed'; echo 'FAILED test_b'; return 1; }; $cmd")
if [[ "$result" == *"FAILED test_b"* && "$result" == *"TESTS_EXIT_CODE=1"* && "$result" != *"test_a passed"* ]]; then
  filtered="yes"
else
  filtered="no: $result"
fi
check "rewritten command shows only failures" "yes" "$filtered"

echo
if (( fails > 0 )); then
  echo "$fails check(s) failed"
  exit 1
fi
echo "All checks passed"
