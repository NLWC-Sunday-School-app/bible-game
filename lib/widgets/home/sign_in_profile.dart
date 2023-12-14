import 'package:bible_game/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../modals/auth_modal.dart';
import '../modals/country_update_modal.dart';
import '../modals/profile_updated_success_modal.dart';
import '../modals/success_modal.dart';

class SignInProfile extends StatelessWidget {
  const SignInProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());
    return GestureDetector(
      onTap: () {
        if (userController.soundIsOff.isFalse) {
          userController.playGameSound();
        }
        Get.dialog(
          const AuthModal(
            title: 'Your Profile',
            text:
                'Sign in to your profile to save \n& continue your game play.',
          ),
          transitionCurve: Curves.easeIn,
          transitionDuration: const Duration(milliseconds: 500),
          barrierDismissible: false,
        );
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Container(
              width: 120.w,
              padding: EdgeInsets.only(
                  left: 30.w, right: 10.w, top: 20.h, bottom: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4.r),
                    topLeft:  Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                    bottomLeft: Radius.circular(10.r)),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0xFF366ABC),
                      offset: Offset(0, 5),
                      blurRadius: 0,
                      spreadRadius: -2)
                ],
              ),
              child: Container(
                padding: EdgeInsets.only(left: 20.w),
                child: Text(
                  'Sign in...',
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Mikado',
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF366ABC)),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0.w,
            top: 6.h,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F2957),
                shape: BoxShape.circle,
                border: Border.all(width: 2.w, color: const Color(0xFF4A91FF)),
              ),
              child: Image.asset(
                'assets/images/icons/person.png',
                width: 20.w,
              ),
              padding: EdgeInsets.all(18.w),
            ),
          ),
        ],
      ),
    );
  }
}
