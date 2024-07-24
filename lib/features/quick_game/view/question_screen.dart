import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_bible_game/shared/features/settings/bloc/settings_bloc.dart';
import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/widgets/question_container.dart';
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
    if (_currentPage <
        (BlocProvider.of<QuickGameBloc>(context)
                    .state
                    .quickGameQuestions
                    ?.length ??
                0) -
            1) {
      _currentPage++;

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _animationController.reset();
      _animationController.forward();
    } else {
      print("End of questions");
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
    return BlocConsumer<QuickGameBloc, QuickGameState>(
      listener: (context, state) {
        if (state.selectedOptionIndex != -1 && state.isCorrectAnswer != null) {
          Future.delayed(Duration(seconds: 1), () {
            _moveToNextPage();
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: PageView.builder(
          controller: _pageController,
          itemCount: state.quickGameQuestions!.length,
          itemBuilder: (BuildContext context, int index) {
            return QuestionContainer(
              gameQuestion: state.quickGameQuestions![index],
              animationController: _animationController,
              currentPage: _currentPage + 1,
              totalQuestions: state.quickGameQuestions!.length,
              optionSelectedCallback: (selectedOptionIndex) {
                final remainingTime =
                    (30 * (1 - _animationController.value)).toInt();
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
            );
          },
        ));
      },
    );
  }
}
