---
name: deploy-website
description: "Deploy a website to Vercel and, when explicitly authorized, connect a GoDaddy-managed custom domain. Covers repository and account preflight, preview-first deployment, narrowly scoped DNS changes, HTTPS verification, rollback, and optional CI/CD review."
---

# Deploy Website to Vercel with GoDaddy DNS

## Purpose

Take a web project from a verified local build to a verified Vercel deployment, then optionally connect a GoDaddy-managed domain without exposing credentials or disturbing unrelated DNS records.

Repository instructions and explicit user direction take precedence. This skill coordinates deployment work; it does not itself authorize creating a repository, pushing commits, changing DNS, deploying production, modifying CI, or promoting traffic.

## Hard boundaries

- Treat preview deployment, production deployment, domain attachment, DNS mutation, CI changes, and repository creation as separate actions with separate authorization requirements.
- Default to a preview deployment. Production deployment or promotion requires explicit authority from the user or repository contract.
- Never place access tokens, API keys, or secret values in tracked files, shell command arguments, tool output, screenshots, session summaries, or pull-request text.
- Prefer authenticated provider CLIs, connectors, or secure secret-input mechanisms. If required credentials are unavailable, stop and ask the user to configure them through the provider-supported secure flow.
- Read DNS before writing it. Change only the exact approved record names and types.
- Never modify `NS`, `SOA`, `MX`, SPF, DKIM, DMARC, verification `TXT`, or unrelated records as a side effect of connecting a website.
- Do not create or replace `vercel.json`, GitHub Actions workflows, branch settings, or production configuration unless the project actually requires it and the change is approved.
- Do not assume the production branch is `main`; derive it from repository and Vercel project truth.
- Stop before any domain purchase, transfer, nameserver replacement, or destructive DNS action unless the user explicitly requests that exact action.

## Required inputs

Confirm before mutation:

- local project root and repository;
- framework, package manager, build command, and output directory;
- Vercel account/team and target project;
- intended preview and production branches;
- apex domain and any approved subdomains;
- authoritative DNS provider and GoDaddy account ownership;
- exact deployment, domain, DNS, repository, and CI actions authorized;
- rollback target for production and before-state for every DNS record to be changed.

Do not ask the user to paste credential values into chat or a repository file.

## 1. Establish the baseline

1. Read the repository instructions and inspect branch, status, remotes, deployment configuration, and existing CI.
2. Preserve unrelated dirty work. Do not initialize Git or rename a branch in an existing repository.
3. Run the repository's required tests and build. Record existing failures before changing deployment configuration.
4. Confirm the relevant CLIs are installed and authenticated without printing tokens:

```bash
command -v gh
gh auth status
command -v vercel
vercel whoami
vercel --version
```

5. Inspect existing Vercel linkage and ignore rules. `.vercel/`, `.env*`, provider credential files, and deployment logs must not be committed unless the repository explicitly documents a safe exception.

If the project is not yet a Git repository or lacks a remote, propose the exact repository owner, visibility, default branch, and remote URL. Create it only after authorization.

## 2. Link the Vercel project

Prefer the existing project link. If no local link exists, determine whether the target Vercel project already exists before running `vercel link`; linking can create external project state when the named project does not exist.

For an existing project, derive and confirm the exact team slug or ID and project name or ID, then link non-interactively:

```bash
vercel link --yes --team team-slug --project project-name-or-id
```

If the Vercel project does not exist, propose its team, name, framework settings, and environment scope and obtain authorization to create it before running any linking or creation flow. Do not accept CLI defaults that can select or create an unintended project.

Do not pass a long-lived token on the command line. Confirm that the generated local project metadata is ignored by Git.

Inspect framework detection and existing project settings before adding configuration. Create or change `vercel.json` only when repository behavior cannot be represented by existing framework settings, and test that change locally.

## 3. Deploy and verify a preview

After local gates pass, deploy a preview:

```bash
vercel deploy
```

Capture the immutable deployment URL and deployment identifier. Verification must cover:

- the expected commit or source tree;
- build completion and build logs;
- HTTP response and important routes;
- browser rendering at relevant viewports;
- console and network errors;
- authentication or protected-route behavior where safe;
- server or function errors in deployment logs.

