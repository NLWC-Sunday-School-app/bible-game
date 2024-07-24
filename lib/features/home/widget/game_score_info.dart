import 'package:flutter/material.dart';
import 'package:the_bible_game/features/home/widget/score_info.dart';
import 'package:the_bible_game/shared/constants/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';

class GameScoreInfo extends StatelessWidget {
  const GameScoreInfo({super.key, required this.noOfCoins, required this.noOfGems, required this.noOfStreaks});
  final String? noOfCoins;
  final String? noOfGems;
  final String? noOfStreaks;

  @override
  Widget build(BuildContext context) {
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
            ),
            SizedBox(width: 5.w,),
            ScoreInfo(
              width: 77.w,
              backgroundColor: AppColors.streakBackground,
              borderColor: AppColors.streakBorder,
              shadowColor: AppColors.streakShade,
              score: noOfStreaks!,
              iconImage: IconImageRoutes.streakIcon,
              iconWidth: 14.w,
              textColor: AppColors.streakText,
            ),
          ],
        )
      ],
    );
  }
}
