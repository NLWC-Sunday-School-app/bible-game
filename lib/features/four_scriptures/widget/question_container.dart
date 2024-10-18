import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bible_game/features/four_scriptures/bloc/four_scriptures_one_word_bloc.dart';
import 'package:bible_game/features/four_scriptures/widget/modal/correct_answer_modal.dart';
import 'package:bible_game/features/four_scriptures/widget/modal/game_info.dart';
import 'package:bible_game/features/four_scriptures/widget/modal/tour_guide_modal.dart';
import 'package:bible_game/features/four_scriptures/widget/score_box.dart';
import 'package:bible_game/features/four_scriptures/widget/scripture_box.dart';
import 'package:bible_game/features/four_scriptures/widget/question_number_box.dart';
import 'package:bible_game/features/who_is_who/widget/modal/not_enough_coins_modal.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:bible_game/shared/widgets/quit_modal.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/constants/image_routes.dart';
import '../../../shared/features/user/bloc/user_bloc.dart';
import '../../../shared/utils/formatter.dart';
import '../../../shared/widgets/blue_button.dart';
import '../../../shared/widgets/screen_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionContainer extends StatefulWidget {
  const QuestionContainer({
    super.key,
    required this.scriptureOne,
    required this.scriptureTwo,
    required this.scriptureThree,
    required this.scriptureFour,
    required this.answer,
    required this.totalQuestions,
    required this.gameLevel,
    required this.onTap,
  });

  final String scriptureOne;
  final String scriptureTwo;
  final String scriptureThree;
  final String scriptureFour;
  final String answer;
  final int totalQuestions;
  final int gameLevel;
  final VoidCallback onTap;

  @override
  State<QuestionContainer> createState() => _QuestionContainerState();
}

class _QuestionContainerState extends State<QuestionContainer> {
  ScreenshotController screenshotController = ScreenshotController();
  StreamController<ErrorAnimationType>? errorController;
  final textEditingController = TextEditingController();
  GlobalKey scriptureTileKey = GlobalKey();
  GlobalKey inputFieldKey = GlobalKey();
  GlobalKey shareButtonKey = GlobalKey();
  bool clickable = true;
  late int gameHintPurchasePrice;
  late int hintIncrementalScore;
  late int noOfHintsUsed;

