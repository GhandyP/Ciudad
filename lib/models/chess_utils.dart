import 'package:flutter/foundation.dart';
import 'piece.dart';
import 'position.dart';
import 'board.dart';
import 'move.dart';

class ChessUtils {
  // Convertir notación algebraica a posición (ej: 'e4' -> Position)
  static Position? algebraicToPosition(String algebraic) {
    if (algebraic.length != 2) return null;

    final col = algebraic[0].toLowerCase().codeUnitAt(0) - 'a'.codeUnitAt(0);
    final row = 8 - int.tryParse(algebraic[1])!;

    if (col < 0 || col > 7 || row < 0 || row > 7) return null;

    return Position(row, col);
  }

  // Convertir posición a notación algebraica (ej: Position -> 'e4')
  static String positionToAlgebraic(Position position) {
    final colChar = String.fromCharCode('a'.codeUnitAt(0) + position.col);
    final rowNum = (8 - position.row).toString();
    return '$colChar$rowNum';
  }

  // Validar si una notación algebraica es válida
  static bool isValidAlgebraicNotation(String notation) {
    if (notation.length != 2) return false;

    final col = notation[0].toLowerCase();
    final row = notation[1];

    return (col >= 'a' && col <= 'h') && (row >= '1' && row <= '8');
  }

  // Obtener el símbolo de una pieza para notación
  static String getPieceSymbol(Piece piece) {
    // En Petteia, todas las piezas son stones
    return piece.symbol;
  }

  // Generar notación completa de un movimiento
  static String generateMoveNotation(Move move) {
    final pieceSymbol = getPieceSymbol(move.piece);
    final captureSymbol = move.capturedPiece != null ? 'x' : '';
    final destination = positionToAlgebraic(move.to);
    final promotionSymbol = move.promotionPiece != null ? '=Q' : '';

    return '$pieceSymbol$captureSymbol$destination$promotionSymbol';
  }

  // Verificar si una posición está en el tablero
  static bool isValidPosition(Position position) {
    return position.row >= 0 && position.row < 8 &&
           position.col >= 0 && position.col < 8;
  }

  // Obtener todas las posiciones del tablero
  static List<Position> getAllPositions() {
    final positions = <Position>[];
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        positions.add(Position(row, col));
      }
    }
    return positions;
  }

  // Verificar si dos posiciones son adyacentes
  static bool areAdjacent(Position pos1, Position pos2) {
    final rowDiff = (pos1.row - pos2.row).abs();
    final colDiff = (pos1.col - pos2.col).abs();
    return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1);
  }

  // Obtener la distancia entre dos posiciones
  static int getDistance(Position pos1, Position pos2) {
    final rowDiff = (pos1.row - pos2.row).abs();
    final colDiff = (pos1.col - pos2.col).abs();
    return rowDiff + colDiff;
  }

  // Verificar si una posición está en una fila específica
  static bool isInRow(Position position, int row) {
    return position.row == row;
  }

  // Verificar si una posición está en una columna específica
  static bool isInColumn(Position position, int col) {
    return position.col == col;
  }

  // Verificar si una posición está en una diagonal específica
  static bool isInDiagonal(Position pos1, Position pos2) {
    final rowDiff = (pos1.row - pos2.row).abs();
    final colDiff = (pos1.col - pos2.col).abs();
    return rowDiff == colDiff;
  }

  // Obtener el color de la casilla (blanca o negra)
  static bool isLightSquare(Position position) {
    return (position.row + position.col) % 2 == 0;
  }

  // Obtener el nombre completo de una pieza
  static String getPieceName(Piece piece) {
    final color = piece.color == PieceColor.white ? 'blanca' : 'negra';
    final type = _getPieceTypeName(piece.type);
    return '$type $color';
  }

  static String _getPieceTypeName(PieceType type) {
    switch (type) {
      case PieceType.pawn:
        return 'Peón';
      case PieceType.rook:
        return 'Torre';
      case PieceType.knight:
        return 'Caballo';
      case PieceType.bishop:
        return 'Alfil';
      case PieceType.queen:
        return 'Reina';
      case PieceType.king:
        return 'Rey';
    }
  }

  // Obtener el estado del juego como texto
  static String getGameStatusText(GameStatus status) {
    switch (status) {
      case GameStatus.active:
        return 'En juego';
      case GameStatus.check:
        return 'Jaque';
      case GameStatus.checkmate:
        return 'Jaque mate';
      case GameStatus.stalemate:
        return 'Ahogado';
      case GameStatus.draw:
        return 'Empate';
    }
  }
}