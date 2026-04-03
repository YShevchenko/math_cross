import 'package:flutter_test/flutter_test.dart';
import 'package:math_cross/domain/models/game_state.dart';

void main() {
  group('GameState', () {
    test('default state', () {
      const state = GameState();
      expect(state.level, 1);
      expect(state.grid, null);
      expect(state.score, 0);
      expect(state.isCompleted, false);
      expect(state.hintsAvailable, 3);
    });

    test('copyWith preserves unmodified fields', () {
      const state = GameState(level: 5, score: 100);
      final updated = state.copyWith(isCompleted: true);
      expect(updated.level, 5);
      expect(updated.score, 100);
      expect(updated.isCompleted, true);
    });

    test('serialization round-trip (without grid)', () {
      const state = GameState(
        level: 7,
        score: 250,
        elapsedSeconds: 45,
        isCompleted: true,
        hintsAvailable: 5,
      );

      final json = state.toJson();
      final restored = GameState.fromJson(json);

      expect(restored.level, 7);
      expect(restored.score, 250);
      expect(restored.elapsedSeconds, 45);
      expect(restored.isCompleted, true);
      expect(restored.hintsAvailable, 5);
    });
  });
}
