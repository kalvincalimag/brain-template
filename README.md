# Brain Template

Reusable starter for a curated project knowledge base ("brain"). Copy this repo, fill in the memory stubs for your project, and keep durable knowledge separate from agent runtime state.

This is not an application source repository. It stores reviewed facts, decisions, session handoffs, plans, research, and intentional artifacts.

## Structure

- `memory/` — durable, reviewed project knowledge and its compact index (`MEMORY.md`)
- `sessions/` — curated chronological summaries of meaningful work
- `planning/` — active plans and archived planning / decision records
- `research/` — source tracking, notes, and synthesis (not automatic truth)
- `artifacts/` — intentional deliverables with provenance
- `skills/` — project-local repeatable agent workflows
- `templates/` — content-free session and decision templates
- `scripts/` and `tests/` — brain-structure validation
- `migrations/` — optional notes when transferring context between tools or accounts

## Runtime separation

Agent runtimes (for example Codex under `~/.codex`) keep raw sessions, attachments, caches, and credentials outside this repo. A local `.codex/` directory, raw rollout JSONL, databases, credentials, caches, and transcripts must remain uncommitted.

## Working loop

1. Read `AGENTS.md` and `memory/MEMORY.md`.
2. Load only the material relevant to the current task.
3. Keep research and proposals distinct from confirmed durable knowledge.
4. Record meaningful work as a curated session summary.
5. Promote stable information to topical memory and update the compact index when needed.
6. Run `bash scripts/validate-brain.sh` before delivery.

## Getting started

1. Fill in `memory/overview.md`, `memory/project.md`, `memory/product.md`, `memory/decisions.md`, and `memory/team-onboarding.md` for your project.
2. Keep `memory/MEMORY.md` as a short navigation index (under 200 lines).
3. Add session summaries under `sessions/YYYY/MM/` using `templates/session-summary.md`.
4. Record decisions with `templates/decision-record.md` when they become durable.
