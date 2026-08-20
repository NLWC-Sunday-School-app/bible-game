import 'package:bible_game/shared/features/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/home/widget/modals/create_profile_modal.dart';
import 'package:bible_game/features/home/widget/modals/google_sign_in_button.dart';
import 'package:bible_game/features/home/widget/modals/login_modal.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';

import '../../../../shared/features/settings/bloc/settings_bloc.dart';

void showAuthModal(BuildContext context) {
  final soundManager = context.read<SettingsBloc>().soundManager;
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.75),
    builder: (BuildContext context) {
      final tr = AppLocalization.tr(context);
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              width: 3,
              color: const Color(0xFF2A5A9A),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1565C0).withOpacity(0.3),
                blurRadius: 24,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Header ──
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF1565C0),
                        Color(0xFF0D47A1),
                      ],
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // Stars
                      Positioned(
                        top: 14.h,
                        left: 22.w,
                        child: Image.asset(
                          IconImageRoutes.star,
                          width: 16.w,
                          opacity: const AlwaysStoppedAnimation(0.35),
                        ),
                      ),
                      Positioned(
                        top: 35.h,
                        right: 28.w,
                        child: Image.asset(
                          IconImageRoutes.star,
                          width: 12.w,
                          opacity: const AlwaysStoppedAnimation(0.3),
                        ),
                      ),
                      Positioned(
                        bottom: 25.h,
                        left: 50.w,
                        child: Image.asset(
                          IconImageRoutes.star,
                          width: 10.w,
                          opacity: const AlwaysStoppedAnimation(0.2),
                        ),
                      ),
                      // Close button
                      Positioned(
                        top: 12.h,
                        right: 12.w,
                        child: GestureDetector(
                          onTap: () {
                            soundManager.playClickSound();
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            IconImageRoutes.closeModal,
                            width: 32.w,
                          ),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: EdgeInsets.only(top: 28.h, bottom: 40.h),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(14.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 2,
                                ),
                              ),
                              child: Image.asset(
                                ProductImageRoutes.theBibleGame,
                                width: 50.w,
                                height: 50.w,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Image.asset(
                              ProductImageRoutes.threeStars,
                              width: 80.w,
                              opacity: const AlwaysStoppedAnimation(0.7),
                            ),
                            SizedBox(height: 8.h),
                            StrokeText(
                              text: tr.t('auth_your_profile'),
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Mikado',
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w900,
                              ),
                              strokeColor: const Color(0xFF0A3060),
                              strokeWidth: 5,
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              tr.t('auth_login_prompt'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.7),
                                fontFamily: 'Mikado',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Gold divider ──
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFFD700).withOpacity(0.0),
                        const Color(0xFFFFD700).withOpacity(0.6),
                        const Color(0xFFFFD700).withOpacity(0.0),
                      ],
                    ),
                  ),
                ),

                // ── Buttons section ──
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF0D2B52),
                        Color(0xFF091E3A),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlueButton(
                        width: double.infinity,
                        buttonText: tr.t('auth_login'),
                        buttonIsLoading: false,
                        onTap: () {
                          soundManager.playClickSound();
                          Navigator.pop(context);
                          showLoginModal(context);
                        },
                      ),
                      SizedBox(height: 14.h),
                      BlueButton(
                        width: double.infinity,
                        buttonText: tr.t('auth_create_profile'),
                        buttonIsLoading: false,
                        onTap: () {
                          soundManager.playClickSound();
                          Navigator.pop(context);
                          showCreateProfileModal(context);
                        },
                      ),
                      SizedBox(height: 18.h),

                      // ── "or" divider ──
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: const Color(0xFF1E3A5F),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Text(
                              tr.t('auth_or_divider'),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF4A6A8A),
                                fontFamily: 'Mikado',
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: const Color(0xFF1E3A5F),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18.h),

                      const GoogleSignInButton(),
                      SizedBox(height: 24.h),

                      // Settings toggles
                      BlocBuilder<SettingsBloc, SettingsState>(
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _settingsIcon(
                                onTap: () {
                                  soundManager.playClickSound();
                                  context
                                      .read<SettingsBloc>()
                                      .add(ToggleSound());
                                },
                                asset: state.isSoundOn
                                    ? IconImageRoutes.soundOn
                                    : IconImageRoutes.soundOff,
                              ),
                              SizedBox(width: 16.w),
                              _settingsIcon(
                                onTap: () {
                                  soundManager.playClickSound();
                                  context
                                      .read<SettingsBloc>()
                                      .add(ToggleMusic());
                                },
                                asset: state.isMusicOn
                                    ? IconImageRoutes.musicOn
                                    : IconImageRoutes.musicOff,
                              ),
                              SizedBox(width: 16.w),
                              _settingsIcon(
                                onTap: () {
                                  soundManager.playClickSound();
                                  context
                                      .read<SettingsBloc>()
                                      .add(ToggleNotification());
                                },
                                asset: state.isNotificationOn
                                    ? IconImageRoutes.notificationOn
                                    : IconImageRoutes.notificationOff,
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _settingsIcon({
  required VoidCallback onTap,
  required String asset,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A3A),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF1E3A5F),
          width: 2,
        ),
      ),
      child: Image.asset(
        asset,
        width: 32.w,
      ),
    ),
  );
}
