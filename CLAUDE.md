# Claude Instructions

Read and follow `AGENTS.md` first. It is the canonical repository contract and takes precedence over this file.

## Claude-specific guidance

- Start with `memory/MEMORY.md`, then load only task-relevant files.
- Keep plans explicit for multi-step work and update them as evidence changes.
- Check `skills/` before creating a new repeatable process.
- Distinguish confirmed repository facts from inferences.
- Do not import context from another brain or from global agent memory without explicit user direction.
- Use the session and decision templates for durable writeback.
- Keep this file thin; shared rules belong in `AGENTS.md` so agent instructions do not drift.
