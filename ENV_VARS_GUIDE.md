# Environment Variables Guide

This project uses shell-managed environment variables instead of dotenv packages for better production practices.

## Required Environment Variables

### Core API Configuration

- `PUBLIC_SALEOR_API_URL` - Saleor GraphQL API URL
- `PUBLIC_STOREFRONT_URL` - Your storefront URL

### Optional Configuration

- `NODE_ENV` - Environment mode (development, production, test)
- `PORT` - Server port (defaults: dev=3000, prod=3001, test=3002)

## Setting Environment Variables

### Development

```bash
# Export variables in your shell
export PUBLIC_SALEOR_API_URL="https://your-saleor.com/graphql/"
export PUBLIC_STOREFRONT_URL="http://localhost:3000"

# Run commands
pnpm run dev
pnpm run build
pnpm run generate
```

### Production

```bash
# Set production variables
export PUBLIC_SALEOR_API_URL="https://your-saleor.com/graphql/"
export PUBLIC_STOREFRONT_URL="https://your-app.vercel.app"
export NODE_ENV="production"

# Build and start
pnpm run build
pnpm run start
```

### Docker

```bash
# Pass variables to docker
docker run -e PUBLIC_SALEOR_API_URL="https://your-saleor.com/graphql/" \
           -e PUBLIC_STOREFRONT_URL="http://localhost:3000" \
           your-app
```

### Vercel/Cloud Platforms

Set environment variables in your platform's dashboard:

- Vercel: Project Settings → Environment Variables
- Netlify: Site Settings → Environment Variables
- Railway: Project → Variables

## Common Commands with Environment Variables

### GraphQL Code Generation

```bash
PUBLIC_SALEOR_API_URL="https://your-saleor.com/graphql/" pnpm run generate
```

### Testing

```bash
PUBLIC_SALEOR_API_URL="https://your-saleor.com/graphql/" \
BASE_URL="http://localhost:3000" \
npx playwright test
```

### Development with Custom API

```bash
PUBLIC_SALEOR_API_URL="https://demo.saleor.io/graphql/" \
PUBLIC_STOREFRONT_URL="http://localhost:3000" \
pnpm run dev
```

## Shell Configuration

### Permanent Setup (Recommended)

Add to your shell profile (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
# Saleor Storefront Environment
export PUBLIC_SALEOR_API_URL="https://your-saleor.com/graphql/"
export PUBLIC_STOREFRONT_URL="http://localhost:3000"
```

### Project-specific .envrc (direnv)

If you use direnv:

```bash
# .envrc
export PUBLIC_SALEOR_API_URL="https://your-saleor.com/graphql/"
export PUBLIC_STOREFRONT_URL="http://localhost:3000"
```

## Why No dotenv?

- **Production Best Practice**: Environment variables should be managed by the deployment platform
- **Security**: Avoids accidentally committing sensitive data in .env files
- **Simplicity**: One less dependency and configuration layer
- **Platform Agnostic**: Works consistently across all deployment environments
- **Docker Native**: Aligns with container deployment practices

## Migration from dotenv

If upgrading from a version that used dotenv:

1. **Export your .env variables to shell:**

   ```bash
   # Convert .env to shell exports
   set -o allexport
   source .env.development
   set +o allexport
   ```

2. **Update your deployment:**
   - Vercel: Add env vars in dashboard
   - Docker: Use -e flags or docker-compose environment
   - CI/CD: Set variables in pipeline configuration

3. **Remove old .env files from sensitive environments**

This approach provides better security, simpler deployment, and follows industry best practices.
