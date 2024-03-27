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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import '../../services/game_service.dart';
import '../../widgets/modals/four_scriptures_guide.dart';
import '../../widgets/modals/four_scriptures_hint_modal.dart';
import '../../widgets/modals/not_enough_coins_modal.dart';
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
  bool clickable = true;

  bool _isNumeric(String str) {
    return int.tryParse(str) != null;
  }

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    fourScriptureQuestionController.noOfHintsUsed.value = GetStorage().read('4ScripturesHintUsed') ?? 0;
    displayTourGuide();
  }

  @override
  void dispose() {
    super.dispose();
    errorController?.close();
    //textEditingController.dispose();
  }

  void showCustomToast(BuildContext context, String message, String imagePath) {
    FToast fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      width: 200.w,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCCE3FF), width: 2.w),
        image: const DecorationImage(
          image: AssetImage('assets/images/aesthetics/hint_bg.png'),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/icons/coins.png',
            height: 30.w,
            width: 30.w,
          ),
          SizedBox(width: 12.w),
          Text(message,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Mikado',
                fontWeight: FontWeight.w700,
                fontSize: 15.sp
              )),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: const Duration(seconds: 2),
    );
  }

  displayTourGuide() {
    var firstTime = GetStorage().read('four_scriptures_first_time') ?? true;
    var firstTimeSeenHint = GetStorage().read('first_time_seen_hint') ?? true;
    if (firstTime) {
      Timer(const Duration(seconds: 0), () {
        Get.bottomSheet(const TourWelcomeModal(),
            isScrollControlled: true, isDismissible: false);
      });
      GetStorage().write('four_scriptures_first_time', false);
    }else{
      if(firstTimeSeenHint){
        Timer(const Duration(seconds: 0), (){
          Get.dialog(const FourScripturesHintModal());
        });
        GetStorage().write('first_time_seen_hint', false);
      }
    }
  }

  fillInputFieldWithHint() {
    if (textEditingController.text.isEmpty) {
      textEditingController.text = widget.question.answer[0].toUpperCase();
    } else {
      dynamic characters = textEditingController.text.toUpperCase().split('');
      var correctAnswer = widget.question.answer.toUpperCase();
      for (int char = 0; char < characters.length; char++) {
        if (characters[char] != correctAnswer[char]) {
          characters[char] = correctAnswer[char];
          textEditingController.text = characters.join();
          break;
        } else {
          var lengthOfInput = textEditingController.text.length;
          if (char == lengthOfInput - 1) {
            textEditingController.text =
                characters.join() + correctAnswer[char + 1];
          }
        }
      }
    }
  }

  formatString(text) {
    var splittedText = text.split(' ');
    if (_isNumeric(text[0])) {
      var newText = splittedText[0] + ' ' + splittedText[1];
      return newText + '\n' + splittedText[2];
    } else {
      if (splittedText[0] == 'Song') {
        return splittedText[0] +
            ' ' +
            splittedText[1] +
            '\n' +
            splittedText[2] +
            '\n' +
            splittedText[3];
      } else {
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
          Column(
            children: [
              Container(
                height: 130.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF366ABC),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  ),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0xFFEF798A),
                        offset: Offset(0, 8),
                        blurRadius: 0,
                        spreadRadius: -4),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            userController.soundIsOff.isFalse
                                ? userController.playGameSound()
                                : null;
                            Get.bottomSheet(
                              const FourScripturesGuide(),
                              isScrollControlled: true,
                              isDismissible: false,
                            );
                          },
                          child: Image.asset(
                            'assets/images/aesthetics/info.png',
                            width: 44.w,
                          ),
                        ),
                        const PointsCard(),
                        const QuestionNumberCard(),
                        InkWell(
                          onTap: () {
                            userController.soundIsOff.isFalse
                                ? userController.playGameSound()
                                : null;
                            Get.dialog(
                              const FourScripturesQuitModal(),
                              barrierDismissible: false,
                            );
                          },
                          child: Image.asset(
                            'assets/images/icons/close_red_white.png',
                            width: 44.w,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    )
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
                fontSize: 14.sp,
                fontFamily: 'Mikado',
                fontWeight: FontWeight.w500),
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
                  key: inputFieldKey,
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: PinCodeTextField(
                    mainAxisAlignment: MainAxisAlignment.center,
                    length: widget.question.answer.length,
                    scrollPadding: EdgeInsets.zero,
                    animationType: AnimationType.fade,
                    textCapitalization: TextCapitalization.characters,
                    textStyle: TextStyle(
                      fontSize: 18.sp,
                    ),
                    pinTheme: PinTheme(
                      fieldOuterPadding: EdgeInsets.all(1.w),
                      inactiveFillColor: Colors.white,
                      inactiveColor: const Color(0xFF598DE7),
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5.r),
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
                        userController.soundIsOff.isFalse
                            ? userController.playCorrectAnswerSound()
                            : null;
                        Get.bottomSheet(
                          CorrectAnswerModal(widget: widget),
                          isScrollControlled: true,
                        );
                        fourScriptureQuestionController.sendGameData();
                      } else {
                        userController.soundIsOff.isFalse
                            ? userController.playWrongAnswerSound()
                            : null;
                        errorController!.add(ErrorAnimationType.shake);
                        textEditingController.text = '';
                      }
                    },
                    appContext: context,
                    onChanged: (String value) {
                      print('value $value');
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 150.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      textEditingController.selection = TextSelection.collapsed(offset: textEditingController.text.length);

                      print(widget.question.answer);
                        // if (userController.myUser['coinWalletBalance'] >= fourScriptureQuestionController
                        //         .gameHintPurchasePrice.value) {
                        //   // if (fourScriptureQuestionController.noOfHintsUsed.value < 3) {
                        //   //   // await GameService.buyFromStore(
                        //   //   //     userController.myUser['id'],
                        //   //   //     fourScriptureQuestionController
                        //   //   //         .gameHintPurchasePrice.value);
                        //   //   await userController.getUserData();
                        //   //   fourScriptureQuestionController
                        //   //       .gameHintPurchasePrice.value += fourScriptureQuestionController.hintIncrementalScore.value;
                        //   //   fillInputFieldWithHint();
                        //   //   if (userController.soundIsOff.isFalse) {
                        //   //     userController.playAchievementSound();
                        //   //   }
                        //   //   fourScriptureQuestionController.noOfHintsUsed.value ++;
                        //   //   showCustomToast(context, "${fourScriptureQuestionController.noOfHintsUsed.value}/3 hint used!",
                        //   //       "assets/images/aesthetics/hint_bg.png");
                        //   //   GetStorage().write(
                        //   //       '4ScripturesHintUsed',
                        //   //       fourScriptureQuestionController
                        //   //           .noOfHintsUsed.value);
                        //   //
                        //   // }
                        // } else {
                        //
                        //   Get.dialog(
                        //       NotEnoughCoinsModal(onTap: () => Get.back(),)
                        //   );
                        // }

                    },
                    child: Obx(
                      () => Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 15.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFF1E62D4), width: fourScriptureQuestionController.noOfHintsUsed.value >= 3 ? 0.w : 3.w),
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          image: DecorationImage(
                            image: AssetImage(
                                fourScriptureQuestionController.noOfHintsUsed.value >= 3 ?
                                'assets/images/aesthetics/inactive_bg.png'
                                :'assets/images/aesthetics/blue_btn_bg.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: fourScriptureQuestionController.noOfHintsUsed.value >= 3
                            ?   Text(
                              'Hint exhausted!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Mikado',
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF6D6D6C),
                              ),
                            )
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Buy hint',
                              style: TextStyle(
                                  fontFamily: 'Mikado',
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Image.asset(
                              'assets/images/icons/coins.png',
                              width: 18.w,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Obx(
                              () => Text(
                                fourScriptureQuestionController
                                    .gameHintPurchasePrice.value
                                    .toString(),
                                style: TextStyle(
                                    fontFamily: 'Mikado',
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Container(
                  key: shareButtonKey,
                  child: GestureDetector(
                    onTap: () async {
                      userController.soundIsOff.isFalse
                          ? userController.playGameSound()
                          : null;
                      await screenshotController
                          .capture(delay: const Duration(milliseconds: 10))
                          .then((Uint8List? image) async {
                        if (image != null) {
                          final directory =
                              await getApplicationDocumentsDirectory();
                          String fileName =
                              DateTime.fromMicrosecondsSinceEpoch.toString();
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
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 20.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFFF69905), width: 2.w),
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.share,
                            color: const Color(0xFFF69905),
                            size: 25.w,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h)
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
  UserController userController = Get.put(UserController());

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
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Timer(const Duration(seconds: 1), (){
                      userController.getUserData();
                    });
                    fourScriptureQuestionController.goToNextQuestion();
                    GetStorage().write('4ScripturesHintUsed', 0);
                    fourScriptureQuestionController.setGameSettings();
                    fourScriptureQuestionController.noOfHintsUsed.value = 0;
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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
        userController.soundIsOff.isFalse
            ? userController.playGameSound()
            : null;
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  InkWell(
                    onTap: () => Get.back(),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        'assets/images/icons/blue_close.png',
                        width: 44.w,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    unFormattedScripture,
                    style: TextStyle(
                        color: const Color(0xFF548CD7),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Mikado'),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'King James Version',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      color: const Color(0xFFA7A7A7),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Obx(
                    () => bibleApiController.isLoadingBibleVerse.isTrue
                        ? Container(
                            margin: EdgeInsets.only(top: 20.h),
                            child: Center(
                              child: SizedBox(
                                  child: Image.asset(
                                      'assets/images/icons/loader.gif')),
                            ),
                          )
                        : Text(
                            bibleApiController.bibleText.value,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Mikado',
                                fontSize: 14.sp,
                                height: 1.8,
                                color: const Color(0xFF292929)),
                          ),
                  ),
                ],
              ),
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
                  fontFamily: 'Mikado',
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
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
   UserController userController = Get.put(UserController());
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(8.w),
          child: Container(
              width: 110.w,
              padding: EdgeInsets.only(left: 15.w, top: 5.h, bottom: 5.h),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(89, 141, 231, 1),
                      Color.fromRGBO(239, 121, 138, 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(36.r)),
                  border: Border.all(color: Colors.white, width: 1.5)),
              child: Obx(
                () => Text(
                  '${userController
                      .myUser['coinWalletBalance']}',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Mikado',
                      fontSize: 16.sp,
                      color: Colors.white),
                ),
              )),
        ),
        Positioned(
          top: 5,
          right: 0,
          child: Image.asset(
            'assets/images/icons/coins.png',
            width: 40.w,
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
          padding: EdgeInsets.all(8.w),
          child: Container(
              width: 110.w,
              padding: EdgeInsets.only(left: 15.w, top: 5.h, bottom: 5.h),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(89, 141, 231, 1),
                      Color.fromRGBO(239, 121, 138, 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(36.r)),
                  border: Border.all(color: Colors.white, width: 1.5)),
              child: Obx(
                () => Text(
                  '${fourScripturesOneWordController.gameLevel.value}/${fourScripturesOneWordController.totalNoOfQuestions.value}',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Mikado',
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              )),
        ),
        Positioned(
          top: 5,
          right: 0,
          child: Image.asset(
            'assets/images/scroll.png',
            width: 40.w,
          ),
        )
      ],
    );
  }
}
