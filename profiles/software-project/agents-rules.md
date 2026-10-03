## Software project rules

### Skills

- Engineering work uses the skills pack installed user-wide: `investigate`, `plan`, `implement`, `test-design`, `bugfix`, `verify`, `ship`, and `writing-discipline`. Do not copy them into this brain.
- A procedure that only applies to this project goes in this brain's `skills/`.
- When a pack skill falls short in a way any project would hit, improve it in `~/.claude/skills`, keep it general, and offer to publish it with `sync-skills`.

### Delivery

- Stage only files that belong to the approved task.
- Do not push, open a pull request, merge, or deploy unless the user authorizes that action in this session.
- Changes that span several files, alter this brain's structure, or touch production configuration need the user's approval first.

### Project sources

- `memory/product.md` is the product source of truth inside this brain. Cite the upstream document and its version for every product claim.
- Keep code in its own repositories. This brain records what the code does and why, with links, not copies.
