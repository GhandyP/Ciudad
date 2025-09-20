import 'position.dart';
import 'piece.dart';

enum MoveType { normal, capture, castling, enPassant, promotion }

class Move {
  final Position from;
  final Position to;
  final Piece piece;
  final Piece? capturedPiece;
  final MoveType moveType;
  final PieceType? promotionPiece;

  const Move({
    required this.from,
    required this.to,
    required this.piece,
    this.capturedPiece,
    this.moveType = MoveType.normal,
    this.promotionPiece,
  });

  // Constructor para movimientos de promoción
  factory Move.promotion({
    required Position from,
    required Position to,
    required Piece piece,
    required PieceType promotionPiece,
  }) {
    return Move(
      from: from,
      to: to,
      piece: piece,
      moveType: MoveType.promotion,
      promotionPiece: promotionPiece,
    );
  }

  // Constructor para capturas
  factory Move.capture({
    required Position from,
    required Position to,
    required Piece piece,
    required Piece capturedPiece,
  }) {
    return Move(
      from: from,
      to: to,
      piece: piece,
      capturedPiece: capturedPiece,
      moveType: MoveType.capture,
    );
  }

  // Constructor para en passant
  factory Move.enPassant({
    required Position from,
    required Position to,
    required Piece piece,
    required Piece capturedPiece,
  }) {
    return Move(
      from: from,
      to: to,
      piece: piece,
      capturedPiece: capturedPiece,
      moveType: MoveType.enPassant,
    );
  }

  // Constructor para enroque
  factory Move.castling({
    required Position from,
    required Position to,
    required Piece piece,
    required bool isKingSide,
  }) {
    return Move(
      from: from,
      to: to,
      piece: piece,
      moveType: MoveType.castling,
    );
  }

  String get notation {
    // En Petteia, todas las piezas son stones, usar símbolo
    final pieceSymbol = piece.symbol;
    final captureSymbol = capturedPiece != null ? 'x' : '';
    final destination = to.toAlgebraic();

    return '$pieceSymbol$captureSymbol$destination';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Move &&
        other.from == from &&
        other.to == to &&
        other.piece == piece;
  }

  @override
  int get hashCode => from.hashCode ^ to.hashCode ^ piece.hashCode;

  @override
  String toString() => 'Move(${from.toAlgebraic()} -> ${to.toAlgebraic()}, $piece)';
}