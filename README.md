# Brain template

Builds brains. A brain is a local, curated knowledge base for one purpose. You start an AI agent in its directory, the agent reads the brain's memory, and it writes durable knowledge back when the work is done. Brains work with any agent that reads `AGENTS.md`, such as OpenAI Codex, and with Claude Code through a small adapter file.

## Requirements

`git`, `bash` 3.2 or later, and `perl`. macOS and Linux include all three. On Windows, use Git Bash, which comes with Git for Windows.

## Create a brain

Start your AI agent in this repository and ask it to create a brain for your purpose. It follows "Create a brain" in `TEMPLATE.md`. It reviews the template against your purpose, improves the template only where it falls short, asks you a few questions, builds the brain, and checks it.

To build one by hand:

```bash
bash scripts/new-brain.sh --dest ../brains/my-brain --name "My brain" \
  --purpose "One sentence on what this brain is for." --profile life-admin
```

Then fill in `memory/overview.md` in the new brain.

## Layout

- `core/` is copied into every brain.
- `profiles/` holds optional structure for a class of purpose. Each profile's `PROFILE.md` says when to use it.
  - `life-admin` is for recurring personal responsibilities: due dates, accounts, documents, and records of what was done.
  - `software-project` is for a software product and its delivery.
- `scripts/new-brain.sh` builds a brain from core and the chosen profiles.
- `tests/test-template.sh` builds brains from every profile and checks them. Run it before every commit.
- `TEMPLATE.md` holds the creation procedure, the rules for changing the template, and the changelog.
- `AGENTS.md` tells an agent working in this repository how to use it.
