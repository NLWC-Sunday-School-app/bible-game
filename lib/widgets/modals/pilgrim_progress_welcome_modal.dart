import 'package:bible_game/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class PilgrimProgressWelcomeModal extends StatelessWidget {
  const PilgrimProgressWelcomeModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 25.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: Get.width >= 500
            ? 500.h
            : Get.height >= 800
                ? 400.h
                : 450.h,
        width: Get.width >= 500 ? 500.h : 400.h,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/pilgrim_progress_welcome_layout.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
              ),
              SvgPicture.asset('assets/images/icons/luke_head.svg'),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'dear sojourner,\nwelcome!',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: 'Neuland',
                  color: const Color(0xFF548BD5),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'This is pilgrim progress, a journey \nthrough the truths in scriptures; Enjoy!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 40.h,),
              GestureDetector(
                onTap: () => {
                  userController.soundIsOff.isFalse ? userController.playGameSound() : null,
                  Get.back(),
                },
                child: Container(
                  width: 250.w,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: const Color(0xFF548BD5),
                      border: Border.all(color: const Color(0xFF548CD7)),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(40))),
                  child: Text(
                    'Sure will!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Neuland',
                        letterSpacing: 1,
                        color: const Color(0xFFFFFFFF),
                        fontSize: 14.sp),
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
