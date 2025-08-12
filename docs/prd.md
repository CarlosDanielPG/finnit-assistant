# 📝 Product Requirements Document (PRD) – Finnit Assistant (MVP)

## 🧠 Project Overview

**Finnit Assistant** is a cross-platform personal finance assistant designed to simplify financial tracking, planning, and decision-making. It helps users manage **income, expenses, debts, savings, and projections** through a guided, interactive experience.
Unlike traditional finance apps, Finnit focuses on **personalized recommendations**, **strategic debt management**, and **cash flow projections** — combining automation, AI-assisted categorization, and seamless bank integrations.

---

## 🎯 MVP Goal

Deliver a functional prototype that allows a user to:

1. **Easily set up accounts and cards** with guided onboarding.
2. **Track income, expenses, transfers, and debts** with minimal friction.
3. **Connect to banks or fintechs** for automatic transaction import.
4. **View insights, budgets, and cash flow projections** in a clear dashboard.
5. **Receive contextual recommendations** and reminders for better financial health.
6. **Attach receipts and supporting documents** to transactions.
7. **Project different financial scenarios** with a “What If” simulator.

---

## ✅ Core Features (MVP)

### 1. User Authentication & Security
- [ ] Sign up/login with secure JWT-based auth.
- [ ] Password hashing, refresh tokens, and session handling.
- [ ] Single-tenant per account, roles: `owner`.
- [ ] Privacy guarantee: user data fully isolated.
- [ ] Account recovery via email.

---

### 2. Accounts & Balances
- [ ] Guided account creation with explanations of account types (cash, debit, credit, savings, e-wallets).
- [ ] Optional card photo scan to auto-fill details (name, last 4 digits, bank, color).
- [ ] Suggestions for default accounts (e.g., “Always create a cash account”).
- [ ] Balance adjustments without generating false income/expense.
- [ ] “Balance correction” transaction type for transparency.
- [ ] Clear difference between transfers and transactions, with examples.
- [ ] Automatic detection of internal transfers for linked accounts.

---

### 3. Transactions
- [ ] Quick add: date, account, amount, type (income/expense/transfer), category.
- [ ] Smart capture: receipt photos, SMS/notification parsing (where allowed).
- [ ] Auto-categorization based on merchant name with user learning.
- [ ] Recurring entries as reminders until confirmed as paid.
- [ ] Option to mark recurring payments as completed with proof.
- [ ] Auto-suggestion of recurrence from detected patterns.
- [ ] Calendar view + optional mobile widget.
- [ ] Attachments for receipts, invoices, payment confirmations.
- [ ] Integration with Banxico for CEP retrieval (interbank transfers).
- [ ] Search & filter by date, account, category, text.

---

### 4. Categories
- [ ] Default hierarchical category list (e.g., “Food > Groceries”).
- [ ] CRUD for user-defined categories with interactive UI.
- [ ] Merchant “memory rules” for auto-categorization.

---

### 5. Budgets
- [ ] Monthly and category-based budgets.
- [ ] Budget assistant that considers fixed expenses and historical spending.
- [ ] Real-time tracking with supportive suggestions.
- [ ] Alerts at 80%/100% usage with advice.

---

### 6. Debts & Credit Cards
- [ ] Guided registration for debts (loans, credit cards).
- [ ] Pre-filled parameters for known banks (editable).
- [ ] Custom interest rates for loans.
- [ ] Credit cards as special accounts with statement/payment dates.
- [ ] Avalanche and snowball payoff strategies with explanations.
- [ ] Calendar-based repayment plan.

---

### 7. Goals & Savings
- [ ] Goal setup with target amount and due date.
- [ ] Manual contributions and progress tracking.
- [ ] Suggestions to save when projected end-of-month balance is positive.

---

### 8. Reports & Insights
- [ ] Monthly summary: income, expenses by category, net balance.
- [ ] Insights: top categories, unusual expenses, comparisons.
- [ ] 3–6 month trends.
- [ ] CSV export.

---

### 9. Bank & Fintech Integrations
- [ ] Integration with Belvo, Paybook, or similar for auto-import.
- [ ] Weekly reconciliation for balances and transactions.
- [ ] Detection of internal transfers between linked accounts.

---

### 10. Cash Flow & Projections
- [ ] Cash flow forecast for 30/60 days with recurring transactions, debts, and goals.
- [ ] “What If” simulations for extra payments, income changes, or new expenses.

---

### 11. Essential Notifications
- [ ] Budget usage alerts (80%/100%).
- [ ] Upcoming credit card/loan payments.
- [ ] Recurring transaction reminders.
- [ ] Weekly/monthly summaries.

---

## 🔧 Tech Stack

| Layer        | Technology         |
|--------------|--------------------|
| Frontend     | Next.js (Vercel)   |
| Mobile       | React Native (Expo)|
| Backend      | NestJS (GraphQL)   |
| DB           | PostgreSQL (Railway)|
| Storage      | AWS S3             |
| Hosting      | Vercel (FE) + Railway (BE) |
| Bank APIs    | Belvo / Paybook    |

---

## 🗂️ Entities & Data Models (High-level)

- **User**: id, name, email, passwordHash
- **Account**: id, userId, type, name, balance, currency, metadata
- **Transaction**: id, accountId, type, amount, categoryId, date, description, attachmentUrl
- **Category**: id, userId, parentId, name
- **Debt**: id, userId, name, principal, interestRate, minPayment, statementDate, dueDate
- **Goal**: id, userId, name, targetAmount, dueDate, currentAmount
- **Notification**: id, userId, type, title, message, status
- **Attachment**: id, transactionId, fileUrl, fileType, uploadedAt

---

## 📈 Metrics of Success
- [ ] 80%+ of users complete account setup in < 5 minutes.
- [ ] 70%+ of users connect at least one bank account.
- [ ] Users log ≥ 10 transactions in their first month.
- [ ] ≥ 85% auto-categorization accuracy after 1 month (with feedback).
- [ ] Cash flow projection used by 50%+ of active users monthly.

---

## 🔄 Out of Scope (for MVP)
- Multi-user/shared accounts.
- Advanced AI recommendations beyond categorization.
- Tax reporting tools.
- Offline mode.
- Subscription billing.
