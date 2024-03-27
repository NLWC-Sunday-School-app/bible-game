import 'package:bible_game/controllers/pilgrim_progress_question_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/modals/quit_modal.dart';
import '../../widgets/pilgrim_progress/pligrim_progress_question_container.dart';

class PilgrimProgressQuestionScreen extends StatefulWidget {
  const PilgrimProgressQuestionScreen({Key? key}) : super(key: key);
  static String routeName = "/pilgrim-progress-question-screen";

  @override
  State<PilgrimProgressQuestionScreen> createState() => _PilgrimProgressQuestionScreenState();
}

class _PilgrimProgressQuestionScreenState extends State<PilgrimProgressQuestionScreen> {
  PilgrimProgressQuestionController pilgrimProgressQuestionController = Get.put(PilgrimProgressQuestionController());
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
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pilgrimProgressQuestionController.pageController,
                  onPageChanged:
                      pilgrimProgressQuestionController.updateTheQuestionNumber,
                  itemCount: pilgrimProgressQuestionController.questions.length,
                  itemBuilder: (context, index) => PilgrimProgressQuestionContainer(
                    question: pilgrimProgressQuestionController.questions[index],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
