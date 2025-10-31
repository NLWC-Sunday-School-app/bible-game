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
                  Center(
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
                  SizedBox(
                    height: 20.h,
                  )
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
               BlocConsumer<MultiplayerBloc, MultiplayerState>(
                 listener: (context, state){
                   if(state.hasCreatedGameRoom){
                     context.read<WebsocketCubit>().connect();
                   }
                 },
                 builder: (context, state) {
                   if(state.isLoadingCreateGameRoom){
                     return Center(child: CircularProgressIndicator(color: Colors.white,));
                   }else{
                     if(state.hasCreatedGameRoom){
                       print(state.createGameRoomResponse.inviteCode);
                       return Column(
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
                                       inviteCode: state.createGameRoomResponse.inviteCode
                                   ),
                                 ),
                               ),
                               Expanded(
                                 child: GroupGameCard(
                                   title: "Time-based Mode",
                                   backgroundColor: Color(0xFFDAD9FF),
                                   cardImage: ProductImageRoutes.timeBasedMode,
                                   onTap: () => showGroupGamePlayModal(
                                       context,
                                       selectedGroupGame: "Time-based Mode",
                                       inviteCode: state.createGameRoomResponse.inviteCode
                                   ),
                                   // onTap: (){
                                   //   Navigator.pushNamed(context,
                                   //       AppRoutes.lightningModeQuestionScreen,
                                   //   );
                                   // }
                                 ),
                               )
                             ],
                           ),
                           Row(
                             children: [
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
                                 ),
                               ),
                               Expanded(
                                 child: GroupGameCard(
                                   title: "Survival Mode",
                                   backgroundColor: Color(0xFFF0FFDC),
                                   cardImage: ProductImageRoutes.survivalMode,
                                   onTap: () => showGroupGamePlayModal(
                                       context,
                                       selectedGroupGame: "Survival Mode",
                                     inviteCode: state.createGameRoomResponse.inviteCode,
                                   ),
                                 ),
                               )
                             ],
                           ),
                         ],
                       );
                     }else{
                       return Container();
                     }
                   }
                 },
               )
            ],
          ),
        )
    );
  }
}
