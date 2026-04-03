import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../providers/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: AppColors.neonCyan),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    l10n.settings.toUpperCase(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.neonCyan,
                          letterSpacing: 4,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 16),
                  _SectionHeader(title: l10n.preferences.toUpperCase()),
                  const SizedBox(height: 12),
                  _ToggleTile(
                    title: l10n.soundEffects,
                    icon: Icons.volume_up_outlined,
                    value: settings.soundEnabled,
                    onChanged: (_) => settingsNotifier.toggleSound(),
                  ),
                  _ToggleTile(
                    title: l10n.hapticFeedback,
                    icon: Icons.vibration,
                    value: settings.hapticEnabled,
                    onChanged: (_) => settingsNotifier.toggleHaptic(),
                  ),
                  const SizedBox(height: 24),
                  _SectionHeader(title: l10n.language.toUpperCase()),
                  const SizedBox(height: 12),
                  ...AppConstants.supportedLocales.entries.map((entry) {
                    return _LanguageTile(
                      code: entry.key,
                      name: entry.value,
                      isSelected: settings.locale == entry.key,
                      onTap: () => settingsNotifier.setLocale(entry.key),
                    );
                  }),
                  const SizedBox(height: 24),
                  _SectionHeader(title: l10n.purchases.toUpperCase()),
                  const SizedBox(height: 12),
                  _ActionTile(
                    title: l10n.restore,
                    icon: Icons.refresh,
                    onTap: () {
                      ref.read(iapServiceProvider).restorePurchases();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.restore),
                          backgroundColor: AppColors.surfaceContainerHigh,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _SectionHeader(title: l10n.stats.toUpperCase()),
                  const SizedBox(height: 12),
                  _buildStats(context, ref, l10n),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(
    BuildContext context, WidgetRef ref, AppLocalizations l10n,
  ) {
    final stats = ref.watch(progressProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          _StatLine(
            label: l10n.puzzlesCompleted,
            value: '${stats.totalPuzzlesCompleted}',
          ),
          const SizedBox(height: 8),
          _StatLine(
            label: l10n.highestLevel,
            value: '${stats.highestLevel}',
          ),
          const SizedBox(height: 8),
          _StatLine(
            label: l10n.totalScore,
            value: _fmtInt(stats.totalScore),
          ),
          const SizedBox(height: 8),
          _StatLine(
            label: l10n.bestScore,
            value: _fmtInt(stats.bestLevelScore),
          ),
          const SizedBox(height: 8),
          _StatLine(
            label: l10n.hintsUsed,
            value: '${stats.totalHintsUsed}',
          ),
          const SizedBox(height: 8),
          _StatLine(
            label: l10n.totalPlayTime,
            value: _fmtTime(stats.totalPlayTimeSeconds),
          ),
        ],
      ),
    );
  }

  String _fmtInt(int n) {
    if (n >= 1e6) return '${(n / 1e6).toStringAsFixed(1)}M';
    if (n >= 1e3) return '${(n / 1e3).toStringAsFixed(1)}K';
    return n.toString();
  }

  String _fmtTime(int totalSeconds) {
    if (totalSeconds < 60) return '${totalSeconds}s';
    final minutes = totalSeconds ~/ 60;
    if (minutes < 60) return '${minutes}m';
    final hours = minutes ~/ 60;
    return '${hours}h';
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            letterSpacing: 4,
            color: AppColors.onSurfaceVariant,
          ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String code;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.code,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.neonCyan.withValues(alpha: 0.08)
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.neonCyan.withValues(alpha: 0.3)
                : AppColors.outlineVariant.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Text(
              code.toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color:
                        isSelected ? AppColors.neonCyan : AppColors.outline,
                    letterSpacing: 2,
                  ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isSelected
                          ? AppColors.onSurface
                          : AppColors.onSurfaceVariant,
                    ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle,
                  color: AppColors.neonCyan, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
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
