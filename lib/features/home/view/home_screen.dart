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
import 'package:bible_game/shared/widgets/did_you_know_carousel.dart';
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
import '../../../shared/features/connectivity/bloc/connectivity_bloc.dart';
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
import 'package:bible_game/shared/features/localization/app_localization.dart';

// ---------------------------------------------------------------------------
// Game card data model
// ---------------------------------------------------------------------------

class _GameEntry {
  final Color bgColor;
  final String gameType;
  final String gameText;
  final String gameTypeKey;
  final String gameTextKey;
  final String gameImage;
  final double smallWidth;
  final double mediumWidth;
  final double largeWidth;
  final String route;
  final Object? routeArguments;
  final bool requiresNetwork;

  const _GameEntry({
    required this.bgColor,
    required this.gameType,
    required this.gameText,
    required this.gameTypeKey,
    required this.gameTextKey,
    required this.gameImage,
    required this.smallWidth,
    required this.mediumWidth,
    required this.largeWidth,
    required this.route,
    this.routeArguments,
    this.requiresNetwork = true,
  });
}

const _gameEntries = [
  _GameEntry(
    bgColor: AppColors.storyModeGameCard,
    gameType: 'Story Mode',
    gameText: 'Journey through Bible narratives!',
    gameTypeKey: 'game_story_mode',
    gameTextKey: 'game_story_mode_desc',
    gameImage: IconImageRoutes.purpleBook,
    smallWidth: 70,
    mediumWidth: 80,
    largeWidth: 90,
    route: AppRoutes.storySelectionScreen,
    requiresNetwork: false,
  ),
  _GameEntry(
    bgColor: AppColors.primaryColor,
    gameType: 'Quick Game',
    gameText: 'Play on your own terms!',
    gameTypeKey: 'game_quick_game',
    gameTextKey: 'game_quick_game_desc',
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
    gameTypeKey: 'game_who_is_who',
    gameTextKey: 'game_who_is_who_desc',
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
    gameTypeKey: 'game_pilgrim_progress',
    gameTextKey: 'game_pilgrim_progress_desc',
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
    gameTypeKey: 'game_four_scriptures',
    gameTextKey: 'game_four_scriptures_desc',
    gameImage: ProductImageRoutes.scroll,
    smallWidth: 70,
    mediumWidth: 75,
    largeWidth: 80,
    route: AppRoutes.questionLoadingScreen,
    routeArguments: {'gameType': 'four_scriptures_game'},
  ),
  _GameEntry(
    bgColor: const Color(0xFFC67B3C),
    gameType: 'True or False',
    gameText: 'Test your knowledge!',
    gameTypeKey: 'game_true_or_false',
    gameTextKey: 'game_true_or_false_desc',
    gameImage: ProductImageRoutes.trueOrFalseIcon,
    smallWidth: 65,
    mediumWidth: 75,
    largeWidth: 85,
    route: AppRoutes.trueOrFalseHomeScreen,
    requiresNetwork: false,
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
    _loadDeviceInfo();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isOffline = !context.read<ConnectivityBloc>().state.isOnline;
      if (!isOffline) {
        initializeWallet();
        fetchGameData();
        setGlobalChallengeTimer();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isOffline = !context.read<ConnectivityBloc>().state.isOnline;
    if (!isOffline) {
      BlocProvider.of<SettingsBloc>(context).add(FetchGamePlaySettings());
    }
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
                                BlocBuilder<ConnectivityBloc, ConnectivityState>(
                                  buildWhen: (prev, curr) =>
                                      prev.isOnline != curr.isOnline ||
                                      prev.pendingSyncCount != curr.pendingSyncCount,
                                  builder: (context, connState) {
                                    final tr = AppLocalization.tr(context);
                                    return Column(
                                      children: [
                                        if (!connState.isOnline)
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.w, vertical: 8.h),
                                            margin: EdgeInsets.only(bottom: 10.h),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.shade900
                                                  .withValues(alpha: 0.85),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(Icons.wifi_off,
                                                    color: Colors.white,
                                                    size: 18.sp),
                                                SizedBox(width: 8.w),
                                                Expanded(
                                                  child: Text(
                                                    tr.t('offline_banner'),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (connState.pendingSyncCount > 0)
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.w, vertical: 8.h),
                                            margin: EdgeInsets.only(bottom: 10.h),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade800
                                                  .withValues(alpha: 0.85),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(Icons.cloud_sync,
                                                    color: Colors.white,
                                                    size: 18.sp),
                                                SizedBox(width: 8.w),
                                                Expanded(
                                                  child: Text(
                                                    tr.t('scores_pending_sync', {'count': '${connState.pendingSyncCount}', 'plural': connState.pendingSyncCount > 1 ? 's' : ''}),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                                _DailyDevotionalBanner(),
                                SizedBox(height: 14.h),
                                // ── All game modes in a 2-column grid ──
                                Wrap(
                                  spacing: 10.w,
                                  runSpacing: 10.h,
                                  children: List.generate(
                                      _gameEntries.length, (index) {
                                    final e = _gameEntries[index];
                                    final tr = AppLocalization.tr(context);
                                    final isOffline = !context
                                        .read<ConnectivityBloc>()
                                        .state
                                        .isOnline;
                                    final disabled =
                                        isOffline && e.requiresNetwork;
                                    return SizedBox(
                                      width: (screenWidth - 40.w) / 2,
                                      child: _GameTileCard(
                                        entry: e,
                                        isDisabled: disabled,
                                        onTap: () {
                                          if (disabled) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  tr.t('requires_internet', {'game': tr.t(e.gameTypeKey)})),
                                              duration:
                                                  const Duration(seconds: 2),
                                              backgroundColor: Colors.black87,
                                            ));
                                            return;
                                          }
                                          soundManager.playClickSound();
                                          if (!e.requiresNetwork ||
                                              state.user.id != 0) {
                                            Navigator.pushNamed(
                                              context,
                                              e.route,
                                              arguments: e.routeArguments,
                                            );
                                          } else {
                                            Navigator.pushNamed(context,
                                                AppRoutes.profileScreen);
                                          }
                                        },
                                      ),
                                    );
                                  }),
                                ),
                                SizedBox(height: 14.h),
                                const DidYouKnowCarousel(),
                                // if (!_isOffline) ...[
                                //   SizedBox(height: 20.h),
                                //   Align(
                                //     alignment: Alignment.center,
                                //     child: Text(
                                //       'BG Billboard',
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.w900,
                                //         letterSpacing: 1,
                                //         fontSize: 22.sp,
                                //         color: Colors.white,
                                //       ),
                                //     ),
                                //   ),
                                //   SizedBox(height: 15.h),
                                //   HomeAdsSlider(),
                                // ]
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
    final tr = AppLocalization.tr(context);
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
                        tr.t('daily_devotional'),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Neuland',
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        completed
                            ? tr.t('daily_devotional_completed')
                            : tr.t('daily_devotional_prompt'),
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

// ─── Game tile card for horizontal scroll ───────────────────────────────────

class _GameTileCard extends StatelessWidget {
  const _GameTileCard({
    required this.entry,
    required this.isDisabled,
    required this.onTap,
  });
  final _GameEntry entry;
  final bool isDisabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double imageWidth = entry.smallWidth.w;
    final tr = AppLocalization.tr(context);

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isDisabled ? 0.40 : 1.0,
        child: Container(
          height: 130.h,
          decoration: BoxDecoration(
            color: entry.bgColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: entry.bgColor.withValues(alpha: 0.5),
                offset: const Offset(0, 4),
                blurRadius: 8,
                spreadRadius: -2,
              ),
            ],
          ),
          child: Stack(
            children: [
              // ── Game image (top-right area) ──
              Positioned(
                right: 6.w,
                top: 8.h,
                child: Opacity(
                  opacity: 0.85,
                  child: entry.gameImage.endsWith('.svg')
                      ? SvgPicture.asset(
                          entry.gameImage,
                          width: imageWidth,
                        )
                      : Image.asset(
                          entry.gameImage,
                          width: imageWidth,
                        ),
                ),
              ),
              // ── Offline badge (top-left) ──
              if (!entry.requiresNetwork)
                Positioned(
                  left: 8.w,
                  top: 8.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 6.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.wifi_off_rounded,
                            color: Colors.white, size: 10.sp),
                        SizedBox(width: 3.w),
                        Text(
                          tr.t('offline_badge'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // ── Text content (bottom-left) ──
              Positioned(
                left: 14.w,
                right: 14.w,
                bottom: 14.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tr.t(entry.gameTypeKey),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      tr.t(entry.gameTextKey),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
