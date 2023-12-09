import 'dart:async';

import 'package:animated_svg/animated_svg.dart';
import 'package:animated_svg/animated_svg_controller.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bible_game/controllers/global_games_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/screens/tabs/account.dart';
import 'package:bible_game/screens/tabs/games.dart';
import 'package:bible_game/screens/tabs/home.dart';
import 'package:bible_game/screens/tabs/leaderboard_menu.dart';
import 'package:bible_game/screens/tabs/store.dart';
import 'package:bible_game/screens/tabs/team.dart';
import 'package:bible_game/services/game_service.dart';
import 'package:bible_game/services/user_service.dart';
import 'package:bible_game/widgets/bottomTab/bottom_tab_item.dart';
import 'package:bible_game/widgets/custom_icons/my_flutter_app_icons.dart';
import 'package:bible_game/widgets/modals/country_update_modal.dart';
import 'package:bible_game/widgets/modals/pilgrim_progress_welcome_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';

import '../../controllers/tabs_controller.dart';
import '../../widgets/modals/welcome_modal.dart';

class TabMainScreen extends StatefulWidget {
  static const routeName = '/bottomTab-main-screen';

  const TabMainScreen({Key? key}) : super(key: key);

  @override
  _TabMainScreenState createState() => _TabMainScreenState();
}

class _TabMainScreenState extends State<TabMainScreen> {
  final TabsController _tabsController = Get.put(TabsController());
  final GlobalGamesController _globalGamesController =
      Get.put(GlobalGamesController());
  var selectedTabIndex = GetStorage().read('tabIndex') ?? 0;
  UserController userController = Get.put(UserController());
  final player = AudioPlayer();
  late final SvgController controller;

  final List<Map<String, dynamic>> _pages = [
    {
      'page': const TabHomeScreen(),
      'title': 'Home',
    },
    {
      'page': const TabStoreScreen(),
      'title': 'store',
    },
    {
      'page': const TabLeaderBoardMenuScreen(),
      'title': 'Leaderboard',
    },
    {
      'page': const TabGamesScreen(),
      'title': 'Games',
    },
    {
      'page': const TabTeamScreen(),
      'title': 'Team',
    },

  ];

  Future<void> selectPage(int index) async {
    if (userController.soundIsOff.isFalse) {
      await player.setAsset('assets/audios/select_tab.mp3');
      await player.setVolume(0.5);
      await player.play();
    }
    setState(() {
      selectedTabIndex = index;
    });
    GetStorage().write('tabIndex', index);
    if (index == 1) {
      _globalGamesController.getGlobalGames();
    }
  }

  displayCountryUpdateModal() async{
    var hasSetCountry = await UserService.getUserCountryStatus();
    if(!hasSetCountry){
      Get.dialog(const CountryUpdateModal());
    }
    print('country $hasSetCountry');
  }

  @override
  void initState() {
    super.initState();
    displayWelcomeModal();
    displayCountryUpdateModal();
    controller = AnimatedSvgController();
    //_setBottomTabPage();
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  displayWelcomeModal() {
    var firstTime = GetStorage().read('first_time') ?? true;
    if (firstTime) {
      Timer(const Duration(seconds: 3), () {
        Get.dialog(const WelcomeModal());
      });
      GetStorage().write('first_time', false);
    }
  }


  Widget get _bottomNavigationBar {
    return SizedBox(
      height: 100.h,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 5.w,
              color: const Color(0xFFF3DB3E),
            ),
          ),
        ),
        child: Obx(
          () => Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BottomTabItem(
                itemLabel: 'assets/images/icons/tab_store.png',
                itemIcon: 'Store',
                itemIsSelected: _tabsController.storeTabIsSelected.value,
                onTap: () {
                  selectPage(1);
                  _tabsController.selectStoreTab();
                },
              ),
              BottomTabItem(
                itemLabel: 'assets/images/icons/tab_trophy.png',
                itemIcon: 'Leaderboard',
                itemIsSelected: _tabsController.leaderboardTabIsSelected.value,
                onTap: (){
                  selectPage(2);
                  _tabsController.selectLeaderboardTab();
                },
              ),
              BottomTabItem(
                itemLabel: 'assets/images/icons/tab_bible.png',
                itemIcon: 'Home',
                itemIsSelected: _tabsController.homeTabIsSelected.value,
                onTap: () {
                  selectPage(0);
                  _tabsController.selectHomeTab();
                },
              ),
              BottomTabItem(
                itemLabel: 'assets/images/icons/tab_sword.png',
                itemIcon: 'Arcade',
                itemIsSelected: _tabsController.arcadeTabIsSelected.value,
                onTap: () {
                  selectPage(3);
                  _tabsController.selectArcadeTab();
                },
              ),
              BottomTabItem(
                itemLabel: 'assets/images/icons/tab_badge.png',
                itemIcon: 'League',
                itemIsSelected: _tabsController.teamTabIsSelected.value,
                onTap: () {
                  selectPage(4);
                  _tabsController.selectTeamTab();
                },
              ),
            ],
          ),
        ),

        // BottomNavigationBar(
        //     onTap: selectPage,
        //     backgroundColor: const Color(0xFF2F5C9F),
        //     unselectedItemColor: Colors.white,
        //     unselectedLabelStyle:const TextStyle(fontWeight: FontWeight.w300, fontFamily: 'Neuland'),
        //     selectedItemColor: const Color(0xFF214B86),
        //     selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Neuland'),
        //     currentIndex: selectedTabIndex,
        //     type: BottomNavigationBarType.fixed,
        //     showUnselectedLabels: false,
        //     showSelectedLabels: true,
        //     items: [
        //       BottomNavigationBarItem(
        //         backgroundColor: Colors.green,
        //         icon:  AnimatedSvg(
        //           controller: controller,
        //           duration: const Duration(milliseconds: 600),
        //           onTap: () {selectPage(0);},
        //           size: 20.w,
        //           clockwise: true,
        //           isActive: true,
        //           children: [
        //             SvgPicture.asset(
        //               'assets/images/icons/booster.svg',
        //             ),
        //             SvgPicture.asset(
        //               'assets/images/icons/padlock.svg',
        //             ),
        //           ],
        //         ),
        //         label: 'Home',
        //       ),
        //       BottomNavigationBarItem(
        //         backgroundColor: Colors.white,
        //         icon: Icon(MyFlutterApp.application, size: 20.w,),
        //         label: 'Games',
        //       ),
        //       BottomNavigationBarItem(
        //         backgroundColor: Colors.white,
        //         icon: Icon(MyFlutterApp.trophy, size: 20.w,),
        //         label: 'Leaderboard',
        //       ),
        //       // BottomNavigationBarItem(
        //       //   backgroundColor: Colors.white,
        //       //   icon: Icon(Icons.account_circle_rounded),
        //       //   label: 'Account',
        //       // ),
        //     ],
        //   ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());
    return Scaffold(
      body: _pages[selectedTabIndex]['page'],
      bottomNavigationBar: _bottomNavigationBar,
    );
  }
}
