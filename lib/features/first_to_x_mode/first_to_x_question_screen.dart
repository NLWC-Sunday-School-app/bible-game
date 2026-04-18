import 'dart:async';

import 'package:bible_game/features/lightning_mode/bloc/lightning_mode_bloc.dart';
import 'package:bible_game/features/multi_player/widget/modal/game_leaderboard.dart';
import 'package:bible_game/shared/features/multiplayer/cubit/websocket_cubit.dart';
import 'package:bible_game/shared/utils/custom_toast.dart';
import 'package:bible_game/shared/widgets/multiplayer_widget/multiply_question_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
// import '../../../shared/widgets/custom_toast.dart'; // DUPLICATE: using shared/utils/custom_toast.dart instead
import '../../../shared/widgets/quit_modal.dart';
import '../../../shared/widgets/modal/network_modal.dart';
import '../../shared/widgets/custom_toast.dart';

class FirstToXQuestionScreen extends StatefulWidget {

  const FirstToXQuestionScreen(
      {super.key,
      });

  @override
  State<FirstToXQuestionScreen> createState() =>
      _FirstToXQuestionScreenState();
}

class _FirstToXQuestionScreenState extends State<FirstToXQuestionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late int _currentPage;
  late int durationPerQuestion;
  bool hasTimer = true;
  int count = 0;
  DateTime? startTime;
  WebsocketConnectionStatus _lastConnectionStatus = WebsocketConnectionStatus.disconnected;
  // bool toastFlag = false; // UNUSED: commented out

  // MOVED TO INITSTATE: Previously initialized in didChangeDependencies
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   durationPerQuestion = 8;
  //   _initializeAnimationController(hasTimer);
  // }

  @override
  void initState() {
    super.initState();
    ToastManager.init(context);
    _currentPage = 0;
    startTime = DateTime.now();
    // MOVED FROM didChangeDependencies for better initialization order
    durationPerQuestion = 8;
    _initializeAnimationController(hasTimer);

    // Start animation only if game is not already finished
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final websocketState = context.read<WebsocketCubit>().state;
      if (websocketState.eventType != "GAME_FINISHED") {
        _startAnimation();
      }
    });
  }

  void _initializeAnimationController(bool hasTimer) {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: durationPerQuestion),
    )..addStatusListener((status) {
      if(status == AnimationStatus.dismissed){
        return;
      }
      if (status == AnimationStatus.completed) {
        if (context.read<WebsocketCubit>().state.hasAnswered == false) {
          context.read<WebsocketCubit>().sendGameAnswer(
              _currentPage,
              "Skipped",
              startTime
          );
          _moveToNextPage();
        }
      }
    });
  }

  void _startAnimation() {
    if (!_animationController.isAnimating) {
      _animationController.forward();
    }
  }

  void _moveToNextPage() {
    final websocketState = BlocProvider.of<WebsocketCubit>(context).state;
    context.read<WebsocketCubit>().onMoveToNextPage();
    // print("MOVE TO NEXT SCREEN"); // DEBUG: commented out
    if (_currentPage < (websocketState.questionData.length ?? 0) - 1) {
      setState(() {
        _currentPage++;
        startTime = DateTime.now();
      });
      _animationController.reset();
      _startAnimation();
    } else {
      _animationController.stop();
      gameFinished();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void gameFinished() {
    // Already disposed in dispose() method - keeping for reference
    // _animationController.dispose();
    // _pageController.dispose();
  }

  Future<bool?> showWarning(BuildContext context) async => showDialog(
      barrierDismissible: true,
      barrierColor: const Color.fromRGBO(40, 40, 40, 0.9),
      context: context,
      builder: (BuildContext context) {
        return QuitModal();
      });

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return WillPopScope(
      onWillPop: () async {
        final displayDialog = await showWarning(context);
        return displayDialog ?? false;
      },
      child: BlocConsumer<WebsocketCubit, WebsocketState>(
        listener: (context, websocketState) {
          // ========== CONNECTION STATUS MONITORING ==========
          if(websocketState.connectionStatus == WebsocketConnectionStatus.disconnected &&
              _lastConnectionStatus == WebsocketConnectionStatus.connected) {
            CustomToast.show(context, "Connection lost. Reconnecting...",
                duration: Duration(seconds: 6));
          }
          if(websocketState.connectionStatus == WebsocketConnectionStatus.connected &&
              _lastConnectionStatus == WebsocketConnectionStatus.disconnected) {
            CustomToast.show(context, "Connection restored",
                duration: Duration(seconds: 2));
          }
          if(websocketState.connectionStatus == WebsocketConnectionStatus.error) {
            showNetworkModal(context, onRetry: () {
              context.read<WebsocketCubit>().connect();
            });
          }
          _lastConnectionStatus = websocketState.connectionStatus;

          ///change newPlayerJoined variable to notification alert
          if(websocketState.eventType == "GAME_FINISHED"){
            _animationController.stop();
            // OLD APPROACH: Using Navigator.pushAndRemoveUntil - kept for reference
            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            //   builder: (BuildContext context) => const GameLeaderboardModal(selectedGroupGame: 'Lightning Mode',),
            // ), (Route)=>false
            // );
            // NEW APPROACH: Using showLeaderboardModal helper
            showLeaderboardModal(context, "Lightning Mode");
          }
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
                child: websocketState.questionData.isNotEmpty
                    ? MultiplayerQuestionContainer(
                        rank: websocketState.userRank,
                        gameQuestion: websocketState.questionData[_currentPage],
                        animationController: _animationController,
                        currentPage: _currentPage + 1,
                        totalQuestions: websocketState.questionData.length,
                        optionSelectedCallback: (selectedOptionIndex) {
                          // print("SELECTED OPTION INDEX:$selectedOptionIndex"); // DEBUG: commented out
                          context.read<WebsocketCubit>().onOptionSelected(
                              selectedOptionIndex,
                              websocketState.questionData[_currentPage],
                              _currentPage,
                              startTime
                          ).then((value){
                            Future.delayed(Duration(seconds: 1), () {
                              _moveToNextPage();
                            });
                          });
                        },
                        selectedOptionIndex: websocketState.selectedOptionIndex ?? -1,
                        isCorrectAnswer: websocketState.isCorrectAnswer ?? false,
                        hasAnswered: websocketState.hasAnswered,
                        hasTimer: true, // FIXED: was false, but animation controller is active
                        coinsGained:websocketState.coinsGained,
                        noOfCorrectAnswers: websocketState.noOfCorrectAnswers,
                        // durationPerQuestion: 6, // OLD VALUE - was mismatch with durationPerQuestion = 8
                        durationPerQuestion: durationPerQuestion, // FIXED: now uses the correct initialized value
                        skipQuestion: () {
                          _moveToNextPage();
                          soundManager.playClickSound();
                        },
                        isWhoIsWho: true,
                        gameMode: 'First to X',
                      )
                    : const SizedBox.expand(),
              ));
        },
      ),
    );
  }
}
