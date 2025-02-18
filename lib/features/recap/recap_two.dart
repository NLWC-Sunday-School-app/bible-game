import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecapTwoScreen extends StatelessWidget {
  const RecapTwoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ProductImageRoutes.recapTwoBg),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 300.h,
          left: 0.w,
          right: 0.w,
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Countup(
                        begin: 1,
                        end: 50,
                        duration: const Duration(seconds: 2),
                        separator: '',
                        style: TextStyle(
                            fontSize: 120.sp,
                            fontFamily: 'Mikado',
                            color: Colors.white,
                            fontWeight: FontWeight.w900),
                      ),
                      Text(
                        'k+',
                        style: TextStyle(
                            fontSize: 120.sp,
                            fontFamily: 'Mikado',
                            color: Colors.white,
                            fontWeight: FontWeight.w900),
                      )
                    ],
                  ),
                  Positioned(
                    top: 100.h,
                    left: 90.w,
                    child: Image.asset(
                      'assets/images/product/recap/downloaded_cloud.png',
                      width: 220.w,
                    ).animate().slide(duration: 800.ms),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
