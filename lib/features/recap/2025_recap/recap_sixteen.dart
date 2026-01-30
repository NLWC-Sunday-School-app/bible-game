import 'dart:math';
import 'dart:ui';

import 'package:bible_game/features/global_challenge/widget/leaderboard_card.dart';
import 'package:bible_game/features/multi_player/widget/multiplayer_leaderboard_card.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/features/user/bloc/user_bloc.dart';
import '../../leader_board/widget/leaderboard_card.dart';

class RecapSixteenScreen extends StatelessWidget {
  const RecapSixteenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.recapSixteenBck),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ProductImageRoutes.recapSixteenGif),
                    fit: BoxFit.contain,
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
                      'Monthly Activity',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: 'Mikado',
                        color: Color(0xFF2F2F2F),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child:Padding(
                padding: EdgeInsets.only(bottom: 130.h),
                child: Column(
                  children: [
                    Spacer(),
                    Image.asset(
                      ProductImageRoutes.recapGraph,
                      width: 300.w,
                    ).animate()
                        .fadeIn(
                        duration: Duration(seconds: 2)
                    ),
                    SizedBox(height: 50.h,),
                    Text(
                      'Your Peak Month is',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: 'Gochi hand',
                        color: Color(0xFF22210D),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    Text(
                      DateFormat('MMMM d').format(DateTime.parse("${state.userInsightYearlyRecap!.peakPlayingMonth!.month!}-01").toLocal()),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 52.sp,
                        fontFamily: 'Mikado',
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 40.h,),
                    Text(
                      'One month, countless blessings; you\nsowed and reaped abundantly!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: 'Gochi hand',
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}
