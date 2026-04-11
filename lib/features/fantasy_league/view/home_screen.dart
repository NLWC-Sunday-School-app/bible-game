import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/fantasy_league/widget/create_league.dart';
import 'package:bible_game/features/fantasy_league/widget/join_league.dart';
import 'package:bible_game/features/fantasy_league/widget/my_leagues.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/features/connectivity/bloc/connectivity_bloc.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../shared/widgets/offline_banner.dart';
import '../../../shared/widgets/screen_app_bar.dart';
import '../../../shared/widgets/tab_button.dart';
import '../../../shared/widgets/login_gate_widget.dart';

class FantasyLeagueHomeScreen extends StatefulWidget {
  const FantasyLeagueHomeScreen({super.key});

  @override
  State<FantasyLeagueHomeScreen> createState() =>
      _FantasyLeagueHomeScreenState();
}

class _FantasyLeagueHomeScreenState extends State<FantasyLeagueHomeScreen> {
  bool _selectedCreate = true;
  bool _selectedJoin = false;
  bool _selectedMyLeague = false;

  void showCreateLeague (){
     setState(() {
       _selectedJoin = false;
       _selectedCreate = true;
       _selectedMyLeague = false;
     });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final double usableHeight = screenHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final soundManager = context.read<SettingsBloc>().soundManager;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: AppColors.primaryColorShade, // Status bar color
      ),
      backgroundColor: const Color(0xFF014AA0),
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
                  height: 80.h,
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
                SizedBox(
                  height: 20.h,
                ),
                BlocBuilder<ConnectivityBloc, ConnectivityState>(
                  builder: (context, connectivityState) {
                    if (!connectivityState.isOnline) {
                      return Padding(
                        padding: EdgeInsets.only(top: 60.h),
                        child: const OfflineBanner(
                          subtitle: 'Fantasy League requires an internet connection.\nPlease reconnect to access your leagues.',
                        ),
                      );
                    }

                    final isLoggedIn = context.read<AuthenticationBloc>().state.user.id != 0;

                    if (!isLoggedIn) {
                      return const LoginGateWidget(
                        featureTitle: 'Fantasy League',
                        subtitle: 'Log in or create a profile\nto join the Fantasy Bible League!',
                        icon: Icons.emoji_events_rounded,
                      );
                    }

                    return Column(
                      children: [
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
                                  width: 105,
                                  buttonText: 'Create',
                                  buttonSelected: _selectedCreate,
                                  onTap: () {
                                    soundManager.playClickSound();
                                    setState(() {
                                      _selectedJoin = false;
                                      _selectedCreate = true;
                                      _selectedMyLeague = false;
                                    });
                                  },
                                ),
                                TabButton(
                                  width: 105,
                                  buttonText: 'Join',
                                  buttonSelected: _selectedJoin,
                                  onTap: () {
                                    soundManager.playClickSound();
                                    setState(() {
                                      _selectedJoin = true;
                                      _selectedCreate = false;
                                      _selectedMyLeague = false;
                                    });
                                  },
                                ),
                                TabButton(
                                  width: 105,
                                  buttonText: 'My leagues',
                                  buttonSelected: _selectedMyLeague,
                                  onTap: () {
                                    soundManager.playClickSound();
                                    setState(() {
                                      _selectedJoin = false;
                                      _selectedCreate = false;
                                      _selectedMyLeague = true;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        _selectedCreate
                            ? CreateLeague(screenHeight: usableHeight)
                            : _selectedJoin
                                ? JoinLeague(screenHeight: usableHeight, showCreateLeague: showCreateLeague)
                                : MyLeagues(screenHeight: usableHeight),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
