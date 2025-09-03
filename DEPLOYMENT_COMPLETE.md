# 🚀 Полное руководство по развертыванию Saleor SvelteKit Storefront

Пошаговый процесс развертывания от клонирования репозитория до запущенного приложения.

---

## 📋 Предварительные требования

### Системные требования
- **Node.js**: ≥20.0.0 (рекомендуется LTS)
- **Package Manager**: pnpm ≥9.4.0 (рекомендуется) или npm ≥8.0
- **Docker**: ≥20.10 (опционально, для Docker развертывания)
- **Git**: для клонирования репозитория

### Проверка версий
```bash
node --version    # v20.0.0+
npm --version     # 8.0.0+
pnpm --version    # 9.4.0+ (если используете pnpm)
docker --version  # 20.10+ (если используете Docker)
```

---

## 🎯 Шаг 1: Клонирование и настройка

### 1.1 Клонирование репозитория
```bash
git clone https://github.com/your-username/saleor-sveltekit-storefront.git
cd saleor-sveltekit-storefront
```

### 1.2 Настройка окружения
```bash
# Копировать пример конфигурации
cp .env.example .env

# Редактировать конфигурацию
nano .env
# или
code .env
```

### 1.3 Минимальная конфигурация .env
```bash
# ОБЯЗАТЕЛЬНО: URL вашего Saleor API
PUBLIC_SALEOR_API_URL=https://demo.saleor.io/graphql/

# ОБЯЗАТЕЛЬНО: URL вашего фронтенда
PUBLIC_STOREFRONT_URL=http://localhost:3000

# ОПЦИОНАЛЬНО: Порт (по умолчанию 3000)
PORT=3000
```

---

## 🚀 Шаг 2: Выбор метода развертывания

### Вариант А: Быстрый старт (Docker) - **РЕКОМЕНДУЕТСЯ**
### Вариант Б: Локальная разработка (Node.js)
### Вариант В: Продакшен (Docker)
### Вариант Г: Облачное развертывание (Vercel)

---

## 🎯 Вариант А: Быстрый старт с Docker

**Преимущества**: Изолированная среда, не влияет на систему, быстрая настройка

### А.1 Запуск разработки
```bash
# Запуск development среды с hot reload
./dev.sh docker development

# Проверка статуса
./dev.sh status
```

### А.2 Доступ к приложению
- **Development**: http://localhost:3000
- **Health check**: http://localhost:3000/health

### А.3 Управление контейнерами
```bash
# Просмотр логов
./dev.sh logs development

# Остановка
./dev.sh stop development

# Перезапуск
./dev.sh restart development
```

---

## 💻 Вариант Б: Локальная разработка

**Преимущества**: Прямой доступ к файлам, быстрая разработка

### Б.1 Установка зависимостей
```bash
# С pnpm (рекомендуется)
pnpm install

# Или с npm
npm install
```

**⚠️ Важно**: При установке зависимостей автоматически запустится `postinstall` скрипт, который:
- Выполнит `svelte-kit sync` для создания типов SvelteKit
- Создаст структуру `src/gql/` с placeholder типами
- Запустит `graphql-codegen` для генерации GraphQL типов

### Б.2 Запуск разработки
```bash
# Запуск development сервера
pnpm run dev:local

# Или с npm
npm run dev:local
```

### Б.3 Доступ к приложению
- **Development**: http://localhost:3000

---

## 🏭 Вариант В: Продакшен с Docker

### В.1 Продакшен сборка
```bash
# Запуск production среды
./dev.sh docker production
```

### В.2 Доступ к приложению
- **Production**: http://localhost:3001

### В.3 Проверка производительности
```bash
# Просмотр метрик контейнера
docker stats saleor-storefront-production

# Проверка размера образа
docker images | grep saleor-storefront
```

---

## ☁️ Вариант Г: Развертывание на Vercel

### Г.1 Подготовка к деплою
```bash
# Установка Vercel CLI
npm i -g vercel

# Логин в Vercel
vercel login
```

### Г.2 Настройка переменных окружения
```bash
# Через Vercel CLI
vercel env add PUBLIC_SALEOR_API_URL
# Введите: https://your-saleor-instance.com/graphql/

vercel env add PUBLIC_STOREFRONT_URL
# Введите: https://your-app.vercel.app
```

