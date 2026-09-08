import 'package:bible_game/features/global_challenge/view/tablet_view/home_screen_tablet_view.dart';
import 'package:bible_game/features/arcade/cubit/arcade_tab_cubit.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/widgets/login_gate_widget.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_game/features/global_challenge/view/home_screen.dart';
import 'package:bible_game/features/multi_player/view/home_screen.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/widgets/screen_app_bar.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../../shared/widgets/tab_button.dart';

class ArcadeScreenTabletView extends StatefulWidget {
  const ArcadeScreenTabletView({super.key});

  @override
  State<ArcadeScreenTabletView> createState() => _ArcadeScreenTabletViewState();
}

class _ArcadeScreenTabletViewState extends State<ArcadeScreenTabletView> {

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final double usableHeight = screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom;
    final soundManager = context.read<SettingsBloc>().soundManager;
    final _selectedGlobalChallenge =
        context.watch<ArcadeTabCubit>().state == ArcadeTab.globalChallenge;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: AppColors.primaryColorShade,// Status bar color
      ),
      backgroundColor: Color(0xFF014AA0),
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
                height: 70.h,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TabButton(
                        width: 239,
                        buttonText: 'Multiplayer',
                        buttonSelected: !_selectedGlobalChallenge,
                        onTap: () {
                          soundManager.playClickSound();
                          context.read<ArcadeTabCubit>().showMultiplayer();
                        },
                      ),
                      SizedBox(width: 50.w,),
                      TabButton(
                        width: 239,
                        buttonText: 'Global Challenge',
                        buttonSelected: _selectedGlobalChallenge,
                        onTap: () {
                          soundManager.playClickSound();
                          context.read<ArcadeTabCubit>().showGlobalChallenge();
                        },
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Expanded(
                child: _selectedGlobalChallenge
                    ? GlobalChallengeHomeScreenTabletView()
                    : Builder(
                        builder: (context) {
                          final isLoggedIn = context
                                  .watch<AuthenticationBloc>()
                                  .state
                                  .user
                                  .id !=
                              0;
                          if (!isLoggedIn) {
                            return const LoginGateWidget(
                              featureTitle: 'Multiplayer',
                              subtitle:
                                  'Log in or create a profile\nto play against your friends!',
                              icon: Icons.groups_rounded,
                            );
                          }
                          return const MultiplayerHomeBody(bottomSpacing: 20);
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
