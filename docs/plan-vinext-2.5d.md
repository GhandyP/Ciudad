# Plan de reescritura: Petteia web 2.5D

## 1. Objetivo

Rehacer el proyecto actual de Petteia, originalmente desarrollado en Flutter, como una aplicación web moderna con una presentación 2.5D.

La aplicación tendrá un tablero jugable con piezas y escenario 3D, pero conservará una lógica de juego por turnos sobre una grilla 2D.

No se hará una traducción archivo por archivo del proyecto Flutter. El código actual servirá únicamente como referencia hasta definir y probar correctamente las reglas.

## 2. Stack tecnológico

- **Vinext**: framework de la aplicación web, rutas y futura integración de servidor.
- **React**: componentes e interfaz de usuario.
- **TypeScript**: lenguaje principal y tipado estricto.
- **React Three Fiber**: integración declarativa de Three.js con React.
- **Three.js**: renderizado del tablero, piezas, cámara, iluminación y animaciones 3D.
- **Vitest**: tests unitarios del motor de juego.
- **Playwright**: tests end-to-end en navegador.
- **`localStorage`**: persistencia local inicial.

Vinext será la capa de aplicación; no será el motor 3D. La escena 2.5D se ejecutará en un componente cliente del navegador mediante React Three Fiber.

## 3. Alcance inicial del MVP

El MVP recomendado incluye:

- partida local para dos jugadores en el mismo dispositivo;
- selección de piedras y visualización de movimientos legales;
- movimientos y capturas según la variante de Petteia definida;
- indicador de turno y estado de la partida;
- historial de movimientos;
- reinicio y deshacer movimiento;
- guardado local de la partida;
- tablero 2.5D responsive para desktop y móvil;
- controles básicos de cámara, como zoom;
- alternativa 2D accesible para teclado y tecnologías asistivas.

Queda fuera del MVP:

- cuentas de usuario;
- multiplayer online;
- inteligencia artificial;
- ranking y partidas públicas;
- backend y base de datos;
- editor de modelos 3D avanzado;
- monetización.

## 4. Decisiones que deben cerrarse antes de programar

Las variantes históricas de Petteia pueden diferir. Antes de implementar el motor se debe documentar y aprobar:

- tamaño del tablero;
- cantidad, color y posición inicial de las piedras;
- movimientos permitidos y distancia máxima;
- regla exacta de captura por bloqueo;
- posibilidad de realizar capturas múltiples;
- condición de victoria;
- condición de empate o bloqueo;
- reglas de repetición, si aplican;
- orientación de coordenadas del tablero;
- comportamiento al seleccionar una pieza o una casilla inválida.

Este documento de reglas será la fuente de verdad del motor, los tests y la interfaz.

## 5. Arquitectura prevista

```text
app/                         # Rutas y páginas según la versión de Vinext
src/
  game/                      # Dominio puro, sin dependencias de React o Three.js
    Position.ts
    Piece.ts
    Board.ts
    Move.ts
    GameState.ts
    PetteiaRules.ts
    gameReducer.ts
    serialization.ts

  components/
    game/                    # Componentes React de la experiencia de juego
      GameView.tsx
      GameControls.tsx
      GameStatus.tsx
      MoveHistory.tsx
      AccessibleBoard.tsx

  scene/                     # Presentación 2.5D
    GameScene.tsx
    Board3D.tsx
    Stone3D.tsx
    Camera.tsx
    lighting.ts

  services/
    gameStorage.ts           # Persistencia versionada en localStorage

  styles/
```

Flujo de datos:

```text
Interacción del usuario
        ↓
Componente React / escena 3D
        ↓
Acción del gameReducer
        ↓
Motor puro de Petteia
        ↓
Nuevo GameState
        ↓
Render 2D y render 2.5D
```

La escena 3D no decidirá si un movimiento es válido. Sólo traducirá interacciones visuales a posiciones del dominio y dibujará el estado recibido.

## 6. Fases de implementación

### Fase 0: reglas, producto y diseño visual

1. Confirmar la variante exacta de Petteia.
2. Definir el alcance final del MVP.
3. Definir la experiencia 2.5D: cámara, colores, materiales, iluminación y estilo de las piedras.
4. Definir los criterios de aceptación.
5. Registrar las decisiones en documentación del proyecto.

**Resultado:** especificación de reglas y alcance aprobada.

### Fase 1: base de Vinext

1. Crear una rama o worktree separado para la reescritura.
2. Crear la aplicación Vinext con React y TypeScript.
3. Configurar TypeScript estricto, linting y formateo.
4. Configurar Vitest y Playwright.
5. Agregar scripts de desarrollo, typecheck, lint, tests y build.
6. Confirmar la compatibilidad de la versión elegida de Vinext.
7. Ejecutar `vinext check` y un build mínimo.

El proyecto Flutter se conservará temporalmente sin mezclar sus modelos con la nueva aplicación.

**Resultado:** aplicación web vacía que inicia, compila y tiene tests funcionando.

### Fase 2: motor puro de Petteia con TDD

Implementar el dominio sin React, Three.js ni APIs del navegador:

- posiciones y coordenadas;
- piedras y colores;
- tablero inmutable;
- movimientos;
- estado de la partida;
- turnos;
- movimientos legales;
- capturas;
- victoria y empate;
- historial;
- serialización y restauración.

