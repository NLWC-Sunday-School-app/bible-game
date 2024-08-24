
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_bible_game/features/arcade/view/arcade_screen.dart';
import 'package:the_bible_game/features/fantasy_league/view/home_screen.dart';
import 'package:the_bible_game/features/leader_board/view/leaderboard_screen.dart';
import 'package:the_bible_game/features/pilgrim_progress/bloc/pilgrim_progress_bloc.dart';
import 'package:the_bible_game/features/store/view/home_screen.dart';
import 'package:the_bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:the_bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:the_bible_game/shared/widgets/modal/country_update_modal.dart';
import 'package:the_bible_game/shared/widgets/modal/welcome_modal.dart';
import '../../features/home/view/home_screen.dart';
import '../../shared/constants/image_routes.dart';
import '../../shared/features/settings/bloc/settings_bloc.dart';
import '../../shared/widgets/modal/network_modal.dart';
import 'bottom_tab_item.dart';


class BottomTabNavigation extends StatefulWidget {
  static const routeName = '/bottomTab-main-screen';

  const BottomTabNavigation({Key? key}) : super(key: key);

  @override
  _BottomTabNavigationState createState() => _BottomTabNavigationState();
}

class _BottomTabNavigationState extends State<BottomTabNavigation> {
  late StreamSubscription<InternetConnectionStatus> connectivitySubscription;
  int _selectedTabIndex = 2;
  bool _selectedHomeTab = true;
  bool _selectedLeaderboardTab = false;
  bool _selectedStoreTab = false;
  bool _selectedArcadeTab = false;
  bool _selectedLeagueTab = false;
  final List<Map<String, dynamic>> _pages = [
    {
      'page': const StoreHomeScreen(),
      'title': 'Store',
    },
    {
      'page': const LeaderBoardScreen(),
      'title': 'Board',
    },
    {
      'page': const HomeScreen(),
      'title': 'Home',
    },
    {
      'page': const ArcadeScreen(),
      'title': 'Arcade',
    },
    {
      'page': const FantasyLeagueHomeScreen(),
      'title': 'Team',
    },
  ];

  displayWelcomeModal()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var firstTime = prefs.getBool('first_time') ?? true;
    if (firstTime) {
      Timer(const Duration(seconds: 3), () {
         showWelcomeModal(context);
      });
      prefs.setBool('first_time', false);
    }
  }

  checkInternet(BuildContext context) async {
    connectivitySubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
          switch (status) {
            case InternetConnectionStatus.connected:
              print('Data connection is available.');
              break;
            case InternetConnectionStatus.disconnected:
              print('You are disconnected from the internet.');
              showNetworkModal(context);
              break;
          }
        });
  }




  displayCountryUpdateModal() async {
    final userState = BlocProvider.of<AuthenticationBloc>(context).state;
    if (userState.user.id != 0 && (userState.user.country == '')) {
      Timer(const Duration(seconds: 3), () {
        showCountryUpdateModal(context);
      });
    }
  }

  @override
  void initState() {
    super.initState();
   displayWelcomeModal();
   displayCountryUpdateModal();
   checkInternet(context);
  }

  Widget  _bottomNavigationBar(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return SizedBox(
      child: Container(
        height: 120.h,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 5.w,
              color: const Color(0xFFF3DB3E),
            ),
          ),
        ),
        child: Row(
            children: [
              BottomTabItem(
                itemLabel: 'Store',
                itemIcon: IconImageRoutes.storeTabIcon,
                itemIsSelected: _selectedStoreTab,
                onTap: () {
                  soundManager.playTabClickSound();
                 setState(() {
                   _selectedLeagueTab = false;
                   _selectedStoreTab = true;
                   _selectedLeaderboardTab = false;
                   _selectedHomeTab = false;
                   _selectedArcadeTab = false;
                   _selectedTabIndex = 0;
                 });
                },
              ),
              BottomTabItem(
                itemLabel: 'Board',
                itemIcon: IconImageRoutes.trophyTabICon,
                itemIsSelected: _selectedLeaderboardTab,
                onTap: () {
                  soundManager.playTabClickSound();
                  setState(() {
                    _selectedLeagueTab = false;
                    _selectedStoreTab = false;
                    _selectedLeaderboardTab = true;
                    _selectedHomeTab = false;
                    _selectedArcadeTab = false;
                    _selectedTabIndex = 1;
                  });
                },
              ),
              BottomTabItem(
                itemLabel: 'Home',
                itemIcon: IconImageRoutes.homeTabIcon,
                itemIsSelected: _selectedHomeTab,
                onTap: () {
                  soundManager.playTabClickSound();
                  setState(() {
                    _selectedLeagueTab = false;
                    _selectedStoreTab = false;
                    _selectedHomeTab = true;
                    _selectedLeaderboardTab = false;
                    _selectedArcadeTab = false;
                    _selectedTabIndex = 2;
                  });
                  if(BlocProvider.of<AuthenticationBloc>(context).state.user.id != 0){
                    BlocProvider.of<AuthenticationBloc>(context).add(FetchUserDataRequested());
                    BlocProvider.of<PilgrimProgressBloc>(context).add(FetchPilgrimProgressLevelData());
                    BlocProvider.of<UserBloc>(context).add(FetchUserStreakDetails());
                  }
                },
              ),
              BottomTabItem(
                itemLabel: 'Arcade',
                itemIcon: IconImageRoutes.swordTabIcon,
                itemIsSelected: _selectedArcadeTab,
                onTap: () {
                  soundManager.playTabClickSound();
                  setState(() {
                    _selectedLeagueTab = false;
                    _selectedStoreTab = false;
                    _selectedHomeTab = false;
                    _selectedLeaderboardTab = false;
                    _selectedArcadeTab = true;
                    _selectedTabIndex = 3;
                  });
                }
                ,
              ),
              BottomTabItem(
                itemLabel: 'League',
                itemIcon: IconImageRoutes.leagueTabIcon,
                itemIsSelected: _selectedLeagueTab,
                onTap: () {
                  soundManager.playTabClickSound();
                 setState(() {
                   _selectedLeagueTab = true;
                   _selectedStoreTab = false;
                   _selectedHomeTab = false;
                   _selectedLeaderboardTab = false;
                   _selectedArcadeTab = false;
                   _selectedTabIndex = 4;
                 });
                },
              ),
            ],
          ),


      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedTabIndex]['page'],
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }
}
