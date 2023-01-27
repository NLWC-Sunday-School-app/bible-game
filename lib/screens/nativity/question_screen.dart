import 'package:bible_game/widgets/modals/auth_modal.dart';
import 'package:bible_game/widgets/modals/quit_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/nativity_question_controller.dart';
import '../../widgets/nativity/question_container.dart';

class NativityQuestionScreen extends StatefulWidget {
  const NativityQuestionScreen({Key? key}) : super(key: key);
  static String routeName = "/nativity-game-question-screen";

  @override
  State<NativityQuestionScreen> createState() => _NativityQuestionScreenState();
}

class _NativityQuestionScreenState extends State<NativityQuestionScreen> {
  final NativityQuestionController _questionController = Get.put(NativityQuestionController());
  Future<bool?> showWarning(BuildContext context) async => Get.dialog(const QuitModal(), barrierDismissible: false,);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        final displayDialog = await showWarning(context);
        return displayDialog ?? false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          Expanded(
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _questionController.pageController,
              onPageChanged: _questionController.updateTheQuestionNumber,
              itemCount: _questionController.questions.length,
              itemBuilder: (context, index) => QuestionContainer(
                question: _questionController.questions[index],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
