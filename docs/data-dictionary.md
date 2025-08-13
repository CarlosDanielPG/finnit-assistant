# 📘 Data Dictionary – Finnit Assistant (MVP)

**Conventions**
- `uuid`: unique identifier (UUID v4).
- `numeric`: uses recommended precision `numeric(18,2)` for amounts.
- `timestamptz`: timestamp with timezone (UTC).
- `date`: date without time.
- `jsonb`: validated JSON.
- Currency: **ISO-4217** code (e.g., `MXN`, `USD`).
- Suggested Enums (or `CHECK`):
  - `account.type`: `cash|debit|credit|savings|ewallet`
  - `transaction.type`: `income|expense|transfer|adjustment`
  - `transaction.source`: `manual|imported|ocr|sms`
  - `notification.type`: `budget|debt_due|recurring|summary`
  - `notification.status`: `scheduled|sent|read|dismissed`
  - `bank_connection.provider`: `belvo|paybook|other`
  - `bank_connection.status`: `active|revoked|error`
  - `reconciliation_item.item_type`: `balance|transaction`
  - `reconciliation_item.state`: `confirmed|corrected|ignored`
  - `debt.kind`: `loan|card|other`
  - `recurring_rule.frequency`: `daily|weekly|monthly|custom`

---

## Table: `user`
Field | Type | Req | Description | Notes
---|---|---|---|---
id | uuid | ✔ | User identifier | PK
name | text | ✔ | Display name | —
email | text | ✔ | Unique access email | UK, email format
password_hash | text | ✔ | Password hash | Argon2/BCrypt recommended
created_at | timestamptz | ✔ | Creation date | Set by server
updated_at | timestamptz | ✔ | Last update | Set by server

---

## Table: `account`
Field | Type | Req | Description | Notes
---|---|---|---|---
id | uuid | ✔ | Account identifier | PK
user_id | uuid | ✔ | Owner | FK→user.id
type | text | ✔ | Account type | Enum `cash|debit|credit|savings|ewallet`
name | text | ✔ | Visible account name | Customizable
currency | text | ✔ | Base currency of the account | ISO-4217
balance_current | numeric | ✔ | Current balance cached | Recalculable
metadata | jsonb | — | Metadata (bank, color, last4, icon) | Free
archived | boolean | ✔ | Archived indicator | Hidden in UI
created_at | timestamptz | ✔ | Creation | —
updated_at | timestamptz | ✔ | Update | —

---

## Table: `credit_card_terms`
Field | Type | Req | Description | Notes
---|---|---|---|---
account_id | uuid | ✔ | Credit card account | PK+FK→account.id
statement_day | int2 | ✔ | Statement day (1–28) | —
payment_due_day | int2 | ✔ | Payment due day (1–28) | —
interest_rate_annual | numeric | — | Estimated annual interest rate | %
min_payment_rule | text | — | Minimum payment rule | `fixed|percent|provider`
grace_period_days | int2 | — | Grace period days | —
updated_at | timestamptz | ✔ | Update | —

---

## Table: `category`
Field | Type | Req | Description | Notes
---|---|---|---|---
id | uuid | ✔ | Category identifier | PK
user_id | uuid | — | Owner (null if default) | FK→user.id, allows global
parent_id | uuid | — | Parent category | FK→category.id
name | text | ✔ | Category name | —
is_default | boolean | ✔ | Default category marker | Read-only for system
sort_order | int2 | — | Suggested order | UI
created_at | timestamptz | ✔ | Creation | —

---

## Table: `transaction`
Field | Type | Req | Description | Notes
---|---|---|---|---
id | uuid | ✔ | Transaction identifier | PK
user_id | uuid | ✔ | Owner | FK→user.id
account_id | uuid | ✔ | Affected account | FK→account.id
category_id | uuid | — | Assigned category | FK→category.id
type | text | ✔ | Transaction type | Enum `income|expense|transfer|adjustment`
amount | numeric | ✔ | Positive amount | Implicit sign by `type`
currency | text | ✔ | Transaction currency | ISO-4217
txn_date | date | ✔ | Effective date | —
description | text | — | Free description | —
merchant_name | text | — | Merchant name | For auto-categorization
is_pending | boolean | ✔ | Pending marker | Imported
is_recurring_instance | boolean | ✔ | Comes from recurring rule | Not confirmed until validated
transfer_id | uuid | — | Relation to transfer | FK→transfer.id
source | text | ✔ | Capture source | `manual|imported|ocr|sms`
external_id | text | — | Provider transaction ID | UK by provider
created_at | timestamptz | ✔ | Creation | —
updated_at | timestamptz | ✔ | Update | —

