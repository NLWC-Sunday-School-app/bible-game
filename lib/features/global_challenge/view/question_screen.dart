import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_game/features/global_challenge/bloc/global_challenge_bloc.dart';
import 'package:bible_game/features/global_challenge/repository/global_challenge_repository.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/widgets/base_question_screen.dart';
import 'package:bible_game/shared/widgets/power_up_bar.dart';

import '../../../navigation/cubit/navigation_cubit.dart';
import '../../../shared/constants/app_routes.dart';
import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../shared/features/user/bloc/user_bloc.dart';
import '../../../shared/widgets/custom_toast.dart';
import '../../../shared/widgets/game_summary_modal.dart';
import '../../../shared/widgets/question_container.dart';
import '../../store/bloc/power_up_bloc.dart';
import '../../store/bloc/power_up_event.dart';
import '../../store/bloc/power_up_state.dart';
import '../../store/model/power_up.dart';

class GlobalQuestionScreen extends StatefulWidget {
  final GlobalChallengeRepository globalChallengeRepository;

  const GlobalQuestionScreen(
      {super.key, required this.globalChallengeRepository});

  @override
  State<GlobalQuestionScreen> createState() => _GlobalQuestionScreenState();
}

class _GlobalQuestionScreenState
    extends BaseQuestionScreenState<GlobalQuestionScreen> {
  late int durationPerQuestion;
  final int gameDuration = 2;

  // Power-up local state (per question)
  bool _fiftyFiftyUsed = false;
  bool _timeFreezeUsed = false;
  List<int> _eliminatedOptionIndices = [];

  @override
  void initState() {
    super.initState();
    durationPerQuestion = int.parse(
      BlocProvider.of<SettingsBloc>(context)
          .state
          .gamePlaySettings['normal_game_speed'],
    );
    initQuestionControllers(
      duration: Duration(minutes: gameDuration),
      onTimerComplete: _moveToNextPage,
    );
  }

  void _resetPowerUpsForQuestion() {
    setState(() {
      _fiftyFiftyUsed = false;
      _eliminatedOptionIndices = [];
    });
  }

  void _useTimeFreeze() {
    if (_timeFreezeUsed) return;
    setState(() => _timeFreezeUsed = true);
    context.read<PowerUpBloc>().add(UsePowerUp(PowerUpType.timeFreeze));
    // Add 30 seconds to the game-wide 2-minute timer
    // value goes 0→1, so subtract to add time back
    final totalSeconds = gameDuration * 60;
    final freezeBonus = 30.0 / totalSeconds;
    final newValue = (animationController.value - freezeBonus).clamp(0.0, 1.0);
    animationController.value = newValue;
    showCustomToast(context, '\u{2744} Time Freeze! +30s');
  }

  void _useFiftyFifty(gameQuestion) {
    if (_fiftyFiftyUsed) return;
    final options = gameQuestion.options;
    final correctAnswer = gameQuestion.answer;
    final wrongIndices = <int>[];
    for (int i = 0; i < options.length; i++) {
      if (options[i] != correctAnswer) wrongIndices.add(i);
    }
    wrongIndices.shuffle(Random());
    final toEliminate = wrongIndices.take(2).toList();
    setState(() {
      _fiftyFiftyUsed = true;
      _eliminatedOptionIndices = toEliminate;
    });
    context.read<PowerUpBloc>().add(UsePowerUp(PowerUpType.fiftyFifty));
  }

  void _moveToNextPage() {
    _resetPowerUpsForQuestion();
    final state = BlocProvider.of<GlobalChallengeBloc>(context).state;
    advancePageByTimer(
      onGameComplete: () {
        showGameSummaryModal(
          context: context,
          pointEarned: state.coinsGained!,
          bonusPoint: state.totalBonusCoinsGained!,
          noOfCorrectQuestions: state.noOfCorrectAnswers,
          totalQuestions: state.globalChallengeQuestions!.length,
          averageTimeQuestion: (state.totalTimeSpent! ~/
                  state.globalChallengeQuestions!.length)
              .round(),
          isGlobalChallenge: true,
          isWhoIsWho: false,
          onTap: () {
            context
                .read<GlobalChallengeBloc>()
                .add(ClearGlobalChallengeGameData());
            Navigator.pushReplacementNamed(context, AppRoutes.home);
            context.read<NavigationCubit>().selectTab(3);
          },
        );
        BlocProvider.of<GlobalChallengeBloc>(context)
            .add(SubmitGlobalChallengeScore());
        Future.delayed(const Duration(seconds: 2), () {
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
    return withQuitProtection(
      BlocConsumer<GlobalChallengeBloc, GlobalChallengeState>(
        listenWhen: (prev, curr) =>
            prev.selectedOptionIndex != curr.selectedOptionIndex ||
            prev.isCorrectAnswer != curr.isCorrectAnswer,
        buildWhen: (prev, curr) =>
            prev.selectedOptionIndex != curr.selectedOptionIndex ||
            prev.isCorrectAnswer != curr.isCorrectAnswer ||
            prev.hasAnswered != curr.hasAnswered ||
            prev.coinsGained != curr.coinsGained,
        listener: (context, state) {
          if (state.selectedOptionIndex != -1 &&
              state.isCorrectAnswer != null) {
            Future.delayed(const Duration(seconds: 1), () {
              if (!mounted) return;
              _moveToNextPage();
            });
          }
        },
        builder: (context, state) {
          // Build power-up items from store inventory
          final powerUpState = context.watch<PowerUpBloc>().state;
          final powerUpItems = <PowerUpBarItem>[
            PowerUpBarItem(
              label: '50/50',
              iconPath: IconImageRoutes.star,
              quantity: powerUpState.getQuantity(PowerUpType.fiftyFifty),
              isUsed: _fiftyFiftyUsed,
              accentColor: const Color(0xFFFF6B6B),
              onTap: () {
                if (state.hasAnswered) return;
                _useFiftyFifty(state.globalChallengeQuestions![currentPage]);
              },
            ),
            PowerUpBarItem(
              label: 'Freeze',
              iconPath: IconImageRoutes.greenTimer,
              quantity: powerUpState.getQuantity(PowerUpType.timeFreeze),
              isUsed: _timeFreezeUsed,
              accentColor: const Color(0xFF54D6FF),
              onTap: () {
                if (state.hasAnswered) return;
                _useTimeFreeze();
              },
            ),
          ];

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
                itemCount: state.globalChallengeQuestions!.length,
                itemBuilder: (context, index) {
                  return QuestionContainer(
                    gameQuestion: state.globalChallengeQuestions![index],
                    animationController: animationController,
                    currentPage: currentPage + 1,
                    totalQuestions: state.globalChallengeQuestions!.length,
                    optionSelectedCallback: (selectedOptionIndex) {
                      context.read<GlobalChallengeBloc>().add(OptionSelected(
                            selectedOptionIndex: selectedOptionIndex,
                            gameQuestion:
                                state.globalChallengeQuestions![index],
                          ));
                    },
                    selectedOptionIndex: state.selectedOptionIndex ?? -1,
                    isCorrectAnswer: state.isCorrectAnswer ?? false,
                    hasAnswered: state.hasAnswered,
                    coinsGained: state.coinsGained!,
                    skipQuestion: _moveToNextPage,
                    durationPerQuestion: durationPerQuestion,
                    isWhoIsWho: true,
                    gameMode: 'globalchallenge',
                    noOfCorrectAnswers: state.noOfCorrectAnswers,
                    whoIsWhoGameDuration: gameDuration,
                    fiftyFiftyUsed: _fiftyFiftyUsed,
                    eliminatedOptionIndices: _eliminatedOptionIndices,
                    powerUpItems: powerUpItems,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
