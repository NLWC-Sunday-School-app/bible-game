import 'package:bible_game/features/multi_player/widget/modal/game_mode_info_modal.dart';
import 'package:bible_game/features/multi_player/widget/group_game_card.dart';
import 'package:flutter/material.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../shared/constants/colors.dart';
import '../../../shared/features/multiplayer/cubit/websocket_cubit.dart';
import '../../../shared/widgets/screen_app_bar.dart';
import '../bloc/multiplayer_bloc.dart';
import '../bloc/multiplayer_event.dart';
import '../widget/modal/group_gameplay_modal.dart';

class GroupGameCategory extends StatelessWidget {
  const GroupGameCategory({super.key});

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
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          IconImageRoutes.arrowCircleBack,
                          width: 44.w,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: StrokeText(
                            text: selectedCategory,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w900,
                            ),
                            strokeColor: AppColors.titleDropShadowColor,
                            strokeWidth: 6,
                          ),
                        ),
                      ),
                      SizedBox(width: 44.w),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  )
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
              const Expanded(child: GroupGameCategoryBody()),
            ],
          ),
        )
    );
  }
}


/// The game-mode grid shown after a room is created.
///
/// Split out of [GroupGameCategory] so the tablet variant can reuse it with a
/// width cap rather than duplicating the mode list and its bloc wiring.
class GroupGameCategoryBody extends StatelessWidget {
  const GroupGameCategoryBody({super.key, this.maxContentWidth});

  /// Caps the content width. Null on phones; tablets pass a value so the mode
  /// cards do not stretch across the full width.
  final double? maxContentWidth;

