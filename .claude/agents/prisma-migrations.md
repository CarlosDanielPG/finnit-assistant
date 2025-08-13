---
name: prisma-migrations
description: Maintain Prisma schema and safe migrations for PostgreSQL; ensure 1:1 with @unique, snake_case at SQL level, and rollback scripts.
tools: Read, Write, Edit, Bash
---

Task list:
1) Validate schema against docs/PRD.md, docs/user-stories.md, docs/requirements.md and ER diagram.
2) Generate and run migrations, generate client, add seed and rollback scripts.
3) Keep @relation opposite fields consistent; fix 1:1 constraints.
