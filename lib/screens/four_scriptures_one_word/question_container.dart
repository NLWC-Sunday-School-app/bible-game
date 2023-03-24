import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bible_game/controllers/bible_api_controller.dart';
import 'package:bible_game/controllers/four_Scriptures_one_word_controller.dart';
import 'package:bible_game/controllers/four_scriptures_question_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/models/fourScripturesOneWord.dart';
import 'package:bible_game/widgets/modals/four_scriptures_quit_modal.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:screenshot/screenshot.dart';
import '../../models/question.dart';
import '../../widgets/modals/quit_modal.dart';
import '../../widgets/modals/tour_welcome_modal.dart';

class QuestionContainer extends StatefulWidget {
  const QuestionContainer({Key? key, required this.question}) : super(key: key);
  final FourScripturesOneWordQuestion question;


  @override
  State<QuestionContainer> createState() => _QuestionContainerState();
}

class _QuestionContainerState extends State<QuestionContainer> {
  FourScriptureQuestionController fourScriptureQuestionController =
      Get.put(FourScriptureQuestionController());
  UserController userController = Get.put(UserController());
  ScreenshotController screenshotController = ScreenshotController();
  StreamController<ErrorAnimationType>? errorController;
  final textEditingController = TextEditingController();
  GlobalKey scriptureTileKey = GlobalKey();
  GlobalKey inputFieldKey = GlobalKey();
  GlobalKey shareButtonKey = GlobalKey();

