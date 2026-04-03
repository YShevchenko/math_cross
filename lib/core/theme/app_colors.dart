import 'package:flutter/material.dart';

/// Neon Void color palette -- Math Cross.
abstract final class AppColors {
  // Core surfaces
  static const background = Color(0xFF0E0E13);
  static const surface = Color(0xFF0E0E13);
  static const surfaceContainer = Color(0xFF16161C);
  static const surfaceContainerLow = Color(0xFF121217);
  static const surfaceContainerHigh = Color(0xFF1C1C24);
  static const surfaceContainerHighest = Color(0xFF22222C);
  static const surfaceContainerLowest = Color(0xFF0A0A0E);
  static const surfaceBright = Color(0xFF2A2A36);

  // Primary (neon cyan)
  static const primary = Color(0xFF00F0FF);
  static const primaryContainer = Color(0xFF00C8D7);
  static const primaryDim = Color(0xFF009AA8);
  static const onPrimary = Color(0xFF002B30);
  static const onPrimaryFixed = Color(0xFF001F24);
  static const neonCyan = Color(0xFF00F0FF);

  // Secondary (neon pink)
  static const secondary = Color(0xFFFF59E3);
  static const secondaryContainer = Color(0xFFFF29D6);
  static const onSecondary = Color(0xFF3E0036);

  // Tertiary (neon gold)
  static const tertiary = Color(0xFFFFD700);
  static const tertiaryContainer = Color(0xFFFFB800);
  static const tertiaryDim = Color(0xFFCC9900);

  // Error
  static const error = Color(0xFFFF716C);
  static const errorContainer = Color(0xFF9F0519);
  static const onErrorContainer = Color(0xFFFFA8A3);

  // Success
  static const success = Color(0xFF4ADE80);
  static const successGlow = Color(0x664ADE80);

  // Text / surface
  static const onSurface = Color(0xFFF3EFF6);
  static const onSurfaceVariant = Color(0xFF8A8E9E);
  static const onBackground = Color(0xFFF3EFF6);
  static const outline = Color(0xFF5A5E70);
  static const outlineVariant = Color(0xFF36384A);

  // Glow presets
  static const primaryGlow = Color(0x6600F0FF);
  static const primaryGlowStrong = Color(0x9900C8D7);
  static const secondaryGlow = Color(0x44FF59E3);
  static const tertiaryGlow = Color(0x44FFD700);
  static const errorGlow = Color(0x44FF716C);

  // Game-specific
  static const cellBackground = Color(0xFF1A1A24);
  static const cellBorder = Color(0xFF2A2A3A);
  static const cellSelected = Color(0xFF003844);
  static const cellSelectedBorder = Color(0xFF00F0FF);
  static const cellCorrect = Color(0xFF0A2E1A);
  static const cellCorrectBorder = Color(0xFF4ADE80);
  static const cellWrong = Color(0xFF2E0A0A);
  static const cellWrongBorder = Color(0xFFFF716C);
  static const cellBlocked = Color(0xFF0A0A0E);
  static const operatorColor = Color(0xFF8A8E9E);
  static const equalsColor = Color(0xFF5A5E70);
  static const resultColor = Color(0xFFFFD700);
  static const numberPadKey = Color(0xFF1C1C24);
  static const numberPadKeyBorder = Color(0xFF2A2A36);
  static const hintColor = Color(0xFFFFD700);
}
