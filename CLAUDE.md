# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Finnit Assistant is a financial management application built as a Turborepo monorepo containing a NestJS API, React Native mobile app, and shared database package with comprehensive financial modeling using Prisma.

## Guardrails (Non-Negotiables)

- **Language and Style**: Strict TypeScript throughout the repo; code and naming in **English** (UI copy can be localized separately).
- **DB/Prisma**: Use **snake_case** for tables and columns in SQL; 1:1 relationships require `@unique`; avoid destructive cascades except in pivot tables; every migration must have a documented **rollback script**.
- **GraphQL**: Code-first in NestJS; strict inputs vs outputs; **cursor-based** pagination; typed errors.
- **Commits/PRs**: *Conventional Commits* conventions; each PR includes: summary, risks, affected migrations, test steps, and rollback plan.
- **Minimum DoD**: clean lints and types; tests pass; `docs/PRD.md` updates *Scope implemented* section; migration applied and verified locally.

## Project Context Sources (How to Provide Context to Claude Code)

Claude Code takes context from three main sources:

1) **Local Repository** (recommended for short PRD and key assets)
   - Place documents in `docs/` and reference exact paths in tasks.
   - Maintain an **index** (see below) so Claude can quickly locate files.

2) **Slash Commands** (reusable prompts that load/read docs)
   - Create files in `.claude/commands/` to standardize how Claude reads `docs/` and executes repeatable steps (plan → implement → test → PR).
   - Examples below.

3) **MCP (Model Context Protocol)** for external sources (Drive/Jira/GitHub)
   - Use this if PRD/User Stories live in Google Drive or if you want Claude to sync changes.
   - Connect the **Google Drive** server from Claude (desktop or CLI) and grant permissions; then reference files by ID or connector path.

> References: *Project memory/CLAUDE.md*, *Slash Commands*, *MCP & Google Drive*.

### Docs Index (canonical path inside the repo)

- `docs/PRD.md`
- `docs/user-stories.md`
- `docs/db/er-diagram.png` (or `.svg`)
- `packages/database/prisma/schema.prisma`
- `docs/tech-stack.md`

> Keep these names/paths stable so Claude can always find them.

### Recommended Flow to Load Context in a Session

1. **Start Claude at the root of the monorepo** and confirm it detects `CLAUDE.md`.
2. Ask: *"Read `docs/PRD.md` and `docs/user-stories.md`, validate assumptions and return a feature map of the MVP."*
3. If using **Drive via MCP**, tell it: *"Read @gdrive:/Finnit/PRD.md and @gdrive:/Finnit/UserStories.md; synchronize findings with `docs/` if they differ."*
4. Use the slash commands below to execute stories with the same checklist.

## Suggested Slash Commands (paste as files in `.claude/commands/`)

### `plan/feature.md`
Generate an executable plan for a story/feature.

```
Read $ARGUMENTS + docs/PRD.md + docs/user-stories.md and deliver:
- Objective and acceptance criteria (DoD)
- Changes in `schema.prisma` (if applicable) and migration
- GraphQL Endpoints/Resolvers
- Tasks by package (api/web/mobile)
- Risks and testing
```

### `impl/story.md`
Implement an end-to-end story with standard checklist.

```
1) Update `packages/database/prisma/schema.prisma` (if applicable)
2) Run: db:migrate:dev, db:generate
3) Implement resolvers/services in `apps/api`
4) Implement UI/hook in web or mobile (depending on story)
5) Add minimal tests
6) Open PR with description, risks, test steps and rollback
```

### `review/code.md`
Static review and refactor suggestions.

```
- Review lints/types, detect code smells, technical debt and modularization opportunities.
- Propose changes with concise diffs and affected tests.
```

## Migration Policy (Operational Summary)

- Every 1:1 relation must have `@unique` on the defining side.
- For *transfers* and *goal contributions*: validate that the `@relation` have opposite sides defined in `Transaction` and unique keys where applicable.
- Add **seed** and **rollback** scripts for critical data.

## GraphQL Conventions

- Inputs separated from outputs; never expose Prisma entities without DTOs.
- Cursor-based pagination; typed errors; mandatory `codegen`.

## Development Commands

### Root Level Commands
- `yarn dev` - Start all development servers
- `yarn build` - Build all applications and packages
- `yarn lint` - Run linting across all packages
- `yarn format` - Format code using Prettier
- `yarn check-types` - Run TypeScript type checking across all workspaces

### API Development (`apps/api/`)
- `turbo run start:dev --filter=@finnit/api` - Start API in development mode
- `yarn api:dev` - Build database and start API (includes database build)
- `yarn start:api` - Alternative API start command

