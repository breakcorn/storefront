# Тестирование в Docker контейнерах

Этот проект поддерживает запуск тестов в Docker контейнерах, что обеспечивает изолированную и воспроизводимую среду тестирования.

## 🐳 Доступные способы тестирования

### 1. Простой способ (рекомендуется)

```bash
# Запуск приложения в Docker и выполнение тестов локально
pnpm run test:docker

# Или напрямую через скрипт
./run-tests-docker.sh

# Запуск конкретного теста
pnpm run test:docker -- __tests__/STF_03.spec.ts

# Запуск с дополнительными параметрами
pnpm run test:docker -- --headed --timeout=120000
```

### 2. Полный Docker способ

```bash
# Запуск всего (приложение + тесты) в Docker контейнере
pnpm run test:docker:full

# Или напрямую через скрипт
./test-docker.sh
```

## 🏗️ Как это работает

### Простой способ (run-tests-docker.sh)

1. **Запуск приложения в Docker**: Использует `docker-compose.development.yml` для запуска приложения в контейнере
2. **Ожидание готовности**: Проверяет доступность приложения на `http://localhost:3000`
3. **Выполнение тестов**: Запускает Playwright тесты локально против приложения в Docker
4. **Автоматическая очистка**: Останавливает контейнеры после завершения

### Полный Docker способ (test-docker.sh)

1. **Сборка образа**: Создает специальный образ с тестовой средой
2. **Запуск контейнера**: Запускает приложение и тесты в изолированном контейнере
3. **Результаты**: Сохраняет результаты тестов в локальные папки

## 📁 Файлы конфигурации

- `docker-compose.test.yml` - Docker Compose для полного тестирования
- `Dockerfile.test` - Dockerfile для тестовой среды
- `playwright.config.docker.ts` - Playwright конфигурация для Docker
- `run-tests-docker.sh` - Простой скрипт тестирования
- `test-docker.sh` - Полный Docker скрипт тестирования

## 🔧 Настройки для Docker

### Playwright конфигурация

Для Docker тестирования используются специальные настройки:

- Увеличенные таймауты (90s вместо 60s)
- Меньше workers (1-2 вместо автоопределения)
- Дополнительные Chrome флаги для стабильности
- Сохранение видео и скриншотов при ошибках

### Переменные среды

```bash
# Основные переменные для тестирования
NODE_ENV=test
PUBLIC_SALEOR_API_URL=https://store-qdjgu50o.eu.saleor.cloud/graphql/
PUBLIC_STOREFRONT_URL=http://localhost:3000
BASE_URL=http://localhost:3000
CI=true
```

## 🚀 Быстрый старт

1. **Убедитесь что Docker запущен**:

   ```bash
   docker --version
   docker-compose --version
   ```

2. **Запустите тесты**:

   ```bash
   pnpm run test:docker
   ```

3. **Проверьте результаты**:
   - HTML репорт: `playwright-report/index.html`
   - Результаты тестов: `test-results/`

## 🐛 Отладка

### Проблемы с запуском

```bash
# Проверить статус контейнеров
docker ps -a

# Посмотреть логи приложения
docker-compose -f docker-compose.development.yml logs

# Остановить все контейнеры
docker-compose -f docker-compose.development.yml down
```

### Проблемы с тестами

```bash
# Запуск с дополнительной отладкой
DEBUG=true pnpm run test:docker

# Запуск в видимом режиме (если поддерживается)
pnpm run test:docker -- --headed

# Запуск конкретного теста с отладкой
pnpm run test:docker -- __tests__/STF_03.spec.ts --debug
```

### Очистка Docker ресурсов

```bash
# Остановить все контейнеры проекта
docker-compose -f docker-compose.development.yml down
docker-compose -f docker-compose.test.yml down

# Удалить неиспользуемые образы
docker image prune -f

# Полная очистка (осторожно!)
docker system prune -a
```

## 🔍 Сравнение методов

| Метод             | Преимущества                                    | Недостатки                                 |
| ----------------- | ----------------------------------------------- | ------------------------------------------ |
| **Простой**       | Быстрее, легче отладка                          | Playwright должен быть установлен локально |
| **Полный Docker** | Полная изоляция, не нужны локальные зависимости | Медленнее, сложнее отладка                 |

## 💡 Рекомендации

1. **Для разработки**: Используйте простой способ (`pnpm run test:docker`)
2. **Для CI/CD**: Используйте полный Docker способ
3. **Для отладки**: Запускайте тесты локально с `pnpm run test:local`
4. **Регулярно очищайте** Docker ресурсы для экономии места

## 📊 Примеры использования

```bash
# Запуск всех тестов
pnpm run test:docker

# Запуск конкретного теста
pnpm run test:docker -- __tests__/STF_03.spec.ts

# Запуск тестов с фильтром
pnpm run test:docker -- --grep "cart"

# Запуск с повтором при неудаче
pnpm run test:docker -- --retries=2

# Запуск в полном Docker режиме
pnpm run test:docker:full
```

Такой подход обеспечивает стабильное тестирование в изолированной среде и упрощает интеграцию с CI/CD системами.
