import 'dart:math';

import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';

class RecapTwentyScreen extends StatelessWidget {
  const RecapTwentyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ProductImageRoutes.recapTwentyBck),
              fit: BoxFit.cover,
            ),
          ),
        ),

        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(top: 100.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Friend Challenge',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'Mikado',
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20.h,),
                Text(
                  'Send this to your  friends to Challenge\nthem to beat your stats in 2026',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: 'Gochi hand',
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 40.h,),
                Transform.rotate(
                  angle: -pi/100,
                  child: StrokeText(
                    text:'I Challenge you to\nbeat my Stats in\n2026',
                    strokeColor: Color(0xFF435570),
                    strokeWidth: 5,
                    textAlign: TextAlign.center,
                    textStyle: TextStyle(
                      fontSize: 35.sp,
                      fontFamily: 'Mikado',
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ).animate(
                      autoPlay: true
                  ).scaleXY(
                      begin: 0,
                      end: 1,
                      curve: Curves.elasticInOut,
                      duration: Duration(seconds: 2),
                      alignment: Alignment.topLeft
                  ),
                ),
              ],
            ),
          ),
        ),

        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 150.h),
              child: Image.asset(
                  ProductImageRoutes.recapTwentyCloud,
                width: 249.w,
              ),
            )
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom:140.h),
              child: Image.asset(
                ProductImageRoutes.recapTwentyGround,
                width: 245.w,
              ),
            )
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 135.h),
              child: Image.asset(
                ProductImageRoutes.recapTwentyCartoon,
                width: 130.w,
              ),
            )
        ),

      ],
    );
  }
}
