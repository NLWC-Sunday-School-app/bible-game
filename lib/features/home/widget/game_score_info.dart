import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_bible_game/features/home/widget/modals/coins_modal.dart';
import 'package:the_bible_game/features/home/widget/modals/gems_modal.dart';
import 'package:the_bible_game/features/home/widget/score_info.dart';
import 'package:the_bible_game/shared/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';
import 'package:the_bible_game/shared/features/authentication/bloc/authentication_bloc.dart';

import '../../../shared/features/settings/bloc/settings_bloc.dart';
import 'modals/bg_streak_modal.dart';

class GameScoreInfo extends StatelessWidget {
  const GameScoreInfo(
      {super.key,
      required this.noOfCoins,
      required this.noOfGems,
      required this.noOfStreaks});

  final String? noOfCoins;
  final String? noOfGems;
  final String? noOfStreaks;

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    final authState = context.read<AuthenticationBloc>().state;
    return Column(
      children: [
        ScoreInfo(
          width: 160.w,
          backgroundColor: AppColors.scoreBackground,
          borderColor: AppColors.scoreBorder,
          shadowColor: AppColors.scoreShade,
          score: noOfCoins!,
          iconImage: IconImageRoutes.coinIcon,
          iconWidth: 20.w,
          textColor: AppColors.scoreText,
          onTap: () {
            soundManager.playClickSound();
            if(authState.user.id != 0){
              showCoinsModal(context);
            }

          },
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            ScoreInfo(
              width: 77.w,
              backgroundColor: AppColors.gemBackground,
              borderColor: AppColors.gemBorder,
              shadowColor: AppColors.gemShade,
              score: noOfGems!,
              iconImage: IconImageRoutes.gemIcon,
              iconWidth: 22.w,
              textColor: AppColors.gemText,
              onTap: () {
                soundManager.playClickSound();
                if(authState.user.id != 0){
                  showGemsModal(context);
                }

              },
            ),
            SizedBox(
              width: 5.w,
            ),
            ScoreInfo(
              width: 77.w,
              backgroundColor: AppColors.streakBackground,
              borderColor: AppColors.streakBorder,
              shadowColor: AppColors.streakShade,
              score: noOfStreaks!,
              iconImage: IconImageRoutes.streakIcon,
              iconWidth: 14.w,
              textColor: AppColors.streakText,
              onTap: () {
                soundManager.playClickSound();
                if(authState.user.id != 0){
                  showStreakModal(context);
                }

              },
            ),
          ],
        )
      ],
    );
  }
}
