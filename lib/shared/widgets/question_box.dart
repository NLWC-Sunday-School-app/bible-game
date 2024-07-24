import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/image_routes.dart';

class QuestionBox extends StatelessWidget {
  const QuestionBox(
      {super.key, required this.instruction, required this.question});

  final String instruction;
  final String question;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                top: 30.h,
                bottom: 5.h,
              ),
              height: 200.h,
              width: 350.w,
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
                  ]),
              child: Scrollbar(
                child: SingleChildScrollView(
                    child: Text(
                  question,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
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
                  width: 230.w,
                ),
                Positioned(
                  top: 10.h,
                  left: 25.w,
                  child: Text(
                    instruction,
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
