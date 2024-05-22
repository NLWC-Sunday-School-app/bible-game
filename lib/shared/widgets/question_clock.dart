import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/image_routes.dart';

class QuestionClock extends StatelessWidget {
  const QuestionClock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFDFF2D8), width: 4.w),
            shape: BoxShape.circle
        ),
        child: Container(
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xFFD77A61), width: 2.w),
              shape: BoxShape.circle
          ),
          child: Stack(
            children: [
              Image.asset(
                ProductImageRoutes.clockBg,
                width: 60.w,
              ),
              Positioned(
                top: 18.h,
                left: 12.w,
                child: Text('2:00', style: TextStyle(
                    color: Color(0xFFD77A61),
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp

                ),),
              )
            ],
          ),
        ),
      );
  }
}
