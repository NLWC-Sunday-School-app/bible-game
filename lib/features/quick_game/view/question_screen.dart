import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:bible_game/shared/widgets/game_summary_modal.dart';
import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/widgets/question_container.dart';
import '../../../shared/widgets/quit_modal.dart';
import '../bloc/quick_game_bloc.dart';
import '../repository/quick_game_repository.dart';

class QuickGameQuestionScreen extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;
  final QuickGameRepository quickGameRepository;

  const QuickGameQuestionScreen(
      {super.key,
      required this.authenticationBloc,
      required this.quickGameRepository});

  @override
  State<QuickGameQuestionScreen> createState() =>
      _QuickGameQuestionScreenState();
}

class _QuickGameQuestionScreenState extends State<QuickGameQuestionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late PageController _pageController;
  late int _currentPage;
  late int durationPerQuestion;
  bool hasTimer = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    setState(() {
      hasTimer = arguments['hasTimer'];
    });

    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    durationPerQuestion =
        int.parse(settingsBloc.state.gamePlaySettings['normal_game_speed']);

    _initializeAnimationController(hasTimer);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentPage = 0;
  }

  void _initializeAnimationController(bool hasTimer) {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: durationPerQuestion),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (hasTimer) {
            _moveToNextPage();
          }
        }
      });
    _animationController.forward();
  }

  void _moveToNextPage() {
    final quickGameState = BlocProvider.of<QuickGameBloc>(context).state;
    final authenticationState =
        BlocProvider.of<AuthenticationBloc>(context).state;
    if (_currentPage < (quickGameState.quickGameQuestions?.length ?? 0) - 1) {
      _currentPage++;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _animationController.reset();
      _animationController.forward();
    } else {
      _animationController.stop();

      showGameSummaryModal(
        context: context,
        pointEarned: quickGameState.coinsGained!,
        bonusPoint: quickGameState.totalBonusCoinsGained!,
        noOfCorrectQuestions: quickGameState.noOfCorrectAnswers,
        totalQuestions: quickGameState.quickGameQuestions!.length,
        averageTimeQuestion: (quickGameState.totalTimeSpent! ~/
                quickGameState.quickGameQuestions!.length)
            .round(),
        isWhoIsWho: false,
        isGlobalChallenge: false,
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
      Timer(Duration(seconds: 2), () {
        BlocProvider.of<AuthenticationBloc>(context)
            .add(FetchUserDataRequested());
        BlocProvider.of<UserBloc>(context).add(FetchUserStreakDetails());
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    Future<bool?> showWarning(BuildContext context) async => showDialog(
        barrierDismissible: true,
        barrierColor: const Color.fromRGBO(40, 40, 40, 0.9),
        context: context,
        builder: (BuildContext context) {
          return QuitModal();
        });
    return WillPopScope(
      onWillPop: () async {
        final displayDialog = await showWarning(context);
        return displayDialog ?? false;
      },
      child: BlocConsumer<QuickGameBloc, QuickGameState>(
        listener: (context, state) {
          if (state.selectedOptionIndex != -1 &&
              state.isCorrectAnswer != null) {
            Future.delayed(Duration(seconds: 1), () {
              _moveToNextPage();
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                toolbarHeight: 0,
                backgroundColor:
                    Color(0xFF998BBC), // Set background color to transparent
              ),
              body: SafeArea(
                bottom: false,
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  itemCount: state.quickGameQuestions!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return QuestionContainer(
                      gameQuestion: state.quickGameQuestions![index],
                      animationController: _animationController,
                      currentPage: _currentPage + 1,
                      totalQuestions: state.quickGameQuestions!.length,
                      optionSelectedCallback: (selectedOptionIndex) {
                        final remainingTime = (durationPerQuestion *
                                (1 - _animationController.value))
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
                    );
                  },
                ),
              ));
        },
      ),
    );
  }
}