Para cada comportamiento se seguirá este ciclo:

1. escribir un test que falla;
2. implementar el comportamiento mínimo;
3. agregar casos límite y regresiones;
4. refactorizar sin cambiar el comportamiento.

**Resultado:** motor determinista cubierto por tests y usable sin interfaz gráfica.

### Fase 3: prototipo 2D funcional

1. Crear el tablero semántico con HTML y React.
2. Conectar el motor mediante `useReducer` o una abstracción equivalente.
3. Implementar selección, movimientos posibles y confirmación de movimientos.
4. Mostrar turno, estado, historial y capturas.
5. Implementar reinicio y deshacer.
6. Agregar navegación por teclado y etiquetas accesibles.

Esta fase debe estar completa antes de introducir el renderizado 3D.

**Resultado:** juego completamente jugable en 2D.

### Fase 4: presentación 2.5D

1. Integrar Three.js y React Three Fiber.
2. Crear un tablero 3D con geometría procedural inicial.
3. Crear piedras 3D diferenciadas por color.
4. Configurar cámara en perspectiva y zoom.
5. Agregar iluminación, sombras y materiales.
6. Resaltar selección, movimientos posibles y último movimiento.
7. Convertir eventos de las piezas y casillas a `Position` del dominio.
8. Animar movimientos y capturas.
9. Mantener los controles y textos como UI HTML/React.

**Resultado:** misma partida y mismas reglas, ahora con presentación 2.5D.

### Fase 5: UX, responsive y persistencia

1. Adaptar la escena a desktop, tablet y móvil.
2. Agregar controles de zoom y opción de restablecer cámara.
3. Guardar y restaurar partidas con un formato versionado.
4. Proteger el acceso a `localStorage` durante renderizado del servidor.
5. Agregar preferencias visuales y tema.
6. Incorporar efectos de sonido sólo después de estabilizar la interacción.
7. Mantener el modo 2D accesible como fallback.

**Resultado:** experiencia completa para uso local.

### Fase 6: backend y multiplayer opcional

Sólo después de validar el MVP local:

- autenticación;
- creación y unión a partidas;
- sincronización de turnos;
- persistencia remota;
- recuperación ante desconexiones;
- reglas anti-trampa en servidor.

Vinext podrá aportar rutas y servicios de servidor, posiblemente desplegados en Cloudflare Workers, pero esta fase no debe bloquear el MVP.

### Fase 7: verificación, rendimiento y despliegue

Ejecutar como mínimo:

```bash
npm run typecheck
npm run lint
npm run test
npm run test:e2e
npm run build
npx vinext check
```

Verificar además:

- Chrome, Firefox y Safari;
- desktop y móvil;
- teclado y lector de pantalla;
- reload con partida guardada;
- movimientos inválidos y estados terminales;
- rendimiento del Canvas y consumo de memoria;
- funcionamiento con conexión lenta;
- comportamiento de la cámara y eventos táctiles.

Desplegar primero una versión de preview y luego producción, preferentemente en Cloudflare si la compatibilidad de la versión de Vinext lo permite.

### Fase 8: limpieza y documentación final

1. Actualizar el README con la arquitectura web real.
2. Documentar cómo ejecutar, testear y desplegar.
3. Eliminar o archivar el código Flutter.
4. Eliminar el motor legacy de ajedrez.
5. Revisar nombres `Chess*` y reemplazarlos por nombres de Petteia.
6. Documentar decisiones de reglas y limitaciones conocidas.

## 7. Unidades de entrega

Cada unidad debe incluir su código, tests y documentación correspondiente:

1. Base Vinext.
2. Motor de reglas de Petteia.
3. Tablero 2D jugable.
4. Escena 2.5D.
5. Animaciones e interacción.
6. Persistencia y accesibilidad.
7. Verificación y despliegue.
8. Retiro de Flutter y documentación final.

Se debe evitar crear un único cambio grande. Cada entrega debe poder revisarse y revertirse de forma razonable.

## 8. Criterios de finalización del MVP

El MVP estará terminado cuando:

- una partida local pueda jugarse de principio a fin;
- todas las reglas aprobadas estén cubiertas por tests;
- los movimientos inválidos sean rechazados correctamente;
- las capturas y condiciones de victoria sean deterministas;
- la escena 2.5D refleje siempre el estado del motor;
- exista un modo accesible sin depender exclusivamente del Canvas;
- la partida pueda guardarse y restaurarse localmente;
- typecheck, lint, tests y build pasen;
- la aplicación pueda desplegarse como preview.

## 9. Riesgos principales

- **Reglas ambiguas:** se mitigan aprobando primero una especificación concreta.
- **Vinext todavía evoluciona:** se valida su versión y build antes de acoplar funcionalidades.
- **Canvas poco accesible:** se mantiene un tablero HTML/2D alternativo.
- **Problemas de rendimiento en móviles:** se limita la complejidad visual y se mide desde la primera escena 3D.
- **Mezcla accidental con Flutter:** el desarrollo comienza aislado y el código anterior se retira sólo al final.
- **Exceso de alcance:** multiplayer, IA y backend quedan explícitamente fuera del MVP.
