# Project Skills

Project-local repeatable workflows belong at:

```text
skills/<skill-name>/SKILL.md
```

A skill may include `references/`, `scripts/`, `assets/`, and `agents/` beside its `SKILL.md`. Add a skill only when the workflow is project-specific, repeatable, testable where appropriate, and not already covered by an available global skill.

Do not copy skills from another brain without explicit review and adaptation to this project's repositories and constraints.

## Included reusable workflows

| Skill | Purpose |
| --- | --- |
| `super-plan` | Decision-complete planning with adversarial review |
| `bugfix` | Evidence-grounded TDD and exact-state regression QA |
| `merge-feature` | Pull-request publication and optional merge |
| `post-superplan-execution-loop` | Plan-to-deployed-QA delivery loop |
| `execution-discipline` | Scoped, reversible, evidence-based execution |
| `agent-browser` | Browser-driven manual QA |
| `agent-browser-verify` | Dev-server visual and console verification |
| `verification` | End-to-end user-story verification |
| `deploy-website` | Preview/production website deployment workflow |
| `openapi-sync` | Endpoint-to-OpenAPI synchronization |
