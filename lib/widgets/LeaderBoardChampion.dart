import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaderBoardChampion extends StatelessWidget {
  const LeaderBoardChampion({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 40.h),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r)),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Image.asset(
                'assets/images/avatar_two.png',
                width: 58.w,
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                'Ademola \nAkogun',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 9.w),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(253, 165, 33, 1),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Text(
                  '7500 PTS',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
        Image.asset(
          'assets/images/first_position_badge.png',
          width: 116.w,
        ),
      ],
    );
  }
}
