import { cloudflare } from "@cloudflare/vite-plugin";
import vinext from "vinext";
import { defineConfig } from "vite";

export default defineConfig(({ command }) => ({
  plugins: [
    vinext(),
    // The Cloudflare adapter is applied for production builds only. In dev it
    // starts a workerd runtime that never serves HTTP in this environment, so
    // `vinext dev` keeps using the plain Node dev server.
    ...(command === "build"
      ? [
          cloudflare({
            viteEnvironment: {
              name: "rsc",
              childEnvironments: ["ssr"],
            },
          }),
        ]
      : []),
  ],
}));
