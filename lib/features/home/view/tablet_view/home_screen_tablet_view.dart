import 'dart:async';

import 'package:bible_game/features/home/widget/tablet_view_widget/game_card_tablet_view.dart';
import 'package:bible_game/features/home/widget/tablet_view_widget/game_score_info_tablet_view.dart';
import 'package:bible_game/features/home/widget/tablet_view_widget/sign_in_profile_tablet_view.dart';
import 'package:bible_game/features/home/widget/tablet_view_widget/user_profile_info_tablet_view.dart';
import 'package:bible_game/features/recap/widget/recap_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bible_game/features/four_scriptures/bloc/four_scriptures_one_word_bloc.dart';
import 'package:bible_game/features/home/widget/game_card.dart';
import 'package:bible_game/features/home/widget/game_score_info.dart';
import 'package:bible_game/features/home/widget/global_challenge_countdown.dart';
import 'package:bible_game/features/home/widget/home_ads_slider.dart';
import 'package:bible_game/features/home/widget/sign_in_profile.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:bible_game/shared/utils/user_badge.dart';
import 'package:upgrader/upgrader.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../../shared/utils/device_info.dart';
import '../../../../shared/utils/multiavatar_generator.dart';
import '../../../global_challenge/bloc/global_challenge_bloc.dart';
import '../../../pilgrim_progress/bloc/pilgrim_progress_bloc.dart';
import '../../widget/user_profile_info.dart';

class HomeScreenTabletView extends StatefulWidget {
  const HomeScreenTabletView({super.key});

  @override
  State<HomeScreenTabletView> createState() => _HomeScreenTabletViewState();
}

class _HomeScreenTabletViewState extends State<HomeScreenTabletView> {
  Timer? _timer;
  Duration _duration = Duration();
  bool _globalChallengeIsComingSoon = false;
  late DrawableRoot svgRoot;
  MultiavatarGenerator generator = MultiavatarGenerator();
  final DeviceInfoService _deviceInfoService = DeviceInfoService();
  Map<String, String> _deviceInfo = {};


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

  Future<void> _loadDeviceInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final info = await _deviceInfoService.getDeviceInfo();
    setState(() {
      _deviceInfo = info;
    });
    prefs.setString('deviceName', _deviceInfo['deviceName']!);
    prefs.setString('deviceOs', _deviceInfo['osVersion']!);

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
      BlocProvider.of<UserBloc>(context).add(FetchUserYearlyRecap());
      BlocProvider.of<AuthenticationBloc>(context)
          .add(FetchUserDataRequested());
      BlocProvider.of<GlobalChallengeBloc>(context)
          .add(FetchGlobalChallengeGames());
    }
  }

  setGlobalChallengeTimer() {
    final userState = BlocProvider.of<AuthenticationBloc>(context).state;
    if (userState.user.id != 0) {
      final globalChallenge = BlocProvider.of<GlobalChallengeBloc>(context)
          .state
          .globalChallengeGames;
        if(globalChallenge.isNotEmpty){
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

    }
  }

  Future<void> clearUpgraderSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userIgnoredVersion');
    await prefs.remove('lastTimeAlerted');
    await prefs.remove('lastVersionAlerted');
  }

  @override
  void initState() {
    super.initState();
    clearUpgraderSharedPreferences();
    setSoundState();
    initializeWallet();
    fetchGameData();
    setGlobalChallengeTimer();
    _loadDeviceInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<SettingsBloc>(context).add(FetchGamePlaySettings());
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
    double screenWidth = MediaQuery.of(context).size.width;
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
          return UpgradeAlert(
            showIgnore: false,
            showLater: false,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.homeScreenBg),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 43,
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
                  Expanded(
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
                                  ? UserProfileInfoTabletView(
                                      user: state.user,
                                      badgeSrc:
                                          getBadgeUrl(state.user.rank),
                                      avatarUrl:
                                          '${state.user.id.toString()}',
                                      displayBadgeInfo: () {},
                                    )
                                  : SignInProfileTabletView(),
                              GameScoreInfoTabletView(
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
                          BlocBuilder<SettingsBloc, SettingsState>(
                            builder: (context, state) {
                              return SizedBox(
                                  child:
                                      state.gamePlaySettings[
                                                      'show_recap'] ==
                                                  "true" &&
                                              BlocProvider.of<AuthenticationBloc>(context).state.user.id != 0
                                          ? RecapButton()
                                          : SizedBox());
                            },
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 100.w),
                            child: Column(
                              children: [
                                GameCardTabletView(
                                  bgColor: AppColors.primaryColor,
                                  gameType: 'Quick Game',
                                  gameText: 'Play on your own terms!',
                                  gameImage: ProductImageRoutes.crossBible,
                                  gameImageWidth: screenWidth <= 380
                                      ? 80.w
                                      : screenWidth > 380 && screenWidth < 430
                                          ? 95.w
                                          : 100.w,
                                  onTap: () {
                                    soundManager.playClickSound();
                                    if (state.user.id != 0) {
                                      Navigator.pushNamed(context,
                                          AppRoutes.quickGameHomeScreen);
                                    } else {
                                      Navigator.pushNamed(
                                          context, AppRoutes.profileScreen);
                                    }
                                  },
                                ),
                                GameCardTabletView(
                                  bgColor: AppColors.wiwGameCard,
                                  gameType: 'Who is Who',
                                  gameText: 'Learn Bible names & stories!',
                                  gameImage: ProductImageRoutes.wiwMask,
                                  gameImageWidth: screenWidth <= 380
                                      ? 70.w
                                      : screenWidth > 380 && screenWidth < 430
                                          ? 84.w
                                          : 90.w,
                                  onTap: () {
                                    soundManager.playClickSound();
                                    if (state.user.id != 0) {
                                      Navigator.pushNamed(context,
                                          AppRoutes.whoIsWhoHomeScreen);
                                    } else {
                                      Navigator.pushNamed(
                                          context, AppRoutes.profileScreen);
                                    }
                                  },
                                ),
                                GameCardTabletView(
                                  bgColor: AppColors.pilgrimProgressGameCard,
                                  gameType: 'Pilgrim Progress',
                                  gameText: 'Journey through the Bible!',
                                  gameImage: ProductImageRoutes.mountain,
                                  gameImageWidth: screenWidth <= 380
                                      ? 60.w
                                      : screenWidth > 380 && screenWidth < 430
                                          ? 70.w
                                          : 90.w,
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
                                GameCardTabletView(
                                  bgColor: AppColors.fourScripturesGameCard,
                                  gameType: '4 Scriptures, 1 Word',
                                  gameText: 'Journey through the Bible!',
                                  gameImage: ProductImageRoutes.scroll,
                                  gameImageWidth: screenWidth <= 380
                                      ? 70.w
                                      : screenWidth > 380 && screenWidth < 430
                                          ? 75.w
                                          : 80.w,
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
                              ],
                            ),
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
                          HomeAdsSlider(),
                          SizedBox(height: 150.h,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