  bool _isNumeric(String str) {
    return int.tryParse(str) != null;
  }

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    displayTourGuide();

  }

  @override
  void dispose() {
    super.dispose();
    errorController?.close();
    //textEditingController.dispose();
  }

  displayTourGuide(){
    var firstTime = GetStorage().read('four_scriptures_first_time') ?? true;
    if(firstTime){
      Timer(const Duration(seconds: 0), () {
        Get.bottomSheet(
            const TourWelcomeModal(), isScrollControlled: true, isDismissible: false );
      });
      GetStorage().write('four_scriptures_first_time', false);
    }

  }

  formatString(text) {
    var splittedText = text.split(' ');
    if (_isNumeric(text[0])) {
      var newText = splittedText[0] + ' ' + splittedText[1];
      return newText + '\n' + splittedText[2];
    }else{
       if(splittedText[0] == 'Song'){
         return splittedText[0] + ' ' +  splittedText[1] +  '\n' + splittedText[2] + '\n' + splittedText[3];
       }else{
         return splittedText[0] + '\n' + splittedText[1];
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 110.h,
                // padding: EdgeInsets.only(bottom: Get.height < 680 ? 20.h : 80.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF548CD7),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.r),
                    bottomRight: Radius.circular(30.r),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 35.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10.h,
                    ),
                    GestureDetector(
                      onTap: () => {
                        userController.soundIsOff.isFalse ? userController.playGameSound() : null,
                        Get.dialog(const FourScripturesQuitModal(), barrierDismissible: false,)
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 20.w,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    const PointsCard(),
                    SizedBox(
                      width: 10.w,
                    ),
                    const QuestionNumberCard(),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            'Click on the scriptures to read them',
            style: TextStyle(
                color: const Color(0xFFA5A5A5),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600),
            key: scriptureTileKey,
          ),
          SizedBox(
            height: 20.h,
          ),
          Screenshot(
            controller: screenshotController,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0.w),
                  child: Row(
                    children: [
                      ScriptureBox(
                        scripture: formatString(widget.question.scriptureOne),
                        unFormattedScripture: widget.question.scriptureOne,
                      ),
                      const Spacer(),
                      ScriptureBox(
                        scripture: formatString(widget.question.scriptureTwo),
                        unFormattedScripture: widget.question.scriptureTwo,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0.w),
                  child: Row(
                    children: [
                      ScriptureBox(
                        scripture: formatString(widget.question.scriptureThree),
                        unFormattedScripture: widget.question.scriptureThree,
                      ),
                      const Spacer(),
                      ScriptureBox(

                        scripture: formatString(widget.question.scriptureFour),
                        unFormattedScripture: widget.question.scriptureFour,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  key: inputFieldKey ,
                  padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                  child: PinCodeTextField(
                    mainAxisAlignment: MainAxisAlignment.center,
                    length: widget.question.answer.length,
                    scrollPadding: EdgeInsets.zero,
                    animationType: AnimationType.fade,
                    textStyle: TextStyle(fontSize: 18.sp),
                    pinTheme: PinTheme(
                      fieldOuterPadding: EdgeInsets.all(1.w),
                      inactiveFillColor: Colors.white,
                      inactiveColor: const Color(0xFF598DE7),
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 35.w,
                      fieldWidth: 35.w,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    onCompleted: (text) {
                      var enteredAnswered = text.toLowerCase();
                      if (enteredAnswered == widget.question.answer) {
                        fourScriptureQuestionController.updateGamePoint();
                        userController.soundIsOff.isFalse ? userController.playCorrectAnswerSound() : null;
                        Get.bottomSheet(
                          CorrectAnswerModal(widget: widget),
                          isScrollControlled: true,
                        );
                        fourScriptureQuestionController.sendGameData();
                      } else {
                        userController.soundIsOff.isFalse ? userController.playWrongAnswerSound() : null;
                        errorController!.add(ErrorAnimationType.shake);
                        textEditingController.text = '';
                      }
                    },
                    appContext: context,
                    onChanged: (String value) {},
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 180.h,
          ),
          Padding(
            key: shareButtonKey,
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: GestureDetector(
              onTap: () async {
                userController.soundIsOff.isFalse ? userController.playGameSound() : null;
                await screenshotController
                    .capture(delay: const Duration(milliseconds: 10))
                    .then((Uint8List? image) async {
                  if (image != null) {
                    final directory = await getApplicationDocumentsDirectory();
                    final imagePath = File('${directory.path}/image.png');
                    await imagePath.writeAsBytes(image);

                    final box = context.findRenderObject() as RenderBox?;
                    await Share.shareFiles(
                      [imagePath.path],
                      subject: 'Can you please help me with this puzzle?',
                      sharePositionOrigin:
                          box!.localToGlobal(Offset.zero) & box.size,
                    );
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: const Color(0xFF558BD7)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ask your friends',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 14.sp),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 14.w,
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h)
        ],
      ),
    ));
  }
}



class CorrectAnswerModal extends StatefulWidget {
  const CorrectAnswerModal({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final QuestionContainer widget;

  @override
  State<CorrectAnswerModal> createState() => _CorrectAnswerModalState();
}

class _CorrectAnswerModalState extends State<CorrectAnswerModal> {
  final confettiController = ConfettiController();
  FourScriptureQuestionController fourScriptureQuestionController =
      Get.put(FourScriptureQuestionController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromRGBO(39, 97, 164, 1).withOpacity(0.8),
              const Color.fromRGBO(39, 97, 164, 0).withOpacity(0.8),
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                SizedBox(height: 100.h),
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Image.asset(
                      'assets/images/icons/thumbs_up.png',
                      width: 80.w,
                    )),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  '${widget.widget.question.answer}!',
                  style: TextStyle(
                    fontFamily: 'neuland',
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Awesome! You got the answer correctly.',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: Colors.white),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => {
                    Get.back(),
                    fourScriptureQuestionController.goToNextQuestion()
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32.r)),
                    child: Text(
                      'Tap to continue',
                      style: TextStyle(
                          fontFamily: 'neuland',
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF2761A4),
                          fontSize: 16.sp),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100.h,
                ),
              ],
            ),
            ConfettiWidget(
              confettiController: confettiController,
              shouldLoop: true,
              blastDirectionality: BlastDirectionality.explosive,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    confettiController.play();
  }
}

class ScriptureBox extends StatelessWidget {
  const ScriptureBox({
    Key? key,
    required this.scripture,
    required this.unFormattedScripture,
  }) : super(key: key);
  final String scripture;
  final String unFormattedScripture;

  @override
  Widget build(BuildContext context) {
    BibleApiController bibleApiController = Get.put(BibleApiController());
    UserController userController = Get.put(UserController());
    return GestureDetector(
      onTap: () {
        bibleApiController.formatScripture(unFormattedScripture);
        userController.soundIsOff.isFalse ? userController.playGameSound() : null;
        Get.bottomSheet(SizedBox(
          height: Get.height / 1.4,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 40.h),
                SvgPicture.asset(
                  'assets/images/icons/bottom_handle.svg',
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  unFormattedScripture,
                  style: TextStyle(
                      color: const Color(0xFF548CD7),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'neuland'),
                ),
                SizedBox(height: 10.h),
                const Text(
                  'KING JAMES VERSION',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                      color: Color(0xFFA7A7A7)),
                ),
                SizedBox(height: 20.h),
                Obx(
                      () =>
                  bibleApiController.isLoadingBibleVerse.isTrue
                      ? Container(
                    margin: EdgeInsets.only(top: 20.h),
                    child: Center(
                      child: SizedBox(
                        child: Image.asset('assets/images/icons/loader.gif')
                      ),
                    ),
                  )
                      : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: Text(
                      bibleApiController.bibleText.value,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          height: 1.8,
                          color: const Color(0xFF292929)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
      },
      child: SizedBox(
        height: 150.h,
        width: 140.w,
        child: Container(
          // padding: EdgeInsets.all(35.w),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/wooden_bg.png'),
                fit: BoxFit.fill),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                scripture,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PointsCard extends StatelessWidget {
  const PointsCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FourScriptureQuestionController fourScriptureQuestionController =
        Get.put(FourScriptureQuestionController());
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              width: 120.w,
              padding: EdgeInsets.only(left: 15.w, top: 12.h, bottom: 12.h),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(89, 141, 231, 1),
                      Color.fromRGBO(7, 79, 175, 1),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(36.r)),
                  border: Border.all(color: Colors.white, width: 1.5)),
              child: Obx(
                () => Text(
                  '${fourScriptureQuestionController.totalPointsGained.value}',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'neuland',
                      fontSize: 16.sp,
                      color: Colors.white),
                ),
              )),
        ),
        Positioned(
          top: 5,
          right: 0,
          child: Image.asset(
            'assets/images/icons/blue_star.png',
            width: 60.w,
          ),
        )
      ],
    );
  }
}

class QuestionNumberCard extends StatelessWidget {
  const QuestionNumberCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FourScripturesOneWordController fourScripturesOneWordController =
        Get.put(FourScripturesOneWordController());
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              width: 100.w,
              padding: EdgeInsets.only(left: 15.w, top: 12.h, bottom: 12.h),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(89, 141, 231, 1),
                      Color.fromRGBO(7, 79, 175, 1),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(36.r)),
                  border: Border.all(color: Colors.white, width: 1.5)),
              child: Obx(
                () => Text(
                  '${fourScripturesOneWordController.gameLevel.value}/${fourScripturesOneWordController.totalNoOfQuestions.value}',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'neuland',
                      fontSize: 16.sp,
                      color: Colors.white),
                ),
              )),
        ),
        Positioned(
          top: 5,
          right: 0,
          child: Image.asset(
            'assets/images/scroll.png',
            width: 35.w,
          ),
        )
      ],
    );
  }
}
