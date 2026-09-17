import { defineConfig, devices } from "@playwright/test";

export default defineConfig({
  testDir: "./tests/e2e",
  fullyParallel: true,
  // The dev server compiles RSC routes on demand; the first navigation after a
  // cold start can take ~1 minute, so per-test and navigation timeouts are
  // deliberately generous.
  timeout: 240_000,
  reporter: "list",
  use: {
    baseURL: "http://127.0.0.1:3000",
    navigationTimeout: 120_000,
    trace: "on-first-retry",
  },
  projects: [
    {
      name: "chromium",
      use: { ...devices["Desktop Chrome"] },
    },
  ],
  webServer: {
    command: "pnpm exec vinext dev --hostname 127.0.0.1",
    url: "http://127.0.0.1:3000",
    reuseExistingServer: !process.env.CI,
    timeout: 300_000,
  },
});
