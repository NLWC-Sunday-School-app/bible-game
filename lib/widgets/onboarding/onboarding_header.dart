import 'package:flutter/material.dart';
import '../circle_dot.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingHeader extends StatelessWidget {
  final String title;
  final String titleInfo;
  final Color secondCircleDotTextColor;
  final int secondCircleDotBgColor;
  final Color secondCircleDotBorderColor;
  final Color thirdCircleDotTextColor;
  final int thirdCircleDotBgColor;
  final Color thirdCircleDotBorderColor;

  const OnboardingHeader({
    Key? key,
    required this.title,
    required this.titleInfo,
    required this.secondCircleDotTextColor,
    required this.secondCircleDotBgColor,
    required this.secondCircleDotBorderColor,
    required this.thirdCircleDotTextColor,
    required this.thirdCircleDotBgColor,
    required this.thirdCircleDotBorderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 65.h,
        ),
        Text(
          'WORDGAME',
          style: TextStyle(
            color: const Color(0xFF362A7A),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        Row(
          children: [
            const CircleDot(
              text: '1',
              textColor: Color(0xFF362A7A),
              color: 0xFFFECF75,
              borderColor: Colors.transparent,
            ),
            CircleDot(
              text: '2',
              textColor: secondCircleDotTextColor,
              color: secondCircleDotBgColor,
              borderColor: secondCircleDotBorderColor,
            ),
            CircleDot(
              text: '3',
              textColor: thirdCircleDotTextColor,
              color: thirdCircleDotBgColor,
              borderColor: thirdCircleDotBorderColor,
            )
          ],
        ),
        SizedBox(
          height: 25.h,
        ),
        Text(
          title,
          style: TextStyle(
              fontSize: 34.sp,
              fontWeight: FontWeight.w700,
              color: const Color.fromRGBO(54, 42, 122, 1)),
        ),
        SizedBox(
          height: 12.h,
        ),
        Padding(
          padding: EdgeInsets.only(right: 15.w),
          child: Text(
            titleInfo,
            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
