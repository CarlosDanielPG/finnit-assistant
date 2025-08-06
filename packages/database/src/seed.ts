import { prisma } from './client';

async function main() {
  // Create seed data
  await prisma.user.create({
    data: {
      email: 'test@test.com',
      password: 'test',
    },
  });
}

main()
  .catch(console.error)
  .finally(async () => {
    await prisma.$disconnect();
  });
