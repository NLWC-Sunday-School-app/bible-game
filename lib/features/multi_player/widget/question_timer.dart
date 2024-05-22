import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/constants/image_routes.dart';

class QuestionTimer extends StatelessWidget {
  const QuestionTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return   Container(
        width: 85.w,
        height: 28.h,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFF331581)),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              IconImageRoutes.outlineTimer,
              width: 12.w,
            ),
            SizedBox(width: 5.w,),
            Text(
              '2:00',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF584097),
              ),
            ),
          ],
        ));
  }
}
