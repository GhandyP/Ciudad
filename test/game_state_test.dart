import 'package:test/test.dart';
import 'package:petteia_flutter/models/game_state.dart';
import 'package:petteia_flutter/models/piece.dart';
import 'package:petteia_flutter/models/position.dart';

void main() {
  group('GameState', () {
    test('should create initial game state', () {
      final gameState = GameState.initial();

      expect(gameState.currentPlayer, PieceColor.white);
      expect(gameState.status, GameStatus.active);
      expect(gameState.moveHistory, isEmpty);
      expect(gameState.selectedSquare, isNull);
      expect(gameState.possibleMoves, isEmpty);
      expect(gameState.isInCheck, false);
      expect(gameState.kingInCheckPosition, isNull);
    });

    test('should have correct initial board setup', () {
      final gameState = GameState.initial();

      // Verificar piedras negras en fila 0, columnas alternas (0,2,4,6)
      expect(gameState.board[0][0]?.type, PieceType.stone);
      expect(gameState.board[0][0]?.color, PieceColor.black);
      expect(gameState.board[0][2]?.type, PieceType.stone);
      expect(gameState.board[0][2]?.color, PieceColor.black);
      expect(gameState.board[0][4]?.type, PieceType.stone);
      expect(gameState.board[0][4]?.color, PieceColor.black);
      expect(gameState.board[0][6]?.type, PieceType.stone);
      expect(gameState.board[0][6]?.color, PieceColor.black);

      // Verificar piedras blancas en fila 7, columnas alternas (1,3,5,7)
      expect(gameState.board[7][1]?.type, PieceType.stone);
      expect(gameState.board[7][1]?.color, PieceColor.white);
      expect(gameState.board[7][3]?.type, PieceType.stone);
      expect(gameState.board[7][3]?.color, PieceColor.white);
      expect(gameState.board[7][5]?.type, PieceType.stone);
      expect(gameState.board[7][5]?.color, PieceColor.white);
      expect(gameState.board[7][7]?.type, PieceType.stone);
      expect(gameState.board[7][7]?.color, PieceColor.white);

      // Verificar que las demás posiciones estén vacías
      for (int row = 0; row < 8; row++) {
        for (int col = 0; col < 8; col++) {
          if (!((row == 0 && (col % 2 == 0)) || (row == 7 && (col % 2 == 1)))) {
            expect(gameState.board[row][col], isNull);
          }
        }
      }
    });

    test('should implement copyWith correctly', () {
      final gameState = GameState.initial();
      final selectedPosition = Position(0, 0);
      final possibleMoves = [Position(0, 1), Position(1, 0)];

      final modifiedState = gameState.copyWith(
        currentPlayer: PieceColor.black,
        selectedSquare: selectedPosition,
        possibleMoves: possibleMoves,
        isInCheck: true,
      );

      expect(modifiedState.currentPlayer, PieceColor.black);
      expect(modifiedState.selectedSquare, selectedPosition);
      expect(modifiedState.possibleMoves, possibleMoves);
      expect(modifiedState.isInCheck, true);
      expect(modifiedState.status, GameStatus.active); // No modificado
    });

    test('should have correct string representation', () {
      final gameState = GameState.initial();
      expect(gameState.toString(), 'GameState(currentPlayer: white, status: active, isInCheck: false)');
    });
  });
}