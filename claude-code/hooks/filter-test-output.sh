#!/usr/bin/env bash
# Token Saver Kit · PreToolUse hook for Bash.
# When Claude runs a test command, rewrite it to show only failures, so a
# 2,000-line passing test log doesn't land in context.
# Adapted from the example in Anthropic's "Manage costs effectively" docs.
# Needs jq.

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')

# Test runners to filter. Add yours (e.g. "cargo test", "bun test").
if [[ "$cmd" =~ ^(npm\ test|npm\ run\ test|pnpm\ test|yarn\ test|npx\ vitest|npx\ jest|pytest|python\ -m\ pytest|go\ test) ]] \
   && [[ "$cmd" != *"|"* ]]; then
  # Keep failures plus a few lines of context, and always the exit code.
  # Works in bash and zsh (Claude Code runs commands in your login shell).
  filtered="{ $cmd 2>&1; echo \"TESTS_EXIT_CODE=\$?\"; } | grep -E -A 5 '(FAIL|ERROR|Error:|error:|failed|✗|●|TESTS_EXIT_CODE)' | tail -n 150"
  printf '%s' "$input" | jq --arg c "$filtered" \
    '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "allow", updatedInput: (.tool_input + {command: $c})}}'
else
  echo '{}'
fi
