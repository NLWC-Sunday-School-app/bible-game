import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GamesLockedButtonTabletView extends StatelessWidget {
  const GamesLockedButtonTabletView({
    Key? key,
    required this.buttonText,
  }) : super(key: key);
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 40.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: const Color(0xFFBCD8FF)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            color: const Color(0xFF5A82B8),
            size: 20.w,
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            buttonText,
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF5A82B8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
