import 'piece.dart';
import 'position.dart';
import 'move.dart';
import 'petteia_rules.dart';

class Board {
  final List<List<Piece?>> squares;
  final Move? lastMove;

  const Board(this.squares, {this.lastMove});

  // Constructor de fábrica para crear tablero inicial
  factory Board.initial() {
    return Board(GameState.initial().board, lastMove: null);
  }

  // Obtener pieza en una posición específica
  Piece? getPieceAt(Position position) {
    if (_isValidPosition(position)) {
      return squares[position.row][position.col];
    }
    return null;
  }

  // Colocar pieza en una posición
  Board placePiece(Position position, Piece? piece) {
    if (!_isValidPosition(position)) return this;

    final newSquares = squares.map((row) => [...row]).toList();
    newSquares[position.row][position.col] = piece;

    return Board(newSquares, lastMove: lastMove);
  }

  // Mover pieza de una posición a otra
  Board movePiece(Position from, Position to) {
    final piece = getPieceAt(from);
    if (piece == null) return this;

    return placePiece(to, piece).placePiece(from, null);
  }

  // Verificar si una posición está dentro del tablero
  bool _isValidPosition(Position position) {
    return position.row >= 0 &&
           position.row < 8 &&
           position.col >= 0 &&
           position.col < 8;
  }

  // Verificar si una posición está ocupada por una pieza del color opuesto
  bool isOpponentPiece(Position position, PieceColor color) {
    final piece = getPieceAt(position);
    return piece != null && piece.color != color;
  }

  // Verificar si una posición está ocupada por una pieza del mismo color
  bool isOwnPiece(Position position, PieceColor color) {
    final piece = getPieceAt(position);
    return piece != null && piece.color == color;
  }

  // Verificar si una posición está vacía
  bool isEmpty(Position position) {
    return getPieceAt(position) == null;
  }

  // Obtener todas las posiciones ocupadas por un color específico
  List<Position> getPositionsForColor(PieceColor color) {
    final positions = <Position>[];
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piece = squares[row][col];
        if (piece != null && piece.color == color) {
          positions.add(Position(row, col));
        }
      }
    }
    return positions;
  }

  // Crear una copia del tablero
  Board copy() {
    return Board(squares.map((row) => [...row]).toList(), lastMove: lastMove);
  }

  // Crear una copia con un último movimiento
  Board withLastMove(Move move) {
    return Board(squares, lastMove: move);
  }

  // Obtener movimientos posibles para una pieza en una posición
  List<Position> getPossibleMoves(Position position) {
    return PetteiaRules.getPossibleMoves(position, this);
  }

  // Verificar si un movimiento es válido según las reglas de Petteia
  bool isValidMove(Position from, Position to) {
    return PetteiaRules.isLegalMove(from, to, this);
  }

  // Verificar si un color no tiene movimientos disponibles
  bool hasNoMoves(PieceColor color) {
    return PetteiaRules.hasNoMoves(color, this);
  }

  // Verificar si un color ha perdido todas sus piezas
  bool hasNoPieces(PieceColor color) {
    return PetteiaRules.hasNoPieces(color, this);
  }

  // Verificar si una posición está siendo atacada (no aplica en Petteia, pero mantener para compatibilidad)
  bool isSquareAttacked(Position position, PieceColor byColor) {
    return false; // En Petteia no hay ataques directos
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    for (int row = 0; row < 8; row++) {
      buffer.write('${8 - row} ');
      for (int col = 0; col < 8; col++) {
        final piece = squares[row][col];
        buffer.write(piece?.symbol ?? '.');
        buffer.write(' ');
      }
      buffer.writeln();
    }
    buffer.write('  a b c d e f g h');
    return buffer.toString();
  }
}

extension BoardExtensions on Board {
  bool isValidPosition(Position position) {
    return position.row >= 0 && position.row < 8 &&
           position.col >= 0 && position.col < 8;
  }
}