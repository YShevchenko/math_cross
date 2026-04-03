import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_cross/domain/models/cell.dart';
import 'package:math_cross/domain/models/equation.dart';
import 'package:math_cross/domain/services/difficulty_service.dart';
import 'package:math_cross/domain/services/puzzle_generator.dart';

void main() {
  group('PuzzleGenerator', () {
    late PuzzleGenerator generator;

    setUp(() {
      generator = PuzzleGenerator(Random(42));
    });

    test('generates valid easy puzzle (addition only)', () {
      const config = DifficultyConfig(
        operators: ['+'],
        equationRows: 2,
        equationCols: 2,
        minOperand: 1,
        maxOperand: 9,
        blanksPerEquation: 1,
      );

      final grid = generator.generate(config);

      // Grid should have 5 rows (2*2+1) and 5 cols
      expect(grid.rows, 5);
      expect(grid.cols, 5);
      expect(grid.cells.length, 25);

      // Should have equations
      expect(grid.equations.isNotEmpty, true);

      // All equations should be valid
      for (final eq in grid.equations) {
        expect(eq.isValid, true, reason: 'Equation ${eq.label} is invalid: '
            '${eq.operandA} ${eq.operator} ${eq.operandB} = ${eq.result}');
      }
    });

    test('generates valid medium puzzle (add + sub)', () {
      const config = DifficultyConfig(
        operators: ['+', '-'],
        equationRows: 2,
        equationCols: 2,
        minOperand: 1,
        maxOperand: 15,
        blanksPerEquation: 1,
      );

      final grid = generator.generate(config);

      expect(grid.rows, 5);
      expect(grid.cols, 5);

      for (final eq in grid.equations) {
        expect(eq.isValid, true, reason: 'Equation ${eq.label} is invalid');
      }
    });

    test('generates valid hard puzzle (all operations)', () {
      const config = DifficultyConfig(
        operators: ['+', '-', 'x', '/'],
        equationRows: 3,
        equationCols: 3,
        minOperand: 1,
        maxOperand: 15,
        blanksPerEquation: 2,
      );

      final grid = generator.generate(config);

      // 3 equation rows -> 7 rows in grid
      expect(grid.rows, 7);
      expect(grid.cols, 5);

      for (final eq in grid.equations) {
        expect(eq.isValid, true, reason: 'Equation ${eq.label} is invalid');
      }
    });

    test('grid has blank cells for player input', () {
      const config = DifficultyConfig(
        operators: ['+'],
        equationRows: 2,
        equationCols: 2,
        minOperand: 1,
        maxOperand: 9,
        blanksPerEquation: 1,
      );

      final grid = generator.generate(config);

      final blanks = grid.blankCells;
      expect(blanks.isNotEmpty, true);

      // Each blank should have an answer
      for (final cell in blanks) {
        expect(cell.answer, isNotNull,
            reason: 'Blank cell at (${cell.row}, ${cell.col}) has no answer');
      }
    });

    test('grid has operator cells', () {
      const config = DifficultyConfig(
        operators: ['+'],
        equationRows: 2,
        equationCols: 2,
        minOperand: 1,
        maxOperand: 9,
        blanksPerEquation: 1,
      );

      final grid = generator.generate(config);

      final operators = grid.cells
          .where((c) => c.type == CellType.operator)
          .toList();
      expect(operators.isNotEmpty, true);
    });

    test('grid has equals cells', () {
      const config = DifficultyConfig(
        operators: ['+'],
        equationRows: 2,
        equationCols: 2,
        minOperand: 1,
        maxOperand: 9,
        blanksPerEquation: 1,
      );

      final grid = generator.generate(config);

      final equals = grid.cells
          .where((c) => c.type == CellType.equals)
          .toList();
      expect(equals.isNotEmpty, true);
    });

    test('horizontal equations span correct columns', () {
      const config = DifficultyConfig(
        operators: ['+'],
        equationRows: 2,
        equationCols: 2,
        minOperand: 1,
        maxOperand: 9,
        blanksPerEquation: 1,
      );

      final grid = generator.generate(config);

      final acrossEqs = grid.equations
          .where((e) => e.direction == EquationDirection.across)
          .toList();

      for (final eq in acrossEqs) {
        // Each across equation starts at col 0
        expect(eq.startCol, 0);
      }
    });

    test('vertical equations span correct rows', () {
      const config = DifficultyConfig(
        operators: ['+'],
        equationRows: 2,
        equationCols: 2,
        minOperand: 1,
        maxOperand: 9,
        blanksPerEquation: 1,
      );

      final grid = generator.generate(config);

      final downEqs = grid.equations
          .where((e) => e.direction == EquationDirection.down)
          .toList();

      for (final eq in downEqs) {
        expect(eq.startRow, 0);
      }
    });

    test('generates multiple different puzzles', () {
      const config = DifficultyConfig(
        operators: ['+'],
        equationRows: 2,
        equationCols: 2,
        minOperand: 1,
        maxOperand: 9,
        blanksPerEquation: 1,
      );

      final gen1 = PuzzleGenerator(Random(1));
      final gen2 = PuzzleGenerator(Random(99));

      final grid1 = gen1.generate(config);
      final grid2 = gen2.generate(config);

      // Grids should (very likely) be different
      final eq1 = grid1.equations.first;
      final eq2 = grid2.equations.first;

      // At least one equation should differ (extremely unlikely both match)
      final allSame = eq1.operandA == eq2.operandA &&
          eq1.operandB == eq2.operandB &&
          eq1.result == eq2.result;
      // This is probabilistic but with different seeds, should almost always differ
      expect(allSame, false);
    });
  });
}
