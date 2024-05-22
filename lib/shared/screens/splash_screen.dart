
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../constants/image_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ProductImageRoutes.splashScreenLoaderBg),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Column(
            children: [
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 70.w),
                child: LinearPercentIndicator(
                    lineHeight: 15.h,
                    percent: 1,
                    animation: true,
                    animationDuration: 3500,
                    barRadius: const Radius.circular(10),
                    progressColor: const Color(0xFFFECF75),
                    onAnimationEnd: () => {print('joy')}),
              ),
              SizedBox(
                height: 50.h,
              )
            ],
          ),
        ),
      ],
    );
  }
}
