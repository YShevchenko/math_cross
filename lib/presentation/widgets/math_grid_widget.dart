import 'package:flutter/material.dart';
import '../../domain/models/math_grid.dart';
import 'cell_widget.dart';

/// Renders the complete math crossword grid.
class MathGridWidget extends StatelessWidget {
  final MathGrid grid;
  final int? selectedRow;
  final int? selectedCol;
  final bool showValidation;
  final ValueChanged<(int, int)> onCellTap;

  const MathGridWidget({
    super.key,
    required this.grid,
    this.selectedRow,
    this.selectedCol,
    required this.showValidation,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: grid.cols / grid.rows,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: List.generate(grid.rows, (row) {
              return Expanded(
                child: Row(
                  children: List.generate(grid.cols, (col) {
                    final cell = grid.cellAt(row, col);
                    final isSelected =
                        selectedRow == row && selectedCol == col;
                    return Expanded(
                      child: CellWidget(
                        cell: cell,
                        isSelected: isSelected,
                        showValidation: showValidation,
                        onTap: () => onCellTap((row, col)),
                      ),
                    );
                  }),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
