import 'package:equatable/equatable.dart';
import 'cell.dart';
import 'equation.dart';

/// The complete math crossword grid.
class MathGrid extends Equatable {
  /// Number of rows in the grid.
  final int rows;

  /// Number of columns in the grid.
  final int cols;

  /// Flat list of cells (row-major order).
  final List<Cell> cells;

  /// All equations in this puzzle.
  final List<Equation> equations;

  const MathGrid({
    required this.rows,
    required this.cols,
    required this.cells,
    required this.equations,
  });

  /// Get a cell at (row, col).
  Cell cellAt(int row, int col) {
    return cells[row * cols + col];
  }

  /// Return a new grid with a cell replaced.
  MathGrid withCellAt(int row, int col, Cell cell) {
    final newCells = List<Cell>.from(cells);
    newCells[row * cols + col] = cell;
    return MathGrid(
      rows: rows,
      cols: cols,
      cells: newCells,
      equations: equations,
    );
  }

  /// All blank cells the player needs to fill.
  List<Cell> get blankCells =>
      cells.where((c) => c.type == CellType.blank).toList();

  /// Whether all blank cells are correctly filled.
  bool get isComplete =>
      blankCells.every((c) => c.isCorrect || c.isRevealed);

  /// Whether all blank cells have input (may be wrong).
  bool get allFilled => blankCells.every((c) => c.isFilled);

  /// Number of blank cells correctly filled (not revealed).
  int get correctCount =>
      blankCells.where((c) => c.isCorrect && !c.isRevealed).length;

  /// Total number of blank cells.
  int get totalBlanks => blankCells.length;

  /// Number of hints used (revealed cells).
  int get hintsUsed => blankCells.where((c) => c.isRevealed).length;

  Map<String, dynamic> toJson() {
    return {
      'rows': rows,
      'cols': cols,
      'cells': cells.map((c) => c.toJson()).toList(),
      'equations': equations.map((e) => e.toJson()).toList(),
    };
  }

  factory MathGrid.fromJson(Map<String, dynamic> json) {
    return MathGrid(
      rows: json['rows'] as int,
      cols: json['cols'] as int,
      cells: (json['cells'] as List)
          .map((c) => Cell.fromJson(c as Map<String, dynamic>))
          .toList(),
      equations: (json['equations'] as List)
          .map((e) => Equation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [rows, cols, cells, equations];
}
