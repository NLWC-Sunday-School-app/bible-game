import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/features/four_scriptures/widget/question_number_box.dart';
import 'package:the_bible_game/features/four_scriptures/widget/score_box.dart';
import 'package:the_bible_game/features/four_scriptures/widget/scripture_box.dart';
import 'package:the_bible_game/shared/widgets/blue_button.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/constants/image_routes.dart';
import '../../../shared/utils/formatter.dart';
import '../../../shared/widgets/screen_app_bar.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
class FourScriptureQuestionScreen extends StatelessWidget {
  const FourScriptureQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Column(
            children: [
              ScreenAppBar(
                widgets: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          IconImageRoutes.arrowCircleBack,
                          width: 40.w,
                        ),
                      ),
                      Spacer(),
                      ScoreBox(),
                      QuestionNumberBox(),
                      Spacer(),
                      InkWell(
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
              Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: SizedBox(
                    height: 350.h,
                    child: GridView.count(
                      padding: EdgeInsets.zero,
                      crossAxisCount: 2,
                      crossAxisSpacing: 40,
                      children: [
                        ScriptureBox(
                          scripture: formatScriptureString('Exodus 5:20'),
                          unFormattedScripture: '5:20',
                        ),
                        ScriptureBox(
                          scripture: formatScriptureString('Romans 2:14'),
                          unFormattedScripture: '1:17',
                        ),
                        ScriptureBox(
                          scripture: formatScriptureString('James 2:14'),
                          unFormattedScripture: '5:17',
                        ),
                        ScriptureBox(
                          scripture: formatScriptureString('John 4:17'),
                          unFormattedScripture: '4:17',
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
                  length: 8,
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
                  onCompleted: (text) {

                  },
                  appContext: context,
                  onChanged: (String value) {
                    print('value $value');
                  },
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlueButton(
                    buttonText: 'Load',
                    buttonIsLoading: false,
                    width: 250.w,
                    customText:
                        Row(
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
                              IconImageRoutes.coinIcon,
                              width: 18.w,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              '3000',
                              style: TextStyle(
                                  fontFamily: 'Mikado',
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),

                          ],
                        ),


                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: () {

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
              SizedBox(height: 40.h,)
            ],
          )),
    );
  }
}
