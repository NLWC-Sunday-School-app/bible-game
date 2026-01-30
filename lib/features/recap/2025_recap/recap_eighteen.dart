import 'dart:math';

import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';

class RecapEighteenScreen extends StatelessWidget {
  const RecapEighteenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF1A6267),Color(0xFFFFFFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
            )
          ),
        ),

        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(top: 120.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '2026 Challenge',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'Mikado',
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
            top: 230.h,
            left: 55.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.rotate(
                  angle: -pi/70,
                  child: Text.rich(
                    TextSpan(
                        text: "Can you\n",
                        children: [
                          TextSpan(
                              text: "beat ",
                              style: TextStyle(
                                  color: Color(0xFF00FF26)
                              )
                          ),
                          TextSpan(
                            text: "your\n2025 stats",
                          )
                        ]
                    ),
                    style: TextStyle(
                        fontSize: 35.sp,
                        fontFamily: 'Mikado',
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4
                    ),
                  ),
                ),
                Text(
                  'Let’s see what you’ve got',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: 'Gochi hand',
                    color: Color(0xFFCECECE),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
        ),
        Positioned(
            top: 250.h,
            right: 61.w,
            child: Image.asset(ProductImageRoutes.recapEighteenQuestionGif)
        ),

        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 240.h),
              child: Image.asset(ProductImageRoutes.recapEighteenArmGif),
            )
        ),

        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 250.h),
              child: StrokeText(
                text: 'Start Strong!',
                strokeWidth: 15,
                strokeColor: Colors.white,
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontSize: 48.sp,
                  fontFamily: 'Gochi hand',
                  color: Color(0xFF000000),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child:Padding(
            padding: EdgeInsets.only(bottom: 130.h),
            child: Column(
              children: [
                Spacer(),
                Text(
                  'Think you can surpass your 2025\nmilestones? God’s grace is your\npower-up.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'Gochi hand',
                    color: Color(0xFF264345),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
