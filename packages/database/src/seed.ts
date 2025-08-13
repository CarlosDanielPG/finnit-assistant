import { prisma } from './client';

async function main() {
  // Create seed data
  await prisma.user.create({
    data: {
      email: 'test@test.com',
      passwordHash: 'test',
      name: 'Test User',
    },
  });
}

main()
  .catch(console.error)
  .finally(async () => {
    await prisma.$disconnect();
  });
