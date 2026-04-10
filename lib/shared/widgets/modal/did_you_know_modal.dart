import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/constants/colors.dart';
import '../../features/settings/bloc/settings_bloc.dart';

void showDidYouKnowModal(BuildContext context, String fact) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DidYouKnowModal(fact: fact);
    },
  );
}

class DidYouKnowModal extends StatelessWidget {
  final String fact;

  const DidYouKnowModal({Key? key, required this.fact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final soundManager = context.read<SettingsBloc>().soundManager;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 25.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: width >= 500 ? 520.h : height >= 800 ? 420.h : 470.h,
        width: width >= 500 ? 500.w : 400.w,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ProductImageRoutes.welcomeModalBg),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 25.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B4513),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFD4A017), width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '✝',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFFFFD700),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Did You Know?',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Neuland',
                        color: const Color(0xFFFFD700),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '✝',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFFFFD700),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Church History',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: 'Neuland',
                  color: const Color(0xFF548BD5),
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SingleChildScrollView(
                    child: Text(
                      fact,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkBrownText,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  soundManager.playClickSound();
                  Navigator.pop(context);
                },
                child: Container(
                  width: 250.w,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF548BD5),
                    border: Border.all(color: const Color(0xFF548CD7)),
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                  ),
                  child: Text(
                    'Got It!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Neuland',
                      letterSpacing: 1,
                      color: const Color(0xFFFFFFFF),
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
