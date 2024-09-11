import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/image_routes.dart';

class QuestionClock extends StatelessWidget {
  const QuestionClock(
      {super.key,
      required this.animationController,
      this.isWhoIsWho,
      this.whoIsWhoGameDuration,
      this.durationPerQuestion});

  final AnimationController animationController;
  final bool? isWhoIsWho;
  final int? whoIsWhoGameDuration;
  final int? durationPerQuestion;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFDFF2D8), width: 4.w),
          shape: BoxShape.circle),
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFD77A61), width: 2.w),
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
              child: ValueListenableBuilder(
                builder: (context, value, child) {
                  int gameDuration = isWhoIsWho!
                      ? (whoIsWhoGameDuration! * 60)
                      : durationPerQuestion!;
                  int totalSeconds = (gameDuration * (1 - value)).toInt();
                  int remainingMinute = totalSeconds ~/ 60;
                  int remainingSeconds = totalSeconds % 60;
                  return isWhoIsWho!
                      ? Text(
                          '${remainingMinute.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Color(0xFFD77A61),
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                        )
                      : Text('00:${totalSeconds.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Color(0xFFD77A61),
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ));
                },
                valueListenable: animationController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
