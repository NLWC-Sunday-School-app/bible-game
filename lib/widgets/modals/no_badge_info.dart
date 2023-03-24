import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';

class NoBadgeInfo extends StatelessWidget {
  const NoBadgeInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserController _userController = Get.put(UserController());
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: SizedBox(
          height: Get.width >= 500 ? 450.h : 450.h,
          width: Get.width >= 500 ? 600.h : 450,
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
                Image.asset(
                  'assets/images/badges/default_badge.png',
                  width: 50.w,
                ),
                SizedBox(height: 20.h,),
                Text(
                  'YOU HAVE NO\n BADGE YET.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Neuland',
                      fontSize: 20.sp,
                      color: const Color(0xFF4075BB)),
                ),
                SizedBox(height: 20.h,),
                Text(
                  'Like a star, you can shine here! \nPlay pilgrim progress to get different\n badges at different levels.',
                 textAlign: TextAlign.center,
                  style: TextStyle(
                   fontSize: 14.sp,
                   height: 1.5,
                   fontWeight: FontWeight.w500
                 ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
