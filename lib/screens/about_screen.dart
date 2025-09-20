import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo de la aplicación
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.sports_esports,
                size: 64,
                color: Colors.brown,
              ),
            ),

            const SizedBox(height: 24),

            // Título de la aplicación
            Text(
              'Chess Flutter',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Versión 1.0.0',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Descripción
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Descripción',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Chess Flutter es un juego de ajedrez moderno y elegante, '
                      'desarrollado con Flutter para ofrecer una experiencia de juego '
                      'fluida en múltiples plataformas. Disfruta del ajedrez clásico '
                      'con una interfaz intuitiva y características avanzadas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Características
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Características',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.check_circle, color: Colors.green),
                          title: Text('Interfaz moderna con Material Design 3'),
                          dense: true,
                        ),
                        ListTile(
                          leading: Icon(Icons.check_circle, color: Colors.green),
                          title: Text('Soporte multiplataforma'),
                          subtitle: Text('Android, iOS, Web y Desktop'),
                          dense: true,
                        ),
                        ListTile(
                          leading: Icon(Icons.check_circle, color: Colors.green),
                          title: Text('Guardado automático de partidas'),
                          dense: true,
                        ),
                        ListTile(
                          leading: Icon(Icons.check_circle, color: Colors.green),
                          title: Text('Efectos de sonido y vibración'),
                          dense: true,
                        ),
                        ListTile(
                          leading: Icon(Icons.check_circle, color: Colors.green),
                          title: Text('Múltiples niveles de dificultad'),
                          dense: true,
                        ),
                        ListTile(
                          leading: Icon(Icons.check_circle, color: Colors.green),
                          title: Text('Historial de movimientos'),
                          dense: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Tecnologías
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Tecnologías utilizadas',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildTechChip('Flutter'),
                        _buildTechChip('Dart'),
                        _buildTechChip('Provider'),
                        _buildTechChip('Material Design 3'),
                        _buildTechChip('Shared Preferences'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Información del desarrollador
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Desarrollado por',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Chess Flutter es desarrollado con pasión por crear '
                      'experiencias de juego excepcionales. El proyecto está '
                      'inspirado en el ajedrez clásico y busca hacer que este '
                      'juego milenario sea accesible para todos.',
                      textAlign: TextAlign.center,
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Enlaces
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _launchURL('https://flutter.dev'),
                  icon: const Icon(Icons.link),
                  tooltip: 'Sitio web de Flutter',
                ),
                IconButton(
                  onPressed: () => _launchURL('https://github.com'),
                  icon: const Icon(Icons.code),
                  tooltip: 'Código fuente',
                ),
                IconButton(
                  onPressed: () => _launchURL('mailto:support@example.com'),
                  icon: const Icon(Icons.email),
                  tooltip: 'Contacto',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Derechos de autor
            Text(
              '© 2024 Chess Flutter. Todos los derechos reservados.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.brown.withOpacity(0.1),
      labelStyle: const TextStyle(color: Colors.brown),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}