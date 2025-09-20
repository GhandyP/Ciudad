import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _vibrationEnabledKey = 'vibration_enabled';
  static const String _autoSaveEnabledKey = 'auto_save_enabled';
  static const String _difficultyKey = 'difficulty';
  static const String _themeKey = 'theme';
  static const String _boardOrientationKey = 'board_orientation';
  static const String _showCoordinatesKey = 'show_coordinates';
  static const String _animationSpeedKey = 'animation_speed';
  static const String _firstTimeUserKey = 'first_time_user';

  // Configuración de sonido
  Future<bool> getSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_soundEnabledKey) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, enabled);
  }

  // Configuración de vibración
  Future<bool> getVibrationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_vibrationEnabledKey) ?? true;
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrationEnabledKey, enabled);
  }

  // Configuración de guardado automático
  Future<bool> getAutoSaveEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoSaveEnabledKey) ?? true;
  }

  Future<void> setAutoSaveEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoSaveEnabledKey, enabled);
  }

  // Configuración de dificultad
  Future<String> getDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_difficultyKey) ?? 'medium';
  }

  Future<void> setDifficulty(String difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_difficultyKey, difficulty);
  }

  // Configuración de tema
  Future<String> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey) ?? 'system';
  }

  Future<void> setTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme);
  }

  // Configuración de orientación del tablero
  Future<String> getBoardOrientation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_boardOrientationKey) ?? 'white_bottom';
  }

  Future<void> setBoardOrientation(String orientation) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_boardOrientationKey, orientation);
  }

  // Configuración de mostrar coordenadas
  Future<bool> getShowCoordinates() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showCoordinatesKey) ?? true;
  }

  Future<void> setShowCoordinates(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showCoordinatesKey, show);
  }

  // Configuración de velocidad de animación
  Future<String> getAnimationSpeed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_animationSpeedKey) ?? 'normal';
  }

  Future<void> setAnimationSpeed(String speed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_animationSpeedKey, speed);
  }

  // Verificar si es la primera vez que usa la aplicación
  Future<bool> isFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool(_firstTimeUserKey) ?? true;
    if (isFirstTime) {
      await prefs.setBool(_firstTimeUserKey, false);
    }
    return isFirstTime;
  }

  // Obtener todas las preferencias
  Future<Map<String, dynamic>> getAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'soundEnabled': prefs.getBool(_soundEnabledKey) ?? true,
      'vibrationEnabled': prefs.getBool(_vibrationEnabledKey) ?? true,
      'autoSaveEnabled': prefs.getBool(_autoSaveEnabledKey) ?? true,
      'difficulty': prefs.getString(_difficultyKey) ?? 'medium',
      'theme': prefs.getString(_themeKey) ?? 'system',
      'boardOrientation': prefs.getString(_boardOrientationKey) ?? 'white_bottom',
      'showCoordinates': prefs.getBool(_showCoordinatesKey) ?? true,
      'animationSpeed': prefs.getString(_animationSpeedKey) ?? 'normal',
    };
  }

  // Restablecer todas las preferencias a valores por defecto
  Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEnabledKey, true);
    await prefs.setBool(_vibrationEnabledKey, true);
    await prefs.setBool(_autoSaveEnabledKey, true);
    await prefs.setString(_difficultyKey, 'medium');
    await prefs.setString(_themeKey, 'system');
    await prefs.setString(_boardOrientationKey, 'white_bottom');
    await prefs.setBool(_showCoordinatesKey, true);
    await prefs.setString(_animationSpeedKey, 'normal');
  }

  // Métodos de conveniencia para obtener valores con tipos específicos

  Future<Difficulty> getDifficultyEnum() async {
    final difficultyStr = await getDifficulty();
    return _stringToDifficulty(difficultyStr);
  }

  Future<ThemeMode> getThemeMode() async {
    final themeStr = await getTheme();
    return _stringToThemeMode(themeStr);
  }

  Future<AnimationSpeed> getAnimationSpeedEnum() async {
    final speedStr = await getAnimationSpeed();
    return _stringToAnimationSpeed(speedStr);
  }

  // Utilidades de conversión
  Difficulty _stringToDifficulty(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return Difficulty.easy;
      case 'hard':
        return Difficulty.hard;
      case 'expert':
        return Difficulty.expert;
      case 'medium':
      default:
        return Difficulty.medium;
    }
  }

  ThemeMode _stringToThemeMode(String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  AnimationSpeed _stringToAnimationSpeed(String speed) {
    switch (speed) {
      case 'slow':
        return AnimationSpeed.slow;
      case 'fast':
        return AnimationSpeed.fast;
      case 'normal':
      default:
        return AnimationSpeed.normal;
    }
  }
}

// Enums para tipos específicos
enum Difficulty {
  easy,
  medium,
  hard,
  expert,
}

enum AnimationSpeed {
  slow,
  normal,
  fast,
}

// Extensiones para obtener nombres localizados
extension DifficultyExtension on Difficulty {
  String get displayName {
    switch (this) {
      case Difficulty.easy:
        return 'Fácil';
      case Difficulty.medium:
        return 'Medio';
      case Difficulty.hard:
        return 'Difícil';
      case Difficulty.expert:
        return 'Experto';
    }
  }

  String get key => toString().split('.').last;
}

extension AnimationSpeedExtension on AnimationSpeed {
  String get displayName {
    switch (this) {
      case AnimationSpeed.slow:
        return 'Lento';
      case AnimationSpeed.normal:
        return 'Normal';
      case AnimationSpeed.fast:
        return 'Rápido';
    }
  }

  String get key => toString().split('.').last;
}