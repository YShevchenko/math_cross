import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/player_stats.dart';
import '../../domain/repositories/progress_repository.dart';

class ProgressNotifier extends Notifier<PlayerStats> {
  late final ProgressRepository _repo;

  @override
  PlayerStats build() {
    _repo = ref.read(progressRepoInternalProvider);
    return const PlayerStats();
  }

  /// Load saved stats from persistent storage.
  Future<void> load() async {
    state = await _repo.loadPlayerStats();
  }

  /// Record a completed puzzle and persist.
  Future<void> recordPuzzleComplete({
    required int level,
    required int score,
    required int hintsUsed,
    required int timeTaken,
  }) async {
    state = state.copyWith(
      highestLevel: level > state.highestLevel ? level : state.highestLevel,
      totalPuzzlesCompleted: state.totalPuzzlesCompleted + 1,
      totalScore: state.totalScore + score,
      bestLevelScore: score > state.bestLevelScore ? score : state.bestLevelScore,
      totalHintsUsed: state.totalHintsUsed + hintsUsed,
      totalPlayTimeSeconds: state.totalPlayTimeSeconds + timeTaken,
    );
    await _repo.savePlayerStats(state);
  }

  /// Update hints available.
  Future<void> setHints(int hints) async {
    state = state.copyWith(hintsAvailable: hints);
    await _repo.savePlayerStats(state);
  }

  /// Add hints (from ad or level completion).
  Future<void> addHints(int count) async {
    state = state.copyWith(hintsAvailable: state.hintsAvailable + count);
    await _repo.savePlayerStats(state);
  }

  /// Use one hint.
  Future<void> useHint() async {
    if (state.hintsAvailable <= 0) return;
    state = state.copyWith(hintsAvailable: state.hintsAvailable - 1);
    await _repo.savePlayerStats(state);
  }

  /// Mark ads as removed (or re-enabled) and persist.
  Future<void> setAdsRemoved(bool removed) async {
    state = state.copyWith(adsRemoved: removed);
    await _repo.savePlayerStats(state);
  }

  /// Reset all stats and clear storage.
  Future<void> reset() async {
    state = const PlayerStats();
    await _repo.clear();
  }
}

/// Internal provider so ProgressNotifier can access the repo.
/// Overridden in providers.dart.
final progressRepoInternalProvider = Provider<ProgressRepository>((_) {
  throw UnimplementedError('Must be overridden in providers.dart');
});
