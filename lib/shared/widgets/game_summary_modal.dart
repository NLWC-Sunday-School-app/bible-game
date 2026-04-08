import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';
import 'package:stroke_text/stroke_text.dart';
import '../constants/image_routes.dart';

// ---------------------------------------------------------------------------
// Public API — unchanged
// ---------------------------------------------------------------------------

void showGameSummaryModal({
  BuildContext? context,
  int? pointEarned,
  int? bonusPoint,
  int? noOfCorrectQuestions,
  int? questionsRequiredToPass,
  int? totalQuestions,
  int? noOfAnsweredQuestions,
  int? averageTimeQuestion,
  required bool isWhoIsWho,
  required bool isGlobalChallenge,
  required VoidCallback onTap,
  int? bestStreak,
}) {
  showDialog(
    barrierDismissible: false,
    barrierColor: AppColors.modalBarrierLight,
    context: context!,
    builder: (_) => Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      insetAnimationCurve: Curves.bounceInOut,
      insetAnimationDuration: const Duration(milliseconds: 500),
      child: GameSummaryModal(
        pointsEarned: pointEarned.toString(),
        bonusPoint: bonusPoint.toString(),
        noOfCorrectionQuestions: noOfCorrectQuestions.toString(),
        totalQuestions: totalQuestions.toString(),
        questionsRequiredToPass: questionsRequiredToPass.toString(),
        averageTimePerQuestion: averageTimeQuestion.toString(),
        noOfAnsweredQuestions: noOfAnsweredQuestions.toString(),
        onTap: onTap,
        isWhoIsWhoGame: isWhoIsWho,
        isGlobalChallenge: isGlobalChallenge,
        bestStreak: bestStreak,
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Internal game-mode discriminator
// ---------------------------------------------------------------------------

enum _GameMode { standard, whoIsWho, globalChallenge }

// ---------------------------------------------------------------------------
// Main modal widget
// ---------------------------------------------------------------------------

class GameSummaryModal extends StatelessWidget {
  const GameSummaryModal({
    super.key,
    required this.pointsEarned,
    this.bonusPoint,
    this.noOfCorrectionQuestions,
    this.totalQuestions,
    this.noOfAnsweredQuestions,
    this.averageTimePerQuestion,
    required this.onTap,
    this.isWhoIsWhoGame = false,
    this.isGlobalChallenge = false,
    this.questionsRequiredToPass,
    this.bestStreak,
  });

  final String? pointsEarned;
  final String? bonusPoint;
  final String? questionsRequiredToPass;
  final String? noOfCorrectionQuestions;
  final String? noOfAnsweredQuestions;
  final String? totalQuestions;
  final String? averageTimePerQuestion;
  final bool isWhoIsWhoGame;
  final bool isGlobalChallenge;
  final VoidCallback onTap;
  final int? bestStreak;

  _GameMode get _mode {
    if (isWhoIsWhoGame) return _GameMode.whoIsWho;
    if (isGlobalChallenge) return _GameMode.globalChallenge;
    return _GameMode.standard;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight <= 700 ? 550.h : 500.h,
      child: Container(
        height: 450.h,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ProductImageRoutes.gameSummaryBg),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 80.h),
            Image.asset(ProductImageRoutes.threeStars, width: 180.w),
            SizedBox(height: 15.h),
            _EarnedCoinsBox(pointsEarned: pointsEarned!),
            _BonusRow(bonusPoint: bonusPoint, mode: _mode),
            SizedBox(height: 20.h),
            _StatsRow(
              mode: _mode,
              noOfCorrectionQuestions: noOfCorrectionQuestions,
              noOfAnsweredQuestions: noOfAnsweredQuestions,
              totalQuestions: totalQuestions,
              averageTimePerQuestion: averageTimePerQuestion,
            ),
            if (bestStreak != null && bestStreak! > 0) ...[
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B3800),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🔥', style: TextStyle(fontSize: 13.sp)),
                    SizedBox(width: 4.w),
                    Text(
                      'Best Streak: x$bestStreak',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                        fontFamily: 'Neuland',
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 30.h),
            BlueButton(
              onTap: onTap,
              buttonText: 'Go home',
              buttonIsLoading: false,
              width: 235.w,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _EarnedCoinsBox extends StatelessWidget {
  const _EarnedCoinsBox({required this.pointsEarned});

  final String pointsEarned;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2.w, color: AppColors.summaryBorderBlue),
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      width: 180.w,
      child: Column(
        children: [
          Text(
            'You earned',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.summaryBorderBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(IconImageRoutes.coinIcon, width: 30.w),
              SizedBox(width: 10.w),
              StrokeText(
                text: pointsEarned,
                textStyle: TextStyle(
                  color: AppColors.summaryCoinText,
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w900,
                ),
                strokeColor: Colors.white,
                strokeWidth: 5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shows the bonus-point badge only for standard games.
class _BonusRow extends StatelessWidget {
  const _BonusRow({required this.bonusPoint, required this.mode});

  final String? bonusPoint;
  final _GameMode mode;

  @override
  Widget build(BuildContext context) {
    if (mode != _GameMode.standard) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(width: 2.w, color: AppColors.summaryBonusBorder),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.r),
          bottomRight: Radius.circular(12.r),
        ),
      ),
      width: 150.w,
      child: Text(
        'Bonus point: +$bonusPoint',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.summaryBonusBorder,
          fontWeight: FontWeight.w700,
          fontSize: 13.sp,
        ),
      ),
    );
  }
}

/// Shows correct-answer count and (for standard games) time-per-question.
class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.mode,
    required this.noOfCorrectionQuestions,
    required this.noOfAnsweredQuestions,
    required this.totalQuestions,
    required this.averageTimePerQuestion,
  });

  final _GameMode mode;
  final String? noOfCorrectionQuestions;
  final String? noOfAnsweredQuestions;
  final String? totalQuestions;
  final String? averageTimePerQuestion;

  String get _questionsLabel {
    switch (mode) {
      case _GameMode.globalChallenge:
        return '$noOfCorrectionQuestions';
      case _GameMode.whoIsWho:
        return '$noOfCorrectionQuestions/$noOfAnsweredQuestions';
      case _GameMode.standard:
        return '$noOfCorrectionQuestions/$totalQuestions';
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(IconImageRoutes.blueCircleMark, width: 24.w),
          SizedBox(width: 10.w),
          Column(
            children: [
              Text(
                _questionsLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColors.summaryStatsText,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'questions',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.summaryStatsText,
                ),
              ),
            ],
          ),
          if (mode == _GameMode.standard) ...[
            SizedBox(width: 10.w),
            VerticalDivider(
              color: AppColors.summaryBonusBorder,
              thickness: 2.w,
            ),
            SizedBox(width: 10.w),
            Image.asset(IconImageRoutes.timer, width: 24.w),
            SizedBox(width: 10.w),
            Column(
              children: [
                Text(
                  ': ${averageTimePerQuestion}s',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: AppColors.summaryStatsText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'per question',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.summaryStatsText,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
