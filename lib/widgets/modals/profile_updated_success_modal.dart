import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../controllers/user_controller.dart';
class ProfileUpdatedSuccessModal extends StatelessWidget {
  const ProfileUpdatedSuccessModal ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserController _userController = Get.put(UserController());
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: SizedBox(
          height:  Get.width >= 500 ? 450.h : 450.h,
          width:  Get.width >= 500 ? 600.h : 350,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/aesthetics/modal_success_bg.png'),
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
                          width: 35.w,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h,),
                Image.asset('assets/images/icons/success_mark.png', width: 80.w,),
                SizedBox(height: 30.h,),
                StrokeText(
                  text: 'Profile Updated!',
                  textStyle: TextStyle(
                    color: const Color(0xFF1768B9),
                    fontFamily: 'Mikado',
                    fontSize: 23.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  strokeColor: Colors.white,
                  strokeWidth: 5,
                ),
                SizedBox(height: 15.h,),
                Text('Enjoy the Bible game!', style: TextStyle(
                    fontFamily: 'Mikado',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500
                ),)

              ],
            ),
          ),
        ),
      ),
    );
  }
}
