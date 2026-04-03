import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/equation.dart';
import '../../l10n/app_localizations.dart';

/// Displays the equation clues like a crossword clue list.
class EquationHints extends StatelessWidget {
  final List<Equation> equations;
  final int? highlightedEquation;

  const EquationHints({
    super.key,
    required this.equations,
    this.highlightedEquation,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final acrossEqs = equations
        .where((e) => e.direction == EquationDirection.across)
        .toList();
    final downEqs = equations
        .where((e) => e.direction == EquationDirection.down)
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _ClueColumn(
              title: l10n.across.toUpperCase(),
              equations: acrossEqs,
              highlightedEquation: highlightedEquation,
            ),
          ),
          Container(
            width: 1,
            height: 80,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
          Expanded(
            child: _ClueColumn(
              title: l10n.down.toUpperCase(),
              equations: downEqs,
              highlightedEquation: highlightedEquation,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClueColumn extends StatelessWidget {
  final String title;
  final List<Equation> equations;
  final int? highlightedEquation;

  const _ClueColumn({
    required this.title,
    required this.equations,
    this.highlightedEquation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 3,
                color: AppColors.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 4),
        ...equations.map((eq) {
          final isHighlighted = highlightedEquation == eq.number;
          return Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              '${eq.number}. ${eq.toDisplayString()}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isHighlighted
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                    fontWeight: isHighlighted
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
            ),
          );
        }),
      ],
    );
  }
}
