import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/auth_controller.dart';
import 'package:bible_game/controllers/pilgrim_progress_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/screens/pilgrim_progress/home.dart';
import 'package:bible_game/screens/pilgrim_progress/new_level.dart';
import 'package:bible_game/screens/pilgrim_progress/retry_level.dart';
import 'package:bible_game/screens/quick_game/step_one.dart';
import 'package:bible_game/services/base_url_service.dart';
import 'package:bible_game/widgets/ads_card.dart';
import 'package:bible_game/widgets/modals/app_update_modal.dart';
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
import '../../widgets/games/game_card.dart';
import '../../widgets/home/game_card_info.dart';
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
          title: 'your profile',
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
                badgeTotalPoint:
                    _pilgrimProgressController.totalPointsAvailableInBabe.value,
                badgePointGained:
                    _pilgrimProgressController.totalPointsGainedInBabe.value,
                badgeSubText:
                    'Such a good start! Keep playing \nto grow through the ranks. \nChild badge in view!',
              ),
            ),
          );

          break;
        }
      case 'child':
        {
          Get.dialog(Obx(
            () => BadgeInfo(
              modalLayoutUrl: 'assets/images/child_layout.png',
              badgeUrl: 'assets/images/badges/child_badge.png',
              badgeName: 'CHILD BADGE!',
              badgeNameColor: 0xFFC75523,
              pointsBgColor: 0xFFFDE3CA,
              badgeTotalPoint:
                  _pilgrimProgressController.totalPointsAvailableInChild.value,
              badgePointGained:
                  _pilgrimProgressController.totalPointsGainedInChild.value,
              badgeSubText:
                  'Having a child badge means the \nmore you play the closer to \nbecoming a young believer!',
            ),
          ));
          break;
        }
      case 'young believer':
        {
          Get.dialog(Obx(
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
          ));
          break;
        }
      case 'charity':
        {
          Get.dialog(Obx(
            () => BadgeInfo(
              modalLayoutUrl: 'assets/images/charity_layout.png',
              badgeUrl: 'assets/images/badges/charity_badge.png',
              badgeName: 'CHARITY BADGE!',
              badgeNameColor: 0xFFC88008,
              pointsBgColor: 0xFFFFF44B,
              badgeTotalPoint: _pilgrimProgressController
                  .totalPointsAvailableInCharity.value,
              badgePointGained:
                  _pilgrimProgressController.totalPointsGainedInCharity.value,
              badgeSubText:
                  'A milestone! Keep playing \nto grow through the ranks. \nFather badge in view!',
            ),
          ));
          break;
        }
      case 'father':
        {
          Get.dialog(Obx(
            () => BadgeInfo(
              modalLayoutUrl: 'assets/images/father_layout.png',
              badgeUrl: 'assets/images/badges/father_badge.png',
              badgeName: 'FATHER BADGE!',
              badgeNameColor: 0xFF4174E7,
              pointsBgColor: 0xFFDFEEFF,
              badgeTotalPoint:
                  _pilgrimProgressController.totalPointsAvailableInFather.value,
              badgePointGained:
                  _pilgrimProgressController.totalPointsGainedInFather.value,
              badgeSubText:
                  'You’ve come a long way to \nget here, play more games \nto become an Elder!',
            ),
          ));
          break;
        }
      case 'elder':
        {
          Get.dialog(Obx(
            () => BadgeInfo(
              modalLayoutUrl: 'assets/images/elder_layout.png',
              badgeUrl: 'assets/images/badges/elder_badge.png',
              badgeName: 'ELDER BADGE!',
              badgeNameColor: 0xFF3F4060,
              pointsBgColor: 0xFFFED806,
              badgeTotalPoint:
                  _pilgrimProgressController.totalPointsAvailableInElder.value,
              badgePointGained:
                  _pilgrimProgressController.totalPointsGainedInElder.value,
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
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/aesthetics/home_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: Get.height < 680
                      ? 130
                      : (Get.height > 680 && Get.height < 800)
                          ? 150
                          : 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF366ABC),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.r),
                      bottomRight: Radius.circular(15.r),
                    ),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0xFFF3DB3E),
                          offset: Offset(0, 8),
                          blurRadius: 0,
                          spreadRadius: -2)
                    ],
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
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 22.w, right: 22.w),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100.h,
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF3c2b4b),
                                ),
                              padding: EdgeInsets.all(10.w),
                                child: Image.network('https://api.multiavatar.com/Binx Bond.png', width: 40.w,)),
                            padding: EdgeInsets.all(8.w),
                          )
                        ],
                      ),
                      // Container(
                      //   padding: EdgeInsets.only(top: 15.w, bottom: 15.w),
                      //   alignment: Alignment.center,
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(15.r),
                      //     boxShadow: const [
                      //       BoxShadow(
                      //           color: Color.fromRGBO(118, 99, 229, 1),
                      //           offset: Offset(0, 15),
                      //           blurRadius: 0,
                      //           spreadRadius: -10)
                      //     ],
                      //   ),
                      //   child: Column(
                      //     children: [
                      //       Text(
                      //         'Your Quick Game High Score',
                      //         style: TextStyle(
                      //           fontSize: 12.sp,
                      //           fontWeight: FontWeight.w700,
                      //           color: Colors.black,
                      //         ),
                      //       ),
                      //       Obx(
                      //         () => SizedBox(
                      //           child: _authController.isLoggedIn.isTrue
                      //               ? Obx(
                      //                   () => AutoSizeText(
                      //                     _userController.myUser['highScore']
                      //                         .toString(),
                      //                     style: TextStyle(
                      //                         fontSize: 60.sp,
                      //                         fontFamily: 'Neuland',
                      //                         color: const Color(0xFF7563DF),
                      //                         fontWeight: FontWeight.w400),
                      //                   ),
                      //                 )
                      //               : Obx(
                      //                   () => AutoSizeText(
                      //                     _userController.tempPlayerPoint.value
                      //                         .toString(),
                      //                     style: TextStyle(
                      //                         fontSize: 60.sp,
                      //                         fontFamily: 'Neuland',
                      //                         color: const Color(0xFF7563DF),
                      //                         fontWeight: FontWeight.w400),
                      //                   ),
                      //                 ),
                      //         ),
                      //       ),
                      //       Text(
                      //         'Play more games, earn more points',
                      //         style: TextStyle(
                      //           fontSize: 12.sp,
                      //           fontWeight: FontWeight.w500,
                      //           color: Colors.black,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 25.h,
                      // ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Padding(
                      //       padding: EdgeInsets.only(left: 25.0.w),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Text(
                      //             greeting(),
                      //             style: TextStyle(
                      //                 fontSize: 15.sp,
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.w600),
                      //           ),
                      //           SizedBox(
                      //             height: 5.h,
                      //           ),
                      //           Obx(
                      //                 () => SizedBox(
                      //               child: _authController.isLoggedIn.isTrue
                      //                   ? Obx(
                      //                     () => Text(
                      //                   (_userController.myUser['name'] ??
                      //                       'Beloved'),
                      //                   style: TextStyle(
                      //                       fontSize: 20.sp,
                      //                       color: Colors.white,
                      //                       fontFamily: 'Neuland',
                      //                       fontWeight: FontWeight.w400),
                      //                 ),
                      //               )
                      //                   : Text(
                      //                 'Beloved',
                      //                 style: TextStyle(
                      //                     fontSize: 20.sp,
                      //                     color: Colors.white,
                      //                     fontFamily: 'Neuland',
                      //                     fontWeight: FontWeight.w400),
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //
                      //     Padding(
                      //       padding: EdgeInsets.only(right: 8.0.w),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: [
                      //           Obx(
                      //                 () => IconButton(
                      //               iconSize: 36.w,
                      //               onPressed: () {
                      //                 _userController.soundIsOff.isFalse
                      //                     ? _userController.playGameSound()
                      //                     : null;
                      //                 _authController.isLoggedIn.isTrue
                      //                     ? displayBadgeInfo()
                      //                     :  Get.dialog(const CreateProfileModal(),
                      //                     barrierDismissible: false);
                      //                 // Get.dialog(const NoBadgeInfo(),
                      //                 //         barrierDismissible: false);
                      //               },
                      //               icon: SizedBox(
                      //                 child: _authController.isLoggedIn.isTrue
                      //                     ? Image.asset(getBadgeUrl())
                      //                     : Image.asset(
                      //                   'assets/images/badges/default_badge.png',
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             width: 10.w,
                      //           ),
                      //           Obx(
                      //                 () => IconButton(
                      //               iconSize: 36.w,
                      //               onPressed: () => {
                      //                 _userController.soundIsOff.isFalse
                      //                     ? _userController.playGameSound()
                      //                     : null,
                      //                 _authController.isLoggedIn.isTrue
                      //                     ? Get.dialog(const SettingsModal(),
                      //                     barrierDismissible: false)
                      //                     : Get.dialog(
                      //                     const AuthModal(
                      //                       title: 'your profile',
                      //                       text:
                      //                       'Sign in to your profile to save \n& continue your game play.',
                      //                     ),
                      //                     barrierDismissible: false)
                      //               },
                      //               icon: _authController.isLoggedIn.isTrue
                      //                   ? Obx(
                      //                     () => Image.network(
                      //                   '${BaseUrlService.avatarBaseUrl}/${_userController.myUser['id']}.png?apikey=${BaseUrlService.avatarApiKey}',
                      //                 ),
                      //               )
                      //                   : Image.asset(
                      //                 'assets/images/icons/user_profile.png',
                      //               ),
                      //             ),
                      //           )
                      //         ],
                      //       ),
                      //     ), // const Spacer(),
                      //   ],
                      // ),
                      GameCardInfo(
                        gameTitle: 'Who is who?',
                        gameText:
                            'Know bible names and stories? \nPlay this easy game to learn \nmore!',
                        gameImageUrl: 'assets/images/who.png',
                        gameImageWidth: 200.w,
                        cardColor: 0xFFDE2D42,
                        onTap: () => {
                          // userController.soundIsOff.isFalse ? userController.playGameSound() : null,
                            Get.to(const PilgrimProgressHomeScreen())
                        },
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      GameCardInfo(
                        gameTitle: 'Quick Game',
                        gameText:
                            'Test your bible knowledge \nthrough short quizzes',
                        gameImageUrl: 'assets/images/bible_image.svg',
                        gameImageWidth: 256.w,
                        cardColor: 0xFF80B708,
                        onTap: () => {
                          _userController.soundIsOff.isFalse ? _userController.playGameSound() : null,
                        Get.to(() => const QuickGameStepOneScreen())
                        },
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      GameCardInfo(
                        gameTitle: 'Pilgrim Progress',
                        gameText:
                            'Journey through the bible, \nGrow as you progress ',
                        gameImageUrl: 'assets/images/pilgrim_progress.svg',
                        gameImageWidth: 179.w,
                        cardColor: 0xFF97D3FF,
                        onTap: () => {
                          _userController.soundIsOff.isFalse ? _userController.playGameSound() : null,
                          Get.to(const PilgrimProgressHomeScreen())
                        },
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      GameCardInfo(
                        gameTitle: '4 scriptures \n1 word!',
                        gameText:
                            'Put together this puzzle, \nshow thyself approved ',
                        gameImageUrl: 'assets/images/blue_bible.png',
                        gameImageWidth: 179.w,
                        cardColor: 0xFFFFC973,
                        onTap: () => {
                          _userController.soundIsOff.isFalse ? _userController.playGameSound() : null,
                          navigateFourScriptures()
                        },
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
                          child: _userController.isLoaded.isFalse
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
                                    aspectRatio:
                                        Get.width > 900 ? 15 / 10 : 9 / 10,
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
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
  }
}