  @override
  Widget build(BuildContext context) {
    final Widget content =
                BlocConsumer<MultiplayerBloc, MultiplayerState>(
                 // hasCreatedGameRoom is never reset, so an unguarded listener
                 // re-ran on every emission -- which, with session-wide invite
                 // polling, is every ten seconds. connect() no-ops when already
                 // connected, but there is no reason to ask it that often.
                 listenWhen: (previous, current) =>
                     !previous.hasCreatedGameRoom && current.hasCreatedGameRoom,
                 listener: (context, state){
                   if(state.hasCreatedGameRoom){
                     context.read<WebsocketCubit>().connect();
                   }
                 },
                 builder: (context, state) {
                   if(state.isLoadingCreateGameRoom){
                     return Center(child: CircularProgressIndicator(color: Colors.white,));
                   }else if(state.hasCreateGameRoomFailed){
                     return Center(
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text(
                             "Game Room couldn't be created",
                             style: TextStyle(
                               color: Colors.white,
                               fontSize: 18.sp,
                               fontWeight: FontWeight.w600,
                             ),
                           ),
                           SizedBox(height: 20.h),
                           ElevatedButton(
                             onPressed: () {
                               BlocProvider.of<MultiplayerBloc>(context).add(CreateGameRoom());
                             },
                             style: ElevatedButton.styleFrom(
                               backgroundColor: Colors.white,
                               padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
                             ),
                             child: Text(
                               'Retry',
                               style: TextStyle(
                                 color: Color(0xFF2D6BB6),
                                 fontWeight: FontWeight.w700,
                                 fontSize: 16.sp,
                               ),
                             ),
                           ),
                         ],
                       ),
                     );
                   }else{
                     if(state.hasCreatedGameRoom){
                       print(state.createGameRoomResponse.inviteCode);
                       // Scrollable rather than a bare Column: the grid sits
                       // in a tight slot, so a couple of extra pixels of card
                       // height -- the info icon's padding, say -- overflowed it.
                       return SingleChildScrollView(
                         child: Column(
                         children: [
                           Text(
                             "Select Game Mode",
                             style: TextStyle(
                               color: Color(0xFFFFFAD3),
                               fontSize: 20.sp,
                               fontWeight: FontWeight.w900,
                             ),
                           ),
                           SizedBox(
                             height: 20.h,
                           ),
                           Row(
                             children: [
                               Expanded(
                                 child: GroupGameCard(
                                   title: "Lightning Mode",
                                   backgroundColor: Color(0xFFD6EEFF),
                                   cardImage: ProductImageRoutes.lightningMode,
                                   onTap: () => showGroupGamePlayModal(
                                       context,
                                       selectedGroupGame: "Lightning Mode",
                                       inviteCode: state.createGameRoomResponse.inviteCode,
                                   ),
                                   onInfoTap: () => showGameModeInfoModal(
                                     context,
                                     title: "Lightning Mode",
                                     image: ProductImageRoutes.lightningMode,
                                     summary: "A race through a fixed set of questions. Everyone sees the same question at the same time.",
                                     rules: const [
                                       "You choose how many questions the round runs for, from 10 up to 30.",
                                       "You set the seconds per question, from 6 to 12 -- it moves on whether you answer or not.",
                                       "Answer correctly and quickly: the faster you are, the more you score.",
                                       "Highest total when the questions run out takes first place.",
                                     ],
                                   ),
                                 ),
                               ),
                               Expanded(
                                 child: GroupGameCard(
                                   title: "First to X",
                                   backgroundColor: Color(0xFFFFEBD9),
                                   cardImage: ProductImageRoutes.xMode,
                                   onTap: () => showGroupGamePlayModal(
                                       context,
                                       selectedGroupGame: "First to X",
                                       inviteCode: state.createGameRoomResponse.inviteCode,
                                   ),
                                   onInfoTap: () => showGameModeInfoModal(
                                     context,
                                     title: "First to X",
                                     image: ProductImageRoutes.xMode,
                                     summary: "A race to a coin target rather than through a set number of questions.",
                                     rules: const [
                                       "You set the target coins when creating the game, from 1,000 up to 3,000.",
                                       "You set the seconds per question, from 6 to 12, same as Lightning Mode.",
                                       "Correct answers earn coins; speed earns more of them.",
                                       "The first player to reach the target wins -- the round ends there.",
                                     ],
                                   ),
                                 ),
                               )
                             ],
                           ),
                           Row(
                             children: [
                               Expanded(
                                 child: GroupGameCard(
                                   title: "Time-based Mode",
                                   backgroundColor: Color(0xFFDAD9FF),
                                   cardImage: ProductImageRoutes.timeBasedMode,
                                   isEnabled: false,
                                   onTap: () => showGroupGamePlayModal(
                                       context,
                                       selectedGroupGame: "Time-based Mode",
                                       inviteCode: state.createGameRoomResponse.inviteCode,
                                   ),
                                   onInfoTap: () => showGameModeInfoModal(
                                     context,
                                     title: "Time-based Mode",
                                     image: ProductImageRoutes.timeBasedMode,
                                     summary: "A race against the clock instead of a question count.",
                                     rules: const [
                                       "You pick how many minutes the round lasts.",
                                       "Answer as many questions as you can before time runs out.",
                                       "Most points when the clock stops wins.",
                                     ],
                                     comingSoonNote: "Not playable yet. The create screen is built, the game behind it is not.",
                                   ),
                                 ),
                               ),
                               Expanded(
                                 child: GroupGameCard(
                                   title: "Survival Mode",
                                   backgroundColor: Color(0xFFF0FFDC),
                                   cardImage: ProductImageRoutes.survivalMode,
                                   isEnabled: false,
                                   onTap: () => showGroupGamePlayModal(
                                       context,
                                       selectedGroupGame: "Survival Mode",
                                       inviteCode: state.createGameRoomResponse.inviteCode,
                                   ),
                                   onInfoTap: () => showGameModeInfoModal(
                                     context,
                                     title: "Survival Mode",
                                     image: ProductImageRoutes.survivalMode,
                                     summary: "Last player standing.",
                                     rules: const [
                                       "Play continues until players are knocked out.",
                                       "The final rules are still being decided.",
                                     ],
                                     comingSoonNote: "Not playable yet, and the rules above are provisional.",
                                   ),
                                 ),
                               )
                             ],
                           ),
                         ],
                       ));
                     }else{
                       return Container();
                     }
                   }
                 },
               );

    if (maxContentWidth == null) return content;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth!),
        child: content,
      ),
    );
  }
}
