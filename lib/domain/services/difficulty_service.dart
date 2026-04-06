import '../../core/constants.dart';

/// Difficulty configuration for a given level.
class DifficultyConfig {
  /// Available operator symbols for this level.
  final List<String> operators;

  /// Number of horizontal equation rows.
  final int equationRows;

  /// Number of vertical equation columns.
  final int equationCols;

  /// Minimum operand value.
  final int minOperand;

  /// Maximum operand value.
  final int maxOperand;

  /// Number of blanks per equation (1 or 2).
  final int blanksPerEquation;

  const DifficultyConfig({
    required this.operators,
    required this.equationRows,
    required this.equationCols,
    required this.minOperand,
    required this.maxOperand,
    required this.blanksPerEquation,
  });
}

/// Determines puzzle difficulty based on level number.
class DifficultyService {
  const DifficultyService();

  DifficultyConfig configForLevel(int level) {
    if (level <= AppConstants.additionOnlyMaxLevel) {
      // Levels 1-25: Addition only
      // Gradually increase operand range and blanks
      final maxOp = level <= 10 ? 9 : (level <= 18 ? 12 : 15);
      final blanks = level <= 12 ? 1 : 2;
      return DifficultyConfig(
        operators: ['+'],
        equationRows: 2,
        equationCols: 2,
        minOperand: 1,
        maxOperand: maxOp,
        blanksPerEquation: blanks,
      );
    } else if (level <= AppConstants.addSubMaxLevel) {
      // Levels 26-50: Addition + Subtraction
      final maxOp = level <= 35 ? 12 : (level <= 42 ? 15 : 20);
      final blanks = level <= 35 ? 1 : 2;
      return DifficultyConfig(
        operators: ['+', '-'],
        equationRows: 2,
        equationCols: 2,
        minOperand: 1,
        maxOperand: maxOp,
        blanksPerEquation: blanks,
      );
    } else if (level <= AppConstants.addSubMulMaxLevel) {
      // Levels 51-75: Addition + Subtraction + Multiplication
      final maxOp = level <= 60 ? 9 : (level <= 68 ? 12 : 15);
      final blanks = level <= 58 ? 1 : 2;
      final rows = level <= 60 ? 2 : 3;
      return DifficultyConfig(
        operators: ['+', '-', 'x'],
        equationRows: rows,
        equationCols: rows,
        minOperand: 1,
        maxOperand: maxOp,
        blanksPerEquation: blanks,
      );
    } else {
      // Levels 76-100: All operations including division
      final maxOp = level <= 85 ? 12 : (level <= 93 ? 15 : 20);
      final blanks = level <= 82 ? 1 : 2;
      return DifficultyConfig(
        operators: ['+', '-', 'x', '/'],
        equationRows: 3,
        equationCols: 3,
        minOperand: 1,
        maxOperand: maxOp,
        blanksPerEquation: blanks,
      );
    }
  }

  /// Grid dimensions based on configuration.
  /// Each equation strip is 5 cells wide: [A] [op] [B] [=] [R]
  /// Rows = equationRows * 2 - 1 (equations interleaved with operator rows)
  /// Cols = equationCols * 2 - 1 (likewise for columns)
  /// But we use a simpler fixed grid approach:
  /// 2x2 equations -> 5x5 grid
  /// 3x3 equations -> 7x7 grid (but we use 5 cols)
  int gridRows(DifficultyConfig config) {
    // Each horizontal equation takes 1 row of cells.
    // Vertical equations fill columns. Operator rows are between.
    // With N rows of equations: 2*N - 1 display rows, 5 columns each.
    return config.equationRows * 2 - 1;
  }

  int gridCols(DifficultyConfig config) {
    return 5; // Always 5 columns: A op B = R
  }
}
