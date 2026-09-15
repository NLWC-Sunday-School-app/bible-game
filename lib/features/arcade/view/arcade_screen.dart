import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:flutter/material.dart';
import 'package:bible_game/features/arcade/cubit/arcade_tab_cubit.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/widgets/login_gate_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_game/features/global_challenge/view/home_screen.dart';
import 'package:bible_game/features/multi_player/view/home_screen.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/features/connectivity/bloc/connectivity_bloc.dart';
import 'package:bible_game/shared/widgets/offline_banner.dart';
import 'package:bible_game/shared/widgets/screen_app_bar.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/constants/image_routes.dart';
import '../../../shared/features/localization/app_localization.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../shared/widgets/tab_button.dart';

class ArcadeScreen extends StatefulWidget {
  const ArcadeScreen({super.key});

  @override
  State<ArcadeScreen> createState() => _ArcadeScreenState();
}

class _ArcadeScreenState extends State<ArcadeScreen> {

  @override
  void initState() {
    super.initState();
    // Belongs to the Arcade screen rather than MultiplayerHomeBody: that body
    // only mounts on the Multiplayer sub-tab, so sitting on Global Challenge
    // meant the Game Requests count never refreshed at all. Entering the tab
    // refreshes it either way.
    context.read<MultiplayerBloc>().add(CountInvite());
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final double usableHeight = screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom;
    final soundManager = context.read<SettingsBloc>().soundManager;
    final tr = AppLocalization.tr(context);
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
        child: SingleChildScrollView(
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
                        text: tr.t('arcade_title'),
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
                          width: 164,
                          buttonText: tr.t('arcade_multiplayer'),
                          buttonSelected: !_selectedGlobalChallenge,
                          onTap: () {
                            soundManager.playClickSound();
                            context.read<ArcadeTabCubit>().showMultiplayer();
                          },
                        ),
                        TabButton(
                          width: 164,
                          buttonText: tr.t('arcade_global_challenge'),
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
                BlocBuilder<ConnectivityBloc, ConnectivityState>(
                  builder: (context, connectivityState) {
                    if (!connectivityState.isOnline) {
                      return Padding(
                        padding: EdgeInsets.only(top: 60.h),
                        child: OfflineBanner(
                          subtitle: tr.t('arcade_offline_message'),
                        ),
                      );
                    }
                    if (!_selectedGlobalChallenge) {
                      final isLoggedIn = context
                              .watch<AuthenticationBloc>()
                              .state
                              .user
                              .id !=
                          0;
                      if (!isLoggedIn) {
                        return SizedBox(
                          height:
                              usableHeight - (70.h + 20.h + 72.h + 120.h),
                          child: const LoginGateWidget(
                            featureTitle: 'Multiplayer',
                            subtitle:
                                'Log in or create a profile\nto play against your friends!',
                            icon: Icons.groups_rounded,
                          ),
                        );
                      }
                    }
                    return SizedBox(
                      height: usableHeight - (70.h + 20.h + 72.h + 120.h),
                      child: _selectedGlobalChallenge
                          ? GlobalChallengeHomeScreen()
                          : MultiplayerHomeBody(bottomSpacing: 20.h),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
