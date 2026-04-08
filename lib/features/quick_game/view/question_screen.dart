import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/widgets/base_question_screen.dart';
import 'package:bible_game/shared/widgets/game_summary_modal.dart';
import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/widgets/custom_toast.dart';
import '../../../shared/widgets/question_container.dart';
import '../bloc/quick_game_bloc.dart';
import '../repository/quick_game_repository.dart';

class QuickGameQuestionScreen extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;
  final QuickGameRepository quickGameRepository;

  const QuickGameQuestionScreen({
    super.key,
    required this.authenticationBloc,
    required this.quickGameRepository,
  });

  @override
  State<QuickGameQuestionScreen> createState() =>
      _QuickGameQuestionScreenState();
}

class _QuickGameQuestionScreenState
    extends BaseQuestionScreenState<QuickGameQuestionScreen> {
  late int durationPerQuestion;
  bool hasTimer = true;
  bool _initialized = false;
  late ConfettiController _confettiController;

  static const _streakMilestones = {3, 5, 7, 10};

  // Floating coin pop state
  int _prevCoins = 0;
  bool _showCoinPop = false;
  int _lastCoinGain = 0;
  Key _coinPopKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _triggerCoinPop(int gain) {
    setState(() {
      _lastCoinGain = gain;
      _coinPopKey = UniqueKey();
      _showCoinPop = true;
    });
    Future.delayed(const Duration(milliseconds: 850), () {
      if (mounted) setState(() => _showCoinPop = false);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    hasTimer = arguments['hasTimer'];

    durationPerQuestion = int.parse(
      BlocProvider.of<SettingsBloc>(context)
          .state
          .gamePlaySettings['normal_game_speed'],
    );

    initQuestionControllers(
      duration: Duration(seconds: durationPerQuestion),
      onTimerComplete: hasTimer ? _moveToNextPage : null,
    );
  }

  void _moveToNextPage() {
    // Reset bloc state (hasAnswered, fiftyFiftyUsed, eliminatedOptions, etc.)
    BlocProvider.of<QuickGameBloc>(context).add(MoveToNextPage());
    final state = BlocProvider.of<QuickGameBloc>(context).state;
    advancePageWithReset(
      totalPages: state.quickGameQuestions?.length ?? 0,
      onGameComplete: () {
        showGameSummaryModal(
          context: context,
          pointEarned: state.coinsGained!,
          bonusPoint: state.totalBonusCoinsGained!,
          noOfCorrectQuestions: state.noOfCorrectAnswers,
          totalQuestions: state.quickGameQuestions!.length,
          averageTimeQuestion:
              (state.totalTimeSpent! ~/ state.quickGameQuestions!.length)
                  .round(),
          isWhoIsWho: false,
          isGlobalChallenge: false,
          bestStreak: state.bestStreak,
          onTap: () {
            BlocProvider.of<QuickGameBloc>(context).add(ClearQuickGameData());
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.quickGameHomeScreen,
              ModalRoute.withName('/home'),
            );
          },
        );
        BlocProvider.of<QuickGameBloc>(context).add(SubmitQuickGameScore());
        Timer(const Duration(seconds: 2), () {
          if (!mounted) return;
          BlocProvider.of<AuthenticationBloc>(context)
              .add(FetchUserDataRequested());
          BlocProvider.of<UserBloc>(context).add(FetchUserStreakDetails());
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return withQuitProtection(
      Stack(
        children: [
          BlocConsumer<QuickGameBloc, QuickGameState>(
            listenWhen: (prev, curr) =>
                prev.selectedOptionIndex != curr.selectedOptionIndex ||
                prev.isCorrectAnswer != curr.isCorrectAnswer ||
                prev.currentStreak != curr.currentStreak,
            buildWhen: (prev, curr) =>
                prev.selectedOptionIndex != curr.selectedOptionIndex ||
                prev.isCorrectAnswer != curr.isCorrectAnswer ||
                prev.hasAnswered != curr.hasAnswered ||
                prev.coinsGained != curr.coinsGained ||
                prev.currentStreak != curr.currentStreak ||
                prev.fiftyFiftyUsed != curr.fiftyFiftyUsed ||
                prev.eliminatedOptionIndices != curr.eliminatedOptionIndices,
            listener: (context, state) {
              if (state.selectedOptionIndex != -1 &&
                  state.isCorrectAnswer != null) {
                // Floating coin pop on correct answer
                if (state.isCorrectAnswer == true) {
                  final gain = (state.coinsGained ?? 0) - _prevCoins;
                  if (gain > 0) _triggerCoinPop(gain);
                }
                _prevCoins = state.coinsGained ?? 0;

                Future.delayed(const Duration(seconds: 1), () {
                  if (!mounted) return;
                  _moveToNextPage();
                });
              }
              // Fire confetti + toast on streak milestones
              if (_streakMilestones.contains(state.currentStreak)) {
                _confettiController.play();
                showCustomToast(
                    context, '🔥 x${state.currentStreak} Streak!');
              }
            },
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  toolbarHeight: 0,
                  backgroundColor: AppColors.questionScreenBar,
                ),
                body: SafeArea(
                  bottom: false,
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    itemCount: state.quickGameQuestions!.length,
                    itemBuilder: (context, index) {
                      return QuestionContainer(
                        key: ValueKey(index),
                        gameQuestion: state.quickGameQuestions![index],
                        animationController: animationController,
                        currentPage: currentPage + 1,
                        totalQuestions: state.quickGameQuestions!.length,
                        optionSelectedCallback: (selectedOptionIndex) {
                          final remainingTime = (durationPerQuestion *
                                  (1 - animationController.value))
                              .toInt();
                          context.read<QuickGameBloc>().add(OptionSelected(
                                selectedOptionIndex: selectedOptionIndex,
                                gameQuestion: state.quickGameQuestions![index],
                                remainingTime: remainingTime,
                              ));
                        },
                        selectedOptionIndex: state.selectedOptionIndex ?? -1,
                        isCorrectAnswer: state.isCorrectAnswer ?? false,
                        hasAnswered: state.hasAnswered,
                        coinsGained: state.coinsGained!,
                        skipQuestion: () {
                          _moveToNextPage();
                          soundManager.playClickSound();
                        },
                        durationPerQuestion: durationPerQuestion,
                        hasTimer: hasTimer,
                        gameMode: 'quickGame',
                        streakCount: state.currentStreak,
                        fiftyFiftyUsed: state.fiftyFiftyUsed,
                        eliminatedOptionIndices: state.eliminatedOptionIndices,
                        fiftyFiftyIsFree: true,
                        onFiftyFiftyTap: () {
                          context.read<QuickGameBloc>().add(UseFiftyFifty(
                              gameQuestion:
                                  state.quickGameQuestions![index]));
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 20,
              maxBlastForce: 20,
              minBlastForce: 8,
              emissionFrequency: 0.05,
              colors: const [
                Colors.yellow,
                Colors.orange,
                Colors.green,
                Colors.blue,
                Colors.purple,
              ],
            ),
          ),
          // Floating coin pop overlay
          if (_showCoinPop)
            Positioned(
              bottom: 220.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  key: _coinPopKey,
                  child: Text(
                    '🪙 +$_lastCoinGain',
                    style: TextStyle(
                      color: const Color(0xFFFFD700),
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Neuland',
                      shadows: const [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 150.ms)
                      .move(
                        begin: Offset.zero,
                        end: const Offset(0, -60),
                        duration: 700.ms,
                        curve: Curves.easeOut,
                      )
                      .fadeOut(delay: 500.ms, duration: 200.ms),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
