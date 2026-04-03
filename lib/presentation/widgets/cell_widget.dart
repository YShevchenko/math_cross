import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/cell.dart';

/// Renders a single cell in the math crossword grid.
class CellWidget extends StatelessWidget {
  final Cell cell;
  final bool isSelected;
  final bool showValidation;
  final VoidCallback? onTap;

  const CellWidget({
    super.key,
    required this.cell,
    this.isSelected = false,
    this.showValidation = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (cell.type == CellType.blocked) {
      return Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: AppColors.cellBlocked,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    final bgColor = _backgroundColor();
    final borderColor = _borderColor();
    final textColor = _textColor();
    final fontSize = _fontSize();

    return GestureDetector(
      onTap: cell.isInputCell ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : showValidation && cell.isCorrect
                  ? [
                      BoxShadow(
                        color: AppColors.success.withValues(alpha: 0.3),
                        blurRadius: 6,
                        spreadRadius: 0,
                      ),
                    ]
                  : showValidation && cell.isWrong
                      ? [
                          BoxShadow(
                            color: AppColors.error.withValues(alpha: 0.3),
                            blurRadius: 6,
                            spreadRadius: 0,
                          ),
                        ]
                      : null,
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Text(
                cell.displayText,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: _fontWeight(),
                  color: textColor,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _backgroundColor() {
    if (isSelected) return AppColors.cellSelected;
    if (cell.isRevealed) {
      return AppColors.hintColor.withValues(alpha: 0.08);
    }
    if (showValidation && cell.isCorrect) return AppColors.cellCorrect;
    if (showValidation && cell.isWrong) return AppColors.cellWrong;
    switch (cell.type) {
      case CellType.blank:
        return AppColors.cellBackground;
      case CellType.given:
        return AppColors.surfaceContainerLow;
      case CellType.operator:
        return AppColors.surfaceContainerLowest;
      case CellType.equals:
        return AppColors.surfaceContainerLowest;
      case CellType.result:
        return AppColors.surfaceContainerLow;
      case CellType.blocked:
        return AppColors.cellBlocked;
    }
  }

  Color _borderColor() {
    if (isSelected) return AppColors.cellSelectedBorder;
    if (showValidation && cell.isCorrect) return AppColors.cellCorrectBorder;
    if (showValidation && cell.isWrong) return AppColors.cellWrongBorder;
    if (cell.type == CellType.blank && !cell.isFilled) {
      return AppColors.outline.withValues(alpha: 0.5);
    }
    return AppColors.cellBorder;
  }

  Color _textColor() {
    if (cell.isRevealed) return AppColors.hintColor;
    switch (cell.type) {
      case CellType.blank:
        if (showValidation && cell.isCorrect) return AppColors.success;
        if (showValidation && cell.isWrong) return AppColors.error;
        return AppColors.primary;
      case CellType.given:
        return AppColors.onSurface;
      case CellType.operator:
        return AppColors.operatorColor;
      case CellType.equals:
        return AppColors.equalsColor;
      case CellType.result:
        return AppColors.resultColor;
      case CellType.blocked:
        return Colors.transparent;
    }
  }

  double _fontSize() {
    switch (cell.type) {
      case CellType.operator:
      case CellType.equals:
        return 16;
      default:
        return 20;
    }
  }

  FontWeight _fontWeight() {
    switch (cell.type) {
      case CellType.blank:
        return FontWeight.w700;
      case CellType.given:
        return FontWeight.w600;
      case CellType.result:
        return FontWeight.w700;
      default:
        return FontWeight.w500;
    }
  }
}
