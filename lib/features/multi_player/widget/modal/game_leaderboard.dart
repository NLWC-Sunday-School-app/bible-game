import 'package:bible_game/features/multi_player/view/game_leaderboard_screen.dart';
import 'package:flutter/material.dart';

void showLeaderboardModal(BuildContext context, selectedGroupGame) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => GameLeaderboardScreen(selectedGroupGame: selectedGroupGame),
      fullscreenDialog: true,
    ),
  );
}
