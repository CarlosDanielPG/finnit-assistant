# Finnit Assistant

A modern monorepo built with Turborepo for the Finnit Assistant project.

## Project Structure

This project uses [Turborepo](https://turbo.build/repo) to manage a monorepo containing multiple applications and shared packages.

### Root Configuration

- **`turbo.json`**: Turborepo configuration defining build pipeline and task dependencies
- **`package.json`**: Root package configuration with workspace definitions
- **`yarn.lock`**: Lock file for dependency management

### Applications (`apps/`)

The project contains two Next.js applications:

#### `apps/web/`
- **Port**: 3000
- **Purpose**: Main web application
- **Features**:
  - Next.js 15 with Turbopack
  - React 19
  - TypeScript
  - ESLint configuration
  - Shared UI components

#### `apps/docs/`
- **Port**: 3001
- **Purpose**: Documentation site
- **Features**:
  - Next.js 15 with Turbopack
  - React 19
  - TypeScript
  - ESLint configuration
  - Shared UI components

### Shared Packages (`packages/`)

#### `packages/ui/`
- **Name**: `@repo/ui`
- **Purpose**: Shared React components library
- **Features**:
  - Reusable UI components
  - TypeScript support
  - ESLint configuration
  - Component generation utilities

#### `packages/eslint-config/`
- **Purpose**: Shared ESLint configuration
- **Configurations**:
  - `base.js`: Base ESLint rules
  - `next.js`: Next.js specific rules
  - `react-internal.js`: React internal rules

#### `packages/typescript-config/`
- **Purpose**: Shared TypeScript configuration
- **Configurations**:
  - `base.json`: Base TypeScript configuration
  - `nextjs.json`: Next.js specific configuration
  - `react-library.json`: React library configuration

## Database Integration

- [Database Monorepo Integration Guide](./database-monorepo-integration.md)

## Development Workflow

### Prerequisites
- Node.js >= 18
- Yarn package manager

### Available Scripts

#### Root Level
- `yarn build`: Build all applications and packages
- `yarn dev`: Start development servers for all applications
- `yarn lint`: Run linting across all packages
- `yarn format`: Format code using Prettier
- `yarn check-types`: Run TypeScript type checking

#### Application Level
- `yarn dev`: Start development server with Turbopack
- `yarn build`: Build for production
- `yarn start`: Start production server
- `yarn lint`: Run ESLint
- `yarn check-types`: Run TypeScript type checking

### Turborepo Features

#### Caching
- Build outputs are cached for faster subsequent builds
- Cache is stored in `.next` directories (excluding cache files)

#### Task Dependencies
- `build`: Depends on `^build` (builds dependencies first)
- `lint`: Depends on `^lint` (lints dependencies first)
- `check-types`: Depends on `^check-types` (type checks dependencies first)
- `dev`: No caching, persistent mode for development servers

#### Workspace Management
- Yarn workspaces for dependency management
- Shared packages are referenced using `@repo/*` naming convention
- Automatic dependency resolution between packages

## Architecture Decisions

### Monorepo Benefits
- **Code Sharing**: Shared UI components and configurations
- **Consistency**: Unified tooling and standards across applications
- **Efficiency**: Turborepo caching and parallel execution
- **Maintainability**: Centralized dependency management

### Technology Stack
- **Build Tool**: Turborepo for monorepo management
- **Framework**: Next.js 15 with App Router
- **Language**: TypeScript for type safety
- **Package Manager**: Yarn with workspaces
- **Linting**: ESLint with shared configurations
- **Formatting**: Prettier for consistent code style

## Getting Started

1. Clone the repository
2. Install dependencies: `yarn install`
3. Start development: `yarn dev`
4. Access applications:
   - Web app: http://localhost:3000
   - Docs: http://localhost:3001

## Contributing

Please refer to the development plan in `docs/development-plan.md` for current priorities and roadmap.
