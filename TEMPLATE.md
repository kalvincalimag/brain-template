# Template maintenance

This file is the contract for building brains from this template and for changing it. Any AI agent can follow it. A tool that wraps this procedure, such as an agent skill, should point here instead of copying it, so the procedure improves with the template.

## Requirements

The scripts need `git`, `bash` 3.2 or later, and `perl`.

- macOS includes all three.
- On Windows, use Git Bash, which comes with Git for Windows.
- Linux distributions include all three.

## What lives where

- `core/` goes into every brain. A change belongs in core only when every brain, whatever its purpose, is better for it.
- `profiles/<name>/` holds structure for one class of purpose. A brain can use several profiles at once.
- The new brain holds everything about its own subject. That includes names, numbers, dates, places, rates, and decisions.

When unsure between core and a profile, choose the profile. When unsure between a profile and the brain, choose the brain. Moving something up later is cheap. Removing something every brain already copied is not.

Two breadth checks keep the template general. Write their answers in the changelog line.

- Before changing core, name three unrelated purposes that would each be better for the change. If you cannot, the change is not core.
- Before adding a profile, name two different brains that would use it. Name the profile for a class of purpose, such as `life-admin`, never for one domain, country, or organization. Prefer extending an existing profile over adding a new one.

## What never enters the template

The template assumes nothing about who uses it. Every file, rule, and example must fit any user, in any country, with any agent.

- Assumptions about the user: their country, laws, currency, language, institutions, profession, operating system, or AI agent.
- Facts about a person, project, or organization.
- Facts that go stale: rates, deadlines, prices, laws, versions, and links to specific forms.
- Examples that reveal what the template's owner uses it for. Use neutral examples.
- Credentials of any kind.
- Content copied from an existing brain. Carry over only the structural idea, rewritten so it fits any subject.
- Skills of any kind. Skills are out of scope for brains. They are the user's own tools, kept in the user's agent setup, which loads them in every session, including sessions in a brain. A brain records repeatable procedures as knowledge in `memory/`. The tests and every brain's validator fail on any `SKILL.md`.
- Anything that only works with one AI agent, except a thin adapter file such as `core/CLAUDE.md`. `core/AGENTS.md` is the contract every agent reads.

## Profile anatomy

Each profile directory has:

- `PROFILE.md` with these sections: "Use when", "Do not use when", "What it adds", "Interview", and optionally "Boundaries", "Known issues", or "Known gaps".
- `agents-rules.md`, which starts with one `## <Name> rules` heading. `scripts/new-brain.sh` appends it to the brain's `AGENTS.md`.
- `memory-index.md`, the navigation lines `scripts/new-brain.sh` adds to the brain's `memory/MEMORY.md`.
- `files/`, copied into the brain at the same relative paths. It must include `files/tests/required/<name>.txt`, which lists the files the brain's validator requires.

A profile never writes a path that core or another profile writes. `scripts/new-brain.sh` refuses the collision.

## Placeholders

`scripts/new-brain.sh` fills these in every `.md` file of a new brain: `{{BRAIN_NAME}}`, `{{PURPOSE}}`, `{{CREATED}}`, `{{TEMPLATE_REF}}`, and `{{PROFILES}}`. The brain's validator fails if any is left.

## Create a brain

1. **Get the purpose.** Ask what the brain is for, what it should help decide or do, and what is out of scope. If the request already says, restate it in one sentence and confirm it in the interview. Do not continue without a purpose.
2. **Sync the template.** In this repository, the branch must be `main`. If an earlier run left unpublished template changes, show them and ask the user whether to publish or discard them before continuing. Then pull the latest with `git pull --ff-only`. If the branch has diverged from GitHub, stop and ask.
3. **Review fitness.** Follow "Fitness review" below for this purpose.
4. **Improve the template, only where the review found a gap.** Follow "Changing the template" for each core or profile gap. If every gap is brain-level, change nothing.
5. **Interview.** Ask in one batch: the brain's name, where to create it, and the "Interview" questions of each chosen profile. Skip anything already answered.
6. **Create.** Run this, repeating `--profile` for each chosen profile:

   ```bash
   bash scripts/new-brain.sh --dest "<path>" --name "<name>" --purpose "<one-paragraph purpose>" --profile <profile>
   ```

7. **Personalize.** In the new brain:
   - Fill `memory/overview.md` with scope, out of scope, and authority.
   - Record the interview answers in the files each profile names. Record only what the user stated, dated, and mark anything uncertain as unverified.
   - Do not research outside rules now unless the user asks. Sourced research belongs in the brain's first real session.
   - Handle the brain-level gaps from the fit report, such as a memory file this purpose needs.
   - Update "Active context" in `memory/MEMORY.md`.
   - Write `sessions/YYYY/MM/YYYY-MM-DD-brain-created.md` from `templates/session-summary.md`, with the fit report.
8. **Verify.**
   - In the brain, run `bash scripts/validate-brain.sh`.
   - Start a fresh agent session in the brain without tools, for example `claude -p "<question>"` or `codex exec "<question>"`. Ask what the brain is for and which memory files its index lists. The answer must name the purpose and the profile's memory files. That proves a new session loads the brain.
   - If no agent command is available, say this check did not run.
