# Token Saver Kit for Claude Code and Codex

Hit your usage limit less often. Ready-made settings, templates, hooks and subagents that stop Claude Code and Codex burning tokens on stale context, giant file reads, noisy test output and an expensive model doing simple work. About 10 minutes to set up.

Free and open source under the [MIT License](LICENSE). Made by [AI Eating The World](https://www.aieatingtheworld.com).

[![Checks](https://github.com/brianweerasinghe/token-saver-kit/actions/workflows/checks.yml/badge.svg)](https://github.com/brianweerasinghe/token-saver-kit/actions/workflows/checks.yml)

## Where your tokens go

| Leak | The fix in this kit |
|---|---|
| A CLAUDE.md or AGENTS.md hundreds of lines long, re-sent with every message | Lean templates under 100 lines; long instructions move into skills that load only when needed |
| The agent opens lockfiles, build output, `node_modules` and 5,000-line files in full | `settings.json` that blocks those reads, plus a hook that turns huge-file reads into a search or a line range |
| One test run dumps thousands of passing-test lines into context | A hook that trims test output to failures, and a cheap Haiku test-runner subagent |
| Every session re-explores the whole repo | A codebase-map prompt and skill, so the agent reads one short map first |
| The top model does everything, including renaming a variable | A Codex config that defaults to `gpt-6-luna` with a `deep` profile, and model guidance for Claude Code |

## Quick start

```bash
git clone https://github.com/brianweerasinghe/token-saver-kit.git
cd token-saver-kit
```

Then follow [START-HERE.md](START-HERE.md). It walks through the setup in order of impact, with a checklist. [GUIDE.md](GUIDE.md) explains why each step works, with sources, and when to skip it.

No Git? [Download the ZIP](https://github.com/brianweerasinghe/token-saver-kit/archive/refs/heads/main.zip).

## What's inside

| Path | What it is |
|---|---|
| `START-HERE.md` | The 10-minute setup, in order of impact, with a checklist |
| `GUIDE.md` | Why each step works, with sources, and when not to use it |
| `claude-code/CLAUDE.md` | Lean memory template (fill in the blanks) |
| `claude-code/settings.json` | Blocks reads of dependencies, build output, lockfiles and `.env` files, and wires up the hooks |
| `claude-code/hooks/block-big-reads.sh` | Stops whole-file reads of files over 1,500 lines |
| `claude-code/hooks/filter-test-output.sh` | Trims test-runner output to failures only |
| `claude-code/agents/scout.md` | Read-only explorer on Haiku that returns a short summary |
| `claude-code/agents/test-runner.md` | Runs your tests on Haiku and returns only the failures |
| `claude-code/skills/codebase-map/` | Makes Claude read your map before it searches |
| `claude-code/glm-settings.example.json` | Optional: route Claude Code to the cheaper GLM Coding Plan |
| `codex/AGENTS.md` | Lean memory template for Codex |
| `codex/config.toml` | Defaults to `gpt-6-luna`, OpenAI's most efficient model |
| `codex/deep.config.toml` | A `deep` profile for the hard tasks |
| `prompts/` | Make a codebase map, plan-then-build, and fresh-session handoff |
| `tests/hooks.test.sh` | Checks for the two hooks |

## Requirements

- Claude Code and/or the Codex CLI.
- The hooks need `bash` and [`jq`](https://jqlang.org/). On Windows, run them in WSL or Git Bash, or skip them. Everything else is plain text and works everywhere.

## Safety

Every file is plain text you can read before you use it. The hooks only block a read or shorten a command's output; they make no network calls and send nothing anywhere. Nothing is installed globally unless you copy the Codex config to `~/.codex`.

Savings depend on your projects and habits, so we don't promise a number. Measure before and after with `/usage` and `/context` (Claude Code) or `/status` (Codex).

## Contributing

Bug reports, fixes and better settings are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md) first. Security issues: see [SECURITY.md](SECURITY.md).

## Credits

The kit points to free open-source tools such as ccusage, claude-code-router, Graphify, Context7 and markitdown, linked rather than bundled. See [CREDITS.md](CREDITS.md). `filter-test-output.sh` is adapted from the example in Anthropic's "Manage costs effectively" docs.

More free guides on Claude Code and Codex: [aieatingtheworld.com/guides](https://www.aieatingtheworld.com/guides).