### Г.3 Развертывание
```bash
# Первичное развертывание
vercel

# Продакшен развертывание
vercel --prod
```

---

## 🔧 Шаг 3: Настройка и конфигурация

### 3.1 Подключение к вашему Saleor

Если у вас есть собственный Saleor API:

```bash
# Обновить .env
PUBLIC_SALEOR_API_URL=https://your-saleor.com/graphql/

# Регенерировать GraphQL типы
pnpm run generate

# Перезапустить приложение
./dev.sh restart development
```

### 3.2 Проверка подключения к API
```bash
# Тест API подключения
curl -X POST -H "Content-Type: application/json" \
  -d '{"query":"{ shop { name } }"}' \
  $PUBLIC_SALEOR_API_URL
```

### 3.3 Настройка платежных систем

Для Adyen:
```bash
# В Saleor Dashboard → Apps → Adyen
# Настройте ваши Adyen credentials
```

---

## 🧪 Шаг 4: Тестирование

### 4.1 Запуск тестов
```bash
# Автоматические E2E тесты
./dev.sh test

# Или против локального сервера
pnpm run test:local

# Интерактивные тесты
pnpm run test:headed
```

### 4.2 Проверка основного функционала

**Ручная проверка**:
1. ✅ Открывается главная страница
2. ✅ Отображается список продуктов
3. ✅ Работает добавление в корзину
4. ✅ Открывается страница продукта
5. ✅ Работает процесс оформления заказа

---

## 🐛 Решение проблем

### Проблема: "During SSR, Vite can't find the '@gql'"
```bash
# Решение - запустить setup
pnpm run setup

# Или пошагово
pnpm exec svelte-kit sync
pnpm run generate
```

### Проблема: Порт уже занят
```bash
# Найти процесс на порту 3000
lsof -i :3000

# Остановить Docker контейнеры
./dev.sh stop development

# Использовать другой порт
PORT=3001 ./dev.sh docker development
```

### Проблема: GraphQL типы не генерируются
```bash
# Проверить API URL
echo $PUBLIC_SALEOR_API_URL

# Проверить доступность API
curl $PUBLIC_SALEOR_API_URL

# Принудительно регенерировать
pnpm run generate:clean
```

### Проблема: Docker контейнер не запускается
```bash
# Проверить логи
./dev.sh logs development

# Проверить статус
docker ps -a

# Пересоздать контейнер
docker compose -f docker-compose.development.yml down
docker compose -f docker-compose.development.yml up --build -d
```

---

## 📊 Проверка успешного развертывания

### Чек-лист готовности

- [ ] ✅ Приложение открывается по адресу
- [ ] ✅ Отображается список продуктов
- [ ] ✅ Работает поиск
- [ ] ✅ Можно добавить товар в корзину
- [ ] ✅ Работает навигация по категориям
- [ ] ✅ Открываются страницы отдельных продуктов
- [ ] ✅ Работает процесс checkout
- [ ] ✅ Нет ошибок в консоли браузера
- [ ] ✅ Проходят автотесты

### Полезные команды для диагностики

```bash
# Состояние всех сервисов
./dev.sh status

# Логи приложения
./dev.sh logs development

# Версии зависимостей
npm ls --depth=0

# Информация о системе
node --version && npm --version && docker --version

# Проверка портов
netstat -tulpn | grep :3000
```

---

## 🎉 Поздравляем! Развертывание завершено

**Ваш магазин готов к использованию!**

### Следующие шаги:
1. 🎨 **Кастомизация дизайна** - редактируйте файлы в `src/lib/components/`
2. 🛒 **Настройка продуктов** - через Saleor Dashboard
3. 💳 **Настройка платежей** - подключите Adyen или Stripe
4. 🚀 **Продакшен деплой** - на Vercel, AWS или других платформах

### Полезные ресурсы:
- [Saleor Documentation](https://docs.saleor.io/)
- [SvelteKit Documentation](https://kit.svelte.dev/)
- [TailwindCSS Documentation](https://tailwindcss.com/)

---

**🔥 Приятной разработки!**
