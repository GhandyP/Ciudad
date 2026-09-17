# Feature: Petteia web 2.5D (Vinext)

## Objetivo

Rehacer el proyecto Petteia desde Flutter a una aplicación web 2.5D con Vinext, React, TypeScript y React Three Fiber, manteniendo el motor de reglas puro, testeable e independiente de la UI.

## Reglas aprobadas (MVP)

- Tablero 8×8.
- Una fila completa de 8 torres blancas en la fila 7 y 8 torres negras en la fila 0.
- Movimiento ortogonal deslizante a cualquier distancia, sin saltar piezas.
- Captura por bloqueo: secuencias contiguas enemigas adyacentes a la torre movida, encerradas por una torre propia; orden determinista (arriba, derecha, abajo, izquierda; más cercana a más lejana).
- Victoria si el rival queda sin torres o sin movimientos legales.
- Botón de rendición que concede la victoria al rival.
- Dos jugadores locales; sin IA, cuentas, multiplayer ni backend en el MVP.

## Estado de tareas

| # | Tarea | Estado | Notas |
|---|-------|--------|-------|
| 1 | Definir reglas y alcance del MVP | done | Documentado en docs/plan-vinext-2.5d.md |
| 2 | Crear base Vinext + React + TypeScript | done | Scaffold en web/; Vitest, Playwright y ESLint configurados; commit 334ace2 |
| 3 | Implementar motor puro de Petteia con TDD | done | web/src/game/engine.ts; 11+ tests; commit a126c25 |
| 4 | Construir prototipo funcional 2D accesible | done | Tablero HTML, controles, historial, rendición, undo, flechas; commit 25e93f9 |
| 5 | Agregar escena visual 2.5D con React Three Fiber | done | Escena procedural, cámara, luces, fallback WebGL; commit 25e93f9 |
| 6 | Integrar UX, persistencia y responsive | done | Persistencia schema 2 con stack de undo; restauración SSR-safe |
| 7 | Verificar, optimizar y desplegar | in_progress | E2E real en Chromium pasó; adapter Cloudflare listo (225dbc4); deploy diferido al final por decisión del usuario |
| 8 | Retirar Flutter y documentar arquitectura | done | README reescrito (e88af83); Flutter eliminado (df73c43); recuperable en historial (9c9f6bd) |

## Entregables verificados

- Lint: pasa.
- Typecheck: pasa.
- Vitest: 22 tests (3 archivos) pasan.
- Playwright list: 1 test; E2E real en Chromium: 1 passed.
- vinext check: 100% compatible.
- Build: completo; warnings informativos (chunk > 500 kB, clasificación dinámica de /api/hello).
- Commits subidos a origin/main: 334ace2, a126c25, 25e93f9, c32e95b, 9b35402, 1b4fd88, 225dbc4, 684cc1b, e88af83, df73c43 (HEAD).

## Pendientes y obstáculos

- Despliegue a Cloudflare Workers: diferido al final por decisión del usuario; requiere `wrangler login` (o `CLOUDFLARE_API_TOKEN`) y luego `pnpm --dir web run deploy`.
- Cambios ajenos preservados: `.gitignore` (raíz) y `.codegraph/` — no tocar.
- Warnings no bloqueantes: chunk grande por Three.js; ruta /api/hello no clasificada estáticamente.

## Próximo paso ODD

Cerrar la Fase 7: autenticar Cloudflare (usuario) y ejecutar el deploy de preview/producción.