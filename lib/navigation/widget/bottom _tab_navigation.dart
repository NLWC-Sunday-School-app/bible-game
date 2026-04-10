
import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bible_game/features/arcade/view/arcade_screen.dart';
import 'package:bible_game/features/fantasy_league/view/home_screen.dart';
import 'package:bible_game/features/leader_board/view/leaderboard_screen.dart';
import 'package:bible_game/features/pilgrim_progress/bloc/pilgrim_progress_bloc.dart';
import 'package:bible_game/features/store/view/home_screen.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/connectivity/bloc/connectivity_bloc.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:bible_game/shared/widgets/modal/country_update_modal.dart';
import 'package:bible_game/shared/widgets/modal/welcome_modal.dart';
import '../../features/home/view/home_screen.dart';
import '../../shared/constants/image_routes.dart';
import '../../shared/features/localization/app_localization.dart';
import '../../shared/features/settings/bloc/settings_bloc.dart';
import '../cubit/navigation_cubit.dart';
import 'bottom_tab_item.dart';


class BottomTabNavigation extends StatefulWidget {
  static const routeName = '/bottomTab-main-screen';

  const BottomTabNavigation({Key? key}) : super(key: key);

  @override
  _BottomTabNavigationState createState() => _BottomTabNavigationState();
}

class _BottomTabNavigationState extends State<BottomTabNavigation> {
  bool _selectedHomeTab = true;
  bool _selectedLeaderboardTab = false;
  bool _selectedStoreTab = false;
  bool _selectedArcadeTab = false;
  bool _selectedLeagueTab = false;
  final List<Widget> _pages = [
    const StoreHomeScreen(),
    const LeaderBoardScreen(),
    const HomeScreen(),
    const ArcadeScreen(),
    const FantasyLeagueHomeScreen(),
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
  }

  Widget  _bottomNavigationBar(BuildContext context, int _selectedTabIndex) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    final tr = AppLocalization.tr(context);
    final bottomPadding = kIsWeb ? MediaQuery.of(context).viewPadding.bottom : 0.0;
    return SizedBox(
      child: Container(
        padding: EdgeInsets.only(bottom: bottomPadding),
        height: 120.h + bottomPadding,
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
                itemLabel: tr.t('nav_store'),
                itemIcon: IconImageRoutes.storeTabIcon,
                itemIsSelected: _selectedTabIndex == 0,
                onTap: () {
                  soundManager.playTabClickSound();
                  context.read<NavigationCubit>().selectTab(0);
                },
              ),
              BottomTabItem(
                itemLabel: tr.t('nav_board'),
                itemIcon: IconImageRoutes.trophyTabICon,
                itemIsSelected: _selectedTabIndex == 1,
                onTap: () {
                  soundManager.playTabClickSound();
                  context.read<NavigationCubit>().selectTab(1);
                },
              ),
              BottomTabItem(
                itemLabel: tr.t('nav_home'),
                itemIcon: IconImageRoutes.homeTabIcon,
                itemIsSelected: _selectedTabIndex == 2,
                onTap: () {
                  soundManager.playTabClickSound();
                  context.read<NavigationCubit>().selectTab(2);
                },
              ),
              BottomTabItem(
                itemLabel: tr.t('nav_arcade'),
                itemIcon: IconImageRoutes.swordTabIcon,
                itemIsSelected: _selectedTabIndex == 3,
                onTap: () {
                  soundManager.playTabClickSound();
                  context.read<NavigationCubit>().selectTab(3);
                },
              ),
              BottomTabItem(
                itemLabel: tr.t('nav_league'),
                itemIcon: IconImageRoutes.leagueTabIcon,
                itemIsSelected: _selectedTabIndex == 4,
                onTap: () {
                  soundManager.playTabClickSound();
                  context.read<NavigationCubit>().selectTab(4);
                },
              ),
            ],
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int _selectedTabIndex = context.watch<NavigationCubit>().state;
    final tr = AppLocalization.tr(context);
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listenWhen: (previous, current) =>
          previous.isOnline != current.isOnline ||
          previous.isSyncing != current.isSyncing,
      listener: (context, state) {
        if (!state.isOnline) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(tr.t('offline_features_limited')),
              backgroundColor: Colors.orange.shade800,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state.isOnline && state.isSyncing) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(tr.t('syncing_scores')),
              backgroundColor: Colors.blue.shade700,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state.isOnline && !state.isSyncing && state.pendingSyncCount == 0) {
          // Just came back online and sync completed
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(tr.t('back_online')),
              backgroundColor: Colors.green.shade700,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        body: _pages[_selectedTabIndex],
        bottomNavigationBar: _bottomNavigationBar(context, _selectedTabIndex),
      ),
    );
  }
}
