import 'package:flutter/material.dart';
import 'package:the_bible_game/features/leader_board/widget/leaderboard_card.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';
import 'package:the_bible_game/shared/widgets/screen_app_bar.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/shared/widgets/tab_button.dart';
import '../../../shared/constants/colors.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  bool _selectedGlobal = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
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
                    text: 'Leaderboard',
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
                      buttonText: 'Global',
                      buttonSelected: _selectedGlobal,
                      onTap: () {
                        setState(() {
                          _selectedGlobal = true;
                        });
                      },
                    ),
                    TabButton(
                      buttonText: 'United Kingdom',
                      buttonSelected: !_selectedGlobal,
                      onTap: () {
                        setState(() {
                          _selectedGlobal = false;
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            SizedBox(
              height: screenHeight - (150.h + 20.h + 72.h + 5.h + 120.h),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return LeaderboardCard(
                    position: 1,
                    userName: 'Toblinkz',
                    userBadge: ProductImageRoutes.defaultBadge,
                    userLevel: 'Elder',
                    noOfCoins: '10, 000',
                    countryName: 'NGA',
                    countryLogo:
                        'https://res.cloudinary.com/dd3hfa9ug/image/upload/v1714750941/Nigeria_NG_q4jizd.png',
                    userAvatar: 'https://api.multiavatar.com/Binx Bond.png',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
