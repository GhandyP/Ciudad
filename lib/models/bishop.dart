import 'package:flutter/foundation.dart';
import 'piece.dart';
import 'position.dart';
import 'board.dart';

class Bishop {
  static List<Position> getPossibleMoves(
    Position position,
    PieceColor color,
    Board board, {
    bool checkForCheck = true,
  }) {
    final moves = <Position>[];

    // Movimientos diagonales
    final directions = [
      [-1, -1], // Arriba-izquierda
      [-1, 1],  // Arriba-derecha
      [1, -1],  // Abajo-izquierda
      [1, 1],   // Abajo-derecha
    ];

    for (final direction in directions) {
      for (int i = 1; i < 8; i++) {
        final newRow = position.row + direction[0] * i;
        final newCol = position.col + direction[1] * i;
        final newPos = Position(newRow, newCol);

        if (!board.isValidPosition(newPos)) break;

        final pieceAtPos = board.getPieceAt(newPos);

        if (pieceAtPos == null) {
          // Casilla vacía, puede moverse
          moves.add(newPos);
        } else if (pieceAtPos.color != color) {
          // Pieza enemiga, puede capturar
          moves.add(newPos);
          break; // No puede seguir en esa dirección
        } else {
          // Pieza propia, no puede pasar
          break;
        }
      }
    }

    if (checkForCheck) {
      return _filterMovesThatDontLeaveKingInCheck(position, moves, color, board);
    }

    return moves;
  }

  static List<Position> _filterMovesThatDontLeaveKingInCheck(
    Position from,
    List<Position> moves,
    PieceColor color,
    Board board,
  ) {
    return moves.where((to) {
      // Simular el movimiento
      final newBoard = board.movePiece(from, to);
      // Verificar si el rey del color actual queda en jaque
      return !ChessRules.isInCheck(color, newBoard);
    }).toList();
  }
}