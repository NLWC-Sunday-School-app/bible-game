import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/models/question.dart';
import 'package:bible_game/widgets/nativity/question_points.dart';
import 'package:bible_game/widgets/nativity/question_timer.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../../controllers/nativity_question_controller.dart';
import 'option_button.dart';

class QuestionContainer extends StatefulWidget {
  final Question question;

  const QuestionContainer({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  State<QuestionContainer> createState() => _QuestionContainerState();
}

class _QuestionContainerState extends State<QuestionContainer> {
  final NativityQuestionController _questionController = Get.put(NativityQuestionController());
  final player = AudioPlayer();
  bool isClicked = false;

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height:  Get.width >= 500 ? 350.h : Get.height >= 800 ? 350.h : 350.h,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient:  const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:  [
                Color.fromRGBO(84, 140, 215, 1),
                Color.fromRGBO(50, 177,242, 1),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/question_screen_cloud.png',
                width: 350.w,
              ),
            ],
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.only(top: 45.h),
              child: Obx(
                () => Center(
                  child: Text(
                    "Question ${_questionController.questionNumber.value} of ${_questionController.questions.length}",
                    style: TextStyle(
                        fontFamily: 'Neuland',
                        letterSpacing: 1,
                        fontSize: 16.sp,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: Get.height < 680 ? 30 : 40 ,),
            Padding(
              padding: EdgeInsets.only(left: 22.w, right: 45.w),
              child: Text(
                'What verse was this found?',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: Get.height > 900 ? 16.sp : 14.sp
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 22.w, right: 45.w),
              child: AutoSizeText(
                '"${widget.question.question}"',
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: Get.height > 900 ? 22 : 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),

          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 305.h),
          child: Column(
            children: [
              // Text(Get.height.toString()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [QuestionTimer(), QuestionPoints()],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      ...List.generate(
                        widget.question.options.length,
                            (index) => OptionButton(
                          bibleVerse: widget.question.options[index],
                          selectOption: () =>
                          {
                            if(isClicked == false){
                              player.setAsset('assets/audios/click.mp3'),
                              player.play(),
                              _questionController.checkAnswer(widget.question, widget.question.options[index])
                            },
                             setState(() {
                               isClicked = true;
                             }),
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
         ConfettiWidget(
              confettiController: _questionController.confettiController,
              shouldLoop: false,
              blastDirectionality: BlastDirectionality.explosive,
         ),
      ],
    );
  }
}
