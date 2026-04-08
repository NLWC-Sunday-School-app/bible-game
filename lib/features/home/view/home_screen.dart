import 'dart:async';

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
import 'package:bible_game/shared/utils/avatar_credentials.dart';
import 'package:bible_game/shared/utils/user_badge.dart';
import 'package:upgrader/upgrader.dart';

import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../shared/utils/device_info.dart';
import '../../../shared/utils/multiavatar_generator.dart';
import '../../../shared/utils/svg_drawer.dart';
import '../../../shared/widgets/modal/network_modal.dart';
import '../../global_challenge/bloc/global_challenge_bloc.dart';
import '../../pilgrim_progress/bloc/pilgrim_progress_bloc.dart';
import '../../recap/home.dart';
import '../widget/user_profile_info.dart';
import 'package:intl/intl.dart';
import 'package:bible_game/features/daily_devotional/bloc/daily_devotional_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ---------------------------------------------------------------------------
// Game card data model
// ---------------------------------------------------------------------------

class _GameEntry {
  final Color bgColor;
  final String gameType;
  final String gameText;
  final String gameImage;
  final double smallWidth;
  final double mediumWidth;
  final double largeWidth;
  final String route;
  final Object? routeArguments;

  const _GameEntry({
    required this.bgColor,
    required this.gameType,
    required this.gameText,
    required this.gameImage,
    required this.smallWidth,
    required this.mediumWidth,
    required this.largeWidth,
    required this.route,
    this.routeArguments,
  });
}

const _gameEntries = [
  _GameEntry(
    bgColor: AppColors.storyModeGameCard,
    gameType: 'Story Mode',
    gameText: 'Journey through Bible narratives!',
    gameImage: ProductImageRoutes.scroll,
    smallWidth: 70,
    mediumWidth: 80,
    largeWidth: 90,
    route: AppRoutes.storySelectionScreen,
  ),
  _GameEntry(
    bgColor: AppColors.primaryColor,
    gameType: 'Quick Game',
    gameText: 'Play on your own terms!',
    gameImage: ProductImageRoutes.crossBible,
    smallWidth: 80,
    mediumWidth: 95,
    largeWidth: 100,
    route: AppRoutes.quickGameHomeScreen,
  ),
  _GameEntry(
    bgColor: AppColors.wiwGameCard,
    gameType: 'Who is Who',
    gameText: 'Learn Bible names & stories!',
    gameImage: ProductImageRoutes.wiwMask,
    smallWidth: 70,
    mediumWidth: 84,
    largeWidth: 90,
    route: AppRoutes.whoIsWhoHomeScreen,
  ),
  _GameEntry(
    bgColor: AppColors.pilgrimProgressGameCard,
    gameType: 'Pilgrim Progress',
    gameText: 'Journey through the Bible!',
    gameImage: ProductImageRoutes.mountain,
    smallWidth: 60,
    mediumWidth: 70,
    largeWidth: 90,
    route: AppRoutes.pilgrimProgressHomeScreen,
  ),
  _GameEntry(
    bgColor: AppColors.fourScripturesGameCard,
    gameType: '4 Scriptures, 1 Word',
    gameText: 'Journey through the Bible!',
    gameImage: ProductImageRoutes.scroll,
    smallWidth: 70,
    mediumWidth: 75,
    largeWidth: 80,
    route: AppRoutes.questionLoadingScreen,
    routeArguments: {'gameType': 'four_scriptures_game'},
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      backgroundColor: AppColors.homeAppBar,
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        buildWhen: (prev, curr) => prev.user != curr.user,
        builder: (context, state) {
          return UpgradeAlert(
            showIgnore: false,
            showLater: false,
            child: Container(
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
                          height: screenHeight - (200.h),
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
                                                '${state.user.id.toString()}',
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
                                BlocBuilder<SettingsBloc, SettingsState>(
                                  buildWhen: (prev, curr) =>
                                      prev.gamePlaySettings['show_recap'] !=
                                      curr.gamePlaySettings['show_recap'],
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
                                SizedBox(height: 10.h),
                                _DailyDevotionalBanner(),
                                SizedBox(height: 10.h),
                                ..._gameEntries.map((entry) {
                                  final imageWidth = screenWidth <= 380
                                      ? entry.smallWidth.w
                                      : screenWidth < 430
                                          ? entry.mediumWidth.w
                                          : entry.largeWidth.w;
                                  return GameCard(
                                    bgColor: entry.bgColor,
                                    gameType: entry.gameType,
                                    gameText: entry.gameText,
                                    gameImage: entry.gameImage,
                                    gameImageWidth: imageWidth,
                                    onTap: () {
                                      soundManager.playClickSound();
                                      if (state.user.id != 0) {
                                        Navigator.pushNamed(
                                          context,
                                          entry.route,
                                          arguments: entry.routeArguments,
                                        );
                                      } else {
                                        Navigator.pushNamed(
                                            context, AppRoutes.profileScreen);
                                      }
                                    },
                                  );
                                }),
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
            ),
          );
        },
      ),
    );
  }
}

class _DailyDevotionalBanner extends StatelessWidget {
  const _DailyDevotionalBanner();

  @override
  Widget build(BuildContext context) {
    final soundManager =
        BlocProvider.of<SettingsBloc>(context).soundManager;
    return BlocBuilder<DailyDevotionalBloc, DailyDevotionalState>(
      builder: (context, state) {
        final completed = state.hasCompletedToday;
        return GestureDetector(
          onTap: () {
            soundManager.playClickSound();
            Navigator.pushNamed(
                context, AppRoutes.dailyDevotionalScreen);
          },
          child: Container(
            width: double.infinity,
            padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: completed
                    ? [
                        const Color(0xFF2E7D32),
                        const Color(0xFF1B5E20),
                      ]
                    : [
                        const Color(0xFF6B4C9A),
                        const Color(0xFF4A2C7A),
                      ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Row(
              children: [
                Text(
                  completed ? '✅' : '📖',
                  style: TextStyle(fontSize: 24.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Devotional',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Neuland',
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        completed
                            ? 'Completed! Come back tomorrow'
                            : 'Read, reflect & answer today\'s question',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.devotionalStreak > 0) ...[
                  Text('🔥', style: TextStyle(fontSize: 14.sp)),
                  SizedBox(width: 4.w),
                  Text(
                    '${state.devotionalStreak}',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
                Icon(Icons.chevron_right,
                    color: Colors.white70, size: 20.sp),
              ],
            ),
          ),
        );
      },
    );
  }
}
