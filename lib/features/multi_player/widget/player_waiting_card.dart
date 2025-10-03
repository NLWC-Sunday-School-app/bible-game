import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/constants/image_routes.dart';
import '../../../shared/widgets/multi_avatar.dart';

class PlayerWaitingCard extends StatelessWidget {
  const PlayerWaitingCard({
    super.key,
    required this.position,
    required this.userName,
    required this.countryName,
    required this.countryLogo,
    required this.userLevel,
    required this.userBadge,
    required this.noOfCoins,
    required this.userId,
    required this.isHost,
    required this.isWaitingForHost,
  });

  final int position;
  final String userName;
  final String countryName;
  final String countryLogo;
  final String userLevel;
  final String userBadge;
  final String noOfCoins;
  final String userId;
  final bool isHost;
  final bool isWaitingForHost;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Container(
        width: double.infinity,
        height: 65.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: Color(0xFFFAF3B3),
          border: Border.all(color: Color(0xFFF4FFCE)),
          borderRadius: BorderRadius.circular(6.r),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF8BA725),
              offset: Offset(2, 4),
              blurRadius: 0,
              spreadRadius: -2,
            ),
          ],
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
            ),
            StrokeText(
              text: position.toString(),
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
              ),
              strokeColor: Color(0xFF9B710B),
              strokeWidth: 2,
            ),
            SizedBox(
              width: 30.w,
            ),
            AvatarWidget(seed: userId, width: 35.w, height: 35.h,),
            SizedBox(
              width: 10.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StrokeText(
                  text: userName,
                  textStyle: TextStyle(
                    color: Color(0xFF0D468A),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  strokeColor: Color(0xFFF4FFCE),
                  strokeWidth: 4,
                ),
                Row(
                  children: [
                    Image.network(
                      countryLogo,
                      width: 16.w,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text(
                      countryName,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF082D5A)),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Image.asset(
                      userBadge,
                      width: 14.sp,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      userLevel,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5047C4),
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            isHost
                ?
                Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Text(
                      "Host",
                    style: TextStyle(
                      color: Color(0xFF1A7E1C),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                )
                :
            isWaitingForHost
                ? SizedBox.shrink()
                : Image.asset(
              IconImageRoutes.redCircleClose,
              width: 60.w,
            )
          ],
        ),
      ),
    );
  }
}
