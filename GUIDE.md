# Token Saver Kit: the guide

Why each step in `START-HERE.md` works, what it costs you, and when to skip it.
Sources are at the end. Numbers from third parties are labeled as theirs; we
haven't reproduced them.

## Where tokens actually go

An agent session isn't one prompt. Every turn re-sends the conversation so far,
plus every file it read and every tool result it got back. Anthropic's docs
put it plainly: Claude Code "sends your full conversation with every request,"
so a one-line question late in an all-day session still pays for the whole
history (prompt caching makes re-reads cheaper, not free).

So the biggest wins come from four places:

1. **History:** how long the session has run.
2. **Standing context:** what loads every time (CLAUDE.md, AGENTS.md, MCP servers).
3. **Reads and tool output:** what the agent pulls in while working.
4. **Model and reasoning:** what each token costs.

The kit hits all four.

## 1. Measure first

- **Claude Code `/usage`** shows plan usage and, on Pro and Max, a breakdown by
  skills, subagents, plugins and MCP servers, plus flags like "long context"
  or "cache misses" when they cause 10% or more of recent usage.
- **`/context`** shows what's filling the context window right now.
- **Codex `/status`** shows your allowance and reset time.
- **`npx ccusage`** (free, open source) reads Claude Code's local logs and
  summarizes usage by day and session.

## 2. Stop dragging old context

- **`/clear` between unrelated tasks.** Anthropic's first recommendation.
  `/rename` the session first if you might come back to it (`/resume`).
- **Fresh session every 15–20 messages.** One benchmark found message 30 of a
  session cost about 31 times message 1, from re-sending accumulated context
  (DEV Community). The handoff prompt carries over what matters in about 25 lines.
- **`/compact` with instructions** keeps what you name, but compacting reads
  the whole conversation, so it's a large request itself. When you don't need
  continuity, `/clear` is free.
- **Coming back after a break?** The prompt cache expires (an hour on a
  subscription, five minutes on an API key by default), and the first message
  after that re-processes everything. Start fresh with a handoff note instead.

## 3. Match the model to the job

- **Claude Code:** Anthropic says Sonnet "handles most coding tasks well and
  costs less than Opus," and to reserve Opus for complex architecture and
  multi-step reasoning. Use `/model` to switch and `/effort` to lower
  reasoning on simple tasks: thinking tokens are billed as output.
- **Codex:** OpenAI describes `gpt-6-luna` as its "most efficient model," for
  focused, high-volume work. `gpt-6.1-sol` offers near top-tier performance at
  lower cost than `gpt-6-astra`. The kit defaults to Luna at medium reasoning
  and gives you a `deep` profile (Sol, high) for the hard parts.
- **Older Codex guides** recommend `gpt-5.6-luna`. Those models are being
  phased out, so update your config.

## 4. Lean memory files

CLAUDE.md and AGENTS.md load at the start of every session. Anthropic's advice:
keep CLAUDE.md under 200 lines, and move workflow-specific instructions (PR
reviews, migrations) into **skills**, which load only when used. The templates
aim for about 100 lines, so there's room to grow.

Codex has a `project_doc_max_bytes` setting that caps how much of AGENTS.md
it reads. If your file is huge, the end may be silently cut off, which is
one more reason to keep it short.

## 5. Block expensive reads

- **Deny rules** in `settings.json` stop Claude reading dependency folders,
  build output, lockfiles and `.env` files. Lockfiles alone can be tens of
  thousands of lines. Adjust the list to your stack; the syntax is
  `Read(./path/**)`.
- **`block-big-reads.sh`** stops whole-file reads of files over 1,500 lines
  and tells Claude to Grep, then read a line range. Change the limit with the
  `TOKEN_SAVER_MAX_LINES` environment variable. Reads that already pass
  `offset`/`limit` go through.

## 6. Shrink tool output

`filter-test-output.sh` is adapted from the example in Anthropic's cost docs.
When Claude runs a recognized test command (npm/pnpm/yarn test, vitest, jest,
pytest, go test), the hook rewrites it to keep only failures, a few lines of
context and the exit code. A passing run of a big suite drops from thousands
of lines to one.

**Know this before you install it:**
- Like Anthropic's example, the hook marks the rewritten test command as
  approved, so Claude Code won't ask before running it. Remove the Bash block
  from `settings.json` if you want to approve test runs yourself.
