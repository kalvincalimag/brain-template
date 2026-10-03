# {{BRAIN_NAME}}

{{PURPOSE}}

This is a brain: a local, curated knowledge base that an agent reads at the start of a session and writes back to at the end. It holds reviewed facts, decisions, session summaries, plans, research, and deliverables. It never holds raw transcripts, credentials, or runtime state.

## Use it

Open a terminal in this directory and start your AI agent there, for example `claude` for Claude Code or `codex` for OpenAI Codex. The agent reads `AGENTS.md` and the memory index `memory/MEMORY.md` first. Ask for what you need. When the work produced something worth keeping, the agent records it before it answers. Say "write back" to force that step.

The brain holds knowledge, not skills. Your agent's own skills and settings work here as they do anywhere else.

## Structure

- `memory/` holds durable knowledge and its index, `MEMORY.md`.
- `sessions/` holds curated summaries of meaningful work.
- `planning/` holds plans and decision records.
- `research/` holds sources and notes that are not yet trusted memory.
- `artifacts/` holds deliverables with provenance.
- `private/` holds sensitive values. Git ignores it.
- `templates/` holds the session and decision shapes.
- `scripts/` and `tests/` hold the structure check, `bash scripts/validate-brain.sh`.
