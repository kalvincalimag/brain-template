# Artifacts

Store intentional project deliverables here, not transient agent attachments or generated workspaces.

Use this layout when the first artifact is created:

```text
artifacts/YYYY/MM/YYYY-MM-DD-<slug>/
├── README.md
├── source/       # Editable source material, when appropriate
├── exported/     # Generated deliverables
└── sanitized/    # Share-safe derivatives, when needed
```

Each artifact `README.md` should record purpose, owner, source/provenance, generation commands, verification, sensitivity, and the canonical file. Do not commit secrets, raw private inputs, dependency trees, caches, or rebuildable temporary files.
