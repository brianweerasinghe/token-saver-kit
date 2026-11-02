# Prompt: hand off to a fresh session

Long sessions get more expensive every message, because the whole history is
re-sent each time. Every 15–20 messages, or when the agent starts repeating
itself, run this, start a new session, and paste the summary in.

## In the old session

---

We're moving to a fresh session. Write a handoff note I can paste into it,
under 25 lines:
- **Goal:** what we're doing, in one sentence.
- **Done:** what's finished (files changed, with one line each).
- **State:** what works, what's broken, and the last error if any.
- **Next:** the next 1–3 steps.
- **Decisions:** choices we made and why, so the next session doesn't
  revisit them.
- **Don't:** dead ends we already tried.

No code blocks unless a short snippet is essential.

---

## In the new session

Run `/clear` (Claude Code) or open a new chat (Codex), then paste:

---

Continuing from a previous session. Handoff note:

[paste the note]

Read only the files the note mentions. Then do the first "Next" step.

---
