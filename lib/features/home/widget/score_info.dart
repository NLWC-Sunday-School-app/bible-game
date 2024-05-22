import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScoreInfo extends StatelessWidget {
  const ScoreInfo({
    super.key,
    required this.width,
    required this.backgroundColor,
    required this.borderColor,
    required this.shadowColor,
    required this.score,
    required this.iconImage,
    required this.textColor,
    required this.iconWidth,
  });

  final double width;
  final Color backgroundColor;
  final Color borderColor;
  final Color shadowColor;
  final String score;
  final String iconImage;
  final double iconWidth;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.h),
      decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            width: 2.w,
            color: borderColor,
          ),
          borderRadius: BorderRadius.all(Radius.circular(26.r)),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: Offset(0, 5),
              blurRadius: 0,
              spreadRadius: -2,
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            iconImage,
            width: iconWidth,
          ),
          Text(
            score,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
