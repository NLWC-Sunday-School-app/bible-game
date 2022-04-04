import 'package:bible_game/screens/onboarding/meditate.dart';
import 'package:bible_game/widgets/onboarding/onboarding_body.dart';
import 'package:bible_game/widgets/onboarding/onboarding_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemorizeScreen extends StatelessWidget {
  const MemorizeScreen({Key? key}) : super(key: key);
  static String routeName = "/memorize-screen";

  void goToMeditateScreen(BuildContext context){
    Navigator.of(context).pushNamed(MeditateScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      // resizeToAvoidBottomInset: false,
       backgroundColor: const Color(0xFFFECF75),
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
                child:  const OnboardingHeader(
                  title: '1. Memorize',
                  titleInfo: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Arcu tincidunt donec blandit aenean mauris, enim lorem luctus rhoncus. Quis sem eget turpis integer leo.',
                  secondCircleDotBgColor:  0xFFFFFFF,
                  secondCircleDotTextColor: Color.fromRGBO(54, 42, 122, 0.6),
                  secondCircleDotBorderColor: Color.fromRGBO(54, 42, 122, 0.6),
                  thirdCircleDotBgColor: 0xFFFFFFF,
                  thirdCircleDotTextColor: Color.fromRGBO(54, 42, 122, 0.6),
                  thirdCircleDotBorderColor: Color.fromRGBO(54, 42, 122, 0.6),

                )
              ),
            ),
          ),
           OnboardingBody(
            imageUrl: 'assets/images/mask_one.png',
            buttonText: 'Next',
            goToNextScreen: () => goToMeditateScreen(context),
          )
        ],
      ),
    ));
  }
}

