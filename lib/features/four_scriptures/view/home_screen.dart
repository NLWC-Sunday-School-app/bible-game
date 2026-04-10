import 'package:flutter/material.dart';
import 'package:bible_game/features/four_scriptures/view/four_scripture_question_screen.dart';

class FourScriptureHomeScreen extends StatelessWidget {
  const FourScriptureHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FourScriptureQuestionScreen(),
    );
  }
}
