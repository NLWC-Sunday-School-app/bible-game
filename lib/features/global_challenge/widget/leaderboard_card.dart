import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bible_game/shared/constants/image_routes.dart';

import '../../../shared/widgets/multi_avatar.dart';

class LeaderBoardCard extends StatelessWidget {
  final int playerPosition;
  final String playerName;
  final int playerPoint;
  final int playerId;
  final String avatarUrl;

  const LeaderBoardCard({
    Key? key,
    required this.playerPosition,
    required this.playerName,
    required this.playerPoint,
    required this.playerId,
    required this.avatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10.h,
      ),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 10.h,
            ),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromRGBO(152, 152, 152, 1).withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 4,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 8.w, left: 50.w),
                      child:
                      // Image.network(
                      //   avatarUrl,
                      //   width: 34.w,
                      // ),
                      AvatarWidget(seed: avatarUrl, width: 34.w, height: 34.h,)
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playerName,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(233, 233, 233, 1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playerPoint.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 11.sp),
                          ),
                          Text(
                            'Pts',
                            style: TextStyle(fontSize: 10.sp),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15.0.w, right: 15.0.w),
                padding: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                  top: 20.h,
                  bottom: 45.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D4781),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Wrap(
                  children: [
                    Text(
                      playerPosition.toString(),
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      (playerPosition == 2)
                          ? 'nd'
                          : (playerPosition == 1)
                              ? 'st'
                              : (playerPosition == 3)
                                  ? 'rd'
                                  : 'th',
                      style: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFeatures: const [FontFeature.superscripts()]),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 50.h,
                  left: 10.w,
                ),
                child: Image.asset(
                  ProductImageRoutes.believerBadge,
                  width: 55.w,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
