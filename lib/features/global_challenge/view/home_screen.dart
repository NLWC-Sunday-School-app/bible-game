import 'package:flutter/material.dart';
import 'package:the_bible_game/features/global_challenge/widget/global_challenge_card.dart';

class GlobalChallengeHomeScreen extends StatelessWidget {
  const GlobalChallengeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return GlobalChallengeCard(
            imageUrl: 'https://res.cloudinary.com/dd3hfa9ug/image/upload/v1702426359/Frame_644953_1_xtp7gv.png',
            title: 'Purity',
            text: "Is purity possible? What's expected of us to stay pure? Let's find out!",
            gameIsLive: false,
            campaignTag: '',
          );
        },
      ),
    );
  }
}
