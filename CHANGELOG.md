# Changelog

All notable changes to this project are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [1.0.0] - 2026-11-03

### Added

- First open-source release under the MIT License (previously sold as a paid download).
- `README.md`, `CONTRIBUTING.md`, `SECURITY.md`, issue templates and a pull request template.
- `tests/hooks.test.sh` and a GitHub Actions workflow that runs the tests and ShellCheck.

### Kit contents (checked against the Claude Code and Codex docs, October 2026)

- Lean `CLAUDE.md` and `AGENTS.md` templates.
- `claude-code/settings.json` with read limits and two hooks: `block-big-reads.sh` and `filter-test-output.sh`.
- `scout` and `test-runner` subagents on Haiku, and a `codebase-map` skill.
- Codex `config.toml` defaulting to `gpt-6-luna`, plus a `deep` profile.
- Prompts for a codebase map, plan-then-build and fresh-session handoff.
- Optional GLM Coding Plan routing example.

[Unreleased]: https://github.com/brianweerasinghe/token-saver-kit/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/brianweerasinghe/token-saver-kit/releases/tag/v1.0.0
