# Planning

Human-authored plans and decision records. Agent runtime state does not belong here.

```text
planning/
├── active/YYYY-MM-DD-<slug>.md
├── decisions/YYYY-MM-DD-<slug>.md
├── archive/YYYY/YYYY-MM-DD-<slug>.md
└── template-feedback.md
```

A plan states its objective, scope, acceptance criteria, dependencies, risks, verification, current status, and next action. Archive a plan when it is completed or abandoned, so the active set stays current.

`template-feedback.md` collects structural improvements that would help any brain built from brain-template. Each entry is dated, says what to change and why, and never contains facts about this brain's subject. The `new-brain` skill reads this file when it improves the template, then marks the entries it carried over.
