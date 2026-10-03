# Profile: personal-admin

## Use when

The brain acts as a personal secretary for recurring life administration: taxes, government contributions, benefits, insurance, bills, IDs, licenses, and renewals. It tracks what applies to the person, when each item is due, what was actually paid or filed, and where the documents are.

## Do not use when

The purpose is a software or work project. Use `software-project` for that.

## What it adds

- `memory/profile.md`, the facts about the person that decide which obligations apply.
- `memory/obligations.md`, every recurring duty with its due rule, next due date, and official source.
- `memory/documents.md`, where each important document is kept.
- `records/`, a log of completed filings and payments by year and agency.
- Rules in `AGENTS.md` for a deadline check at startup, sourcing external rules, showing computations, and never acting outside the brain without a request.

## Interview

Ask these when creating the brain. Record only what the user states, dated, in the files named. Mark anything the user is unsure of as unverified.

1. Which country, and which local jurisdiction if it matters? (`memory/profile.md`)
2. What is the income and employment situation, and since when? For example employed, self-employed, or mixed income. (`memory/profile.md`)
3. Which agencies or institutions is the person registered with, and under what membership type? Ask for the last four digits of any ID only. (`memory/profile.md`)
4. Which obligations does the person already know about, and which feel urgent or behind? (`memory/obligations.md`, unverified until sourced)
5. Where are documents and receipts kept? (`memory/documents.md`)

## Boundaries

This profile holds structure only. Jurisdiction-specific rules, rates, and deadlines go stale. They belong in the brain, with official sources, never in the template.

## Known gaps

- The deadline check runs only when a session starts in the brain. Nothing reminds the person between sessions.
