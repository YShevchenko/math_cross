import 'package:flutter_test/flutter_test.dart';
import 'package:math_cross/domain/models/player_stats.dart';

void main() {
  group('PlayerStats', () {
    test('default values', () {
      const stats = PlayerStats();
      expect(stats.highestLevel, 0);
      expect(stats.totalPuzzlesCompleted, 0);
      expect(stats.totalScore, 0);
      expect(stats.adsRemoved, false);
      expect(stats.hintsAvailable, 3);
    });

    test('copyWith works correctly', () {
      const stats = PlayerStats(highestLevel: 5, totalScore: 100);
      final updated = stats.copyWith(totalPuzzlesCompleted: 3);
      expect(updated.highestLevel, 5);
      expect(updated.totalScore, 100);
      expect(updated.totalPuzzlesCompleted, 3);
    });

    test('serialization round-trip', () {
      const stats = PlayerStats(
        highestLevel: 15,
        totalPuzzlesCompleted: 12,
        totalScore: 5000,
        bestLevelScore: 450,
        totalHintsUsed: 8,
        totalPlayTimeSeconds: 3600,
        adsRemoved: true,
        hintsAvailable: 10,
      );

      final json = stats.toJson();
      final restored = PlayerStats.fromJson(json);

      expect(restored, stats);
    });

    test('fromJson handles missing fields with defaults', () {
      final stats = PlayerStats.fromJson({});
      expect(stats.highestLevel, 0);
      expect(stats.totalPuzzlesCompleted, 0);
      expect(stats.adsRemoved, false);
    });
  });
}