  getGameData() async {
    final settingsState = BlocProvider.of<SettingsBloc>(context).state;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    noOfHintsUsed = await prefs.getInt('4ScripturesHintUsed') ?? 0;
    gameHintPurchasePrice =
        int.parse(settingsState.gamePlaySettings['game_time_purchase_price']);
    hintIncrementalScore =
        int.parse(settingsState.gamePlaySettings['hint_incremental_score']);
    BlocProvider.of<FourScripturesOneWordBloc>(context)
        .add(SetGameData(gameHintPurchasePrice, noOfHintsUsed));
  }

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    getGameData();
    displayTourGuide();
  }

  displayTourGuide() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = await prefs.getBool('four_scriptures_first_time') ?? true;
    if (firstTime) {
      Timer(Duration(seconds: 0), () {
        showFourScripturesOneWordTourGuidModal(context);
      });
      await prefs.setBool('four_scriptures_first_time', false);
    }
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
          image: AssetImage(ProductImageRoutes.hintBg),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            IconImageRoutes.coinIcon,
            height: 30.w,
            width: 30.w,
          ),
          SizedBox(width: 12.w),
          Text(message,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
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

  fillInputFieldWithHint() {
    if (textEditingController.text.isEmpty) {
      textEditingController.text = widget.answer[0].toUpperCase();
    } else {
      dynamic characters = textEditingController.text.toUpperCase().split('');
      var correctAnswer = widget.answer.toUpperCase();
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

  @override
  void dispose() {
    super.dispose();
    errorController?.close();
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = BlocProvider.of<SettingsBloc>(context).soundManager;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: AppColors.primaryColorShade,// Status bar color
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child:
          Column(
            children: [
              ScreenAppBar(
                widgets: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          soundManager.playClickSound();
                          showQuitModal(context, gameMode: 'fourScriptures');
                        },
                        child: Image.asset(
                          IconImageRoutes.arrowCircleBack,
                          width: 40.w,
                        ),
                      ),
                      Spacer(),
                      BlocBuilder<AuthenticationBloc, AuthenticationState>(
                        builder: (context, state) {
                          return ScoreBox(
                            coinsAvailable: state.user.coinWalletBalance,
                          );
                        },
                      ),
                      QuestionNumberBox(
                        totalQuestions: widget.totalQuestions,
                        gameLevel: widget.gameLevel,
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          soundManager.playClickSound();
                          showFourScripturesOneWordInfo(context);
                        },
                        child: Image.asset(
                          IconImageRoutes.infoCircle,
                          width: 40.w,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                'Click on the scriptures to read them',
                style: TextStyle(
                  color: const Color(0xFFA5A5A5),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Screenshot(
                controller: screenshotController,
                child: Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: SizedBox(
                          height: 390.h,
                          child: GridView.count(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 40,
                            children: [
                              ScriptureBox(
                                scripture:
                                    formatScriptureString(widget.scriptureOne),
                                unFormattedScripture: widget.scriptureOne,
                              ),
                              ScriptureBox(
                                scripture:
                                    formatScriptureString(widget.scriptureTwo),
                                unFormattedScripture: widget.scriptureTwo,
                              ),
                              ScriptureBox(
                                scripture:
                                    formatScriptureString(widget.scriptureThree),
                                unFormattedScripture: widget.scriptureThree,
                              ),
                              ScriptureBox(
                                scripture:
                                    formatScriptureString(widget.scriptureFour),
                                unFormattedScripture: widget.scriptureFour,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      child: PinCodeTextField(
                        mainAxisAlignment: MainAxisAlignment.center,
                        length: widget.answer.length,
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
                          String enteredAnswer = text.toLowerCase();
                          print(widget.answer);
                          if (enteredAnswer == widget.answer) {
                            soundManager.playCorrectAnswerSound();
                            showCorrectAnswerBottomSheetModal(
                                context, widget.answer, widget.onTap);
                            BlocProvider.of<FourScripturesOneWordBloc>(context)
                                .add(UpdateGameLevel());
                            BlocProvider.of<FourScripturesOneWordBloc>(context)
                                .add(SendGameData());
                            Future.delayed(Duration(seconds: 1), () {
                              BlocProvider.of<AuthenticationBloc>(context)
                                  .add(FetchUserDataRequested());
                              BlocProvider.of<UserBloc>(context).add(FetchUserStreakDetails());
                            });
                          } else {
                            errorController!.add(ErrorAnimationType.shake);
                            textEditingController.text = '';
                            soundManager.playWrongAnswerSound();
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
                height: 70.h,
              ),
              // Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<FourScripturesOneWordBloc,
                      FourScripturesOneWordState>(
                    builder: (context, state) {
                      return BlueButton(
                        buttonText: '',
                        isActive: state.noOfHintsUsed >= 3 ? false : true,
                        buttonIsLoading: false,
                        width: 250.w,
                        onTap: () async {
                          soundManager.playClickSound();
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          textEditingController.selection =
                              TextSelection.collapsed(
                                  offset: textEditingController.text.length);
                          final coinBalance =
                              BlocProvider.of<AuthenticationBloc>(context)
                                  .state
                                  .user
                                  .coinWalletBalance;
                          if (coinBalance >= gameHintPurchasePrice) {
                            if (noOfHintsUsed < 3) {
                              BlocProvider.of<FourScripturesOneWordBloc>(context)
                                  .add(PurchaseHint(gameHintPurchasePrice));
                              Future.delayed(Duration(seconds: 1), () {
                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(FetchUserDataRequested());
                              });
                              gameHintPurchasePrice += hintIncrementalScore;
                              fillInputFieldWithHint();
                              soundManager.playAchievementSound();
                              noOfHintsUsed++;
                              BlocProvider.of<FourScripturesOneWordBloc>(context)
                                  .add(SetGameData(
                                      gameHintPurchasePrice, noOfHintsUsed));
                              showCustomToast(
                                  context,
                                  "$noOfHintsUsed/3 hint used",
                                  ProductImageRoutes.hintBg);
                              prefs.setInt('4ScripturesHintUsed', noOfHintsUsed);
                            } else {
                              // await prefs.remove('4ScripturesHintUsedd');
                              // await prefs.remove('4ScripturesHintUsed');
                            }
                          } else {
                            showNotEnoughCoinsModal(context, onTap: () {
                              soundManager.playClickSound();
                              Navigator.pop(context);
                            });
                          }
                        },
                        customText: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.noOfHintsUsed >= 3
                                  ? 'Hint exhausted!'
                                  : 'Buy hint',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: state.noOfHintsUsed >= 3
                                    ? const Color(0xFF6D6D6C)
                                    : Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            state.noOfHintsUsed >= 3
                                ? SizedBox()
                                : Image.asset(
                                    IconImageRoutes.coinIcon,
                                    width: 18.w,
                                  ),
                            SizedBox(
                              width: 5.w,
                            ),
                            state.noOfHintsUsed >= 3
                                ? SizedBox()
                                : Text(
                                    state.gameHintPurchasePrice.toString(),
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: () async {
                        soundManager.playClickSound();
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
              SizedBox(
                height: 140.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
