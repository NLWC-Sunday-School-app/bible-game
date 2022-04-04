import 'package:bible_game/screens/tabs/account.dart';
import 'package:bible_game/screens/tabs/games.dart';
import 'package:bible_game/screens/tabs/home.dart';
import 'package:bible_game/screens/tabs/leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabMainScreen extends StatefulWidget {
  static const routeName = '/tab-main-screen';

  const TabMainScreen({Key? key}) : super(key: key);

  @override
  _TabMainScreenState createState() => _TabMainScreenState();
}

class _TabMainScreenState extends State<TabMainScreen> {

  int _selectedPageIndex = 0;
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
      'page': const TabLeaderBoardScreen(),
      'title': 'Leaderboard',
    },
    {
      'page': const TabAccountScreen(),
      'title': 'Account',
    }
  ];

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Widget get _bottomNavigationBar {
    return Container(
      height: 100.h,
        child: BottomNavigationBar(
          onTap: _selectPage,
          backgroundColor: Colors.white,
          unselectedItemColor: const Color.fromRGBO(101, 119, 138, 1),
          selectedItemColor: const Color.fromRGBO(48, 105, 164, 1),
          currentIndex: _selectedPageIndex,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.category),
              label: 'Games',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.bar_chart),
              label: 'Leaderboard',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.account_circle_outlined),
              label: 'Account',
            ),
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
