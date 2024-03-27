import 'package:bible_game/widgets/modals/auth_modal.dart';
import 'package:bible_game/widgets/modals/quit_modal.dart';
import 'package:bible_game/widgets/quick_game/question_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/quick_game_question_controller.dart';



class QuickGameQuestionScreen extends StatefulWidget {
  const QuickGameQuestionScreen({Key? key}) : super(key: key);
  static String routeName = "/quick-game-question-screen";

  @override
  State<QuickGameQuestionScreen> createState() => _QuickGameQuestionScreenState();
}

class _QuickGameQuestionScreenState extends State<QuickGameQuestionScreen> {
  final QuickGamesQuestionController _questionController = Get.put(QuickGamesQuestionController());
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
