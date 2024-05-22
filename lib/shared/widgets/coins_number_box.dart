import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';

class CoinsNumberBox extends StatelessWidget {
  const CoinsNumberBox({super.key});

  @override
  Widget build(BuildContext context) {
    return
      Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
            child: Container(
              width: 120.w,
              height: 35.h,
              padding:
              EdgeInsets.only(left: 20.w, right: 5.w, top: 5.h, bottom: 5.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26.r),
                border: Border.all(color: Color(0xFFFFAF02)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF7F6F15),
                    offset: Offset(0, 5),
                    blurRadius: 0,
                    spreadRadius: -2,
                  )
                ],
              ),
              child: Container(
                padding: EdgeInsets.only(right: 10.w),
                decoration: BoxDecoration(
                    color: Color(0xFFE56205),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(26.r),
                      bottomRight: Radius.circular((26.r)),
                    )),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '120,4321',
                    style: TextStyle(
                      fontFamily: 'Mikado',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            child: Image.asset(
              IconImageRoutes.coinIcon,
              width: 40.w,
            ),
          ),
        ],
      );
  }
}
