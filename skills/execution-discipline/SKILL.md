---
name: execution-discipline
description: "Use for non-trivial execution, debugging, review follow-through, research synthesis, deployment work, or multi-step tasks where claims, verification, scope, subagent output, rollback, or old-contract compatibility could matter. Applies Fable5-style discipline: confirmed vs inferred claims, baseline before no-regression claims, failable gates, scoped staging, rollback awareness, and final evidence-based handoff."
---

# Execution Discipline

## Purpose

Keep non-trivial work evidence-based, scoped, and reversible. Use this when the task is bigger than a one-shot edit or when a wrong claim, unverified agent output, broad staging, stale baseline, or unsafe outward action would create real cost.

This skill adapts the useful parts of the Fable5 execution discipline into the active repository workflow. It does not override repository instructions or expand authorization for commits, pushes, pull requests, deployments, or memory writeback.

## Core Rules

1. Mark important claims.
   - Confirmed claims name evidence: file path, command, runtime check, source read, PR/check status, or artifact.
   - Inferred claims say they are inferred and name what would confirm them.
   - Do not turn a diagnosis, root cause, "works", "safe", or "no regression" claim into fact from one weak sample.

2. Capture the baseline before claiming no regression.
   - Record starting branch/commit and dirty state when code or memory changes.
   - For tests/checks, capture the baseline count or named failures before comparing later results.
   - Report deltas: `baseline 2 failing {a,b} -> still 2 failing {a,b}` or `now 3: +c, likely caused by this change`.

3. Use gates that can fail.
   - Prefer real tests, builds, lint/typecheck, HTTP smoke, browser/device checks, generated artifact inspection, or source readback.
   - A compile/build alone does not prove runtime behavior. For visual/stateful/user-facing work, inspect the actual screen or artifact when feasible.
   - If a stage cannot be verified, label it unverified instead of implying confidence.

4. Treat agent/reviewer output as hypotheses.
   - Do not accept a subagent's "complete", a review finding, stale memory, or a README statement without checking the cited files/output.
   - Keep findings that survive direct inspection; discard contradicted ones and say why if relevant.

5. Stay scoped.
   - Stage only files intentionally changed for this task.
   - Name unrelated dirty or untracked work and leave it alone.
   - If a file contains mixed user/agent changes, inspect before staging; do not blanket-add a directory unless the task is explicitly a consolidation.

6. Respect outward-action boundaries.
   - Before destructive, irreversible, or external-state actions, know the rollback or recovery path.
   - If the user or repo instructions already authorize commit/push/PR/deploy/writeback for this task class, proceed and report what happened.
   - If not authorized, stop before commit, push, deploy, migration, deletion, remote edit, or shared/global/native-state write.

7. Check old contracts before calling a change safe.
   - Identify what may still speak the old shape: deployed server, installed clients, cached values, migrations, env vars, workflows, prompts, or consumers.
   - Confirm compatibility or document the rollout boundary.

8. Close with state.
   - Say what changed, what was verified, what is committed/pushed/PR'd, what remains dirty, and what is inferred or unverified.
   - For user-side checks, name exactly what only the user can verify.

## Before Sending

Re-read once and fix any failure:

- Can a reader tell confirmed claims from inferred claims?
- Did you claim no regressions without a baseline?
- Did you trust an agent/reviewer/memory claim without direct evidence?
- Did you stage files outside the task scope?
- Did you take an outward action without authorization or rollback awareness?
- Did you check what still speaks the old contract?
- Is the answer larger than the task deserves?
