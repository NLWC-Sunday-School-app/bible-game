import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:flutter/material.dart';
import 'package:bible_game/features/multi_player/widget/game_play_card.dart';
import 'package:bible_game/features/multi_player/widget/game_request_card.dart';
import 'package:bible_game/features/multi_player/widget/modal/create_gameplay_modal.dart';
import 'package:bible_game/features/multi_player/widget/modal/game_request_modal.dart';
import 'package:bible_game/features/multi_player/widget/modal/join_gameplay_modal.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../shared/constants/app_routes.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/widgets/screen_app_bar.dart';

class MultiplayerHomeScreen extends StatelessWidget {
  const MultiplayerHomeScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final selectedCategory = arguments['selectedCategory'];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: AppColors.primaryColorShade, // Status bar color
      ),
      backgroundColor: Color(0xFF2D6BB6),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ProductImageRoutes.patternTwoBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            ScreenAppBar(
              height: 70.h,
              widgets: [
                Center(
                  child: StrokeText(
                    text: 'Multiplayer',
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w900,
                    ),
                    strokeColor: AppColors.titleDropShadowColor,
                    strokeWidth: 6,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                )
              ],
            ),
            SizedBox(
              height: 16.h,
            ),
            Text(
             selectedCategory,
              style: TextStyle(
                color: Color(0xFFFFFAD3),
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            GamePlayCard(
              onTap: (){
                BlocProvider.of<MultiplayerBloc>(context).add(CreateGameRoom());
                Navigator.pushNamed(context,
                    AppRoutes.groupGameCategory,
                    arguments: {
                      'selectedCategory': selectedCategory
                    }
                );
              },
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
            BlocBuilder<MultiplayerBloc, MultiplayerState>(
              builder: (context, state) {
                return GameRequestCard(
                  onTap: (){
                    BlocProvider.of<MultiplayerBloc>(context).add(FetchGameInvites());
                    showGameRequestModal(context);
                    },
                  count: state.inviteCount,
            );
                },
            ),
            SizedBox(
              height: 20.h,
            )
          ],
        ),
      )
    );
  }
}
