# {{BRAIN_NAME}} agent instructions

## Scope and precedence

These instructions apply to this whole directory. Follow, in order:

1. Direct user instructions.
2. This `AGENTS.md`.
3. Task-relevant memory and documentation in this brain.

This brain is standalone. It does not inherit facts, decisions, people, or assumptions from any other brain, and it does not write to one. Do not read from or write to another brain unless the user asks for a scoped transfer. Treat transferred material as unverified source material until it is reviewed and deliberately promoted.

`AGENTS.md` is the canonical agent contract. Model-specific files such as `CLAUDE.md` may add narrow guidance but must not duplicate or contradict it.

## Purpose

{{PURPOSE}}

`memory/overview.md` holds the full scope. It says what this brain covers, what it does not, and which sources are authoritative.

## Startup protocol

Before meaningful work:

1. Read this file and any model-specific instruction file.
2. Read `memory/MEMORY.md`, the compact navigation index.
3. Run any startup checks in the profile rules below.
4. Read only the memory, planning, research, or session files the task needs.

Do not load every memory or session by default. Load what the task needs, so stale material does not leak into answers.

Before researching a question or asking the user for a fact, check whether this brain already records it. Search `memory/`, `research/`, `planning/`, and `sessions/`. Rediscovering what the brain already knows is the failure this brain exists to prevent.

## Knowledge architecture

- `memory/` holds curated durable knowledge. `memory/MEMORY.md` is a short index, not a content dump, and stays under 200 lines.
- `sessions/YYYY/MM/YYYY-MM-DD-<slug>.md` holds curated summaries of meaningful work, never raw transcripts.
- `planning/` holds active plans, dated decision records, and archived plans.
- `research/` holds sources, notes, and synthesis that has not yet become durable memory.
- `artifacts/YYYY/MM/YYYY-MM-DD-<slug>/` holds deliberate deliverables and their provenance.
- `private/` holds sensitive values the user chose to keep. Git ignores everything in it except its `README.md`.
- `templates/` holds content-free document shapes.
- `scripts/` and `tests/` hold this brain's structure checks.
- `.claude/settings.json` holds Claude Code settings for this brain.

A brain holds knowledge only. Skills are out of scope. Claude Code loads the user's installed skills in every session, including sessions here, so this brain never contains a skill. A repeatable procedure, such as how a payment is made, is knowledge. Record it in `memory/` with the date each step was last confirmed.

## Knowledge standards

- Separate confirmed facts from hypotheses, proposals, and open questions.
- Date every fact that can go stale, and record where it came from.
- Prefer primary, current sources for external claims, and link them.
- Record decisions with context, alternatives, tradeoffs, and reversal conditions.
- Promote material into `memory/` only when it is stable, reusable, and still accurate.
- When knowledge goes stale, update or supersede it. Do not leave contradictions in place.

## Sensitive data

- Never store passwords, PINs, one-time codes, recovery codes, private keys, or access tokens anywhere in this brain.
- Store the least identifying form that does the job. For an account or ID number, that is usually the last four digits.
- Store a full sensitive value only when the user asks, and only in `private/`. Other files refer to it by path, never by value.
- Do not repeat a full sensitive value in a reply unless the user asks for it.

## Git

- This brain is a local Git repository with no remote. Do not add a remote or push unless the user asks.
- Editing files here is reversible local work and needs no approval. Commit only when the user authorizes it.
- Check `git status` before editing, and preserve changes you did not make.
- Use concise commit messages. Use `mem: <description>` when a commit only changes curated memory.

## Verification

After every writeback or structural change, run `bash scripts/validate-brain.sh`. Once the brain has commits, also run `git diff --check`. State anything you could not verify.

## Session writeback

Writeback is how this brain remembers. Do it without being asked, before the final reply of any task that produced knowledge worth keeping. When the user says "write back", run the same steps on demand. Writeback only edits files in this brain and never commits, so a rule that gates commits or pushes does not block it.

1. Decide what is durable. That means facts about the subject, decisions, completed actions, sourced external rules, and open questions that will matter next time.
2. Promote each durable fact into the right `memory/` file. Record a decision under `planning/decisions/` from `templates/decision-record.md`, and index it in `memory/decisions.md`.
3. Write a session file, `sessions/YYYY/MM/YYYY-MM-DD-<slug>.md` from `templates/session-summary.md`, when the task did any of these: made or changed a decision, recorded a completed action, produced research or a deliverable, or changed more than one memory file. A single fact needs no session file.
4. In `memory/MEMORY.md`, link each new session file under "Recent sessions", update "Active context" and navigation when they change, and set "Last consolidated" to today.
5. Mark uncertain items as uncertain. Flag questionable stale entries instead of deleting them.
6. Run the verification above, then tell the user in one line what you wrote and where.

A session file is curated history, not a transcript. If writeback cannot be finished, say what is missing. It never blocks the answer.

## Template feedback

This brain was built from brain-template. `memory/overview.md` records the version under "Origin". When you notice a structural improvement that would help any brain, add it to `planning/template-feedback.md` and tell the user. The `new-brain` skill carries those notes back into the template. Facts about this brain's subject stay here.

<!-- PROFILE RULES -->
