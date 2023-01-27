import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/auth_controller.dart';
import 'package:bible_game/controllers/pilgrim_progress_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/screens/pilgrim_progress/home.dart';
import 'package:bible_game/screens/pilgrim_progress/new_level.dart';
import 'package:bible_game/screens/pilgrim_progress/retry_level.dart';
import 'package:bible_game/screens/quick_game/step_one.dart';
import 'package:bible_game/widgets/ads_card.dart';
import 'package:bible_game/widgets/modals/auth_modal.dart';
import 'package:bible_game/widgets/modals/badge_info.dart';
import 'package:bible_game/widgets/modals/nativity_info.dart';
import 'package:bible_game/widgets/modals/nativity_loader.dart';
import 'package:bible_game/widgets/modals/no_badge_info.dart';
import 'package:bible_game/widgets/modals/pilgrim_progress_welcome_modal.dart';
import 'package:bible_game/widgets/modals/settings_modal.dart';
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

import '../../widgets/modals/welcome_modal.dart';

class TabHomeScreen extends StatefulWidget {
  const TabHomeScreen({Key? key}) : super(key: key);

  @override
  State<TabHomeScreen> createState() => _TabHomeScreenState();
}

class _TabHomeScreenState extends State<TabHomeScreen> {
  GetStorage box = GetStorage();
  final UserController _userController = Get.put(UserController());
  final AuthController _authController = Get.put(AuthController());
  PilgrimProgressController pilgrimProgressController = Get.put(PilgrimProgressController());
  final assetsAudioPlayer = AssetsAudioPlayer();
  final player = AudioPlayer();

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  final gameSettings = GetStorage().read('game_settings');

  void goToQuickGameScreen(BuildContext context) {
    Get.to(() => const QuickGameStepOneScreen(),
        transition: Transition.downToUp);
    // Get.to(const RetryLevelScreen());

  }

