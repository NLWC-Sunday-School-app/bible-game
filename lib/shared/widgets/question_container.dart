import 'package:bible_game_api/bible_game_api.dart';
import 'package:flutter/material.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';
import 'package:the_bible_game/shared/widgets/option_button.dart';
import 'package:the_bible_game/shared/widgets/question_box.dart';
import 'package:the_bible_game/shared/widgets/question_clock.dart';
import 'package:the_bible_game/shared/widgets/question_number_box.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/widgets/coins_number_box.dart';

typedef OptionSelectedCallback = void Function(
    int selectedOption);

class QuestionContainer extends StatelessWidget {
  const QuestionContainer(
      {super.key,
      required this.gameQuestion,
      required this.animationController,
      required this.currentPage,
      required this.totalQuestions,
      required this.optionSelectedCallback, required this.isCorrectAnswer, required this.selectedOptionIndex, required this.hasAnswered, required this.coinsGained});

  final GameQuestion gameQuestion;
  final AnimationController animationController;
  final int currentPage;
  final int totalQuestions;
  final bool isCorrectAnswer;
  final int selectedOptionIndex;
  final OptionSelectedCallback optionSelectedCallback;
  final bool hasAnswered;
  final int coinsGained;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(ProductImageRoutes.questionScreenBg),
        fit: BoxFit.cover,
      )),
      child: Column(
        children: [
          SizedBox(
            height: 50.h,
          ),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CoinsNumberBox(noOfCoins: coinsGained,),
              QuestionClock(
                animationController: animationController,
              ),
              QuestionNumberBox(
                currentQuestionNumber: currentPage.toString(),
                totalQuestions: totalQuestions.toString(),
              )
            ],
          )),
          SizedBox(
            height: 15.h,
          ),
          QuestionBox(
            instruction: gameQuestion.instruction,
            question: gameQuestion.question,
          ),
          SizedBox(
            height: 15.h,
          ),
          ...List.generate(
              gameQuestion.options.length,
              (index) {
                final isSelected = selectedOptionIndex == index;
                final isCorrect = isSelected ? isCorrectAnswer : null;
                return OptionButton(
                    text: gameQuestion.options[index],
                    correctAnswer: gameQuestion.answer,
                    index: index,
                    onTap: () {
                      optionSelectedCallback(index);
                    },
                  isSelected: isSelected,
                  isCorrect: isCorrect,
                  hasAnswered: hasAnswered ,

                  );}
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                IconImageRoutes.redCircleClose,
                width: 64.w,
              ),
              Image.asset(
                IconImageRoutes.skip,
                width: 64.w,
              ),
            ],
          ),
          SizedBox(
            height: 30.h,
          ),
        ],
      ),
    );
  }
}
