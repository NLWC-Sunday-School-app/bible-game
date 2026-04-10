import 'package:flutter/material.dart';

class AppColors {
  // ---------------------------------------------------------------------------
  // Brand / Primary
  // ---------------------------------------------------------------------------
  static const Color primaryColor = Color(0xFF366ABC);
  static const Color primaryColorShade = Color(0xFF0B79D1);
  static const Color accentColor = Color(0xFFF3DB3E);
  static const Color primaryDark = Color(0xFF366ABC);
  static const Color primaryDarkBackground = Color(0xFF0F2957);
  static const Color titleDropShadowColor = Color(0xFF014F8E);
  static const Color screenTopBorder = Color(0xFFEF798A);

  // ---------------------------------------------------------------------------
  // Blue family (used in UI chrome, stats, summaries)
  // ---------------------------------------------------------------------------

  /// Home screen app bar / header (0xFF548CD7 — 16×)
  static const Color homeAppBar = Color(0xFF548CD7);

  /// Question screen status bar (0xFF998BBC — 8×)
  static const Color questionScreenBar = Color(0xFF998BBC);

  /// Light variant used in list items and cards (0xFF6185BC — 8×)
  static const Color lightBlue = Color(0xFF6185BC);

  /// Bright interactive blue (0xFF0C70DB — 12×)
  static const Color brightBlue = Color(0xFF0C70DB);

  /// Deep primary blue shade (0xFF014CA3 — 18×)
  static const Color deepBlue = Color(0xFF014CA3);

  /// Alternate deep blue (0xFF014AA0 — 12×)
  static const Color deepBlueAlt = Color(0xFF014AA0);

  /// Navy blue (0xFF104387 — 11×)
  static const Color navyBlue = Color(0xFF104387);

  /// Dark navy (0xFF093D7B — 6×)
  static const Color darkNavy = Color(0xFF093D7B);

  /// Deep slate blue used in overlays/cards (0xFF364865 — 9×)
  static const Color slateBlue = Color(0xFF364865);

  /// Deep ink — stroke colour on outlined text (0xFF272D39 — 54×)
  static const Color deepInk = Color(0xFF272D39);

  // ---------------------------------------------------------------------------
  // Game summary / stats panel colours
  // ---------------------------------------------------------------------------

  /// Outer border on the "You earned" box (0xFF306DB6 — 6×)
  static const Color summaryBorderBlue = Color(0xFF306DB6);

  /// Large coin score text (0xFF1768B9 — 13×)
  static const Color summaryCoinText = Color(0xFF1768B9);

  /// Bonus-point badge border (0xFF0B5DB0 — 6×)
  static const Color summaryBonusBorder = Color(0xFF0B5DB0);

  /// Stats (questions / time) text colour (0xFF0155AF — 11×)
  static const Color summaryStatsText = Color(0xFF0155AF);

  // ---------------------------------------------------------------------------
  // Answer feedback
  // ---------------------------------------------------------------------------

  /// Correct-answer option highlight (0xFFA0E00A)
  static const Color correctAnswer = Color(0xFFA0E00A);

  /// Wrong-answer option highlight (0xFFB30C0C)
  static const Color wrongAnswer = Color(0xFFB30C0C);

  /// Quick-tips modal success green border (0xFF7FB57A — 8×)
  static const Color successGreenBorder = Color(0xFF7FB57A);

  // ---------------------------------------------------------------------------
  // Modal / overlay
  // ---------------------------------------------------------------------------

  /// Heavy modal barrier (0.95 opacity) used in most dialogs (13×)
  static const Color modalBarrier = Color.fromRGBO(40, 40, 40, 0.95);

  /// Lighter modal barrier (0.9 opacity) — quit/warning dialogs (11×)
  static const Color modalBarrierLight = Color.fromRGBO(40, 40, 40, 0.9);

  // ---------------------------------------------------------------------------
  // Surface / background colours
  // ---------------------------------------------------------------------------

  /// Light yellow — profile surfaces, game card highlights (0xFFFFFAD3 — 38×)
  static const Color lightYellowSurface = Color(0xFFFFFAD3);

  /// Warm yellow — question backgrounds (0xFFF8E193 — 10×)
  static const Color warmYellow = Color(0xFFF8E193);

  /// Mint / very light teal — game row backgrounds (0xFFD7EEED — 10×)
  static const Color mintBackground = Color(0xFFD7EEED);

  // ---------------------------------------------------------------------------
  // Text colours
  // ---------------------------------------------------------------------------

  /// Very dark brown — primary body text (0xFF22210D — 36×)
  static const Color darkBrownText = Color(0xFF22210D);

  /// Gold accent — level/achievement labels (0xFFBE9F37 — 16×)
  static const Color goldAccent = Color(0xFFBE9F37);

  // ---------------------------------------------------------------------------
  // Form fields
  // ---------------------------------------------------------------------------

  /// Input field fill / inactive border (0xFFD4DDDF — 31×)
  static const Color inputFieldFill = Color(0xFFD4DDDF);

  // ---------------------------------------------------------------------------
  // Game card colours (pre-existing)
  // ---------------------------------------------------------------------------
  static const Color scoreBackground = Color(0xFFFEF6C9);
  static const Color scoreShade = Color(0xFF7F6F15);
  static const Color scoreBorder = Color(0xFFD8C03B);
  static const Color scoreText = Color(0xFF554A0C);
  static const Color gemBackground = Color(0xFFF7A072);
  static const Color gemBorder = Color(0xFFC8571A);
  static const Color gemShade = Color(0xFF9B400E);
  static const Color gemText = Color(0xFF4E1C01);
  static const Color streakBackground = Color(0xFFEAD7D7);
  static const Color streakBorder = Color(0xFFFFFEFE);
  static const Color streakShade = Color(0xFF8E7B72);
  static const Color streakText = Color(0xFF5C321E);
  static const Color wiwGameCard = Color(0xFF7F9183);
  static const Color pilgrimProgressGameCard = Color(0xFF0892A5);
  static const Color fourScripturesGameCard = Color(0xFFCBD1C4);
  static const Color searchBoxBorder = Color(0xFFB1B1B1);

  // ---------------------------------------------------------------------------
  // New game mode card colours
  // ---------------------------------------------------------------------------
  static const Color devotionalGameCard = Color(0xFF6B4C9A);
  static const Color storyModeGameCard = Color(0xFF8B5E3C);
  static const Color trueOrFalseGameCard = Color(0xFFD4A017);
}
