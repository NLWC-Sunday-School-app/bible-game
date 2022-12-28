import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/utilities/constants.dart';
import 'package:bible_game/widgets/leaderboard/leaderboard_menu_card.dart';
import 'package:flutter/material.dart';

class TabLeaderBoardMenuScreen extends StatelessWidget {
  const TabLeaderBoardMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF548CD7),
      body: SizedBox(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  maxWidth: constraints.maxWidth),
              child: Center(
                child: Stack(
                  children: [
                    Positioned(
                      top: 100,
                      child: Image.asset(
                        'assets/images/leaderboard/leaderboard_menu_cloud.png',
                        width: 200,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: constraints.maxHeight * 0.1),
                        const AutoSizeText(
                          'Leaderboard',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                           fontFamily: 'Neuland',
                            letterSpacing: 1
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.04),
                        const AutoSizeText(
                          'Choose a level',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.03),
                        const LeaderBoardMenuCard(levelImage:'assets/images/pilgrim_levels/babe.png', levelLabel: 'Babe', levelNumber: '1',),
                        const LeaderBoardMenuCard(levelImage:'assets/images/pilgrim_levels/child.png', levelLabel: 'Child', levelNumber: '2',),
                        const LeaderBoardMenuCard(levelImage:'assets/images/pilgrim_levels/young_believer.png', levelLabel: 'Young Believer', levelNumber: '3',),
                        const LeaderBoardMenuCard(levelImage:'assets/images/pilgrim_levels/charity.png', levelLabel: 'Charity', levelNumber: '4',),
                        const LeaderBoardMenuCard(levelImage:'assets/images/pilgrim_levels/father.png', levelLabel: 'Father', levelNumber: '5',),
                        const LeaderBoardMenuCard(levelImage:'assets/images/pilgrim_levels/elder.png', levelLabel: 'Elder', levelNumber: '6',)

                      ],
                    ),

                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
