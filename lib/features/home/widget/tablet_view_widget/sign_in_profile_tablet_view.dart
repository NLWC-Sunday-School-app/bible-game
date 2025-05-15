import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/constants/image_routes.dart';

import '../../../../shared/constants/app_routes.dart';
import '../../../../shared/features/settings/bloc/settings_bloc.dart';

class SignInProfileTabletView extends StatelessWidget {
  const SignInProfileTabletView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return InkWell(
      onTap: () {
        soundManager.playClickSound();
        // showAuthModal(context);
        Navigator.pushNamed(context, AppRoutes.profileScreen);
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Container(
              width: 182.w,
              height: 56.h,
              padding: EdgeInsets.only(
                  left: 50.w,
                  // right: 10.w,
                  // top: 12.h,
                  // bottom: 12.h
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4.r),
                    topLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                    bottomLeft: Radius.circular(10.r)),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0xFF366ABC),
                      offset: Offset(5, 8),
                      blurRadius: 0,
                      spreadRadius: -2
                  )
                ],
              ),
              child: Center(
                child: Text(
                  'Sign in...',
                  style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0.w,
            top: 6.h,
            child: Container(
              height: 72.h,
              width: 72.w,
              decoration: BoxDecoration(
                color: AppColors.primaryDarkBackground,
                shape: BoxShape.circle,
                border: Border.all(
                    width: 3.w, color: AppColors.primaryColor
                ),
              ),
              child: Center(
                child: Image.asset(
                  IconImageRoutes.personIcon,
                  width: 31.w,
                  height: 43.h,
                ),
              ),
              // padding: EdgeInsets.all(18.w),
            ),
          ),
        ],
      ),
    );
  }
}