  void goToPilgrimProgressHomeScreen(BuildContext context) {
    Navigator.of(context).pushNamed(PilgrimProgressHomeScreen.routeName);
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
    switch (rank) {
      case 'babe':
        {
          Get.dialog(
              Obx(
                  ()=> BadgeInfo(
            modalLayoutUrl: 'assets/images/babe_layout.png',
            badgeUrl: 'assets/images/badges/babe_badge.png',
            badgeName: 'BABE BADGE!',
            badgeNameColor: 0xFF5D42C8,
            pointsBgColor: 0xFFE2DAFF,
            badgeTotalPoint:pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value,
            badgePointGained: pilgrimProgressController.totalPointsGainedInBabe.value,
            badgeSubText:
                  'Such a good start! Keep playing \nto grow through the ranks. \nChild badge in view!',
          ),
              ));
          break;
        }
      case 'child': {
        Get.dialog(
            Obx(
                ()=> BadgeInfo(
          modalLayoutUrl: 'assets/images/child_layout.png',
          badgeUrl: 'assets/images/badges/child_badge.png',
          badgeName: 'CHILD BADGE!',
          badgeNameColor: 0xFFC75523,
          pointsBgColor: 0xFFFDE3CA,
          badgeTotalPoint:pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value,
          badgePointGained: pilgrimProgressController.totalPointsGainedInChild.value,
          badgeSubText:
          'Having a child badge means the \nmore you play the closer to \nbecoming a young believer!',
        ),
            ));
        break;
      }
      case 'young believer': {
        Get.dialog(
            Obx(
                () => BadgeInfo(
          modalLayoutUrl: 'assets/images/yb_layout.png',
          badgeUrl: 'assets/images/badges/yb_badge.png',
          badgeName: 'YOUNG BELIEVER\n BADGE!',
          badgeNameColor: 0xFF8999A8,
          pointsBgColor: 0xFF9EB7CD,
          badgeTotalPoint: pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value,
          badgePointGained: pilgrimProgressController.totalPointsGainedInYb.value,
          badgeSubText:
          'The next badge is for Charity! \nDo not relent now, there is \nreward round the corner!',
        ),
            ));
        break;
      }
      case 'charity': {
        Get.dialog(
            Obx(
                () => BadgeInfo(
          modalLayoutUrl: 'assets/images/charity_layout.png',
          badgeUrl: 'assets/images/badges/charity_badge.png',
          badgeName: 'CHARITY BADGE!',
          badgeNameColor: 0xFFC88008,
          pointsBgColor: 0xFFFFF44B,
          badgeTotalPoint: pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value,
          badgePointGained: pilgrimProgressController.totalPointsGainedInCharity.value,
          badgeSubText:
          'A milestone! Keep playing \nto grow through the ranks. \nFather badge in view!',
        ),
            ));
        break;
      }
      case 'father': {
        Get.dialog(
            Obx(
                ()=> BadgeInfo(
          modalLayoutUrl: 'assets/images/father_layout.png',
          badgeUrl: 'assets/images/badges/father_badge.png',
          badgeName: 'FATHER BADGE!',
          badgeNameColor: 0xFF4174E7,
          pointsBgColor: 0xFFDFEEFF,
          badgeTotalPoint:pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value,
          badgePointGained: pilgrimProgressController.totalPointsGainedInFather.value,
          badgeSubText:
          'You’ve come a long way to \nget here, play more games \nto become an Elder!',
        ),
            ));
        break;
      }
      case 'elder': {
        Get.dialog(
            Obx(
                () => BadgeInfo(
          modalLayoutUrl: 'assets/images/elder_layout.png',
          badgeUrl: 'assets/images/badges/elder_badge.png',
          badgeName: 'ELDER BADGE!',
          badgeNameColor: 0xFF3F4060,
          pointsBgColor: 0xFFFED806,
          badgeTotalPoint:pilgrimProgressController.totalPointsAvailableInPilgrimProgress.value,
          badgePointGained: pilgrimProgressController.totalPointsGainedInElder.value,
          badgeSubText:
          'You have gotten to the height!\n Keep playing to unlock new \ntests!',
        ),
            ));
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFF548CD7),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: Get.height < 680
                    ? 180
                    : (Get.height > 680 && Get.height < 800)
                        ? 200
                        : 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF32B1F2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.r),
                    bottomRight: Radius.circular(30.r),
                  ),
                ),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/images/cloud.png',
                          scale: 1.5,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 25.0.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                greeting(),
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.white,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Obx(
                                () => SizedBox(
                                  child: _authController.isLoggedIn.isTrue
                                      ? Obx(
                                          () => AutoSizeText(
                                            (_userController.myUser['name'] ??
                                                'Beloved'),
                                            style: TextStyle(
                                                fontSize: 24.sp,
                                                color: Colors.white,
                                                fontFamily: 'Neuland',
                                                fontWeight: FontWeight.w400),
                                          ),
                                        )
                                      : AutoSizeText(
                                          'Beloved',
                                          style: TextStyle(
                                              fontSize: 24.sp,
                                              color: Colors.white,
                                              fontFamily: 'Neuland',
                                              fontWeight: FontWeight.w400),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(right: 8.0.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Obx(
                                () => IconButton(
                                  iconSize: 45.w,
                                  onPressed: () {
                                    player.setAsset('assets/audios/click.mp3');
                                    player.play();
                                    _authController.isLoggedIn.isTrue
                                        ? displayBadgeInfo()
                                        : Get.dialog(const NoBadgeInfo(),
                                            barrierDismissible: false);
                                  },
                                  icon: SizedBox(
                                    child: _authController.isLoggedIn.isTrue
                                        ? Image.asset(getBadgeUrl())
                                        : Image.asset(
                                            'assets/images/badges/default_badge.png',
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Obx(
                                () => IconButton(
                                  iconSize: 45.w,
                                  onPressed: () => {
                                    player.setAsset('assets/audios/click.mp3'),
                                    player.play(),
                                    _authController.isLoggedIn.isTrue
                                        ? Get.dialog(const SettingsModal(),
                                            barrierDismissible: false)
                                        : Get.dialog(const AuthModal(),
                                            barrierDismissible: false)
                                  },
                                  icon: _authController.isLoggedIn.isTrue
                                      ? Obx(
                                          () => SvgPicture.network(
                                            'https://api.multiavatar.com/${_userController.myUser['id']}.svg',
                                          ),
                                        )
                                      : Image.asset(
                                          'assets/images/icons/user_profile.png',
                                        ),
                                ),
                              )
                            ],
                          ),
                        ), // const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.only(left: 22.w, right: 22.w),
                child: Column(
                  children: [
                    SizedBox(
                      height: 160.h,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15.w, bottom: 15.w),
                      alignment: Alignment.center,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromRGBO(118, 99, 229, 1),
                              offset: Offset(0, 15),
                              blurRadius: 0,
                              spreadRadius: -10)
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Your High Score',
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color.fromRGBO(52, 42, 122, 1)),
                          ),
                          Obx(
                            () => SizedBox(
                              child: _authController.isLoggedIn.isTrue
                                  ? Obx(
                                      () => AutoSizeText(
                                        _userController.myUser['highScore'].toString(),
                                        style: TextStyle(
                                            fontSize: 60.sp,
                                            fontFamily: 'Neuland',
                                            color: const Color(0xFF7563DF),
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  : Obx(
                                      () => AutoSizeText(
                                        _userController.tempPlayerPoint.value
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 60.sp,
                                            fontFamily: 'Neuland',
                                            color: const Color(0xFF7563DF),
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                            ),
                          ),
                          Text(
                            'Play more games, earn more points',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0xFF80B708),
                              offset: Offset(0, 15),
                              blurRadius: 0,
                              spreadRadius: -10
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 23.0.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 21.h,
                                ),
                                AutoSizeText(
                                  'Quick Game',
                                  style: TextStyle(
                                    letterSpacing: 0.5,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Neuland',
                                    color: const Color.fromRGBO(124, 110, 203, 1),
                                  ),
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Text(
                                  'Test your bible knowledge',
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  'through short quizzes',
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 14.h,
                                ),
                                GestureDetector(
                                  onTap: () => {
                                    player.setAsset('assets/audios/click.mp3'),
                                    player.play(),
                                    goToQuickGameScreen(context)
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: 21.w,
                                      right: 21.w,
                                      top: 10.h,
                                      bottom: 10.h,
                                    ),
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage('assets/images/home_button_bg.png'),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Text(
                                      'PLAY',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.sp,
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15.r),
                                  bottom: Radius.circular(15.r)),
                              child: SvgPicture.asset(
                                'assets/images/bible_image.svg',
                                width: 256.w,
                                fit: BoxFit. cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0xFF97D3FF),
                              offset: Offset(0, 15),
                              blurRadius: 0,
                              spreadRadius: -10
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 23.0.w,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 21.h,
                                ),
                                AutoSizeText(
                                  'Pilgrim Progress',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    letterSpacing: 1,
                                    fontFamily: 'Neuland',
                                    fontWeight: FontWeight.w400,
                                    color: const Color.fromRGBO(124, 110, 203, 1),
                                  ),
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Text(
                                  'Journey through the bible',
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  'Grow as you progress',
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 14.h,
                                ),
                                GestureDetector(
                                  onTap: () => {
                                    player.setAsset('assets/audios/click.mp3'),
                                    player.play(),
                                    goToPilgrimProgressHomeScreen(context),
                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(
                                        left: 21.w,
                                        right: 21.w,
                                        top: 10.h,
                                        bottom: 10.h,
                                      ),
                                      decoration: BoxDecoration(
                                        image: const DecorationImage(
                                          image: AssetImage('assets/images/home_button_bg.png'),
                                          fit: BoxFit.fill,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Text(
                                        'PLAY',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.sp,
                                          color: const Color(0xFFFFFFFF),
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15.r),
                                  bottom: Radius.circular(15.r)),
                              child: SvgPicture.asset(
                                'assets/images/pilgrim_progress.svg',
                                width: 179.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 38.h,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Updates for you',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1,
                            fontFamily: 'Neuland',
                            fontSize: 16.sp,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Obx(
                      () => SizedBox(
                        child: _userController.isLoaded.isTrue
                            ? CarouselSlider.builder(
                                itemCount: _userController.adsData.length,
                                itemBuilder: (BuildContext context,
                                        int itemIndex, int pageViewIndex) =>
                                    AdsCard(
                                  imageUrl: _userController
                                      .adsData[itemIndex].imageUrl,
                                  title:
                                      _userController.adsData[itemIndex].title,
                                ),
                                options: CarouselOptions(
                                  aspectRatio: 10 / 10,
                                  viewportFraction: 1,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 5),
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
              )
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
  }
}
