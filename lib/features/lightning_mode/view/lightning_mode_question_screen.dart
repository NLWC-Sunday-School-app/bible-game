import 'package:bible_game/features/lightning_mode/bloc/lightning_mode_bloc.dart';
import 'package:bible_game/features/multi_player/widget/modal/game_leaderboard.dart';
import 'package:bible_game/shared/features/multiplayer/cubit/websocket_cubit.dart';
import 'package:bible_game/shared/utils/custom_toast.dart';
import 'package:bible_game/shared/widgets/multiplayer_widget/multiply_question_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/widgets/custom_toast.dart';
import '../../../shared/widgets/quit_modal.dart';
import '../../../shared/widgets/modal/network_modal.dart';

class LightningModeQuestionScreen extends StatefulWidget {

  const LightningModeQuestionScreen(
      {super.key,
      });

  @override
  State<LightningModeQuestionScreen> createState() =>
      _LightningModeQuestionScreenState();
}

class _LightningModeQuestionScreenState extends State<LightningModeQuestionScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animationController;
  late int _currentPage;
  late int durationPerQuestion;
  DateTime? startTime;
  bool _isInitialized = false;
  WebsocketConnectionStatus _lastConnectionStatus = WebsocketConnectionStatus.disconnected;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // setState(() {
    //   _lifecycleState = state.toString();
    // });

    switch (state) {
      case AppLifecycleState.resumed:
      // App is visible and responding to user input
        print('App resumed - User is back!');
        _onAppResumed();
        break;

      case AppLifecycleState.inactive:
      // App is inactive (transitioning or interrupted)
      // e.g., phone call, app switcher
        print('App inactive - Transitioning state');
        break;

      case AppLifecycleState.paused:
      // App is not visible, running in background
        print('App paused - Save your data here!');
        _onAppPaused();
        break;

      case AppLifecycleState.detached:
      // App is still in memory but detached from view
        print('App detached - About to be terminated');
        break;

      case AppLifecycleState.hidden:
      // App is hidden (iOS specific mostly)
        print('App hidden');
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ToastManager.init(context);
    _currentPage = 0;
    startTime = DateTime.now();
    durationPerQuestion = 8;
    _initializeAnimationController();

    // Load saved state and update if needed
    _loadSavedStateAndInitialize();

    // Start animation after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_animationController.isAnimating) {
        _animationController.forward();
      }
    });
  }

  Future<void> _loadSavedStateAndInitialize() async {
    // Load saved state and update page if it exists
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedPage = prefs.getInt('currentPage');

    if (savedPage != null && savedPage != _currentPage) {
      setState(() {
        _currentPage = savedPage;
        _isInitialized = true;
      });
    } else {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  void _initializeAnimationController() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    )..addStatusListener((status) {
      if(status == AnimationStatus.dismissed){
        return;
      }
      if (status == AnimationStatus.completed) {
        if (mounted && context.read<WebsocketCubit>().state.hasAnswered == false) {
          context.read<WebsocketCubit>().sendGameAnswer(
              _currentPage,
              "Skipped",
              startTime
          );
          _moveToNextPage();
        } else if (mounted) {
          _moveToNextPage();
        }
      }
    });
  }

  void _onAppPaused() async {
    print('Saving data: current_page = $_currentPage');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentPage', _currentPage);
    _animationController.stop();
  }

  void _onAppResumed() async {
    print('App resumed - Refreshing data');

    // Just resume the animation - state is already loaded
    if (mounted && _animationController.status != AnimationStatus.completed && !_animationController.isAnimating) {
      _animationController.forward();
    }
  }

  void _moveToNextPage() {
    final websocketState = BlocProvider.of<WebsocketCubit>(context).state;
    context.read<WebsocketCubit>().onMoveToNextPage();
    if (_currentPage < (websocketState.questionData.length ?? 0) - 1) {
      _animationController.stop();
      setState(() {
        _currentPage++;
        startTime = DateTime.now();
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _animationController.isCompleted) {
          _animationController.reset();
          _animationController.forward();
        }
      });
    } else {
      _animationController.stop();
      gameFinished();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  void gameFinished() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('currentPage');
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
            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            //   builder: (BuildContext context) => const GameLeaderboardModal(selectedGroupGame: 'Lightning Mode',),
            // ), (Route)=>false
            // );
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
                Color(0xFF998BBC),
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
                          context.read<WebsocketCubit>().onOptionSelected(
                            selectedOptionIndex,
                            websocketState.questionData[_currentPage],
                            _currentPage,
                            startTime
                          );
                        },
                        selectedOptionIndex: websocketState.selectedOptionIndex ?? -1,
                        isCorrectAnswer: websocketState.isCorrectAnswer ?? false,
                        hasAnswered: websocketState.hasAnswered,
                        hasTimer: true,
                        coinsGained: websocketState.coinsGained,
                        noOfCorrectAnswers: websocketState.noOfCorrectAnswers,
                        durationPerQuestion: durationPerQuestion,
                        skipQuestion: () {
                          _moveToNextPage();
                          soundManager.playClickSound();
                        },
                        isWhoIsWho: true,
                        gameMode: 'Lightning Mode',
                      )
                    : const SizedBox.expand(),
              ));
          },
      ),
    );
  }
}
