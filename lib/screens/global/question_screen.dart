import 'package:bible_game/widgets/modals/auth_modal.dart';
import 'package:bible_game/widgets/modals/quit_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/global_question_controller.dart';
import '../../widgets/global/question_container.dart';

class GlobalQuestionScreen extends StatefulWidget {
  const GlobalQuestionScreen({Key? key}) : super(key: key);
  static String routeName = "/global-game-question-screen";

  @override
  State<GlobalQuestionScreen> createState() => _GlobalQuestionScreenState();
}

class _GlobalQuestionScreenState extends State<GlobalQuestionScreen> {
  final GlobalQuestionController _questionController = Get.put(GlobalQuestionController());
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
        body: Container(
          height: Get.height,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/aesthetics/wiw_question_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: [
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
      ),
    );
  }
}
