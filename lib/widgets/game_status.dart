import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/piece.dart';

class GameStatus extends StatelessWidget {
  final PieceColor currentPlayer;
  final bool isInCheck;
  final GameStatus status;

  const GameStatus({
    super.key,
    required this.currentPlayer,
    required this.isInCheck,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor(context),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Turno actual
          Row(
            children: [
              Icon(
                currentPlayer == PieceColor.white
                    ? Icons.person
                    : Icons.person_outline,
                color: currentPlayer == PieceColor.white
                    ? Colors.white
                    : Colors.black,
              ),
              const SizedBox(width: 8),
              Text(
                'Turno: ${currentPlayer == PieceColor.white ? 'Blancas' : 'Negras'}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _getTextColor(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Estado del juego
          Row(
            children: [
              Icon(
                _getStatusIcon(),
                color: _getTextColor(context),
              ),
              const SizedBox(width: 8),
              Text(
                _getStatusText(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _getTextColor(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BuildContext context) {
    if (status == GameStatus.checkmate) {
      return Colors.red;
    } else if (status == GameStatus.check) {
      return Colors.orange;
    } else if (status == GameStatus.stalemate || status == GameStatus.draw) {
      return Colors.grey;
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }

  Color _getTextColor(BuildContext context) {
    if (status == GameStatus.checkmate) {
      return Colors.white;
    } else if (status == GameStatus.check) {
      return Colors.white;
    } else if (status == GameStatus.stalemate || status == GameStatus.draw) {
      return Colors.white;
    } else {
      return Theme.of(context).colorScheme.onPrimary;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case GameStatus.checkmate:
        return Icons.cancel;
      case GameStatus.check:
        return Icons.warning;
      case GameStatus.stalemate:
        return Icons.balance;
      case GameStatus.draw:
        return Icons.handshake;
      case GameStatus.active:
      default:
        return Icons.play_arrow;
    }
  }

  String _getStatusText() {
    switch (status) {
      case GameStatus.checkmate:
        return 'Jaque mate';
      case GameStatus.check:
        return 'Jaque';
      case GameStatus.stalemate:
        return 'Ahogado';
      case GameStatus.draw:
        return 'Tablas';
      case GameStatus.active:
      default:
        return 'En juego';
    }
  }
}

// Widget para mostrar información detallada del juego
class GameInfo extends StatelessWidget {
  final int moveCount;
  final int captureCount;
  final Duration gameDuration;
  final bool isPlayerTurn;

  const GameInfo({
    super.key,
    required this.moveCount,
    required this.captureCount,
    required this.gameDuration,
    required this.isPlayerTurn,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Información de la partida',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoColumn(
                  context,
                  'Movimientos',
                  moveCount.toString(),
                  Icons.swap_horiz,
                ),
                _buildInfoColumn(
                  context,
                  'Capturas',
                  captureCount.toString(),
                  Icons.delete,
                ),
                _buildInfoColumn(
                  context,
                  'Tiempo',
                  _formatDuration(gameDuration),
                  Icons.timer,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isPlayerTurn
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isPlayerTurn ? 'Es tu turno' : 'Turno del oponente',
                style: TextStyle(
                  color: isPlayerTurn
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}