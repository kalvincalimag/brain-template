# {{BRAIN_NAME}}

{{PURPOSE}}

This is a brain: a local, curated knowledge base that an agent reads at the start of a session and writes back to at the end. It holds reviewed facts, decisions, session summaries, plans, research, and deliverables. It never holds raw transcripts, credentials, or runtime state.

## Use it

```bash
cd <this directory>
claude
```

Claude loads `AGENTS.md` and `memory/MEMORY.md` on launch. Ask for what you need. When the work produced something worth keeping, the agent records it before it answers. Type `/writeback` to force that step.

## Structure

- `memory/` holds durable knowledge and its index, `MEMORY.md`.
- `sessions/` holds curated summaries of meaningful work.
- `planning/` holds plans and decision records.
- `research/` holds sources and notes that are not yet trusted memory.
- `artifacts/` holds deliverables with provenance.
- `skills/` holds repeatable procedures for this brain.
- `private/` holds sensitive values. Git ignores it.
- `templates/` holds the session and decision shapes.
- `scripts/` and `tests/` hold the structure check, `bash scripts/validate-brain.sh`.
