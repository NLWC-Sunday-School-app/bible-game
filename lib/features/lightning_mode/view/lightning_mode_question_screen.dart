import 'dart:async';

import 'package:bible_game/features/lightning_mode/bloc/lightning_mode_bloc.dart';
import 'package:bible_game/features/lightning_mode/bloc/lightning_mode_bloc.dart';
import 'package:bible_game/shared/features/multiplayer/cubit/websocket_cubit.dart';
import 'package:bible_game/shared/features/multiplayer/cubit/websocket_cubit.dart';
import 'package:bible_game/shared/widgets/multiplayer_widget/multiply_question_container.dart';
import 'package:bible_game_api/bible_game_api.dart';
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

class LightningModeQuestionScreen extends StatefulWidget {

  const LightningModeQuestionScreen(
      {super.key,
      });

  @override
  State<LightningModeQuestionScreen> createState() =>
      _LightningModeQuestionScreenState();
}

class _LightningModeQuestionScreenState extends State<LightningModeQuestionScreen>
    with SingleTickerProviderStateMixin {
  // late AnimationController _animationController;
  late PageController _pageController;
  late int _currentPage;
  late int durationPerQuestion;
  bool hasTimer = true;
  int count = 0;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // final arguments = (ModalRoute.of(context)?.settings.arguments ??
    //     <String, dynamic>{}) as Map;
    // setState(() {
    //   hasTimer = arguments['hasTimer'];
    // });

    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    durationPerQuestion =
        int.parse(settingsBloc.state.gamePlaySettings['normal_game_speed']);

    // _initializeAnimationController(hasTimer);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentPage = 0;
  }

  // void _initializeAnimationController(bool hasTimer) {
  //   print("DURATION: $durationPerQuestion");
  //   _animationController = AnimationController(
  //     vsync: this,
  //     duration: Duration(seconds: durationPerQuestion),
  //   )..addStatusListener((status) {
  //     if (status == AnimationStatus.completed) {
  //       if (hasTimer) {
  //         _moveToNextPage();
  //       }
  //     }
  //   });
  //   _animationController.forward();
  // }

  void _moveToNextPage() {
    final lightningGameState = BlocProvider.of<LightningModeBloc>(context).state;
    final authenticationState =
        BlocProvider.of<AuthenticationBloc>(context).state;
    print("MOVE TO NEXT SCREEN");
    if (true) {
      _currentPage++;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );} else {

      // _animationController.stop();

      showGameSummaryModal(
        context: context,
        pointEarned: lightningGameState.coinsGained,
        bonusPoint: 10,
        noOfCorrectQuestions: lightningGameState.noOfCorrectAnswers,
        totalQuestions: BlocProvider.of<WebsocketCubit>(context).state.questionData.length,
        averageTimeQuestion: 10,
        isWhoIsWho: false,
        isGlobalChallenge: false,
        onTap: () {
          // BlocProvider.of<QuickGameBloc>(context).add(ClearQuickGameData());
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.quickGameHomeScreen,
            ModalRoute.withName('/home'),
          );
        },
      );
      //
      // BlocProvider.of<QuickGameBloc>(context).add(SubmitQuickGameScore());
      // Timer(Duration(seconds: 2), () {
      //   BlocProvider.of<AuthenticationBloc>(context)
      //       .add(FetchUserDataRequested());
      //   BlocProvider.of<UserBloc>(context).add(FetchUserStreakDetails());
      // });
    }
  }

  @override
  void dispose() {
    // _animationController.dispose();
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
      child: BlocConsumer<LightningModeBloc, LightningModeState>(
        listener: (context, lightningModeState) {
          count++;
          print("LISTENING: $count");
          // _moveToNextPage();
          if ( lightningModeState.selectedOptionIndex != -1 && lightningModeState.isCorrectAnswer !=null
             ) {
            Future.delayed(Duration(seconds: 1), () {
              _moveToNextPage();
            });
          }
       },
        builder: (context, lightningModeState) {
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                toolbarHeight: 0,
                backgroundColor:
                Color(0xFF998BBC), // Set background color to transparent
              ),
              body: SafeArea(
                bottom: false,
                child: BlocBuilder<WebsocketCubit, WebsocketState>(
                  builder: (context, websocketState) {
                    print("WEBSOCKET:${websocketState.questionData.length}");
                    return PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      itemCount: websocketState.questionData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MultiplayerQuestionContainer(
                          gameQuestion: websocketState.questionData[index],
                          animationController: null,
                          currentPage: _currentPage + 1,
                          totalQuestions: websocketState.questionData.length,
                          optionSelectedCallback: (selectedOptionIndex) {
                            print("SELECTED OPTION INDEX:$selectedOptionIndex");
                            // final remainingTime = (durationPerQuestion *
                            //     (1 - _animationController.value))
                            //     .toInt();
                            context.read<LightningModeBloc>().add(OptionSelected(
                              selectedOptionIndex: selectedOptionIndex,
                              gameQuestion: websocketState.questionData[index],
                              // remainingTime: remainingTime,
                            ));
                          },
                          selectedOptionIndex: lightningModeState.selectedOptionIndex ?? -1,
                          isCorrectAnswer: lightningModeState.isCorrectAnswer ?? false,
                          hasAnswered: lightningModeState.hasAnswered,
                          hasTimer: false,
                          coinsGained:lightningModeState.coinsGained,
                          skipQuestion: () {
                            _moveToNextPage();
                            soundManager.playClickSound();
                          },
                          // isWhoIsWho: true,
                          gameMode: 'quickgame',
                        );
                      },
                    );
                    },
                ),
              ));
          },
      ),
    );
  }
}
