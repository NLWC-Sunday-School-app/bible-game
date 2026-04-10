import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_game/features/global_challenge/bloc/global_challenge_bloc.dart';
import 'package:bible_game/features/global_challenge/repository/global_challenge_repository.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/widgets/base_question_screen.dart';

import '../../../navigation/cubit/navigation_cubit.dart';
import '../../../shared/constants/app_routes.dart';
import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../shared/features/user/bloc/user_bloc.dart';
import '../../../shared/widgets/game_summary_modal.dart';
import '../../../shared/widgets/question_container.dart';

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

  void _moveToNextPage() {
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
                            gameQuestion: state.globalChallengeQuestions![index],
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
