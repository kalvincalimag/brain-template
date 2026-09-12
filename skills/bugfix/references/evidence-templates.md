# Bugfix Evidence Templates

Use these as working artifacts. Keep facts and hypotheses distinct, and update them as evidence changes.

## Reproduction Contract

```markdown
### Reported symptom
- Source artifact:
- Expected:
- Observed:

### Exact state
- Baseline branch/commit and dirty state:
- Route/entry point:
- Auth/account/flags:
- Entity/provider/chain/locale/time range:
- Device/browser/viewport:
- Network/timing/cache conditions:

### Evidence
- Reproduction steps:
- Repeatability:
- Console/network/server evidence:
- Confirmed facts:
- Inferences and confirmation needed:
```

## Regression Matrix

| State | Why it can regress | Baseline | Expected after fix | Automated evidence | Manual evidence | Result |
|---|---|---|---|---|---|---|
| Exact reported state | Original defect | | | | | |
| Adjacent shared-contract state | Same source/normalizer/renderer | | | | | |
| Loading/empty/error state | Fallback behavior | | | | | |
| Old contract or environment | Deployed/cached/provider compatibility | | | | | |

Add rows for authentication, feature flags, viewport classes, providers, chains, races, or locales when relevant. A baseline may be `pass`, a named existing failure, or `blocked` with the exact reason.

## QA Iteration Ledger

| Iteration | Commit/build | Environment | Exact workflow exercised | Failure or pass evidence | New red test | Fix | Regression rerun |
|---|---|---|---|---|---|---|---|
| 1 | | Local | | | | | |
| 2 | | Deployed development | | | | | |

Record the exact deployed commit or immutable build identifier. Do not call a deployment current from age, URL, or HTTP status alone.

## Completion Evidence Checklist

```markdown
- Root cause: [confirmed/inferred] — evidence
- Scope changed: files and contract
- Red test: command and expected pre-fix failure
- Green focused test: command and result
- Regression matrix: rows and result
- Broad gates: typecheck/test/build/lint/diff as required
- Local manual QA: route, state, viewport/device, repetitions, console/network, artifact
- Merge/deploy: PR/merge commit and deployed commit proof, when requested
- Deployed manual QA: same exact workflow and regression evidence, when requested
- Unauthorized irreversible actions: none / explicitly authorized action
- Remaining blockers or unverified claims: exact list
- Writeback/delivery state: location and status
```
