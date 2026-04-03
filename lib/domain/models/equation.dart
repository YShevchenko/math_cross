import 'package:equatable/equatable.dart';

/// Direction of an equation strip in the grid.
enum EquationDirection { across, down }

/// Represents a single math equation placed on the grid.
/// Format: operandA [op] operandB = result
class Equation extends Equatable {
  /// Unique ID for this equation (e.g., "1 Across").
  final int number;

  /// Direction: across or down.
  final EquationDirection direction;

  /// First operand.
  final int operandA;

  /// Operator symbol: +, -, x, /
  final String operator;

  /// Second operand.
  final int operandB;

  /// Result of the equation.
  final int result;

  /// Starting row in the grid.
  final int startRow;

  /// Starting column in the grid.
  final int startCol;

  /// Which positions are blank (0 = operandA, 2 = operandB, 4 = result).
  /// These are the cell indices in the 5-cell strip [A, op, B, =, R].
  final List<int> blankPositions;

  const Equation({
    required this.number,
    required this.direction,
    required this.operandA,
    required this.operator,
    required this.operandB,
    required this.result,
    required this.startRow,
    required this.startCol,
    required this.blankPositions,
  });

  /// Validate that the equation is mathematically correct.
  bool get isValid {
    switch (operator) {
      case '+':
        return operandA + operandB == result;
      case '-':
        return operandA - operandB == result;
      case 'x':
        return operandA * operandB == result;
      case '/':
        return operandB != 0 && operandA % operandB == 0 &&
            operandA ~/ operandB == result;
      default:
        return false;
    }
  }

  /// Compute the result for validation.
  static int? compute(int a, String op, int b) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case 'x':
        return a * b;
      case '/':
        if (b == 0 || a % b != 0) return null;
        return a ~/ b;
      default:
        return null;
    }
  }

  /// Human-readable label.
  String get label {
    final dir = direction == EquationDirection.across ? 'Across' : 'Down';
    return '$number $dir';
  }

  /// Human-readable equation string with blanks.
  String toDisplayString() {
    final a = blankPositions.contains(0) ? '_' : '$operandA';
    final b = blankPositions.contains(2) ? '_' : '$operandB';
    final r = blankPositions.contains(4) ? '_' : '$result';
    return '$a $operator $b = $r';
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'direction': direction.index,
      'operandA': operandA,
      'operator': operator,
      'operandB': operandB,
      'result': result,
      'startRow': startRow,
      'startCol': startCol,
      'blankPositions': blankPositions,
    };
  }

  factory Equation.fromJson(Map<String, dynamic> json) {
    return Equation(
      number: json['number'] as int,
      direction: EquationDirection.values[json['direction'] as int],
      operandA: json['operandA'] as int,
      operator: json['operator'] as String,
      operandB: json['operandB'] as int,
      result: json['result'] as int,
      startRow: json['startRow'] as int,
      startCol: json['startCol'] as int,
      blankPositions: (json['blankPositions'] as List).cast<int>(),
    );
  }

  @override
  List<Object?> get props => [
        number, direction, operandA, operator, operandB, result,
        startRow, startCol, blankPositions,
      ];
}
