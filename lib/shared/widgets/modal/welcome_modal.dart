import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';

import '../../features/settings/bloc/settings_bloc.dart';

void showWelcomeModal(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const WelcomeModal();
    },
  );
}

class WelcomeModal extends StatelessWidget {
  const WelcomeModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final soundManager = context.read<SettingsBloc>().soundManager;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 25.w),
      backgroundColor: Colors.transparent,
      insetAnimationDuration: Duration.zero,
      child: Container(
        width: screenWidth >= 500 ? 420.w : double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A3A6B),
              Color(0xFF0F2957),
              Color(0xFF0A1E42),
            ],
          ),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: AppColors.accentColor.withValues(alpha: 0.4),
            width: 2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0A1E42).withValues(alpha: 0.6),
              blurRadius: 30,
              spreadRadius: 5,
            ),
            BoxShadow(
              color: AppColors.accentColor.withValues(alpha: 0.15),
              blurRadius: 20,
              spreadRadius: -2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30.h),

            // Luke avatar with speech bubble
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Avatar with glow
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.accentColor.withValues(alpha: 0.6),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentColor.withValues(alpha: 0.25),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 40.r,
                    backgroundColor: const Color(0xFF1E4580),
                    backgroundImage: const AssetImage(
                      ProductImageRoutes.broLukeInfo,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                // Speech bubble
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                      bottomRight: Radius.circular(16.r),
                      bottomLeft: Radius.circular(4.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    "Hi, I'm Luke!",
                    style: TextStyle(
                      fontFamily: 'Gochi Hand',
                      fontSize: 16.sp,
                      color: const Color(0xFF1A3A6B),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Gold accent divider
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 45.w,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accentColor.withValues(alpha: 0.0),
                        AppColors.accentColor,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Icon(
                    Icons.auto_awesome,
                    size: 20.sp,
                    color: AppColors.accentColor,
                  ),
                ),
                Container(
                  width: 45.w,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accentColor,
                        AppColors.accentColor.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 18.h),

            // Title with stroke text
            StrokeText(
              text: 'Welcome to\nBible Game!',
              textStyle: TextStyle(
                color: Colors.white,
                fontFamily: 'Mikado',
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
                height: 1.3,
              ),
              strokeColor: const Color(0xFF0A1530),
              strokeWidth: 5,
            ),

            SizedBox(height: 18.h),

            // Body text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Text(
                'I hope as you play daily you can grow\n& test your bible knowledge with\nall your friends.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.6,
                ),
              ),
            ),

            SizedBox(height: 32.h),

            // Button
            BlueButton(
              onTap: () {
                soundManager.playClickSound();
                Navigator.pop(context);
              },
              buttonText: "Let's Go!",
              buttonIsLoading: false,
              width: 200.w,
            ),

            SizedBox(height: 28.h),
          ],
        ),
      ),
    ).animate()
        .scale(
          begin: const Offset(0.5, 0.5),
          end: const Offset(1, 1),
          duration: 400.ms,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: 300.ms);
  }
}
