import 'piece.dart';
import 'position.dart';
import 'move.dart';

enum GameStatus { active, check, checkmate, stalemate, draw }

class GameState {
  final List<List<Piece?>> board;
  final PieceColor currentPlayer;
  final GameStatus status;
  final List<Move> moveHistory;
  final Position? selectedSquare;
  final List<Position> possibleMoves;
  final bool isInCheck;
  final Position? kingInCheckPosition;

  const GameState({
    required this.board,
    required this.currentPlayer,
    this.status = GameStatus.active,
    this.moveHistory = const [],
    this.selectedSquare,
    this.possibleMoves = const [],
    this.isInCheck = false,
    this.kingInCheckPosition,
  });

  // Crear estado inicial del juego
  factory GameState.initial() {
    return GameState(
      board: _createInitialBoard(),
      currentPlayer: PieceColor.white,
      status: GameStatus.active,
      moveHistory: [],
      selectedSquare: null,
      possibleMoves: [],
      isInCheck: false,
      kingInCheckPosition: null,
    );
  }

  static List<List<Piece?>> _createInitialBoard() {
    final board = List.generate(8, (_) => List<Piece?>.filled(8, null));

    // Colocar piedras negras en fila 0, columnas alternas (0,2,4,6)
    for (int col = 0; col < 8; col += 2) {
      board[0][col] = Piece(type: PieceType.stone, color: PieceColor.black);
    }

    // Colocar piedras blancas en fila 7, columnas alternas (1,3,5,7)
    for (int col = 1; col < 8; col += 2) {
      board[7][col] = Piece(type: PieceType.stone, color: PieceColor.white);
    }

    return board;
  }

  GameState copyWith({
    List<List<Piece?>>? board,
    PieceColor? currentPlayer,
    GameStatus? status,
    List<Move>? moveHistory,
    Position? selectedSquare,
    List<Position>? possibleMoves,
    bool? isInCheck,
    Position? kingInCheckPosition,
  }) {
    return GameState(
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      status: status ?? this.status,
      moveHistory: moveHistory ?? this.moveHistory,
      selectedSquare: selectedSquare ?? this.selectedSquare,
      possibleMoves: possibleMoves ?? this.possibleMoves,
      isInCheck: isInCheck ?? this.isInCheck,
      kingInCheckPosition: kingInCheckPosition ?? this.kingInCheckPosition,
    );
  }

  @override
  String toString() {
    return 'GameState(currentPlayer: $currentPlayer, status: $status, isInCheck: $isInCheck)';
  }
}