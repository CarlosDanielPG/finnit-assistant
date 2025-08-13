# 📚 User Stories – Finnit Assistant (MVP)

## 1. User Authentication & Security

**US-1** – As a user, I want to sign up with my email and password so I can create my account.
- **Acceptance Criteria:**
  - [ ] The system accepts valid email and password.
  - [ ] Password is hashed before storage.
  - [ ] Invalid email format returns an error.
  - [ ] Duplicate email registration is blocked.

**US-2** – As a user, I want to log in so I can access my account.
- **Acceptance Criteria:**
  - [ ] JWT is generated and returned on successful login.
  - [ ] Invalid credentials return an error.
  - [ ] Session tokens expire after configurable time.

**US-3** – As a user, I want to reset my password so I can regain access if I forget it.
- **Acceptance Criteria:**
  - [ ] A reset link is sent to the registered email.
  - [ ] Link expires after X hours.
  - [ ] Password update requires confirmation of the new password.

---

## 2. Accounts & Balances

**US-4** – As a user, I want a guided process to add an account so I understand each type.
- **Acceptance Criteria:**
  - [ ] Questionnaire explains account types (cash, debit, credit, savings, e-wallets).
  - [ ] Optional card photo fills in account metadata.
  - [ ] Default suggestion to create a cash account.

**US-5** – As a user, I want to set or adjust my account balance without affecting reports.
- **Acceptance Criteria:**
  - [ ] Adjustments do not create income/expense entries.
  - [ ] “Balance correction” entry is logged in audit trail.

**US-6** – As a user, I want to record transfers between my accounts so my reports remain accurate.
- **Acceptance Criteria:**
  - [ ] Transfers do not affect net income/expense.
  - [ ] Internal transfers are auto-detected if both accounts are linked.

---

## 3. Transactions

**US-7** – As a user, I want to quickly add a transaction so I can keep my records updated.
- **Acceptance Criteria:**
  - [ ] Fields: date, account, amount, type, category.
  - [ ] Save action takes < 2 seconds.

**US-8** – As a user, I want to upload a photo of a receipt so I can store proof of purchase.
- **Acceptance Criteria:**
  - [ ] Image upload is validated (size/type).
  - [ ] Image is stored securely in AWS S3.
  - [ ] Transaction is linked to the uploaded file.

**US-9** – As a user, I want transactions to be auto-categorized so I save time.
- **Acceptance Criteria:**
  - [ ] Merchant name triggers suggested category.
  - [ ] User can override category.
  - [ ] System learns from user changes.

**US-10** – As a user, I want to set recurring transactions as reminders so I don’t forget them.
- **Acceptance Criteria:**
  - [ ] Recurrence pattern: daily, weekly, monthly.
  - [ ] Reminders are not marked as expense until confirmed.
  - [ ] Calendar view shows upcoming recurring items.

**US-11** – As a user, I want to search transactions by filters so I can find records quickly.
- **Acceptance Criteria:**
  - [ ] Filters: date range, account, category, keyword.
  - [ ] Results load in < 2 seconds for 1,000+ records.

---

## 4. Categories

**US-12** – As a user, I want a default category list so I can start organizing quickly.
- **Acceptance Criteria:**
  - [ ] List is hierarchical (e.g., Food > Groceries).
  - [ ] Includes at least 15 default categories.

**US-13** – As a user, I want to create and edit my own categories so I can customize my budget.
- **Acceptance Criteria:**
  - [ ] CRUD for categories.
  - [ ] Custom categories can be nested under defaults.

---

## 5. Budgets

**US-14** – As a user, I want to set a monthly budget so I can track my spending.
- **Acceptance Criteria:**
  - [ ] Budgets can be global or category-based.
  - [ ] Assistant suggests budget amounts based on historical data.

**US-15** – As a user, I want to get alerts when I approach my budget so I can adjust my spending.
- **Acceptance Criteria:**
  - [ ] Alerts at 80% and 100% usage.
  - [ ] Suggestions for reducing spending are shown.

---

## 6. Debts & Credit Cards

**US-16** – As a user, I want to register debts so I can track repayments.
- **Acceptance Criteria:**
  - [ ] Debt type: loan or credit card.
  - [ ] Fields: principal, interest rate, min payment, due date.

**US-17** – As a user, I want to see payoff strategies so I can minimize interest.
- **Acceptance Criteria:**
  - [ ] Avalanche and snowball options explained.
  - [ ] Strategy shows repayment timeline.

---

## 7. Goals & Savings

**US-18** – As a user, I want to set financial goals so I can save towards them.
- **Acceptance Criteria:**
  - [ ] Goal has a target amount and due date.
  - [ ] Progress is tracked as I contribute.

---

## 8. Reports & Insights

**US-19** – As a user, I want to see a monthly summary so I can review my performance.
- **Acceptance Criteria:**
  - [ ] Summary shows income, expenses by category, net balance.
  - [ ] Compares current month with previous month.

**US-20** – As a user, I want to export my transactions to CSV so I can analyze them elsewhere.
- **Acceptance Criteria:**
  - [ ] CSV contains all visible transactions in current filters.

---

## 9. Bank & Fintech Integrations

**US-21** – As a user, I want to link my bank account so transactions import automatically.
- **Acceptance Criteria:**
  - [ ] Supports Belvo or Paybook connections.
  - [ ] Transactions sync at least daily.
  - [ ] Duplicates are avoided with matching logic.

**US-22** – As a user, I want a weekly reconciliation so I can verify my data.
- **Acceptance Criteria:**
  - [ ] Balance and recent transactions are displayed for review.
  - [ ] User can confirm or correct discrepancies.

---

## 10. Cash Flow & Projections

**US-23** – As a user, I want to see my cash flow forecast so I can plan ahead.
- **Acceptance Criteria:**
  - [ ] Shows projected balance for next 30/60 days.
  - [ ] Includes recurring transactions, debts, and goals.

**US-24** – As a user, I want to run “What If” scenarios so I can see the impact of financial changes.
- **Acceptance Criteria:**
  - [ ] User can simulate extra payments, income changes, new expenses.
  - [ ] Forecast updates instantly with scenario changes.

---

## 11. Essential Notifications

**US-25** – As a user, I want to receive budget alerts so I stay informed.
- **Acceptance Criteria:**
  - [ ] Notifications for budget usage (80%/100%).
  - [ ] Click opens budget details.

**US-26** – As a user, I want reminders for upcoming payments so I avoid late fees.
- **Acceptance Criteria:**
  - [ ] Notifications X days before due date.
  - [ ] Payment link or action is available from notification.

---
