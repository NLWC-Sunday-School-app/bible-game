import 'package:flutter/material.dart';
import 'package:the_bible_game/features/global_challenge/view/home_screen.dart';
import 'package:the_bible_game/features/multi_player/view/home_screen.dart';
import 'package:the_bible_game/shared/constants/colors.dart';
import 'package:the_bible_game/shared/widgets/screen_app_bar.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/constants/image_routes.dart';
import '../../../shared/widgets/tab_button.dart';

class ArcadeScreen extends StatefulWidget {
  const ArcadeScreen({super.key});

  @override
  State<ArcadeScreen> createState() => _ArcadeScreenState();
}

class _ArcadeScreenState extends State<ArcadeScreen> {
  bool _selectedGlobalChallenge = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFF014AA0),
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
                    text: 'Arcade',
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
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Container(
                height: 72.h,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: Color(0xFF898C6FE),
                  borderRadius: BorderRadius.circular(4.r),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF364865),
                      offset: Offset(0, 5),
                      blurRadius: 0,
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TabButton(
                      buttonText: 'Global Challenge',
                      buttonSelected: _selectedGlobalChallenge,
                      onTap: () {
                        setState(() {
                          _selectedGlobalChallenge = true;
                        });
                      },
                    ),
                    TabButton(
                      buttonText: 'Multiplayer',
                      buttonSelected: !_selectedGlobalChallenge,
                      onTap: () {
                        setState(() {
                          _selectedGlobalChallenge = false;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              child: _selectedGlobalChallenge
                  ? SizedBox(
                  height: screenHeight - (150.h + 20.h + 72.h + 5.h + 120.h + 7.h),
                  child: GlobalChallengeHomeScreen())
                  : MultiplayerHomeScreen()
            )
          ],
        ),
      ),
    );
  }
}
