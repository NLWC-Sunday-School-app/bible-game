import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_game/features/pilgrim_progress/bloc/pilgrim_progress_bloc.dart';
import 'package:bible_game/features/pilgrim_progress/repository/pilgrim_progress_repository.dart';
import 'package:bible_game/features/pilgrim_progress/widget/modal/retry_modal.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/widgets/base_question_screen.dart';
import 'package:bible_game/shared/widgets/custom_toast.dart';
import 'package:bible_game/shared/widgets/power_up_bar.dart';
import 'package:bible_game/shared/widgets/question_container.dart';

import '../../../shared/constants/app_routes.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../shared/features/user/bloc/user_bloc.dart';
import '../../../shared/widgets/game_summary_modal.dart';
import '../../store/bloc/power_up_bloc.dart';
import '../../store/bloc/power_up_event.dart';
import '../../store/bloc/power_up_state.dart';
import '../../store/model/power_up.dart';
import '../widget/modal/new_rank_modal.dart';

class PilgrimQuestionScreen extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;
  final PilgrimProgressRepository pilgrimProgressRepository;

  const PilgrimQuestionScreen({
    super.key,
    required this.authenticationBloc,
    required this.pilgrimProgressRepository,
  });

  @override
  State<PilgrimQuestionScreen> createState() => _PilgrimQuestionScreenState();
}

class _PilgrimQuestionScreenState
    extends BaseQuestionScreenState<PilgrimQuestionScreen> {
  late int durationPerQuestion;

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
      duration: Duration(seconds: durationPerQuestion),
      onTimerComplete: _moveToNextPage,
    );
  }

  void _resetPowerUpsForQuestion() {
    setState(() {
      _fiftyFiftyUsed = false;
      _timeFreezeUsed = false;
      _eliminatedOptionIndices = [];
    });
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

  void _useTimeFreeze() {
    if (_timeFreezeUsed) return;
    setState(() => _timeFreezeUsed = true);
    context.read<PowerUpBloc>().add(UsePowerUp(PowerUpType.timeFreeze));
    final freezeBonus = 30.0 / durationPerQuestion;
    final newValue = (animationController.value - freezeBonus).clamp(0.0, 1.0);
    animationController.value = newValue;
    showCustomToast(context, '\u{2744} Time Freeze! +30s');
  }

  void _moveToNextPage() {
    _resetPowerUpsForQuestion();
    final state = BlocProvider.of<PilgrimProgressBloc>(context).state;
    advancePageWithReset(
      totalPages: state.pilgrimProgressQuestions?.length ?? 0,
      onGameComplete: () {
        showGameSummaryModal(
          context: context,
          pointEarned: state.coinsGained,
          bonusPoint: state.totalBonusCoinsGained!,
          noOfCorrectQuestions: state.noOfCorrectAnswers,
          totalQuestions: state.pilgrimProgressQuestions!.length,
          averageTimeQuestion: (state.totalTimeSpent! ~/
                  state.pilgrimProgressQuestions!.length)
              .round(),
          isWhoIsWho: false,
          isGlobalChallenge: false,
          onTap: () {
            context
                .read<PilgrimProgressBloc>()
                .add(FetchPilgrimProgressLevelData());
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.pilgrimProgressHomeScreen,
              ModalRoute.withName('/home'),
            );
            context.read<PilgrimProgressBloc>().add(ClearPilgrimProgressData());
          },
        );
        BlocProvider.of<PilgrimProgressBloc>(context).add(CalculateGameScore());
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
    return BlocConsumer<PilgrimProgressBloc, PilgrimProgressState>(
      listenWhen: (prev, curr) =>
          prev.selectedOptionIndex != curr.selectedOptionIndex ||
          prev.isCorrectAnswer != curr.isCorrectAnswer ||
          prev.userHasToRetry != curr.userHasToRetry ||
          prev.hasUnlockedNewRank != curr.hasUnlockedNewRank,
      buildWhen: (prev, curr) =>
          prev.selectedOptionIndex != curr.selectedOptionIndex ||
          prev.isCorrectAnswer != curr.isCorrectAnswer ||
          prev.hasAnswered != curr.hasAnswered ||
          prev.coinsGained != curr.coinsGained,
      listener: (context, state) {
        if (state.selectedOptionIndex != -1 && state.isCorrectAnswer != null) {
          Future.delayed(const Duration(seconds: 1), () {
            if (!mounted) return;
            _moveToNextPage();
          });
        }
        if (state.userHasToRetry == true) {
          showRetryLevelModal(context);
        }
        if (state.hasUnlockedNewRank == true) {
          showNewRankModal(
              context, state.newRankUnlocked!, state.newRankBadgeSrc!);
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
              _useFiftyFifty(state.pilgrimProgressQuestions![currentPage]);
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
              itemCount: state.pilgrimProgressQuestions!.length,
              itemBuilder: (context, index) {
                return QuestionContainer(
                  gameQuestion: state.pilgrimProgressQuestions![index],
                  animationController: animationController,
                  currentPage: currentPage + 1,
                  totalQuestions: state.pilgrimProgressQuestions!.length,
                  optionSelectedCallback: (selectedOptionIndex) {
                    final remainingTime =
                        (durationPerQuestion * (1 - animationController.value))
                            .toInt();
                    context.read<PilgrimProgressBloc>().add(OptionSelected(
                          selectedOptionIndex: selectedOptionIndex,
                          gameQuestion:
                              state.pilgrimProgressQuestions![index],
                          remainingTime: remainingTime,
                        ));
                  },
                  selectedOptionIndex: state.selectedOptionIndex ?? -1,
                  isCorrectAnswer: state.isCorrectAnswer ?? false,
                  hasAnswered: state.hasAnswered,
                  coinsGained: state.coinsGained,
                  skipQuestion: _moveToNextPage,
                  durationPerQuestion: durationPerQuestion,
                  gameMode: 'pilgrimProgress',
                  fiftyFiftyUsed: _fiftyFiftyUsed,
                  eliminatedOptionIndices: _eliminatedOptionIndices,
                  powerUpItems: powerUpItems,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
