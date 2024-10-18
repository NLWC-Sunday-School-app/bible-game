import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';

import '../../../../shared/features/settings/bloc/settings_bloc.dart';

void showGlobalChallengeTipsModal(BuildContext context) {
  final soundManager = context.read<SettingsBloc>().soundManager;
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
          backgroundColor: Colors.transparent,
          insetAnimationCurve: Curves.bounceInOut,
          insetAnimationDuration: const Duration(milliseconds: 500),
          child: SizedBox(
            height: 400.h,
            width: 400.w,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(ProductImageRoutes.quickTipsBg))),
              child: Column(
                children: [
                  SizedBox(
                    height: 120.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                          color: Color(0xFFF8E193),
                          border: Border.all(color: Color(0xFFBE9F37)),
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10.w, top: 10.h, bottom: 10.h),
                            child: Text(
                              'Bonus point for when you \nget all questions right!',
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5),
                            ),
                          ),
                          Spacer(),
                          Image.asset(
                            IconImageRoutes.coinIcon,
                            width: 56.w,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                          color: Color(0xFE7F2E6),
                          border: Border.all(color: Color(0xFF7FB57A)),
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10.w, top: 10.h, bottom: 10.h),
                            child: Text(
                              'Speed is an extra advantage',
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5),
                            ),
                          ),
                          Spacer(),
                          Image.asset(
                            ProductImageRoutes.rocket,
                            width: 56.w,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  BlueButton(
                    buttonText: 'Play Now',
                    buttonIsLoading: false,
                    onTap: () {
                       soundManager.playClickSound();
                      Navigator.pushNamed(
                          context, AppRoutes.globalChallengeQuestionScreen);
                    },
                    width: 280.w,
                  )
                ],
              ),
            ),
          ),
        );
      });
}
