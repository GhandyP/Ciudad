import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/position.dart';
import '../models/piece.dart';
import '../models/move.dart';

class ChessBoard extends StatelessWidget {
  final GameState gameState;
  final Function(Position) onSquareTapped;

  const ChessBoard({
    super.key,
    required this.gameState,
    required this.onSquareTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
          ),
          itemCount: 64,
          itemBuilder: (context, index) {
            final row = index ~/ 8;
            final col = index % 8;
            final position = Position(row, col);
            final piece = gameState.board[row][col];
            final isLight = (row + col) % 2 == 0;
            final isSelected = gameState.selectedSquare == position;
            final isPossibleMove = gameState.possibleMoves.contains(position);
            final isLastMove = _isLastMove(position, gameState.moveHistory);

            return _Square(
              position: position,
              piece: piece,
              isLight: isLight,
              isSelected: isSelected,
              isPossibleMove: isPossibleMove,
              isLastMove: isLastMove,
              onTap: () => onSquareTapped(position),
            );
          },
        ),
      ),
    );
  }

  bool _isLastMove(Position position, List<Move> moveHistory) {
    if (moveHistory.isEmpty) return false;
    final lastMove = moveHistory.last;
    return lastMove.from == position || lastMove.to == position;
  }
}

class _Square extends StatelessWidget {
  final Position position;
  final Piece? piece;
  final bool isLight;
  final bool isSelected;
  final bool isPossibleMove;
  final bool isLastMove;
  final VoidCallback onTap;

  const _Square({
    required this.position,
    required this.piece,
    required this.isLight,
    required this.isSelected,
    required this.isPossibleMove,
    required this.isLastMove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _getSquareColor(context),
          border: _getBorder(context),
        ),
        child: Stack(
          children: [
            // Indicador de movimiento posible
            if (isPossibleMove)
              Center(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),

            // Pieza de ajedrez
            if (piece != null)
              Center(
                child: Text(
                  piece!.symbol,
                  style: const TextStyle(
                    fontSize: 32,
                    height: 1,
                  ),
                ),
              ),

            // Coordenadas del tablero (solo en los bordes)
            if (_shouldShowCoordinate())
              Positioned(
                bottom: 2,
                right: 2,
                child: Text(
                  _getCoordinateText(),
                  style: TextStyle(
                    fontSize: 8,
                    color: isLight ? Colors.black54 : Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getSquareColor(BuildContext context) {
    Color baseColor;

    if (isLight) {
      baseColor = const Color(0xFFEEEED2); // Color claro del tablero
    } else {
      baseColor = const Color(0xFF769656); // Color oscuro del tablero
    }

    // Resaltar casilla seleccionada
    if (isSelected) {
      baseColor = Theme.of(context).colorScheme.primary.withOpacity(0.5);
    }

    // Resaltar movimientos posibles
    if (isPossibleMove && !isSelected) {
      baseColor = baseColor.withOpacity(0.7);
    }

    // Resaltar último movimiento
    if (isLastMove && !isSelected && !isPossibleMove) {
      baseColor = baseColor.withOpacity(0.8);
    }

    return baseColor;
  }

  Border? _getBorder(BuildContext context) {
    // Mostrar borde en casillas seleccionadas, movimientos posibles o último movimiento
    if (isSelected || isPossibleMove || isLastMove) {
      return Border.all(
        color: isLastMove && !isSelected && !isPossibleMove
            ? Theme.of(context).colorScheme.secondary.withOpacity(0.7)
            : Theme.of(context).colorScheme.primary,
        width: isSelected ? 3 : 2,
      );
    }
    return null;
  }

  bool _shouldShowCoordinate() {
    // Mostrar coordenadas solo en los bordes del tablero
    return position.row == 7 || position.col == 0;
  }

  String _getCoordinateText() {
    if (position.row == 7) {
      // Fila inferior: mostrar letras (a-h)
      const files = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
      return files[position.col];
    } else if (position.col == 0) {
      // Columna izquierda: mostrar números (1-8)
      return '${8 - position.row}';
    }
    return '';
  }
}