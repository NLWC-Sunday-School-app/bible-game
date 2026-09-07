import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../shared/constants/colors.dart';
import '../../../shared/constants/image_routes.dart';
import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/utils/country_iso_3.dart';
import '../../../shared/utils/formatter.dart';
import '../../../shared/utils/user_badge.dart';
import '../../../shared/widgets/multi_avatar.dart';

class MultiplayerLeaderboardCard extends StatelessWidget {
  const MultiplayerLeaderboardCard({
    super.key,
    required this.position,
    required this.userName,
    required this.userRank,
    required this.countryName,
    // required this.userBadge,
    required this.noOfCoins,
    required this.userId,
  });

  final String? userId;
  final int position;
  final String userName;
  final String? countryName;
  final String userRank;
  final int noOfCoins;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 73.h,
      width: double.infinity,
      margin:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
        gradient: BlocProvider.of<AuthenticationBloc>(context).state.user.id != userId ?  LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF9EDBB),
            Color(0xFFFBF7AC),
          ],
        ) : LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFB4FF6A),
            Color(0xFF599D15),
          ],
        ) ,
        // color: BlocProvider.of<AuthenticationBloc>(context).state.user.id == userId ? Color(0xFF599D15) : Color(0xFFFAF3B3),
        border: Border.all(color: BlocProvider.of<AuthenticationBloc>(context).state.user.id == userId  ? Color(0xFF7DCD2E) : Color(0xFFF4FFCE )),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          position <= 3
              ? Stack(
            children: [
              Image.asset(
                ProductImageRoutes.positionBg,
                width: 50.w,
              ),
              Positioned(
                left: 20.w,
                child: StrokeText(
                  text: position.toString(),
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
          )
              : Padding(
            padding: EdgeInsets.only(
                left: position <= 500 && position >= 100 ? 10.w : 20.w,
                right: position < 10
                    ? 20.w
                    : position <= 500 && position >= 100
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
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Color(0xFF366ABC))
            ),
            child: AvatarWidget(seed: userId!, width: 35.w, height: 35.h,),
          ),
          SizedBox(
            width: 5.w,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  countryName != null
                      ? SvgPicture.asset(
                    'assets/images/flags/${countryName!.replaceAll('/', ' ').toLowerCase()}.svg',
                    width: 16.w,
                  )
                      : SizedBox(
                    width: 16.w,
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text(
                    countryName != null
                        ? getIso3Code(countryName!.replaceAll('/', ' '))
                        : '-',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF082D5A)),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Image.asset(
                    getBadgeUrl(userRank),
                    width: 13.sp,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  StrokeText(
                    text:
                    capitalizeText(userRank),
                    textStyle: TextStyle(
                      color: Color(0xFF5047C4),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                    ),
                    strokeColor: Colors.white,
                    strokeWidth: 2,
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          Container(
            width: 71.w,
            height: 34.h,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Color(0xFF9D9446),
                width: 2.w,
              ),
              borderRadius: BorderRadius.circular(26.r),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF7F6F15),
                  offset: Offset(0, 2),
                  blurRadius: 0,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 4.w,),
                Image.asset(
                  IconImageRoutes.coinIcon,
                  width: 16,
                  height: 16,
                ),
                SizedBox(width: 4.w,),
                Text(
                  "$noOfCoins",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: Color(0xFF554A0C)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
