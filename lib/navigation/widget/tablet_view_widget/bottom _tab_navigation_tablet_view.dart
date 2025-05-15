
import 'dart:async';

import 'package:bible_game/features/arcade/view/tablet_view/arcade_screen_tablet_view.dart';
import 'package:bible_game/features/fantasy_league/view/tablet_view/home_screen_tablet_view.dart';
import 'package:bible_game/features/home/view/tablet_view/home_screen_tablet_view.dart';
import 'package:bible_game/features/leader_board/view/tablet_view/leaderboard_screen_tablet_view.dart';
import 'package:bible_game/features/store/view/tablet_view/home_screen_tablet_view.dart';
import 'package:bible_game/navigation/widget/tablet_view_widget/bottom_tab_item_tablet_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bible_game/features/arcade/view/arcade_screen.dart';
import 'package:bible_game/features/fantasy_league/view/home_screen.dart';
import 'package:bible_game/features/leader_board/view/leaderboard_screen.dart';
import 'package:bible_game/features/pilgrim_progress/bloc/pilgrim_progress_bloc.dart';
import 'package:bible_game/features/store/view/home_screen.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:bible_game/shared/widgets/modal/country_update_modal.dart';
import 'package:bible_game/shared/widgets/modal/welcome_modal.dart';
import '../../../features/home/view/home_screen.dart';
import '../../../shared/constants/image_routes.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../shared/widgets/modal/network_modal.dart';
import '../../cubit/navigation_cubit.dart';
import '../bottom_tab_item.dart';


class BottomTabNavigationTabletView extends StatefulWidget {
  static const routeName = '/bottomTab-main-screen';

  const BottomTabNavigationTabletView({Key? key}) : super(key: key);

  @override
  _BottomTabNavigationTabletViewState createState() => _BottomTabNavigationTabletViewState();
}

class _BottomTabNavigationTabletViewState extends State<BottomTabNavigationTabletView> {
  late StreamSubscription<InternetConnectionStatus> connectivitySubscription;
  // int _selectedTabIndex = 2;
  bool _selectedHomeTab = true;
  bool _selectedLeaderboardTab = false;
  bool _selectedStoreTab = false;
  bool _selectedArcadeTab = false;
  bool _selectedLeagueTab = false;
  final List<Map<String, dynamic>> _pages = [
    {
      'page': const StoreHomeScreenTabletView(),
      'title': 'Store',
    },
    {
      'page': const LeaderBoardScreenTabletView(),
      'title': 'Board',
    },
    {
      'page': const HomeScreenTabletView(),
      'title': 'Home',
    },
    {
      'page': const ArcadeScreenTabletView(),
      'title': 'Arcade',
    },
    {
      'page': const FantasyLeagueHomeScreenTabletView(),
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
              if (!mounted) return;
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

  Widget  _bottomNavigationBar(BuildContext context, isTablet, int _selectedTabIndex) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return Container(
      height: 160.h,
      child: Row(
          children: [
            BottomTabItemTabletView(
              itemLabel: 'Store',
              itemIcon: IconImageRoutes.storeTabIcon,
              itemIsSelected: _selectedTabIndex == 0,
              onTap: () {
                soundManager.playTabClickSound();
                context.read<NavigationCubit>().selectTab(0);
              },
            ),
            BottomTabItemTabletView(
              itemLabel: 'Board',
              itemIcon: IconImageRoutes.trophyTabICon,
              itemIsSelected: _selectedTabIndex == 1,
              onTap: () {
                soundManager.playTabClickSound();
                context.read<NavigationCubit>().selectTab(1);

              },
            ),
            BottomTabItemTabletView(
              itemLabel: 'Home',
              itemIcon: IconImageRoutes.homeTabIcon,
              itemIsSelected: _selectedTabIndex == 2,
              onTap: () {
                soundManager.playTabClickSound();
                context.read<NavigationCubit>().selectTab(2);

                // if(BlocProvider.of<AuthenticationBloc>(context).state.user.id != 0){
                //   BlocProvider.of<AuthenticationBloc>(context).add(FetchUserDataRequested());
                //   BlocProvider.of<PilgrimProgressBloc>(context).add(FetchPilgrimProgressLevelData());
                //   BlocProvider.of<UserBloc>(context).add(FetchUserStreakDetails());
                // }
              },
            ),
            BottomTabItemTabletView(
              itemLabel: 'Arcade',
              itemIcon: IconImageRoutes.swordTabIcon,
              itemIsSelected: _selectedTabIndex == 3,
              onTap: () {
                soundManager.playTabClickSound();
                context.read<NavigationCubit>().selectTab(3);
              }
              ,
            ),
            BottomTabItemTabletView(
              itemLabel: 'League',
              itemIcon: IconImageRoutes.leagueTabIcon,
              itemIsSelected: _selectedTabIndex == 4,
              onTap: () {
                soundManager.playTabClickSound();
                context.read<NavigationCubit>().selectTab(4);
              },
            ),
          ],
        ),

    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final int _selectedTabIndex = context.watch<NavigationCubit>().state;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: _pages[_selectedTabIndex]['page'],
      bottomNavigationBar: _bottomNavigationBar(context, isTablet,_selectedTabIndex),
    );
  }
}
