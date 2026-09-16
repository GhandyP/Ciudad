# Petteia web 2.5D

Reescritura web del juego de Petteia, originalmente desarrollado en Flutter. La aplicación es un tablero 2.5D para dos jugadores locales, con motor de reglas puro y testeable.

## Stack

- **Vinext** — framework web (App Router sobre Vite), compatible con Next.js.
- **React + TypeScript** — interfaz y tipado estricto.
- **React Three Fiber + Three.js** — escena 2.5D procedural (cámara, luces, sombras, torres).
- **Vitest** — tests unitarios del motor y la persistencia.
- **Playwright** — tests end-to-end en navegador (Chromium).
- **ESLint** — calidad de código.
- **localStorage** — persistencia local versionada (schema 2) con historial de deshacer.

## Reglas del MVP

- Tablero 8×8; las blancas ocupan la fila 7 completa y las negras la fila 0 completa.
- Movimiento ortogonal deslizante a cualquier distancia, sin saltar piezas.
- Captura por bloqueo: tramos contiguos enemigos adyacentes a la torre movida quedan capturados cuando están cerrados por una torre propia.
- Gana quien deja al rival sin torres o sin movimientos legales; también hay rendición.

## Estructura

```text
web/
├── app/                    # Rutas y página del juego (Vinext App Router)
├── src/
│   ├── game/               # Motor puro de Petteia (sin React ni Three.js)
│   ├── components/game/    # Componentes React (tablero HTML accesible, controles)
│   ├── scene/              # Escena 2.5D con React Three Fiber
│   └── services/           # Persistencia versionada en localStorage
├── tests/unit/             # Vitest (motor y persistencia)
├── tests/e2e/              # Playwright
└── vite.config.ts / wrangler.jsonc  # Build y despliegue Cloudflare
```

El tablero HTML semántico queda siempre disponible como alternativa accesible a la vista 3D, incluso si WebGL no está disponible.

## Comandos

```bash
cd web
pnpm install

pnpm run dev             # servidor de desarrollo
pnpm run lint            # ESLint
pnpm run typecheck       # TypeScript estricto
pnpm run test            # Vitest (unitarios)
pnpm run test:e2e        # Playwright (requiere: pnpm exec playwright install chromium)
pnpm run test:e2e:list   # listar tests E2E
pnpm run check:vinext    # compatibilidad Vinext
pnpm run build           # build de producción
pnpm --dir web run deploy  # deploy a Cloudflare Workers (requiere wrangler login)
```

## Despliegue

Vinext apunta primariamente a **Cloudflare Workers**. Configuración lista en `web/wrangler.jsonc` (worker `petteia`); autenticación previa:

```bash
pnpm --dir web exec wrangler login
```

Luego:

```bash
pnpm --dir web run deploy
```

## Legado

El código original de Flutter fue retirado del árbol durante la Fase 8; permanece íntegro en el historial de Git (commit inicial `9c9f6bd`) como referencia. La app web no comparte código con él. Los detalles y decisiones están en [`docs/plan-vinext-2.5d.md`](docs/plan-vinext-2.5d.md) y el seguimiento de tareas en [`odd/tasks/petteia-web-25d.md`](odd/tasks/petteia-web-25d.md).