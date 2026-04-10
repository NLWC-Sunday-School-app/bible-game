import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_game/features/pilgrim_progress/bloc/pilgrim_progress_bloc.dart';
import 'package:bible_game/features/pilgrim_progress/repository/pilgrim_progress_repository.dart';
import 'package:bible_game/features/pilgrim_progress/widget/modal/retry_modal.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/widgets/base_question_screen.dart';
import 'package:bible_game/shared/widgets/question_container.dart';

import '../../../shared/constants/app_routes.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../shared/features/user/bloc/user_bloc.dart';
import '../../../shared/widgets/game_summary_modal.dart';
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

  void _moveToNextPage() {
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
                        (30 * (1 - animationController.value)).toInt();
                    context.read<PilgrimProgressBloc>().add(OptionSelected(
                          selectedOptionIndex: selectedOptionIndex,
                          gameQuestion: state.pilgrimProgressQuestions![index],
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
                );
              },
            ),
          ),
        );
      },
    );
  }
}
