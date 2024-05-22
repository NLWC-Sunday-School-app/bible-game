import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/features/pilgrim_progress/widget/modal/quick_tips_modal.dart';
import 'package:the_bible_game/features/pilgrim_progress/widget/pilgrim_progress_menu.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/constants/image_routes.dart';
import '../../../shared/widgets/screen_app_bar.dart';
import 'package:stroke_text/stroke_text.dart';

class PilgrimProgressHomeScreen extends StatelessWidget {
  const PilgrimProgressHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFF014AA0),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ProductImageRoutes.patternTwoBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            ScreenAppBar(
              widgets: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        IconImageRoutes.arrowCircleBack,
                        width: 40.w,
                      ),
                    ),
                    Spacer(),
                    StrokeText(
                      text: 'Pilgrim Progress',
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w900,
                      ),
                      strokeColor: AppColors.titleDropShadowColor,
                      strokeWidth: 6,
                    ),
                    Spacer(),
                    InkWell(
                      child: Image.asset(
                        IconImageRoutes.infoCircle,
                        width: 40.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                StrokeText(
                  text: 'Grow your knowledge as you progress',
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1),
                  strokeColor: AppColors.titleDropShadowColor,
                  strokeWidth: 4,
                ),
                SizedBox(
                  height: 15.h,
                )
              ],
            ),
            SizedBox(
              height: 8.h,
            ),
            SizedBox(
              height: screenHeight - (150.h + 8.h),
              child: ListView(
                children: [
                  PilgrimProgressLevelMenu(
                    menuImage: ProductImageRoutes.babe,
                    menuNumber: '',
                    menuLabel: 'BABE',
                    isLocked: false,
                    menuProgressValue: 0.5,
                    totalPointsGained: 4000,
                    boxShadowColor: 0xFFE4E0DD,
                    totalPointsAvailable: 5000,
                    onTap: () {
                      showPilgrimProgressTipsModal(context);
                    },
                    textSpan: RichText(
                        text: TextSpan(
                            text: 'Begin your bible adventure! Get up \nto',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF22210D),
                              height: 1.5,
                            ),
                            children: <TextSpan>[
                          TextSpan(
                              text: ' 2000 points',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          const TextSpan(
                            text: ' to finish this level.',
                          ),
                        ])),
                  ),
                  PilgrimProgressLevelMenu(
                    menuImage: ProductImageRoutes.babe,
                    menuNumber: '',
                    menuLabel: 'CHILD',
                    isLocked: true,
                    menuProgressValue: 0,
                    totalPointsGained: 4000,
                    boxShadowColor: 0xFFE4E0DD,
                    totalPointsAvailable: 5000,
                    onTap: () {},
                    textSpan: RichText(
                        text: TextSpan(
                            text: 'Begin your bible adventure! Get up \nto',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF22210D),
                              height: 1.5,
                            ),
                            children: <TextSpan>[
                          TextSpan(
                              text: ' 2000 points',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          const TextSpan(
                            text: ' to finish this level.',
                          ),
                        ])),
                  ),
                  PilgrimProgressLevelMenu(
                    menuImage: ProductImageRoutes.babe,
                    menuNumber: '',
                    menuLabel: 'YOUNG BELIEVER',
                    isLocked: true,
                    menuProgressValue: 0,
                    totalPointsGained: 4000,
                    boxShadowColor: 0xFFE4E0DD,
                    totalPointsAvailable: 5000,
                    onTap: () {},
                    textSpan: RichText(
                        text: TextSpan(
                            text: 'Begin your bible adventure! Get up \nto',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF22210D),
                              height: 1.5,
                            ),
                            children: <TextSpan>[
                          TextSpan(
                              text: ' 2000 points',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          const TextSpan(
                            text: ' to finish this level.',
                          ),
                        ])),
                  ),
                  PilgrimProgressLevelMenu(
                    menuImage: ProductImageRoutes.babe,
                    menuNumber: '',
                    menuLabel: 'CHARITY',
                    isLocked: true,
                    menuProgressValue: 0,
                    totalPointsGained: 4000,
                    boxShadowColor: 0xFFE4E0DD,
                    totalPointsAvailable: 5000,
                    onTap: () {},
                    textSpan: RichText(
                        text: TextSpan(
                            text: 'Begin your bible adventure! Get up \nto',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF22210D),
                              height: 1.5,
                            ),
                            children: <TextSpan>[
                          TextSpan(
                              text: ' 2000 points',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          const TextSpan(
                            text: ' to finish this level.',
                          ),
                        ])),
                  ),
                  PilgrimProgressLevelMenu(
                    menuImage: ProductImageRoutes.babe,
                    menuNumber: '',
                    menuLabel: 'FATHER',
                    isLocked: true,
                    menuProgressValue: 0,
                    totalPointsGained: 4000,
                    boxShadowColor: 0xFFE4E0DD,
                    totalPointsAvailable: 5000,
                    onTap: () {},
                    textSpan: RichText(
                        text: TextSpan(
                            text: 'Begin your bible adventure! Get up \nto',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF22210D),
                              height: 1.5,
                            ),
                            children: <TextSpan>[
                          TextSpan(
                              text: ' 2000 points',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          const TextSpan(
                            text: ' to finish this level.',
                          ),
                        ])),
                  ),
                  PilgrimProgressLevelMenu(
                    menuImage: ProductImageRoutes.babe,
                    menuNumber: '',
                    menuLabel: 'ELDER',
                    isLocked: true,
                    menuProgressValue: 0,
                    totalPointsGained: 4000,
                    boxShadowColor: 0xFFE4E0DD,
                    totalPointsAvailable: 5000,
                    onTap: () {},
                    textSpan: RichText(
                        text: TextSpan(
                            text: 'Begin your bible adventure! Get up \nto',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF22210D),
                              height: 1.5,
                            ),
                            children: <TextSpan>[
                          TextSpan(
                              text: ' 2000 points',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          const TextSpan(
                            text: ' to finish this level.',
                          ),
                        ])),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
