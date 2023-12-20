import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/auth_controller.dart';
import 'package:bible_game/controllers/pilgrim_progress_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/screens/pilgrim_progress/home.dart';
import 'package:bible_game/screens/pilgrim_progress/new_level.dart';
import 'package:bible_game/screens/pilgrim_progress/retry_level.dart';
import 'package:bible_game/screens/quick_game/step_one.dart';
import 'package:bible_game/screens/who_is_who/home.dart';
import 'package:bible_game/services/base_url_service.dart';
import 'package:bible_game/services/user_service.dart';
import 'package:bible_game/widgets/ads_card.dart';
import 'package:bible_game/widgets/home/user_profile_info.dart';
import 'package:bible_game/widgets/modals/app_update_modal.dart';
import 'package:bible_game/widgets/modals/auth_modal.dart';
import 'package:bible_game/widgets/modals/badge_info.dart';
import 'package:bible_game/widgets/modals/nativity_info.dart';
import 'package:bible_game/widgets/modals/nativity_loader.dart';
import 'package:bible_game/widgets/modals/no_badge_info.dart';
import 'package:bible_game/widgets/modals/pilgrim_progress_welcome_modal.dart';
import 'package:bible_game/widgets/modals/settings_modal.dart';
import 'package:bible_game/widgets/modals/who_is_who_guide.dart';
import 'package:bible_game/widgets/shimmer/ads_shimmer.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:new_version_plus/new_version_plus.dart';
import '../../widgets/games/game_card.dart';
import '../../widgets/home/game_card_info.dart';
import '../../widgets/home/game_score_info.dart';
import '../../widgets/home/sign_in_profile.dart';
import '../../widgets/modals/create_profile_modal.dart';
import '../../widgets/modals/four_scriptures_welcome_modal.dart';
import '../../widgets/modals/welcome_modal.dart';
import '../four_scriptures_one_word/loading_screen.dart';

class TabHomeScreen extends StatefulWidget {
  const TabHomeScreen({Key? key}) : super(key: key);

  @override
  State<TabHomeScreen> createState() => _TabHomeScreenState();
}

class _TabHomeScreenState extends State<TabHomeScreen> {
  GetStorage box = GetStorage();
  final UserController _userController = Get.put(UserController());
  final AuthController _authController = Get.put(AuthController());
  final PilgrimProgressController _pilgrimProgressController =
      Get.put(PilgrimProgressController());

  @override
  void dispose() {
    super.dispose();
  }

  final gameSettings = GetStorage().read('game_settings');

