import 'dart:ui';

import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

import '../../../shared/utils/recap.dart';

class RecapFiveScreen extends StatelessWidget {
  const RecapFiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.recapFiveBck),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(
                  height: 571,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(formatUser2025TopGameModeImageBck(state.userInsightYearlyRecap!.userTopGameMode!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 120.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Your Favorite Game Type',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: 'Mikado',
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 32.h,),
                    Text(
                      'You enjoyed playing....',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: 'Gochi hand',
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 32.h,),
                    Image.asset(
                      formatUser2025TopGameModeImageContainer(state.userInsightYearlyRecap!.userTopGameMode!),
                      width: 308.w,
                    ).animate(
                        autoPlay: true
                    )
                        .scaleXY(
                        begin: 0,
                        end: 1,
                        curve: Curves.elasticInOut,
                        duration: Duration(seconds: 2),
                        alignment: Alignment.topLeft
                    ),

                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 130.h),
                child: Column(
                  children: [
                    Spacer(),
                    Text(
                      '${formatUserTopGameMode(state.userYearlyRecap['user_top_game_mode'])} was your\nbattlefield',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: 'Mikado',
                        color: Color(0xffFFF9F0),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 36.h,),
                    Text(
                      '65%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 64.sp,
                        fontFamily: 'Mikado',
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '0f games',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontFamily: 'Gochi hand',
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
