# Environment Variables Guide

This project uses .env files loaded by shell scripts instead of dotenv packages for better production practices.

## Available .env Files

- `.env` - Base environment variables (loaded first)
- `.env.development` - Development environment (port 3000)
- `.env.production` - Production environment (port 3001)
- `.env.test` - Testing environment (port 3002)
- `.env.example` - Template with all available variables

## Required Environment Variables

### Core API Configuration

- `PUBLIC_SALEOR_API_URL` - Saleor GraphQL API URL
- `PUBLIC_STOREFRONT_URL` - Your storefront URL

### Optional Configuration

- `NODE_ENV` - Environment mode (automatically set by SvelteKit)
- `PORT` - Server port (defaults: dev=3000, prod=3001, test=3002)

## Using Environment Files

### Development Commands

```bash
# Development server with .env.development
pnpm run dev:local
pnpm run start:dev
pnpm run serve:dev

# GraphQL generation with .env.development
pnpm run generate:dev
```

### Production Commands

```bash
# Production server with .env.production
pnpm run start:prod
pnpm run serve:prod

# GraphQL generation with .env.production
pnpm run generate:prod
```

### Testing Commands

```bash
# Tests with .env.test
pnpm run test
pnpm run test:headed
pnpm run test:debug

# Test server with .env.test
pnpm run start:test
pnpm run serve:test
```

## Manual Environment Loading

For custom scripts or manual operations:

```bash
# Load development environment
source scripts/load-env.sh development
echo "API URL: $PUBLIC_SALEOR_API_URL"

# Run command with specific environment
./scripts/with-env.sh production -- your-command

# Run GraphQL generation with specific environment
./scripts/generate.sh production
```

## Environment File Structure

### .env.development

```bash
# Development environment
PUBLIC_SALEOR_API_URL=https://your-saleor.com/graphql/
PUBLIC_STOREFRONT_URL=http://127.0.0.1:3000
PORT=3000
```

### .env.production

```bash
# Production environment
PUBLIC_SALEOR_API_URL=https://your-saleor.com/graphql/
PUBLIC_STOREFRONT_URL=https://your-domain.com
PORT=3001
```

### .env.test

```bash
# Testing environment
PUBLIC_SALEOR_API_URL=https://your-saleor.com/graphql/
PUBLIC_STOREFRONT_URL=http://127.0.0.1:3002
PORT=3002
```

## Deployment Considerations

### Docker

```dockerfile
# Copy .env files
COPY .env* ./

# Use environment-specific commands
CMD ["pnpm", "run", "start:prod"]
```

### Vercel/Cloud Platforms

For cloud deployment, set environment variables in platform dashboard:

- Copy values from your .env.production
- Set PUBLIC_STOREFRONT_URL to your domain
- Platform will override .env files

### CI/CD

```yaml
# GitHub Actions example
- name: Run tests
  run: pnpm run test
  env:
    PUBLIC_SALEOR_API_URL: ${{ secrets.SALEOR_API_URL }}
```

## Migration from dotenv

If upgrading from dotenv version:

1. **Keep your .env files** - they work the same way
2. **Update commands** - use new npm scripts
3. **Remove dotenv packages** - already done
4. **Test environments** - verify each environment loads correctly

## Script Architecture

### scripts/load-env.sh

- Loads base .env first, then environment-specific
- Validates required variables
- Provides feedback on loading status

### scripts/with-env.sh

- Wrapper to run commands with loaded environment
- Usage: `./scripts/with-env.sh [env] -- command`
- Supports development, production, test environments

### Benefits of This Approach

- ✅ **No runtime dependencies** - no dotenv packages
- ✅ **Shell compatibility** - works in any Unix shell
- ✅ **Environment isolation** - clear separation of concerns
- ✅ **Debugging friendly** - can see what's loaded
- ✅ **Production ready** - follows deployment best practices
- ✅ **Docker native** - works seamlessly in containers

This approach provides the convenience of .env files with the reliability and security of proper environment variable management.