  navigateFourScriptures() {
    var firstTime =
        GetStorage().read('four_scriptures_modal_first_time') ?? true;
    if (_authController.isLoggedIn.isTrue) {
      if (firstTime) {
        Get.dialog(const FourScripturesWelcomeModal());
        GetStorage().write('four_scriptures_modal_first_time', false);
      } else {
        Get.to(() => const FourScriptureLoadingScreen());
      }
    } else {
      Get.dialog(const AuthModal(
          title: 'Your profile',
          text:
              'Sign in to your profile to save \n& continue your game play.'));
    }
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    }
    if (hour < 17) {
      return 'Good Afternoon,';
    }
    return 'Good Evening,';
  }

  initializeWallet() async {
    if (_userController.myUser['isWalletInitialized'] != null) {
      if (!_userController.myUser['isWalletInitialized']) {
        await UserService.initializeWallet();
      }
    }
  }

  checkForUpdateAppVersion() async {
    final newVersion = NewVersionPlus();
    final status = await newVersion.getVersionStatus();
    final localVersion = status?.localVersion;
    final storeVersion = status?.storeVersion;
    final appCanUpdate = status?.canUpdate;
    if (appCanUpdate == true) {
      Get.dialog(const AppUpdateModal(), barrierDismissible: false);
    }
  }

  String getBadgeUrl() {
    var rank = _userController.myUser['rank'];
    if (rank == 'babe') {
      return 'assets/images/badges/babe_badge.png';
    }
    if (rank == 'child') {
      return 'assets/images/badges/child_badge.png';
    }
    if (rank == 'young believer') {
      return 'assets/images/badges/yb_badge.png';
    }
    if (rank == 'charity') {
      return 'assets/images/badges/charity_badge.png';
    }
    if (rank == 'father') {
      return 'assets/images/badges/father_badge.png';
    }
    if (rank == 'elder') {
      return 'assets/images/badges/elder_badge.png';
    }
    return 'assets/images/badges/default_badge.png';
  }

  displayBadgeInfo() {
    var rank = _userController.myUser['rank'];
    _pilgrimProgressController.setPilgrimData();
    switch (rank) {
      case 'babe':
        {
          Get.dialog(
              Obx(
                () => BadgeInfo(
                  modalLayoutUrl: 'assets/images/babe_layout.png',
                  badgeUrl: 'assets/images/badges/babe_badge.png',
                  badgeName: 'BABE BADGE!',
                  badgeNameColor: 0xFF5D42C8,
                  pointsBgColor: 0xFFE2DAFF,
                  badgeTotalPoint: _pilgrimProgressController
                      .totalPointsAvailableInBabe.value,
                  badgePointGained:
                      _pilgrimProgressController.totalPointsGainedInBabe.value,
                  badgeSubText:
                      'Such a good start! Keep playing \nto grow through the ranks. \nChild badge in view!',
                ),
              ),
              transitionCurve: Curves.easeIn,
              transitionDuration: const Duration(milliseconds: 500));

          break;
        }
      case 'child':
        {
          Get.dialog(
              Obx(
                () => BadgeInfo(
                  modalLayoutUrl: 'assets/images/child_layout.png',
                  badgeUrl: 'assets/images/badges/child_badge.png',
                  badgeName: 'CHILD BADGE!',
                  badgeNameColor: 0xFFC75523,
                  pointsBgColor: 0xFFFDE3CA,
                  badgeTotalPoint: _pilgrimProgressController
                      .totalPointsAvailableInChild.value,
                  badgePointGained:
                      _pilgrimProgressController.totalPointsGainedInChild.value,
                  badgeSubText:
                      'Having a child badge means the \nmore you play the closer to \nbecoming a young believer!',
                ),
              ),
              transitionCurve: Curves.easeIn,
              transitionDuration: const Duration(milliseconds: 500));
          break;
        }
      case 'young believer':
        {
          Get.dialog(
              Obx(
                () => BadgeInfo(
                  modalLayoutUrl: 'assets/images/yb_layout.png',
                  badgeUrl: 'assets/images/badges/yb_badge.png',
                  badgeName: 'YOUNG BELIEVER\n BADGE!',
                  badgeNameColor: 0xFF8999A8,
                  pointsBgColor: 0xFF9EB7CD,
                  badgeTotalPoint:
                      _pilgrimProgressController.totalPointsAvailableInYb.value,
                  badgePointGained:
                      _pilgrimProgressController.totalPointsGainedInYb.value,
                  badgeSubText:
                      'The next badge is for Charity! \nDo not relent now, there is \nreward round the corner!',
                ),
              ),
              transitionCurve: Curves.easeIn,
              transitionDuration: const Duration(milliseconds: 500));
          break;
        }
      case 'charity':
        {
          Get.dialog(
              Obx(
                () => BadgeInfo(
                  modalLayoutUrl: 'assets/images/charity_layout.png',
                  badgeUrl: 'assets/images/badges/charity_badge.png',
                  badgeName: 'CHARITY BADGE!',
                  badgeNameColor: 0xFFC88008,
                  pointsBgColor: 0xFFFFF44B,
                  badgeTotalPoint: _pilgrimProgressController
                      .totalPointsAvailableInCharity.value,
                  badgePointGained: _pilgrimProgressController
                      .totalPointsGainedInCharity.value,
                  badgeSubText:
                      'A milestone! Keep playing \nto grow through the ranks. \nFather badge in view!',
                ),
              ),
              transitionCurve: Curves.easeIn,
              transitionDuration: const Duration(milliseconds: 500));
          break;
        }
      case 'father':
        {
          Get.dialog(
              Obx(
                () => BadgeInfo(
                  modalLayoutUrl: 'assets/images/father_layout.png',
                  badgeUrl: 'assets/images/badges/father_badge.png',
                  badgeName: 'FATHER BADGE!',
                  badgeNameColor: 0xFF4174E7,
                  pointsBgColor: 0xFFDFEEFF,
                  badgeTotalPoint: _pilgrimProgressController
                      .totalPointsAvailableInFather.value,
                  badgePointGained: _pilgrimProgressController
                      .totalPointsGainedInFather.value,
                  badgeSubText:
                      'You’ve come a long way to \nget here, play more games \nto become an Elder!',
                ),
              ),
              transitionCurve: Curves.easeIn,
              transitionDuration: const Duration(milliseconds: 500));
          break;
        }
      case 'elder':
        {
          Get.dialog(
              Obx(
                () => BadgeInfo(
                  modalLayoutUrl: 'assets/images/elder_layout.png',
                  badgeUrl: 'assets/images/badges/elder_badge.png',
                  badgeName: 'ELDER BADGE!',
                  badgeNameColor: 0xFF3F4060,
                  pointsBgColor: 0xFFFED806,
                  badgeTotalPoint: _pilgrimProgressController
                      .totalPointsAvailableInElder.value,
                  badgePointGained:
                      _pilgrimProgressController.totalPointsGainedInElder.value,
                  badgeSubText:
                      'You have gotten to the height!\n Keep playing to unlock new \ntests!',
                ),
              ),
              transitionCurve: Curves.easeIn,
              transitionDuration: const Duration(milliseconds: 500));
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFF548CD7),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/aesthetics/home_bgg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 80.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF366ABC),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.r),
                    bottomRight: Radius.circular(8.r),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFF3DB3E),
                      offset: Offset(0, 8),
                      blurRadius: 0,
                      spreadRadius: -2,
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                // height: Get.height - 200.h,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      height: Get.height - (200.h + 10.h),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            SizedBox(
                              child: Row(
                                children: [
                                  Obx(
                                        () => _authController.isLoggedIn.isTrue
                                        ? UserProfileInfo(
                                      avatarUrl:
                                      '${BaseUrlService.avatarBaseUrl}/${_userController.myUser['id']}.png?apikey=${BaseUrlService.avatarApiKey}',
                                      username: _userController.myUser['name'] ??
                                          'Beloved',
                                      gameLevel: _userController.myUser['rank'],
                                      badgeSrc: getBadgeUrl(),
                                      displayBadgeInfo: displayBadgeInfo,
                                    )
                                        : const SignInProfile(),
                                  ),
                                  const Spacer(),
                                  Obx(
                                        () => GameScoreInfo(
                                      noOfCoins: _authController.isLoggedIn.isTrue
                                          ? _userController.myUser['coinWalletBalance']
                                          : 0,
                                      noOfGems: 0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            GameCardInfo(
                              gameTitle: 'Quick Game',
                              gameText:
                                  'Test your bible knowledge \nthrough short quizzes',
                              gameImageUrl: 'assets/images/aesthetics/bible.gif',
                              gameImageWidth: 150.w,
                              cardColor: 0xFF1A3B77,
                              onTap: () => {
                                _userController.soundIsOff.isFalse
                                    ? _userController.playGameSound()
                                    : null,
                                Get.to(() => const QuickGameStepOneScreen())
                              },
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            GameCardInfo(
                              gameTitle: 'Who is who?',
                              gameText:
                                  'Know bible names and stories? \nPlay this easy game to learn \nmore!',
                              gameImageUrl:
                                  'assets/images/aesthetics/whoiswho.gif',
                              gameImageWidth: 150.w,
                              cardColor: 0xFFDE2D42,
                              onTap: () {
                                var firstTime =
                                    GetStorage().read('wiw_info_first_time') ??
                                        true;
                                _userController.soundIsOff.isFalse
                                    ? _userController.playGameSound()
                                    : null;
                                if (_authController.isLoggedIn.isTrue) {
                                  if (firstTime) {
                                    Get.bottomSheet(const WhoIsWhoGuide(),
                                        isScrollControlled: true,
                                        isDismissible: false);
                                  } else {
                                    Get.to(() => const WhoIsWhoHomeScreen());
                                  }
                                } else {
                                  Get.dialog(
                                    const AuthModal(
                                        title: 'Your profile',
                                        text:
                                            'Sign in to your profile to save \n& continue your game play.'),
                                  );
                                }
                              },
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            GameCardInfo(
                              gameTitle: 'Pilgrim Progress',
                              gameText:
                                  'Journey through the bible, \nGrow as you progress ',
                              gameImageUrl:
                                  'assets/images/aesthetics/pilgrim_hill.gif',
                              gameImageWidth: 150.w,
                              cardColor: 0xFF97D3FF,
                              onTap: () => {
                                _userController.soundIsOff.isFalse
                                    ? _userController.playGameSound()
                                    : null,
                                Get.to(const PilgrimProgressHomeScreen())
                              },
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            GameCardInfo(
                              gameTitle: '4 scriptures, \n1 word!',
                              gameText:
                                  'Put together this puzzle, \nshow thyself approved ',
                              gameImageUrl: 'assets/images/aesthetics/scroll.gif',
                              gameImageWidth: 150.w,
                              cardColor: 0xFFFFC973,
                              onTap: () => {
                                _userController.soundIsOff.isFalse
                                    ? _userController.playGameSound()
                                    : null,
                                navigateFourScriptures()
                              },
                            ),
                            SizedBox(
                              height: 38.h,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'BG Billboard',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1,
                                    fontFamily: 'Mikado',
                                    fontSize: 22.sp,
                                    color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Obx(
                              () => SizedBox(
                                child: _userController.isLoaded.isFalse
                                    ? CarouselSlider.builder(
                                        itemCount: _userController.adsData.length,
                                        itemBuilder: (BuildContext context,
                                                int itemIndex,
                                                int pageViewIndex) =>
                                            AdsCard(
                                          imageUrl: _userController
                                              .adsData[itemIndex].imageUrl,
                                          title: _userController
                                              .adsData[itemIndex].title,
                                        ),
                                        options: CarouselOptions(
                                          aspectRatio:
                                              Get.width > 900 ? 15 / 10 : 9 / 10,
                                          viewportFraction: 1,
                                          autoPlay: true,
                                          autoPlayInterval:
                                              const Duration(milliseconds: 2500),
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          enlargeCenterPage: true,
                                        ),
                                      )
                                    : const AdsCardShimmer(),
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    initializeWallet();
    checkForUpdateAppVersion();
  }
}
