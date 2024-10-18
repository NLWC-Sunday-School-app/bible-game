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
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../shared/widgets/green_button.dart';
import '../../../shared/widgets/screen_app_bar.dart';
import '../../../shared/widgets/tab_button.dart';
import '../../home/widget/modals/create_profile_modal.dart';
import '../../home/widget/modals/login_modal.dart';

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
                context.read<AuthenticationBloc>().state.user.id != 0
                    ? Padding(
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
                              )
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 10.h,
                ),
                context.read<AuthenticationBloc>().state.user.id != 0
                    ? _selectedCreate
                        ? CreateLeague(
                            screenHeight: usableHeight,
                          )
                        : _selectedJoin
                            ? JoinLeague(
                                screenHeight: usableHeight, showCreateLeague: showCreateLeague,
                              )
                            : MyLeagues(
                                screenHeight: usableHeight,
                              )
                    :  Column(
                  children: [
                    SizedBox(
                      height: 100.h,
                    ),
                    GreenButton(
                      onTap: () {
                        soundManager.playClickSound();
                        showLoginModal(context);
                      },
                      buttonIsLoading: false,
                      width: 350.w,
                      customWidget: Center(
                        child: StrokeText(
                          text: 'Log In',
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          strokeColor: const Color(0xFF272D39),
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h,),
                    GestureDetector(
                      onTap: () {
                        soundManager.playClickSound();
                        showCreateProfileModal(context);
                      },
                      child: Container(
                        width: 350.w,
                        padding:
                        EdgeInsets.symmetric(vertical: 15.h),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  ProductImageRoutes.newBlueBtnBg),
                              fit: BoxFit.fill,
                            )),
                        child: Center(
                          child: StrokeText(
                            text: 'Create Profile',
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                            strokeColor: const Color(0xFF272D39),
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
