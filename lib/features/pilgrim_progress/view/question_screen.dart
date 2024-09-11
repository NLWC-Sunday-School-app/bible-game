import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_bible_game/features/pilgrim_progress/bloc/pilgrim_progress_bloc.dart';
import 'package:the_bible_game/features/pilgrim_progress/repository/pilgrim_progress_repository.dart';
import 'package:the_bible_game/features/pilgrim_progress/widget/modal/retry_modal.dart';
import 'package:the_bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:the_bible_game/shared/widgets/question_container.dart';

import '../../../shared/constants/app_routes.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../shared/widgets/game_summary_modal.dart';
import '../widget/modal/new_rank_modal.dart';

class PilgrimQuestionScreen extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;
  final PilgrimProgressRepository pilgrimProgressRepository;
  const PilgrimQuestionScreen({super.key, required this.authenticationBloc, required this.pilgrimProgressRepository});

  @override
  State<PilgrimQuestionScreen> createState() => _PilgrimQuestionScreenState();
}

class _PilgrimQuestionScreenState extends State<PilgrimQuestionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late PageController _pageController;
  late int _currentPage;
  late int durationPerQuestion;

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
    final pilgrimProgressState = BlocProvider.of<PilgrimProgressBloc>(context).state;
    if (_currentPage < (pilgrimProgressState.pilgrimProgressQuestions?.length ?? 0) - 1) {
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
        pointEarned: pilgrimProgressState.coinsGained,
        bonusPoint: pilgrimProgressState.totalBonusCoinsGained!,
        noOfCorrectQuestions: pilgrimProgressState.noOfCorrectAnswers,
        totalQuestions:  pilgrimProgressState.pilgrimProgressQuestions!.length,
        averageTimeQuestion: (pilgrimProgressState.totalTimeSpent! ~/
            pilgrimProgressState.pilgrimProgressQuestions!.length)
            .round(),
        isWhoIsWho: false,
        onTap:  () {
          context.read<PilgrimProgressBloc>().add(FetchPilgrimProgressLevelData());
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.pilgrimProgressHomeScreen,
            ModalRoute.withName('/home'),
          );
          context.read<PilgrimProgressBloc>().add(ClearPilgrimProgressData());
        },
      );
      BlocProvider.of<PilgrimProgressBloc>(context).add(CalculateGameScore());
      Timer(Duration(seconds: 2), (){
        BlocProvider.of<AuthenticationBloc>(context).add(FetchUserDataRequested());
      });
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PilgrimProgressBloc, PilgrimProgressState>(
  listener: (context, state) {
    if (state.selectedOptionIndex != -1 &&
        state.isCorrectAnswer != null) {
      Future.delayed(Duration(seconds: 1), () {
        _moveToNextPage();
      });
    }
    if(state.userHasToRetry == true){
      showRetryLevelModal(context);
    }
    if(state.hasUnlockedNewRank == true){
      showNewRankModal(context, state.newRankUnlocked!, state.newRankBadgeSrc!);
    }
  },
  builder: (context, state) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          itemCount: state.pilgrimProgressQuestions!.length,
        itemBuilder: (BuildContext context, int index) {
          return QuestionContainer(
            gameQuestion: state.pilgrimProgressQuestions![index],
            animationController: _animationController,
              currentPage: _currentPage + 1,
            totalQuestions: state.pilgrimProgressQuestions!.length,
            optionSelectedCallback: (selectedOptionIndex){
              final remainingTime = (30 * (1 - _animationController.value)).toInt();
              context.read<PilgrimProgressBloc>().add(OptionSelected(
                selectedOptionIndex: selectedOptionIndex,
                gameQuestion: state.pilgrimProgressQuestions![index],
                remainingTime: remainingTime,
              ));
            },
            selectedOptionIndex: state.selectedOptionIndex ?? -1,
            isCorrectAnswer: state.isCorrectAnswer ?? false,
            hasAnswered: state.hasAnswered,
            coinsGained: state.coinsGained,
            skipQuestion: () => _moveToNextPage(),
            durationPerQuestion: durationPerQuestion, gameMode: 'pilgrimProgress',

          );
        }
      ),
    );
  },
);
  }
}
