import 'package:test/test.dart';
import 'package:petteia_flutter/models/piece.dart';

void main() {
  group('Piece', () {
    test('should create piece with type and color', () {
      final piece = Piece(type: PieceType.pawn, color: PieceColor.white);
      expect(piece.type, PieceType.pawn);
      expect(piece.color, PieceColor.white);
      expect(piece.hasMoved, false);
    });

    test('should have correct symbols for all piece types', () {
      final whitePawn = Piece(type: PieceType.pawn, color: PieceColor.white);
      final blackPawn = Piece(type: PieceType.pawn, color: PieceColor.black);

      expect(whitePawn.symbol, '♙');
      expect(blackPawn.symbol, '♟');

      final whiteRook = Piece(type: PieceType.rook, color: PieceColor.white);
      final blackRook = Piece(type: PieceType.rook, color: PieceColor.black);

      expect(whiteRook.symbol, '♖');
      expect(blackRook.symbol, '♜');
    });

    test('should implement copyWith correctly', () {
      final piece = Piece(type: PieceType.pawn, color: PieceColor.white);
      final movedPiece = piece.copyWith(hasMoved: true);

      expect(movedPiece.type, PieceType.pawn);
      expect(movedPiece.color, PieceColor.white);
      expect(movedPiece.hasMoved, true);
    });

    test('should implement equality correctly', () {
      final piece1 = Piece(type: PieceType.pawn, color: PieceColor.white);
      final piece2 = Piece(type: PieceType.pawn, color: PieceColor.white);
      final piece3 = Piece(type: PieceType.pawn, color: PieceColor.black);
      final piece4 = Piece(type: PieceType.pawn, color: PieceColor.white, hasMoved: true);

      expect(piece1 == piece2, true);
      expect(piece1 == piece3, false);
      expect(piece1 == piece4, false);
    });

    test('should have correct hashCode', () {
      final piece1 = Piece(type: PieceType.pawn, color: PieceColor.white);
      final piece2 = Piece(type: PieceType.pawn, color: PieceColor.white);

      expect(piece1.hashCode == piece2.hashCode, true);
    });

    test('should have correct string representation', () {
      final piece = Piece(type: PieceType.pawn, color: PieceColor.white);
      expect(piece.toString(), 'Piece(pawn, white, moved: false)');
    });
  });
}