import 'package:bible_game/widgets/who_is_who/score_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/wiw_game_question_controller.dart';
import '../../widgets/modals/wiw_quit_modal.dart';
import '../../widgets/who_is_who/wiw_question_container.dart';

class WhoIsWhoQuestionScreen extends StatefulWidget {
  const WhoIsWhoQuestionScreen({Key? key}) : super(key: key);

  @override
  State<WhoIsWhoQuestionScreen> createState() => _WhoIsWhoQuestionScreenState();
}

class _WhoIsWhoQuestionScreenState extends State<WhoIsWhoQuestionScreen> {
  WiwGameQuestionController wiwGameQuestionController = Get.put(WiwGameQuestionController());
  Future<bool?> showWarning(BuildContext context) async => Get.dialog(const WiwQuitModal(), barrierDismissible: false,);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        final displayDialog = await showWarning(context);
        return displayDialog ?? false;
      },
      child: Scaffold(
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
              const ScoreCard(),
              SizedBox(
                height: 20.h,
              ),
              Expanded(
                child: PageView.builder(
                  controller: wiwGameQuestionController.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: wiwGameQuestionController.questions.length,
                  itemBuilder: (context, index) => WiwQuestionContainer(
                    question: wiwGameQuestionController.questions[index],
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
