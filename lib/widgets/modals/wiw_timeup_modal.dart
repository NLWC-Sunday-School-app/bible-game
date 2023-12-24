import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/controllers/wiw_game_controller.dart';
import 'package:bible_game/controllers/wiw_game_question_controller.dart';
import 'package:bible_game/services/game_service.dart';
import 'package:bible_game/widgets/modals/wiw_not_enough_coins_modal.dart';
import 'package:bible_game/widgets/modals/wiw_try_again_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../screens/who_is_who/question_screen.dart';

class WiwTimeUpModal extends StatelessWidget {
  const WiwTimeUpModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WiwGameQuestionController wiwGameQuestionController = Get.put(WiwGameQuestionController());
    UserController userController = Get.put(UserController());
    WiwGameController wiwGameController = Get.put(WiwGameController());
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: Get.width >= 500
            ? 400.h
            : Get.height >= 800
                ? 450.h
                : 500.h,
        width: Get.width >= 500 ? 400.h : 500.h,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/aesthetics/time_up_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
              ),
              Column(
                  children: [
                    InkWell(
                      onTap: (){
                        if (userController.soundIsOff.isFalse) {
                          userController.playGameSound();
                        }
                        Get.back();
                        Get.dialog(const WiwTryAgainModal(),barrierDismissible: false);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 50.w),
                        child: Align(
                          child: Image.asset(
                            'assets/images/icons/close_red_white.png',
                            width: 50.w,
                          ),
                          alignment: Alignment.topRight,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      'Don’t lose your coins',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Mikado',
                          color: const Color(0xFFE81A31),
                          fontSize: 18.sp),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Container(
                      width: 200.w,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      decoration: BoxDecoration(
                          color: const Color(0xFFD4E9F6).withOpacity(0.5),
                          border: Border.all(
                              width: 2.w, color: const Color(0xFF106CDC)),
                          borderRadius: BorderRadius.all(Radius.circular(8.r))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/icons/timer.png',
                                width: 30.w,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                ':60',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: const Color(0xFF0A5CAF),
                                    fontFamily: 'Mikado',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 34.sp),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            'Buy 60s to finish level',
                            style: TextStyle(
                                color: const Color(0xFF306DB6),
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Mikado',
                                fontSize: 16.sp),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    InkWell(
                      onTap:()async{
                        if (userController.soundIsOff.isFalse) {
                          userController.playGameSound();
                        }
                        if(userController.myUser['coinWalletBalance'] >= wiwGameController.gameTimePurchasePrice){
                          wiwGameQuestionController.resetTimer();
                          Get.back();
                         await GameService.buyFromStore(userController.myUser['id'],  wiwGameController.gameTimePurchasePrice);
                         await userController.getUserData();
                        }else{
                          Get.back();
                          Get.dialog(const WiwNotEnoughCoinsModal(),barrierDismissible: false, transitionCurve: Curves.fastOutSlowIn,
                              transitionDuration: const Duration(milliseconds: 500));
                        }
                      },
                      child: Container(
                        width: 240.w,
                        padding: EdgeInsets.symmetric(
                            vertical: 15.h, horizontal: 15.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFF1E62D4), width: 3.w),
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          image: const DecorationImage(
                            image: AssetImage(
                                'assets/images/aesthetics/blue_btn_bg.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Keep Playing',
                              style: TextStyle(
                                  fontFamily: 'Mikado',
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            const Spacer(),
                            Image.asset(
                              'assets/images/icons/coins.png',
                              width: 18.w,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              wiwGameController.gameTimePurchasePrice.toString(),
                              style: TextStyle(
                                  fontFamily: 'Mikado',
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
