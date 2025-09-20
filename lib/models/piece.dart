import 'position.dart';

enum PieceType { stone }
enum PieceColor { white, black }

class Piece {
  final PieceType type;
  final PieceColor color;
  final String symbol;
  bool hasMoved;

  Piece({
    required this.type,
    required this.color,
    this.hasMoved = false,
  }) : symbol = _getSymbol(type, color);

  static String _getSymbol(PieceType type, PieceColor color) {
    const symbols = {
      PieceType.stone: '●○',
    };

    final symbolPair = symbols[type]!;
    return color == PieceColor.white ? symbolPair[0] : symbolPair[1];
  }

  Piece copyWith({bool? hasMoved}) {
    return Piece(
      type: type,
      color: color,
      hasMoved: hasMoved ?? this.hasMoved,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Piece &&
        other.type == type &&
        other.color == color &&
        other.hasMoved == hasMoved;
  }

  @override
  int get hashCode => type.hashCode ^ color.hashCode ^ hasMoved.hashCode;

  @override
  String toString() => 'Piece($type, $color, moved: $hasMoved)';
}