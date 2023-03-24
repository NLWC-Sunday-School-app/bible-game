import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bible_game/controllers/global_games_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/screens/tabs/account.dart';
import 'package:bible_game/screens/tabs/games.dart';
import 'package:bible_game/screens/tabs/home.dart';
import 'package:bible_game/screens/tabs/leaderboard_menu.dart';
import 'package:bible_game/services/game_service.dart';
import 'package:bible_game/services/user_service.dart';
import 'package:bible_game/widgets/custom_icons/my_flutter_app_icons.dart';
import 'package:bible_game/widgets/modals/pilgrim_progress_welcome_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';

import '../../controllers/tabs_controller.dart';
import '../../widgets/modals/welcome_modal.dart';

class TabMainScreen extends StatefulWidget {
  static const routeName = '/tab-main-screen';

  const TabMainScreen({Key? key}) : super(key: key);

  @override
  _TabMainScreenState createState() => _TabMainScreenState();
}

class _TabMainScreenState extends State<TabMainScreen> {
  final TabsController _tabsController = Get.put(TabsController());
  final GlobalGamesController _globalGamesController = Get.put(GlobalGamesController());
  var selectedTabIndex = GetStorage().read('tabIndex') ?? 0;
  UserController userController = Get.put(UserController());
  final player = AudioPlayer();

  final List<Map<String, dynamic>> _pages = [
    {
      'page': const TabHomeScreen(),
      'title': 'Home',
    },
    {
      'page': const TabGamesScreen(),
      'title': 'Games',
    },
    {
      'page': const TabLeaderBoardMenuScreen(),
      'title': 'Leaderboard',
    },
  ];

  void selectPage(int index){
    if(userController.soundIsOff.isFalse){
      player.setAsset('assets/audios/select_tab.mp3');
      player.play();
      player.setVolume(0.5);
    }
    setState(() {
      selectedTabIndex = index;
    });
    GetStorage().write('tabIndex', index);
   if(index == 1){
     _globalGamesController.getGlobalGames();
   }
  }

  @override
  void initState() {
    super.initState();
    displayWelcomeModal();
    //_setBottomTabPage();
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  displayWelcomeModal(){
    var firstTime = GetStorage().read('first_time') ?? true;

    if(firstTime){
      Timer(const Duration(seconds: 3), () {
        Get.dialog(const WelcomeModal());
      });
      GetStorage().write('first_time', false);
    }
  }

  Widget get _bottomNavigationBar {
    return SizedBox(
        child:  BottomNavigationBar(
            onTap: selectPage,
            backgroundColor: const Color(0xFF558CD7),
            unselectedItemColor: Colors.white,
            unselectedLabelStyle:const TextStyle(fontWeight: FontWeight.w300, fontFamily: 'Neuland'),
            selectedItemColor: const Color(0xFF214B86),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Neuland'),
            currentIndex: selectedTabIndex,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            items: [
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.home, size: 15.w,),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(MyFlutterApp.application, size: 15.w,),
                label: 'Games',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(MyFlutterApp.trophy, size: 15.w,),
                label: 'Leaderboard',
              ),
              // BottomNavigationBarItem(
              //   backgroundColor: Colors.white,
              //   icon: Icon(Icons.account_circle_rounded),
              //   label: 'Account',
              // ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());
    return  Scaffold(
         body: _pages[selectedTabIndex]['page'],
         bottomNavigationBar: _bottomNavigationBar,
      );

  }
}


