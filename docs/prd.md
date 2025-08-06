
# 📝 Product Requirements Document (PRD) - Finnit Assistant (MVP)

## 🧠 Project Overview

**Finnit Assistant** is a cross-platform personal finance assistant designed to help users track their income, expenses, and debts, and receive personalized recommendations to improve their financial health. Unlike traditional finance managers, Finnit aims to assist users with strategic decision-making, debt prioritization, and actionable financial advice, powered by automation and AI.

---

## 🎯 Goal of the MVP

Build a working prototype that allows a user to:

1. Register and authenticate securely.
2. Record income, expenses, and debts.
3. View financial summaries and analytics.
4. Receive simple suggestions for improving their financial status.
5. Upload and store related financial documents.

---

## ✅ Core Features (MVP)

### 1. **User Authentication**
- Sign up / login with JWT-based auth.
- Password hashing and session tokens.

### 2. **Transactions**
- Create income or expense transactions.
- Categorize transactions (food, rent, etc).
- View transaction history and summaries.
- Detect and flag recurring transactions.

### 3. **Debts**
- Register debts (credit cards, loans, etc).
- View total debt, minimum payment, interest.
- Track payment history.

### 4. **Dashboard**
- Summary of:
  - Current balance
  - Monthly income vs. expenses
  - Outstanding debts
- Simple financial health score.

### 5. **GraphQL API**
- Single endpoint serving all client apps.
- Query/mutation support for all core features.
- JWT-based context and guard support.

### 6. **File Upload**
- Upload receipts, invoices, or documents.
- Store files securely in AWS S3.

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

---

## 🗂️ Entities & Data Models

- **User**
  - id, name, email, passwordHash
- **Transaction**
  - id, userId, type (income/expense), amount, category, date, description
- **Debt**
  - id, userId, name, amount, interestRate, dueDate, minPayment, payments[]
- **Payment**
  - id, debtId, amount, date
- **File**
  - id, userId, fileUrl, type, uploadedAt

---

## 📈 Metrics of Success

- MVP deployed and usable by a single user account.
- User can register, login, and create/view transactions and debts.
- Financial dashboard renders correct totals and insights.
- GraphQL API is secured and usable by frontend and mobile apps.
- System is hosted with CI/CD enabled.

---

## 🔄 Not in scope (for MVP)

- Multi-user support / shared accounts
- Bank API integrations
- Advanced AI recommendation engine
- Notifications and reminders
- Offline support
- Subscription/payment model

---

This document is the foundational reference for the MVP phase and should be used by AI agents (Claude/Cursor), developers and contributors for task planning and execution.
