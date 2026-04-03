import '../models/game_state.dart';
import '../models/player_stats.dart';

/// Abstract repository for persisting game progress.
abstract class ProgressRepository {
  Future<GameState> loadGameState();
  Future<void> saveGameState(GameState state);
  Future<PlayerStats> loadPlayerStats();
  Future<void> savePlayerStats(PlayerStats stats);
  Future<void> clear();
}
