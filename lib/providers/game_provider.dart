import 'package:flutter/foundation.dart';
import '../models/game_state.dart';
import '../models/move.dart';
import '../models/position.dart';
import '../models/piece.dart';
import '../models/board.dart';
import '../models/petteia_rules.dart';

class GameProvider extends ChangeNotifier {
  GameState _gameState = GameState.initial();

  GameState get gameState => _gameState;

  // Obtener el estado actual del juego
  GameState get currentState => _gameState;

  // Verificar si es el turno del jugador actual
  bool get isCurrentPlayerTurn => _gameState.status == GameStatus.active;

  // Seleccionar una casilla
  void selectSquare(Position position) {
    final piece = _gameState.board[position.row][position.col];

    // Si no hay pieza seleccionada y la casilla tiene una pieza del jugador actual
    if (_gameState.selectedSquare == null) {
      if (piece != null && piece.color == _gameState.currentPlayer) {
        _gameState = _gameState.copyWith(
          selectedSquare: position,
          possibleMoves: _getPossibleMoves(position),
        );
      }
    } else {
      // Si ya hay una casilla seleccionada
      final selectedPos = _gameState.selectedSquare!;

      // Si se selecciona la misma casilla, deseleccionar
      if (selectedPos == position) {
        _gameState = _gameState.copyWith(
          selectedSquare: null,
          possibleMoves: [],
        );
      } else {
        // Intentar hacer el movimiento
        _tryMakeMove(selectedPos, position);
      }
    }

    notifyListeners();
  }

  // Intentar hacer un movimiento
  void _tryMakeMove(Position from, Position to) {
    final piece = _gameState.board[from.row][from.col];
    if (piece == null) return;

    // Verificar si el movimiento es válido
    if (_isValidMove(from, to)) {
      _makeMove(from, to);
    } else {
      // Si no es válido, solo cambiar la selección
      _gameState = _gameState.copyWith(
        selectedSquare: to,
        possibleMoves: _getPossibleMoves(to),
      );
    }
  }

  // Hacer un movimiento
  void _makeMove(Position from, Position to) {
    final piece = _gameState.board[from.row][from.col];
    if (piece == null) return;

    final newBoard = List.generate(8, (row) => List<Piece?>.from(_gameState.board[row]));

    // Mover la pieza
    final movedPiece = piece.copyWith(hasMoved: true);
    newBoard[to.row][to.col] = movedPiece;
    newBoard[from.row][from.col] = null;

    // Ejecutar capturas por bloqueo
    final boardAfterMove = Board(newBoard);
    final capturedPositions = PetteiaRules.executeCaptures(to, piece.color, boardAfterMove);

    // Remover piezas capturadas
    for (final pos in capturedPositions) {
      newBoard[pos.row][pos.col] = null;
    }

    // Crear el movimiento (simplificado para Petteia)
    final move = Move(
      from: from,
      to: to,
      piece: piece,
      capturedPiece: null, // En Petteia las capturas son por bloqueo, no directo
      moveType: MoveType.normal,
    );

    // Cambiar turno
    final nextPlayer = _gameState.currentPlayer == PieceColor.white
        ? PieceColor.black
        : PieceColor.white;

    // Verificar estado del juego para el siguiente jugador
    final finalBoard = Board(newBoard);
    final hasNoMoves = finalBoard.hasNoMoves(nextPlayer);
    final hasNoPieces = finalBoard.hasNoPieces(nextPlayer);

    GameStatus status = GameStatus.active;
    if (hasNoPieces) {
      status = GameStatus.checkmate; // Usar checkmate para indicar victoria
    } else if (hasNoMoves) {
      status = GameStatus.stalemate; // Usar stalemate para indicar sin movimientos
    }

    // Actualizar el estado del juego
    _gameState = _gameState.copyWith(
      board: newBoard,
      currentPlayer: nextPlayer,
      status: status,
      moveHistory: [..._gameState.moveHistory, move],
      selectedSquare: null,
      possibleMoves: [],
      isInCheck: false, // No hay jaque en Petteia
    );

    notifyListeners();
  }

  // Verificar si un movimiento es válido
  bool _isValidMove(Position from, Position to) {
    final piece = _gameState.board[from.row][from.col];
    if (piece == null) return false;

    // Verificar que no sea la misma posición
    if (from == to) return false;

    // Verificar que la casilla destino esté vacía
    final targetPiece = _gameState.board[to.row][to.col];
    if (targetPiece != null) return false;

    // Usar PetteiaRules para validación completa
    final board = Board(_gameState.board);
    return PetteiaRules.isLegalMove(from, to, board);
  }

  // Obtener movimientos posibles para una pieza
  List<Position> _getPossibleMoves(Position position) {
    final piece = _gameState.board[position.row][position.col];
    if (piece == null) return [];

    // Usar PetteiaRules para obtener movimientos posibles
    final board = Board(_gameState.board);
    return PetteiaRules.getPossibleMoves(position, board);
  }

  // Reiniciar el juego
  void resetGame() {
    _gameState = GameState.initial();
    notifyListeners();
  }

  // Cargar un estado de juego guardado
  void loadGameState(GameState state) {
    _gameState = state;
    notifyListeners();
  }

  // Obtener el historial de movimientos
  List<Move> get moveHistory => _gameState.moveHistory;

  // Verificar si el juego ha terminado
  bool get isGameOver => _gameState.status != GameStatus.active;

  // Obtener el ganador (si hay)
  PieceColor? get winner {
    if (_gameState.status == GameStatus.checkmate) {
      return _gameState.currentPlayer == PieceColor.white
          ? PieceColor.black
          : PieceColor.white;
    }
    return null;
  }
}