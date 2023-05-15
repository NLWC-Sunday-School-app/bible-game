import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/quick_game_controller.dart';
import 'package:bible_game/screens/global/question_screen.dart';
import 'package:bible_game/widgets/game_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/global_game_controller.dart';

class GlobalGameModal extends StatelessWidget {
  const GlobalGameModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalGameController globalGameController = Get.put(GlobalGameController());
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: 480.h,
        child: Column(
          children: [
            Container(
              width: Get.width >= 500 ? 450.w : 300.w,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color:
                    const Color.fromRGBO(152, 152, 152, 1).withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 4,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child:  Obx(
                    () => AutoSizeText(
                  globalGameController.modalTitle.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const Text(''),
            Container(
              width: Get.width >= 500 ? 450.w : 300.w,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color:
                    const Color.fromRGBO(152, 152, 152, 1).withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 4,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 26.w, vertical: 12.h),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(118, 99, 229, 1),
                        borderRadius: BorderRadius.all(Radius.circular(12.r))),
                    child: AutoSizeText(
                      'Quick Tips',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(248, 225, 147, 1),
                        borderRadius: BorderRadius.all(Radius.circular(12.r))),
                    child: Row(
                      children: [
                        Container(
                          width: 23.w,
                          height: 23.h,
                          margin: EdgeInsets.only(right: 12.w),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              '1',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.sp),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        AutoSizeText(
                          'Get all the questions right to get \n bonus points',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(231, 226, 255, 1),
                        borderRadius: BorderRadius.all(Radius.circular(12.r))),
                    child: Row(
                      children: [
                        Container(
                          width: 23.w,
                          height: 23.h,
                          margin: EdgeInsets.only(right: 12.w),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              '2',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.sp),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        AutoSizeText(
                          'Missing any question reduces \nyour point ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(231, 242, 230, 1),
                        borderRadius: BorderRadius.all(Radius.circular(12.r))),
                    child: Row(
                      children: [
                        Container(
                          width: 23.h,
                          height: 23.h,
                          margin: EdgeInsets.only(right: 12.w),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              '3',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.sp),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        AutoSizeText(
                          'Speed is an extra advantage',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 11.w),
                            child: Image.asset(
                              'assets/images/heart.png',
                              width: 18.w,
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 38.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      if(globalGameController.gameIsReady.value){
                        Get.off(() => const GlobalQuestionScreen());
                      }

                    },
                    child: Obx(()=> GameButton(buttonText: 'PLAY NOW', buttonActive: globalGameController.gameIsReady.value,)),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
