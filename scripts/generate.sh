#!/bin/bash
set -e

# Script for GraphQL code generation with .env loading
# Usage: ./scripts/generate.sh [environment]

ENV=${1:-development}

echo "🔄 Generating GraphQL types for $ENV environment..."

# Load environment variables
source "$(dirname "$0")/load-env.sh" "$ENV"

# Create src/gql directory if it doesn't exist
mkdir -p src/gql

# Determine package manager
if [ -f "pnpm-lock.yaml" ] && (command -v pnpm > /dev/null 2>&1 || command -v corepack > /dev/null 2>&1); then
    # Enable pnpm via corepack if not available
    if ! command -v pnpm > /dev/null 2>&1; then
        corepack enable 2>/dev/null || true
    fi
    pnpm exec graphql-codegen --config .graphqlrc.ts
elif command -v npx > /dev/null 2>&1; then
    # Set clean npm configuration
    export npm_config_verify_deps_before_run=false
    export npm_config__jsr_registry=
    npx graphql-codegen --config .graphqlrc.ts
else
    echo "❌ No package manager found"
    exit 1
fi

# Исправляем индексный файл для экспорта всех типов
echo "🔧 Fixing GraphQL exports..."

# Всегда перезаписываем index.ts для включения всех экспортов
echo 'export * from "./gql";
export * from "./graphql";' > src/gql/index.ts

echo "✅ GraphQL types generated successfully!"
