import 'package:bible_game/screens/tabs/account.dart';
import 'package:bible_game/screens/tabs/games.dart';
import 'package:bible_game/screens/tabs/home.dart';
import 'package:bible_game/screens/tabs/leaderboard.dart';
import 'package:bible_game/widgets/custom_icons/my_flutter_app_icons.dart';
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

  @override
  void initState() {
    super.initState();
    _setBottomTabPage();
  }

  _setBottomTabPage()async{

  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Widget get _bottomNavigationBar {
    return SizedBox(
      height: 85.h,
        child: BottomNavigationBar(
          onTap: _selectPage,
          backgroundColor: Colors.white,
          unselectedItemColor: const Color.fromRGBO(169, 171, 173, 1),
          unselectedLabelStyle:const TextStyle(fontWeight: FontWeight.w700),
          selectedItemColor: const Color.fromRGBO(118, 99, 229, 1),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
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
              icon: Icon(MyFlutterApp.application),
              label: 'Games',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(MyFlutterApp.trophy),
              label: 'Leaderboard',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.account_circle_rounded),
              label: 'Account',
            ),
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: _pages[_selectedPageIndex]['page'],
       bottomNavigationBar: _bottomNavigationBar,
    );
  }
}


