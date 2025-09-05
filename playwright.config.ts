import { defineConfig, devices } from "@playwright/test";
// Environment variables should be managed externally
import * as fs from "fs";
import { execSync } from "child_process";
import * as http from "http";

// Load environment-specific config
// Не используем NODE_ENV так как Vite управляет этим автоматически
const TEST_ENV = process.env.TEST_ENV || "test";
const envFile = `.env.${TEST_ENV}`;

// Try to load environment-specific config, fallback to .env
// Environment variables should be set externally
// Example: TEST_ENV=development npx playwright test

const PORT = process.env.PORT || 3000;
const baseURL = process.env.BASE_URL || `http://127.0.0.1:${PORT}`;

// Auto-detect package manager
let packageManager = "npm";
let packageExec = "npx";

try {
	// Check if pnpm is available
	execSync("which pnpm", { stdio: "ignore" });
	if (fs.existsSync("pnpm-lock.yaml")) {
		packageManager = "pnpm";
		packageExec = "pnpm exec";
	}
} catch (e) {
	// Fall back to npm if pnpm not available
	console.log("PNPM not found, using npm");
}

// Function to check if server is running on a specific port
function isServerRunning(url: string): Promise<boolean> {
	return new Promise((resolve) => {
		const urlObj = new URL(url);
		const port = parseInt(urlObj.port) || (urlObj.protocol === "https:" ? 443 : 80);
		const hostname = urlObj.hostname;

		const req = http.get(
			{
				hostname,
				port,
				path: "/",
				timeout: 2000,
			},
			(res) => {
				resolve(res.statusCode !== undefined && res.statusCode < 500);
			},
		);

		req.on("error", () => resolve(false));
		req.on("timeout", () => {
			req.destroy();
			resolve(false);
		});
	});
}

// Determine the correct server command based on target URL and environment
function getServerCommand(targetUrl: string): string {
	const urlObj = new URL(targetUrl);
	const port = parseInt(urlObj.port) || 3000;
	// Environment variables should be set externally before running these commands

	// Determine environment by port convention
	switch (port) {
		case 3000: // Development
			return `${packageManager} run dev`;

		case 3001: // Production
			return `${packageManager} run build:production && ${packageManager} run start`;

		case 3002: // Test
			return `${packageManager} run build && ${packageManager} run start`;

		default:
			// Fallback to development
			return `${packageManager} run dev`;
	}
}

// Test configuration
const testConfig = {
	testDir: "./__tests__",
	fullyParallel: true,
	workers: process.env.CI ? 3 : undefined,
	forbidOnly: !!process.env.CI,
	retries: process.env.CI ? 2 : 0,
	reporter: process.env.CI ? [["html"], ["github"], ["list"]] : [["html"], ["list"]],
	timeout: 90 * 1000, // Увеличиваем timeout для большей стабильности
	globalTimeout: 10 * 60 * 1000, // 10 минут общий таймаут

	use: {
		baseURL,
		trace: "on-first-retry",
		screenshot: process.env.CI ? "only-on-failure" : "off",
		video: process.env.CI ? "retain-on-failure" : "off",
		// Увеличиваем таймауты для большей стабильности
		actionTimeout: 15 * 1000,
		navigationTimeout: 30 * 1000,
	},

	projects: [
		{
			name: "Desktop Chrome",
			use: { ...devices["Desktop Chrome"] },
		},
		// Uncomment for additional browser testing
		// {
		// 	name: "Desktop Firefox",
		// 	use: { ...devices["Desktop Firefox"] },
		// },
		// {
		// 	name: "Desktop Safari",
		// 	use: { ...devices["Desktop Safari"] },
		// },
		// {
		// 	name: "Mobile Chrome",
		// 	use: { ...devices["Pixel 5"] },
		// },
	],
};

// Configure webServer to auto-start if needed
const serverCommand = getServerCommand(baseURL);
console.log(`🎯 Will test against: ${baseURL}`);
console.log(`📦 Auto-start command: ${serverCommand}`);

(testConfig as any).webServer = {
	command: serverCommand,
	url: baseURL,
	reuseExistingServer: !process.env.CI,
	timeout: 120_000,
	stdout: "pipe",
	stderr: "pipe",
	env: {
		...process.env,
	},
};

export default defineConfig(testConfig);
