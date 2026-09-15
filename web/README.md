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

The game domain lives in `src/game` and is independent from React and Three.js. The interactive 2.5D presentation uses React Three Fiber; the semantic HTML board remains available for accessible play.
