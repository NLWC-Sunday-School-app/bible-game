import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';

class OptionButton extends StatelessWidget {
  const OptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Container(
          margin: EdgeInsets.only(bottom: 10.h),
          width: double.infinity,
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.primaryColor),
              borderRadius: BorderRadius.circular(8.r)
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    shape: BoxShape.circle
                ),
                child: Text('A', style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500
                ),),

              ),
              SizedBox(width: 10.w,),
              Text(
                'Matthew',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                ),
              )
            ],
          ),
        ),
      );
  }
}
