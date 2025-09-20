import 'package:flutter/foundation.dart';
import 'piece.dart';
import 'position.dart';
import 'board.dart';

class Knight {
  static List<Position> getPossibleMoves(
    Position position,
    PieceColor color,
    Board board, {
    bool checkForCheck = true,
  }) {
    final moves = <Position>[];

    // Los 8 posibles movimientos del caballo en forma de L
    final knightMoves = [
      [-2, -1], [-2, 1], // Dos arriba
      [-1, -2], [1, -2], // Uno arriba, dos a los lados
      [2, -1], [2, 1],   // Dos abajo
      [-1, 2], [1, 2],   // Uno abajo, dos a los lados
    ];

    for (final move in knightMoves) {
      final newRow = position.row + move[0];
      final newCol = position.col + move[1];
      final newPos = Position(newRow, newCol);

      if (!board.isValidPosition(newPos)) continue;

      final pieceAtPos = board.getPieceAt(newPos);

      // Puede moverse a casillas vacías o capturar piezas enemigas
      if (pieceAtPos == null || pieceAtPos.color != color) {
        moves.add(newPos);
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