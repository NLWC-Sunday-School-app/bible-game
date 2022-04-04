import 'package:bible_game/screens/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingButton extends StatelessWidget {
  const OnboardingButton({Key? key, required this.buttonText, required this.goToNextScreen}) : super(key: key);

  final String buttonText;
  final VoidCallback goToNextScreen;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: goToNextScreen,
      child: Container(
        padding: EdgeInsets.only(
          left: 66.w,
          right: 66.w,
          top: 16.h,
          bottom: 16.h,
        ),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(224, 153, 16, 1),
                Color.fromRGBO(254, 193, 75, 1),
              ],
            ),
            borderRadius: BorderRadius.circular(20.r)),
        child:  Text(
          buttonText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
  }
}
