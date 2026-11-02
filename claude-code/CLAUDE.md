# [Project name]

<!-- Token Saver Kit template. This file loads into EVERY session, so every
line costs tokens on every message. Keep it under ~100 lines. Delete these
comments and any section you don't need. -->

[One sentence: what this project is and who uses it.]

## Map

Read `docs/CODEMAP.md` before searching the codebase. It lists the folders,
entry points and conventions. If it's out of date, say so instead of
re-exploring everything.

## Commands

- Install: `[pnpm install]`
- Dev: `[pnpm dev]`
- Test one file: `[pnpm test path/to/file.test.ts]`
- Typecheck / lint: `[pnpm tsc --noEmit]` / `[pnpm lint]`

## Rules

- [The 3–7 things you've had to correct more than once. Examples:]
- [Use the existing `lib/api.ts` client; don't add fetch wrappers.]
- [Tests live next to the file they test.]

## Working style

- Make the smallest change that solves the task. Don't refactor unrelated code.
- Search with Grep or read a line range before opening a whole large file.
- Run only the tests for the files you changed unless asked for the full suite.
- For a multi-step task, write the plan to `plan.md` first and wait for approval.

## Don't read

Build output, generated files and vendored code: `[dist/, .next/, coverage/, *.lock, vendor/]`.

# Compact instructions

When compacting, keep: the current task, files changed, decisions made, and
failing test output. Drop: exploration that led nowhere and full file dumps.
