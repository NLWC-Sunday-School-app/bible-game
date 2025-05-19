import 'package:bible_game/shared/widgets/tablet_view_widget/coins_number_box_tablet_view.dart';
import 'package:bible_game/shared/widgets/tablet_view_widget/option_button_tablet_view.dart';
import 'package:bible_game/shared/widgets/tablet_view_widget/question_box_tablet_view.dart';
import 'package:bible_game/shared/widgets/tablet_view_widget/question_clock_tablet_view.dart';
import 'package:bible_game/shared/widgets/tablet_view_widget/question_number_box_tablet_view.dart';
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
import '../../features/settings/bloc/settings_bloc.dart';

typedef OptionSelectedCallback = void Function(int selectedOption);

class QuestionContainerTabletView extends StatelessWidget {
  const QuestionContainerTabletView({
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
          Padding(
            padding: EdgeInsets.only(left: 40.w,right: 40.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            CoinsNumberBoxTabletView(
              noOfCoins: coinsGained,
            ),
            hasTimer!
                ? QuestionClockTabletView(
                    isWhoIsWho: isWhoIsWho,
                    whoIsWhoGameDuration: whoIsWhoGameDuration,
                    animationController: animationController,
                    durationPerQuestion: durationPerQuestion,
                  )
                : Image.asset(
                    ProductImageRoutes.theBibleGame,
                    width: 180.w,
                  ),
            QuestionNumberBoxTabletView(
              isWhoIsWho: isWhoIsWho,
              currentQuestionNumber: currentPage.toString(),
              totalQuestions: totalQuestions.toString(),
              noOfCorrectQuestions: noOfCorrectAnswers.toString(),
            )
              ],
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          QuestionBoxTabletView(
            isWhoIsWho: isWhoIsWho,
            instruction: gameQuestion.instruction,
            question: gameQuestion.question,
          ),
          SizedBox(
            height: 30.h,
          ),
          ...List.generate(gameQuestion.options.length, (index) {
            final isSelected = selectedOptionIndex == index;
            final isCorrect = isSelected ? isCorrectAnswer : null;
            return OptionButtonTabletView(
              text: gameQuestion.options[index],
              correctAnswer: gameQuestion.answer,
              index: index,
              onTap: () {
                optionSelectedCallback(index);
              },
              isSelected: isSelected,
              isCorrect: isCorrect,
              hasAnswered: hasAnswered,
            );
          }),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(left: 60.w,right: 60.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                isWhoIsWho!
                    ? SizedBox()
                    : GestureDetector(
                        onTap: skipQuestion,
                        child: Image.asset(
                          IconImageRoutes.skip,
                          width: 64.w,
                        ),
                      )
              ],
            ),
          ),
          SizedBox(
            height: 100.h,
          ),
        ],
      ),
    );
  }
}
