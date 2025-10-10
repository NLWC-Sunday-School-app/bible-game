import 'dart:ui';

import 'package:bible_game/shared/features/multiplayer/cubit/websocket_cubit.dart';
import 'package:bible_game/shared/widgets/multiplayer_widget/multiplayer_question_count_down.dart';
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
import 'package:screenshot/screenshot.dart';
import '../../../shared/widgets/coins_number_box.dart';
import '../../features/settings/bloc/settings_bloc.dart';
import '../multi_avatar.dart';
import 'multiplayer_question_clock.dart';
import 'multiply_question_number_box.dart';

typedef OptionSelectedCallback = void Function(int selectedOption);

class MultiplayerQuestionContainer extends StatelessWidget {
  const MultiplayerQuestionContainer({
    super.key,
    required this.gameQuestion,
    this.animationController,
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
    this.rank= 0,
    this.noOfCorrectAnswers = 0,
    required this.gameMode,
  });

  final Datum gameQuestion;
  final AnimationController? animationController;
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
  final int? rank;
  final int? noOfCorrectAnswers;
  final String gameMode;

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return Container(
      padding: EdgeInsets.only(left: 13, right: 13),
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ProductImageRoutes.questionScreenBg),
            fit: BoxFit.cover,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CoinsNumberBox(
                    noOfCoins: coinsGained,
                  ),
                  // hasTimer!
                  //     ?
                  // MultiplayerQuestionClock(
                  //   survival: isWhoIsWho,
                  //   whoIsWhoGameDuration: whoIsWhoGameDuration,
                  //   animationController: animationController,
                  //   durationPerQuestion: durationPerQuestion,
                  // )
                  //     :
                  // false
                  //     ?
                  // Container(
                  //   height: 60.h,
                  //   width: 60.h,
                  //   decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //       image: AssetImage(ProductImageRoutes.xPoint)
                  //     )
                  //   ),
                  //   child: Stack(
                  //     children: [
                  //       Align(
                  //         alignment: Alignment.bottomCenter,
                  //         child: Container(
                  //           height: 24.h,
                  //           decoration: BoxDecoration(
                  //               color: Colors.white,
                  //             border: Border.all(
                  //               color: Color(0xFFF0C38A),
                  //               width: 2
                  //             ),
                  //             borderRadius: BorderRadius.circular(20)
                  //           ),
                  //           child: Center(
                  //             child: Text(
                  //               "100 pts",
                  //               textAlign: TextAlign.center,
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.w700,
                  //                 fontSize: 12.sp,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   )
                  // )
                  // :
                  //     SizedBox.shrink(),

                  Expanded(
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          height: 40.h,
                          width: 40.w,
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFEE6352),
                              border: Border.all(color: Color(0xFFD7402D), width: 2)
                          ),
                          child: Center(
                            child: AvatarWidget(seed: context.read<WebsocketCubit>().state.playersJoined.players[0].userId.toString(), width: 40.w, height: 40.h,),
                          ),
                        ),
                        ...List.generate(
                          (context.read<WebsocketCubit>().state.playersJoined.totalPlayers! - 1)>=3?3:(context.read<WebsocketCubit>().state.playersJoined.totalPlayers! - 1),
                                (index) => Positioned(
                                  right: 25.w * (index+1),
                                  child: Container(
                                    height: 40.h,
                                    width: 40.w,
                                    padding: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFEE6352),
                                        border: Border.all(color: Color(0xFFD7402D), width: 2)
                                    ),
                                    child: Center(
                                      child: AvatarWidget(seed: context.read<WebsocketCubit>().state.playersJoined.players[(index+1)].userId.toString(), width: 40.w, height: 40.h,),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  )
                ],
              )
          ),
          Row(
            children: [
              Container(
                height: 70.h,
                width: 70.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ProductImageRoutes.completedUser),
                    fit: BoxFit.cover
                  )
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 5.w,
                      bottom: 0,
                      child: Container(
                        height: 40.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(ProductImageRoutes.completedUserBall),
                                fit: BoxFit.cover
                            )
                        ),
                        child: Center(
                          child: Text(
                            "$rank",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), // semi-transparent
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 5.h,),
                    Padding(
                      padding: EdgeInsets.only(left: 15.w,right: 15.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MultiplayerQuestionNumberBox(
                            isWhoIsWho: isWhoIsWho,
                            currentQuestionNumber: currentPage.toString(),
                            totalQuestions: totalQuestions.toString(),
                            noOfCorrectQuestions: noOfCorrectAnswers.toString(),
                          ),

                          MultiplayerQuestionCountDown(
                            animationController: animationController!,
                            durationPerQuestion: durationPerQuestion,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    QuestionBox(
                      isWhoIsWho: isWhoIsWho,
                      instruction: gameQuestion.instruction!,
                      question: gameQuestion.question!,
                    ),

                    ...List.generate(gameQuestion.options.length, (index) {
                      final isSelected = selectedOptionIndex == index;
                      final isCorrect = isSelected ? isCorrectAnswer : null;
                      return OptionButton(
                        text: gameQuestion.options[index],
                        correctAnswer: gameQuestion.correctOption!,
                        index: index,
                        onTap: () {
                          optionSelectedCallback(index);
                        },
                        isSelected: isSelected,
                        isCorrect: isCorrect,
                        hasAnswered: hasAnswered,
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          Spacer(),
          Row(
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
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }
}
