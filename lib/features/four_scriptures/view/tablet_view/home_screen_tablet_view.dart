import 'package:bible_game/features/four_scriptures/view/tablet_view/four_scripture_question_screen_tablet_view.dart';
import 'package:flutter/material.dart';
import 'package:bible_game/features/four_scriptures/view/four_scripture_question_screen.dart';

class FourScriptureHomeScreenTabletView extends StatelessWidget {
  const FourScriptureHomeScreenTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FourScriptureQuestionScreenTabletView(),
    );
  }
}
