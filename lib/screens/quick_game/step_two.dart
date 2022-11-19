import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/quick_game_controller.dart';
import 'package:bible_game/widgets/game_button.dart';
import 'package:bible_game/widgets/quick_game/difficulty_level_meter.dart';
import 'package:bible_game/widgets/quick_game_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class QuickGameStepTwoScreen extends StatelessWidget {
  const QuickGameStepTwoScreen({Key? key}) : super(key: key);
  static String routeName = "/quick-game-step-two-screen";

//   @override
//   State<QuickGameStepTwoScreen> createState() => _QuickGameStepTwoScreenState();
// }
//
// class _QuickGameStepTwoScreenState extends State<QuickGameStepTwoScreen> {
//   bool _normalIsActive = true;
//   bool _intermediateIsActive = false;
//   bool _hardIsActive = false;
//
//
//   showDialogModal() {
//     Get.dialog(
//       const QuickGameModal(),
//       barrierDismissible: false,
//       barrierColor: const Color.fromRGBO(30, 30, 30, 0.9)
//     );
//   }
//
//   void selectNormalLevel() {
//     setState(() {
//       _normalIsActive = true;
//       _intermediateIsActive = false;
//       _hardIsActive = false;
//     });
//   }
//
//   void selectIntermediateLevel() {
//     setState(() {
//       _normalIsActive = false;
//       _intermediateIsActive = true;
//       _hardIsActive = false;
//     });
//   }
//
//   void selectHardLevel() {
//     setState(() {
//       _normalIsActive = false;
//       _intermediateIsActive = false;
//       _hardIsActive = true;
//     });
//   }


  @override
  Widget build(BuildContext context) {
    QuickGameController quickGameController = Get.put(QuickGameController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Obx(
            () => Stack(
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
                        const AutoSizeText(
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
                          'assets/images/quick_game_step_two.svg'),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 260.h),
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  children: [
                    const Align(
                      child: AutoSizeText(
                        'Choose a difficulty level.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(91, 73, 191, 1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: quickGameController.selectNormalLevel,
                          child: DifficultyLevelMeter(
                            difficultyImage:
                                'assets/images/quick_game/normal_speed.svg',
                            dotColor: const Color.fromRGBO(155, 201, 14, 1),
                            isActive: quickGameController.normalIsActive.value,
                            difficultyLevel: 'Normal',
                            checkerImage: 'assets/images/quick_game/green_circle_check.svg',
                          ),
                        ),
                        GestureDetector(
                          onTap: quickGameController.selectIntermediateLevel,
                          child: DifficultyLevelMeter(
                            difficultyImage:
                                'assets/images/quick_game/intermediate_speed.svg',
                            dotColor: const Color.fromRGBO(237, 195, 86, 1),
                            isActive: quickGameController.intermediateIsActive.value,
                            difficultyLevel: 'Intermediate',
                            checkerImage: 'assets/images/quick_game/orange_circle_check.svg',
                          ),
                        ),
                        GestureDetector(
                          onTap: quickGameController.selectHardLevel,
                          child: DifficultyLevelMeter(
                            difficultyImage: 'assets/images/quick_game/hard_speed.svg',
                            dotColor: const Color.fromRGBO(211, 98, 93, 1),
                            isActive: quickGameController.hardIsActive.value,
                            difficultyLevel: 'Hard',
                            checkerImage: 'assets/images/quick_game/wine_circle_check.svg',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 200.h,
                    ),
                    GestureDetector(
                      onTap: () => quickGameController.startGame(),
                      child: const GameButton(
                        buttonText: 'START GAME',
                        buttonActive: true,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
