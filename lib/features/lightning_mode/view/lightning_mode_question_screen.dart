import 'dart:async';

import 'package:bible_game/features/lightning_mode/bloc/lightning_mode_bloc.dart';
import 'package:bible_game/features/lightning_mode/bloc/lightning_mode_bloc.dart';
import 'package:bible_game/features/multi_player/widget/modal/game_leaderboard.dart';
import 'package:bible_game/shared/features/multiplayer/cubit/websocket_cubit.dart';
import 'package:bible_game/shared/features/multiplayer/cubit/websocket_cubit.dart';
import 'package:bible_game/shared/utils/custom_toast.dart';
import 'package:bible_game/shared/widgets/multiplayer_widget/multiply_question_container.dart';
import 'package:bible_game_api/bible_game_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:bible_game/shared/widgets/game_summary_modal.dart';
import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/widgets/custom_toast.dart';
import '../../../shared/widgets/question_container.dart';
import '../../../shared/widgets/quit_modal.dart';
import '../../global_challenge/widget/modal/leaderboard_modal.dart';

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
  late AnimationController _animationController;
  late PageController _pageController;
  late int _currentPage;
  late int durationPerQuestion;
  bool hasTimer = true;
  int count = 0;
  DateTime? startTime;
  bool toastFlag = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // final arguments = (ModalRoute.of(context)?.settings.arguments ??
    //     <String, dynamic>{}) as Map;
    // setState(() {
    //   hasTimer = arguments['hasTimer'];
    // });

    // final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    durationPerQuestion = 8;
        // int.parse(settingsBloc.state.gamePlaySettings['normal_game_speed']);

    _initializeAnimationController(hasTimer);
  }

  @override
  void initState() {
    super.initState();
    ToastManager.init(context);
    _pageController = PageController();
    _currentPage = 0;
    startTime = DateTime.now();
  }

  void _initializeAnimationController(bool hasTimer) {
    print("DURATION: $durationPerQuestion");
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: durationPerQuestion),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (context.read<WebsocketCubit>().state.hasAnswered == false) {
          context.read<WebsocketCubit>().sendGameAnswer(
              _currentPage,
              "Skipped",
              startTime
          );
          _moveToNextPage();
        }else{
          _moveToNextPage();
        }
      }
    });
    _animationController.forward();
  }

  void _moveToNextPage() {
    final lightningGameState = BlocProvider.of<LightningModeBloc>(context).state;
    final websocketState = BlocProvider.of<WebsocketCubit>(context).state;
    context.read<WebsocketCubit>().onMoveToNextPage();
    print("MOVE TO NEXT SCREEN");
    if (_currentPage < (websocketState.questionData.length ?? 0) - 1) {
      _currentPage++;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        startTime = DateTime.now();
      });
      _animationController.reset();
      _animationController.forward();
    } else {
      _animationController.stop();
      showLeaderboardModal(context, "Lightning Mode");
      // Navigator.push(context, MaterialPageRoute(
      //   builder: (BuildContext context) => const GameLeaderboardModal(),
      // ),);
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
      child: BlocConsumer<WebsocketCubit, WebsocketState>(
        listener: (context, websocketState) {
          ///change newPlayerJoined variable to notification alert
          if((websocketState.eventType == "POSITION_UPDATED" && websocketState.newPlayerJoined)){
            CustomToast.removeOverlay();
            ToastManager.showCustomToast(
                context,
                websocketState.positionUpdate.toastNotificationMessage!
            );
          }else if((websocketState.eventType == "PLAYER_ANSWERED" && websocketState.newPlayerJoined)){
            if(websocketState.userToastMessage != null && websocketState.userToastMessage!.isNotEmpty){
              ToastManager.dismissAll();
              CustomToast.show(
                context,
                websocketState.userToastMessage!,
              );
            }
          }
       },
        builder: (context, websocketState) {
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
                  itemCount: websocketState.questionData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MultiplayerQuestionContainer(
                      rank: websocketState.userRank,
                      gameQuestion: websocketState.questionData[index],
                      animationController: _animationController,
                      currentPage: _currentPage + 1,
                      totalQuestions: websocketState.questionData.length,
                      optionSelectedCallback: (selectedOptionIndex) {
                        print("SELECTED OPTION INDEX:$selectedOptionIndex");
                        // final remainingTime = (durationPerQuestion *
                        //     (1 - _animationController.value))
                        //     .toInt();
                        context.read<WebsocketCubit>().onOptionSelected(
                          selectedOptionIndex,
                          websocketState.questionData[index],
                          index,
                          startTime
                        );
                      },
                      selectedOptionIndex: websocketState.selectedOptionIndex ?? -1,
                      isCorrectAnswer: websocketState.isCorrectAnswer ?? false,
                      hasAnswered: websocketState.hasAnswered,
                      hasTimer: false,
                      coinsGained:websocketState.coinsGained,
                      noOfCorrectAnswers: websocketState.noOfCorrectAnswers,
                      durationPerQuestion: 9,
                      skipQuestion: () {
                        _moveToNextPage();
                        soundManager.playClickSound();
                      },
                      isWhoIsWho: true,
                      gameMode: 'quickgame',
                    );
                  },
                ),
              ));
          },
      ),
    );
  }
}
