import 'dart:math';

import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';

class RecapSeventeenScreen extends StatelessWidget {
  const RecapSeventeenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ProductImageRoutes.recapSeventeenBck),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ProductImageRoutes.recapThirteenStar),
              opacity: 0.3,
              fit: BoxFit.cover,
            ),
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
                  'Amazing!',
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

        Align(
          child: Column(
            children: [
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Thanks for an',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34.sp,
                      fontFamily: 'Gochi hand',
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Amazing',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 51.sp,
                      fontFamily: 'Mikado',
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Transform.rotate(
                    angle: -pi/30,
                    child: Text(
                      '2025!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 85.sp,
                        fontFamily: 'Mikado',
                        color: Color(0xFF0059FF),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              Spacer()
            ],
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child:Padding(
            padding: EdgeInsets.only(bottom: 200.h),
            child: Column(
              children: [
                Spacer(),
                Text(
                  'Thank you for an amazing 2025.\nCan’t wait for the next adventure.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'Gochi hand',
                    color: Colors.white,
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
