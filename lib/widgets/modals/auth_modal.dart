import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/widgets/modals/create_profile_modal.dart';
import 'package:bible_game/widgets/modals/login_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

import '../../controllers/user_controller.dart';

class AuthModal extends StatelessWidget {
  const AuthModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    UserController _userController = Get.put(UserController());
    return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: SizedBox(
            height: Get.width >= 500 ? 500.h : 450.h,
            width: Get.width >= 500? 500.h : 400.h,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/modal_layout_2.png'),
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
                      player.setAsset('assets/audios/click.mp3'),
                      player.play(),
                      Get.back()
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 15.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset('assets/images/icons/close.png', width: 40.w,)
                        ],
                      ),
                    ),
                  ),
                  AutoSizeText(
                   'YOUR PROFILE',
                    style: TextStyle(
                        fontFamily: 'Neuland',
                        fontSize: 24.sp,
                        color: const Color(0xFF4075BB)),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  AutoSizeText(
                    'Sign in to your profile to save \n& continue your game play.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  GestureDetector(
                    onTap: () => {
                      player.setAsset('assets/audios/click.mp3'),
                      player.play(),
                      Get.back(),
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () => {
                      player.setAsset('assets/audios/click.mp3'),
                      player.play(),
                      Get.back(),
                      Get.dialog(
                        const CreateProfileModal(),
                        barrierDismissible: false,
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
                        'CREATE PROFILE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Neuland',
                            letterSpacing: 1,
                            color: Colors.white,
                            fontSize: 14.sp),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(
                          () => IconButton(
                          iconSize: 50,
                          onPressed: () =>
                              _userController.toggleMusic(),
                          icon: _userController.musicIsOff.value
                              ? Image.asset(
                            'assets/images/icons/music_off.png',
                          )
                              : Image.asset(
                            'assets/images/icons/music_on.png',
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
