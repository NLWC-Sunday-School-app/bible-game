import 'package:bible_game/controllers/question_controller.dart';
import 'package:bible_game/widgets/question_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ElderQuestionScreen extends StatelessWidget {
  const ElderQuestionScreen({Key? key}) : super(key: key);
  static String routeName = "/elder-question-screen";

  @override
  Widget build(BuildContext context) {
    QuestionController _questionController = Get.put(QuestionController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 200.h),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(110, 91, 220, 1),
                  Color.fromRGBO(60, 46, 144, 1),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/question_screen_cloud.png',
                  width: 350.w,
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 55.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => {Navigator.pop(context)},
                      child: Padding(
                        padding: EdgeInsets.only(left: 22.0.w),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 15.w,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 95.0.w),
                      child: Obx(
                            () => Text(
                          "Question ${_questionController.questionNumber.value} of ${_questionController.questions.length}",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
            ],
          ),
        ],
      ),
    );
  }
}
