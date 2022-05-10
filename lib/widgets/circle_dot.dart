import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleDot extends StatelessWidget {
  final String text;
  final int color;
  final Color borderColor;
  final Color textColor;

  const CircleDot(
      {Key? key,
      required this.text,
      required this.color,
      required this.textColor,
      required this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 6.0.w),
      child: Container(
          width: 42.w,
          height: 42.w,
          child: Center(
              child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: textColor,
              fontSize: 18.sp

            ),
          )),
          decoration: BoxDecoration(
            color: Color(color),
            shape: BoxShape.circle,
            border: Border.all(width: 1.w, color: borderColor),
          )),
    );
  }
}
