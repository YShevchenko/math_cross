import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/game_state.dart';
import '../../domain/models/player_stats.dart';
import '../../domain/repositories/progress_repository.dart';

class PrefsProgressRepository implements ProgressRepository {
  static const _gameStateKey = 'math_cross_game_state';
  static const _playerStatsKey = 'math_cross_player_stats';
  final SharedPreferences _prefs;

  PrefsProgressRepository(this._prefs);

  @override
  Future<GameState> loadGameState() async {
    final jsonStr = _prefs.getString(_gameStateKey);
    if (jsonStr == null) return const GameState();
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    return GameState.fromJson(json);
  }

  @override
  Future<void> saveGameState(GameState state) async {
    await _prefs.setString(_gameStateKey, jsonEncode(state.toJson()));
  }

  @override
  Future<PlayerStats> loadPlayerStats() async {
    final jsonStr = _prefs.getString(_playerStatsKey);
    if (jsonStr == null) return const PlayerStats();
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    return PlayerStats.fromJson(json);
  }

  @override
  Future<void> savePlayerStats(PlayerStats stats) async {
    await _prefs.setString(_playerStatsKey, jsonEncode(stats.toJson()));
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(_gameStateKey);
    await _prefs.remove(_playerStatsKey);
  }
}
