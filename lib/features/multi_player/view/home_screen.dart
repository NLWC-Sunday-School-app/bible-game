import 'package:flutter/material.dart';
import 'package:the_bible_game/features/multi_player/widget/game_play_card.dart';
import 'package:the_bible_game/features/multi_player/widget/game_request_card.dart';
import 'package:the_bible_game/features/multi_player/widget/modal/create_gameplay_modal.dart';
import 'package:the_bible_game/features/multi_player/widget/modal/game_request_modal.dart';
import 'package:the_bible_game/features/multi_player/widget/modal/join_gameplay_modal.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MultiplayerHomeScreen extends StatelessWidget {
  const MultiplayerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GamePlayCard(
          onTap: () => showCreateGamePlayModal(context),
          title: 'Create a gameplay',
          text: 'Be the host and invite your friends',
          backgroundImage: ProductImageRoutes.createGameCardBg,
          swordImage: ProductImageRoutes.createSword,
        ),
        GamePlayCard(
          onTap: () => showJoinGamePlayModal(context),
          title: 'Join gameplay',
          text: 'Enjoy the thrills with your  friends',
          backgroundImage: ProductImageRoutes.joinGameCardBg,
          swordImage: ProductImageRoutes.joinSword,
        ),
        SizedBox(height: 120.h,),
         GameRequestCard(
           onTap: () => showGameRequestModal(context),
         ),
        SizedBox(
          height: 20.h,
        )
      ],
    );
  }
}
