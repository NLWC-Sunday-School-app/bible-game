import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/auth_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/screens/pilgrim_progress/home.dart';
import 'package:bible_game/screens/quick_game/step_one.dart';
import 'package:bible_game/widgets/ads_card.dart';
import 'package:bible_game/widgets/modals/auth_modal.dart';
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

class TabHomeScreen extends StatefulWidget {
  const TabHomeScreen({Key? key}) : super(key: key);

  @override
  State<TabHomeScreen> createState() => _TabHomeScreenState();
}

class _TabHomeScreenState extends State<TabHomeScreen> {
  GetStorage box = GetStorage();
  final UserController _userController = Get.put(UserController());
  final AuthController _authController = Get.put(AuthController());
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                greeting(),
                                style:TextStyle(
                                    fontSize: Get.width >= 600 ? 18 : 15,
                                    color: Colors.white),
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
                                            style: const TextStyle(
                                                fontSize: 24,
                                                color: Colors.white,
                                                fontFamily: 'Neuland',
                                                fontWeight: FontWeight.w400),
                                          ),
                                        )
                                      : const AutoSizeText(
                                          'BELOVED',
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.white,
                                              fontFamily: 'Neuland',
                                              fontWeight: FontWeight.w400),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Image.asset(
                          'assets/images/badges/default_badge.png',
                          width: 45,
                        ),
                        Obx(
                          () => IconButton(
                            iconSize: 50,
                            onPressed: () => {
                             player.setAsset('assets/audios/click.mp3'),
                             player.play(),
                              _authController.isLoggedIn.isTrue
                                  ? Get.dialog(
                                  const SettingsModal(),
                              )
                                  : Get.dialog(const AuthModal(),
                              )
                            },
                            icon: _authController.isLoggedIn.isTrue
                                ? Obx(() => SvgPicture.network(
                                      'https://api.multiavatar.com/${_userController.myUser['id']}.svg ',
                                    ),
                                  ) : Image.asset('assets/images/icons/user_profile.png',),
                          ),
                        )
                        // const Spacer(),
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
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color.fromRGBO(52, 42, 122, 1)),
                          ),
                        Obx(
                            ()=> SizedBox(
                                child: _authController.isLoggedIn.isTrue
                                    ? Obx(
                                        () => AutoSizeText(
                                          _userController.myUser['highScore'] != null
                                              ? _userController.myUser['highScore']
                                                  .toString()
                                              : '0',
                                          style: TextStyle(
                                              fontSize: 65.sp,
                                              fontFamily: 'Neuland',
                                              color: const Color(0xFF7563DF),
                                              fontWeight: FontWeight.w800),
                                        ),
                                      )
                                    : Obx(
                                       () => AutoSizeText(
                                          _userController.tempPlayerPoint.value.toString(),
                                          style: TextStyle(
                                              fontSize: 65.sp,
                                              fontFamily: 'Neuland',
                                              color: const Color(0xFF7563DF),
                                              fontWeight: FontWeight.w800),
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
                    gameSettings['is_campaign_active'] == 'true'
                        ? SizedBox(
                            height: 25.h,
                          )
                        : const SizedBox(),
                    gameSettings['is_campaign_active'] == 'true'
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0xFFFEC14B),
                                    offset: Offset(0, 15),
                                    blurRadius: 0,
                                    spreadRadius: -10)
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 23.0.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Image.asset(
                                        'assets/images/global.png',
                                        height: 25,
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      const AutoSizeText(
                                        'NATIVITY STORY',
                                        style: TextStyle(
                                          letterSpacing: 0.5,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Neuland',
                                          color:
                                              Color.fromRGBO(124, 110, 203, 1),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Text(
                                        'How well do you know the',
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        'Nativity story? Test yourself.',
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
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            left: 21.w,
                                            right: 21.w,
                                            top: 10.h,
                                            bottom: 10.h,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color.fromRGBO(110, 91, 220, 1),
                                                Color.fromRGBO(60, 46, 144, 1),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                          ),
                                          child: const Text(
                                            'NOT LIVE',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFFFFFFFF),
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
                                    child: Image.asset(
                                      'assets/images/baby_jesus.png',
                                      width: Get.width >= 600 ? 120.w : 226.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: 25.h,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0xFFFEC14B),
                              offset: Offset(0, 15),
                              blurRadius: 0,
                              spreadRadius: -10)
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
                                const AutoSizeText(
                                  'Quick Game',
                                  style: TextStyle(
                                    letterSpacing: 0.5,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Neuland',
                                    color: Color.fromRGBO(124, 110, 203, 1),
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
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color.fromRGBO(110, 91, 220, 1),
                                          Color.fromRGBO(60, 46, 144, 1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: const Text(
                                      'PLAY NOW',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFFFFFFF),
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
                                fit: BoxFit.cover,
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
                              color: Color(0xFFFEC14B),
                              offset: Offset(0, 15),
                              blurRadius: 0,
                              spreadRadius: -10)
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
                                const AutoSizeText(
                                  'Pilgrim Progress',
                                  style: TextStyle(
                                    fontSize: 20,
                                    letterSpacing: 1,
                                    fontFamily: 'Neuland',
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(124, 110, 203, 1),
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
                                    goToPilgrimProgressHomeScreen(context)
                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(
                                        left: 21.w,
                                        right: 21.w,
                                        top: 10.h,
                                        bottom: 10.h,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color.fromRGBO(110, 91, 220, 1),
                                            Color.fromRGBO(60, 46, 144, 1),
                                          ],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: const Text(
                                        'PLAY NOW',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFFFFFFFF),
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
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Updates for you',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1,
                            fontFamily: 'Neuland',
                            fontSize: 16,
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
}
