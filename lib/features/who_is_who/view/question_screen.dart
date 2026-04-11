import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_game/features/who_is_who/bloc/who_is_who_bloc.dart';
import 'package:bible_game/features/who_is_who/widget/modal/not_enough_coins_modal.dart';
import 'package:bible_game/features/who_is_who/widget/modal/wiw_time_up_modal.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/widgets/base_question_screen.dart';
import 'package:bible_game/shared/widgets/power_up_bar.dart';
import 'package:bible_game/shared/widgets/question_container.dart';
import '../../../shared/constants/app_routes.dart';
import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/features/user/bloc/user_bloc.dart';
import '../../../shared/widgets/custom_toast.dart';
import '../../../shared/widgets/game_summary_modal.dart';
import '../../store/bloc/power_up_bloc.dart';
import '../../store/bloc/power_up_event.dart';
import '../../store/bloc/power_up_state.dart';
import '../../store/model/power_up.dart';

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

  // Power-up local state (per question)
  bool _fiftyFiftyUsed = false;
  bool _timeFreezeUsed = false;
  List<int> _eliminatedOptionIndices = [];

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

  void _resetPowerUpsForQuestion() {
    setState(() {
      _fiftyFiftyUsed = false;
      _eliminatedOptionIndices = [];
      // Time Freeze is NOT reset per question — it's one-time for the whole game
    });
  }

  void _useTimeFreeze() {
    if (_timeFreezeUsed) return;
    setState(() => _timeFreezeUsed = true);
    context.read<PowerUpBloc>().add(UsePowerUp(PowerUpType.timeFreeze));
    // Add 30 seconds to the game-wide timer
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
          // Build power-up items from store inventory (50/50 only for game-wide timer modes)
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
                _useFiftyFifty(state.wiwGameQuestions![currentPage]);
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
