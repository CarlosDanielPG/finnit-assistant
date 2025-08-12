// prisma/seed.js
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  // 1) Demo user
  const user = await prisma.user.upsert({
    where: { email: 'demo@finnit.app' },
    update: {},
    create: {
      name: 'Demo User',
      email: 'demo@finnit.app',
      passwordHash: 'REPLACE_WITH_HASH',
    },
  });

  // 2) Default categories (simple level + some subcategories)
  const rootCats = [
    { name: 'Food', isDefault: true },
    { name: 'Housing', isDefault: true },
    { name: 'Transport', isDefault: true },
    { name: 'Health', isDefault: true },
    { name: 'Entertainment', isDefault: true },
    { name: 'Utilities', isDefault: true },
    { name: 'Shopping', isDefault: true },
    { name: 'Income', isDefault: true },
    { name: 'Fees', isDefault: true },
  ];

  const createdRoots = {};
  for (const rc of rootCats) {
    const c = await prisma.category.create({
      data: { name: rc.name, isDefault: rc.isDefault, userId: null },
    });
    createdRoots[rc.name] = c.id;
  }

  const subcats = [
    { name: 'Groceries', parent: 'Food' },
    { name: 'Restaurants', parent: 'Food' },
    { name: 'Rent/Mortgage', parent: 'Housing' },
    { name: 'Fuel', parent: 'Transport' },
    { name: 'Public Transport', parent: 'Transport' },
    { name: 'Internet', parent: 'Utilities' },
    { name: 'Electricity', parent: 'Utilities' },
    { name: 'Medical', parent: 'Health' },
    { name: 'Pharmacy', parent: 'Health' },
    { name: 'Salary', parent: 'Income' },
    { name: 'Freelance', parent: 'Income' },
    { name: 'Bank Fees', parent: 'Fees' },
  ];

  for (const sc of subcats) {
    await prisma.category.create({
      data: {
        name: sc.name,
        isDefault: true,
        userId: null,
        parentId: createdRoots[sc.parent],
      },
    });
  }

  // 3) Accounts: cash + credit card
  const cash = await prisma.account.create({
    data: {
      userId: user.id,
      type: 'cash',
      name: 'Cash Wallet',
      currency: 'MXN',
      balanceCurrent: 1500.00,
      metadata: { color: '#10B981', icon: 'wallet' },
    },
  });

  const credit = await prisma.account.create({
    data: {
      userId: user.id,
      type: 'credit',
      name: 'Credit Card BBVA',
      currency: 'MXN',
      balanceCurrent: -1200.00,
      metadata: { bank: 'BBVA', last4: '1234', color: '#1E3A8A' },
    },
  });

  await prisma.creditCardTerms.create({
    data: {
      accountId: credit.id,
      statementDay: 10,
      paymentDueDay: 25,
      interestRateAnnual: 0.3999,
      minPaymentRule: 'percent',
      gracePeriodDays: 20,
    },
  });

  // Helpers
  const today = new Date();
  const toDateOnly = (d) => new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate()));

  // 4) Transactions: income and expense
  const salaryCat = await prisma.category.findFirst({ where: { name: 'Salary', userId: null } });
  const groceriesCat = await prisma.category.findFirst({ where: { name: 'Groceries', userId: null } });

  const tIncome = await prisma.transaction.create({
    data: {
      userId: user.id,
      accountId: cash.id,
      type: 'income',
      amount: 20000.00,
      currency: 'MXN',
      txnDate: toDateOnly(today),
      description: 'Monthly salary',
      merchantName: 'ACME Corp',
      source: 'manual',
      categoryId: salaryCat?.id || null,
    },
  });

  const tExpense = await prisma.transaction.create({
    data: {
      userId: user.id,
      accountId: cash.id,
      type: 'expense',
      amount: 850.50,
      currency: 'MXN',
      txnDate: toDateOnly(today),
      description: 'Groceries at SuperMart',
      merchantName: 'SuperMart',
      source: 'manual',
      categoryId: groceriesCat?.id || null,
    },
  });

  // 5) Transfer: from cash to card (simulates payment)
  const tFrom = await prisma.transaction.create({
    data: {
      userId: user.id,
      accountId: cash.id,
      type: 'transfer',
      amount: 1000.00,
      currency: 'MXN',
      txnDate: toDateOnly(today),
      description: 'Transfer to credit card',
      source: 'manual',
    },
  });

  const tTo = await prisma.transaction.create({
    data: {
      userId: user.id,
      accountId: credit.id,
      type: 'transfer',
      amount: 1000.00,
      currency: 'MXN',
      txnDate: toDateOnly(today),
      description: 'Transfer from cash',
      source: 'manual',
    },
  });

  await prisma.transfer.create({
    data: {
      fromTxnId: tFrom.id,
      toTxnId: tTo.id,
      amount: 1000.00,
    },
  });

  // 6) Goal + contribution
  const goal = await prisma.goal.create({
    data: {
      userId: user.id,
      name: 'Emergency Fund',
      targetAmount: 30000.00,
      dueDate: null,
      currency: 'MXN',
      currentAmount: 0,
    },
  });

  await prisma.goalContribution.create({
    data: {
      goalId: goal.id,
      transactionId: tIncome.id, // aporte desde el salario
      amount: 3000.00,
      date: toDateOnly(today),
    },
  });

  // 7) Debt + payment (linked to transfer transaction to card)
  const debt = await prisma.debt.create({
    data: {
      userId: user.id,
      name: 'BBVA Credit',
      kind: 'card',
      principal: 1200.00,
      interestRateAnnual: 0.3999,
      minPaymentAmount: 200.00,
      linkedAccountId: credit.id,
    },
  });

  await prisma.debtPayment.create({
    data: {
      debtId: debt.id,
      transactionId: tTo.id, // el abono a la tarjeta
      amount: 1000.00,
      date: toDateOnly(today),
    },
  });

  // 8) Monthly budget (global)
  const now = new Date();
  const budget = await prisma.budget.upsert({
    where: {
      userId_year_month: {
        userId: user.id,
        year: now.getUTCFullYear(),
        month: now.getUTCMonth() + 1,
      },
    },
    update: {},
    create: {
      userId: user.id,
      year: now.getUTCFullYear(),
      month: now.getUTCMonth() + 1,
      currency: 'MXN',
      amountTotal: 15000.00,
    },
  });

  console.log('Seed ready:', {
    user: user.email,
    accounts: { cash: cash.name, credit: credit.name },
    budget: `${budget.year}-${budget.month}`,
  });
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
