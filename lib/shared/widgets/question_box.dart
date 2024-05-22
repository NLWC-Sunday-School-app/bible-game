import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/image_routes.dart';
class QuestionBox extends StatelessWidget {
  const QuestionBox({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 20.h,
            ),
            child: Container(
              padding: EdgeInsets.only(
                left: 10.w,
                right: 10.w,
                top: 25.h,
                bottom: 5.h,
              ),
              height: 200.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    width: 2.w,
                    color: Color(0xFFFFF8C4),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFED8A9),
                      Color(0xFFF3C393),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFBD7371),
                      offset: Offset(0, 5),
                      blurRadius: 0,
                      spreadRadius: -2,
                    )
                  ]
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                    child: Text(
                      'The king’s scribes were summoned at that time, in the third month, which is the month of Sivan, on thetwenty-third day. And an edict was written, accordingto all that Mordecai commanded concerningthe Jews, to the satraps and the governors and theofficials of the provinces from India toEthiopia, 127 provinces, to each province in its ownscript and to each people in its own language,and also to the Jews in their script and their language',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14.sp),
                    )),
              ),
            ),
          ),
          Positioned(
            right: 80.w,
            child: Stack(
              children: [
                Image.asset(
                  ProductImageRoutes.questionFrameBg,
                  width: 210.w,
                ),
                Positioned(
                  top: 10.h,
                  left: 25.w,
                  child: Text(
                    'Who said this in the bible?',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
