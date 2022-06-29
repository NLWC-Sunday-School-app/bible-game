import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameButton extends StatelessWidget {
  const GameButton({
    Key? key, required this.buttonText,
  }) : super(key: key);

  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      EdgeInsets.symmetric(horizontal: 81.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(224, 153, 16, 1),
            Color.fromRGBO(254, 193, 75, 1),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child:  Text(
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

