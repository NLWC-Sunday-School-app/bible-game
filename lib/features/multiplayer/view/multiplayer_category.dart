import 'package:bible_game/features/multiplayer/widget/multiplayer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/constants/app_routes.dart';
import '../../../shared/constants/image_routes.dart';
import '../../multi_player/bloc/multiplayer_bloc.dart';
import '../../multi_player/bloc/multiplayer_event.dart';

class MultiplayerCategory extends StatelessWidget {
  const MultiplayerCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MultiplayerCard(
          bgColor: Color(0xFFDAFFE8),
          gameType: 'Group Game',
          gameText: 'Be the host and invite friends',
          gameImage: ProductImageRoutes.groupGame,
          gameImageWidth: 20,
          onTap: () {
            BlocProvider.of<MultiplayerBloc>(context).add(CountInvite());
            Navigator.pushNamed(context,
                AppRoutes.multiplayer,
                arguments: {
                  'selectedCategory': 'Group Game'
                }
            );
          },
        ),
        SizedBox(height: 20.h,),
        MultiplayerCard(
          bgColor: Color(0xFFDAD6FF),
          gameType: 'Versus Game',
          gameText: 'Enjoy the thrills with your  friends',
          gameImage: ProductImageRoutes.versusGame,
          gameImageWidth: 20,
          onTap: () {  },
        ),
      ],
    );
  }
}
