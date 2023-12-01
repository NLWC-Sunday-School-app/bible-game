import 'dart:async';

import 'package:bible_game/controllers/wiw_game_controller.dart';
import 'package:bible_game/widgets/modals/who_is_who_guide.dart';
import 'package:bible_game/widgets/who_is_who/level_title_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../widgets/who_is_who/who_is_who_level.dart';

class WhoIsWhoHomeScreen extends StatefulWidget {
  const WhoIsWhoHomeScreen({Key? key}) : super(key: key);

  @override
  State<WhoIsWhoHomeScreen> createState() => _WhoIsWhoHomeScreenState();
}

class _WhoIsWhoHomeScreenState extends State<WhoIsWhoHomeScreen> {
  final int levelsCount = 24;
  final int bannerCount = 3;

  final WiwGameController _wiwGameController = Get.put(WiwGameController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFF084E9A),
        body: LayoutBuilder(
          builder: (context, constraints) =>
              Container(
                height: Get.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/images/aesthetics/pattern_bg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
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
                                InkWell(
                                  onTap: () => Get.back(),
                                  child: Image.asset(
                                    'assets/images/aesthetics/back.png',
                                    width: 44.w,
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                      'Who is Who',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Mikado',
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          fontSize: 26.sp),
                                    )),
                                InkWell(
                                  onTap: () => Get.dialog(const WhoIsWhoGuide(), barrierDismissible: false),
                                  child: Image.asset(
                                    'assets/images/aesthetics/info.png',
                                    width: 44.w,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              'Choose who did what in the bible',
                              style: TextStyle(
                                  fontFamily: 'Mikado',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 16.sp),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      // padding: EdgeInsets.only(left: 15.w, right: 15.w),
                      child: Obx(
                            () =>
                            Column(
                              children: [
                                _wiwGameController.isLoadingGameLevel.isTrue
                                    ? SizedBox(
                                  height: constraints.maxHeight * 0.8,
                                  child: Center(
                                    child:
                                    Image.asset(
                                        'assets/images/icons/loader.gif'),
                                  ),
                                )
                                    : SizedBox(
                                  height: constraints.maxHeight * 0.8,
                                  child: Obx(
                                        () =>
                                        GridView.builder(
                                          // scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount:
                                          _wiwGameController.gameLevels.length,
                                          gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,

                                            mainAxisSpacing: 30.0.w,

                                            crossAxisSpacing:
                                            10.0.w, // spacing between columns
                                          ),
                                          itemBuilder:
                                              (BuildContext context,
                                              int index) {
                                            return Column(
                                              children: [
                                                WhoIsWhoLevel(
                                                  isUnLocked: index == 0
                                                      ? true
                                                      : _wiwGameController
                                                      .gameLevels[index]
                                                      .isUnlocked,
                                                  level: (index + 1).toString(),
                                                  backgroundUrl: _wiwGameController
                                                      .gameLevels[index]
                                                      .backgroundImage,
                                                  isSpecialLevel: _wiwGameController
                                                      .gameLevels[index]
                                                      .isSpecialLevel,
                                                  playTime: _wiwGameController
                                                      .gameLevels[index]
                                                      .playTime,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                  ),
                                ),
                              ],
                            ),
                      ),
                    ),
                  ],
                ),
              ),
        ));
  }

  @override
  void initState() {
    super.initState();
    _wiwGameController.getGameLevels();
     Timer(const Duration(seconds: 1), (){
       Get.dialog(const WhoIsWhoGuide());
     });

  }
}


//   Widget renderLists(BuildContext context) {
//     final lists = SliverList(
//       delegate: SliverChildListDelegate(
//         [LevelTitleBanner()],
//       ),
//     );
//     return lists;
//   }
//
//   List<Widget> businessLogic(BuildContext context) {
//     List<Widget> temp = [];
//     for (var i = 0; i < 24; i++) {
//       if (i % 8 == 0) {
//         temp.add(renderLists(context));
//       }
//       temp.add(renderGrids(context, i));
//     }
//     print(temp);
//     return temp;
//   }
//
//   Widget renderScrollArea(BuildContext context) {
//     final scrollableArea = CustomScrollView(
//       slivers: businessLogic(context),
//
//       // Below lines are neglected as we have more complex requirement
//       // slivers: <Widget>[
//       //   renderGrids(context),
//       //   renderLists(context),
//       //   renderGrids(context),
//       //   renderLists(context),
//       // ],
//     );
//     return scrollableArea;
//   }
//
//   // Widget renderGrids(BuildContext context) {
//   Widget renderGrids(BuildContext context, index) {
//     final grids = SliverGrid(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 1,
//       ),
//       delegate: SliverChildListDelegate(
//         [
//           // WhoIsWhoLevel(isLocked: false, level: (index + 1).toString()),
//         ],
//       ),
//     );
//     return grids;
//   }
// }
