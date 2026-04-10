import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/constants/image_routes.dart';

class CoinsNumberBoxTabletView extends StatelessWidget {
  const CoinsNumberBoxTabletView({super.key, required this.noOfCoins});
  final int noOfCoins;

  @override
  Widget build(BuildContext context) {
    return
      SizedBox(
        height: 50.h,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                child: Container(
                  width: 144.w,
                  height: 40.h,
                  padding:
                  EdgeInsets.only(left: 20.w, right: 2.w, top: 2.h, bottom: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26.r),
                    border: Border.all(color: Color(0xFFFFAF02)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFF7F6F15),
                        offset: Offset(0, 5),
                        blurRadius: 0,
                        spreadRadius: -2,
                      )
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.only(right: 10.w),
                    decoration: BoxDecoration(
                        color: Color(0xFFE56205),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(26.r),
                          bottomRight: Radius.circular((26.r)),
                        )),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        noOfCoins.toString(),
                        style: TextStyle(
                          fontFamily: 'Mikado',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
             alignment: Alignment.bottomCenter,
              child: Image.asset(
                IconImageRoutes.coinIcon,
                width: 49.w,
              ),
            ),
          ],
        ),
      );
  }
}
