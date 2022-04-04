import 'package:bible_game/screens/authentication/signup.dart';
import 'package:bible_game/widgets/onboarding/onboarding_body.dart';
import 'package:bible_game/widgets/onboarding/onboarding_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class KnowScripturesScreen extends StatelessWidget {
  const KnowScripturesScreen({Key? key}) : super(key: key);
  static String routeName = "/know-scriptures-screen";

  void goToSignupScreen(BuildContext context){
    Navigator.of(context).pushNamed(SignUpScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFFFD9090),
          body: Stack(
            children: [
              SizedBox(
                height: 436.h,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xfff2f3f7),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60.r),
                      bottomRight: Radius.circular(60.r),
                    ),
                  ),
                  child: Padding(
                      padding: EdgeInsets.only(left: 19.0.w),
                      child: const OnboardingHeader(
                        title: '3. Know Scriptures',
                        titleInfo: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Arcu tincidunt donec blandit aenean mauris, enim lorem luctus rhoncus. Quis sem eget turpis integer leo.',
                        secondCircleDotBgColor: 0xFFFFAD61,
                        secondCircleDotTextColor: Color(0xFF362A7A),
                        secondCircleDotBorderColor: Colors.transparent,
                        thirdCircleDotBgColor: 0xFFFD9090,
                        thirdCircleDotTextColor: Color(0xFF362A7A),
                        thirdCircleDotBorderColor: Colors.transparent,
                      )
                  ),
                ),
              ),
               OnboardingBody(
                imageUrl: 'assets/images/mask_three.png',
                buttonText: 'Get Started',
                goToNextScreen: () => goToSignupScreen(context),
              )
            ],
          ),
        ));
  }
}

