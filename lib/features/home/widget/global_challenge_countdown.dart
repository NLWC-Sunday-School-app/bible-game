import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/constants/image_routes.dart';
import 'package:stroke_text/stroke_text.dart';

class GlobalChallengeCountDown extends StatelessWidget {
  const GlobalChallengeCountDown({super.key, required this.days, required this.hours, required this.minutes, required this.seconds});
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
          border: Border.all(
              color: AppColors.accentColor, width: 3.w),
          borderRadius: BorderRadius.circular(8.r),
          image: DecorationImage(
            image: AssetImage(
                ProductImageRoutes.gcAnnouncementBg),
            fit: BoxFit.cover,
          )),
      child: Container(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  StrokeText(
                    text: 'Next Global Challenge Starts',
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700),
                    strokeColor: const Color(0xFF144B51),
                    strokeWidth: 3,
                  ),
                  StrokeText(
                    text: '${days}D:${hours}H:${minutes}M:${seconds}s',
                    textStyle: TextStyle(
                        letterSpacing: 4,
                        color: AppColors.accentColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700),
                    strokeColor: Colors.white,
                    strokeWidth: 1,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10.h,
              right: 0,
              child: Image.asset(
                IconImageRoutes.whiteCancelIcon,
                width: 15.sp,
              ),
            )
          ],
        ),
      ),
    );
  }
}
