import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/image_routes.dart';

class QuestionBoxTabletView extends StatelessWidget {
  const QuestionBoxTabletView(
      {super.key, required this.instruction, required this.question, this.isWhoIsWho = false});

  final String instruction;
  final String question;
  final bool? isWhoIsWho;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: 365.h,
        width: double.infinity,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(
                  left: 10.w,
                  right: 10.w,
                  top: 35.h,
                  bottom: 5.h,
                ),
                height: 344.h,
                width: 717.w,
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
                child: Center(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                        child: Text(
                      question,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.sp,
                      ),
                    )),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                children: [
                  Image.asset(
                    ProductImageRoutes.questionFrameBg,
                    width:350.w,
                  ),
                  Positioned(
                    top: 14.h,
                    left: 25.w,
                    right: 25.w,
                    child: Text(
                      instruction,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
