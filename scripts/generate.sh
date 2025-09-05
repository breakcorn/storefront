#!/bin/bash
set -e

# Скрипт для генерации GraphQL кода без npm warnings

echo "🔄 Generating GraphQL types..."

# Создаем директорию src/gql если она не существует
mkdir -p src/gql

# Определяем правильный пакетный менеджер
if [ -f "pnpm-lock.yaml" ] && (command -v pnpm > /dev/null 2>&1 || command -v corepack > /dev/null 2>&1); then
    # Если pnpm недоступен, активируем через corepack
    if ! command -v pnpm > /dev/null 2>&1; then
        corepack enable 2>/dev/null || true
    fi
    pnpm exec graphql-codegen --config .graphqlrc.ts
elif command -v npx > /dev/null 2>&1; then
    # Временно устанавливаем чистую конфигурацию для npm
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