---

## Table: `transfer`
Field | Type | Req | Description | Notes
---|---|---|---|---
id | uuid | ✔ | Transfer identifier | PK
from_txn_id | uuid | ✔ | Outgoing transaction | UK+FK→transaction.id
to_txn_id | uuid | ✔ | Incoming transaction | UK+FK→transaction.id
amount | numeric | ✔ | Transferred amount | Must match both sides
created_at | timestamptz | ✔ | Creation | —

---

## Table: `attachment`
Field | Type | Req | Description | Notes
---|---|---|---|---
id | uuid | ✔ | Attachment identifier | PK
transaction_id | uuid | ✔ | Associated transaction | FK→transaction.id
file_url | text | ✔ | Location (S3) | URL/Key
file_type | text | ✔ | MIME type | e.g., `image/jpeg`
file_size | int4 | — | Size in bytes | Validations
extra | jsonb | — | Metadata (CEP, OCR, etc.) | Free
uploaded_at | timestamptz | ✔ | Upload date | —

---

## Table: `recurring_rule`
Field | Type | Req | Description | Notes
---|---|---|---|---
id | uuid | ✔ | Rule identifier | PK
user_id | uuid | ✔ | Owner | FK→user.id
default_account_id | uuid | — | Default account | FK→account.id
default_category_id | uuid | — | Default category | FK→category.id
frequency | text | ✔ | Base frequency | `daily|weekly|monthly|custom`
interval | int2 | ✔ | Every N units | —
byday | text | — | Days (MO,TU,...) | iCal-like
start_date | date | ✔ | Start date | —
end_date | date | — | End date | Optional
amount | numeric | ✔ | Suggested amount | —
merchant_name | text | — | Typical merchant | For matching
auto_confirm | boolean | ✔ | Auto-post on match | Careful
next_occurrence | timestamptz | — | Next occurrence | Cache
template_overrides | jsonb | — | Overrides (transaction fields) | —
created_at | timestamptz | ✔ | Creation | —
updated_at | timestamptz | ✔ | Update | —

---

## Table: `budget`
Field | Type | Req | Description | Notes
---|---|---|---|---
id | uuid | ✔ | Budget identifier | PK
user_id | uuid | ✔ | Owner | FK→user.id
year | int2 | ✔ | Year | —
month | int2 | ✔ | Month (1–12) | —
currency | text | ✔ | Budget currency | ISO-4217
amount_total | numeric | — | Global monthly limit | Optional
created_at | timestamptz | ✔ | Creation | —

---

## Table: `budget_category`
Field | Type | Req | Description | Notes
---|---|---|---|---
id | uuid | ✔ | Identifier | PK
budget_id | uuid | ✔ | Parent budget | FK→budget.id
category_id | uuid | ✔ | Top category | FK→category.id
cap_amount | numeric | ✔ | Category limit | —

---

## Table: `goal`
Field | Type | Req | Description | Notes
---|---|---|---|---
id | uuid | ✔ | Goal identifier | PK
user_id | uuid | ✔ | Owner | FK→user.id
name | text | ✔ | Goal name | —
target_amount | numeric | ✔ | Target amount | —
due_date | date | — | Due date | Optional
current_amount | numeric | ✔ | Progress cache | Recalculated by contributions
currency | text | ✔ | Currency | ISO-4217
created_at | timestamptz | ✔ | Creation | —

---

## Table: `goal_contribution`
Field | Type | Req | Description | Notes
---|---|---|---|---
id | uuid | ✔ | Identifier | PK
goal_id | uuid | ✔ | Associated goal | FK→goal.id
transaction_id | uuid | — | Supporting transaction | FK→transaction.id
amount | numeric | ✔ | Contribution amount | —
date | date | ✔ | Contribution date | —

---

## Table: `debt`
Field | Type | Req | Description | Notes
---|---|---|---|---
id | uuid | ✔ | Debt identifier | PK
user_id | uuid | ✔ | Owner | FK→user.id
name | text | ✔ | Name (e.g., “Auto BBVA”) | —
kind | text | ✔ | Debt type | `loan|card|other`
principal | numeric | ✔ | Principal pending | —
interest_rate_annual | numeric | — | Annual interest rate | %
min_payment_amount | numeric | — | Minimum payment | Can derive from rule
start_date | date | — | Credit start date | —
due_date | date | — | Due date/payment date | Card: payment date
linked_account_id | uuid | — | Linked account | FK→account.id
created_at | timestamptz | ✔ | Creation | —

