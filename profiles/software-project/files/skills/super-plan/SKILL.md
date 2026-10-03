---
name: super-plan
description: "Use whenever building an implementation plan, roadmap, sequencing, or pre-execution handoff — whether or not the user says 'super plan'. Also triggers on /super-plan, ultraplan, extended plan, implementation-ready, or requests for adversarial plan review. Applies to plans touching production behavior, deploy paths, data contracts, auth, background jobs, or multiple modules. Skip only for tiny one-shot edits or already-approved execution."
---

# Super Plan

## Overview

A plan is not ready until it has survived a hostile review grounded in repo/runtime truth. This skill extends — never replaces — repo inspection, user-intent clarification, task-specific skills, and active Plan Mode rules.

**The letter of this workflow is the spirit.** Skipping the review because the plan "feels solid" is the exact failure this skill exists to catch.

## When to Use

- The user asks for any plan, approach, strategy, sequencing, or handoff before execution — even without saying "super plan".
- Hidden assumptions could create implementation risk.

**Skip only for:** tiny one-shot edits, simple command outputs, or already-approved execution where the agent should implement rather than plan.

## Workflow

### 1. Ground in truth

- Read project instructions and only task-relevant project memory. Do not import another brain unless the user explicitly authorizes a scoped transfer.
- Inspect the actual repo: files, contracts, tests, schemas, runtime boundaries, open PRs, deploy notes, current branch state.
- Separate discoverable facts from product preferences. Ask the user only for high-impact choices that cannot be derived.

### 2. Draft the initial plan

State goal, success criteria, boundaries, interfaces, data flow, edge cases, tests, rollout, and verification. It must be **decision-complete**: the implementer never chooses files, contracts, sequencing, or acceptance criteria.

**Decision-complete checklist:**
- [ ] Every file to create/modify is named with a path.
- [ ] Every interface/type/contract change is written out, not described.
- [ ] Tests are listed by name/behavior, riskiest paths first.
- [ ] Sequencing and gates between steps are explicit.
- [ ] Verification commands are runnable as written.
- [ ] Rollout/rollback stated when production behavior changes.

### 3. Adversarial review

- If a subagent/parallel review path is available and allowed, you MUST spawn a dedicated adversarial reviewer. A research subagent does not count unless it explicitly attacks the implementation plan.
- **Pi runtime:** when an active tool named `subagent` and user agents `plan-red-team` and `plan-runtime-reviewer` are available, issue one parallel call containing both reviewers. Give each the complete original task, cwd, baseline, and full current plan. Accept the round only when the tool reports `Parallel: 2/2 succeeded` and both reviewers return CLEAR with no P0/P1. Partial success, an unknown agent, or a provider failure leaves the plan blocked.
- **Codex runtime:** use the available collaboration/subagent path to start a separate adversarial reviewer. The Pi-specific agent names are not required when that tool is absent.
- **Reviewer contract — hand it:** the full plan, the goal, verified repo facts with file paths, and constraints. **Require back:** findings with severity, each backed by a file path, contract, or runtime fact — not vibes.
- Fall back to local self-critique only when no subagent path exists or session rules prohibit one; state that fallback in the final plan notes.
- The reviewer is hostile to: unverified runtime assumptions, vague seams (any component named without its exact contract), missing tests on risky paths, hidden state transitions, deploy/rollback gaps, stale branch context, and scope creep.
- Delegate only in trusted repositories. A Pi child process still loads applicable global/project context and extensions; user-agent discovery scope does not isolate it from repository instructions.
- Preserve the full original contract on every retry. Do not use a chain that passes only the immediately preceding reviewer text.
- The parent agent owns test/build/runtime gates and must verify reviewer claims directly.

**Severity rubric:**
- **P0** — plan produces wrong behavior, data loss, broken deploy, or violates a repo contract. Blocks output.
- **P1** — plan forces the implementer to make a significant undocumented decision or rework. Blocks output.
- **P2** — polish, optional hardening, future work. Record as deferred; does not block.

### 4. Iterate to convergence

- Revise for every P0/P1, then re-review the revised plan.
- **Cap: 3 review rounds.** If P0/P1 findings persist after round 3, stop looping and surface the unresolved questions to the user as explicit decision points instead of grinding.
- Preserve deferred P2 items explicitly; never silently drop them.

### 5. Output the final plan

One complete replacement plan — not a diff against drafts. Include assumptions/defaults, public API/interface/type changes, tests, verification, and a short note of what the adversarial review changed.

## Final Plan Shape

- Title / Summary / Key Changes / Test Plan / Assumptions & Rollout Notes / Review Notes (what the critique changed, deferred P2s, fallback used if any)

Add sections only when they prevent implementation mistakes.

## Red Flags — STOP, you are rationalizing

| Excuse | Reality |
|--------|---------|
| "The user didn't ask for super-plan" | Default workflow. Explicit naming is not the trigger; planning is. |
| "The plan is simple enough" | Simple plans hide unverified runtime assumptions. Review takes minutes. |
| "I already know this codebase" | Branch state, contracts, and deploys drift. Ground in current truth. |
| "The reviewer would just agree" | Then the review is cheap. If it wouldn't, you need it. |
| "I'll fix gaps during implementation" | That converts P1s into mid-execution rework and scope creep. |
| "One more review round will fix it" (after 3) | Persistent blockers are user decisions, not yours. Escalate. |
