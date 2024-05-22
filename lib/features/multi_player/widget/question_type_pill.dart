import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionTypePill extends StatelessWidget {
  const QuestionTypePill({super.key, required this.text, required this.pillSelected, required this.onTap});
  final String text;
  final bool pillSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: onTap,
      child: Container(
        height: 40.h,
        width: 120.w,
        decoration: BoxDecoration(
          color: pillSelected ? Color(0xFFF1915E) : Color(0xFFFEEDE4),
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: pillSelected ? Color(0xFFFCD1BB) : Color(0xFFF8E7DE) , width: 2.w),
          boxShadow: [
           pillSelected ? BoxShadow(
             color: Color(0xFFFCD1BB),
             offset: Offset(1, 3),
             blurRadius: 0,
             spreadRadius: -2,
           ) : BoxShadow(
              color: Color(0xFFF8E7DE),
              offset: Offset(0, -3),
              blurRadius: 0,
              spreadRadius: -2,
            ) ,
          ],
        ),
        child: Align(
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: pillSelected ? Colors.white :Color(0xFF014CA3),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500

              ),
            )),
      ),
    );
  }
}