### Database Management (`packages/database/`)
- `turbo run db:migrate:dev --filter=@finnit/database` - Run database migrations in development
- `turbo run db:push --filter=@finnit/database` - Push schema to database
- `turbo run db:generate --filter=@finnit/database` - Generate Prisma client
- `turbo run studio --filter=@finnit/database` - Open Prisma Studio
- `turbo run db:seed --filter=@finnit/database` - Seed database

### Mobile App (`apps/finnit-app/`)
- `turbo run start --filter=finnit-app` - Start Expo development server
- `turbo run android --filter=finnit-app` - Run on Android
- `turbo run ios --filter=finnit-app` - Run on iOS
- `turbo run web --filter=finnit-app` - Run on web

### Testing
- API tests: `turbo run test --filter=@finnit/api` (Jest)
- E2E tests: `turbo run test:e2e --filter=@finnit/api`

## Architecture Overview

### Monorepo Structure
- **Turborepo** orchestrates builds and caching across workspaces
- **Yarn workspaces** for dependency management
- Shared packages use `@finnit/*` naming convention
- Each workspace has its own package.json with specific scripts

### Applications
1. **API** (`apps/api/`) - NestJS REST API with Prisma integration
   - Port: 3000 (configurable via PORT env var)
   - Dependencies: `@finnit/database` for data access
   - Structure: Controllers → Services → Prisma repositories

2. **Mobile App** (`apps/finnit-app/`) - React Native with Expo
   - Uses Expo Router for navigation
   - TypeScript throughout
   - Shared UI components and hooks

### Shared Packages
1. **Database** (`packages/database/`) - Prisma client and schema
   - PostgreSQL database with comprehensive financial modeling
   - Generated client exported from `packages/database/src/index.ts`
   - Singleton Prisma client pattern for connection management

2. **ESLint Config** (`packages/eslint-config/`) - Shared linting rules
3. **TypeScript Config** (`packages/typescript-config/`) - Shared TS configurations
4. **UI** (`packages/ui/`) - Shared React components (if exists)

### Database Schema Design
The Prisma schema includes comprehensive financial modeling:
- **Users & Authentication** - Basic user management
- **Accounts** - Multiple account types (cash, credit, debit, savings, ewallet) with metadata
- **Transactions** - Full transaction lifecycle with categories, attachments, and reconciliation
- **Budgeting & Goals** - Budget management and financial goal tracking
- **Recurring Patterns** - Support for recurring transactions and rules
- **Bank Integration** - Connect external bank accounts via providers like Belvo/Paybook
- **Debt Management** - Track loans, credit cards, and payment schedules
- **Notifications** - In-app notification system
- **Import & Reconciliation** - Transaction import and reconciliation workflows

## Development Guidelines

### Code Standards (from .cursor/rules/)
- All code must be in TypeScript and English
- Use Prettier for formatting, ESLint for linting
- camelCase for variables/functions, PascalCase for components/classes
- Functional components with hooks for React
- Keep files under 300 lines when possible

### Workflow Requirements
- Read `docs/development-plan.md` before starting work
- Follow conventional commit messages
- Run `yarn lint`, `yarn format`, and `yarn check-types` before submitting
- Write tests alongside code
- Update documentation as needed

### Monorepo Best Practices
- Use workspace dependencies correctly (`@finnit/*` for internal packages)
- Follow Turborepo task dependencies (build depends on ^build)
- Maintain consistent dependency versions across workspaces
- Use proper caching for build outputs

## Database Workflow

### Development Setup
1. Set `DATABASE_URL` in environment
2. Run `turbo run db:generate --filter=@finnit/database` to generate client
3. Run `turbo run db:migrate:dev --filter=@finnit/database` for schema migration
4. Optional: `turbo run db:seed --filter=@finnit/database` for test data

### Schema Changes
1. Modify `packages/database/prisma/schema.prisma`
2. Run `turbo run db:migrate:dev --filter=@finnit/database --` to create migration
3. Run `turbo run db:generate --filter=@finnit/database` to update generated client
4. The API will automatically use the updated types

## Technology Stack Requirements
- **Runtime**: Node.js >=18
- **Package Manager**: Yarn (required, not npm)
- **Database**: PostgreSQL
- **API Framework**: NestJS with Prisma ORM
- **Mobile**: React Native with Expo
- **Language**: TypeScript throughout (strict mode)
- **Build Tool**: Turborepo for monorepo orchestration

## Environment Setup
- Development requires `DATABASE_URL` for Prisma
- API port configurable via `PORT` environment variable (default: 3000)
- Mobile app uses Expo development server (multiple platform targets)

## Key Integration Points
- API consumes `@finnit/database` package for all data operations
- Mobile app will connect to API endpoints
- Shared configurations via `@finnit/eslint-config` and `@finnit/typescript-config`
- All packages follow consistent TypeScript and ESLint configurations
