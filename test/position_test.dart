import 'package:test/test.dart';
import 'package:petteia_flutter/models/position.dart';

void main() {
  group('Position', () {
    test('should create position with row and col', () {
      final position = Position(0, 0);
      expect(position.row, 0);
      expect(position.col, 0);
    });

    test('should create position from algebraic notation', () {
      final position = Position.fromAlgebraic('e4');
      expect(position.row, 4);
      expect(position.col, 4);
    });

    test('should convert position to algebraic notation', () {
      final position = Position(7, 0);
      expect(position.toAlgebraic(), 'a1');
    });

    test('should handle different algebraic positions', () {
      final positions = [
        {'algebraic': 'a1', 'expectedRow': 7, 'expectedCol': 0},
        {'algebraic': 'h8', 'expectedRow': 0, 'expectedCol': 7},
        {'algebraic': 'e4', 'expectedRow': 4, 'expectedCol': 4},
        {'algebraic': 'd5', 'expectedRow': 3, 'expectedCol': 3},
      ];

      for (final pos in positions) {
        final position = Position.fromAlgebraic(pos['algebraic'] as String);
        expect(position.row, pos['expectedRow']);
        expect(position.col, pos['expectedCol']);
        expect(position.toAlgebraic(), pos['algebraic']);
      }
    });

    test('should implement equality correctly', () {
      final pos1 = Position(1, 2);
      final pos2 = Position(1, 2);
      final pos3 = Position(2, 3);

      expect(pos1 == pos2, true);
      expect(pos1 == pos3, false);
      expect(pos1.hashCode == pos2.hashCode, true);
    });

    test('should have correct string representation', () {
      final position = Position(0, 0);
      expect(position.toString(), 'Position(0, 0) = a8');
    });
  });
}