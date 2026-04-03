import 'package:equatable/equatable.dart';

/// Types of cells in the math crossword grid.
enum CellType {
  /// A number cell the player must fill in.
  blank,

  /// A number cell with a fixed (given) value.
  given,

  /// An operator cell (+, -, x, /).
  operator,

  /// An equals sign cell.
  equals,

  /// The result of an equation (given).
  result,

  /// A blocked/black cell (no content).
  blocked,
}

/// A single cell in the math crossword grid.
class Cell extends Equatable {
  /// Row position in the grid.
  final int row;

  /// Column position in the grid.
  final int col;

  /// Type of this cell.
  final CellType type;

  /// The correct answer for blank cells, or value for given/result cells.
  final int? answer;

  /// The operator string for operator cells.
  final String? operatorSymbol;

  /// The player's current input for blank cells.
  final int? userInput;

  /// Whether this cell has been revealed by a hint.
  final bool isRevealed;

  const Cell({
    required this.row,
    required this.col,
    required this.type,
    this.answer,
    this.operatorSymbol,
    this.userInput,
    this.isRevealed = false,
  });

  /// Whether this cell accepts player input.
  bool get isInputCell => type == CellType.blank && !isRevealed;

  /// Whether this cell is correctly filled.
  bool get isCorrect =>
      type == CellType.blank && userInput != null && userInput == answer;

  /// Whether this cell is incorrectly filled.
  bool get isWrong =>
      type == CellType.blank && userInput != null && userInput != answer;

  /// Whether this cell has any user input.
  bool get isFilled => userInput != null || isRevealed;

  /// Display text for this cell.
  String get displayText {
    if (type == CellType.blocked) return '';
    if (type == CellType.operator) return operatorSymbol ?? '';
    if (type == CellType.equals) return '=';
    if (isRevealed) return '${answer ?? ''}';
    if (type == CellType.blank) return userInput?.toString() ?? '';
    if (type == CellType.given) return '${answer ?? ''}';
    if (type == CellType.result) return '${answer ?? ''}';
    return '';
  }

  Cell copyWith({
    int? userInput,
    bool? isRevealed,
  }) {
    return Cell(
      row: row,
      col: col,
      type: type,
      answer: answer,
      operatorSymbol: operatorSymbol,
      userInput: userInput,
      isRevealed: isRevealed ?? this.isRevealed,
    );
  }

  /// Clear user input.
  Cell clearInput() {
    return Cell(
      row: row,
      col: col,
      type: type,
      answer: answer,
      operatorSymbol: operatorSymbol,
      userInput: null,
      isRevealed: isRevealed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'row': row,
      'col': col,
      'type': type.index,
      'answer': answer,
      'operatorSymbol': operatorSymbol,
      'userInput': userInput,
      'isRevealed': isRevealed,
    };
  }

  factory Cell.fromJson(Map<String, dynamic> json) {
    return Cell(
      row: json['row'] as int,
      col: json['col'] as int,
      type: CellType.values[json['type'] as int],
      answer: json['answer'] as int?,
      operatorSymbol: json['operatorSymbol'] as String?,
      userInput: json['userInput'] as int?,
      isRevealed: json['isRevealed'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props =>
      [row, col, type, answer, operatorSymbol, userInput, isRevealed];
}
