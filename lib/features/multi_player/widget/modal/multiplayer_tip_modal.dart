import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/constants/app_routes.dart';
import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../../shared/widgets/blue_button.dart';

void showMultiplayerTipsModal(BuildContext context, {required String gameMode}) {
  final soundManager = context.read<SettingsBloc>().soundManager;
  showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        Timer(Duration(seconds: 3), () {
              Navigator.pushNamed(
                  context, AppRoutes.lightningModeQuestionScreen
              );
        });
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          insetAnimationCurve: Curves.bounceInOut,
          insetAnimationDuration: const Duration(milliseconds: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50.h,),
              Text(
                  'Quick Tips',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white
                  )
              ),
              SizedBox(height: 8.h,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 34),
                margin: EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Color(0xFF999999),
                    width: 1
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      const Color(0xFFD1D1D1),
                      const Color(0xFFFF8F8F),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10.w),
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
                              'First Place gets the most points\n- Be fast and accurate!',
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5),
                            ),
                          ),
                          SizedBox(width: 11.w,),
                          Image.asset(
                            IconImageRoutes.quickTipsIconOne,
                            height: 65.h,
                            width: 65.w,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.w),
                      decoration: BoxDecoration(
                          color: Color(0xFFE7F2E6),
                          border: Border.all(color: Color(0xFF7FB57A)),
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10.w, top: 10.h, bottom: 10.h),
                            child: Text(
                              'Speed is crucial - you\'re racing\nother players',
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5),
                            ),
                          ),
                          SizedBox(width: 23.w,),
                          Image.asset(
                            ProductImageRoutes.rocket,
                            width: 65.w,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.w),
                      decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          border: Border.all(color: Color(0xFF7FB57A)),
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10.w, top: 10.h, bottom: 10.h),
                            child: Text(
                              'Questions vanish after 7seconds\n- Answer quickyly!',
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5),
                            ),
                          ),
                          SizedBox(width: 11.w,),
                          Image.asset(
                            IconImageRoutes.quickTipsIconTwo,
                            width: 65.w,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}
