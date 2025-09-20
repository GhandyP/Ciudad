import 'package:flutter/foundation.dart';
import 'piece.dart';
import 'position.dart';
import 'board.dart';
import 'move.dart';

class Pawn {
  static List<Position> getPossibleMoves(
    Position position,
    PieceColor color,
    Board board, {
    bool checkForCheck = true,
    Move? lastMove,
  }) {
    final moves = <Position>[];
    final direction = color == PieceColor.white ? -1 : 1;
    final startRow = color == PieceColor.white ? 6 : 1;

    // Movimiento hacia adelante una casilla
    final oneStep = Position(position.row + direction, position.col);
    if (board.isEmpty(oneStep)) {
      moves.add(oneStep);

      // Movimiento hacia adelante dos casillas desde la posición inicial
      if (position.row == startRow) {
        final twoSteps = Position(position.row + 2 * direction, position.col);
        if (board.isEmpty(twoSteps)) {
          moves.add(twoSteps);
        }
      }
    }

    // Capturas diagonales
    for (int dCol = -1; dCol <= 1; dCol += 2) {
      final capturePos = Position(position.row + direction, position.col + dCol);
      if (board.isOpponentPiece(capturePos, color)) {
        moves.add(capturePos);
      }
    }

    // Implementar captura al paso (en passant)
    _addEnPassantMoves(position, color, board, moves, lastMove);

    if (checkForCheck) {
      return _filterMovesThatDontLeaveKingInCheck(position, moves, color, board);
    }

    return moves;
  }

  static bool canPromote(Position position, PieceColor color) {
    return (color == PieceColor.white && position.row == 0) ||
           (color == PieceColor.black && position.row == 7);
  }

  static void _addEnPassantMoves(
    Position position,
    PieceColor color,
    Board board,
    List<Position> moves,
    Move? lastMove,
  ) {
    if (lastMove == null || lastMove.moveType != MoveType.normal || lastMove.piece.type != PieceType.pawn) {
      return;
    }

    final fromRow = lastMove.from.row;
    final toRow = lastMove.to.row;
    final deltaRow = (toRow - fromRow).abs();

    // Verificar si el peón movió dos casillas
    if (deltaRow != 2) return;

    final passantCol = lastMove.to.col;
    final pawnRow = position.row;
    final pawnCol = position.col;

    // Verificar si el peón actual está en la fila correcta para en passant
    final passantRow = color == PieceColor.white ? 4 : 3;
    if (pawnRow != passantRow) return;

    // Verificar si está en columna adyacente
    if ((pawnCol - passantCol).abs() != 1) return;

    // La posición de captura
    final captureRow = color == PieceColor.white ? 5 : 2;
    final capturePos = Position(captureRow, passantCol);

    // Verificar que la posición esté vacía (la captura al paso captura la pieza en passantCol, passantRow)
    if (board.isEmpty(capturePos)) {
      moves.add(capturePos);
    }
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