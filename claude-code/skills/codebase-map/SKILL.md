---
name: codebase-map
description: Orient in this codebase cheaply. Use before exploring, searching widely, or answering questions about project structure, where code lives, entry points or conventions.
---

# Codebase map

Before searching the codebase, read `docs/CODEMAP.md`. It describes the
folders, entry points, data flow and conventions, so you don't have to
rediscover them with many Glob, Grep and Read calls.

1. Read `docs/CODEMAP.md`.
2. Use it to go straight to the right folder or file. Search only inside that
   area.
3. If the map is wrong or missing something you needed, finish the task, then
   tell the user which line of the map to update. Don't rewrite the map unless
   asked.

If `docs/CODEMAP.md` doesn't exist, tell the user to create it with the
"make codemap" prompt from the Token Saver Kit, then continue with a
normal, focused search.
