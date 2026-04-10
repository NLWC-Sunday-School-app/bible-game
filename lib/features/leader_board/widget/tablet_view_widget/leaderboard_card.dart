import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/utils/country_iso_3.dart';
import 'package:bible_game/shared/utils/formatter.dart';
import 'package:intl/intl.dart';

import '../../../../shared/constants/colors.dart';
import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/widgets/multi_avatar.dart';

class LeaderboardCardTabletView extends StatelessWidget {
  const LeaderboardCardTabletView({
    super.key,
    required this.position,
    required this.userName,
    required this.countryName,
    // required this.userBadge,
    required this.noOfCoins,
    required this.userId,
  });

  final int userId;
  final int position;
  final String userName;
  final String? countryName;
  // final String userBadge;
  final int noOfCoins;

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,###,###');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Container(
        height: 73.h,
        width: double.infinity,
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
            position <= 5
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
                  border: Border.all(color: AppColors.primaryColor),
                  shape: BoxShape.circle),
              child:
              // SvgPicture.network(
              //   '${AvatarCredentials.BaseURL}/${userId}.svg?apikey=${AvatarCredentials.APIKey}/',
              //   width: 35.w,
              //   semanticsLabel: 'Logo',
              //   placeholderBuilder: (BuildContext context) => Image.asset(ProductImageRoutes.defaultAvatar, width: 35.w,),
              // ),

              AvatarWidget(seed: userId.toString(), width: 35.w, height: 35.h,),
              // Text(userId.toString()),
              // FadeInImage.assetNetwork(
              //   placeholder: ProductImageRoutes.defaultAvatar,
              //   image:
              //       '${AvatarCredentials.BaseURL}/${userId}.png?apikey=${AvatarCredentials.APIKey}/',
              //   width: 35.w,
              // ),
            ),
            SizedBox(
              width: 5.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    // Image.asset(
                    //   userBadge,
                    //   width: 14.sp,
                    // ),
                    // SizedBox(
                    //   width: 5.w,
                    // ),
                    // Text(
                    //   userLevel == 'young believer'
                    //       ? 'YB'
                    //       : capitalizeText(userLevel),
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.w700,
                    //     color: Color(0xFF5047C4),
                    //     fontSize: 13.sp,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Container(
              width: 99.w,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color(0xFF9D9446),
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(26.r),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF7F6F15),
                    offset: Offset(0, 5),
                    blurRadius: 0,
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    IconImageRoutes.coinIcon,
                    width: 13.w,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    formatter.format(noOfCoins),
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: Color(0xFF554A0C)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
