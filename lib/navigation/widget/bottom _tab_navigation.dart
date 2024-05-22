
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/features/arcade/view/arcade_screen.dart';
import 'package:the_bible_game/features/fantasy_league/view/home_screen.dart';
import 'package:the_bible_game/features/leader_board/view/leaderboard_screen.dart';
import 'package:the_bible_game/features/store/view/home_screen.dart';
import '../../features/home/view/home_screen.dart';
import '../../shared/constants/image_routes.dart';
import 'bottom_tab_item.dart';


class BottomTabNavigation extends StatefulWidget {
  static const routeName = '/bottomTab-main-screen';

  const BottomTabNavigation({Key? key}) : super(key: key);

  @override
  _BottomTabNavigationState createState() => _BottomTabNavigationState();
}

class _BottomTabNavigationState extends State<BottomTabNavigation> {
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
      'title': 'Leaderboard',
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

  Widget get _bottomNavigationBar {
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
                itemLabel: 'Leaderboard',
                itemIcon: IconImageRoutes.trophyTabICon,
                itemIsSelected: _selectedLeaderboardTab,
                onTap: () {
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
                  setState(() {
                    _selectedLeagueTab = false;
                    _selectedStoreTab = false;
                    _selectedHomeTab = true;
                    _selectedLeaderboardTab = false;
                    _selectedArcadeTab = false;
                    _selectedTabIndex = 2;
                  });
                },
              ),
              BottomTabItem(
                itemLabel: 'Arcade',
                itemIcon: IconImageRoutes.swordTabIcon,
                itemIsSelected: _selectedArcadeTab,
                onTap: () {
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
      bottomNavigationBar: _bottomNavigationBar,
    );
  }
}
