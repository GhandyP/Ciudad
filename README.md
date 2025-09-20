# Petteia Flutter

Un juego de Petteia moderno y elegante desarrollado con Flutter para múltiples plataformas.

## Características

- 🎮 **Interfaz moderna** con Material Design 3
- 📱 **Multiplataforma** - Android, iOS, Web y Desktop
- 💾 **Guardado automático** de partidas
- 🔊 **Efectos de sonido** y vibración
- 🎯 **Múltiples niveles de dificultad**
- 📊 **Historial de movimientos**
- 🌙 **Tema oscuro/claro** con modo sistema
- ⚡ **Animaciones fluidas** y responsivas

## Tecnologías

- **Flutter** 3.19+ - Framework principal
- **Dart** 3.0+ - Lenguaje de programación
- **Provider** - State management
- **Shared Preferences** - Persistencia local
- **AudioPlayers** - Efectos de sonido
- **Material Design 3** - Interfaz de usuario

## Estructura del proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── models/                   # Modelos de datos
│   ├── position.dart        # Posiciones del tablero
│   ├── piece.dart           # Piezas de Petteia
│   ├── move.dart            # Movimientos
│   ├── game_state.dart      # Estado del juego
│   └── board.dart           # Tablero de Petteia
├── providers/               # State management
│   └── game_provider.dart   # Provider del juego
├── screens/                 # Pantallas principales
│   ├── home_screen.dart     # Pantalla de inicio
│   ├── game_screen.dart     # Pantalla del juego
│   ├── settings_screen.dart # Configuración
│   └── about_screen.dart    # Acerca de
├── widgets/                 # Widgets reutilizables
│   ├── chess_board.dart     # Tablero de Petteia
│   ├── chess_piece.dart     # Piezas individuales
│   ├── game_controls.dart   # Controles del juego
│   └── game_status.dart     # Estado del juego
└── services/                # Servicios
    ├── game_storage.dart    # Persistencia de juegos
    └── preferences_service.dart # Preferencias de usuario
```

## Instalación

1. **Requisitos previos:**
   - Flutter SDK 3.19+
   - Dart SDK 3.0+
   - Android Studio o VS Code con Flutter extension

2. **Clonar el proyecto:**
    ```bash
    git clone <repository-url>
    cd petteia_flutter
    ```

3. **Instalar dependencias:**
   ```bash
   flutter pub get
   ```

4. **Ejecutar la aplicación:**
   ```bash
   # Para Android
   flutter run

   # Para iOS
   flutter run

   # Para Web
   flutter run -d chrome

   # Para Desktop (Windows/Linux/Mac)
   flutter run -d windows
   # flutter run -d linux
   # flutter run -d macos
   ```

## Configuración

### Plataformas soportadas

El proyecto está configurado para funcionar en:

- **Android** (API 21+)
- **iOS** (iOS 11+)
- **Web** (Chrome, Firefox, Safari, Edge)
- **Windows** (Windows 10+)
- **Linux** (Ubuntu 18.04+, CentOS 7+)
- **macOS** (macOS 10.14+)

### Configuración de análisis de código

El proyecto incluye configuración de análisis estático:

```bash
# Ejecutar análisis
flutter analyze

# Ejecutar tests
flutter test

# Ejecutar tests con cobertura
flutter test --coverage
```

## Uso

### Jugabilidad básica

1. **Iniciar una partida:** Presiona "Jugar" en la pantalla principal
2. **Seleccionar pieza:** Toca una pieza para ver movimientos posibles
3. **Mover pieza:** Toca el destino para completar el movimiento
4. **Controles:** Usa los botones para guardar, cargar o reiniciar

### Configuración

Accede a la configuración desde el menú principal para:

- Activar/desactivar sonido y vibración
- Cambiar tema (claro, oscuro, sistema)
- Ajustar nivel de dificultad
- Configurar orientación del tablero
- Gestionar datos guardados

## Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agrega nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## Testing

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar tests específicos
flutter test test/position_test.dart

# Ejecutar tests con reporte de cobertura
flutter test --coverage
```

## Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## Soporte

Para soporte y preguntas:

- 📧 Email: support@petteiaflutter.com
- 🐛 Reportar bugs: [Issues](https://github.com/tu-usuario/petteia-flutter/issues)
- 📖 Documentación: [Wiki](https://github.com/tu-usuario/petteia-flutter/wiki)

## Roadmap

- [ ] Implementar lógica completa del Petteia
- [ ] Agregar modo multijugador local
- [ ] Implementar IA para jugar contra la máquina
- [ ] Agregar más temas y personalización
- [ ] Implementar modo de análisis de partidas
- [ ] Agregar soporte para notación PGN
- [ ] Implementar modo de entrenamiento/tutoría

---

**Desarrollado con ❤️ usando Flutter**