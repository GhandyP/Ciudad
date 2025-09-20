class Position {
  final int row;
  final int col;

  const Position(this.row, this.col);

  // Constructor de fábrica para crear posición desde notación algebraica (ej: 'e4')
  factory Position.fromAlgebraic(String algebraic) {
    final col = algebraic[0].toLowerCase().codeUnitAt(0) - 'a'.codeUnitAt(0);
    final row = 8 - int.parse(algebraic[1]);
    return Position(row, col);
  }

  // Convertir posición a notación algebraica
  String toAlgebraic() {
    final colChar = String.fromCharCode('a'.codeUnitAt(0) + col);
    final rowNum = (8 - row).toString();
    return '$colChar$rowNum';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Position && other.row == row && other.col == col;
  }

  @override
  int get hashCode => row.hashCode ^ col.hashCode;

  @override
  String toString() => 'Position($row, $col) = ${toAlgebraic()}';
}