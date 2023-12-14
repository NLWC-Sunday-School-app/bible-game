import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/utilities/constants.dart';
import 'package:bible_game/widgets/leaderboard/leaderboard_menu_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stroke_text/stroke_text.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';

class TabLeaderBoardMenuScreen extends StatelessWidget {
  const TabLeaderBoardMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController _authController = Get.put(AuthController());
    final gameSettings = GetStorage().read('game_settings');
    return Scaffold(
      backgroundColor: const Color(0xFF084E9A),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/aesthetics/pattern_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  maxWidth: constraints.maxWidth),
              child: Center(
                child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: Get.height < 680
                              ? 130
                              : (Get.height > 680 && Get.height < 800)
                              ? 150
                              : 160.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF366ABC),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.r),
                              bottomRight: Radius.circular(10.r),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color(0xFFF3DB3E),
                                  offset: Offset(0, 10),
                                  blurRadius: 0,
                                  spreadRadius: -3),
                              BoxShadow(
                                  color: Color(0xFFEF798A),
                                  offset: Offset(0, 8),
                                  blurRadius: 0,
                                  spreadRadius: -4),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child:  Center(
                                        child: StrokeText(
                                          text: 'Leaderboard',
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Mikado',
                                            fontSize: 28.sp,
                                            fontWeight: FontWeight.w900,
                                          ),
                                          strokeColor: const Color(0xFF05477B) ,
                                          strokeWidth: 5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 6.h,
                        ),
                        SizedBox(
                          height: Get.height - (160.h + 120.h + 6.h),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: constraints.maxHeight * 0.03),
                                const LeaderBoardMenuCard(levelImage:'assets/images/blue_bible.png',levelLabel: '4 Scriptures', levelNumber: '*', isNativity: true,),
                                const LeaderBoardMenuCard(levelImage:'assets/images/pilgrim_levels/babe.png', levelLabel: 'Babe', levelNumber: '1', isNativity: false,),
                                const LeaderBoardMenuCard(levelImage:'assets/images/pilgrim_levels/child.png', levelLabel: 'Child', levelNumber: '2', isNativity: false,),
                                const LeaderBoardMenuCard(levelImage:'assets/images/pilgrim_levels/young_believer.png', levelLabel: 'Young Believer', levelNumber: '3', isNativity: false,),
                                const LeaderBoardMenuCard(levelImage:'assets/images/pilgrim_levels/charity.png', levelLabel: 'Charity', levelNumber: '4', isNativity: false,),
                                const LeaderBoardMenuCard(levelImage:'assets/images/pilgrim_levels/father.png', levelLabel: 'Father', levelNumber: '5', isNativity: false,),
                                const LeaderBoardMenuCard(levelImage:'assets/images/pilgrim_levels/elder.png', levelLabel: 'Elder', levelNumber: '6', isNativity: false,)
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),


              ),
            );
        }),
      ),
    );
  }
}