---

## Table: `debt_payment`
Field | Type | Req | Description | Notes
---|---|---|---|---
id | uuid | ✔ | Identifier | PK
debt_id | uuid | ✔ | Paid debt | FK→debt.id
transaction_id | uuid | ✔ | Payment transaction | FK→transaction.id
amount | numeric | ✔ | Payment amount | —
date | date | ✔ | Payment date | —

---

## Table: `notification`
Field | Type | Req | Description | Notes
---|---|---|---|---
id | uuid | ✔ | Identifier | PK
user_id | uuid | ✔ | Receptor | FK→user.id
type | text | ✔ | Notification type | `budget|debt_due|recurring|summary`
title | text | ✔ | Short title | —
message | text | ✔ | Message | —
status | text | ✔ | Status | `scheduled|sent|read|dismissed`
scheduled_at | timestamptz | — | Scheduled for | —
sent_at | timestamptz | — | Send date | —
related_entity_id | uuid | — | Related entity | Polymorphic
related_entity_type | text | — | Related entity type | Logical name

---

## Table: `bank_connection`
Field | Type | Req | Description | Notes
---|---|---|---|---
id | uuid | ✔ | Identifier | PK
user_id | uuid | ✔ | Owner | FK→user.id
provider | text | ✔ | Provider | `belvo|paybook|other`
provider_item_id | text | ✔ | Provider item ID | UK
status | text | ✔ | Connection status | `active|revoked|error`
created_at | timestamptz | ✔ | Creation | —
updated_at | timestamptz | ✔ | Update | —

---

## Table: `linked_account`
Field | Type | Req | Description | Notes
---|---|---|---|---
id | uuid | ✔ | Identifier | PK
bank_connection_id | uuid | ✔ | Source connection | FK→bank_connection.id
account_id | uuid | ✔ | Local account | FK→account.id
provider_account_id | text | ✔ | Provider account ID | UK
mask | text | — | Mask (last 4) | —
official_name | text | — | Official bank name | —
type | text | — | Reported by provider | —
currency | text | — | Reported currency | ISO-4217

---

## Table: `imported_transaction`
Field | Type | Req | Description | Notes
---|---|---|---|---
id | uuid | ✔ | Identifier | PK
linked_account_id | uuid | ✔ | Linked account | FK→linked_account.id
provider_txn_id | text | ✔ | Provider transaction ID | UK
amount | numeric | ✔ | Reported amount | —
currency | text | ✔ | Currency | ISO-4217
date | date | ✔ | Operation date | —
merchant | text | — | Reported merchant | —
raw | jsonb | — | Original payload | Debug/mapping
matched_transaction_id | uuid | — | Local matched transaction | FK→transaction.id
imported_at | timestamptz | ✔ | Import date | —

---

## Table: `reconciliation_session`
Field | Type | Req | Description | Notes
---|---|---|---|---
id | uuid | ✔ | Identifier | PK
user_id | uuid | ✔ | Owner | FK→user.id
started_at | timestamptz | ✔ | Start date | —
ended_at | timestamptz | — | End date | —
status | text | ✔ | Status | `open|closed`

---

## Table: `reconciliation_item`
Field | Type | Req | Description | Notes
---|---|---|---|---
id | uuid | ✔ | Identifier | PK
session_id | uuid | ✔ | Associated session | FK→reconciliation_session.id
account_id | uuid | ✔ | Reviewed account | FK→account.id
item_type | text | ✔ | Item type | `balance|transaction`
reference_id | uuid | ✔ | Reference (txn/snapshot) | Polymorphic
state | text | ✔ | Result | `confirmed|corrected|ignored`
details | jsonb | — | Correction details | Before/after

---

## Table: `tag`
Field | Type | Req | Description | Notes
---|---|---|---|---
id | uuid | ✔ | Identifier | PK
user_id | uuid | ✔ | Owner | FK→user.id
name | text | ✔ | Unique tag name | UK by user
created_at | timestamptz | ✔ | Creation | —

---

## Table: `transaction_tag`
Field | Type | Req | Description | Notes
---|---|---|---|---
transaction_id | uuid | ✔ | Tagged transaction | FK→transaction.id
tag_id | uuid | ✔ | Applied tag | FK→tag.id
