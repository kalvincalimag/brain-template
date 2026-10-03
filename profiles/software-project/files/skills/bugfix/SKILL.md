---
name: bugfix
description: "Reproduce, diagnose, fix, and verify software bugs end to end with evidence-grounded TDD, regression preservation, manual QA, and repository-specific delivery validation. Use when the user reports broken, missing, incorrect, intermittent, or regressed behavior and asks for a fix. Do not use for diagnosis-only requests that do not authorize changes."
---

# Bugfix

## Purpose

Turn a reported symptom into a verified repair without losing the exact state that exposed it. Compose the repository's own rules with `execution-discipline` and, when delivery or deployed QA is requested, `post-superplan-execution-loop` from the beginning of the task.

Repository instructions and explicit user directions take precedence. Read [evidence-templates.md](references/evidence-templates.md) before beginning and keep its evidence artifacts current throughout the loop.

## Boundaries

- In Plan Mode, produce only the investigation and execution plan, evidence gates, and handoff criteria. Do not mutate code, git, deployments, browsers, or memory.
- A diagnosis-only request is read-only. Investigate and report; do not edit, commit, merge, deploy, or otherwise mutate state unless the user authorizes a fix.
- Stop before destructive, irreversible, financial, wallet-signing, order-submission, payment, or production actions unless the user explicitly authorizes the exact action.
- Default to one implementation agent for a bugfix. Use parallel agents only when explicitly requested or when the work has genuinely independent investigation or review lanes that cannot conflict.

## Compose the Workflow

1. Apply `execution-discipline` for confirmed-versus-inferred claims, starting-state capture, scoped edits, old-contract compatibility, and evidence-based handoff.
2. If the request includes merge, delivery, deployed-development QA, or the post-superplan loop, invoke `post-superplan-execution-loop` as the enclosing lifecycle before implementation. Do not bolt it on after a local fix.
3. Follow repository-specific testing, branching, review, merge, deployment, and memory instructions. Let the invoked skills govern their own model routing and agent roles.

## 1. Establish the Reproduction Contract

Inspect every supplied screenshot, recording, error, log, or linked artifact before forming a diagnosis. Capture:

- exact route or entry point;
- user/auth/account state and feature flags;
- viewport, device, browser, and network conditions when relevant;
- selected entity, provider, chain, locale, time range, or other data state;
- expected behavior and the observed behavior;
- console, network, server, and persisted-state evidence;
- repeatability and any known intermittent timing.

Reproduce the symptom on the unchanged baseline when safe. If exact reproduction is blocked, record the missing prerequisite and distinguish confirmed evidence from hypotheses. Never silently replace the reported state with an easier nearby state.

## 2. Freeze the Regression Matrix

Before edits, fill the regression matrix from the reference. Include the exact reported state, adjacent states sharing the same contract, empty/loading/error states, and any old client/provider/cache/environment contract that may still exist. Capture named baseline failures and passes before claiming a delta.

## 3. Diagnose at the Defect Boundary

Trace the failing value or behavior across its real boundaries: source data, normalization, state selection, cache/freshness logic, API contract, rendering, and deployment/runtime configuration. Prefer evidence from the narrowest boundary that explains both the symptom and the unaffected cases.

State root cause as confirmed only when the code/runtime evidence supports the causal chain. Otherwise label it inferred and name the check that would confirm it.

## 4. Repair with TDD

1. Add the smallest regression test that reproduces the defect at the boundary where it belongs.
2. Run it against the unchanged implementation and verify it fails for the expected reason.
3. Make the smallest scoped fix that satisfies the intended contract.
4. Run the focused test, then the regression matrix and broader repository gates required by risk.
5. Do not weaken tests or rewrite their intent to make a failure disappear. If intended behavior changed, explain the contract change and obtain required approval.

Make time, provider, cache, environment, and race conditions deterministic in tests. Preserve unrelated dirty work and avoid opportunistic refactors.

## 5. Verify the Exact User State

Manual QA must exercise the original route and state, not merely a component story or adjacent page. For UI bugs, use the relevant browser/device viewport and inspect visible output plus console and network behavior. Save screenshots or equivalent artifacts for visual claims.

Repeat the original workflow enough times to cover its timing characteristics. Mark the symptom no longer reproducible only when the exact reproduction contract passes and the regression matrix stays green.

If delivery is requested, complete local gates, merge through the repository workflow, confirm the deployed development build serves the exact merged commit, and repeat the same QA against that deployment. An HTTP 200 or a green build alone is not manual QA.

## 6. Treat QA Failures as New Bugs

For every failure found during local or deployed QA:

1. add it to the QA iteration ledger;
2. reproduce it deterministically where feasible;
3. add a red regression test;
4. fix the smallest causal boundary;
5. rerun focused and broad gates;
6. repeat the original workflow and affected regression rows.

Respect any cycle cap imposed by `post-superplan-execution-loop` or the repository. When the cap is reached, stop with the repeated pattern, evidence, and last verified state rather than rounding partial success up to done.

## Completion Contract

Report completion only when:

- the original symptom is no longer reproducible in its exact state;
- the defect-boundary regression test failed before the fix and passes after it;
- every required regression row and local gate passes;
- requested deployed QA ran against the exact merged commit and passed;
- no unauthorized irreversible action was taken;
- required memory/writeback and delivery steps are complete.

If a gate cannot run, report the precise blocker and last confirmed state. Use the completion evidence checklist in the reference for the final handoff.
