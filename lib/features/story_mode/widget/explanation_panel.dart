import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/constants/colors.dart';

class ExplanationPanel extends StatelessWidget {
  const ExplanationPanel({
    super.key,
    required this.explanation,
    required this.bibleReference,
    required this.isCorrect,
    required this.isVisible,
  });

  final String explanation;
  final String bibleReference;
  final bool isCorrect;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeIn,
      child: AnimatedSlide(
        offset: isVisible ? Offset.zero : const Offset(0, 0.5),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.navyBlue,
            borderRadius: BorderRadius.circular(8.r),
            border: Border(
              left: BorderSide(
                color: isCorrect
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFFF44336),
                width: 4.w,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    '📖',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      bibleReference,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                explanation,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
