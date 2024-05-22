import 'package:flutter/material.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/widgets/screen_app_bar.dart';

class FantasyLeagueHomeScreen extends StatelessWidget {
  const FantasyLeagueHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF384A5E),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ProductImageRoutes.patternTwoBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            ScreenAppBar(
              widgets: [
                Center(
                  child: StrokeText(
                    text: 'Fantasy Bible League',
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w900,
                    ),
                    strokeColor: AppColors.titleDropShadowColor,
                    strokeWidth: 6,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                )
              ],
            ),
            const Spacer(),
            Image.asset(ProductImageRoutes.fblComingSoon,
              width: 300.w,
            ),
            SizedBox(
              height: 30.h,
            ),
            Text('Play and win with your friends!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
