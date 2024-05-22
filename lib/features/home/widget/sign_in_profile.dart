import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/features/home/widget/modals/auth_modal.dart';
import 'package:the_bible_game/shared/constants/colors.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';

class SignInProfile extends StatelessWidget {
  const SignInProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
          showAuthModal(context);
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
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
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryDark),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0.w,
            top: 6.h,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryDarkBackground,
                shape: BoxShape.circle,
                border: Border.all(width: 3.w, color: AppColors.primaryColor),
              ),
              child: Image.asset(
               IconImageRoutes.personIcon,
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