9. **Publish, with permission.** Ask the user before committing or pushing template changes, and before the brain's first commit. After a template commit, replace the "Origin" line in the brain's `memory/overview.md` with the new short commit hash. If the user declines the template push, say that this repository holds unpublished changes and that the next creation stops at step 2 until they are published or discarded.

## Fitness review

Do not assume the template fits because a profile's name sounds right.

1. Write the purpose as a class, without personal facts. A purpose about one person's household paperwork becomes "life admin".
2. Read every file in `core/`. For each, decide whether this brain needs it, whether it would mislead, and whether anything is missing.
3. Read each `profiles/*/PROFILE.md`. Choose the profiles whose "Use when" fits and whose "Do not use when" does not. Read the files of each chosen profile the same way as core.
4. List every gap and mismatch. Give each one a level: core, profile, or brain, using the rules in "What lives where". Anything that depends on where the user lives or which institutions they deal with is brain-level.
5. Keep the fit report short. It goes into the new brain's first session file and, when the template changes, into the changelog.

## Changing the template

1. Make the smallest structural change that closes the gap. Before writing it, check it against "What never enters the template": if it would fit only users in one country, with one institution, or with one agent, it belongs in the brain, not here.
2. If the change alters `scripts/new-brain.sh`, the validator, or how profiles compose, add a check to `tests/test-template.sh` first and watch it fail.
3. Run `bash tests/test-template.sh` until it passes. To also check that no brain's names leaked into the template, keep a list of those names outside the repository, one per line, and set `BRAIN_TEMPLATE_BLOCKLIST` to its path.
4. Add a dated line to the changelog: the purpose class that exposed the gap, what changed, why, and the breadth check answers.
5. Commit and push only with the user's authorization.

## Carry feedback back from a brain

A brain records structural improvements in its `planning/template-feedback.md`.

1. Read only that file and any structural file an entry names. Do not read the brain's memory, sessions, records, or `private/`.
2. Sync the template, as in "Create a brain" step 2.
3. For each entry, choose core, profile, or reject. Rewrite the idea so it holds no facts about that brain's subject. Apply it and run the tests.
4. In the brain's feedback file, mark each entry as carried over, with the date and template commit, or as rejected, with the reason.
5. Ask before committing and pushing the template.

## Changelog

- 2026-10-03, life admin: the first non-software purpose showed that the template assumed a software project. Split it into `core/` and `profiles/`. Moved product, project, and team memory and `migrations/` into the `software-project` profile. Added a life-admin profile with obligations, records, documents, and a startup due-date check. Core gained `private/` for sensitive values, adapter imports so memory loads at launch, writeback without being asked, a recorded template origin, and `planning/template-feedback.md`. Added `scripts/new-brain.sh`, `tests/test-template.sh`, and the breadth checks. Breadth: the life-admin profile fits a household brain and a relocation brain; the core additions help a learning brain, a health brain, and a software brain.
- 2026-10-03, software project: the profile carried ten skill copies that duplicated and drifted from the owner's own skills. Removed them.
- 2026-10-03, all purposes: skills are out of scope for brains. Removed core's `skills/` folder and its writeback skill; writeback is triggered by asking for it. Procedures are recorded as knowledge in `memory/`. The tests and each brain's validator fail on any `SKILL.md`. Breadth: every brain, since the user's own skills already load in every session.
- 2026-10-03, all purposes (adversarial review): `AGENTS.md` now lists exactly when a session file is required, says writeback needs no commit, and tells the agent to search the brain before researching or asking. `memory/MEMORY.md` caps recent sessions at ten. Brain settings allow the validator and read-only git commands without prompts. `scripts/new-brain.sh` and the validator handle apostrophes in paths and a repeated profile. Breadth: every brain.
- 2026-10-03, all purposes: the template now serves any AI agent on macOS, Windows, or Linux. The creation procedure moved into this file from an agent-specific skill, and a root `AGENTS.md` points agents here. `core/AGENTS.md` treats `CLAUDE.md` as one adapter among agents. Requirements are documented, and a test rejects bash-4-only features and GNU-only flags. The first profile became `life-admin`, rewritten in neutral terms, and examples that described the owner's own use were removed. Breadth: every brain, whichever agent or operating system its owner uses.
- 2026-10-03, life admin: a secretary brain needs a home for step-by-step procedures, and the obligations table holds only one line per task. Added `memory/procedures.md` to the life-admin profile, linked from each obligation. `core/AGENTS.md` now points to this file, not to one agent's skill, for carrying feedback back. Breadth: procedures fit a household brain (renewing a vehicle registration) and a relocation brain (renewing a visa); the feedback pointer helps every brain whichever agent runs it. Creation step 2 now asks whether to publish or discard leftover template changes instead of stopping.
- 2026-10-03, all purposes: made explicit that the template assumes nothing about who uses it: no country, laws, currency, language, institutions, profession, operating system, or agent. The fitness review classes anything location- or institution-specific as brain-level, every template change is checked against that rule before it is written, and brains must word template feedback so it fits any user. Breadth: every brain and every user.
