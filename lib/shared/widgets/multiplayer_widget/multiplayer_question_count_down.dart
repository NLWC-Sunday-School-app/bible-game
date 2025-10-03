import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/constants/image_routes.dart';

class MultiplayerQuestionCountDown extends StatelessWidget {
  const MultiplayerQuestionCountDown({super.key});
  @override
  Widget build(BuildContext context) {

    return
      SizedBox(
        height: 50.h,
        width: 70.w,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Container(
                  width: 56.w,
                  height: 22.h,
                  padding:
                  EdgeInsets.only(left: 2.w, right: 2.w, top: 2.h, bottom: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26.r),
                    border: Border.all(color: Color(0xFF6AACE8)),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(right: 5.w),
                    decoration: BoxDecoration(
                        color: Color(0xFF6AACE8),
                      borderRadius: BorderRadius.circular(26.r),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '00:15',
                        style: TextStyle(
                          fontFamily: 'Mikado',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                "assets/images/product/multi_player/sand.png",
                width: 30.w,
                height: 30.h,
              ),
            ),
          ],
        ),
      );
  }
}
