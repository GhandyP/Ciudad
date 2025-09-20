import 'package:flutter/foundation.dart';
import 'piece.dart';
import 'position.dart';
import 'board.dart';
import 'pawn.dart';
import 'rook.dart';
import 'knight.dart';
import 'bishop.dart';
import 'queen.dart';
import 'king.dart';

class ChessRules {
  // Obtener todos los movimientos posibles para una pieza en una posición
  static List<Position> getPossibleMoves(
    Position position,
    Board board, {
    bool checkForCheck = true,
  }) {
    final piece = board.getPieceAt(position);
    if (piece == null) return [];

    switch (piece.type) {
      case PieceType.pawn:
        return Pawn.getPossibleMoves(position, piece.color, board, checkForCheck: checkForCheck, lastMove: board.lastMove);
      case PieceType.rook:
        return Rook.getPossibleMoves(position, piece.color, board, checkForCheck: checkForCheck);
      case PieceType.knight:
        return Knight.getPossibleMoves(position, piece.color, board, checkForCheck: checkForCheck);
      case PieceType.bishop:
        return Bishop.getPossibleMoves(position, piece.color, board, checkForCheck: checkForCheck);
      case PieceType.queen:
        return Queen.getPossibleMoves(position, piece.color, board, checkForCheck: checkForCheck);
      case PieceType.king:
        return King.getPossibleMoves(position, piece.color, board, checkForCheck: checkForCheck);
    }
  }

  // Verificar si un color está en jaque
  static bool isInCheck(PieceColor color, Board board) {
    final kingPosition = _findKingPosition(color, board);
    if (kingPosition == null) return false;

    final opponentColor = color == PieceColor.white ? PieceColor.black : PieceColor.white;

    // Verificar si alguna pieza del oponente puede atacar al rey
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = board.squares[row][col];
        if (piece != null && piece.color == opponentColor) {
          final moves = getPossibleMoves(Position(row, col), board, checkForCheck: false);
          if (moves.contains(kingPosition)) {
            return true;
          }
        }
      }
    }

    return false;
  }

  // Verificar si un movimiento es legal (no deja al rey en jaque)
  static bool isLegalMove(Position from, Position to, Board board) {
    final piece = board.getPieceAt(from);
    if (piece == null) return false;

    // Verificar que el movimiento esté en los movimientos posibles de la pieza
    final possibleMoves = getPossibleMoves(from, board, checkForCheck: false);
    if (!possibleMoves.contains(to)) return false;

    // Simular el movimiento y verificar que no deje al rey en jaque
    final newBoard = board.movePiece(from, to);
    return !isInCheck(piece.color, newBoard);
  }

  // Verificar si el juego está en jaque mate
  static bool isCheckmate(PieceColor color, Board board) {
    if (!isInCheck(color, board)) return false;

    // Verificar si hay algún movimiento legal disponible
    return _hasNoLegalMoves(color, board);
  }

  // Verificar si el juego está en ahogado (stalemate)
  static bool isStalemate(PieceColor color, Board board) {
    if (isInCheck(color, board)) return false;

    // Verificar si hay algún movimiento legal disponible
    return _hasNoLegalMoves(color, board);
  }

  // Obtener todas las posiciones donde un color puede moverse
  static List<Position> getAllPossibleMoves(PieceColor color, Board board) {
    final allMoves = <Position>[];

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = board.squares[row][col];
        if (piece != null && piece.color == color) {
          final moves = getPossibleMoves(Position(row, col), board);
          allMoves.addAll(moves);
        }
      }
    }

    return allMoves;
  }

  // Verificar si un color tiene algún movimiento legal
  static bool _hasNoLegalMoves(PieceColor color, Board board) {
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = board.squares[row][col];
        if (piece != null && piece.color == color) {
          final moves = getPossibleMoves(Position(row, col), board);
          if (moves.isNotEmpty) {
            return false;
          }
        }
      }
    }
    return true;
  }

  // Encontrar la posición del rey de un color
  static Position? _findKingPosition(PieceColor color, Board board) {
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = board.squares[row][col];
        if (piece != null && piece.type == PieceType.king && piece.color == color) {
          return Position(row, col);
        }
      }
    }
    return null;
  }

  // Verificar si una posición está siendo atacada por el color oponente
  static bool isSquareAttacked(Position position, PieceColor byColor, Board board) {
    final opponentColor = byColor == PieceColor.white ? PieceColor.black : PieceColor.white;

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = board.squares[row][col];
        if (piece != null && piece.color == opponentColor) {
          final moves = getPossibleMoves(Position(row, col), board, checkForCheck: false);
          if (moves.contains(position)) {
            return true;
          }
        }
      }
    }

    return false;
  }
}