import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaderBoardBaseChampions extends StatelessWidget {
  const LeaderBoardBaseChampions({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 60.h,),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40.h),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Image.asset(
                  'assets/images/avatar_one.png',
                  width: 47.w,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  'Blackwood \nJackson Jnr',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 7.w),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(118, 99, 229, 1),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Text(
                    '7300 PTS',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          Image.asset(
            'assets/images/second_position_badge.png',
            width: 95.w,
          ),
        ],
      ),
    );
  }
}
