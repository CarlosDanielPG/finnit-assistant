
# 📅 Finnit Assistant - MVP Work Plan (Claude Code / Cursor Background Agent Compatible)

This plan defines the full breakdown of the MVP for Finnit Assistant, structured for background agent execution and compatibility with tools like Claude Code and Cursor.

---

## 🧠 CONTEXT LOAD (STEP 0)
**Goal:** Load initial project context for AI/agent tools.

### Tasks:
- Read the PRD (`docs/prd.md`).
- Understand tech stack: NestJS (GraphQL), React Native, Next.js, PostgreSQL (Prisma), AWS S3.
- Initialize `dev-plans/progress.md` to track completion.

---

## 🔧 BACKEND API - NESTJS + GRAPHQL (STEP 1)

### Tasks:
1. **Project Scaffold**
   - Create NestJS project with GraphQL setup.
   - Add Prisma + PostgreSQL integration.
   - Configure .env and initial DB connection.

2. **Entities & Models**
   - Define models: User, Transaction, Debt, Payment, File (in `schema.prisma`).
   - Generate Prisma client and run migrations.

3. **Auth Module**
   - Implement signup/login using JWT.
   - Hash passwords with bcrypt.
   - Add guards and decorators for auth context.

4. **GraphQL Schema**
   - Create types, queries and mutations:
     - `me`, `getDebts`, `getTransactions`
     - `createTransaction`, `createDebt`, `makePayment`, `uploadFile`

5. **Business Logic**
   - Implement services for transactions and debts.
   - Add logic for detecting recurring expenses.
   - Validate inputs and guard ownership.

6. **File Upload**
   - Integrate AWS SDK.
   - Create S3 client, signed upload URLs and file metadata saving.

7. **CI/CD**
   - Add GitHub Actions for lint, test and build.
   - Connect to Railway for deploy (auto on main).

---

## 📱 MOBILE APP - REACT NATIVE + EXPO (STEP 2)

### Tasks:
1. **Scaffold App**
   - Initialize Expo app with TypeScript.
   - Set up navigation (React Navigation).

2. **Authentication**
   - Screens: Login, Signup.
   - Connect with GraphQL auth flow.

3. **Dashboard**
   - Fetch financial summary from API.
   - Show income, expenses, debt overview.

4. **Transactions**
   - List transactions.
   - Create new transaction form.

5. **Debts**
   - List debts with current status.
   - Add new debt.
   - Make a payment.

6. **File Upload**
   - Pick document from phone.
   - Upload to S3 via signed URL from backend.

---

## 🌐 WEB APP - NEXT.JS (STEP 3)

### Tasks:
1. **Scaffold Next.js App**
   - Configure TypeScript + GraphQL client (Apollo/urql).
   - Setup basic routing.

2. **Auth**
   - Pages: Login, Signup.
   - Store and forward JWT.

3. **Dashboard UI**
   - Render financial summary, debt chart, transaction list.
   - Use ChakraUI or Tailwind for styling.

4. **Forms**
   - Add new transaction/debt/payment.
   - Handle file upload.

---

## 🧪 TESTING & MONITORING (STEP 4)

### Tasks:
1. Add unit tests (Jest) for critical backend services.
2. Optional: E2E tests with Playwright (web) or Detox (mobile).
3. Log key API errors and response times.

---

## ✅ DEPLOYMENT & VALIDATION (STEP 5)

### Tasks:
1. Deploy backend to Railway.
2. Deploy frontend to Vercel.
3. Generate `.env.example` and setup scripts.
4. Validate core flows: register → create debt → add transactions → see dashboard.

---

## 📈 FUTURE (Not part of MVP)

- Notification system (reminders for payments).
- AI-based recommendations.
- Multi-user support.
- Integration with bank APIs.

---

## 📁 Files Created

- `schema.prisma`
- `schema.graphql`
- `progress.md`
- `finnit_assistant_prd.md`

---

This plan is ready to be used as input for Claude Code or Cursor agents in plan/execution mode.
