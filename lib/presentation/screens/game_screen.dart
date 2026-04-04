import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/equation.dart';
import '../../domain/models/math_grid.dart';
import '../../l10n/app_localizations.dart';
import '../providers/providers.dart';
import '../widgets/equation_hints.dart';
import '../widgets/math_grid_widget.dart';
import '../widgets/neon_glow.dart';
import '../widgets/number_pad.dart';
import '../widgets/victory_modal.dart';

class GameScreen extends ConsumerStatefulWidget {
  final int level;

  const GameScreen({super.key, required this.level});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  int? _selectedRow;
  int? _selectedCol;
  Timer? _timer;
  bool _showValidation = false;
  int? _cachedHighlightedEquation;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(gameStateProvider.notifier).startLevel(widget.level);
      _startTimer();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final game = ref.read(gameStateProvider);
      if (!game.isCompleted) {
        ref.read(gameStateProvider.notifier).tick();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _selectCell(int row, int col) {
    setState(() {
      _selectedRow = row;
      _selectedCol = col;
      // Recompute highlighted equation when selection changes
      final game = ref.read(gameStateProvider);
      final grid = game.grid;
      if (grid != null) {
        _cachedHighlightedEquation = _computeHighlightedEquation(grid, row, col);
      }
    });
  }

  void _inputNumber(int number) {
    if (_selectedRow == null || _selectedCol == null) return;

    final settings = ref.read(settingsProvider);
    if (settings.hapticEnabled) {
      HapticFeedback.lightImpact();
    }

    ref.read(gameStateProvider.notifier).placeNumber(
      _selectedRow!, _selectedCol!, number,
    );

    // Check if puzzle is complete after placing
    final game = ref.read(gameStateProvider);
    if (game.isCompleted && !game.showedCompletion) {
      _onPuzzleComplete();
    }
  }

  void _clearCell() {
    if (_selectedRow == null || _selectedCol == null) return;

    final settings = ref.read(settingsProvider);
    if (settings.hapticEnabled) {
      HapticFeedback.lightImpact();
    }

    ref.read(gameStateProvider.notifier).clearCell(
      _selectedRow!, _selectedCol!,
    );
  }

  void _useHint() {
    final stats = ref.read(progressProvider);
    if (stats.hintsAvailable <= 0) {
      _showNoHintsDialog();
      return;
    }

    final used = ref.read(gameStateProvider.notifier).useHint();
    if (used) {
      ref.read(progressProvider.notifier).useHint();

      final game = ref.read(gameStateProvider);
      if (game.isCompleted && !game.showedCompletion) {
        _onPuzzleComplete();
      }
    }
  }

  void _showNoHintsDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        title: Text(l10n.noHintsAvailable),
        content: Text(l10n.watchAdForHints),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final adService = ref.read(adServiceProvider);
              final rewarded = await adService.showRewardedAd();
              if (rewarded) {
                ref.read(progressProvider.notifier)
                    .addHints(AppConstants.hintsPerRewardedAd);
                ref.read(gameStateProvider.notifier)
                    .addHints(AppConstants.hintsPerRewardedAd);
              }
            },
            child: Text(l10n.watchAdForHints),
          ),
        ],
      ),
    );
  }

  void _onPuzzleComplete() {
    _timer?.cancel();
    setState(() => _showValidation = true);

    final game = ref.read(gameStateProvider);
    ref.read(gameStateProvider.notifier).markCompletionShown();

    // Record stats
    final isNewBest = game.score > ref.read(progressProvider).bestLevelScore;
    ref.read(progressProvider.notifier).recordPuzzleComplete(
      level: game.level,
      score: game.score,
      hintsUsed: game.grid?.hintsUsed ?? 0,
      timeTaken: game.elapsedSeconds,
    );
    ref.read(progressProvider.notifier)
        .addHints(AppConstants.hintsPerLevelComplete);
    ref.read(gameStateProvider.notifier)
        .addHints(AppConstants.hintsPerLevelComplete);

    // Show ad periodically
    ref.read(adServiceProvider).showInterstitialIfReady(game.level);

    // Show victory modal
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => VictoryModal(
          level: game.level,
          score: game.score,
          timeSeconds: game.elapsedSeconds,
          isNewBest: isNewBest,
          onNextLevel: () {
            Navigator.pop(context); // close modal
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => GameScreen(level: game.level + 1),
              ),
            );
          },
          onBackToMenu: () {
            Navigator.pop(context); // close modal
            Navigator.pop(context); // back to menu
          },
        ),
      );
    });
  }

  void _checkAnswers() {
    setState(() => _showValidation = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showValidation = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameStateProvider);
    final stats = ref.watch(progressProvider);
    final settings = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;

    final grid = game.grid;
    if (grid == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar: back, level, score, time, hints
            _buildTopBar(context, l10n, game, stats),
            const SizedBox(height: 8),

            // Equation hints (clues)
            EquationHints(
              equations: grid.equations,
              highlightedEquation: _cachedHighlightedEquation,
            ),
            const SizedBox(height: 8),

            // Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MathGridWidget(
                  grid: grid,
                  selectedRow: _selectedRow,
                  selectedCol: _selectedCol,
                  showValidation: _showValidation,
                  onCellTap: (pos) => _selectCell(pos.$1, pos.$2),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Action buttons row
            _buildActionBar(context, l10n, grid),
            const SizedBox(height: 8),

            // Number pad
            NumberPad(
              onNumberTap: _inputNumber,
              onBackspace: _clearCell,
              hapticEnabled: settings.hapticEnabled,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context, AppLocalizations l10n, game, stats,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.neonCyan),
            onPressed: () => Navigator.pop(context),
          ),
          NeonText(
            '${l10n.level} ${game.level}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.neonCyan,
                  fontWeight: FontWeight.w700,
                ),
            glowColor: AppColors.neonCyan.withValues(alpha: 0.3),
          ),
          const Spacer(),
          // Time
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined,
                    color: AppColors.onSurfaceVariant, size: 16),
                const SizedBox(width: 4),
                Text(
                  _formatTime(game.elapsedSeconds),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Hints
          GestureDetector(
            onTap: _useHint,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.hintColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.hintColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline,
                      color: AppColors.hintColor, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${stats.hintsAvailable}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.hintColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar(
    BuildContext context, AppLocalizations l10n, grid,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (grid.allFilled && !grid.isComplete)
            GestureDetector(
              onTap: _checkAnswers,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  'CHECK',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                        letterSpacing: 2,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  int? _computeHighlightedEquation(MathGrid grid, int? row, int? col) {
    if (row == null || col == null) return null;
    // Find equations that contain the selected cell
    for (final eq in grid.equations) {
      if (eq.direction == EquationDirection.across && row == eq.startRow) {
        return eq.number;
      }
      if (eq.direction == EquationDirection.down && col == eq.startCol) {
        return eq.number;
      }
    }
    return null;
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
