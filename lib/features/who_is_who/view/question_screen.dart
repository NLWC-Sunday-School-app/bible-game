import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_game/features/who_is_who/bloc/who_is_who_bloc.dart';
import 'package:bible_game/features/who_is_who/widget/modal/not_enough_coins_modal.dart';
import 'package:bible_game/features/who_is_who/widget/modal/wiw_time_up_modal.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/widgets/base_question_screen.dart';
import 'package:bible_game/shared/widgets/question_container.dart';
import '../../../shared/constants/app_routes.dart';
import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/features/user/bloc/user_bloc.dart';
import '../../../shared/widgets/game_summary_modal.dart';

class WhoIsWhoQuestionScreen extends StatefulWidget {
  const WhoIsWhoQuestionScreen({super.key});

  @override
  State<WhoIsWhoQuestionScreen> createState() => _WhoIsWhoQuestionScreenState();
}

class _WhoIsWhoQuestionScreenState
    extends BaseQuestionScreenState<WhoIsWhoQuestionScreen> {
  late int gameDuration;
  late int questionsRequiredToPass;
  late int gameTimePurchasePrice;

  @override
  void initState() {
    super.initState();
    final whoIsWhoBloc = BlocProvider.of<WhoIsWhoBloc>(context);
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);

    gameDuration = whoIsWhoBloc.state.gameDuration!;
    questionsRequiredToPass = int.parse(
        settingsBloc.state.gamePlaySettings['whoiswho_questions_passmark']);
    gameTimePurchasePrice = int.parse(
        settingsBloc.state.gamePlaySettings['game_time_purchase_price']);

    initQuestionControllers(
      duration: Duration(minutes: gameDuration),
      onTimerComplete: _moveToNextPage,
    );
  }

  void _moveToNextPage() {
    final wiwGameBloc = BlocProvider.of<WhoIsWhoBloc>(context);
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    advancePageByTimer(
      onGameComplete: () {
        if (wiwGameBloc.state.noOfCorrectAnswers! >= questionsRequiredToPass) {
          wiwGameBloc.add(SetUserCompletedLeveLState(true));
          showGameSummaryModal(
            context: context,
            pointEarned: wiwGameBloc.state.coinsGained!,
            bonusPoint: wiwGameBloc.state.coinsGained!,
            noOfCorrectQuestions: wiwGameBloc.state.noOfCorrectAnswers!,
            totalQuestions: wiwGameBloc.state.wiwGameQuestions!.length,
            averageTimeQuestion: (wiwGameBloc.state.totalTimeSpent! ~/
                    wiwGameBloc.state.wiwGameQuestions!.length)
                .round(),
            isWhoIsWho: true,
            isGlobalChallenge: false,
            noOfAnsweredQuestions: wiwGameBloc.state.noOfQuestionsAnswered,
            questionsRequiredToPass: questionsRequiredToPass,
            onTap: () {
              context.read<WhoIsWhoBloc>().add(ClearWhoIsWhoGameData());
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.whoIsWhoHomeScreen,
                ModalRoute.withName('/home'),
              );
            },
          );
          wiwGameBloc.add(SubmitWhoIsWhoScore());
          Future.delayed(const Duration(seconds: 2), () {
            if (!mounted) return;
            authenticationBloc.add(FetchUserDataRequested());
          });
        } else {
          wiwGameBloc.add(SetUserCompletedLeveLState(false));
          showWhoIsWhoTimeUpModal(context,
              gameTimePurchasePrice: gameTimePurchasePrice, onTap: () {
            if (authenticationBloc.state.user.coinWalletBalance >=
                gameTimePurchasePrice) {
              gameDuration = 1;
              restartAnimationController(
                duration: const Duration(minutes: 1),
                onTimerComplete: _moveToNextPage,
              );
              Navigator.pop(context);
              wiwGameBloc.add(PurchaseExtraTime(
                  authenticationBloc.state.user.id, gameTimePurchasePrice));
              Future.delayed(const Duration(seconds: 2), () {
                if (!mounted) return;
                authenticationBloc.add(FetchUserDataRequested());
              });
            } else {
              Navigator.pop(context);
              showNotEnoughCoinsModal(context, onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.whoIsWhoHomeScreen,
                  ModalRoute.withName('/home'),
                );
                wiwGameBloc.add(SubmitWhoIsWhoScore());
                Future.delayed(const Duration(seconds: 2), () {
                  if (!mounted) return;
                  authenticationBloc.add(FetchUserDataRequested());
                  BlocProvider.of<UserBloc>(context)
                      .add(FetchUserStreakDetails());
                });
              });
            }
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return withQuitProtection(
      BlocConsumer<WhoIsWhoBloc, WhoIsWhoState>(
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
                itemCount: state.wiwGameQuestions!.length,
                itemBuilder: (context, index) {
                  return QuestionContainer(
                    gameQuestion: state.wiwGameQuestions![index],
                    animationController: animationController,
                    currentPage: currentPage + 1,
                    totalQuestions: state.wiwGameQuestions!.length,
                    optionSelectedCallback: (selectedOptionIndex) {
                      context.read<WhoIsWhoBloc>().add(OptionSelected(
                            selectedOptionIndex: selectedOptionIndex,
                            gameQuestion: state.wiwGameQuestions![index],
                          ));
                    },
                    selectedOptionIndex: state.selectedOptionIndex ?? -1,
                    isCorrectAnswer: state.isCorrectAnswer ?? false,
                    hasAnswered: state.hasAnswered,
                    coinsGained: state.coinsGained!,
                    skipQuestion: _moveToNextPage,
                    isWhoIsWho: true,
                    noOfCorrectAnswers: state.noOfCorrectAnswers,
                    whoIsWhoGameDuration: gameDuration,
                    gameMode: 'whoIsWho',
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
