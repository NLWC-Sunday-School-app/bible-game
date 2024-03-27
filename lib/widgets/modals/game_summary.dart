import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/widgets/button/modal_blue_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/tabs_controller.dart';


class GameSummaryModal extends StatelessWidget {
  const GameSummaryModal({
    Key? key,
    required this.pointsGained,
    required this.questionsGotten,
    required this.onTap,
    required this.bonusPointsGained,
    required this.averageTimeSpent,
    required this.isQuickGame,
  }) : super(key: key);

  final String pointsGained;
  final String questionsGotten;
  final String bonusPointsGained;
  final String averageTimeSpent;
  final VoidCallback onTap;
  final bool isQuickGame;

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());
    final TabsController tabsController = Get.put(TabsController());
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 5.w),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: SizedBox(
            height: Get.width >= 500
                ? 700.h
                : Get.height >= 800
                    ? 600.h
                    : 650.h,
            width: Get.width >= 500 ? 500.h : 500.h,
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: Get.width >= 500
                          ? 550.h
                          : Get.height >= 800
                              ? 500.h
                              : 480.h,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/aesthetics/success_modal_bg.png',
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 80.h,
                            ),
                            Image.asset(
                              'assets/images/aesthetics/three_stars.png',
                              width: 180.w,
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2.w,
                                      color: const Color(0xFF306DB6)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.r))),
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              width: 180.w,
                              child: Column(
                                children: [
                                  Text(
                                    'You earned',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: const Color(0xFF306DB6),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/icons/coins.png',
                                        width: 30.w,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        pointsGained,
                                        style: TextStyle(
                                          fontFamily: 'Mikado',
                                          fontSize: 40.sp,
                                          fontWeight: FontWeight.w900,
                                          color: const Color(0xFF306DB6),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding:
                              EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2.w, color: const Color(0xFF0B5DB0)),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12.r),
                                      bottomRight: Radius.circular(12.r))),
                              width: 150.w,
                              child: Text(
                                'Bonus point: +$bonusPointsGained',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF0B5DB0),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            IntrinsicHeight(
                              child:
                              SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/icons/mark.png',
                                      width: 24.w,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          questionsGotten,
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                fontFamily: 'Mikado',
                                                color: const Color(0xFF0155AF),
                                                fontWeight: FontWeight.w700),
                                          ),

                                        Text(
                                          'questions',
                                          style: TextStyle(
                                              fontFamily: 'Mikado',
                                              fontSize: 13.sp,
                                              color: const Color(0xFF0155AF)),
                                        )
                                      ],
                                    ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        VerticalDivider(
                                          color: const Color(0xFF0B5DB0),
                                          thickness: 2.w,
                                        ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Image.asset(
                                      'assets/images/icons/timer.png',
                                      width: 24.w,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          ': ${averageTimeSpent}s',
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              fontFamily: 'Mikado',
                                              color: const Color(0xFF0155AF),
                                              fontWeight: FontWeight.w700),
                                        ),

                                        Text(
                                          'per question',
                                          style: TextStyle(
                                              fontFamily: 'Mikado',
                                              fontSize: 13.sp,
                                              color: const Color(0xFF0155AF)),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Column(
                              //       children: [
                              //         Text(
                              //           'You answered:',
                              //           style: TextStyle(
                              //             fontSize: 12.sp,
                              //             color: const Color(0xFF323B63),
                              //             fontWeight: FontWeight.w600,
                              //           ),
                              //         ),
                              //         Text(
                              //           questionsGotten,
                              //           style: TextStyle(
                              //             height: 1.5,
                              //             fontSize: 20.sp,
                              //             fontFamily: 'Neuland',
                              //             fontWeight: FontWeight.w500,
                              //             color: const Color(0xFF323B63),
                              //           ),
                              //         ),
                              //         Text(
                              //           'questions',
                              //           style: TextStyle(
                              //             height: 1.5,
                              //             fontSize: 12.sp,
                              //             color: const Color(0xFF323B63),
                              //             fontWeight: FontWeight.w600,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //     SizedBox(
                              //       width: 10.w,
                              //     ),
                              //     const VerticalDivider(
                              //       color: Color(0xFFDAEDF2),
                              //       thickness: 1.5,
                              //     ),
                              //     SizedBox(
                              //       width: 10.w,
                              //     ),
                              //     Column(
                              //       children: [
                              //         Text(
                              //           'Avg. time spent',
                              //           style: TextStyle(
                              //             fontSize: 12.sp,
                              //             color: const Color(0xFF323B63),
                              //             fontWeight: FontWeight.w600,
                              //           ),
                              //         ),
                              //         Text(
                              //           ': $averageTimeSpent sec',
                              //           style: TextStyle(
                              //             fontSize: 20.sp,
                              //             height: 1.5,
                              //             fontFamily: 'Neuland',
                              //             fontWeight: FontWeight.w500,
                              //             color: const Color(0xFF323B63),
                              //           ),
                              //         ),
                              //         Text(
                              //           'per question',
                              //           style: TextStyle(
                              //             height: 1.5,
                              //             fontSize: 12.sp,
                              //             color: const Color(0xFF323B63),
                              //             fontWeight: FontWeight.w600,
                              //           ),
                              //         ),
                              //       ],
                              //     )
                              //   ],
                              // ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            ModalBlueButton(
                              buttonText: 'Continue',
                              buttonIsLoading: false,
                              onTap: onTap
                            )
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: Get.width >= 500
                    //       ? 20.h
                    //       : Get.height >= 800
                    //           ? 15.h
                    //           : 22.h,
                    // ),
                    // isQuickGame ? const SizedBox() : const LeaderBoardModal()
                    // const LeaderBoardModal()
                  ],
                ),
                // Container(
                //   margin: EdgeInsets.only(
                //       top: Get.width >= 500
                //           ? 450.h
                //           : Get.height >= 800
                //               ? 380.h
                //               : 400.h),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       GameSummaryActionButton(
                //         icon: const Icon(
                //           Icons.refresh_outlined,
                //           color: Colors.white,
                //         ),
                //         size: 15.w,
                //         shapeColor: const Color(0XFFFDC049),
                //         onTap: onTap,
                //       ),
                //       GameSummaryActionButton(
                //         icon: Icon(
                //           Icons.home,
                //           color: Colors.white,
                //           size: 30.w,
                //         ),
                //         size: 20.w,
                //         shapeColor: const Color(0xFF4075BB),
                //         onTap: () async => {
                //           userController.soundIsOff.isFalse
                //               ? userController.playGameSound()
                //               : null,
                //           await userController.getUserData(),
                //           Get.delete<PilgrimProgressQuestionController>(),
                //           Get.delete<QuickGamesQuestionController>(),
                //           Get.delete<GlobalQuestionController>(),
                //           Get.delete<LeaderboardController>(),
                //           GetStorage().write('isTempLoggedIn', false),
                //           Get.offAll(() => const TabMainScreen(),
                //               transition: Transition.fadeIn)
                //         },
                //       ),
                //       GameSummaryActionButton(
                //         icon: const Icon(
                //           MyFlutterApp.trophy,
                //           color: Colors.white,
                //         ),
                //         size: 15.w,
                //         shapeColor: const Color(0XFFFDC049),
                //         onTap: () async => {
                //           userController.soundIsOff.isFalse
                //               ? userController.playGameSound()
                //               : null,
                //           await userController.getUserData(),
                //           GetStorage().write('isTempLoggedIn', false),
                //           if (isQuickGame)
                //             {
                //               tabsController.selectPage(2),
                //               Get.offAll(() => const TabMainScreen(),
                //                   transition: Transition.fadeIn)
                //             }
                //           else
                //             {
                //               Future.delayed(Duration.zero, () {
                //                 Get.bottomSheet(
                //                     const PilgrimProgressLeaderboardModal(),
                //                     isScrollControlled: true);
                //               })
                //             }
                //         },
                //       ),
                //     ],
                //   ),
                // )
              ],
            )),
      ),
    );
  }
}
