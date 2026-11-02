# Contributing

Thanks for helping make the kit better. Small, focused changes are easiest to review.

## Good contributions

- A file that's broken, or a setting that no longer matches the current Claude Code or Codex docs.
- A test runner missing from `filter-test-output.sh`.
- A clearer step in `START-HERE.md` or `GUIDE.md`.

Please open an issue first for bigger changes, such as a new folder or a new tool, so we can agree on the approach before you write it.

## Rules for changes

1. **Cite the docs.** If a change depends on how Claude Code or Codex behaves, link the official page in the pull request and note the date you checked it.
2. **No network calls in hooks.** Hooks may read their input and the file system, and print JSON. They must not send data anywhere.
3. **No bundled third-party code.** Link to other projects in `CREDITS.md` instead.
4. **Keep the templates short.** `CLAUDE.md` and `AGENTS.md` should stay under about 100 lines.
5. **Don't promise savings.** Describe what a change removes, not a percentage.

## Checks

Run these before you open a pull request:

```bash
bash tests/hooks.test.sh
shellcheck claude-code/hooks/*.sh tests/*.sh
```

The tests need `bash` and `jq`. GitHub Actions runs the same checks on every pull request.

## Changelog

Add a line under "Unreleased" in `CHANGELOG.md` for any change users would notice.

By contributing, you agree that your contributions are licensed under the [MIT License](LICENSE).
