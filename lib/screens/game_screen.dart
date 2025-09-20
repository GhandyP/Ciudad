import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/chess_board.dart';
import '../widgets/game_controls.dart';
import '../widgets/game_status.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partida de Ajedrez'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showExitDialog(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _showResetDialog(context),
            tooltip: 'Reiniciar partida',
          ),
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          return Column(
            children: [
              // Estado del juego
              GameStatus(
                currentPlayer: gameProvider.currentState.currentPlayer,
                isInCheck: gameProvider.currentState.isInCheck,
                status: gameProvider.currentState.status,
              ),

              // Tablero de ajedrez
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ChessBoard(
                    gameState: gameProvider.currentState,
                    onSquareTapped: gameProvider.selectSquare,
                  ),
                ),
              ),

              // Controles del juego
              GameControls(
                onReset: () => _showResetDialog(context),
                onSave: () {}, // TODO: Implementar guardado
                onLoad: () {}, // TODO: Implementar carga
                onUndo: () => _showUndoDialog(context),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Salir de la partida?'),
          content: const Text(
            '¿Estás seguro de que quieres salir? Se perderá el progreso actual.'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
                Navigator.of(context).pop(); // Volver a home
              },
              child: const Text('Salir'),
            ),
          ],
        );
      },
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Reiniciar partida?'),
          content: const Text(
            '¿Estás seguro de que quieres reiniciar? Se perderá todo el progreso.'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                context.read<GameProvider>().resetGame();
                Navigator.of(context).pop();
              },
              child: const Text('Reiniciar'),
            ),
          ],
        );
      },
    );
  }

  void _showUndoDialog(BuildContext context) {
    final gameProvider = context.read<GameProvider>();
    final canUndo = gameProvider.moveHistory.isNotEmpty;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deshacer movimiento'),
          content: Text(
            canUndo
                ? '¿Deseas deshacer el último movimiento?'
                : 'No hay movimientos para deshacer.'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            if (canUndo)
              TextButton(
                onPressed: () {
                  // TODO: Implementar deshacer movimiento
                  Navigator.of(context).pop();
                },
                child: const Text('Deshacer'),
              ),
          ],
        );
      },
    );
  }
}