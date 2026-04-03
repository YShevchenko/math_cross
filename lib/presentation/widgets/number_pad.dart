import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';

/// Number input pad (0-9 plus backspace).
class NumberPad extends StatelessWidget {
  final ValueChanged<int> onNumberTap;
  final VoidCallback onBackspace;
  final bool hapticEnabled;

  const NumberPad({
    super.key,
    required this.onNumberTap,
    required this.onBackspace,
    this.hapticEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: 1-5
          Row(
            children: [
              for (int i = 1; i <= 5; i++) ...[
                if (i > 1) const SizedBox(width: 6),
                Expanded(child: _NumberKey(
                  label: '$i',
                  onTap: () {
                    if (hapticEnabled) HapticFeedback.lightImpact();
                    onNumberTap(i);
                  },
                )),
              ],
            ],
          ),
          const SizedBox(height: 6),
          // Row 2: 6-9, 0, backspace
          Row(
            children: [
              for (int i = 6; i <= 9; i++) ...[
                if (i > 6) const SizedBox(width: 6),
                Expanded(child: _NumberKey(
                  label: '$i',
                  onTap: () {
                    if (hapticEnabled) HapticFeedback.lightImpact();
                    onNumberTap(i);
                  },
                )),
              ],
              const SizedBox(width: 6),
              Expanded(child: _NumberKey(
                label: '0',
                onTap: () {
                  if (hapticEnabled) HapticFeedback.lightImpact();
                  onNumberTap(0);
                },
              )),
              const SizedBox(width: 6),
              Expanded(child: _BackspaceKey(
                onTap: () {
                  if (hapticEnabled) HapticFeedback.lightImpact();
                  onBackspace();
                },
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class _NumberKey extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NumberKey({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.numberPadKey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.numberPadKeyBorder,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
    );
  }
}

class _BackspaceKey extends StatelessWidget {
  final VoidCallback onTap;

  const _BackspaceKey({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.errorContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.error.withValues(alpha: 0.3),
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.backspace_outlined,
            color: AppColors.error,
            size: 22,
          ),
        ),
      ),
    );
  }
}
