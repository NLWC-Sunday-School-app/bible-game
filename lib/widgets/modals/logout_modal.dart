import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';

class LogoutModal extends StatelessWidget {
  const LogoutModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    AuthController authController = Get.put(AuthController());
    UserController _userController = Get.put(UserController());
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: Get.width >= 500 ? 500.h : Get.height >= 800 ? 450.h : 500.h,
        width: Get.width >= 500 ? 500.h : 450.h,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/modal_layout_2.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 50.h,
              ),
              GestureDetector(
                onTap: () => {
                  if(_userController.soundIsOff.isFalse){
                    player.setAsset('assets/audios/click.mp3'),
                    player.play(),
                  },
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
              SizedBox(height: 20.h,),
              Text(
                'are you sure you \nwant to Log out',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Neuland',
                    fontSize: 24.sp,
                    color: const Color(0xFF4075BB)),
              ),
             SizedBox(height: 10.h,),
             Text('You will lose unsaved progress.',
               style: TextStyle(
                 fontWeight: FontWeight.w500,
                 fontSize: 14.sp
               ),
             ),
              SizedBox(
                height: 40.h,
              ),
              GestureDetector(
                onTap: () => {
                  if(_userController.soundIsOff.isFalse){
                    player.setAsset('assets/audios/click.mp3'),
                    player.play(),
                  },
                 Get.back()
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
                    "NO I DONT",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Neuland',
                        letterSpacing: 1,
                        color: const Color(0xFF323B63),
                        fontSize: 14.sp),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () => {
                  if(_userController.soundIsOff.isFalse){
                    player.setAsset('assets/audios/click.mp3'),
                    player.play(),
                  },
                 authController.logoutUser()
                },
                child: Obx(
                  () => Container(
                    width: 200.w,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        color: const Color(0xFF548CD7),
                        border: Border.all(color: const Color(0xFF548CD7)),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(40))),

                    child: authController.isLoadingLogout.isTrue
                        ? const Center(
                      child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFFFFFFF),
                          )),
                    )
                    :Text(
                      'yes, log out',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Neuland',
                          letterSpacing: 1,
                          color: Colors.white,
                          fontSize: 14.sp),
                    ),
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
