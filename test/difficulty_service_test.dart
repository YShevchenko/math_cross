import 'package:flutter_test/flutter_test.dart';
import 'package:math_cross/domain/services/difficulty_service.dart';

void main() {
  group('DifficultyService', () {
    const service = DifficultyService();

    test('level 1 is addition only', () {
      final config = service.configForLevel(1);
      expect(config.operators, ['+']);
      expect(config.equationRows, 2);
      expect(config.blanksPerEquation, 1);
    });

    test('level 10 is still addition only', () {
      final config = service.configForLevel(10);
      expect(config.operators, ['+']);
    });

    test('level 11 adds subtraction', () {
      final config = service.configForLevel(11);
      expect(config.operators, ['+', '-']);
    });

    test('level 20 is add + sub', () {
      final config = service.configForLevel(20);
      expect(config.operators, ['+', '-']);
    });

    test('level 21 adds multiplication', () {
      final config = service.configForLevel(21);
      expect(config.operators, ['+', '-', 'x']);
      expect(config.equationRows, 3);
      expect(config.blanksPerEquation, 2);
    });

    test('level 36 includes division', () {
      final config = service.configForLevel(36);
      expect(config.operators, ['+', '-', 'x', '/']);
      expect(config.equationRows, 3);
    });

    test('level 100 includes all operations', () {
      final config = service.configForLevel(100);
      expect(config.operators.length, 4);
    });

    test('higher levels have larger operand range', () {
      final easy = service.configForLevel(1);
      final hard = service.configForLevel(36);
      expect(hard.maxOperand, greaterThanOrEqualTo(easy.maxOperand));
    });
  });
}
