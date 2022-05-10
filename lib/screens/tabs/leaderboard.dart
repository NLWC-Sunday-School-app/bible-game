import 'dart:ui';

import 'package:bible_game/widgets/LeaderBoardBaseChampions.dart';
import 'package:bible_game/widgets/LeaderBoardChampion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../widgets/LeaderBoardCard.dart';

class TabLeaderBoardScreen extends StatelessWidget {
  const TabLeaderBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 200.h),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(110, 91, 220, 1),
                    Color.fromRGBO(60, 46, 144, 1),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/games_cloud.png',
                    width: 280.w,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 65.h),
              child: Text(
                'Leaderboard',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.sp,
                    color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 130.h),
              padding: EdgeInsets.only(left: 25.0.w, right: 25.0.w),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 10.w),
                    child: const Icon(
                        Icons.search), // myIcon is a 48px-wide widget.
                  ),
                  prefixIconColor: const Color.fromRGBO(160, 160, 160, 1),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(118, 99, 229, 1)),
                    borderRadius: BorderRadius.circular(15.0.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(51, 97, 159, 0.2)),
                    borderRadius: BorderRadius.circular(15.0.r),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0.r),
                  ),
                  filled: true,
                  hintStyle: const TextStyle(
                      color: Color.fromRGBO(160, 160, 160, 1),
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                  hintText: "Search by username or name ",
                  fillColor: const Color.fromRGBO(243, 242, 242, 1),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 200.h,
              ),
              padding: EdgeInsets.only(left: 25.w, right: 25.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  LeaderBoardBaseChampions(),
                  LeaderBoardChampion(),
                  LeaderBoardBaseChampions()
                ],
              ),
            ),

            Container(
              margin:
              EdgeInsets.only(top: 500.h, left: 15.0.w, right: 15.0.w),
              child: Column(
                children: const [
                  LeaderBoardCard(leaderBoardPosition: '4',),
                  LeaderBoardCard(leaderBoardPosition: '5',),
                  LeaderBoardCard(leaderBoardPosition: '5',),
                  LeaderBoardCard(leaderBoardPosition: '7'),
                  LeaderBoardCard(leaderBoardPosition: '8'),
                  LeaderBoardCard(leaderBoardPosition: '9'),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

