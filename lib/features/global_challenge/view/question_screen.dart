import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_bible_game/features/global_challenge/bloc/global_challenge_bloc.dart';
import 'package:the_bible_game/features/global_challenge/repository/global_challenge_repository.dart';

import '../../../shared/constants/app_routes.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../shared/widgets/game_summary_modal.dart';
import '../../../shared/widgets/question_container.dart';
import '../../../shared/widgets/quit_modal.dart';

class GlobalQuestionScreen extends StatefulWidget {
  final GlobalChallengeRepository globalChallengeRepository;

  const GlobalQuestionScreen(
      {super.key, required this.globalChallengeRepository});

  @override
  State<GlobalQuestionScreen> createState() => _GlobalQuestionScreenState();
}

class _GlobalQuestionScreenState extends State<GlobalQuestionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late PageController _pageController;
  late int _currentPage;
  late int durationPerQuestion;

  void _initializeAnimationController() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: durationPerQuestion),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _moveToNextPage();
        }
      });
    _animationController.forward();
  }

  void _moveToNextPage() {
    final globalChallengeState = BlocProvider.of<GlobalChallengeBloc>(context).state;
    if(_currentPage < (globalChallengeState.globalChallengeQuestions?.length ?? 0) - 1){
      _currentPage++;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _animationController.reset();
      _animationController.forward();
    }else{
      _animationController.stop();
      showGameSummaryModal(
        context: context,
        pointEarned: globalChallengeState.coinsGained!,
        bonusPoint: globalChallengeState.totalBonusCoinsGained!,
        noOfCorrectQuestions: globalChallengeState.noOfCorrectAnswers,
        totalQuestions: globalChallengeState.globalChallengeQuestions!.length,
        averageTimeQuestion: (globalChallengeState.totalTimeSpent! ~/
            globalChallengeState.globalChallengeQuestions!.length)
            .round(),
        isWhoIsWho: false,
        onTap: () {
          context.read<GlobalChallengeBloc>().add(ClearGlobalChallengeGameData());
          Navigator.pushNamedAndRemoveUntil(context,
              AppRoutes.home, (Route<dynamic> route) => false);
        },
      );

      BlocProvider.of<GlobalChallengeBloc>(context).add(SubmitGlobalChallengeScore());
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentPage = 0;

    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    durationPerQuestion =
        int.parse(settingsBloc.state.gamePlaySettings['normal_game_speed']);
    _initializeAnimationController();
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
      child: BlocConsumer<GlobalChallengeBloc, GlobalChallengeState>(
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
            body: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: state.globalChallengeQuestions!.length,
              itemBuilder: (BuildContext context, int index) {
                return QuestionContainer(
                  gameQuestion: state.globalChallengeQuestions![index],
                  animationController: _animationController,
                  currentPage: _currentPage + 1,
                  totalQuestions: state.globalChallengeQuestions!.length,
                  optionSelectedCallback: (selectedOptionIndex) {
                    final remainingTime =
                    (durationPerQuestion * (1 - _animationController.value)).toInt();
                    context.read<GlobalChallengeBloc>().add(OptionSelected(
                      selectedOptionIndex: selectedOptionIndex,
                      gameQuestion: state.globalChallengeQuestions![index],
                      remainingTime: remainingTime,
                    ));
                  },
                  selectedOptionIndex: state.selectedOptionIndex ?? -1,
                  isCorrectAnswer: state.isCorrectAnswer ?? false,
                  hasAnswered: state.hasAnswered,
                  coinsGained: state.coinsGained!,
                  skipQuestion: () => _moveToNextPage(),
                  durationPerQuestion: durationPerQuestion,
                  isWhoIsWho: false,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
