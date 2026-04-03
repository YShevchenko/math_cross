import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../domain/models/cell.dart';
import '../../domain/models/game_state.dart';
import '../../domain/models/math_grid.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/services/difficulty_service.dart';
import '../../domain/services/puzzle_generator.dart';

class GameNotifier extends Notifier<GameState> {
  late final ProgressRepository _repo;
  final DifficultyService _difficulty = const DifficultyService();
  final PuzzleGenerator _generator = PuzzleGenerator();

  @override
  GameState build() {
    _repo = ref.read(gameRepoInternalProvider);
    return const GameState();
  }

  /// Load saved game state.
  Future<void> load() async {
    state = await _repo.loadGameState();
  }

  /// Start a new level. Generate a puzzle for the given level.
  void startLevel(int level) {
    final config = _difficulty.configForLevel(level);
    final grid = _generator.generate(config);
    state = state.copyWith(
      level: level,
      grid: grid,
      score: 0,
      elapsedSeconds: 0,
      isCompleted: false,
      showedCompletion: false,
    );
    _save();
  }

  /// Place a number in a cell.
  void placeNumber(int row, int col, int number) {
    final grid = state.grid;
    if (grid == null) return;

    final cell = grid.cellAt(row, col);
    if (!cell.isInputCell) return;

    final updated = cell.copyWith(userInput: number);
    final newGrid = grid.withCellAt(row, col, updated);

    final isComplete = newGrid.isComplete;
    int newScore = state.score;

    if (isComplete) {
      newScore = _calculateScore(newGrid, state.elapsedSeconds);
    }

    state = state.copyWith(
      grid: newGrid,
      isCompleted: isComplete,
      score: newScore,
    );
    _save();
  }

  /// Clear a cell's input.
  void clearCell(int row, int col) {
    final grid = state.grid;
    if (grid == null) return;

    final cell = grid.cellAt(row, col);
    if (cell.type != CellType.blank || cell.isRevealed) return;

    final updated = cell.clearInput();
    state = state.copyWith(grid: grid.withCellAt(row, col, updated));
    _save();
  }

  /// Reveal a hint for a random unfilled blank cell.
  bool useHint() {
    final grid = state.grid;
    if (grid == null) return false;
    if (state.hintsAvailable <= 0) return false;

    // Find unfilled blank cells
    final unfilled = grid.blankCells
        .where((c) => !c.isFilled)
        .toList();
    if (unfilled.isEmpty) return false;

    // Reveal a random one
    unfilled.shuffle();
    final cell = unfilled.first;
    final revealed = cell.copyWith(isRevealed: true);
    final newGrid = grid.withCellAt(cell.row, cell.col, revealed);

    final isComplete = newGrid.isComplete;
    int newScore = state.score;
    if (isComplete) {
      newScore = _calculateScore(newGrid, state.elapsedSeconds);
    }

    state = state.copyWith(
      grid: newGrid,
      hintsAvailable: state.hintsAvailable - 1,
      isCompleted: isComplete,
      score: newScore,
    );
    _save();
    return true;
  }

  /// Add hints (from rewarded ad or level complete).
  void addHints(int count) {
    state = state.copyWith(
      hintsAvailable: state.hintsAvailable + count,
    );
    _save();
  }

  /// Update elapsed time.
  void tick() {
    if (state.isCompleted) return;
    state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
  }

  /// Mark completion as shown.
  void markCompletionShown() {
    state = state.copyWith(showedCompletion: true);
  }

  /// Set ads removed state.
  void setAdsRemoved(bool removed) {
    state = state.copyWith(adsRemoved: removed);
    _save();
  }

  /// Calculate score for a completed puzzle.
  int _calculateScore(MathGrid grid, int seconds) {
    final baseScore = grid.totalBlanks * AppConstants.baseScorePerCell;

    // Time bonus: full bonus if under threshold, scales down after
    double timeMultiplier = 1.0;
    if (seconds < AppConstants.timeBonusThresholdSeconds) {
      timeMultiplier = AppConstants.timeBonusMultiplier;
    } else if (seconds < AppConstants.timeBonusThresholdSeconds * 2) {
      final ratio = 1.0 -
          (seconds - AppConstants.timeBonusThresholdSeconds) /
              AppConstants.timeBonusThresholdSeconds;
      timeMultiplier = 1.0 + ratio;
    }

    // Hint penalty
    final hintPenalty = grid.hintsUsed > 0
        ? _pow(AppConstants.hintPenaltyMultiplier, grid.hintsUsed)
        : 1.0;

    return (baseScore * timeMultiplier * hintPenalty).round();
  }

  double _pow(double base, int exp) {
    double result = 1.0;
    for (int i = 0; i < exp; i++) {
      result *= base;
    }
    return result;
  }

  Future<void> _save() async {
    state = state.copyWith(
      lastSaveTimeMs: DateTime.now().millisecondsSinceEpoch,
    );
    await _repo.saveGameState(state);
  }
}

/// Internal provider so GameNotifier can access the repo.
/// Overridden in providers.dart.
final gameRepoInternalProvider = Provider<ProgressRepository>((_) {
  throw UnimplementedError('Must be overridden in providers.dart');
});
