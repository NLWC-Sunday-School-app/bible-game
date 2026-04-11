import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';

class StreakCounter extends StatelessWidget {
  final int streakCount;

  const StreakCounter({super.key, required this.streakCount});

  /// Returns the current multiplier for the given streak count.
  /// Matches the bloc logic: 1.0 + (streak * 0.1), capped at 2.0
  String _getMultiplierText(int streak) {
    if (streak < 3) return '';
    final multiplier = (1.0 + streak * 0.1).clamp(1.0, 2.0);
    if (multiplier == 2.0) return '2x';
    return '${multiplier.toStringAsFixed(1)}x';
  }

  @override
  Widget build(BuildContext context) {
    if (streakCount < 2) return const SizedBox.shrink();

    Color glowColor;
    Color bgColor;
    Color comboColor;
    Color multiplierColor;
    final bool hasMultiplier = streakCount >= 3;
    final bool isMax = streakCount >= 10;

    if (streakCount >= 7) {
      // Gold tier
      glowColor = const Color(0xFFFFD700);
      bgColor = const Color(0xFF2A1800);
      comboColor = const Color(0xFFFFD700);
      multiplierColor = const Color(0xFFFFE866);
    } else if (streakCount >= 5) {
      // Orange tier
      glowColor = const Color(0xFFFF6B00);
      bgColor = const Color(0xFF2A0A00);
      comboColor = const Color(0xFFFF8C00);
      multiplierColor = const Color(0xFFFFAA44);
    } else if (streakCount >= 3) {
      // Blue tier (multiplier starts)
      glowColor = const Color(0xFF4A9FFF);
      bgColor = const Color(0xFF0A1A30);
      comboColor = const Color(0xFF5BB5FF);
      multiplierColor = const Color(0xFF88CCFF);
    } else {
      // Starting combo (no multiplier yet)
      glowColor = const Color(0xFF888888);
      bgColor = const Color(0xFF1A1A2E);
      comboColor = Colors.white;
      multiplierColor = Colors.white70;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(streakCount),
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: glowColor.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(isMax ? 0.7 : 0.4),
              blurRadius: isMax ? 14 : 8,
              spreadRadius: isMax ? 3 : 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lightning bolt
            Text(
              '\u26A1',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(width: 4.w),

            // Combo count
            StrokeText(
              text: '${streakCount}x Combo',
              textStyle: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                color: comboColor,
              ),
              strokeColor: Colors.black,
              strokeWidth: 3,
            ),

            // Multiplier badge (only at 3+)
            if (hasMultiplier) ...[
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: glowColor.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: glowColor.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/icons/user/coins.png',
                      width: 12.w,
                      height: 12.w,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      _getMultiplierText(streakCount),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w900,
                        color: multiplierColor,
                      ),
                    ),
                    if (isMax) ...[
                      SizedBox(width: 2.w),
                      Text(
                        'MAX',
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFFFD700),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      )
          .animate(key: ValueKey('anim_$streakCount'))
          .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1, 1),
              duration: 300.ms,
              curve: Curves.elasticOut)
          .fadeIn(duration: 200.ms),
    );
  }
}
