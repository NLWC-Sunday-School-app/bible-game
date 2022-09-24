
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/screens/question_screen.dart';
import 'package:bible_game/widgets/game_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickGameModal extends StatelessWidget {
  const QuickGameModal({Key? key}) : super(key: key);


  goToQuestionScreen(BuildContext context){
    Navigator.pop(context);
    Navigator.of(context).pushNamed(QuestionScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(top: 120.0.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromRGBO(152, 152, 152, 1).withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 4,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: const AutoSizeText(
                'Preparing your questions...',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Text(''),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromRGBO(152, 152, 152, 1).withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 4,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 26.w, vertical: 12.h),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(118, 99, 229, 1),
                        borderRadius: BorderRadius.all(Radius.circular(12.r))),
                    child: AutoSizeText(
                      'Quick Tips',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(248, 225, 147, 1),
                        borderRadius: BorderRadius.all(Radius.circular(12.r))),
                    child: Row(
                      children: [
                        Container(
                          width: 23.w,
                          height: 23.h,
                          margin: EdgeInsets.only(right: 12.w),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Align(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              '1',
                              style: TextStyle(fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        AutoSizeText(
                          'Get all the questions right to get \n bonus points',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(231, 226, 255, 1),
                        borderRadius: BorderRadius.all(Radius.circular(12.r))),
                    child: Row(
                      children: [
                        Container(
                          width: 23.w,
                          height: 23.h,
                          margin: EdgeInsets.only(right: 12.w),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Align(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              '2',
                              style: TextStyle(fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const AutoSizeText(
                          'Missing any question reduces \nyour point ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(231, 242, 230, 1),
                        borderRadius: BorderRadius.all(Radius.circular(12.r))),
                    child: Row(
                      children: [
                        Container(
                          width: 23.w,
                          height: 23.h,
                          margin: EdgeInsets.only(right: 12.w),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Align(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              '3',
                              style: TextStyle(fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const AutoSizeText(
                          'Speed is an extra advantage',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 11.w),
                            child: Image.asset(
                              'assets/images/heart.png',
                              width: 18.w,
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 38.h,
                  ),
                  GestureDetector(
                    onTap: () => goToQuestionScreen(context),
                    child: const GameButton(buttonText: 'PLAY NOW'),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
