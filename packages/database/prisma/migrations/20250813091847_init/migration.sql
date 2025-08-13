-- CreateEnum
CREATE TYPE "public"."AccountType" AS ENUM ('cash', 'debit', 'credit', 'savings', 'ewallet');

-- CreateEnum
CREATE TYPE "public"."TransactionType" AS ENUM ('income', 'expense', 'transfer', 'adjustment');

-- CreateEnum
CREATE TYPE "public"."TransactionSource" AS ENUM ('manual', 'imported', 'ocr', 'sms');

-- CreateEnum
CREATE TYPE "public"."NotificationType" AS ENUM ('budget', 'debt_due', 'recurring', 'summary');

-- CreateEnum
CREATE TYPE "public"."NotificationStatus" AS ENUM ('scheduled', 'sent', 'read', 'dismissed');

-- CreateEnum
CREATE TYPE "public"."BankProvider" AS ENUM ('belvo', 'paybook', 'other');

-- CreateEnum
CREATE TYPE "public"."BankConnectionStatus" AS ENUM ('active', 'revoked', 'error');

-- CreateEnum
CREATE TYPE "public"."ReconciliationItemType" AS ENUM ('balance', 'transaction');

-- CreateEnum
CREATE TYPE "public"."ReconciliationState" AS ENUM ('confirmed', 'corrected', 'ignored');

-- CreateEnum
CREATE TYPE "public"."DebtKind" AS ENUM ('loan', 'card', 'other');

-- CreateEnum
CREATE TYPE "public"."RecurringFrequency" AS ENUM ('daily', 'weekly', 'monthly', 'custom');

-- CreateTable
CREATE TABLE "public"."User" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Account" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" "public"."AccountType" NOT NULL,
    "name" TEXT NOT NULL,
    "currency" VARCHAR(3) NOT NULL,
    "balanceCurrent" DECIMAL(18,2) NOT NULL,
    "metadata" JSONB,
    "archived" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."CreditCardTerms" (
    "accountId" TEXT NOT NULL,
    "statementDay" SMALLINT NOT NULL,
    "paymentDueDay" SMALLINT NOT NULL,
    "interestRateAnnual" DECIMAL(9,4),
    "minPaymentRule" TEXT,
    "gracePeriodDays" INTEGER,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CreditCardTerms_pkey" PRIMARY KEY ("accountId")
);

