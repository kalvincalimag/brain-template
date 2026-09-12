---
name: openapi-sync
description: "Use whenever creating, modifying, moving, or deleting an API endpoint or changing its authentication, authorization, parameters, request body, response body, status codes, error codes, or documented behavior. Keeps the repository's canonical OpenAPI document and contract verification synchronized with endpoint source code in the same change."
---

# OpenAPI Sync

Keep executable API behavior and the repository's canonical OpenAPI contract synchronized. This skill applies automatically to every endpoint creation or modification, including changes that leave the route and method unchanged.

## Workflow

1. Read the active repository instructions and locate the endpoint source, canonical OpenAPI file, and existing contract tests. Prefer the repository's approved paths; a common default for the contract file is `api_docs/openapi.yaml`.
2. Before changing behavior, add or update a failing test that expresses the intended API contract. Cover the relevant path, method, security, request, response, status, error, and behavioral limitation—not only route existence.
3. Implement the endpoint change and update the matching OpenAPI operation in the same working change. Synchronize:
   - public path and HTTP method;
   - authentication and authorization requirements;
   - path, query, header, and cookie parameters;
   - request schema, required fields, formats, constraints, and examples;
   - success and error response schemas and exact status codes;
   - idempotency, concurrency, retry, redaction, and environment behavior;
   - limitations such as configuration-only checks or unimplemented external probes.
4. When an endpoint is moved or removed, remove the stale OpenAPI operation. Use `deprecated: true` only when the old endpoint still exists and intentionally remains supported.
5. Review the source and OpenAPI diff together. Do not expose internal folder names in public paths unless the approved wire contract explicitly includes them.

## Verification

- Parse the OpenAPI document with the repository's existing parser or validation command.
- Run the endpoint's focused behavioral tests and the OpenAPI contract test.
- Run every repository-required test, typecheck, lint, formatting, and build gate before delivery.
- Treat a missing, stale, or unparsable OpenAPI update as an incomplete API change; do not claim completion or publish it as ready.

## Boundaries

- This workflow does not authorize unrelated endpoint redesigns, database or production-configuration changes, deployments, merges, or external publication.
- Never place live tokens, API keys, signing secrets, credentials, private URLs, or sensitive customer payloads in OpenAPI examples, tests, diffs, or verification output.
- Preserve provider-specific wire contracts at their adapter boundary. Document a normalized endpoint only when the implementation actually exposes that contract.
- If a repository has API source but no canonical OpenAPI location, follow its instructions. If none exists, use `api_docs/openapi.yaml` and add a parser-based contract test as part of the approved API change.
