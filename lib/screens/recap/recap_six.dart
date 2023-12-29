import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

class RecapSixScreen extends StatelessWidget {
  const RecapSixScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/aesthetics/recap_six_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 130.h,
          left: 0.w,
          right: 0.w,
          child: Column(
            children: [
              Text(
                '${GetStorage().read('game_recap')['total_seconds_spent']}s',
                style: TextStyle(
                  fontFamily: 'Mikado',
                  fontSize: 80.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ).animate().fade(duration: 900.ms),
              Text(
                '...that is ${GetStorage().read('game_recap')['total_minutes_spent']} minutes \non the app this year!',
                style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'Mikado',
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFFEE6C2)),
              ).animate().fade(delay: 900.ms),
              SizedBox(
                height: 25.h,
              ),
              Image.asset(
                'assets/images/aesthetics/recap_hourglass.png',
                width: 240.w,
              ).animate().move(
                    delay: 900.ms,
                    duration: 1.seconds,
                  )
            ],
          ),
        )
      ],
    );
  }
}
