import 'package:flutter/foundation.dart';
import 'piece.dart';
import 'position.dart';
import 'board.dart';

class King {
  static List<Position> getPossibleMoves(
    Position position,
    PieceColor color,
    Board board, {
    bool checkForCheck = true,
  }) {
    final moves = <Position>[];

    // Movimientos básicos del rey (una casilla en todas las direcciones)
    for (int dRow = -1; dRow <= 1; dRow++) {
      for (int dCol = -1; dCol <= 1; dCol++) {
        if (dRow == 0 && dCol == 0) continue;

        final newPos = Position(position.row + dRow, position.col + dCol);

        if (!board.isValidPosition(newPos)) continue;

        final pieceAtPos = board.getPieceAt(newPos);

        // Puede moverse a casillas vacías o capturar piezas enemigas
        if (pieceAtPos == null || pieceAtPos.color != color) {
          // Verificar que el movimiento no deje al rey en jaque
          if (!checkForCheck || !_wouldBeInCheck(position, newPos, color, board)) {
            moves.add(newPos);
          }
        }
      }
    }

    // Enroque (castling)
    _addCastlingMoves(position, color, board, moves);

    return moves;
  }

  static bool _wouldBeInCheck(Position from, Position to, PieceColor color, Board board) {
    // Simular el movimiento
    final newBoard = board.movePiece(from, to);
    // Verificar si el rey queda en jaque
    return ChessRules.isInCheck(color, newBoard);
  }

  // TODO: Implementar enroque
  static void _addCastlingMoves(Position position, PieceColor color, Board board, List<Position> moves) {
    // Verificar si el rey ya se ha movido
    final king = board.getPieceAt(position);
    if (king?.hasMoved ?? true) return;

    // Enroque corto (king-side)
    if (_canCastleKingSide(position, color, board)) {
      moves.add(Position(position.row, position.col + 2));
    }

    // Enroque largo (queen-side)
    if (_canCastleQueenSide(position, color, board)) {
      moves.add(Position(position.row, position.col - 2));
    }
  }

  static bool _canCastleKingSide(Position position, PieceColor color, Board board) {
    // Verificar que el rey no esté en jaque
    if (ChessRules.isInCheck(color, board)) return false;

    // Posiciones para blanco y negro
    final row = color == PieceColor.white ? 7 : 0;
    final rookCol = 7; // h-file

    // Verificar que el rey esté en la posición inicial
    if (position.row != row || position.col != 4) return false;

    // Verificar que la torre esté en su posición inicial y no haya movido
    final rook = board.getPieceAt(Position(row, rookCol));
    if (rook == null || rook.type != PieceType.rook || rook.hasMoved) return false;

    // Verificar que las casillas entre rey y torre estén vacías
    for (int col = 5; col < 7; col++) {
      if (!board.isEmpty(Position(row, col))) return false;
    }

    // Verificar que las casillas que el rey cruza no estén atacadas
    final opponentColor = color == PieceColor.white ? PieceColor.black : PieceColor.white;
    for (int col = 4; col <= 6; col++) {
      if (ChessRules.isSquareAttacked(Position(row, col), opponentColor, board)) return false;
    }

    return true;
  }

  static bool _canCastleQueenSide(Position position, PieceColor color, Board board) {
    // Verificar que el rey no esté en jaque
    if (ChessRules.isInCheck(color, board)) return false;

    // Posiciones para blanco y negro
    final row = color == PieceColor.white ? 7 : 0;
    final rookCol = 0; // a-file

    // Verificar que el rey esté en la posición inicial
    if (position.row != row || position.col != 4) return false;

    // Verificar que la torre esté en su posición inicial y no haya movido
    final rook = board.getPieceAt(Position(row, rookCol));
    if (rook == null || rook.type != PieceType.rook || rook.hasMoved) return false;

    // Verificar que las casillas entre rey y torre estén vacías
    for (int col = 1; col < 4; col++) {
      if (!board.isEmpty(Position(row, col))) return false;
    }

    // Verificar que las casillas que el rey cruza no estén atacadas
    final opponentColor = color == PieceColor.white ? PieceColor.black : PieceColor.white;
    for (int col = 2; col <= 4; col++) {
      if (ChessRules.isSquareAttacked(Position(row, col), opponentColor, board)) return false;
    }

    return true;
  }
}