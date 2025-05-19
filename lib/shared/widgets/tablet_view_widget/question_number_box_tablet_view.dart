import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/constants/image_routes.dart';

class QuestionNumberBoxTabletView extends StatelessWidget {
  const QuestionNumberBoxTabletView({super.key, required this.currentQuestionNumber, required this.totalQuestions, this.isWhoIsWho = false, this.noOfCorrectQuestions});
  final String currentQuestionNumber;
  final String totalQuestions;
  final bool? isWhoIsWho;
  final String? noOfCorrectQuestions;
  @override
  Widget build(BuildContext context) {
    return
      SizedBox(
        height: 50.h,
        child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Container(
                width: 130.w,
                height: 36.h,
                padding:
                    EdgeInsets.only(left: 20.w, right: 2.w, top: 2.h, bottom: 2.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26.r),
                  border: Border.all(color: Color(0xFF7E3DB6)),
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
                  decoration: BoxDecoration(
                      color: Color(0xFF8943B9),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(26.r),
                        bottomRight: Radius.circular((26.r)),
                      )),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                     isWhoIsWho! ? '$noOfCorrectQuestions Q' : '$currentQuestionNumber/$totalQuestions Qs',
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
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              IconImageRoutes.purpleBook,
              width: 49.w,
            ),
          ),
        ],
            ),
      );
  }
}
