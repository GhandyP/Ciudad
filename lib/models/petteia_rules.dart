import 'piece.dart';
import 'position.dart';
import 'board.dart';
import 'move.dart';

class PetteiaRules {
  // Obtener todos los movimientos posibles para una piedra en una posición
  static List<Position> getPossibleMoves(Position position, Board board) {
    final piece = board.getPieceAt(position);
    if (piece == null || piece.type != PieceType.stone) return [];

    final moves = <Position>[];

    // Direcciones ortogonales: arriba, abajo, izquierda, derecha
    final directions = [
      Position(-1, 0), // arriba
      Position(1, 0),  // abajo
      Position(0, -1), // izquierda
      Position(0, 1),  // derecha
    ];

    for (final direction in directions) {
      Position current = position + direction;
      while (board.isValidPosition(current) && board.isEmpty(current)) {
        moves.add(current);
        current = current + direction;
      }
    }

    return moves;
  }

  // Verificar si un movimiento es legal
  static bool isLegalMove(Position from, Position to, Board board) {
    final piece = board.getPieceAt(from);
    if (piece == null || piece.type != PieceType.stone) return false;

    // Debe ser una casilla vacía
    if (!board.isEmpty(to)) return false;

    // Debe estar en línea recta (horizontal o vertical)
    if (from.row != to.row && from.col != to.col) return false;

    // No debe haber piezas en el camino
    final path = _getPath(from, to);
    for (final pos in path) {
      if (!board.isEmpty(pos)) return false;
    }

    return true;
  }

  // Obtener el camino entre dos posiciones (excluyendo inicio y fin)
  static List<Position> _getPath(Position from, Position to) {
    final path = <Position>[];

    if (from.row == to.row) {
      // Movimiento horizontal
      final start = from.col < to.col ? from.col + 1 : to.col + 1;
      final end = from.col < to.col ? to.col : from.col;
      for (int col = start; col < end; col++) {
        path.add(Position(from.row, col));
      }
    } else if (from.col == to.col) {
      // Movimiento vertical
      final start = from.row < to.row ? from.row + 1 : to.row + 1;
      final end = from.row < to.row ? to.row : from.row;
      for (int row = start; row < end; row++) {
        path.add(Position(row, from.col));
      }
    }

    return path;
  }

  // Ejecutar capturas por bloqueo después de un movimiento
  static List<Position> executeCaptures(Position movedTo, PieceColor playerColor, Board board) {
    final capturedPositions = <Position>[];

    // Verificar todas las líneas que pasan por la posición movida
    final directions = [
      Position(-1, 0), Position(1, 0), Position(0, -1), Position(0, 1),
    ];

    for (final direction in directions) {
      final capturesInLine = _findCapturesInLine(movedTo, direction, playerColor, board);
      capturedPositions.addAll(capturesInLine);
    }

    return capturedPositions;
  }

  // Encontrar capturas en una línea específica
  static List<Position> _findCapturesInLine(Position center, Position direction, PieceColor playerColor, Board board) {
    final captures = <Position>[];

    // Buscar hacia adelante y atrás desde el centro
    final forward = _findOpponentBetweenOwn(center, direction, playerColor, board);
    final backward = _findOpponentBetweenOwn(center, Position(-direction.row, -direction.col), playerColor, board);

    captures.addAll(forward);
    captures.addAll(backward);

    return captures;
  }

  // Encontrar piezas oponentes entre piezas propias en una dirección
  static List<Position> _findOpponentBetweenOwn(Position start, Position direction, PieceColor playerColor, Board board) {
    final captures = <Position>[];
    Position current = start + direction;
    bool foundOwn = false;

    while (board.isValidPosition(current)) {
      final piece = board.getPieceAt(current);

      if (piece != null) {
        if (piece.color == playerColor) {
          // Encontró pieza propia, ahora buscar oponentes antes
          if (foundOwn) {
            // Ya encontró una propia antes, ahora encontró otra, capturar lo de en medio
            Position capturePos = start + direction;
            while (capturePos != current) {
              final capturePiece = board.getPieceAt(capturePos);
              if (capturePiece != null && capturePiece.color != playerColor) {
                captures.add(capturePos);
              }
              capturePos = capturePos + direction;
            }
          }
          foundOwn = true;
        } else if (foundOwn) {
          // Encontró oponente después de propia, potencial captura
          captures.add(current);
        }
      }

      current = current + direction;
    }

    return captures;
  }

  // Verificar si un color no tiene movimientos disponibles
  static bool hasNoMoves(PieceColor color, Board board) {
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = board.squares[row][col];
        if (piece != null && piece.color == color) {
          final moves = getPossibleMoves(Position(row, col), board);
          if (moves.isNotEmpty) return false;
        }
      }
    }
    return true;
  }

  // Verificar si un color ha perdido todas sus piezas
  static bool hasNoPieces(PieceColor color, Board board) {
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = board.squares[row][col];
        if (piece != null && piece.color == color) {
          return false;
        }
      }
    }
    return true;
  }
}