- Commands that already contain a pipe are left alone.
- If you need the full log for one run, ask Claude to run the tests with
  output saved to a file, then grep it.

**Codex** has no hook for this in the kit. The AGENTS.md template tells it to
pipe long output through `tail` or `grep`. Codex also has a
`tool_output_token_limit` setting if you want a hard cap.

## 7. A codebase map

Every new session starts blind and explores: Glob, Grep, Read, repeat.
`docs/CODEMAP.md` is a one-time, under-150-line summary that both agents read
first. The `codebase-map` skill makes Claude Code reach for it automatically
before searching. Anthropic's docs suggest this exact pattern (a
"codebase-overview" skill).

**Bigger repos: Graphify.** Graphify builds a knowledge graph of your code
and hooks into Claude Code so searches query the graph. Community material
reported large savings on one 52-file corpus, but on small projects its
per-query overhead can cost more than a direct read (discussed in Graphify's
own issue tracker). Rule of thumb: worth trying at 20+ files, or when you see
4+ searches to answer one question. Free, open source; install from its repo (see CREDITS.md).

## 8. Cheap subagents for noisy jobs

Subagents run in their own context window, and only their summary comes back
to your session. Anthropic recommends delegating verbose work (running tests,
fetching docs, processing logs) this way, and setting `model: haiku` for
simple subagent tasks. The kit's `scout` (read-only search) and `test-runner`
both run on Haiku and are told to report in under 30 lines.

They still use your plan, just less of it per token. Don't use them for tiny
lookups the main session could do in one call.

## 9. Plan first

Claude Code (Shift+Tab) and Codex (`/plan`) both have a plan mode, and
Anthropic recommends it for complex tasks. Plan mode explores and proposes
without editing, so a wrong direction costs a
plan, not a rewrite. Saving the plan to `plan.md` and building in a fresh
session means the build doesn't carry the planning chatter.

## 10. Trim MCP servers

Claude Code loads MCP tool names and server instructions up front, and full
tool definitions only when used. Anthropic still recommends turning off
servers you don't use (`/mcp`) and preferring CLI tools like `gh` or `aws`
where they exist, because they add no per-tool listing.

## Optional: a cheaper provider

Claude Code can talk to any Anthropic-compatible endpoint. Z.ai's GLM Coding
Plan documents a setup that maps Claude Code's model slots to GLM models
(`glm-settings.example.json`, copied from their docs on October 9, 2026). To
use it, put the `env` block in `~/.claude/settings.json` with your Z.ai key.

Trade-offs:
- It's a different model, with different strengths, so test it on your real work.
- Your code goes to Z.ai, under their terms and data policy. Check both
  before using it on a client or work repo.
- To switch back, remove the `env` block.

For mixing providers per task, see claude-code-router in CREDITS.md.

## What doesn't help much

- **"Talk like a caveman" style skills.** Their own benchmark claims about 65%
  fewer output tokens. JetBrains' independent test on 82 paired agent tasks
  found about 8.5% fewer output tokens and about 10% lower cost at best,
  because code and tool output dominate agent sessions. Harmless, but small.
- **Converting every PDF to Markdown.** Big savings on scanned or messy
  PDFs, but independent tests put typical documents at around 30–50%, and a
  clean text PDF can come out about even. Not the 90% you'll see quoted.
  Use a local converter (markitdown, docling) for anything sensitive.

## Sources

- Anthropic, "Manage costs effectively" (Claude Code docs), code.claude.com/docs/en/costs. Checked Oct 9, 2026.
- Anthropic, Claude Code docs: settings, hooks, subagents. code.claude.com/docs. Checked Oct 9, 2026.
- OpenAI, Codex config reference and models pages, learn.chatgpt.com/docs. Checked Oct 9, 2026.
- Z.ai, "Claude Code" setup for the GLM Coding Plan, docs.z.ai/devpack/tool/claude. Checked Oct 9, 2026.
- DEV Community, "Token Optimisation 101" (cost by message 30 ≈ 31× message 1).
- JetBrains Blog, "Speaking to AI Agents like Cavemen Saves 65% of Tokens. We Test."
- AI Eating The World, "How to Fix Codex Usage Limits" and "How to Save Tokens in Claude Code Using Graphify" (aieatingtheworld.com/guides).
