import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LeaderBoardChampion extends StatelessWidget {
  const LeaderBoardChampion({
    Key? key, required this.avatarUrl, required this.playerPoint, required this.playerName, required this.playerPosition,
  }) : super(key: key);

  final String avatarUrl;
  final int playerPoint;
  final String playerName;
  final int playerPosition;


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
              SvgPicture.network(
                avatarUrl,
                width: 58.w,
              ),
              SizedBox(
                height: 15.h,
              ),
              SizedBox(
                width: 70,
                child: AutoSizeText(
                  playerName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
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
                  '$playerPoint PTS',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/leaderboard_badge_two.png',
              width: Get.width >= 600 ? 80.w : 100.w,
            ),
            Text(playerPosition.toString(), style: TextStyle(fontSize: 27.sp, fontWeight: FontWeight.w700, color: Colors.white),)
          ],
        ),
      ],
    );
  }
}
