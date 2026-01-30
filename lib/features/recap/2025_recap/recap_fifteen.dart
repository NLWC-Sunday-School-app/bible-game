import 'dart:math';
import 'dart:ui';

import 'package:bible_game/features/global_challenge/widget/leaderboard_card.dart';
import 'package:bible_game/features/multi_player/widget/multiplayer_leaderboard_card.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/features/user/bloc/user_bloc.dart';
import '../../leader_board/widget/leaderboard_card.dart';

class RecapFifteenScreen extends StatelessWidget {
  const RecapFifteenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        final index = state
            .countryLeaderboard!.indexWhere((board) => board.userId == BlocProvider.of<AuthenticationBloc>(context).state.user.id);
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.recapFourteenBck),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.recapFourteenGif),
                  fit: BoxFit.contain,
                  opacity: 0.3
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
                      'Local Leaderboard',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: 'Mikado',
                        color: Color(0xFF2F2F2F),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 28.h,),
                    Text(
                      'See Where you rank in among friends in\nyour Country',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: 'Mikado',
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Image.asset(
                        ProductImageRoutes.recapFifteenLeaderboard,
                      width: 700.w,
                      height: 440.h,
                    ),
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child:Padding(
                padding: EdgeInsets.only(bottom: 100.h),
                child: Column(
                  children: [
                    Spacer(),
                    Text(
                      'Holding your spot in the country—\ngrace kept you shining locally!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: 'Mikado',
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: Column(
            //     children: [
            //       Spacer(),
            //       SizedBox(height: 270.h,),
            //       Transform.rotate(
            //         angle: -pi/40,
            //         child: LeaderboardCard(
            //           userId: BlocProvider.of<AuthenticationBloc>(context).state.user.id,
            //           position: state
            //               .countryLeaderboard![index].position,
            //           userName: BlocProvider.of<AuthenticationBloc>(context).state.user.name,
            //           // userBadge:
            //           //     ProductImageRoutes.defaultBadge,
            //           // userLevel: state
            //           //     .globalLeaderboard![index].status,
            //           noOfCoins: state.countryLeaderboard![index].walletBalance,
            //           countryName: state.countryLeaderboard![index].country,
            //         ),
            //       ),
            //       Spacer()
            //     ],
            //   ),
            // ),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                children: [
                  Spacer(),
                  SizedBox(height: 270.h,),
                  Transform.rotate(
                    angle: -pi/40,
                    child: LeaderboardCard(
                      userId: BlocProvider.of<AuthenticationBloc>(context).state.user.id,
                      position: (state
                          .countryLeaderboard!.indexWhere((board) => board.userId == BlocProvider.of<AuthenticationBloc>(context).state.user.id) + 1),
                      userName: BlocProvider.of<AuthenticationBloc>(context).state.user.name,
                      // userBadge:
                      //     ProductImageRoutes.defaultBadge,
                      // userLevel: state
                      //     .globalLeaderboard![index].status,
                      noOfCoins: BlocProvider.of<AuthenticationBloc>(context).state.user.coinWalletBalance,
                      countryName: BlocProvider.of<AuthenticationBloc>(context).state.user.country,
                    ),
                  ),
                  Spacer()
                ],
              ),
            ),
          ],
        );
      }
    );
  }
}
