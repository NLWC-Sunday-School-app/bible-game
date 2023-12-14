import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/widgets/modals/create_profile_modal.dart';
import 'package:bible_game/widgets/modals/login_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../controllers/user_controller.dart';

class AuthModal extends StatelessWidget {
  const AuthModal({Key? key, required this.title, required this.text})
      : super(key: key);
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    UserController _userController = Get.put(UserController());
    return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: SizedBox(
            height: Get.width >= 500 ? 500.h : 550.h,
            width: Get.width >= 500 ? 500.h : 400.h,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/aesthetics/modal_bg.png'),
                    fit: BoxFit.fill),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  GestureDetector(
                    onTap: () => {
                      _userController.soundIsOff.isFalse
                          ? _userController.playGameSound()
                          : null,
                      Get.back()
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 15.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/images/icons/close.png',
                            width: 35.w,
                          )
                        ],
                      ),
                    ),
                  ),
                  StrokeText(
                    text: title,
                    textStyle: TextStyle(
                      color: const Color(0xFF1768B9),
                      fontFamily: 'Mikado',
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                    ),
                    strokeColor: Colors.white,
                    strokeWidth: 5,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Mikado',
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  GestureDetector(
                    onTap: () => {
                      _userController.soundIsOff.isFalse
                          ? _userController.playGameSound()
                          : null,
                      Get.back(),
                      Get.dialog(
                        const LoginModal(),
                        barrierDismissible: false,
                          transitionCurve: Curves.easeIn,
                          transitionDuration: const Duration(milliseconds: 500)
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
                        'Log In',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Mikado',
                          letterSpacing: 1,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF4075BB),
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () => {
                      _userController.soundIsOff.isFalse
                          ? _userController.playGameSound()
                          : null,
                      Get.back(),
                      Get.dialog(
                        const CreateProfileModal(),
                        barrierDismissible: false,
                          transitionCurve: Curves.easeIn,
                          transitionDuration: const Duration(milliseconds: 500)
                      )
                    },
                    child: Container(
                      width: 200.w,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: const Color(0xFF548BD5),
                          border: Border.all(color: const Color(0xFF548CD7)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(40))),
                      child: Text(
                        'Create Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Mikado',
                          letterSpacing: 1,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(
                          () => IconButton(
                              iconSize: 50,
                              onPressed: () => {
                                    _userController.soundIsOff.isFalse
                                        ? _userController.playGameSound()
                                        : null,
                                    _userController.toggleGameSound()
                                  },
                              icon: _userController.soundIsOff.isTrue
                                  ? Image.asset(
                                      'assets/images/icons/volume_down.png',
                                    )
                                  : Image.asset(
                                      'assets/images/icons/volume_up.png',
                                    )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(
                          () => IconButton(
                              iconSize: 50,
                              onPressed: () => {
                                    _userController.soundIsOff.isFalse
                                        ? _userController.playGameSound()
                                        : null,
                                    _userController.toggleGameMusic(),
                                  },
                              icon: _userController.musicIsOff.isTrue
                                  ? Image.asset(
                                      'assets/images/icons/music_off.png',
                                    )
                                  : Image.asset(
                                      'assets/images/icons/music_on.png',
                                    )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(
                          () => IconButton(
                              iconSize: 50,
                              onPressed: () => {
                                    _userController.soundIsOff.isFalse
                                        ? _userController.playGameSound()
                                        : null,
                                    _userController.toggleNotification(),
                                  },
                              icon: _userController.notificationIsOff.isTrue
                                  ? Image.asset(
                                      'assets/images/icons/notification_off.png',
                                    )
                                  : Image.asset(
                                      'assets/images/icons/notification.png',
                                    )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
