import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../shared/constants/colors.dart';
import '../../../shared/constants/image_routes.dart';
import '../../../shared/utils/avatar_credentials.dart';

class LeaguePlayerCard extends StatelessWidget {
  const LeaguePlayerCard(
      {super.key,
      required this.username,
      required this.userId,
      required this.points,
      required this.position, required this.goal});


  final String username;
  final int userId;
  final String points;
  final String position;
  final String goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        gradient: LinearGradient(
          colors: [
            Color(0xFFF9EDBB),
            Color(0xFFFBF7AC),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        int.parse(position) <= 5 ?
        Stack(
            children: [
              Image.asset(
                ProductImageRoutes.positionBg,
                width: 50.w,
              ),
              Positioned(
                left: 20.w,
                child: StrokeText(
                  text: position,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  strokeColor: Color(0xFF9B710B),
                  strokeWidth: 2,
                ),
              ),
            ],
          ) :
      Padding(
        padding: EdgeInsets.only(
            left: int.parse(position) <= 500 && int.parse(position) >= 100 ? 10.w : 20.w,
            right: int.parse(position) < 10
                ? 20.w
                : int.parse(position) <= 500 && int.parse(position) >= 100
                ? 0.w
                : 5.w),
        child: StrokeText(
          text: position.toString(),
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
          ),
          strokeColor: Color(0xFF9B710B),
          strokeWidth: 2,
        ),
      ),

          SizedBox(
            width: 10.w,
          ),
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryColor),
                shape: BoxShape.circle),
            child:
            SvgPicture.network(
              '${AvatarCredentials.BaseURL}/$userId.svg?apikey=${AvatarCredentials.APIKey}/',
              width: 35.w,
              semanticsLabel: 'Logo',
              placeholderBuilder: (BuildContext context) => Image.asset(ProductImageRoutes.defaultAvatar, width: 35.w,),
            ),

          ),
          SizedBox(
            width: 5.w,
          ),
          StrokeText(
            text: username,
            textStyle: TextStyle(
              color: Color(0xFF0D468A),
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
            ),
            strokeColor: Color(0xFFF4FFCE),
            strokeWidth: 2,
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: Color(0xFF9D9446)),
                color: Color(0xFFFFFDEB)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  IconImageRoutes.coinIcon,
                  width: 12.w,
                ),
                SizedBox(
                  width: 5.w,
                ),
                StrokeText(
                  text: '$points/$goal',
                  textStyle: TextStyle(
                    color: Color(0xFF554A0C),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  strokeColor: Colors.white,
                  strokeWidth: 4,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
