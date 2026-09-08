import 'package:bible_game/features/first_to_x_mode/first_to_x_question_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Tablet route for first-to-X mode.
///
/// The gameplay screen is shared with the phone so timers, socket wiring and
/// scoring cannot drift between layouts; only the question card's width cap
/// differs.
class FirstToXQuestionScreenTabletView extends StatelessWidget {
  const FirstToXQuestionScreenTabletView({super.key});

  @override
  Widget build(BuildContext context) =>
      FirstToXQuestionScreen(maxContentWidth: 700.w);
}
