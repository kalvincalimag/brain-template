# Brain Template Agent Instructions

## Scope and precedence

These instructions apply to the entire repository. Follow, in order:

1. Direct user instructions.
2. This `AGENTS.md`.
3. Task-relevant repository documentation and memory.

This repository is a standalone curated brain for one project. It does not inherit facts, memories, decisions, people, artifacts, or assumptions from any other brain. Do not read from or import another brain unless the user explicitly requests a scoped transfer. Treat transferred material as unverified source material until it is reviewed and deliberately incorporated.

`AGENTS.md` is the canonical agent contract. Model-specific files such as `CLAUDE.md` may add narrow guidance but must not duplicate or contradict this file.

## Repository purpose

This repository stores curated, durable project knowledge. It is not an application source repository and it is not a mirror of agent runtime state.

Keep authored knowledge in readable, reviewable Markdown. Do not commit raw agent transcripts, Codex rollout JSONL, SQLite state, caches, credentials, worktrees, attachments, or other application-managed data.

## Startup protocol

Before meaningful work:

1. Read `AGENTS.md` and any applicable model-specific instruction file.
2. Read `memory/MEMORY.md` as the compact navigation index.
3. Read only the memory, planning, research, session, or skill files relevant to the task.
4. Check `skills/` before inventing a repeatable workflow.
5. Inspect the working tree before changing files, and preserve unrelated user changes.

Do not load every memory or session by default. Use progressive disclosure to keep context relevant and reduce accidental propagation of stale information.

## Knowledge architecture

- `memory/` contains curated durable knowledge. `memory/MEMORY.md` is a short index, not a content dump, and must remain under 200 lines.
- `sessions/YYYY/MM/YYYY-MM-DD-<slug>.md` contains curated summaries of meaningful work, never raw transcripts.
- `planning/` contains active plans and archived planning records.
- `research/` contains source indexes, research notes, and synthesis that has not automatically become durable memory.
- `artifacts/YYYY/MM/YYYY-MM-DD-<slug>/` contains intentional project deliverables and their provenance, not transient agent attachments.
- `skills/<skill-name>/SKILL.md` contains repeatable project-local workflows. Optional skill resources belong beside the skill in `references/`, `scripts/`, `assets/`, or `agents/`.
- `templates/` contains reusable, content-free document shapes.
- `scripts/` and `tests/` contain repository-maintenance automation and its checks.
- `migrations/` is optional; use it only for reviewed transfer notes between tools or accounts.

Do not create a repository-local `.codex/` hierarchy. Global `~/.codex` data is runtime state and has a different lifecycle from this curated brain.

## Knowledge standards

- Separate confirmed facts from hypotheses, proposals, and open questions.
- Attach dates and provenance to facts whose accuracy may change over time.
- Prefer primary and current sources for external claims.
- Record decisions with context, alternatives, tradeoffs, and reversal conditions.
- Promote session material into durable memory only when it is stable, reusable, and still accurate.
- Update or supersede stale knowledge; do not silently preserve contradictions.
- Never store secrets, credentials, private keys, access tokens, unredacted sensitive data, or private data that is unnecessary for the project.

## Change workflow

For features, fixes, scripts, and validation logic, use test-driven development:

1. Add or update a test that expresses the intended behavior.
2. Run it and confirm that it fails for the expected reason.
3. Implement the smallest compliant change.
4. Run the focused test, then every available repository test and build check.
5. Refactor only while the checks remain green.

Documentation-only edits still require structural validation and a diff review. Multiple-file, architectural, dependency, schema, or production-configuration changes require explicit user approval. Do not change database schemas or production configuration without approval.

Use parallel agents only for independent work with non-overlapping ownership. For larger implementation efforts, isolate agents in separate worktrees and reconcile their output through an integration branch. Never assume a subagent result is correct without reviewing its files and verification evidence.

## Git and delivery

- Inspect status and the current branch before editing.
- Do not overwrite unrelated or pre-existing changes.
- Stage only files that belong to the approved task.
- Do not commit, push, open a pull request, merge, or deploy unless the user authorizes that outward action. There is no standing auto-push exception.
- Before an authorized push, run all repository tests and builds successfully and review the staged diff.
- Use concise commit messages. Use `mem: <description>` when a change only updates curated memory.

## Verification

Run the following minimum checks after changing this brain structure:

```bash
bash tests/validate-brain-structure.sh
bash scripts/validate-brain.sh
git diff --check
```

Also run any task-specific tests or builds introduced later. A successful build alone does not prove runtime behavior; use the strongest relevant verification available and state anything that remains unverified.

## Session writeback

After meaningful work, add a concise session summary using `templates/session-summary.md`. Include:

- context and outcome;
- work completed and files changed;
- decisions and their reasoning;
- commands and verification results;
- current state, blockers, risks, and next steps;
- durable knowledge that should be promoted, if any.

Session writeback is curated project history, not a transcript. Promote stable facts into the appropriate `memory/` file and update `memory/MEMORY.md` only when its navigation or active context changes. Keep uncertain items marked as uncertain, and flag questionable stale entries instead of deleting them without review.

Do not push or open a pull request after writeback unless the user explicitly authorizes that action.
