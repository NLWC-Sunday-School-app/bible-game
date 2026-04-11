import 'dart:math';
import 'package:bible_game/shared/features/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/home/widget/modals/create_profile_modal.dart';
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
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0842A0).withOpacity(0.5),
                blurRadius: 32,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ──
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 20.h, bottom: 32.h),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1E6FD9),
                      Color(0xFF0842A0),
                      Color(0xFF063580),
                    ],
                  ),
                ),
                child: CustomPaint(
                  painter: _SparklesPainter(),
                  child: Column(
                    children: [
                      // Close
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 16.w),
                          child: GestureDetector(
                            onTap: () {
                              soundManager.playClickSound();
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 32.w,
                              height: 32.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.white.withOpacity(0.8),
                                size: 18.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Emblem
                      Container(
                        width: 76.w,
                        height: 76.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFFFE066),
                              Color(0xFFFFAA00),
                              Color(0xFFFF8800),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xFFFFAA00).withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 3,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.menu_book_rounded,
                              color: const Color(0xFF7A3800),
                              size: 38.sp,
                            ),
                            Positioned(
                              top: 6.h,
                              right: 6.w,
                              child: Icon(
                                Icons.auto_awesome,
                                color: Colors.white.withOpacity(0.9),
                                size: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 18.h),
                      StrokeText(
                        text: tr.t('auth_your_profile'),
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Mikado',
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w900,
                        ),
                        strokeColor: const Color(0xFF042A6B),
                        strokeWidth: 5,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        tr.t('auth_login_prompt'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white.withOpacity(0.65),
                          fontFamily: 'Mikado',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Gold divider ──
              Container(
                height: 4,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFFAA00),
                      Color(0xFFFFD700),
                      Color(0xFFFFE066),
                      Color(0xFFFFD700),
                      Color(0xFFFFAA00),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x55FFD700),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),

              // ── Buttons ──
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0C2244),
                      Color(0xFF071832),
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
                    SizedBox(height: 24.h),

                    // Settings
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
        color: const Color(0xFF0F2A4A),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF1A3A5E),
          width: 1.5,
        ),
      ),
      child: Image.asset(asset, width: 32.w),
    ),
  );
}

class _SparklesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(99);
    final paint = Paint();
    for (int i = 0; i < 18; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = rng.nextDouble() * 1.8 + 0.5;
      paint.color = Colors.white.withOpacity(rng.nextDouble() * 0.25 + 0.05);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
