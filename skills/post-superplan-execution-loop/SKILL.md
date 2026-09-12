---
name: post-superplan-execution-loop
description: "Carry an approved plan through implementation, repository-defined merge, deployed-environment QA, bounded bug-fix cycles, and project writeback. Use when the user explicitly requests end-to-end delivery rather than planning alone."
---

# Post-Superplan Execution Loop

## Overview

Carry a super-planned change through implementation, the repository-defined merge path, deployed-environment QA, and bug fixing until the requested environment passes — with evidence at every gate. "Done" requires runtime evidence when deployment is in scope, not only local tests.

**Plan Mode boundary:** while in Plan Mode, produce only the execution-ready plan, gates, and handoff criteria. No code changes, git mutations, deploys, browser QA, or memory writebacks.

**Required sub-skills:** `super-plan` for the planning gate, `merge-feature` for the repository promotion gate, and `execution-discipline` for evidence and scope. Follow the active repository's TDD and validation rules.

Track the loop with a todo per gate below. A gate without a checkable pass condition is not a gate.

## The Loop

### 1. Ground

Read repo instructions, relevant project memory, current branch/status, and current runtime/deploy state. Start from repo truth, not chat assumptions. Preserve unrelated dirty work.

### 2. Plan

Build the normal implementation plan, then run the `super-plan` review loop until decision-complete and blocker-free with explicit verification gates.

### 3. Implement with TDD

- Failing test first; verify it fails for the expected reason.
- Smallest correct change; then focused test, broader tests, typecheck, build, and diff checks as risk requires.
- Never weaken a test to hide a defect. Changing a test's intent requires the approval mandated by the user or repository.

### 4. Merge

Use `merge-feature` and the repository's documented merge workflow. The repository instructions or explicit user direction determine the target branch. Include post-merge CI verification when a merge is authorized; a green pull request does not prove the base branch is healthy.

### 5. QA the requested deployed environment

- Wait for the deployment tied to the merged commit and **confirm the deployed build is that commit** through deployment metadata or commit SHA. Poll with a bounded wait; if it has not landed after about 15 minutes, investigate the pipeline instead of assuming.
- Get the environment URL from repository or deployment truth, not memory.
- Run browser QA at the relevant viewport/device class, plus any API/smoke checks the repo uses.
- **Evidence required:** the exact workflow steps exercised, console/network errors observed (or their absence), and screenshots for visual claims. "Page returned 200" is not QA.
- If the flow can create real orders, payments, trades, or wallet actions, stop before final submit unless the user explicitly approves the live smoke.

### 6. Fix and repeat

- Every deployed-QA failure is a new bug: capture it with a failing test first, fix, rerun local gates, merge via step 4, wait for deploy, and re-QA.
- Small related bugs found in one QA pass may share one fix branch/PR; unrelated bugs get their own.
- Re-QA covers the fixed flow AND the originally requested workflow (regression), not just the patch.
- **Cap: 3 full merge→deploy→QA cycles.** If the environment still fails after 3, stop and report the pattern, evidence, and last verified state to the user rather than grinding.

### 7. Write back — during, not after

Follow the active repository's project-local session writeback protocol after each meaningful loop iteration, not only at handoff: record what changed, decisions, files, commands, tests, deployments, QA evidence, current branch/deploy state, blockers, and next steps. Do not write to another brain unless the user explicitly authorizes that separate scope. Never store secrets, tokens, raw transcripts, or unnecessary sensitive data.

## Done Criteria

Report completion only when ALL hold:

- [ ] Local gates pass (tests, typecheck, build).
- [ ] The authorized base-branch CI passed for the merge commit.
- [ ] Dev deployment serves the merged commit.
- [ ] Deployed dev URL passes the requested workflow and regression checks, with evidence.
- [ ] Memory writeback committed.

If merging or deployment was not authorized, mark those gates out of scope rather than performing them. Any required gate that is impossible must be reported with the exact blocker and last verified state. Never round "almost done" up to done.

## Red Flags — STOP, you are rationalizing

| Excuse | Reality |
|--------|---------|
| "Local tests pass, deployed QA is a formality" | Deployed environments catch configuration and integration failures local checks cannot. |
| "The deploy is probably live by now" | Verify the deployed commit SHA. Stale builds pass QA falsely. |
| "This fix is trivial, skip the failing test" | Trivial fixes regress. The test is the proof and the guard. |
| "I'll QA once at the end after all fixes" | Untested intermediate merges compound; each cycle QAs its own merge. |
| "I'll write memory back when everything's done" | Sessions get cut. Write back each meaningful iteration. |
| "One more fix cycle will do it" (after 3) | A persistent failure pattern is information the user needs. Escalate. |
