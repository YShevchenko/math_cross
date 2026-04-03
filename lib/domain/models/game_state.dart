import 'package:equatable/equatable.dart';
import 'math_grid.dart';

/// Immutable game state for a single puzzle session.
class GameState extends Equatable {
  /// Current level number.
  final int level;

  /// The active puzzle grid (null if not loaded).
  final MathGrid? grid;

  /// Current score for this level.
  final int score;

  /// Elapsed time in seconds.
  final int elapsedSeconds;

  /// Whether the current puzzle is completed.
  final bool isCompleted;

  /// Whether the completion modal has been shown.
  final bool showedCompletion;

  /// Whether ads have been removed.
  final bool adsRemoved;

  /// Number of hints available.
  final int hintsAvailable;

  /// Timestamp of last save (ms since epoch).
  final int lastSaveTimeMs;

  const GameState({
    this.level = 1,
    this.grid,
    this.score = 0,
    this.elapsedSeconds = 0,
    this.isCompleted = false,
    this.showedCompletion = false,
    this.adsRemoved = false,
    this.hintsAvailable = 3,
    this.lastSaveTimeMs = 0,
  });

  GameState copyWith({
    int? level,
    MathGrid? grid,
    int? score,
    int? elapsedSeconds,
    bool? isCompleted,
    bool? showedCompletion,
    bool? adsRemoved,
    int? hintsAvailable,
    int? lastSaveTimeMs,
  }) {
    return GameState(
      level: level ?? this.level,
      grid: grid ?? this.grid,
      score: score ?? this.score,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
      showedCompletion: showedCompletion ?? this.showedCompletion,
      adsRemoved: adsRemoved ?? this.adsRemoved,
      hintsAvailable: hintsAvailable ?? this.hintsAvailable,
      lastSaveTimeMs: lastSaveTimeMs ?? this.lastSaveTimeMs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'grid': grid?.toJson(),
      'score': score,
      'elapsedSeconds': elapsedSeconds,
      'isCompleted': isCompleted,
      'showedCompletion': showedCompletion,
      'adsRemoved': adsRemoved,
      'hintsAvailable': hintsAvailable,
      'lastSaveTimeMs': lastSaveTimeMs,
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      level: json['level'] as int? ?? 1,
      grid: json['grid'] != null
          ? MathGrid.fromJson(json['grid'] as Map<String, dynamic>)
          : null,
      score: json['score'] as int? ?? 0,
      elapsedSeconds: json['elapsedSeconds'] as int? ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      showedCompletion: json['showedCompletion'] as bool? ?? false,
      adsRemoved: json['adsRemoved'] as bool? ?? false,
      hintsAvailable: json['hintsAvailable'] as int? ?? 3,
      lastSaveTimeMs: json['lastSaveTimeMs'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        level, grid, score, elapsedSeconds, isCompleted,
        showedCompletion, adsRemoved, hintsAvailable, lastSaveTimeMs,
      ];
}
