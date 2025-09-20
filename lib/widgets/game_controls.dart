import 'package:flutter/material.dart';

class GameControls extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onSave;
  final VoidCallback onLoad;
  final VoidCallback onUndo;

  const GameControls({
    super.key,
    required this.onReset,
    required this.onSave,
    required this.onLoad,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Estado del juego
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGameStatusChip(context, 'Turno: Blancas', Icons.person),
              _buildGameStatusChip(context, 'Estado: Activo', Icons.play_arrow),
            ],
          ),

          const SizedBox(height: 16),

          // Controles principales
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                context,
                'Reiniciar',
                Icons.refresh,
                onReset,
                Colors.blue,
              ),
              _buildControlButton(
                context,
                'Guardar',
                Icons.save,
                onSave,
                Colors.green,
              ),
              _buildControlButton(
                context,
                'Cargar',
                Icons.folder_open,
                onLoad,
                Colors.orange,
              ),
              _buildControlButton(
                context,
                'Deshacer',
                Icons.undo,
                onUndo,
                Colors.purple,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Información adicional
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem(context, 'Movimientos', '0'),
              _buildInfoItem(context, 'Capturas', '0'),
              _buildInfoItem(context, 'Tiempo', '00:00'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameStatusChip(BuildContext context, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
    Color color,
  ) {
    return Column(
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: color,
          child: Icon(icon),
          heroTag: label,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

// Widget para mostrar el historial de movimientos
class MoveHistory extends StatelessWidget {
  final List<String> moves;
  final VoidCallback? onMoveSelected;

  const MoveHistory({
    super.key,
    required this.moves,
    this.onMoveSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (moves.isEmpty) {
      return const Center(
        child: Text('No hay movimientos aún'),
      );
    }

    return ListView.builder(
      itemCount: (moves.length / 2).ceil(),
      itemBuilder: (context, index) {
        final whiteMove = index * 2 < moves.length ? moves[index * 2] : '';
        final blackMove = index * 2 + 1 < moves.length ? moves[index * 2 + 1] : '';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Text(
                  '${index + 1}.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: whiteMove.isNotEmpty ? () => onMoveSelected?.call() : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: whiteMove.isNotEmpty
                        ? BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(4),
                          )
                        : null,
                    child: Text(
                      whiteMove,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: blackMove.isNotEmpty ? () => onMoveSelected?.call() : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: blackMove.isNotEmpty
                        ? BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(4),
                          )
                        : null,
                    child: Text(
                      blackMove,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}