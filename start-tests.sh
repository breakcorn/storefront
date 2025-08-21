#!/bin/sh
set -e

echo "Запуск приложения..."
node build/index.js &
APP_PID=$!

echo "Ожидание готовности приложения..."
for i in $(seq 1 30); do
  if wget --no-verbose --tries=1 --spider http://localhost:3000 >/dev/null 2>&1; then
    echo "Приложение готово!"
    break
  fi
  echo -n "."
  sleep 2
done
echo

echo "Запуск тестов..."
# Используем специальную конфигурацию для контейнера
BASE_URL=http://localhost:3000 pnpm exec playwright test --config=playwright.config.container.ts
TEST_EXIT_CODE=$?

echo "Остановка приложения..."
kill $APP_PID 2>/dev/null || true
exit $TEST_EXIT_CODE
