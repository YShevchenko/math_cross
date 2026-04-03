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
      return DifficultyConfig(
        operators: ['+'],
        equationRows: 2,
        equationCols: 2,
        minOperand: 1,
        maxOperand: 9,
        blanksPerEquation: 1,
      );
    } else if (level <= AppConstants.addSubMaxLevel) {
      return DifficultyConfig(
        operators: ['+', '-'],
        equationRows: 2,
        equationCols: 2,
        minOperand: 1,
        maxOperand: 15,
        blanksPerEquation: 1,
      );
    } else if (level <= AppConstants.addSubMulMaxLevel) {
      return DifficultyConfig(
        operators: ['+', '-', 'x'],
        equationRows: 3,
        equationCols: 3,
        minOperand: 1,
        maxOperand: 12,
        blanksPerEquation: 2,
      );
    } else {
      return DifficultyConfig(
        operators: ['+', '-', 'x', '/'],
        equationRows: 3,
        equationCols: 3,
        minOperand: 1,
        maxOperand: 15,
        blanksPerEquation: 2,
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
