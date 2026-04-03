/// App tuning constants. Change here, not scattered through code.
abstract final class AppConstants {
  // -- Puzzle generation --

  /// Maximum attempts to generate a valid puzzle before fallback.
  static const int maxGenerationAttempts = 50;

  // -- Difficulty thresholds --

  /// Levels 1-10: addition only, 2 equation rows, numbers 1-9.
  static const int additionOnlyMaxLevel = 10;

  /// Levels 11-20: addition + subtraction, 3 equation rows.
  static const int addSubMaxLevel = 20;

  /// Levels 21-35: add + sub + multiplication, 3 equation rows.
  static const int addSubMulMaxLevel = 35;

  /// Levels 36+: all operations including division.

  // -- Scoring --

  /// Base score per correctly filled cell.
  static const int baseScorePerCell = 10;

  /// Time bonus: score multiplier for quick solves.
  static const double timeBonusMultiplier = 2.0;

  /// Time threshold in seconds for bonus (solve under this = bonus).
  static const int timeBonusThresholdSeconds = 60;

  /// Score multiplier per hint used (penalty).
  static const double hintPenaltyMultiplier = 0.8;

  // -- Hints --

  /// Starting hint count for new players.
  static const int startingHints = 3;

  /// Hints earned per level completed.
  static const int hintsPerLevelComplete = 1;

  /// Hints earned from rewarded ad.
  static const int hintsPerRewardedAd = 2;

  // -- Ads --

  /// Show interstitial ad every N levels.
  static const int adFrequencyLevels = 3;

  /// IAP product IDs.
  static const String removeAdsProductId = 'math_cross_remove_ads';

  /// Available locales.
  static const Map<String, String> supportedLocales = {
    'en': 'English',
    'de': 'Deutsch',
    'es': 'Espanol',
    'uk': 'Ukrainska',
  };
}
