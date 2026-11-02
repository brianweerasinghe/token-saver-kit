# Token Saver Kit for Claude Code and Codex

Hit your usage limit less often. This kit is a set of settings, templates and habits that cut the tokens Claude Code and Codex burn on things that don't help you: stale context, heavy reads, noisy tool output and an expensive model doing cheap work.

Version 1.0.0 · October 2026 · Free and open source (MIT) · Made by [AI Eating The World](https://www.aieatingtheworld.com)
Checked against Claude Code and Codex docs as of October 9, 2026.

## What's in the box

| Folder | What it is |
|---|---|
| `START-HERE.md` | This file: the 10-minute setup, in order of impact |
| `GUIDE.md` | Why each step works, with sources, and when *not* to use it |
| `claude-code/` | `CLAUDE.md` template, `settings.json` with read limits and hooks, two cheap subagents, a codebase-map skill, a GLM routing example |
| `codex/` | `AGENTS.md` template, a lean `config.toml`, and a `deep` profile for hard tasks |
| `prompts/` | Copy-paste prompts: build a codebase map, plan-then-build, end-of-session handoff |
| `CREDITS.md` | Free open-source tools the kit points to (linked, not bundled) |
| `tests/` | Checks for the two hook scripts (`bash tests/hooks.test.sh`) |

## The 10-minute setup

Do these in order. The first four cost nothing and carry most of the savings.

### 1. See where your tokens go (1 minute)

- **Claude Code:** run `/usage` to see what counts against your plan, and `/context` to see what fills the context window right now.
- **Codex:** run `/status` in a session to see your allowance and reset time.
- **History:** `npx ccusage` (free, open source) summarizes past Claude Code usage by day.

Look for a CLAUDE.md that's hundreds of lines long, MCP servers you never use, or one giant session that has run all day.

### 2. Stop dragging old context (0 minutes, a habit)

Every message re-sends the whole conversation. A long session gets more expensive with every turn.

- Run `/clear` (Claude Code) or start a new chat (Codex) when you switch to an unrelated task.
- Start fresh every 15–20 messages on long tasks. Paste `prompts/handoff.md` first, so the new session gets a short summary instead of the whole history.
- If you'd rather compact, tell it what to keep: `/compact Focus on the failing test and the files we changed`.

### 3. Use the cheap model by default (2 minutes)

- **Claude Code:** keep Sonnet as your default (`/model`) and switch to Opus only for architecture or gnarly debugging. Lower `/effort` for simple edits.
- **Codex:** copy `codex/config.toml` to `~/.codex/config.toml`. It defaults to `gpt-6-luna`, OpenAI's most efficient model. For hard tasks, run `codex --profile deep` (copy `codex/deep.config.toml` next to it).

### 4. Put your memory files on a diet (5 minutes)

CLAUDE.md and AGENTS.md load into **every** session.

- Replace yours with `claude-code/CLAUDE.md` / `codex/AGENTS.md` and fill in the blanks. Keep each under about 100 lines (Anthropic's own ceiling is 200).
- Move long, task-specific instructions (release steps, migration checklists) into skills, which load only when needed.
- Rule of thumb: anything you've corrected twice goes in the file. Anything you need once a month doesn't.

### 5. Block expensive reads (2 minutes)

Merge `claude-code/settings.json` into your project's `.claude/settings.json`. It:

- denies reads of `node_modules`, build output, lockfiles and `.env` files,
- adds a hook that stops whole-file reads of files over 1,500 lines and points Claude to search or a line range instead,
- adds a hook that trims test-runner output to failures only (adapted from Anthropic's docs).

Copy `claude-code/hooks/` to `.claude/hooks/` in your project and run `chmod +x .claude/hooks/*.sh`. The hooks need `jq` (`brew install jq` or `apt install jq`).

### 6. Give the agent a map (10 minutes, once per project)

Agents re-explore your codebase every session. Pay for that once:

1. Paste `prompts/make-codemap.md` into a session. It writes `docs/CODEMAP.md`: the folders, entry points and conventions, in under 150 lines.
2. Copy `claude-code/skills/codebase-map/` to `.claude/skills/` so Claude reads the map before searching.
3. Codex: the AGENTS.md template already points to the map.

On a big repo (20+ files, or 4+ searches to answer one question), consider Graphify too. See `GUIDE.md`.

### 7. Send noisy jobs to cheap helpers (2 minutes)

Copy `claude-code/agents/` to `.claude/agents/`. You get:

- `scout`: a read-only explorer on Haiku that finds code and reports back a short summary,
- `test-runner`: runs your tests on Haiku and returns only the failures.

Their long output stays in their own context, and your main session gets a summary.

### 8. Plan before you build (a habit)

For anything multi-step, plan first: Shift+Tab into plan mode in Claude Code, or `/plan` in Codex. Save the plan to `plan.md` (see `prompts/plan-then-build.md`), then build in a fresh session that reads only the plan.

## Optional: route to a cheaper provider

If you still run out, you can point Claude Code at a cheaper Anthropic-compatible provider. `claude-code/glm-settings.example.json` shows the GLM Coding Plan setup from Z.ai's docs. Read `GUIDE.md` first: it's a different model, with its own terms and data policy.

## Checklist

- [ ] Checked `/usage` and `/context` (or `/status` in Codex)
- [ ] `/clear` between tasks; a fresh session every 15–20 messages
- [ ] Sonnet / `gpt-6-luna` as the default model
- [ ] CLAUDE.md / AGENTS.md under about 100 lines
- [ ] Read limits and hooks installed, `jq` installed
- [ ] `docs/CODEMAP.md` created and the skill installed
- [ ] `scout` and `test-runner` subagents installed
- [ ] Unused MCP servers turned off (`/mcp`)

Found a broken file or a better setting? [Open an issue](https://github.com/brianweerasinghe/token-saver-kit/issues) or send a pull request. See `CONTRIBUTING.md`.
