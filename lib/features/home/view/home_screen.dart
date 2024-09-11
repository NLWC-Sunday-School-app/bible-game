import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_bible_game/features/four_scriptures/bloc/four_scriptures_one_word_bloc.dart';
import 'package:the_bible_game/features/home/widget/game_card.dart';
import 'package:the_bible_game/features/home/widget/game_score_info.dart';
import 'package:the_bible_game/features/home/widget/global_challenge_countdown.dart';
import 'package:the_bible_game/features/home/widget/home_ads_slider.dart';
import 'package:the_bible_game/features/home/widget/sign_in_profile.dart';
import 'package:the_bible_game/shared/constants/app_routes.dart';
import 'package:the_bible_game/shared/constants/colors.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:the_bible_game/shared/utils/avatar_credentials.dart';
import 'package:the_bible_game/shared/utils/user_badge.dart';

import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../shared/widgets/modal/network_modal.dart';
import '../../global_challenge/bloc/global_challenge_bloc.dart';
import '../../pilgrim_progress/bloc/pilgrim_progress_bloc.dart';
import '../widget/user_profile_info.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  Duration _duration = Duration();
  bool _globalChallengeIsComingSoon = false;

  Future<void> setSoundState() async {
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    final soundManager = settingsBloc.soundManager;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic isMusicOn = prefs.getBool('isMusicOn') ?? true;
    dynamic isSoundOn = prefs.getBool('isSoundOn') ?? true;
    settingsBloc.add(UpdateSoundState(isMusicOn, isSoundOn));
    if (isMusicOn) {
      soundManager.playGameMusic();
    }
  }

  initializeWallet() {
    final userState = BlocProvider.of<AuthenticationBloc>(context).state;
    if (userState.user.id != 0) {
      if (!userState.user.isWalletInitialized) {
        context.read<UserBloc>().add(InitializeWallet());
      }
    }
  }

  fetchGameData() {
    final userState = BlocProvider.of<AuthenticationBloc>(context).state;
    if (userState.user.id != 0) {
      BlocProvider.of<PilgrimProgressBloc>(context)
          .add(FetchPilgrimProgressLevelData());
      BlocProvider.of<UserBloc>(context).add(FetchUserStreakDetails());
      BlocProvider.of<AuthenticationBloc>(context)
          .add(FetchUserDataRequested());
      BlocProvider.of<GlobalChallengeBloc>(context)
          .add(FetchGlobalChallengeGames());
    }
  }

  setGlobalChallengeTimer() {
    final globalChallenge = BlocProvider.of<GlobalChallengeBloc>(context)
        .state
        .globalChallengeGames;
    final topGlobalChallenge = globalChallenge[0];
    if (topGlobalChallenge.isComingSoon!) {
      setState(() {
        _globalChallengeIsComingSoon = true;
      });
      DateTime targetDate = DateTime.parse(topGlobalChallenge.startDate!);
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        final now = DateTime.now();
        final difference = targetDate.difference(now);
        if (difference.isNegative) {
          timer.cancel();
        } else {
          setState(() {
            _duration = difference;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setSoundState();
    initializeWallet();
    fetchGameData();
    setGlobalChallengeTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,###,###');
    double screenHeight = MediaQuery.of(context).size.height;
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    final soundManager = settingsBloc.soundManager;
    final days = _duration.inDays;
    final hours = _duration.inHours.remainder(24);
    final minutes = _duration.inMinutes.remainder(60);
    final seconds = _duration.inSeconds.remainder(60);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF548CD7),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ProductImageRoutes.homeScreenBg),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 60.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    image: DecorationImage(
                      image: AssetImage(ProductImageRoutes.patternBg),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.r),
                      bottomRight: Radius.circular(8.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentColor,
                        offset: Offset(0, 8),
                        blurRadius: 0,
                        spreadRadius: -2,
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15.w, right: 15.w),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        height: screenHeight - (200.h + 10.h ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  state.user.id != 0
                                      ? UserProfileInfo(
                                          user: state.user,
                                          badgeSrc:
                                              getBadgeUrl(state.user.rank),
                                          avatarUrl:
                                              '${AvatarCredentials.BaseURL}/${state.user.id}.svg?apikey=${AvatarCredentials.APIKey}/',
                                          displayBadgeInfo: () {},
                                        )
                                      : SignInProfile(),
                                  GameScoreInfo(
                                    noOfCoins: state.user.id != 0
                                        ? formatter.format(
                                            state.user.coinWalletBalance)
                                        : '0',
                                    noOfGems: state.user.id != 0
                                        ? state.user.gems.toString()
                                        : '0',
                                    noOfStreaks: state.user.id != 0
                                        ? state.user.streak.toString()
                                        : '0',
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              _globalChallengeIsComingSoon
                                  ? GlobalChallengeCountDown(
                                      days: days,
                                      hours: hours,
                                      minutes: minutes,
                                      seconds: seconds,
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 10.h,
                              ),
                              GameCard(
                                bgColor: AppColors.primaryColor,
                                gameType: 'Quick Game',
                                gameText: 'Play on your own terms!',
                                gameImage: ProductImageRoutes.crossBible,
                                gameImageWidth: 100.w,
                                onTap: () {
                                  soundManager.playClickSound();
                                  if (state.user.id != 0) {
                                    Navigator.pushNamed(
                                        context, AppRoutes.quickGameHomeScreen);
                                  } else {
                                    Navigator.pushNamed(
                                        context, AppRoutes.profileScreen);
                                  }
                                },
                              ),
                              GameCard(
                                bgColor: AppColors.wiwGameCard,
                                gameType: 'Who is Who',
                                gameText: 'Learn Bible names & stories!',
                                gameImage: ProductImageRoutes.wiwMask,
                                gameImageWidth: 90.w,
                                onTap: () {
                                  soundManager.playClickSound();
                                  if (state.user.id != 0) {
                                    Navigator.pushNamed(
                                        context, AppRoutes.whoIsWhoHomeScreen);
                                  } else {
                                    Navigator.pushNamed(
                                        context, AppRoutes.profileScreen);
                                  }
                                },
                              ),
                              GameCard(
                                bgColor: AppColors.pilgrimProgressGameCard,
                                gameType: 'Pilgrim Progress',
                                gameText: 'Journey through the Bible!',
                                gameImage: ProductImageRoutes.mountain,
                                gameImageWidth: 75.w,
                                onTap: () {
                                  soundManager.playClickSound();
                                  if (state.user.id != 0) {
                                    Navigator.pushNamed(context,
                                        AppRoutes.pilgrimProgressHomeScreen);
                                  } else {
                                    Navigator.pushNamed(
                                        context, AppRoutes.profileScreen);
                                  }
                                },
                              ),
                              GameCard(
                                bgColor: AppColors.fourScripturesGameCard,
                                gameType: '4 Scriptures, 1 Word',
                                gameText: 'Journey through the Bible!',
                                gameImage: ProductImageRoutes.scroll,
                                gameImageWidth: 80.w,
                                onTap: () {
                                  soundManager.playClickSound();
                                  if (state.user.id != 0) {
                                    Navigator.pushNamed(context,
                                        AppRoutes.questionLoadingScreen,
                                        arguments: {
                                          'gameType': 'four_scriptures_game'
                                        });
                                  } else {
                                    Navigator.pushNamed(
                                        context, AppRoutes.profileScreen);
                                  }
                                },
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'BG Billboard',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1,
                                    fontSize: 22.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              HomeAdsSlider()
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
