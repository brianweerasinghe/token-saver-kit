# Prompt: plan first, then build in a fresh session

Planning is verbose and exploratory. Building doesn't need that history.
Split them: plan in one session, save the plan to a file, and build in a new
session that reads only the file.

## Step 1: plan (Claude Code: Shift+Tab into plan mode · Codex: /plan)

---

I want to: [describe the change].

Plan it before writing any code:
- Read `docs/CODEMAP.md` first, then only the files you need.
- Write the plan to `plan.md` with: goal, files to change (with the reason
  for each), numbered steps small enough to test one at a time, how to verify
  each step, and open questions for me.
- Keep it under 60 lines. Don't edit any other file yet.

---

## Step 2: build (new session: /clear in Claude Code, or a new Codex chat)

---

Implement `plan.md` step by step. After each step, run the check listed for
it and tick the step off in `plan.md`. Stop and ask me if a step turns out to
be wrong instead of improvising a different design.

---
