import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_cross/domain/models/math_grid.dart';
import 'package:math_cross/domain/services/difficulty_service.dart';
import 'package:math_cross/domain/services/puzzle_generator.dart';

void main() {
  group('MathGrid', () {
    late MathGrid grid;

    setUp(() {
      final generator = PuzzleGenerator(Random(42));
      const config = DifficultyConfig(
        operators: ['+'],
        equationRows: 2,
        equationCols: 2,
        minOperand: 1,
        maxOperand: 9,
        blanksPerEquation: 1,
      );
      grid = generator.generate(config);
    });

    test('cellAt returns correct cell', () {
      final cell = grid.cellAt(0, 0);
      expect(cell.row, 0);
      expect(cell.col, 0);
    });

    test('withCellAt returns new grid with updated cell', () {
      final original = grid.cellAt(0, 0);
      final updated = original.copyWith(userInput: 5);
      final newGrid = grid.withCellAt(0, 0, updated);

      expect(newGrid.cellAt(0, 0).userInput, 5);
      // Original should be unchanged
      expect(grid.cellAt(0, 0).userInput, isNot(5));
    });

    test('isComplete returns false when blanks unfilled', () {
      expect(grid.isComplete, false);
    });

    test('isComplete returns true when all blanks correctly filled', () {
      var g = grid;
      for (final cell in g.blankCells) {
        g = g.withCellAt(
          cell.row, cell.col,
          cell.copyWith(userInput: cell.answer),
        );
      }
      expect(g.isComplete, true);
    });

    test('isComplete returns false when blanks wrongly filled', () {
      var g = grid;
      for (final cell in g.blankCells) {
        // Fill with wrong answer
        final wrongAnswer = (cell.answer ?? 0) + 1;
        g = g.withCellAt(
          cell.row, cell.col,
          cell.copyWith(userInput: wrongAnswer),
        );
      }
      expect(g.isComplete, false);
    });

    test('allFilled returns true when all blanks have input', () {
      var g = grid;
      for (final cell in g.blankCells) {
        g = g.withCellAt(
          cell.row, cell.col,
          cell.copyWith(userInput: 1),
        );
      }
      expect(g.allFilled, true);
    });

    test('correctCount counts only correct non-revealed cells', () {
      var g = grid;
      final blanks = g.blankCells;
      if (blanks.isNotEmpty) {
        final first = blanks.first;
        g = g.withCellAt(
          first.row, first.col,
          first.copyWith(userInput: first.answer),
        );
        expect(g.correctCount, 1);
      }
    });

    test('hintsUsed counts revealed cells', () {
      var g = grid;
      final blanks = g.blankCells;
      if (blanks.isNotEmpty) {
        final first = blanks.first;
        g = g.withCellAt(
          first.row, first.col,
          first.copyWith(isRevealed: true),
        );
        expect(g.hintsUsed, 1);
      }
    });

    test('serialization round-trip', () {
      final json = grid.toJson();
      final restored = MathGrid.fromJson(json);

      expect(restored.rows, grid.rows);
      expect(restored.cols, grid.cols);
      expect(restored.cells.length, grid.cells.length);
      expect(restored.equations.length, grid.equations.length);
    });
  });
}
