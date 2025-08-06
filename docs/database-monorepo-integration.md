# Database Package Integration in a Turborepo Monorepo

This guide explains how to set up and consume the `@finnit/database` package (with Prisma) in a Turborepo monorepo, specifically for use with a NestJS API. It also covers common issues with ES/CommonJS modules and how to solve them.

---

## 1. Monorepo Structure

- `apps/api/` — Your NestJS API
- `packages/database/` — Shared database package (Prisma client, types, helpers)

## 2. Database Package Setup

**`packages/database/package.json`**
```json
{
  "name": "@finnit/database",
  "version": "0.0.0",
  "main": "./dist/index.js",
  "types": "./dist/index.d.ts",
  "exports": {
    ".": "./dist/index.js"
  },
  "scripts": {
    "build": "tsc -p tsconfig.json",
    "build:watch": "tsc -p tsconfig.json --watch"
  }
}
```

**`packages/database/tsconfig.json`**
```json
{
  "extends": "@finnit/typescript-config/base.json",
  "compilerOptions": {
    "module": "CommonJS",
    "moduleResolution": "node",
    "allowSyntheticDefaultImports": true,
    "esModuleInterop": true,
    "outDir": "dist",
    "rootDir": "src",
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*", "generated/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

- The Prisma client should be generated in `packages/database/generated/client`.
- Expose your Prisma client and types in `src/index.ts`:

```ts
export { prisma } from './client';
export * from '../generated/client';
```

## 3. Consuming the Database Package in the API

**`apps/api/package.json`**
```json
{
  "dependencies": {
    "@finnit/database": "*",
    // ...other dependencies
  }
}
```

**`apps/api/tsconfig.json`**
```json
{
  "compilerOptions": {
    "module": "CommonJS",
    "moduleResolution": "node",
    // ...other options
  }
}
```

**Usage Example:**
```ts
// apps/api/src/services/prisma.service.ts
import { PrismaClient } from '@finnit/database';

export class PrismaService extends PrismaClient {
  // ...
}
```

## 4. Turborepo Configuration

**`turbo.json`**
```json
{
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": [".next/**", "!.next/cache/**", "dist/**"]
    },
    "start:dev": {
      "dependsOn": ["^build"],
      "cache": false,
      "persistent": true
    }
  }
}
```

## 5. Development Commands

### Single Command to Start API (Recommended)
```bash
# From project root - automatically builds database and starts API
npm run api:dev
# or
yarn api:dev
```

### Manual Commands
```bash
# Build database package
cd packages/database && npm run build

# Start API (from apps/api)
npm run start:dev
```

### Turborepo Commands
```bash
# Build all packages
npm run build

# Start API with automatic dependencies
npm run start:api
```

## 6. Troubleshooting: Module Resolution Issues

### Problem: `Cannot find module .../src/client` or `ERR_MODULE_NOT_FOUND`

**Symptoms:**
- Node.js or TypeScript cannot resolve imports from the database package.
- Errors about missing `.js` extensions or module not found.

**Solution:**
- **Always compile the database package before using it in the API.**
- Ensure the database package exports compiled `.js` files from `dist/`.
- Use `npm run build` in the database package or `npm run api:dev` from root.
- Never import `.ts` files directly between packages in production.

### Problem: Types are not found when importing from `@finnit/database`

**Symptoms:**
- TypeScript cannot find types or Prisma types from the database package.

**Solution:**
- Make sure `types` in `package.json` points to `./dist/index.d.ts`.
- Ensure the Prisma client is generated and up to date (`npx prisma generate`).
- Check that your `tsconfig.json` includes the `generated` directory.

### Problem: NestJS dependency injection fails with `tsx`

**Symptoms:**
- `AppService is undefined` or similar dependency injection errors.

**Solution:**
- Use `nest start --watch` instead of `tsx watch src/main.ts`.
- The NestJS compiler handles dependency injection correctly.
- `tsx` is great for simple scripts but breaks NestJS's DI container.

---

## 7. Key Points

1. **Always compile the database package to JavaScript** before using it in the API.
2. **Use Turborepo dependencies** to automate the build process.
3. **Never import `.ts` files directly** between packages in production.
4. **Use NestJS compiler** for the API, not `tsx`.
5. **Keep Prisma client only in the database package**.

---

## 8. References
- [Prisma + Turborepo Docs](https://www.prisma.io/docs/guides/other/troubleshooting-orms/monorepo)
- [NestJS + Prisma Example](https://docs.nestjs.com/recipes/prisma)
- [Node.js Module Resolution](https://nodejs.org/api/modules.html)

---

If you encounter new issues, document them here for future reference.
