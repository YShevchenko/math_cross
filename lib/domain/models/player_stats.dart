import 'package:equatable/equatable.dart';

/// Persistent player statistics.
class PlayerStats extends Equatable {
  /// Highest level completed.
  final int highestLevel;

  /// Total puzzles completed.
  final int totalPuzzlesCompleted;

  /// Total score accumulated.
  final int totalScore;

  /// Best score on a single level.
  final int bestLevelScore;

  /// Total hints used.
  final int totalHintsUsed;

  /// Total play time in seconds.
  final int totalPlayTimeSeconds;

  /// Whether ads have been removed via IAP.
  final bool adsRemoved;

  /// Total hints available.
  final int hintsAvailable;

  const PlayerStats({
    this.highestLevel = 0,
    this.totalPuzzlesCompleted = 0,
    this.totalScore = 0,
    this.bestLevelScore = 0,
    this.totalHintsUsed = 0,
    this.totalPlayTimeSeconds = 0,
    this.adsRemoved = false,
    this.hintsAvailable = 3,
  });

  PlayerStats copyWith({
    int? highestLevel,
    int? totalPuzzlesCompleted,
    int? totalScore,
    int? bestLevelScore,
    int? totalHintsUsed,
    int? totalPlayTimeSeconds,
    bool? adsRemoved,
    int? hintsAvailable,
  }) {
    return PlayerStats(
      highestLevel: highestLevel ?? this.highestLevel,
      totalPuzzlesCompleted:
          totalPuzzlesCompleted ?? this.totalPuzzlesCompleted,
      totalScore: totalScore ?? this.totalScore,
      bestLevelScore: bestLevelScore ?? this.bestLevelScore,
      totalHintsUsed: totalHintsUsed ?? this.totalHintsUsed,
      totalPlayTimeSeconds:
          totalPlayTimeSeconds ?? this.totalPlayTimeSeconds,
      adsRemoved: adsRemoved ?? this.adsRemoved,
      hintsAvailable: hintsAvailable ?? this.hintsAvailable,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'highestLevel': highestLevel,
      'totalPuzzlesCompleted': totalPuzzlesCompleted,
      'totalScore': totalScore,
      'bestLevelScore': bestLevelScore,
      'totalHintsUsed': totalHintsUsed,
      'totalPlayTimeSeconds': totalPlayTimeSeconds,
      'adsRemoved': adsRemoved,
      'hintsAvailable': hintsAvailable,
    };
  }

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      highestLevel: json['highestLevel'] as int? ?? 0,
      totalPuzzlesCompleted: json['totalPuzzlesCompleted'] as int? ?? 0,
      totalScore: json['totalScore'] as int? ?? 0,
      bestLevelScore: json['bestLevelScore'] as int? ?? 0,
      totalHintsUsed: json['totalHintsUsed'] as int? ?? 0,
      totalPlayTimeSeconds: json['totalPlayTimeSeconds'] as int? ?? 0,
      adsRemoved: json['adsRemoved'] as bool? ?? false,
      hintsAvailable: json['hintsAvailable'] as int? ?? 3,
    );
  }

  @override
  List<Object?> get props => [
        highestLevel, totalPuzzlesCompleted, totalScore, bestLevelScore,
        totalHintsUsed, totalPlayTimeSeconds, adsRemoved, hintsAvailable,
      ];
}
