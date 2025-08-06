# Project-Specific Rules

## Turborepo
- Use workspace dependencies correctly
- Follow monorepo best practices
- Cache build outputs appropriately
- Use proper task dependencies

## Next.js
- Use App Router patterns
- Optimize for server-side rendering
- Use proper loading and error boundaries
- Follow Next.js conventions

## React
- Use hooks for state management
- Avoid prop drilling
- Use context for global state
- Optimize with React.memo when needed

## TypeScript
- Use strict mode
- Define proper types for all data
- Avoid any type
- Use utility types when appropriate
- Export types from dedicated files

## Monorepo Structure
- Keep shared packages in `packages/`
- Keep applications in `apps/`
- Use `@repo/*` naming convention for internal packages
- Maintain consistent dependency versions across workspaces

## Development Environment
- Use Yarn as package manager
- Follow workspace dependency resolution
- Use Turborepo for build orchestration
- Maintain consistent Node.js version (>=18) 