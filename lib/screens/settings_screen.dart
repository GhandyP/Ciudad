import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _autoSaveEnabled = true;
  String _difficulty = 'medium';
  String _theme = 'system';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _soundEnabled = prefs.getBool('sound_enabled') ?? true;
      _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
      _autoSaveEnabled = prefs.getBool('auto_save_enabled') ?? true;
      _difficulty = prefs.getString('difficulty') ?? 'medium';
      _theme = prefs.getString('theme') ?? 'system';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sección de juego
          _buildSection(
            title: 'Juego',
            icon: Icons.sports_esports,
            children: [
              SwitchListTile(
                title: const Text('Sonido'),
                subtitle: const Text('Activar efectos de sonido'),
                value: _soundEnabled,
                onChanged: (value) {
                  setState(() => _soundEnabled = value);
                  _saveSetting('sound_enabled', value);
                },
              ),
              SwitchListTile(
                title: const Text('Vibración'),
                subtitle: const Text('Activar vibración en movimientos'),
                value: _vibrationEnabled,
                onChanged: (value) {
                  setState(() => _vibrationEnabled = value);
                  _saveSetting('vibration_enabled', value);
                },
              ),
              SwitchListTile(
                title: const Text('Guardado automático'),
                subtitle: const Text('Guardar partida automáticamente'),
                value: _autoSaveEnabled,
                onChanged: (value) {
                  setState(() => _autoSaveEnabled = value);
                  _saveSetting('auto_save_enabled', value);
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Sección de apariencia
          _buildSection(
            title: 'Apariencia',
            icon: Icons.palette,
            children: [
              ListTile(
                title: const Text('Tema'),
                subtitle: Text(_getThemeDisplayName(_theme)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showThemeSelectionDialog(),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Sección de dificultad
          _buildSection(
            title: 'Dificultad',
            icon: Icons.trending_up,
            children: [
              ListTile(
                title: const Text('Nivel de dificultad'),
                subtitle: Text(_getDifficultyDisplayName(_difficulty)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showDifficultySelectionDialog(),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Sección de datos
          _buildSection(
            title: 'Datos',
            icon: Icons.storage,
            children: [
              ListTile(
                title: const Text('Limpiar datos guardados'),
                subtitle: const Text('Eliminar todas las partidas guardadas'),
                trailing: const Icon(Icons.delete, color: Colors.red),
                onTap: () => _showClearDataDialog(),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Información de la aplicación
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Versión: 1.0.0'),
                  const Text('Desarrollado con Flutter'),
                  const Text('Compatible con Android, iOS, Web y Desktop'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  String _getThemeDisplayName(String theme) {
    switch (theme) {
      case 'light':
        return 'Claro';
      case 'dark':
        return 'Oscuro';
      case 'system':
      default:
        return 'Sistema';
    }
  }

  String _getDifficultyDisplayName(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return 'Fácil';
      case 'medium':
        return 'Medio';
      case 'hard':
        return 'Difícil';
      case 'expert':
        return 'Experto';
      default:
        return 'Medio';
    }
  }

  void _showThemeSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Sistema'),
              leading: Radio<String>(
                value: 'system',
                groupValue: _theme,
                onChanged: (value) {
                  setState(() => _theme = value!);
                  _saveSetting('theme', value);
                  Navigator.of(context).pop();
                },
              ),
            ),
            ListTile(
              title: const Text('Claro'),
              leading: Radio<String>(
                value: 'light',
                groupValue: _theme,
                onChanged: (value) {
                  setState(() => _theme = value!);
                  _saveSetting('theme', value);
                  Navigator.of(context).pop();
                },
              ),
            ),
            ListTile(
              title: const Text('Oscuro'),
              leading: Radio<String>(
                value: 'dark',
                groupValue: _theme,
                onChanged: (value) {
                  setState(() => _theme = value!);
                  _saveSetting('theme', value);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDifficultySelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar dificultad'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Fácil'),
              leading: Radio<String>(
                value: 'easy',
                groupValue: _difficulty,
                onChanged: (value) {
                  setState(() => _difficulty = value!);
                  _saveSetting('difficulty', value);
                  Navigator.of(context).pop();
                },
              ),
            ),
            ListTile(
              title: const Text('Medio'),
              leading: Radio<String>(
                value: 'medium',
                groupValue: _difficulty,
                onChanged: (value) {
                  setState(() => _difficulty = value!);
                  _saveSetting('difficulty', value);
                  Navigator.of(context).pop();
                },
              ),
            ),
            ListTile(
              title: const Text('Difícil'),
              leading: Radio<String>(
                value: 'hard',
                groupValue: _difficulty,
                onChanged: (value) {
                  setState(() => _difficulty = value!);
                  _saveSetting('difficulty', value);
                  Navigator.of(context).pop();
                },
              ),
            ),
            ListTile(
              title: const Text('Experto'),
              leading: Radio<String>(
                value: 'expert',
                groupValue: _difficulty,
                onChanged: (value) {
                  setState(() => _difficulty = value!);
                  _saveSetting('difficulty', value);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar datos'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar todos los datos guardados? Esta acción no se puede deshacer.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Datos eliminados correctamente')),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}