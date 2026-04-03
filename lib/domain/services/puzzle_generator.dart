import 'dart:math';

import '../models/cell.dart';
import '../models/equation.dart';
import '../models/math_grid.dart';
import 'difficulty_service.dart';

/// Generates valid math crossword puzzles.
///
/// Grid layout for a 2x2 equation puzzle (5x5 grid):
/// ```
///   Row 0: [A1] [op1] [B1] [=] [R1]   <- horizontal equation 1
///   Row 1: [opV1] [ ] [opV2] [ ] [opV3]  <- vertical operators
///   Row 2: [A2] [op2] [B2] [=] [R2]   <- horizontal equation 2
///   Row 3: [=]  [ ]  [=]   [ ]  [=]   <- equals row
///   Row 4: [RV1] [ ] [RV2] [ ] [RV3]  <- vertical results
/// ```
/// Vertical equations run through columns 0, 2, 4.
class PuzzleGenerator {
  final Random _random;

  PuzzleGenerator([Random? random]) : _random = random ?? Random();

  /// Generate a puzzle for the given difficulty configuration.
  MathGrid generate(DifficultyConfig config) {
    // Determine grid layout
    final eqRows = config.equationRows;
    final gridRows = eqRows * 2 + 1; // eq rows + op rows + result row
    const gridCols = 5;

    // Generate horizontal equations first
    final horizontalEquations = <_RawEquation>[];
    for (int i = 0; i < eqRows; i++) {
      horizontalEquations.add(_generateEquation(config));
    }

    // Build vertical equations from the columns where numbers appear (0, 2, 4)
    // Each vertical eq uses the values from horizontal equations at that column.
    final verticalEquations = <_RawEquation>[];
    for (int colIdx = 0; colIdx < 3; colIdx++) {
      final col = colIdx * 2; // columns 0, 2, 4
      final values = <int>[];
      for (int r = 0; r < eqRows; r++) {
        if (col == 0) {
          values.add(horizontalEquations[r].a);
        } else if (col == 2) {
          values.add(horizontalEquations[r].b);
        } else {
          values.add(horizontalEquations[r].result);
        }
      }
      // Build a vertical equation from these values
      final vEq = _buildVerticalEquation(values, config);
      if (vEq != null) {
        verticalEquations.add(vEq);
      } else {
        // Retry entire generation if vertical equation fails
        return generate(config);
      }
    }

    // Now build the cell grid
    final cells = <Cell>[];
    int equationNumber = 1;
    final equations = <Equation>[];

    // Create horizontal equations
    for (int r = 0; r < eqRows; r++) {
      final eq = horizontalEquations[r];
      final gridRow = r * 2;

      // Determine blank positions for this equation
      final blanks = _chooseBlanks(config.blanksPerEquation, eq);

      equations.add(Equation(
        number: equationNumber,
        direction: EquationDirection.across,
        operandA: eq.a,
        operator: eq.op,
        operandB: eq.b,
        result: eq.result,
        startRow: gridRow,
        startCol: 0,
        blankPositions: blanks,
      ));
      equationNumber++;
    }

    // Create vertical equations
    for (int colIdx = 0; colIdx < 3; colIdx++) {
      final col = colIdx * 2;
      final vEq = verticalEquations[colIdx];

      final blanks = _chooseVerticalBlanks(config.blanksPerEquation, vEq);

      equations.add(Equation(
        number: equationNumber,
        direction: EquationDirection.down,
        operandA: vEq.a,
        operator: vEq.op,
        operandB: vEq.b,
        result: vEq.result,
        startRow: 0,
        startCol: col,
        blankPositions: blanks,
      ));
      equationNumber++;
    }

    // Build the cell grid row by row
    for (int r = 0; r < gridRows; r++) {
      for (int c = 0; c < gridCols; c++) {
        cells.add(_buildCell(
          r, c, gridRows, gridCols, eqRows,
          horizontalEquations, verticalEquations, equations,
        ));
      }
    }

    return MathGrid(
      rows: gridRows,
      cols: gridCols,
      cells: cells,
      equations: equations,
    );
  }

