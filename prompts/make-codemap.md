# Prompt: build a codebase map (run once per project)

Paste this into Claude Code or Codex at the project root. It costs one
exploration session, then saves the agent from re-exploring in every future
session. Re-run it after big restructures.

---

Create `docs/CODEMAP.md`: a map of this codebase for AI coding agents, so
future sessions can skip exploring.

Rules:
- Under 150 lines. Dense bullet points, no prose paragraphs.
- Explore with Glob and Grep and the README; don't read every file. Skip
  dependencies, build output, generated files and lockfiles.
- Only write what you verified. Mark anything you're unsure about with "(?)".

Sections:
1. **What this is**: one or two lines.
2. **Stack**: language, framework, package manager, test runner.
3. **Folders**: each top-level folder (and important subfolders), one line
   each: what lives there.
4. **Entry points**: where requests, pages, CLI commands or jobs start.
5. **Key files**: the 10–20 files most tasks touch, one line each.
6. **Data flow**: how a typical request or action moves through the code,
   in 3–6 steps.
7. **Conventions**: naming, where tests go, how errors and config are handled.
8. **Commands**: install, dev, test one file, lint, typecheck.
9. **Gotchas**: things that surprise newcomers.

When done, tell me the line count and anything marked "(?)".
