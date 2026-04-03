import 'package:flutter_test/flutter_test.dart';
import 'package:math_cross/domain/models/cell.dart';

void main() {
  group('Cell', () {
    test('blank cell without input is not filled', () {
      const cell = Cell(
        row: 0, col: 0, type: CellType.blank, answer: 5,
      );

      expect(cell.isInputCell, true);
      expect(cell.isFilled, false);
      expect(cell.isCorrect, false);
      expect(cell.isWrong, false);
      expect(cell.displayText, '');
    });

    test('blank cell with correct input', () {
      const cell = Cell(
        row: 0, col: 0, type: CellType.blank, answer: 5, userInput: 5,
      );

      expect(cell.isCorrect, true);
      expect(cell.isWrong, false);
      expect(cell.isFilled, true);
      expect(cell.displayText, '5');
    });

    test('blank cell with wrong input', () {
      const cell = Cell(
        row: 0, col: 0, type: CellType.blank, answer: 5, userInput: 3,
      );

      expect(cell.isCorrect, false);
      expect(cell.isWrong, true);
      expect(cell.isFilled, true);
      expect(cell.displayText, '3');
    });

    test('revealed cell shows answer', () {
      const cell = Cell(
        row: 0, col: 0, type: CellType.blank, answer: 7, isRevealed: true,
      );

      expect(cell.isInputCell, false);
      expect(cell.isFilled, true);
      expect(cell.displayText, '7');
    });

    test('given cell is not input', () {
      const cell = Cell(
        row: 0, col: 0, type: CellType.given, answer: 3,
      );

      expect(cell.isInputCell, false);
      expect(cell.displayText, '3');
    });

    test('operator cell shows symbol', () {
      const cell = Cell(
        row: 0, col: 1, type: CellType.operator, operatorSymbol: '+',
      );

      expect(cell.isInputCell, false);
      expect(cell.displayText, '+');
    });

    test('equals cell shows =', () {
      const cell = Cell(
        row: 0, col: 3, type: CellType.equals,
      );

      expect(cell.displayText, '=');
    });

    test('blocked cell shows empty', () {
      const cell = Cell(
        row: 1, col: 1, type: CellType.blocked,
      );

      expect(cell.displayText, '');
    });

    test('result cell shows value', () {
      const cell = Cell(
        row: 0, col: 4, type: CellType.result, answer: 15,
      );

      expect(cell.displayText, '15');
    });

    test('copyWith preserves other fields', () {
      const cell = Cell(
        row: 2, col: 3, type: CellType.blank, answer: 9,
      );

      final updated = cell.copyWith(userInput: 4);

      expect(updated.row, 2);
      expect(updated.col, 3);
      expect(updated.answer, 9);
      expect(updated.userInput, 4);
    });

    test('clearInput removes user input', () {
      const cell = Cell(
        row: 0, col: 0, type: CellType.blank, answer: 5, userInput: 3,
      );

      final cleared = cell.clearInput();
      expect(cleared.userInput, null);
      expect(cleared.answer, 5);
    });

    test('serialization round-trip', () {
      const cell = Cell(
        row: 2, col: 4, type: CellType.blank, answer: 7, userInput: 7,
        isRevealed: false,
      );

      final json = cell.toJson();
      final restored = Cell.fromJson(json);

      expect(restored, cell);
    });
  });
}
