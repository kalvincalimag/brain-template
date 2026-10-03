## Software project rules

### Change workflow

Use test-driven development for scripts and validation logic in this brain:

1. Add or update a test that expresses the intended behavior.
2. Run it and confirm that it fails for the expected reason.
3. Make the smallest change that passes.
4. Run the focused test, then every check in this brain.

Changes that span several files, alter structure, or touch production configuration need the user's approval first.

### Delivery

- Stage only files that belong to the approved task.
- Do not push, open a pull request, merge, or deploy unless the user authorizes that action in this session.
- Before an authorized push, run every check and review the staged diff.

### Project sources

- `memory/product.md` is the product source of truth inside this brain. Cite the upstream document and its version for every product claim.
- Keep code in its own repositories. This brain records what the code does and why, with links, not copies.
