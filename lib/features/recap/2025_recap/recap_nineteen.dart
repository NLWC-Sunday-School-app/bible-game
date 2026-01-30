import 'dart:math';

import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';

class RecapNineteenScreen extends StatelessWidget {
  const RecapNineteenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ProductImageRoutes.recapNineteenBck),
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        Align(
          alignment: Alignment.center,
          child: Image.asset(
              ProductImageRoutes.recapNineteenGif,
            width: 350.w,
            height: 350.h,
            scale: 0.3,
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
                  'Sneak Peek',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'Mikado',
                    color: Color(0xFF342821),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20.h,),
                Text(
                  'A sneak peek at our upcoming features -\nMultiplayer! Brace up for Impact!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: 'Gochi hand',
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
            top: 230.h,
            left: 55.w,
            child: Image.asset(
                ProductImageRoutes.recapNineteenDevice
            ).animate(
              autoPlay: true
            )
            .scaleXY(
              begin: 0,
              end: 0.85,
              curve: Curves.elasticInOut,
              duration: Duration(seconds: 2),
              alignment: Alignment.topLeft
            )
        ),
        Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
                ProductImageRoutes.recapNineteenCartoon,
              scale: 1,
            )
        ),

      ],
    );
  }
}
