# Claude Code adapter

@AGENTS.md

@memory/MEMORY.md

## Claude-specific guidance

- The two imports above load `AGENTS.md` and `memory/MEMORY.md` at launch. Load anything else only when the task needs it.
- Claude Code's auto memory is off in `.claude/settings.json`, so durable knowledge goes into this brain's `memory/`, as `AGENTS.md` requires.
- Keep this file thin. Shared rules belong in `AGENTS.md`.
