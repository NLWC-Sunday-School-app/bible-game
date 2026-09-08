import 'package:bible_game/features/lightning_mode/view/lightning_mode_question_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Tablet route for lightning mode.
///
/// The gameplay screen is shared with the phone so timers, socket wiring and
/// scoring cannot drift between layouts; only the question card's width cap
/// differs.
class LightningModeQuestionScreenTabletView extends StatelessWidget {
  const LightningModeQuestionScreenTabletView({super.key});

  @override
  Widget build(BuildContext context) =>
      LightningModeQuestionScreen(maxContentWidth: 700.w);
}