An HTTP 200 alone is not sufficient. Do not promote a preview that has not passed the project's required manual and automated checks.

## 4. Add a custom domain

Domain attachment changes external state and requires authorization.

1. Inspect existing project domains.
2. Add only the approved apex or subdomain to the confirmed project.
3. Inspect the domain to obtain Vercel's current required DNS records; do not rely on remembered IP addresses or CNAME targets.

```bash
vercel domains ls
vercel domains add example.com project-name
vercel domains inspect example.com
```

If both apex and `www` are required, treat each as an explicit target and decide which hostname is canonical before configuring redirects.

Use the current official Vercel domain guidance:

- [Set up a custom domain](https://vercel.com/docs/domains/set-up-custom-domain)
- [Deploy from the CLI](https://vercel.com/docs/projects/deploy-from-cli)

## 5. Change GoDaddy DNS safely

Use GoDaddy DNS APIs only when GoDaddy remains authoritative for the domain. If nameservers point elsewhere, use the actual authoritative provider instead.

Before writing:

1. Read the complete record set and the exact target records.
2. Save a redacted before-state containing record IDs, names, types, data, TTLs, and priorities—but no credentials.
3. Compare the requested changes with Vercel's current `domains inspect` output.
4. Present the exact record-level delta and rollback values.
5. Obtain the required approval for the DNS mutation.

Prefer GoDaddy's current record-specific API using stable record IDs. Do not replace the entire zone or every record of a broad type when only one record must change. Use a minimally scoped Personal Access Token through a secure client or connector; legacy key/secret authorization should not be introduced into new automation.

After each write, read the record back and compare every field. On a conflict, ambiguous duplicate, unexpected record, authorization failure, or API version mismatch, stop rather than broadening the operation.

Use the current official references:

- [GoDaddy Domains API](https://developer.godaddy.com/en/docs/references/rest/domains)
- [Manage DNS records](https://developer.godaddy.com/en/docs/api-users/domains/manage/dns)

## 6. Verify DNS and HTTPS

Verification should distinguish provider state, authoritative DNS, public resolver propagation, and application behavior:

```bash
vercel domains inspect example.com
dig example.com A
dig www.example.com CNAME
curl --head https://example.com
```

Use bounded polling and report propagation as pending when it has not converged. Confirm:

- Vercel recognizes the intended DNS configuration;
- authoritative and public DNS return the expected records;
- the TLS certificate is valid for every approved hostname;
- the canonical hostname and redirect behavior are correct;
- the deployed application renders and key routes work over the custom domain.

## 7. Promote to production

Production promotion requires explicit authorization and a verified rollback target. Prefer staging a production build without moving the domain when the project needs a final gate:

```bash
vercel deploy --prod --skip-domain
```

After verifying that staged production deployment, promote the exact deployment:

```bash
vercel promote deployment-url
```

Where the repository's established workflow deploys directly, follow that contract instead. Verify the production domain serves the intended deployment identifier or commit. Record the previous production deployment so rollback can use the provider-supported rollback or promotion mechanism.

## 8. CI/CD is conditional

Do not automatically add a GitHub Actions workflow. First determine whether the project already uses:

- Vercel Git integration;
- an existing deployment workflow;
- protected environments and approvals;
- branch-scoped Preview and Production settings.

If CI changes are required, plan and review them as repository configuration changes. Use GitHub encrypted secrets or provider-supported workload identity; never place secret values in workflow YAML or CLI arguments. Test Preview delivery before enabling Production deployment.

## Failure and retry rules

- Retry a read after transient failure using bounded backoff.
- Before retrying a write, re-read provider state to determine whether the first attempt succeeded.
- Do not retry repository creation, domain attachment, DNS mutation, or production promotion blindly.
- A partial deployment is not completion. Report the precise last confirmed state and the safest rollback or continuation step.

## Completion evidence

Report:

- repository, branch, commit, Vercel scope, and project;
- preview and production deployment identifiers and URLs, as applicable;
- domain and exact DNS records changed;
- before-state and rollback target location without secrets;
- local tests/build and deployment-log results;
- browser, console, network, DNS, TLS, and route verification;
- CI or Git integration state;
- actions intentionally left unperformed and any remaining propagation or user checks.