-- CreateTable
CREATE TABLE "public"."Category" (
    "id" TEXT NOT NULL,
    "userId" TEXT,
    "parentId" TEXT,
    "name" TEXT NOT NULL,
    "isDefault" BOOLEAN NOT NULL DEFAULT false,
    "sortOrder" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Transaction" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "categoryId" TEXT,
    "type" "public"."TransactionType" NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "currency" VARCHAR(3) NOT NULL,
    "txnDate" DATE NOT NULL,
    "description" TEXT,
    "merchantName" TEXT,
    "isPending" BOOLEAN NOT NULL DEFAULT false,
    "isRecurringInstance" BOOLEAN NOT NULL DEFAULT false,
    "source" "public"."TransactionSource" NOT NULL,
    "externalId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Transaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Transfer" (
    "id" TEXT NOT NULL,
    "fromTxnId" TEXT NOT NULL,
    "toTxnId" TEXT NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Transfer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Attachment" (
    "id" TEXT NOT NULL,
    "transactionId" TEXT NOT NULL,
    "fileUrl" TEXT NOT NULL,
    "fileType" TEXT NOT NULL,
    "fileSize" INTEGER,
    "extra" JSONB,
    "uploadedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Attachment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."RecurringRule" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "defaultAccountId" TEXT,
    "defaultCategoryId" TEXT,
    "frequency" "public"."RecurringFrequency" NOT NULL,
    "interval" SMALLINT NOT NULL,
    "byday" TEXT,
    "startDate" DATE NOT NULL,
    "endDate" DATE,
    "amount" DECIMAL(18,2) NOT NULL,
    "merchantName" TEXT,
    "autoConfirm" BOOLEAN NOT NULL DEFAULT false,
    "nextOccurrence" TIMESTAMP(3),
    "templateOverrides" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RecurringRule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Budget" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "year" SMALLINT NOT NULL,
    "month" SMALLINT NOT NULL,
    "currency" VARCHAR(3) NOT NULL,
    "amountTotal" DECIMAL(18,2),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Budget_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."BUDGET_CATEGORY" (
    "id" TEXT NOT NULL,
    "budgetId" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "capAmount" DECIMAL(18,2) NOT NULL,

    CONSTRAINT "BUDGET_CATEGORY_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Goal" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "targetAmount" DECIMAL(18,2) NOT NULL,
    "dueDate" DATE,
    "currentAmount" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "currency" VARCHAR(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Goal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."GoalContribution" (
    "id" TEXT NOT NULL,
    "goalId" TEXT NOT NULL,
    "transactionId" TEXT,
    "amount" DECIMAL(18,2) NOT NULL,
    "date" DATE NOT NULL,

    CONSTRAINT "GoalContribution_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Debt" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "kind" "public"."DebtKind" NOT NULL,
    "principal" DECIMAL(18,2) NOT NULL,
    "interestRateAnnual" DECIMAL(9,4),
    "minPaymentAmount" DECIMAL(18,2),
    "startDate" DATE,
    "dueDate" DATE,
    "linkedAccountId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Debt_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."DebtPayment" (
    "id" TEXT NOT NULL,
    "debtId" TEXT NOT NULL,
    "transactionId" TEXT NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "date" DATE NOT NULL,

    CONSTRAINT "DebtPayment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Notification" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" "public"."NotificationType" NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "status" "public"."NotificationStatus" NOT NULL DEFAULT 'scheduled',
    "scheduledAt" TIMESTAMP(3),
    "sentAt" TIMESTAMP(3),
    "relatedEntityId" TEXT,
    "relatedEntityType" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."BankConnection" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "provider" "public"."BankProvider" NOT NULL,
    "providerItemId" TEXT NOT NULL,
    "status" "public"."BankConnectionStatus" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BankConnection_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."LinkedAccount" (
    "id" TEXT NOT NULL,
    "bankConnectionId" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "providerAccountId" TEXT NOT NULL,
    "mask" TEXT,
    "officialName" TEXT,
    "type" TEXT,
    "currency" VARCHAR(3),

    CONSTRAINT "LinkedAccount_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ImportedTransaction" (
    "id" TEXT NOT NULL,
    "linkedAccountId" TEXT NOT NULL,
    "providerTxnId" TEXT NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "currency" VARCHAR(3) NOT NULL,
    "date" DATE NOT NULL,
    "merchant" TEXT,
    "raw" JSONB,
    "matchedTransactionId" TEXT,
    "importedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ImportedTransaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ReconciliationSession" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "endedAt" TIMESTAMP(3),
    "status" TEXT NOT NULL DEFAULT 'open',

    CONSTRAINT "ReconciliationSession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ReconciliationItem" (
    "id" TEXT NOT NULL,
    "sessionId" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "itemType" "public"."ReconciliationItemType" NOT NULL,
    "referenceId" TEXT NOT NULL,
    "state" "public"."ReconciliationState" NOT NULL,
    "details" JSONB,

    CONSTRAINT "ReconciliationItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Tag" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."TransactionTag" (
    "transactionId" TEXT NOT NULL,
    "tagId" TEXT NOT NULL,

    CONSTRAINT "TransactionTag_pkey" PRIMARY KEY ("transactionId","tagId")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "public"."User"("email");

-- CreateIndex
CREATE INDEX "Account_userId_idx" ON "public"."Account"("userId");

-- CreateIndex
CREATE INDEX "Account_userId_type_idx" ON "public"."Account"("userId", "type");

-- CreateIndex
CREATE INDEX "Category_userId_idx" ON "public"."Category"("userId");

-- CreateIndex
CREATE INDEX "Category_parentId_idx" ON "public"."Category"("parentId");

-- CreateIndex
CREATE UNIQUE INDEX "Transaction_externalId_key" ON "public"."Transaction"("externalId");

-- CreateIndex
CREATE INDEX "Transaction_userId_txnDate_idx" ON "public"."Transaction"("userId", "txnDate" DESC);

-- CreateIndex
CREATE INDEX "Transaction_userId_accountId_txnDate_idx" ON "public"."Transaction"("userId", "accountId", "txnDate" DESC);

-- CreateIndex
CREATE INDEX "Transaction_source_idx" ON "public"."Transaction"("source");

-- CreateIndex
CREATE UNIQUE INDEX "Transfer_fromTxnId_key" ON "public"."Transfer"("fromTxnId");

-- CreateIndex
CREATE UNIQUE INDEX "Transfer_toTxnId_key" ON "public"."Transfer"("toTxnId");

-- CreateIndex
CREATE INDEX "Attachment_transactionId_idx" ON "public"."Attachment"("transactionId");

-- CreateIndex
CREATE INDEX "Budget_userId_idx" ON "public"."Budget"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Budget_userId_year_month_key" ON "public"."Budget"("userId", "year", "month");

-- CreateIndex
CREATE INDEX "BUDGET_CATEGORY_categoryId_idx" ON "public"."BUDGET_CATEGORY"("categoryId");

-- CreateIndex
CREATE UNIQUE INDEX "BUDGET_CATEGORY_budgetId_categoryId_key" ON "public"."BUDGET_CATEGORY"("budgetId", "categoryId");

-- CreateIndex
CREATE INDEX "GoalContribution_goalId_date_idx" ON "public"."GoalContribution"("goalId", "date");

-- CreateIndex
CREATE INDEX "GoalContribution_transactionId_idx" ON "public"."GoalContribution"("transactionId");

-- CreateIndex
CREATE INDEX "Debt_userId_idx" ON "public"."Debt"("userId");

-- CreateIndex
CREATE INDEX "DebtPayment_debtId_date_idx" ON "public"."DebtPayment"("debtId", "date");

-- CreateIndex
CREATE UNIQUE INDEX "DebtPayment_transactionId_key" ON "public"."DebtPayment"("transactionId");

-- CreateIndex
CREATE INDEX "Notification_userId_status_idx" ON "public"."Notification"("userId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "BankConnection_providerItemId_key" ON "public"."BankConnection"("providerItemId");

-- CreateIndex
CREATE UNIQUE INDEX "LinkedAccount_providerAccountId_key" ON "public"."LinkedAccount"("providerAccountId");

-- CreateIndex
CREATE INDEX "LinkedAccount_bankConnectionId_idx" ON "public"."LinkedAccount"("bankConnectionId");

-- CreateIndex
CREATE INDEX "LinkedAccount_accountId_idx" ON "public"."LinkedAccount"("accountId");

-- CreateIndex
CREATE UNIQUE INDEX "ImportedTransaction_providerTxnId_key" ON "public"."ImportedTransaction"("providerTxnId");

-- CreateIndex
CREATE INDEX "ImportedTransaction_linkedAccountId_date_idx" ON "public"."ImportedTransaction"("linkedAccountId", "date");

-- CreateIndex
CREATE INDEX "ReconciliationItem_sessionId_idx" ON "public"."ReconciliationItem"("sessionId");

-- CreateIndex
CREATE INDEX "ReconciliationItem_accountId_idx" ON "public"."ReconciliationItem"("accountId");

-- CreateIndex
CREATE INDEX "Tag_userId_idx" ON "public"."Tag"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Tag_userId_name_key" ON "public"."Tag"("userId", "name");

-- AddForeignKey
ALTER TABLE "public"."Account" ADD CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."CreditCardTerms" ADD CONSTRAINT "CreditCardTerms_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "public"."Account"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Category" ADD CONSTRAINT "Category_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Category" ADD CONSTRAINT "Category_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "public"."Category"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Transaction" ADD CONSTRAINT "Transaction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Transaction" ADD CONSTRAINT "Transaction_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "public"."Account"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Transaction" ADD CONSTRAINT "Transaction_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "public"."Category"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Transfer" ADD CONSTRAINT "Transfer_fromTxnId_fkey" FOREIGN KEY ("fromTxnId") REFERENCES "public"."Transaction"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Transfer" ADD CONSTRAINT "Transfer_toTxnId_fkey" FOREIGN KEY ("toTxnId") REFERENCES "public"."Transaction"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Attachment" ADD CONSTRAINT "Attachment_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "public"."Transaction"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."RecurringRule" ADD CONSTRAINT "RecurringRule_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."RecurringRule" ADD CONSTRAINT "RecurringRule_defaultAccountId_fkey" FOREIGN KEY ("defaultAccountId") REFERENCES "public"."Account"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."RecurringRule" ADD CONSTRAINT "RecurringRule_defaultCategoryId_fkey" FOREIGN KEY ("defaultCategoryId") REFERENCES "public"."Category"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Budget" ADD CONSTRAINT "Budget_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BUDGET_CATEGORY" ADD CONSTRAINT "BUDGET_CATEGORY_budgetId_fkey" FOREIGN KEY ("budgetId") REFERENCES "public"."Budget"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BUDGET_CATEGORY" ADD CONSTRAINT "BUDGET_CATEGORY_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "public"."Category"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Goal" ADD CONSTRAINT "Goal_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."GoalContribution" ADD CONSTRAINT "GoalContribution_goalId_fkey" FOREIGN KEY ("goalId") REFERENCES "public"."Goal"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."GoalContribution" ADD CONSTRAINT "GoalContribution_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "public"."Transaction"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Debt" ADD CONSTRAINT "Debt_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Debt" ADD CONSTRAINT "Debt_linkedAccountId_fkey" FOREIGN KEY ("linkedAccountId") REFERENCES "public"."Account"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."DebtPayment" ADD CONSTRAINT "DebtPayment_debtId_fkey" FOREIGN KEY ("debtId") REFERENCES "public"."Debt"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."DebtPayment" ADD CONSTRAINT "DebtPayment_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "public"."Transaction"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Notification" ADD CONSTRAINT "Notification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."BankConnection" ADD CONSTRAINT "BankConnection_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."LinkedAccount" ADD CONSTRAINT "LinkedAccount_bankConnectionId_fkey" FOREIGN KEY ("bankConnectionId") REFERENCES "public"."BankConnection"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."LinkedAccount" ADD CONSTRAINT "LinkedAccount_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "public"."Account"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ImportedTransaction" ADD CONSTRAINT "ImportedTransaction_linkedAccountId_fkey" FOREIGN KEY ("linkedAccountId") REFERENCES "public"."LinkedAccount"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ImportedTransaction" ADD CONSTRAINT "ImportedTransaction_matchedTransactionId_fkey" FOREIGN KEY ("matchedTransactionId") REFERENCES "public"."Transaction"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ReconciliationSession" ADD CONSTRAINT "ReconciliationSession_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ReconciliationItem" ADD CONSTRAINT "ReconciliationItem_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "public"."ReconciliationSession"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ReconciliationItem" ADD CONSTRAINT "ReconciliationItem_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "public"."Account"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Tag" ADD CONSTRAINT "Tag_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."TransactionTag" ADD CONSTRAINT "TransactionTag_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "public"."Transaction"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."TransactionTag" ADD CONSTRAINT "TransactionTag_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "public"."Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;
