import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_game/features/who_is_who/bloc/who_is_who_bloc.dart';
import 'package:bible_game/features/who_is_who/widget/modal/not_enough_coins_modal.dart';
import 'package:bible_game/features/who_is_who/widget/modal/wiw_time_up_modal.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:bible_game/shared/widgets/question_container.dart';
import '../../../shared/constants/app_routes.dart';
import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/features/user/bloc/user_bloc.dart';
import '../../../shared/widgets/game_summary_modal.dart';
import '../../../shared/widgets/quit_modal.dart';

class WhoIsWhoQuestionScreen extends StatefulWidget {
  const WhoIsWhoQuestionScreen({
    super.key,
  });

  @override
  State<WhoIsWhoQuestionScreen> createState() => _WhoIsWhoQuestionScreenState();
}

class _WhoIsWhoQuestionScreenState extends State<WhoIsWhoQuestionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late PageController _pageController;
  late int _currentPage;
  late int gameDuration;
  late int questionsRequiredToPass;
  late int gameTimePurchasePrice;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentPage = 0;

    final whoIsWhoBloc = BlocProvider.of<WhoIsWhoBloc>(context);
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    final selectedLevelDuration =  BlocProvider.of<WhoIsWhoBloc>(context).state.gameDuration;
    gameDuration = whoIsWhoBloc.state.gameDuration!;
    questionsRequiredToPass = int.parse(
        settingsBloc.state.gamePlaySettings['whoiswho_questions_passmark']);
    gameTimePurchasePrice = int.parse(
        settingsBloc.state.gamePlaySettings['game_time_purchase_price']);

    _initializeAnimationController(Duration(minutes: gameDuration));
  }

  void _initializeAnimationController(Duration duration) {
    _animationController = AnimationController(
      vsync: this,
      duration: duration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _moveToNextPage();
        }
      });
    _animationController.forward();
  }

  void _restartAnimationController(Duration duration) {
    setState(() {
      _initializeAnimationController(duration);
    });
  }

  void _moveToNextPage() {
    final wiwGameBloc = BlocProvider.of<WhoIsWhoBloc>(context);
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    if (_animationController.isAnimating) {
      _currentPage++;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _animationController.stop();
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
        Future.delayed(Duration(seconds: 2), () {
          authenticationBloc.add(FetchUserDataRequested());
        });
      } else {
        wiwGameBloc.add(SetUserCompletedLeveLState(false));
        showWhoIsWhoTimeUpModal(context,
            gameTimePurchasePrice: gameTimePurchasePrice, onTap: () {
          if (authenticationBloc.state.user.coinWalletBalance >=
              gameTimePurchasePrice) {
             gameDuration = 1;
            _restartAnimationController(Duration(minutes: 1));
            Navigator.pop(context);
            wiwGameBloc.add(PurchaseExtraTime(
                authenticationBloc.state.user.id, gameTimePurchasePrice));
            Future.delayed(Duration(seconds: 2), () {
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
              Future.delayed(Duration(seconds: 2), () {
                authenticationBloc.add(FetchUserDataRequested());
                BlocProvider.of<UserBloc>(context).add(FetchUserStreakDetails());
              });
            });
          }
        });
      }
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
      child: BlocConsumer<WhoIsWhoBloc, WhoIsWhoState>(
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
                backgroundColor: Color(0xFF998BBC), // Set background color to transparent
              ),
              body: SafeArea(
                bottom: false,
                child: PageView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _pageController,
                            itemCount: state.wiwGameQuestions!.length,
                            itemBuilder: (BuildContext context, int index) {
                return QuestionContainer(
                  gameQuestion: state.wiwGameQuestions![index],
                  animationController: _animationController,
                  currentPage: _currentPage + 1,
                  totalQuestions: state.wiwGameQuestions!.length,
                  optionSelectedCallback: (selectedOptionIndex) {
                    context.read<WhoIsWhoBloc>().add(OptionSelected(
                          selectedOptionIndex: selectedOptionIndex,
                          gameQuestion: state.wiwGameQuestions![index],
                          // remainingTime: remainingTime,
                        ));
                  },
                  selectedOptionIndex: state.selectedOptionIndex ?? -1,
                  isCorrectAnswer: state.isCorrectAnswer ?? false,
                  hasAnswered: state.hasAnswered!,
                  coinsGained: state.coinsGained!,
                  skipQuestion: () => _moveToNextPage(),
                  isWhoIsWho: true,
                  noOfCorrectAnswers: state.noOfCorrectAnswers,
                  whoIsWhoGameDuration: gameDuration, gameMode: 'whoIsWho',
                );
                            },
                          ),
              ));
        },
      ),
    );
  }
}
