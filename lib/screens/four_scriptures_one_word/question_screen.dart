import 'package:bible_game/controllers/four_Scriptures_one_word_controller.dart';
import 'package:bible_game/screens/four_scriptures_one_word/question_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/four_scriptures_question_controller.dart';
import '../../widgets/modals/four_scriptures_quit_modal.dart';
import '../../widgets/modals/quit_modal.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
class FourScriptureQuestionScreen extends StatefulWidget {
  const FourScriptureQuestionScreen({Key? key}) : super(key: key);

  @override
  State<FourScriptureQuestionScreen> createState() => _FourScriptureQuestionScreenState();
}

class _FourScriptureQuestionScreenState extends State<FourScriptureQuestionScreen> {
  Future<bool?> showWarning(BuildContext context) async => Get.dialog(const FourScripturesQuitModal(), barrierDismissible: false,);
  FourScriptureQuestionController fourScriptureQuestionController = Get.put(FourScriptureQuestionController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        final displayDialog = await showWarning(context);
        return displayDialog ?? false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: fourScriptureQuestionController.pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: fourScriptureQuestionController.questions.length,
                itemBuilder: (context, index) => QuestionContainer(
                  question: fourScriptureQuestionController.questions[index],

                ),
            )
            )
          ]
        ),
      ),
    );
  }
}
