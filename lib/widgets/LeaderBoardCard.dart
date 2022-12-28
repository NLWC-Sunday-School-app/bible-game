import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeaderBoardCard extends StatelessWidget {
  final int playerPosition;
  final String playerName;
  final int playerPoint;
  final int playerId;
  final String avatarUrl;

  const LeaderBoardCard({
    Key? key, required this.playerPosition, required this.playerName, required this.playerPoint, required this.playerId, required this.avatarUrl,

  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h, ),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10.h, ),
            padding:
            EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(152, 152, 152, 1)
                      .withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 4,
                  offset:
                  const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 8.w, left: 50.w),
                      child: SvgPicture.network(
                        avatarUrl,
                        width: 34.w,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playerName,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Beloved of the Lord',
                          style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500),
                        )
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
                        children:  [
                          Text(
                            playerPoint.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(123, 123, 123, 1)),
                          ),
                          const Text('Pts'),
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
                margin: EdgeInsets.only(
                    left: 15.0.w, right: 15.0.w),
                padding: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                  top: 20.h,
                  bottom: 45.h,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(91, 74, 191, 1),
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
                      'th',
                      style: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFeatures: const [
                            FontFeature.superscripts()
                          ]),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: 50.h, left: 10.w),
                child:Image.asset('assets/images/believer_badge.png', width: 55.w,),
              )

            ],
          )
        ],
      ),
    );
  }
}
