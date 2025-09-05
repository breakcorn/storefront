import { defineConfig, devices } from "@playwright/test";
// Environment variables should be set externally

// Загружаем конфигурацию для тестов
const NODE_ENV = process.env.NODE_ENV || "test";
const envFile = `.env.${NODE_ENV}`;

// Environment variables should be set externally
// Example: NODE_ENV=test npx playwright test

const PORT = process.env.PORT || 3000;
const baseURL = process.env.BASE_URL || `http://localhost:${PORT}`;

// Конфигурация для тестирования в Docker
const testConfig = {
	testDir: "./__tests__",
	fullyParallel: true,
	workers: process.env.CI ? 2 : 1, // Уменьшаем количество воркеров для Docker
	forbidOnly: !!process.env.CI,
	retries: process.env.CI ? 2 : 1, // Добавляем retry для Docker
	reporter: process.env.CI ? [["html"], ["github"], ["list"]] : [["html"], ["list"]],
	timeout: 90 * 1000, // Увеличиваем timeout для Docker
	globalTimeout: 10 * 60 * 1000, // 10 минут общий таймаут

	use: {
		baseURL,
		trace: "retain-on-failure", // Сохраняем trace при ошибках
		screenshot: "only-on-failure",
		video: "retain-on-failure",
		// Увеличиваем таймауты для действий
		actionTimeout: 15 * 1000,
		navigationTimeout: 30 * 1000,
	},

	projects: [
		{
			name: "Desktop Chrome",
			use: {
				...devices["Desktop Chrome"],
				// Дополнительные настройки для Docker
				launchOptions: {
					args: [
						"--no-sandbox",
						"--disable-setuid-sandbox",
						"--disable-dev-shm-usage",
						"--disable-web-security",
						"--disable-features=VizDisplayCompositor",
					],
				},
			},
		},
	],

	// Не запускаем встроенный веб-сервер, так как приложение уже запущено в Docker
	// webServer будет настроен только если BASE_URL не задан
};

// Настраиваем веб-сервер только если BASE_URL не установлен
if (!process.env.BASE_URL) {
	(testConfig as any).webServer = {
		command: "pnpm run dev",
		url: baseURL,
		reuseExistingServer: !process.env.CI,
		timeout: 180_000, // 3 минуты для запуска
		env: {
			NODE_ENV: "development",
			...process.env,
		},
	};
}

export default defineConfig(testConfig);
