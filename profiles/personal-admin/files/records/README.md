# Records

A log of what was actually filed or paid. Keep one file per year and agency:

```text
records/YYYY/<agency-slug>.md
```

Each file holds one table, with rows appended in date order:

| Date done | Obligation | Period covered | Amount paid | Channel | Reference or receipt no. | Proof kept at |
| --- | --- | --- | --- | --- | --- | --- |

- Record only completed actions, confirmed by the user or a receipt. A plan to pay is not a record.
- Amount paid is the total actually paid, including any penalty, in the currency paid.
- Reference and receipt numbers may be stored here. They are not credentials.
- After adding a row, update `Next due` and `Status` in `memory/obligations.md`.
