import 'package:bible_game_api/bible_game_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/widgets/option_button.dart';
import 'package:bible_game/shared/widgets/question_box.dart';
import 'package:bible_game/shared/widgets/question_clock.dart';
import 'package:bible_game/shared/widgets/question_number_box.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/widgets/quit_modal.dart';
import '../../../shared/widgets/coins_number_box.dart';
import '../../../shared/widgets/power_up_bar.dart';
import '../../../shared/widgets/streak_counter.dart';
import '../features/settings/bloc/settings_bloc.dart';

typedef OptionSelectedCallback = void Function(int selectedOption);

class QuestionContainer extends StatelessWidget {
  const QuestionContainer({
    super.key,
    required this.gameQuestion,
    required this.animationController,
    required this.currentPage,
    required this.totalQuestions,
    this.hasTimer = true,
    required this.optionSelectedCallback,
    required this.isCorrectAnswer,
    required this.selectedOptionIndex,
    required this.hasAnswered,
    required this.coinsGained,
    required this.skipQuestion,
    this.isWhoIsWho = false,
    this.whoIsWhoGameDuration = 0,
    this.durationPerQuestion = 0,
    this.noOfCorrectAnswers = 0,
    required this.gameMode,
    this.streakCount = 0,
    this.fiftyFiftyUsed = false,
    this.eliminatedOptionIndices = const [],
    this.onFiftyFiftyTap,
    this.fiftyFiftyCost = 20,
    this.fiftyFiftyIsFree = false,
    this.powerUpItems = const [],
    this.doubleCoinsActive = false,
  });

  final GameQuestion gameQuestion;
  final AnimationController animationController;
  final int currentPage;
  final int totalQuestions;
  final bool isCorrectAnswer;
  final int selectedOptionIndex;
  final OptionSelectedCallback optionSelectedCallback;
  final bool hasAnswered;
  final bool? isWhoIsWho;
  final bool? hasTimer;
  final int coinsGained;
  final int? whoIsWhoGameDuration;
  final VoidCallback skipQuestion;
  final int? durationPerQuestion;
  final int? noOfCorrectAnswers;
  final String gameMode;
  final int streakCount;
  final bool fiftyFiftyUsed;
  final List<int> eliminatedOptionIndices;
  final VoidCallback? onFiftyFiftyTap;
  final int fiftyFiftyCost;
  final bool fiftyFiftyIsFree;
  final List<PowerUpBarItem> powerUpItems;
  final bool doubleCoinsActive;

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(ProductImageRoutes.questionScreenBg),
        fit: BoxFit.fill,
      )),
      child: Column(
        children: [
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CoinsNumberBox(
                noOfCoins: coinsGained,
              ),
              hasTimer!
                  ? QuestionClock(
                      isWhoIsWho: isWhoIsWho,
                      whoIsWhoGameDuration: whoIsWhoGameDuration,
                      animationController: animationController,
                      durationPerQuestion: durationPerQuestion,
                    )
                  : Image.asset(
                      ProductImageRoutes.theBibleGame,
                      width: 80.w,
                    ),
              QuestionNumberBox(
                isWhoIsWho: isWhoIsWho,
                currentQuestionNumber: currentPage.toString(),
                totalQuestions: totalQuestions.toString(),
                noOfCorrectQuestions: noOfCorrectAnswers.toString(),
              )
            ],
          )),
          SizedBox(height: 4.h),
          // Combo counter — only shown in non-WhoIsWho modes
          if (!(isWhoIsWho ?? false))
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreakCounter(streakCount: streakCount),
                if (doubleCoinsActive && streakCount >= 2)
                  SizedBox(width: 6.w),
                if (doubleCoinsActive)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD400).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: const Color(0xFFFFD400).withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(IconImageRoutes.coinIcon, width: 12.w),
                        SizedBox(width: 3.w),
                        Text(
                          '2x',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFFFD400),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          SizedBox(height: streakCount >= 2 ? 4.h : 11.h),
          QuestionBox(
            isWhoIsWho: isWhoIsWho,
            instruction: gameQuestion.instruction,
            question: gameQuestion.question,
          ),
          SizedBox(height: 15.h),
          ...List.generate(gameQuestion.options.length, (index) {
            final isEliminated = eliminatedOptionIndices.contains(index);
            final isSelected = selectedOptionIndex == index;
            final isCorrect = isSelected ? isCorrectAnswer : null;
            return Opacity(
              opacity: isEliminated ? 0.3 : 1.0,
              child: IgnorePointer(
                ignoring: isEliminated,
                child: OptionButton(
                  text: gameQuestion.options[index],
                  correctAnswer: gameQuestion.answer,
                  index: index,
                  onTap: () {
                    optionSelectedCallback(index);
                  },
                  isSelected: isSelected,
                  isCorrect: isCorrect,
                  hasAnswered: hasAnswered,
                ),
              ),
            );
          }),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  soundManager.playClickSound();
                  showQuitModal(context, gameMode: gameMode);
                },
                child: Image.asset(
                  IconImageRoutes.redCircleClose,
                  width: 64.w,
                ),
              ),
              // Power-ups in the center of the action row
              if (powerUpItems.isNotEmpty)
                Expanded(
                  child: PowerUpBar(items: powerUpItems),
                )
              // Keep legacy 50/50 button for game modes that don't use new power-up bar
              else if (!(isWhoIsWho ?? false) &&
                  onFiftyFiftyTap != null)
                _LegacyPowerUpButton(
                  label: '50/50',
                  subLabel:
                      fiftyFiftyIsFree ? 'Free' : '-$fiftyFiftyCost coins',
                  isUsed: fiftyFiftyUsed,
                  hasEnoughCoins:
                      fiftyFiftyIsFree ? true : coinsGained >= fiftyFiftyCost,
                  onTap: () {
                    soundManager.playClickSound();
                    onFiftyFiftyTap!();
                  },
                ),
              isWhoIsWho!
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: skipQuestion,
                      child: Image.asset(
                        IconImageRoutes.skip,
                        width: 64.w,
                      ),
                    )
            ],
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}

/// Legacy power-up button kept for backward compatibility with other game modes
class _LegacyPowerUpButton extends StatelessWidget {
  final String label;
  final String subLabel;
  final bool isUsed;
  final bool hasEnoughCoins;
  final VoidCallback onTap;

  const _LegacyPowerUpButton({
    required this.label,
    required this.subLabel,
    required this.isUsed,
    required this.hasEnoughCoins,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool canUse = !isUsed && hasEnoughCoins;
    return GestureDetector(
      onTap: canUse ? onTap : null,
      child: Opacity(
        opacity: isUsed ? 0.35 : (hasEnoughCoins ? 1.0 : 0.5),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isUsed ? Colors.grey.shade700 : const Color(0xFF366ABC),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isUsed
                  ? Colors.grey
                  : Colors.white.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Neuland',
                ),
              ),
              Text(
                isUsed ? 'used' : subLabel,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
