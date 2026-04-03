import 'package:flutter_test/flutter_test.dart';
import 'package:math_cross/domain/models/equation.dart';

void main() {
  group('Equation', () {
    test('addition equation validates correctly', () {
      const eq = Equation(
        number: 1,
        direction: EquationDirection.across,
        operandA: 3,
        operator: '+',
        operandB: 5,
        result: 8,
        startRow: 0,
        startCol: 0,
        blankPositions: [0],
      );

      expect(eq.isValid, true);
    });

    test('subtraction equation validates correctly', () {
      const eq = Equation(
        number: 1,
        direction: EquationDirection.across,
        operandA: 9,
        operator: '-',
        operandB: 4,
        result: 5,
        startRow: 0,
        startCol: 0,
        blankPositions: [2],
      );

      expect(eq.isValid, true);
    });

    test('multiplication equation validates correctly', () {
      const eq = Equation(
        number: 1,
        direction: EquationDirection.across,
        operandA: 6,
        operator: 'x',
        operandB: 7,
        result: 42,
        startRow: 0,
        startCol: 0,
        blankPositions: [4],
      );

      expect(eq.isValid, true);
    });

    test('division equation validates correctly', () {
      const eq = Equation(
        number: 1,
        direction: EquationDirection.across,
        operandA: 24,
        operator: '/',
        operandB: 6,
        result: 4,
        startRow: 0,
        startCol: 0,
        blankPositions: [0],
      );

      expect(eq.isValid, true);
    });

    test('invalid addition equation fails', () {
      const eq = Equation(
        number: 1,
        direction: EquationDirection.across,
        operandA: 3,
        operator: '+',
        operandB: 5,
        result: 9, // wrong
        startRow: 0,
        startCol: 0,
        blankPositions: [0],
      );

      expect(eq.isValid, false);
    });

    test('division by zero fails validation', () {
      const eq = Equation(
        number: 1,
        direction: EquationDirection.across,
        operandA: 10,
        operator: '/',
        operandB: 0,
        result: 0,
        startRow: 0,
        startCol: 0,
        blankPositions: [0],
      );

      expect(eq.isValid, false);
    });

    test('non-integer division fails validation', () {
      const eq = Equation(
        number: 1,
        direction: EquationDirection.across,
        operandA: 7,
        operator: '/',
        operandB: 2,
        result: 3, // 7/2 = 3.5, not integer
        startRow: 0,
        startCol: 0,
        blankPositions: [0],
      );

      expect(eq.isValid, false);
    });

    test('Equation.compute works for all operators', () {
      expect(Equation.compute(3, '+', 5), 8);
      expect(Equation.compute(9, '-', 4), 5);
      expect(Equation.compute(6, 'x', 7), 42);
      expect(Equation.compute(24, '/', 6), 4);
      expect(Equation.compute(7, '/', 2), null); // non-integer
      expect(Equation.compute(10, '/', 0), null); // div by zero
    });

    test('toDisplayString shows blanks correctly', () {
      const eq = Equation(
        number: 1,
        direction: EquationDirection.across,
        operandA: 3,
        operator: '+',
        operandB: 5,
        result: 8,
        startRow: 0,
        startCol: 0,
        blankPositions: [0, 2],
      );

      expect(eq.toDisplayString(), '_ + _ = 8');
    });

    test('serialization round-trip', () {
      const eq = Equation(
        number: 3,
        direction: EquationDirection.down,
        operandA: 12,
        operator: 'x',
        operandB: 4,
        result: 48,
        startRow: 0,
        startCol: 2,
        blankPositions: [0, 4],
      );

      final json = eq.toJson();
      final restored = Equation.fromJson(json);

      expect(restored, eq);
    });
  });
}
