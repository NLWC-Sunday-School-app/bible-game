import 'package:bible_game/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../screens/four_scriptures_one_word/loading_screen.dart';

class FourScripturesWelcomeModal extends StatelessWidget {
  const FourScripturesWelcomeModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 25.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: Get.width >= 500 ? 500.h : Get.height >= 800 ? 400.h : 450.h,
        width: Get.width >= 500 ? 500.h : 400.h,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/four_scripture_welcome_layout.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 30.h,),
              Row(
                children: [
                  SizedBox(width: 30.h,),
                  SvgPicture.asset('assets/images/four_scripture_one_word/bro_luke_one.svg', width: 130.w,),
                ],
              ),
              Text(
                'The bible giants \nhang out here!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'Neuland',
                    color: Colors.white
                ),
              ),
              SizedBox(height: 20.h,),
              Text('Imagine questions with no options, you \ntype in one word that the bible verses \nhave in common! Are you up for it?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                ),
              ),
              SizedBox(height: 40.h,),
              GestureDetector(
                onTap: () => {
                  userController.soundIsOff.isFalse ? userController.playGameSound() : null,
                  Get.back(),
                  Get.to(() => const FourScriptureLoadingScreen())
                },
                child: Container(
                  width: 250.w,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFF548CD7)),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(40))),
                  child: Text(
                    'Sure, i am!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Neuland',
                        letterSpacing: 1,
                        color: const Color(0xFF548BD5),
                        fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
