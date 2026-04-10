import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/image_routes.dart';

class QuestionClock extends StatelessWidget {
  const QuestionClock({
    super.key,
    required this.animationController,
    this.isWhoIsWho,
    this.whoIsWhoGameDuration,
    this.durationPerQuestion,
  });

  final AnimationController animationController;
  final bool? isWhoIsWho;
  final int? whoIsWhoGameDuration;
  final int? durationPerQuestion;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: animationController,
      builder: (context, value, child) {
        final int gameDuration = isWhoIsWho!
            ? (whoIsWhoGameDuration! * 60)
            : durationPerQuestion!;
        final int totalSeconds = (gameDuration * (1 - value)).toInt();
        final int remainingMinute = totalSeconds ~/ 60;
        final int remainingSeconds = totalSeconds % 60;

        // Urgency: last 5 seconds of a per-question timer
        final bool isUrgent =
            !(isWhoIsWho!) && totalSeconds <= 5 && totalSeconds > 0;
        final Color outerBorderColor =
            isUrgent ? Colors.red : const Color(0xFFDFF2D8);
        final Color timeTextColor =
            isUrgent ? Colors.red : const Color(0xFFD77A61);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            border: Border.all(color: outerBorderColor, width: 4.w),
            shape: BoxShape.circle,
          ),
          child: Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD77A61), width: 2.w),
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                Image.asset(
                  ProductImageRoutes.clockBg,
                  width: 70.w,
                ),
                Positioned(
                  top: 25.h,
                  left: 12.w,
                  child: isWhoIsWho!
                      ? Text(
                          '${remainingMinute.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: timeTextColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                        )
                      : Text(
                          '00:${totalSeconds.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: timeTextColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
