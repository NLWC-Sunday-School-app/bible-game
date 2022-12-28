import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LeaderBoardBaseChampions extends StatelessWidget {
  final String playerName;
  final int playerPoint;
  final String avatarUrl;
  final int playerPosition;

  const LeaderBoardBaseChampions({
    Key? key,
    required this.playerName, required this.playerPoint, required this.avatarUrl, required this.playerPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 60.h,
      ),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40.h),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r)),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                SvgPicture.network(
                  avatarUrl,
                  width: 47.w,
                ),
                SizedBox(
                  height: 5.h,
                ),
                SizedBox(
                  width: 60,
                  child: AutoSizeText(
                    playerName,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
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
                    '$playerPoint PTS',
                    style: TextStyle(
                      fontSize: 10.sp,
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
                'assets/images/leaderboard_badge.png',
                width: Get.width >= 600 ? 75.w : 95.w,
              ),
              Text(playerPosition.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),),
            ],
          ),
        ],
      ),
    );
  }
}
