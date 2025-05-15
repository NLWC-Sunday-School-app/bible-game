import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';
import 'package:stroke_text/stroke_text.dart';
import '../constants/image_routes.dart';

void showGameSummaryModal(
    {BuildContext? context,
    int? pointEarned,
    int? bonusPoint,
    int? noOfCorrectQuestions,
    int? questionsRequiredToPass,
    int? totalQuestions,
    int? noOfAnsweredQuestions,
    int? averageTimeQuestion,
    required bool isWhoIsWho,
    required bool isGlobalChallenge,
    required VoidCallback onTap}) {
  showDialog(
      barrierDismissible: false,
      barrierColor: const Color.fromRGBO(40, 40, 40, 0.9),
      context: context!,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          insetAnimationCurve: Curves.bounceInOut,
          insetAnimationDuration: const Duration(milliseconds: 500),
          child: GameSummaryModal(
            pointsEarned: pointEarned.toString(),
            bonusPoint: bonusPoint.toString(),
            noOfCorrectionQuestions: noOfCorrectQuestions.toString(),
            totalQuestions: totalQuestions.toString(),
            questionsRequiredToPass: questionsRequiredToPass.toString(),
            averageTimePerQuestion: averageTimeQuestion.toString(),
            noOfAnsweredQuestions: noOfAnsweredQuestions.toString(),
            onTap: onTap,
            isWhoIsWhoGame: isWhoIsWho,
            isGlobalChallenge: isGlobalChallenge,
          ),
        );
      });
}

class GameSummaryModal extends StatelessWidget {
  const GameSummaryModal(
      {super.key,
      required this.pointsEarned,
      this.bonusPoint,
      this.noOfCorrectionQuestions,
      this.totalQuestions,
      this.noOfAnsweredQuestions,
      this.averageTimePerQuestion,
      required this.onTap,
      this.isWhoIsWhoGame = false,
      this.isGlobalChallenge = false,
      this.questionsRequiredToPass});

  final String? pointsEarned;
  final String? bonusPoint;
  final String? questionsRequiredToPass;
  final String? noOfCorrectionQuestions;
  final String? noOfAnsweredQuestions;
  final String? totalQuestions;
  final String? averageTimePerQuestion;
  final bool isWhoIsWhoGame;
  final bool isGlobalChallenge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: screenHeight <= 700 ? 550.h : 500.h,
      child: Container(
        height: 450.h,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ProductImageRoutes.gameSummaryBg),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 80.h,
            ),
            Image.asset(
              ProductImageRoutes.threeStars,
              width: 180.w,
            ),
            SizedBox(
              height: 15.h,
            ),
            Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(width: 2.w, color: const Color(0xFF306DB6)),
                  borderRadius: BorderRadius.all(Radius.circular(8.r))),
              padding: EdgeInsets.symmetric(vertical: 8.h),
              width: 180.w,
              child: Column(
                children: [
                  Text(
                    'You earned',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF306DB6),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        IconImageRoutes.coinIcon,
                        width: 30.w,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      StrokeText(
                        text: pointsEarned!,
                        textStyle: TextStyle(
                          color: const Color(0xFF1768B9),
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w900,
                        ),
                        strokeColor: Colors.white,
                        strokeWidth: 5,
                      ),
                    ],
                  )
                ],
              ),
            ),
            isWhoIsWhoGame || isGlobalChallenge
                ? SizedBox()
                : Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2.w, color: const Color(0xFF0B5DB0)),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12.r),
                            bottomRight: Radius.circular(12.r))),
                    width: 150.w,
                    child: Text(
                      'Bonus point: +$bonusPoint',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF0B5DB0),
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
            SizedBox(
              height: 20.h,
            ),
            IntrinsicHeight(
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      IconImageRoutes.blueCircleMark,
                      width: 24.w,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      children: [
                        isGlobalChallenge!
                            ? Text(
                                '${noOfCorrectionQuestions}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    color: const Color(0xFF0155AF),
                                    fontWeight: FontWeight.w700
                                ),
                              )
                            : Text(
                                isWhoIsWhoGame!
                                    ? '${noOfCorrectionQuestions}/$noOfAnsweredQuestions'
                                    : '$noOfCorrectionQuestions/$totalQuestions',
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    color: const Color(0xFF0155AF),
                                    fontWeight: FontWeight.w700),
                              ),
                        Text(
                          'questions',
                          style: TextStyle(
                              fontSize: 13.sp, color: const Color(0xFF0155AF)),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    isWhoIsWhoGame! || isGlobalChallenge!
                        ? SizedBox()
                        : VerticalDivider(
                            color: const Color(0xFF0B5DB0),
                            thickness: 2.w,
                          ),
                    SizedBox(
                      width: 10.w,
                    ),
                    isWhoIsWhoGame! || isGlobalChallenge!
                        ? SizedBox()
                        : Image.asset(
                            IconImageRoutes.timer,
                            width: 24.w,
                          ),
                    SizedBox(
                      width: 10.w,
                    ),
                    isWhoIsWhoGame! || isGlobalChallenge!
                        ? SizedBox()
                        : Column(
                            children: [
                              Text(
                                ': ${averageTimePerQuestion}s',
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    color: const Color(0xFF0155AF),
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'per question',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: const Color(0xFF0155AF),
                                ),
                              )
                            ],
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            BlueButton(
              onTap: onTap,
              buttonText: 'Go home',
              buttonIsLoading: false,
              width: 235.w,
            )
          ],
        ),
      ),
    );
  }
}
