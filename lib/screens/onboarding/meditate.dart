import 'package:bible_game/screens/onboarding/know_scriptures.dart';
import 'package:bible_game/widgets/onboarding/onboarding_body.dart';
import 'package:bible_game/widgets/onboarding/onboarding_button.dart';
import 'package:bible_game/widgets/onboarding/onboarding_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MeditateScreen extends StatelessWidget {
  const MeditateScreen({Key? key}) : super(key: key);
  static String routeName = "/meditate-screen";

  void goToKnowScripturesScreen(BuildContext context){
    Get.off(() => const KnowScripturesScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFFFFAD61),
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
                        title: '2. Meditate',
                        titleInfo: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Arcu tincidunt donec blandit aenean mauris, enim lorem luctus rhoncus. Quis sem eget turpis integer leo.',
                        secondCircleDotBgColor:  0xFFFFAD61,
                        secondCircleDotTextColor: Color(0xFF362A7A),
                        secondCircleDotBorderColor: Colors.transparent,
                        thirdCircleDotBgColor: 0xFFFFFFF,
                        thirdCircleDotTextColor: Color.fromRGBO(54, 42, 122, 0.6),
                        thirdCircleDotBorderColor: Color.fromRGBO(54, 42, 122, 0.6),
                      )
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 250.h),
                child: OnboardingBody(
                  imageUrl: 'assets/images/mask_two.png',
                  buttonText: 'Next',
                  goToNextScreen: () => goToKnowScripturesScreen(context),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(top: 600.h),
                  child: OnboardingButton(buttonText: 'Next', goToNextScreen: () => goToKnowScripturesScreen(context),),
                ),
              ),
            ],
          ),
        );
  }
}
