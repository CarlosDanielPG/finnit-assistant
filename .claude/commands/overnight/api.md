## Suggested Slash Commands (paste as files in `.claude/commands/`)

### `plan/feature.md`
Plan a new feature based on the requirements.

### `impl/story.md`
Implement the user story with code and tests.

### `review/code.md`
Review the code changes and suggest improvements.

### `overnight/api.md` (fault‑tolerant)
Run a background, autonomous build of the NestJS GraphQL API in `apps/api` for the MVP scope **without confirmations** and **continue even if a sub‑agent fails**. Install packages as needed.

```
Context:
- Read: docs/PRD.md, docs/user-stories.md, docs/requirements.md, docs/db/er-diagram.png
- Read/verify: packages/database/prisma/schema.prisma
- Respect CLAUDE.md guardrails (DTOs, cursor pagination, typed errors, snake_case in SQL, DoD)
- Sub‑agents available: prisma-migrations, api-scaffolder, graphql-resolvers, test-runner, pr-manager
- Permissions: you may run yarn/npm/pnpm, prisma, turbo, git, and edit files

Policy:
- DO NOT ask for confirmation.
- **Fault tolerance**: if a step or sub‑agent fails, log the error, mark the module as `blocked:<reason>`, and continue with the next independent step/module. At the end, summarize failures and what’s needed to fix them.
- Prefer one branch/PR per major module (accounts, transactions, debts, goals, imports) to reduce merge conflicts.

Steps:
1) Plan modules and GraphQL operations (queries/mutations/subscriptions) from docs; output a module checklist.
2) Call **prisma-migrations** to align schema; generate migrations + rollback scripts + seeds; run `db:migrate:dev` and `db:generate`.
   - On failure: record `blocked:db` and proceed to modules that don’t require new schema, but still scaffold resolvers/types where possible.
3) Call **api-scaffolder** to scaffold NestJS modules in `apps/api` (resolvers, services, mappers, repositories, module wiring).
   - On failure for a module: mark `blocked:<module>` and continue with the next.
4) Call **graphql-resolvers** to implement resolvers with DTOs, input types, cursor-based pagination and typed error mapping.
5) Call **test-runner** to add minimal unit tests (services/resolvers) and a basic e2e for critical paths.
6) Update docs minimally (append to `docs/PRD.md` → *Scope implemented*).
7) Call **pr-manager** to open PRs (one per major module). Include in each PR: summary, risks, affected migrations, test steps, and rollback.
8) Run a final consistency check: lints/types/tests. If some modules are blocked, ensure PR descriptions include TODOs and exact failing commands/logs.

Constraints:
- You may modify `apps/api/package.json` and install required deps (e.g., `@nestjs/graphql`, `graphql`, `class-validator`, `class-transformer`, `@prisma/client`, testing libs).
- Use Conventional Commits. Keep commits atomic per change.
```

### `overnight/finish.md` (fault‑tolerant closer)
Finalize overnight work, still **continuing despite failures**, and prepare PRs for review.

```
1) Run lints, type checks and tests; fix trivial issues automatically. If a fix is risky, open a follow‑up commit or TODO.
2) Verify Prisma migrations apply cleanly on a fresh DB; if not, generate a corrective migration and update rollback notes.
3) Ensure every PR has a complete description (summary, risks, affected migrations, test steps, rollback, and list of blocked items if any).
4) If GitHub integration is available, mention @claude for summaries and follow‑ups.
5) Output a final overnight report: completed modules, partial modules, blocked modules (with failing commands and stack traces), and next actions.
```
