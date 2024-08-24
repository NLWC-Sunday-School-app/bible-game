import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_bible_game/features/four_scriptures/bloc/four_scriptures_one_word_bloc.dart';
import 'package:the_bible_game/features/four_scriptures/widget/question_container.dart';
import 'package:the_bible_game/shared/features/authentication/bloc/authentication_bloc.dart';

import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../shared/widgets/quit_modal.dart';

class FourScriptureQuestionScreen extends StatefulWidget {
  const FourScriptureQuestionScreen({super.key});

  @override
  State<FourScriptureQuestionScreen> createState() =>
      _FourScriptureQuestionScreenState();
}

class _FourScriptureQuestionScreenState
    extends State<FourScriptureQuestionScreen> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentPage = 0;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  void _moveToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
      child: BlocConsumer<FourScripturesOneWordBloc, FourScripturesOneWordState>(
        listener: (context, state) {},
        builder: (context, state) {
          return  PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            itemCount: state.fourScripturesOneWordQuestions!.length,
            itemBuilder: (BuildContext context, int index) {
              return QuestionContainer(
                scriptureOne: state.fourScripturesOneWordQuestions![index].scriptureOne,
                scriptureTwo:  state.fourScripturesOneWordQuestions![index].scriptureTwo,
                scriptureThree:  state.fourScripturesOneWordQuestions![index].scriptureThree,
                scriptureFour:  state.fourScripturesOneWordQuestions![index].scriptureFour,
                answer: state.fourScripturesOneWordQuestions![index].answer,
                totalQuestions: state.totalNoOfQuestions!,
                gameLevel: BlocProvider.of<AuthenticationBloc>(context).state.user!.fourScriptsLevel,
                onTap: (){
                  soundManager.playClickSound();
                  Navigator.pop(context);
                 _moveToNextPage();
                },
              );
            },
          );
        },
      ),
    );
  }
}
