import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GamesLockedButton extends StatelessWidget {
  const GamesLockedButton({
    Key? key,
    required this.buttonText,
  }) : super(key: key);
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 30.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: const Color(0xFFBCD8FF)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            color: const Color(0xFF5A82B8),
            size: 16.w,
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            buttonText,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF5A82B8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
