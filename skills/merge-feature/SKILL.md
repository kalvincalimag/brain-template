---
name: merge-feature
description: "Publish a completed working branch through the repository's documented GitHub pull-request path. Use when the user asks to create, ship, merge, or promote a feature after implementation and local verification. Do not use for dry-run or inspection-only requests."
---

# Merge Feature

## Purpose

Publish a completed branch through the active repository's documented delivery path without skipping local, pull-request, merge, or post-merge gates. Repository instructions and explicit user direction determine the base branch, merge method, deployment environment, and stopping boundary.

This skill does not itself authorize a push, pull request, merge, deployment, or promotion. Confirm that the user or repository policy authorizes each outward action before taking it.

## Preflight

1. Read the repository instructions and identify the required base branch and promotion path. Do not assume `develop` or `main`.
2. Confirm the GitHub CLI is available and authenticated: `command -v gh` and `gh auth status`.
3. Inspect `git status --short --branch`, remotes, current branch, upstream, and latest base tip.
4. Refuse to publish from a detached head or protected base branch. Create an appropriately named feature or memory branch first.
5. Identify unrelated dirty files and stage only the authorized paths. Never use broad staging when unrelated work exists.
6. Confirm all required local tests, builds, and diff checks have passed for the exact proposed commit.

## Pull-request workflow

1. Fetch the documented base branch immediately before integration.
2. If the base moved or conflicts exist, integrate its latest tip locally. Resolve each conflict by intent, preserve unrelated changes, and rerun affected tests plus the full required gate.
3. Review the complete branch diff and staged diff. Confirm the file list matches the authorized scope.
4. Push the feature branch with an explicit upstream.
5. Reuse an existing open pull request for the same head/base pair or create a new one with a concise summary, verification evidence, risks, and remaining manual checks.
6. Wait for every required check. Pending is not green. Diagnose failures from evidence; do not retry a flaky check until it happens to pass.
7. Merge only if the user or repository workflow authorizes merging and the pull request is mergeable with required checks green. Follow the repository's merge-method convention.

## Post-merge verification

When a merge is authorized:

1. Fetch the base and confirm it contains the expected merge or squash commit.
2. Watch the base-branch workflow for that exact commit.
3. If the repository deploys the base, confirm the deployment serves that commit rather than merely returning HTTP 200.
4. Treat post-merge failures as new defects and fix them through the same branch-and-PR workflow unless the user directs otherwise.

## Stop boundaries

- Stop at the repository-defined promotion boundary. Do not infer permission for the next environment or branch.
- Do not close, cancel, merge, or replace unrelated pull requests or workflows.
- Stop before destructive, production, financial, or irreversible actions without explicit authorization.

## Handoff

Report the pull-request URL, base and head branches, local and remote checks, conflict resolutions, merge/deploy status if authorized, remaining risk, and project-local writeback state. Claim only what was directly verified.
