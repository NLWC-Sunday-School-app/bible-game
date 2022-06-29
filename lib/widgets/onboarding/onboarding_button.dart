import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingButton extends StatelessWidget {
  const OnboardingButton({
    Key? key,
    required this.buttonText,
    required this.goToNextScreen,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback goToNextScreen;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: goToNextScreen,
      child: Container(
        padding: EdgeInsets.only(
          left: 110.w,
          right: 110.w,
          top: 20.h,
          bottom: 20.h,
        ),
        decoration: BoxDecoration(
            color: const Color(0xfff2f3f7),
            borderRadius: BorderRadius.circular(20.r)),
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.w700, color: Color(0xFF362A7A)),
        ),
      ),
    );
  }
}
