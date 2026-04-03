import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import 'neon_button.dart';
import 'neon_glow.dart';

/// Victory modal shown when a puzzle is completed.
class VictoryModal extends StatelessWidget {
  final int level;
  final int score;
  final int timeSeconds;
  final bool isNewBest;
  final VoidCallback onNextLevel;
  final VoidCallback onBackToMenu;

  const VictoryModal({
    super.key,
    required this.level,
    required this.score,
    required this.timeSeconds,
    required this.isNewBest,
    required this.onNextLevel,
    required this.onBackToMenu,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: AppColors.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NeonText(
              l10n.wellDone,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
              glowColor: AppColors.primaryGlowStrong,
            ),
            const SizedBox(height: 8),
            Text(
              '${l10n.level} $level ${l10n.complete}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    letterSpacing: 2,
                  ),
            ),
            const SizedBox(height: 24),
            _StatLine(label: l10n.score, value: '$score'),
            const SizedBox(height: 8),
            _StatLine(label: l10n.time, value: _formatTime(timeSeconds)),
            if (isNewBest) ...[
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.tertiary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  l10n.newBest,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.tertiary,
                        letterSpacing: 2,
                      ),
                ),
              ),
            ],
            const SizedBox(height: 28),
            NeonButton(
              label: l10n.nextLevel.toUpperCase(),
              onTap: onNextLevel,
              icon: Icons.arrow_forward,
            ),
            const SizedBox(height: 12),
            NeonOutlinedButton(
              label: l10n.backToMenu,
              onTap: onBackToMenu,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class _StatLine extends StatelessWidget {
  final String label;
  final String value;

  const _StatLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
