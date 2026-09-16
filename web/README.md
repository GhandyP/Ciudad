# Petteia web

Vinext + React + TypeScript application for the local 2.5D Petteia game.

## Scripts

- `pnpm run dev` starts the Vinext development server.
- `pnpm run lint` checks TypeScript and TSX sources with ESLint.
- `pnpm run typecheck` runs the TypeScript compiler without emitting files.
- `pnpm run test` runs the Vitest unit suite.
- `pnpm run test:e2e:list` lists Playwright browser tests.
- `pnpm run test:e2e` runs the Playwright browser suite.
- `pnpm run check:vinext` checks Vinext compatibility.
- `pnpm run build` creates the production build.
- `pnpm run deploy` builds and deploys the Worker with the Vinext Cloudflare adapter.

### Cloudflare Workers deployment

The app uses Vinext's documented Cloudflare integration through `@cloudflare/vite-plugin`. The
`wrangler.jsonc` contract serves `dist/client` as `ASSETS` and runs
`vinext/server/fetch-handler` as the Worker entry.

Before deploying, authenticate with Cloudflare using either `wrangler login` or a
`CLOUDFLARE_API_TOKEN` environment variable, and provide the target account through
`CLOUDFLARE_ACCOUNT_ID` or `account_id` in `wrangler.jsonc`. No credentials are stored in this
repository. `pnpm run deploy` is intentionally not run as part of local verification.

The game domain lives in `src/game` and is independent from React and Three.js. The interactive 2.5D presentation uses React Three Fiber; the semantic HTML board remains available for accessible play.
