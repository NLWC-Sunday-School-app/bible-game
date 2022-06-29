import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionPoints extends StatelessWidget {
  const QuestionPoints({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 45.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            width: 1,
            color: const Color.fromRGBO(229, 150, 75, 1)),
        borderRadius: BorderRadius.circular(13.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(229, 150, 75, 1),
            offset: Offset(0, 1),
            blurRadius: 1,
          )
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 5.h,
          ),
          Text(
            'Points',
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: const Color.fromRGBO(229, 150, 75, 1)),
          ),
          Text(
            '0',
            style: TextStyle(
                fontSize: 34.sp,
                fontWeight: FontWeight.w500,
                color: const Color.fromRGBO(229, 150, 75, 1)),
          )
        ],
      ),
    );
  }
}

