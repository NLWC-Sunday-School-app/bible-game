import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../shared/constants/image_routes.dart';


class SentGameRequestCard extends StatelessWidget {
  const SentGameRequestCard({super.key, required this.userAvatar, required this.userName});
  final String userAvatar;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 60.h,
        margin: EdgeInsets.only(top: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Color(0xFFF4FFCE)),
          color: Color(0xFFF9EDBB),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFF8BA725),
              offset: Offset(1, 5),
              blurRadius: 0,
              spreadRadius: -2,
            ),
            BoxShadow(
              color: Colors.black26,
              offset: Offset(1, 5),
              blurRadius: 0,
              spreadRadius: -2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                  border:
                  Border.all(color: Color(0xFF366ABC)),
                  shape: BoxShape.circle),
              child: Image.network(
                userAvatar,
                width: 35.w,
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StrokeText(
                  text: userName,
                  textStyle: TextStyle(
                    color: Color(0xFF0D468A),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  strokeColor: Color(0xFFF4FFCE),
                  strokeWidth: 3,
                ),
                Text(
                  'sent you a game request.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
            Image.asset(
              IconImageRoutes.redCircleClose,
              width: 65.w,
            ),
            Image.asset(
              IconImageRoutes.greenCircleMark,
              width: 40.w,
            )
          ],
        ),
      ),
    );
  }
}
