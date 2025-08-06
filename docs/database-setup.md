# Database Setup

## Requirements

- Docker
- Docker Compose

## Configuration

### 1. Environment Variables

Create a `.env` file in the `packages/database/` directory with the following configuration:

```env
# PostgreSQL database configuration
DATABASE_URL="postgresql://finnit_user:finnit_password@localhost:5432/finnit_db?schema=public"

# Additional variables for development
NODE_ENV=development
```

### 2. Start the Services

From the project root directory:

```bash
# Start all services
docker-compose up -d

# View real-time logs
docker-compose logs -f postgres

# Stop services
docker-compose down
```

### 3. Available Services

- **PostgreSQL**: Port 5432
  - Database: `finnit_db`
  - User: `finnit_user`
  - Password: `finnit_password`

- **pgAdmin** (optional): Port 8080
  - URL: http://localhost:8080
  - Email: `admin@finnit.com`
  - Password: `admin123`

### 4. Useful Commands

```bash
# Connect to the database
docker exec -it finnit-postgres psql -U finnit_user -d finnit_db

# Run Prisma migrations
cd packages/database
npx prisma migrate dev

# Generate Prisma client
npx prisma generate

# View database status
npx prisma studio
```

### 5. Volumes

PostgreSQL data is stored in the `postgres_data` volume for persistence between restarts.

### 6. Health Check

The PostgreSQL service includes a health check to ensure the database is ready to accept connections.

## Troubleshooting

### Port 5432 in use
If port 5432 is already in use, modify the port mapping in `docker-compose.yml`:

```yaml
ports:
  - "5433:5432"  # Change 5432 to 5433
```

And update the DATABASE_URL:
```env
DATABASE_URL="postgresql://finnit_user:finnit_password@localhost:5433/finnit_db?schema=public"
```

### Reset everything from scratch
```bash
# Remove containers and volumes
docker-compose down -v

# Recreate everything
docker-compose up -d
```
