# Template maintenance

This file is the contract for changing brain-template. The `new-brain` skill follows it every time it creates a brain, so the template improves a little with each new purpose.

## What lives where

- `core/` goes into every brain. A change belongs in core only when every brain, whatever its purpose, is better for it.
- `profiles/<name>/` holds structure for one class of purpose, such as personal administration or a software project. A brain can use several profiles at once.
- The new brain holds everything about its own subject. That includes names, numbers, dates, jurisdictions, rates, and decisions.

When unsure between core and a profile, choose the profile. When unsure between a profile and the brain, choose the brain. Moving something up later is cheap. Removing something every brain already copied is not.

Two breadth checks keep the template general. Write their answers in the changelog line.

- Before changing core, name three unrelated purposes that would each be better for the change. If you cannot, the change is not core.
- Before adding a profile, name two different brains that would use it. Name the profile for a class of purpose, such as `personal-admin`, never for one domain, country, or agency, such as `philippine-taxes`. Prefer extending an existing profile over adding a new one.

## What never enters the template

- Facts about a person, project, or organization.
- Facts that go stale: rates, deadlines, prices, laws, versions, and URLs to specific forms.
- Credentials of any kind.
- Content copied from an existing brain. Carry over only the structural idea, rewritten so it fits any subject.
- Copies of skills that live in a skills pack. A profile names the pack skills it needs under "Skills it needs" in its `PROFILE.md`. Only a procedure specific to the profile's class of purpose may live in its `files/skills/`.

## Profile anatomy

Each profile directory has:

- `PROFILE.md` with these sections: "Use when", "Do not use when", "What it adds", "Interview", and optionally "Skills it needs", "Boundaries", "Known issues", or "Known gaps".
- `agents-rules.md`, which starts with one `## <Name> rules` heading. `scripts/new-brain.sh` appends it to the brain's `AGENTS.md`.
- `memory-index.md`, the navigation lines `scripts/new-brain.sh` adds to the brain's `memory/MEMORY.md`.
- `files/`, copied into the brain at the same relative paths. It must include `files/tests/required/<name>.txt`, which lists the files the brain's validator requires.

A profile never writes a path that core or another profile writes. `scripts/new-brain.sh` refuses the collision.

## Placeholders

`scripts/new-brain.sh` fills these in every `.md` file of a new brain: `{{BRAIN_NAME}}`, `{{PURPOSE}}`, `{{CREATED}}`, `{{TEMPLATE_REF}}`, and `{{PROFILES}}`. The brain's validator fails if any is left.

## Fitness review

Run this before creating any brain. Do not assume the template fits because a profile's name sounds right.

1. Write the purpose as a class without personal facts. "Personal tax and government contributions" becomes "personal administration".
2. Read every file in `core/`. For each, decide whether this brain needs it, whether it would mislead, and whether anything is missing.
3. Read each `profiles/*/PROFILE.md`. Choose the profiles whose "Use when" fits and whose "Do not use when" does not. Read the files of each chosen profile the same way as core.
4. List every gap and mismatch. Give each one a level: core, profile, or brain, using the rules in "What lives where".
5. Fix the core and profile items in the template, following "Changing the template". Brain-level items are handled after the brain exists.
6. Keep the fit report short. It goes into the new brain's first session file and into the changelog line below.

## Changing the template

1. Make the smallest structural change that closes the gap.
2. If the change alters `scripts/new-brain.sh`, the validator, or how profiles compose, add a check to `tests/test-template.sh` first and watch it fail.
3. Run `bash tests/test-template.sh` until it passes.
4. Add a dated line to the changelog: the purpose class that exposed the gap, what changed, and why.
5. Commit and push only with the user's authorization.

## Changelog

- 2026-10-03, personal administration: the first non-software purpose showed that the template assumed a software project. Split it into `core/` and `profiles/`. Moved product, project, and team memory, `migrations/`, and the ten workflow skills into the `software-project` profile. Added the `personal-admin` profile with obligations, records, documents, and a startup deadline check. Core gained `private/` for sensitive values, `@` imports in `CLAUDE.md` so memory loads at launch, auto memory turned off so `memory/` is the only store, a `/writeback` command, writeback without being asked, a recorded template origin, and `planning/template-feedback.md` for carrying improvements back. Added `scripts/new-brain.sh`, `tests/test-template.sh`, and the breadth checks. Breadth: `personal-admin` fits a household budget brain and a visa or relocation brain as well as taxes; the core additions help a learning brain, a health brain, and a software brain alike.
- 2026-10-03, software project: the profile carried ten skill copies that duplicated and drifted from the user's skills pack. Removed them. The profile now names the pack skills it needs, and `TEMPLATE.md` forbids copying pack skills into the template. Breadth: removal only; every software brain now shares one current set of skills.
