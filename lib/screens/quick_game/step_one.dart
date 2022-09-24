import 'package:bible_game/screens/quick_game/step_two.dart';
import 'package:bible_game/widgets/TopicPill.dart';
import 'package:bible_game/widgets/game_button.dart';
import 'package:bible_game/widgets/quick_game_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class QuickGameStepOneScreen extends StatelessWidget {
  const QuickGameStepOneScreen({Key? key}) : super(key: key);
  static String routeName = "/quick-game-step-one-screen";

  showDialogModal() {
    Get.dialog(
      const QuickGameModal(),
    );
  }

  void goToQuickGameStepTwoScreen(BuildContext context) {
    Navigator.of(context).pushNamed(QuickGameStepTwoScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 80.h),
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
              child: Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  'assets/images/cloud.png',
                  width: 200.w,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 75.h),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => {Navigator.pop(context)},
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 15.w,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 50.h,
                      ),
                      const Text(
                        'Start Quick Game in \n2 easy steps',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.h),
                    child: SvgPicture.asset(
                        'assets/images/quick_game_step_one.svg'),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: MediaQuery. of(context).size.height * 0.32),
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Column(
                children: [
                  Text(
                    'Select 1 or more topic(s) of interest.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color.fromRGBO(91, 73, 191, 1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 15.0,
                    children: const [
                      TopicPill(topic: 'Faith'),
                      TopicPill(
                        topic: 'Brotherly Love',
                      ),
                      TopicPill(
                        topic: 'Hope',
                      ),
                      TopicPill(
                        topic: 'Love',
                      ),
                      TopicPill(
                        topic: 'Holiness',
                      ),
                      TopicPill(
                        topic: 'Long suffering',
                      ),
                      TopicPill(
                        topic: 'Humility',
                      ),
                      TopicPill(
                        topic: 'Patience',
                      ),
                      TopicPill(
                        topic: 'Healing',
                      ),
                      TopicPill(
                        topic: 'Mercy',
                      ),
                      TopicPill(
                        topic: 'Gospel',
                      ),
                      TopicPill(
                        topic: 'Peace',
                      ),
                      TopicPill(
                        topic: 'Goodness',
                      ),
                      TopicPill(
                        topic: 'Faithfulness',
                      ),
                      TopicPill(
                        topic: 'Gentleness',
                      ),
                      TopicPill(
                        topic: 'Self-Control',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  GestureDetector(
                    onTap: () => goToQuickGameStepTwoScreen(context),
                    child: const GameButton(
                      buttonText: 'CONTINUE',
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
