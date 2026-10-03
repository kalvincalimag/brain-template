# Brain template

Builds brains. A brain is a local, curated knowledge base for one purpose. You start an agent session in its directory, the agent reads the brain's memory, and it writes durable knowledge back when the work is done.

## Create a brain

With Claude Code, run the `new-brain` skill and describe the purpose. It reviews this template against the purpose, improves the template where it falls short, interviews you, creates the brain, and checks it.

Without the skill:

```bash
bash scripts/new-brain.sh --dest ../brains/my-brain --name "My brain" \
  --purpose "One sentence on what this brain is for." --profile personal-admin
```

Then fill in `memory/overview.md` in the new brain.

## Layout

- `core/` is copied into every brain.
- `profiles/` holds optional structure for a class of purpose. Each profile's `PROFILE.md` says when to use it.
  - `personal-admin` is for taxes, government contributions, benefits, bills, IDs, and renewals.
  - `software-project` is for a software product and its delivery.
- `scripts/new-brain.sh` builds a brain from core and the chosen profiles.
- `tests/test-template.sh` builds brains from every profile and checks them. Run it before every commit.
- `TEMPLATE.md` says what may change here, how to review fitness for a new purpose, and what changed so far.
