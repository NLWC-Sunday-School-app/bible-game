
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../controllers/user_controller.dart';
import 'login_modal.dart';
class ResetPasswordSuccessModal extends StatelessWidget {
  const ResetPasswordSuccessModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserController _userController = Get.put(UserController());
    AuthController authController = Get.put(AuthController());
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: SizedBox(
          height:  Get.width >= 500 ? 450.h : 550.h,
          width:  Get.width >= 500 ? 600.h : 350,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/modal_layout_2.png'),
                  fit: BoxFit.fill
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50.h,
                ),
                GestureDetector(
                  onTap: () => {
                    _userController.soundIsOff.isFalse ? _userController.playGameSound() : null,
                    Get.back()
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/images/icons/close.png',
                          width: 40.w,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Image.asset('assets/images/icons/success_mark.png', width: 80,),
                const SizedBox(height: 50,),
                AutoSizeText(
                  'New password set \nsuccessfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Neuland',
                      fontSize: 18.sp,
                      color: const Color(0xFF4075BB)
                  ),),
                 const SizedBox(height: 50,),
                Obx(
                  () => authController.isLoggedIn.isFalse ? GestureDetector(
                    onTap: () => {
                      Get.back(),
                      _userController.soundIsOff.isFalse ? _userController.playGameSound() : null,
                      Get.dialog(
                        const LoginModal(),
                        barrierDismissible: false,
                      )
                    },
                    child: Container(
                      width: 200.w,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: const Color(0xFFE8F8FF),
                          border: Border.all(color: const Color(0xFF548CD7)),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(40))),
                      child: Text(
                        'LOG IN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Neuland',
                            letterSpacing: 1,
                            color: const Color(0xFF4075BB),
                            fontSize: 14.sp),
                      ),
                    ),
                  ): const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
