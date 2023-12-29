import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecapOneScreen extends StatelessWidget {
  const RecapOneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/aesthetics/recap_one_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),

        Positioned(
          top: 220.h,
          left: 30.w,
          child:
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Your 2023 \nBible Game \nrecap is here!',
                textStyle: TextStyle(
                  fontSize: 48.sp,
                  fontFamily: 'Mikado',
                  height: 1,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
                speed: const Duration(milliseconds: 100),
              ),
            ],
            isRepeatingAnimation: false,
            pause: const Duration(milliseconds: 1000),
            displayFullTextOnTap: true,
            stopPauseOnTap: true,
          )
        )
      ],
    );
  }
}
