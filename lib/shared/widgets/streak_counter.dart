import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StreakCounter extends StatelessWidget {
  final int streakCount;

  const StreakCounter({super.key, required this.streakCount});

  @override
  Widget build(BuildContext context) {
    if (streakCount < 2) return const SizedBox.shrink();

    Color glowColor;
    Color bgColor;
    Color textColor;

    if (streakCount >= 7) {
      glowColor = const Color(0xFFFFD700);
      bgColor = const Color(0xFFB8860B);
      textColor = const Color(0xFFFFD700);
    } else if (streakCount >= 5) {
      glowColor = const Color(0xFFFF4500);
      bgColor = const Color(0xFF8B1A00);
      textColor = Colors.orange;
    } else {
      glowColor = const Color(0xFFFF8C00);
      bgColor = const Color(0xFF7B3800);
      textColor = Colors.yellow;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(streakCount),
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: glowColor.withValues(alpha: 0.6),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🔥', style: TextStyle(fontSize: 14.sp)),
            SizedBox(width: 4.w),
            Text(
              'x$streakCount Streak!',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Neuland',
              ),
            ),
          ],
        ),
      )
          .animate(key: ValueKey('anim_$streakCount'))
          .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1), duration: 300.ms, curve: Curves.elasticOut)
          .fadeIn(duration: 200.ms),
    );
  }
}
