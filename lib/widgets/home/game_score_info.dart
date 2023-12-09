import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameScoreInfo extends StatelessWidget {
  const GameScoreInfo({Key? key, required this.noOfCoins, required this.noOfGems}) : super(key: key);
  final int noOfCoins;
  final int noOfGems;

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10.w, vertical: 2.h),
              child: Container(
                width: 120.w,
                padding: EdgeInsets.only(
                    left: 25.w,
                    right: 10.w,
                    top: 5.h,
                    bottom: 5.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4.r),
                    bottomRight: Radius.circular(10.r),
                    topLeft: Radius.circular(4.r),
                  ),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0xFF366ABC),
                        offset: Offset(0, 5),
                        blurRadius: 0,
                        spreadRadius: -2)
                  ],
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    noOfCoins.toString(),
                    style: TextStyle(
                        fontFamily: 'Mikado',
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF3C78D1),
                        fontSize: 14.sp),
                  ),
                ),
              ),
            ),
            Positioned(
              child: Image.asset(
                'assets/images/icons/coins.png',
                width: 35.w,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10.w, vertical: 3.h),
              child: Container(
                width: 120.w,
                padding: EdgeInsets.only(
                    left: 25.w,
                    right: 10.w,
                    top: 5.h,
                    bottom: 5.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4.r),
                      topLeft: Radius.circular(10.r),
                      bottomRight: Radius.circular(10.r),
                      bottomLeft: Radius.circular(4.r)),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0xFF366ABC),
                        offset: Offset(0, 5),
                        blurRadius: 0,
                        spreadRadius: -2)
                  ],
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    noOfGems.toString(),
                    style: TextStyle(
                        fontFamily: 'Mikado',
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF3C78D1),
                        fontSize: 14.sp),
                  ),
                ),
              ),
            ),
            Positioned(
              child: Image.asset(
                'assets/images/icons/gem.png',
                width: 35.w,
              ),
            ),
          ],
        )
      ],
    );
  }
}
