#!/bin/bash
# Load environment variables from .env files
# Usage: source scripts/load-env.sh [environment]

set -e

# Determine environment
ENV=${1:-development}
ENV_FILE=".env.${ENV}"

# Function to load env file
load_env_file() {
    local file=$1
    if [ -f "$file" ]; then
        echo "🔧 Loading environment from $file"
        # Export variables, ignoring comments and empty lines
        set -o allexport
        source "$file"
        set +o allexport
        return 0
    else
        echo "⚠️  Environment file $file not found"
        return 1
    fi
}

# Load base .env first (if exists)
if [ -f ".env" ]; then
    load_env_file ".env"
fi

# Load environment-specific .env file
if load_env_file "$ENV_FILE"; then
    echo "✅ Environment loaded: $ENV"
else
    echo "❌ Failed to load environment: $ENV"
    echo "Available .env files:"
    ls -1 .env* 2>/dev/null || echo "No .env files found"
    exit 1
fi

# Verify required variables
if [ -z "$PUBLIC_SALEOR_API_URL" ]; then
    echo "❌ PUBLIC_SALEOR_API_URL is not set"
    exit 1
fi

echo "🚀 Environment ready:"
echo "  - PUBLIC_SALEOR_API_URL: $PUBLIC_SALEOR_API_URL"
echo "  - PUBLIC_STOREFRONT_URL: ${PUBLIC_STOREFRONT_URL:-'not set'}"
echo "  - PORT: ${PORT:-'not set'}"
