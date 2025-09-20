import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';
import '../models/move.dart';

class GameStorage {
  static const String _gameStateKey = 'petteia_game_state';
  static const String _savedGamesKey = 'petteia_saved_games';
  static const String _settingsKey = 'petteia_settings';

  // Guardar estado actual del juego
  Future<bool> saveGameState(GameState gameState) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final gameStateJson = _gameStateToJson(gameState);
      return await prefs.setString(_gameStateKey, gameStateJson);
    } catch (e) {
      print('Error saving game state: $e');
      return false;
    }
  }

  // Cargar estado del juego
  Future<GameState?> loadGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final gameStateJson = prefs.getString(_gameStateKey);
      if (gameStateJson != null) {
        return _gameStateFromJson(gameStateJson);
      }
      return null;
    } catch (e) {
      print('Error loading game state: $e');
      return null;
    }
  }

  // Guardar partida con nombre
  Future<bool> saveGame(String name, GameState gameState) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedGames = await getSavedGames();

      final savedGame = {
        'name': name,
        'date': DateTime.now().toIso8601String(),
        'gameState': _gameStateToJson(gameState),
      };

      savedGames.add(savedGame);
      final savedGamesJson = jsonEncode(savedGames);
      return await prefs.setString(_savedGamesKey, savedGamesJson);
    } catch (e) {
      print('Error saving game: $e');
      return false;
    }
  }

  // Cargar partida guardada
  Future<GameState?> loadSavedGame(String name) async {
    try {
      final savedGames = await getSavedGames();
      final savedGame = savedGames.firstWhere(
        (game) => game['name'] == name,
        orElse: () => {},
      );

      if (savedGame.isNotEmpty) {
        final gameStateJson = savedGame['gameState'];
        return _gameStateFromJson(gameStateJson);
      }
      return null;
    } catch (e) {
      print('Error loading saved game: $e');
      return null;
    }
  }

  // Obtener lista de partidas guardadas
  Future<List<Map<String, dynamic>>> getSavedGames() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedGamesJson = prefs.getString(_savedGamesKey);
      if (savedGamesJson != null) {
        final List<dynamic> decoded = jsonDecode(savedGamesJson);
        return decoded.map((game) => Map<String, dynamic>.from(game)).toList();
      }
      return [];
    } catch (e) {
      print('Error getting saved games: $e');
      return [];
    }
  }

  // Eliminar partida guardada
  Future<bool> deleteSavedGame(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedGames = await getSavedGames();
      savedGames.removeWhere((game) => game['name'] == name);
      final savedGamesJson = jsonEncode(savedGames);
      return await prefs.setString(_savedGamesKey, savedGamesJson);
    } catch (e) {
      print('Error deleting saved game: $e');
      return false;
    }
  }

  // Guardar configuración
  Future<bool> saveSettings(Map<String, dynamic> settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = jsonEncode(settings);
      return await prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      print('Error saving settings: $e');
      return false;
    }
  }

  // Cargar configuración
  Future<Map<String, dynamic>> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);
      if (settingsJson != null) {
        return Map<String, dynamic>.from(jsonDecode(settingsJson));
      }
      return {};
    } catch (e) {
      print('Error loading settings: $e');
      return {};
    }
  }

  // Limpiar todos los datos
  Future<bool> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_gameStateKey);
      await prefs.remove(_savedGamesKey);
      await prefs.remove(_settingsKey);
      return true;
    } catch (e) {
      print('Error clearing data: $e');
      return false;
    }
  }

  // Convertir GameState a JSON
  String _gameStateToJson(GameState gameState) {
    return jsonEncode({
      'board': _boardToJson(gameState.board),
      'currentPlayer': gameState.currentPlayer == PieceColor.white ? 'white' : 'black',
      'status': _gameStatusToString(gameState.status),
      'moveHistory': gameState.moveHistory.map((move) => _moveToJson(move)).toList(),
      'selectedSquare': gameState.selectedSquare != null
          ? {'row': gameState.selectedSquare!.row, 'col': gameState.selectedSquare!.col}
          : null,
      'possibleMoves': gameState.possibleMoves.map((pos) => {'row': pos.row, 'col': pos.col}).toList(),
      'isInCheck': gameState.isInCheck,
      'kingInCheckPosition': gameState.kingInCheckPosition != null
          ? {'row': gameState.kingInCheckPosition!.row, 'col': gameState.kingInCheckPosition!.col}
          : null,
    });
  }

  // Convertir JSON a GameState
  GameState _gameStateFromJson(String jsonStr) {
    final Map<String, dynamic> data = jsonDecode(jsonStr);

    return GameState(
      board: _boardFromJson(data['board']),
      currentPlayer: data['currentPlayer'] == 'white' ? PieceColor.white : PieceColor.black,
      status: _gameStatusFromString(data['status']),
      moveHistory: (data['moveHistory'] as List).map((moveJson) => _moveFromJson(moveJson)).toList(),
      selectedSquare: data['selectedSquare'] != null
          ? Position(data['selectedSquare']['row'], data['selectedSquare']['col'])
          : null,
      possibleMoves: (data['possibleMoves'] as List)
          .map((posJson) => Position(posJson['row'], posJson['col']))
          .toList(),
      isInCheck: data['isInCheck'],
      kingInCheckPosition: data['kingInCheckPosition'] != null
          ? Position(data['kingInCheckPosition']['row'], data['kingInCheckPosition']['col'])
          : null,
    );
  }

  // Convertir tablero a JSON
  List<List<dynamic>> _boardToJson(List<List<Piece?>> board) {
    return board.map((row) {
      return row.map((piece) {
        if (piece == null) return null;
        return {
          'type': _pieceTypeToString(piece.type),
          'color': piece.color == PieceColor.white ? 'white' : 'black',
          'hasMoved': piece.hasMoved,
        };
      }).toList();
    }).toList();
  }

  // Convertir JSON a tablero
  List<List<Piece?>> _boardFromJson(List<List<dynamic>> boardJson) {
    return boardJson.map((rowJson) {
      return rowJson.map<Piece?>((pieceJson) {
        if (pieceJson == null) return null;
        return Piece(
          type: _pieceTypeFromString(pieceJson['type']),
          color: pieceJson['color'] == 'white' ? PieceColor.white : PieceColor.black,
          hasMoved: pieceJson['hasMoved'],
        );
      }).toList();
    }).toList();
  }

  // Convertir movimiento a JSON
  Map<String, dynamic> _moveToJson(Move move) {
    return {
      'from': {'row': move.from.row, 'col': move.from.col},
      'to': {'row': move.to.row, 'col': move.to.col},
      'piece': {
        'type': _pieceTypeToString(move.piece.type),
        'color': move.piece.color == PieceColor.white ? 'white' : 'black',
        'hasMoved': move.piece.hasMoved,
      },
      'capturedPiece': move.capturedPiece != null ? {
        'type': _pieceTypeToString(move.capturedPiece!.type),
        'color': move.capturedPiece!.color == PieceColor.white ? 'white' : 'black',
        'hasMoved': move.capturedPiece!.hasMoved,
      } : null,
      'moveType': _moveTypeToString(move.moveType),
      'promotionPiece': move.promotionPiece != null ? _pieceTypeToString(move.promotionPiece!) : null,
    };
  }

  // Convertir JSON a movimiento
  Move _moveFromJson(Map<String, dynamic> moveJson) {
    return Move(
      from: Position(moveJson['from']['row'], moveJson['from']['col']),
      to: Position(moveJson['to']['row'], moveJson['to']['col']),
      piece: Piece(
        type: _pieceTypeFromString(moveJson['piece']['type']),
        color: moveJson['piece']['color'] == 'white' ? PieceColor.white : PieceColor.black,
        hasMoved: moveJson['piece']['hasMoved'],
      ),
      capturedPiece: moveJson['capturedPiece'] != null ? Piece(
        type: _pieceTypeFromString(moveJson['capturedPiece']['type']),
        color: moveJson['capturedPiece']['color'] == 'white' ? PieceColor.white : PieceColor.black,
        hasMoved: moveJson['capturedPiece']['hasMoved'],
      ) : null,
      moveType: _moveTypeFromString(moveJson['moveType']),
      promotionPiece: moveJson['promotionPiece'] != null ? _pieceTypeFromString(moveJson['promotionPiece']) : null,
    );
  }

  // Utilidades para conversiones de enums
  String _pieceTypeToString(PieceType type) {
    return type.toString().split('.').last;
  }

  PieceType _pieceTypeFromString(String type) {
    return PieceType.values.firstWhere((e) => e.toString().split('.').last == type);
  }

  String _gameStatusToString(GameStatus status) {
    return status.toString().split('.').last;
  }

  GameStatus _gameStatusFromString(String status) {
    return GameStatus.values.firstWhere((e) => e.toString().split('.').last == status);
  }

  String _moveTypeToString(MoveType type) {
    return type.toString().split('.').last;
  }

  MoveType _moveTypeFromString(String type) {
    return MoveType.values.firstWhere((e) => e.toString().split('.').last == type);
  }
}