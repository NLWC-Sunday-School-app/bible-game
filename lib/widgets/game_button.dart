import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameButton extends StatelessWidget {
  const GameButton({
    Key? key, required this.buttonText, required this.buttonActive,
  }) : super(key: key);

  final String buttonText;
  final bool buttonActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      EdgeInsets.symmetric(horizontal: 81.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient:  LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: !buttonActive ? [
            const Color.fromRGBO(224, 153, 16, 1).withOpacity(0.4),
            const Color.fromRGBO(254, 193, 75, 1).withOpacity(0.4),
          ] : [
            const Color.fromRGBO(224, 153, 16, 1),
            const Color.fromRGBO(254, 193, 75, 1),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child:  AutoSizeText(
        buttonText,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14.sp,
          color: const Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}

