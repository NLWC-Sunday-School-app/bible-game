import 'package:bible_game/features/pilgrim_progress/widget/tablet_view_widget/pilgrim_progress_menu_tablet_view.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:bible_game/features/pilgrim_progress/bloc/pilgrim_progress_bloc.dart';
import 'package:bible_game/features/pilgrim_progress/widget/pilgrim_progress_menu.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../../shared/constants/app_routes.dart';
import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/widgets/screen_app_bar.dart';

class PilgrimProgressHomeScreenTabletView extends StatefulWidget {
  const PilgrimProgressHomeScreenTabletView({super.key});

  @override
  State<PilgrimProgressHomeScreenTabletView> createState() =>
      _PilgrimProgressHomeScreenTabletViewState();
}

class _PilgrimProgressHomeScreenTabletViewState extends State<PilgrimProgressHomeScreenTabletView> {
  PilgrimProgressBloc? pilgrimProgressBloc;

  @override
  void initState() {
    super.initState();
    pilgrimProgressBloc = BlocProvider.of<PilgrimProgressBloc>(context);
    pilgrimProgressBloc?.add(SetPilgrimProgressData());
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    double screenHeight = MediaQuery.of(context).size.height;
    final double usableHeight = screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom;
    final settingsState = BlocProvider.of<SettingsBloc>(context).state;
    var formatter = NumberFormat('#,###,###');

    return BlocBuilder<PilgrimProgressBloc, PilgrimProgressState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Color(0xFF014AA0),
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 0,
            backgroundColor: AppColors.primaryColorShade,// Status bar color
          ),
          body: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.patternTwoBg),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  ScreenAppBar(
                    height: null,
                    widgets: [
                      SizedBox(
                        height: 16.h,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: (){
                              soundManager.playClickSound();
                              Navigator.pop(context);},
                            child: Image.asset(
                              IconImageRoutes.arrowCircleBack,
                              width: 40.w,
                            ),
                          ),
                          Spacer(),
                          StrokeText(
                            text: 'Pilgrim Progress',
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w900,
                            ),
                            strokeColor: AppColors.titleDropShadowColor,
                            strokeWidth: 6,
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      StrokeText(
                        text: 'Grow your knowledge as you progress',
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0),
                        strokeColor: AppColors.titleDropShadowColor,
                        strokeWidth: 4,
                      ),
                      SizedBox(
                        height: 36.h,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal:135.w),
                      children: [
                        PilgrimProgressLevelMenuTabletView(
                          menuImage: ProductImageRoutes.babe,
                          menuNumber: '',
                          menuLabel: 'BABE',
                          isLocked: false,
                          menuProgressValue:
                              state.pilgrimProgressLevelData[0].progress!,
                          totalPointsGained: state.totalPointsGainedInBabe,
                          boxShadowColor: 0xFFE4E0DD,
                          totalPointsAvailable: 5000,
                          onTap: () {
                            soundManager.playClickSound();
                            Navigator.pushNamed(context, AppRoutes.questionLoadingScreen, arguments:{ 'gameType': 'pilgrim_progress', 'selectedLevel': 'babe'});
                          },
                          textSpan: RichText(
                              text: TextSpan(
                                  text: 'Begin your bible adventure! Get up \nto',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: const Color(0xFF22210D),
                                    height: 1.5,
                                  ),
                                  children: <TextSpan>[
                                TextSpan(
                                    text:
                                        ' ${formatter.format(int.parse(settingsState.gamePlaySettings['babe_to_child_total']))} points',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                const TextSpan(
                                  text: ' to finish this level.',
                                ),
                              ])),
                        ),
                        PilgrimProgressLevelMenuTabletView(
                          menuImage: ProductImageRoutes.child,
                          menuNumber: '',
                          menuLabel: 'CHILD',
                          isLocked: state.childLevelIsLocked,
                          menuProgressValue:
                              state.pilgrimProgressLevelData[1].progress!,
                          totalPointsGained: state.totalPointsGainedInChild,
                          boxShadowColor: 0xFFFCCB90,
                          totalPointsAvailable: 5000,
                          onTap: () {
                            soundManager.playClickSound();
                            Navigator.pushNamed(context, AppRoutes.questionLoadingScreen, arguments:{ 'gameType': 'pilgrim_progress', 'selectedLevel': 'child'});
                          },
                          textSpan: RichText(
                              text: TextSpan(
                                  text: 'Go further in your journey! Get up \nto',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: const Color(0xFF22210D),
                                    height: 1.5,
                                  ),
                                  children: <TextSpan>[
                                TextSpan(
                                    text:
                                        ' ${formatter.format(int.parse(settingsState.gamePlaySettings['child_to_young_believer_total']))} points',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                const TextSpan(
                                  text: ' to grow from here.',
                                ),
                              ])),
                        ),
                        PilgrimProgressLevelMenuTabletView(
                          menuImage: ProductImageRoutes.youngBeliever,
                          menuNumber: '',
                          menuLabel: 'YOUNG BELIEVER',
                          isLocked: state.youngBelieversLevelIsLocked,
                          menuProgressValue:
                              state.pilgrimProgressLevelData[2].progress!,
                          totalPointsGained: state.totalPointsGainedInYb,
                          boxShadowColor: 0xFFC7DAE1,
                          totalPointsAvailable: 5000,
                          onTap: () {
                            soundManager.playClickSound();
                            Navigator.pushNamed(context, AppRoutes.questionLoadingScreen, arguments:{ 'gameType': 'pilgrim_progress', 'selectedLevel': 'young believer'});
                          },
                          textSpan: RichText(
                              text: TextSpan(
                                  text: 'You are growing! Almost there! Get \n',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: const Color(0xFF22210D),
                                    height: 1.5,
                                  ),
                                  children: <TextSpan>[
                                TextSpan(
                                    text:
                                        ' ${formatter.format(int.parse(settingsState.gamePlaySettings['young_believer_to_charity_total']))} points',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                const TextSpan(
                                  text: ' to get to charity.',
                                ),
                              ])),
                        ),
                        PilgrimProgressLevelMenuTabletView(
                          menuImage: ProductImageRoutes.charity,
                          menuNumber: '',
                          menuLabel: 'CHARITY',
                          isLocked: state.charityLevelIsLocked,
                          menuProgressValue:
                              state.pilgrimProgressLevelData[3].progress!,
                          totalPointsGained: state.totalPointsGainedInCharity,
                          boxShadowColor:0xFF92D6EE,
                          totalPointsAvailable: 5000,
                          onTap: () {
                            soundManager.playClickSound();
                            Navigator.pushNamed(context, AppRoutes.questionLoadingScreen, arguments:{ 'gameType': 'pilgrim_progress', 'selectedLevel': 'charity'});
                          },
                          textSpan: RichText(
                              text: TextSpan(
                                  text:
                                      'Charity is round the corner! Get up \nto',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: const Color(0xFF22210D),
                                    height: 1.5,
                                  ),
                                  children: <TextSpan>[
                                TextSpan(
                                    text:
                                        ' ${formatter.format(int.parse(settingsState.gamePlaySettings['charity_to_father_total']))} points',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                const TextSpan(
                                  text: ' to get to Father.',
                                ),
                              ])),
                        ),
                        PilgrimProgressLevelMenuTabletView(
                          menuImage: ProductImageRoutes.father,
                          menuNumber: '',
                          menuLabel: 'FATHER',
                          isLocked: state.fatherLevelIsLocked,
                          menuProgressValue:
                              state.pilgrimProgressLevelData[4].progress!,
                          totalPointsGained: state.totalPointsGainedInFather,
                          boxShadowColor: 0xFFF9ACBB,
                          totalPointsAvailable: 5000,
                          onTap: () {
                            soundManager.playClickSound();
                            Navigator.pushNamed(context, AppRoutes.questionLoadingScreen, arguments:{ 'gameType': 'pilgrim_progress', 'selectedLevel': 'father'});
                          },
                          textSpan: RichText(
                              text: TextSpan(
                                  text: 'Grown beyond this world! Get up to \n',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: const Color(0xFF22210D),
                                    height: 1.5,
                                  ),
                                  children: <TextSpan>[
                                TextSpan(
                                    text:
                                        ' ${formatter.format(int.parse(settingsState.gamePlaySettings['father_to_elder_total']))} points',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                const TextSpan(
                                  text: ' to become an Elder.',
                                ),
                              ])),
                        ),
                        PilgrimProgressLevelMenuTabletView(
                          menuImage: ProductImageRoutes.elder,
                          menuNumber: '',
                          menuLabel: 'ELDER',
                          isLocked: state.elderLevelIsLocked,
                          menuProgressValue:
                              state.pilgrimProgressLevelData[5].progress!,
                          totalPointsGained: state.totalPointsGainedInElder,
                          boxShadowColor: 0xFFA2EAE0,
                          totalPointsAvailable: 5000,
                          onTap: () {
                            soundManager.playClickSound();
                            Navigator.pushNamed(context, AppRoutes.questionLoadingScreen, arguments:{ 'gameType': 'pilgrim_progress', 'selectedLevel': 'elder'});
                          },
                          textSpan: RichText(
                              text: TextSpan(
                                  text: 'Welcome to the peak! Test how skillful',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: const Color(0xFF22210D),
                                    height: 1.5,
                                  ),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: '\n& knowledgeable you’ve become',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                              ])),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
