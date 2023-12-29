import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecapThreeScreen extends StatelessWidget {
  const RecapThreeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/aesthetics/recap_three_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 100.h, left: 20.w,
          child: Text.rich(
            TextSpan(
              text: '...and so mightily \ngrew the app & \nspread to',
              style: TextStyle(
                fontFamily: 'Mikado',
                fontSize: 36.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0B70B8)
              ),
              children: const [
                TextSpan(
                  text: ' 45+ \ncountries...',
                  style: TextStyle(
                    color: Color(0xFFFFB700)
                  )
                )
              ]
            )
          ).animate()
            .fadeIn() // uses `Animate.defaultDuration`
            .scale() // inherits duration from fadeIn
            .move(delay: 1000.ms, duration: 500.ms)

        ) // inherits the delay & duration from move
      ],
    );
  }
}