  Cell _buildCell(
    int r, int c, int gridRows, int gridCols, int eqRows,
    List<_RawEquation> hEqs, List<_RawEquation> vEqs,
    List<Equation> equations,
  ) {
    // Determine what row type this is
    final isHorizontalEqRow = r.isEven && r < eqRows * 2;
    final isOperatorRow = r.isOdd && r < eqRows * 2 - 1;
    final isEqualsRow = r == eqRows * 2 - 1;
    final isResultRow = r == eqRows * 2;

    // Column positions: 0=operandA, 1=operator, 2=operandB, 3=equals, 4=result
    final isNumberCol = c == 0 || c == 2 || c == 4;

    if (isHorizontalEqRow) {
      final eqIdx = r ~/ 2;
      final hEq = hEqs[eqIdx];
      final equation = equations[eqIdx]; // horizontal equation

      if (c == 0) {
        return _numberCell(r, c, hEq.a, equation, 0);
      } else if (c == 1) {
        return Cell(row: r, col: c, type: CellType.operator, operatorSymbol: hEq.op);
      } else if (c == 2) {
        return _numberCell(r, c, hEq.b, equation, 2);
      } else if (c == 3) {
        return Cell(row: r, col: c, type: CellType.equals);
      } else {
        return _numberCell(r, c, hEq.result, equation, 4);
      }
    }

    if (isOperatorRow && isNumberCol) {
      final colIdx = c ~/ 2;
      if (colIdx < vEqs.length) {
        return Cell(
          row: r, col: c, type: CellType.operator,
          operatorSymbol: vEqs[colIdx].op,
        );
      }
    }

    if (isEqualsRow && isNumberCol) {
      return Cell(row: r, col: c, type: CellType.equals);
    }

    if (isResultRow && isNumberCol) {
      final colIdx = c ~/ 2;
      if (colIdx < vEqs.length) {
        final vEqFormal = equations[eqRows + colIdx];
        return _numberCell(r, c, vEqs[colIdx].result, vEqFormal, 4);
      }
    }

    // Empty / blocked cell
    return Cell(row: r, col: c, type: CellType.blocked);
  }

  /// Build a number cell, deciding if it should be blank or given based on
  /// whether this position is blank in any equation that uses it.
  Cell _numberCell(int r, int c, int value, Equation eq, int posInEq) {
    final isBlank = eq.blankPositions.contains(posInEq);
    if (isBlank) {
      return Cell(
        row: r, col: c, type: CellType.blank, answer: value,
      );
    }
    // For result position, mark as result type
    if (posInEq == 4) {
      return Cell(
        row: r, col: c, type: CellType.result, answer: value,
      );
    }
    return Cell(
      row: r, col: c, type: CellType.given, answer: value,
    );
  }

  /// Generate a random valid equation with the given config.
  _RawEquation _generateEquation(DifficultyConfig config) {
    for (int attempt = 0; attempt < 100; attempt++) {
      final op = config.operators[_random.nextInt(config.operators.length)];
      int a, b;

      switch (op) {
        case '+':
          a = _randomInRange(config.minOperand, config.maxOperand);
          b = _randomInRange(config.minOperand, config.maxOperand);
          return _RawEquation(a, op, b, a + b);
        case '-':
          a = _randomInRange(config.minOperand + 1, config.maxOperand);
          b = _randomInRange(config.minOperand, a);
          return _RawEquation(a, op, b, a - b);
        case 'x':
          a = _randomInRange(config.minOperand, min(config.maxOperand, 12));
          b = _randomInRange(config.minOperand, min(config.maxOperand, 9));
          return _RawEquation(a, op, b, a * b);
        case '/':
          b = _randomInRange(max(config.minOperand, 1), min(config.maxOperand, 9));
          final quotient = _randomInRange(1, min(config.maxOperand, 12));
          a = b * quotient;
          if (a <= config.maxOperand * 2) {
            return _RawEquation(a, op, b, quotient);
          }
          break;
      }
    }
    // Fallback to simple addition
    final a = _randomInRange(1, 9);
    final b = _randomInRange(1, 9);
    return _RawEquation(a, '+', b, a + b);
  }

  /// Build a vertical equation from the column values.
  /// For 2 rows: A op B = result, where A and B are the values.
  _RawEquation? _buildVerticalEquation(
    List<int> values, DifficultyConfig config,
  ) {
    if (values.length < 2) return null;
    final a = values[0];
    final b = values[1];

    // Try each available operator
    final ops = List<String>.from(config.operators)..shuffle(_random);
    for (final op in ops) {
      final result = Equation.compute(a, op, b);
      if (result != null && result >= 0) {
        return _RawEquation(a, op, b, result);
      }
    }

    // If no operator works, try addition always
    return _RawEquation(a, '+', b, a + b);
  }

  /// Choose which positions to make blank in a horizontal equation.
  List<int> _chooseBlanks(int count, _RawEquation eq) {
    // Positions: 0=A, 2=B, 4=result
    final candidates = [0, 2, 4];
    candidates.shuffle(_random);
    return candidates.take(min(count, candidates.length)).toList()..sort();
  }

  /// Choose blanks for vertical equations. For vertical equations,
  /// we are more conservative -- only blank 1 position.
  List<int> _chooseVerticalBlanks(int count, _RawEquation eq) {
    // For vertical, typically make the result blank, or one operand
    final candidates = [0, 2, 4];
    candidates.shuffle(_random);
    return candidates.take(min(1, candidates.length)).toList()..sort();
  }

  int _randomInRange(int minVal, int maxVal) {
    if (minVal >= maxVal) return minVal;
    return minVal + _random.nextInt(maxVal - minVal + 1);
  }
}

class _RawEquation {
  final int a;
  final String op;
  final int b;
  final int result;

  const _RawEquation(this.a, this.op, this.b, this.result);
}
