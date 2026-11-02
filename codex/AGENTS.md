# [Project name]

<!-- Token Saver Kit template. Codex loads this file at the start of every
session, so every line costs tokens every time. Keep it under ~100 lines and
delete these comments. -->

[One sentence: what this project is and who uses it.]

## Map

Read `docs/CODEMAP.md` before searching the repo. It lists folders, entry
points and conventions. If it's wrong, say which line to fix instead of
re-exploring everything.

## Commands

- Install: `[pnpm install]`
- Test one file: `[pnpm test path/to/file.test.ts]`
- Typecheck / lint: `[pnpm tsc --noEmit]` / `[pnpm lint]`

## Rules

- [The 3–7 things you've had to correct more than once.]

## Working style

- Make the smallest change that solves the task.
- Search first; open only the files and line ranges you need.
- Run only the tests for changed files unless asked for the full suite.
- For multi-step work, write the plan to `plan.md` and wait for approval.
- Don't read build output, generated files, lockfiles or vendored code:
  `[dist/, .next/, coverage/, *.lock, vendor/]`.
- Keep command output short: pipe long output through `tail` or `grep`.
