# Claude instructions

@AGENTS.md

@memory/MEMORY.md

## Claude-specific guidance

- The two imports above load `AGENTS.md` and `memory/MEMORY.md` at launch. Load anything else only when the task needs it.
- This brain's `memory/` directory is the only memory store for this work. Claude Code's auto memory is off in `.claude/settings.json`, so write durable knowledge here.
- Keep this file thin. Shared rules belong in `AGENTS.md`.
