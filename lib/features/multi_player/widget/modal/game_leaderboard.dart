import 'package:another_flushbar/flushbar.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/widget/modal/invite_modal.dart';
import 'package:bible_game/features/multi_player/widget/modal/players_waiting_modal.dart';
import 'package:bible_game/features/multi_player/widget/multiplayer_leaderboard_card.dart';
import 'package:bible_game/shared/features/multiplayer/cubit/websocket_cubit.dart';
import 'package:bible_game/shared/widgets/multi_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/multi_player/widget/player_waiting_card.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stroke_text/stroke_text.dart';
import '../../../../shared/constants/app_routes.dart';
import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/utils/country_iso_3.dart';
import '../../../../shared/utils/custom_toast.dart';
import '../../../lightning_mode/bloc/lightning_mode_bloc.dart';

void showLeaderboardModal(BuildContext context,selectedGroupGame) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GameLeaderboardModal(selectedGroupGame: selectedGroupGame);
      });
}

class GameLeaderboardModal extends StatefulWidget {
  const GameLeaderboardModal({super.key, required this.selectedGroupGame});
  final String selectedGroupGame;

  @override
  State<GameLeaderboardModal> createState() => _GameLeaderboardModalState();
}

class _GameLeaderboardModalState extends State<GameLeaderboardModal> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      insetAnimationCurve: Curves.bounceInOut,
      insetAnimationDuration: const Duration(milliseconds: 500),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          color: Colors.black.withOpacity(0.8),
          padding: EdgeInsets.only(top: 30.h),
          child: Stack(
            children: [
              BlocBuilder<WebsocketCubit, WebsocketState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 200.h,
                            margin: EdgeInsets.only(right: 15.w, left: 15.w, top: 50.h),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFF047AEE)
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF083073),
                                  offset: Offset(2, 4),
                                  blurRadius: 0,
                                  spreadRadius: -2,
                                ),
                              ],
                              color: Color(0xFFFFEED6),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 20,),
                                Container(
                                  height: 90.h,
                                  width: 90.w,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(color: Color(0xFF366ABC))
                                  ),
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    margin: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                        shape:  BoxShape.circle,
                                    ),
                                    child: AvatarWidget(seed: state.gameFinishedEvent.data!.leaderboard[0].userId!, width: 40.w, height: 40.h,),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    StrokeText(
                                      text: state.gameFinishedEvent.data?.winner ?? "",
                                      textStyle: TextStyle(
                                        color: Color(0xFF0D468A),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w900,
                                      ),
                                      strokeColor: Color(0xFFF4FFCE),
                                      strokeWidth: 4,
                                    ),
                                    SizedBox(
                                      width:5.w,
                                    ),
                                    state.gameFinishedEvent.data!.leaderboard[0].country!= null
                                        ? SvgPicture.asset(
                                      'assets/images/flags/${state.gameFinishedEvent.data!.leaderboard[0].country!.replaceAll('/', ' ').toLowerCase()}.svg',
                                      width: 16.w,
                                    )
                                        : SizedBox(
                                      width: 16.w,
                                    ),
                                    SizedBox(
                                      width:2.w,
                                    ),
                                    Text(
                                      state.gameFinishedEvent.data!.leaderboard[0].country != null
                                          ? getIso3Code(state.gameFinishedEvent.data!.leaderboard[0].country!.replaceAll('/', ' '))
                                          : '-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF082D5A)),
                                    ),
                                    SizedBox(
                                      width:5.w,
                                    ),
                                    StrokeText(
                                      text: "Won",
                                      textStyle: TextStyle(
                                        color: Color(0xFF0D468A),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w900,
                                      ),
                                      strokeColor: Color(0xFFF4FFCE),
                                      strokeWidth: 4,
                                    ),
                                  ],)
                              ],
                            ),
                          ),
                          Image.asset(
                            ProductImageRoutes.leaderboardBanner,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 30.w,),
                                Text(
                                  "Game Leaderboard!",
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    context.read<WebsocketCubit>().closeWebsocket();
                                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home,
                                            (Route<dynamic> route) => false);
                                  },
                                  child: Image.asset(
                                    IconImageRoutes.redCircleClose,
                                    width: 50.w,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 12.h,),
                      Expanded(
                          child: ListView.builder(
                              itemCount: state.gameFinishedEvent.data!.leaderboard.length,
                              itemBuilder: (BuildContext context, int index){
                                return MultiplayerLeaderboardCard(
                                    position: (index+1),
                                    userName: state.gameFinishedEvent.data!.leaderboard[index].username ??"",
                                    countryName: state.gameFinishedEvent.data!.leaderboard[index].country??"Nigeria",
                                    userRank:state.gameFinishedEvent.data!.leaderboard[index].level ?? "child",
                                    noOfCoins: state.gameFinishedEvent.data!.leaderboard[index].score ??0,
                                    userId:state.gameFinishedEvent.data!.leaderboard[index].userId
                                );
                                // return Container();
                              }
                          )
                      ),
                    ],
                  );
                  },
              ),
              BlocListener<WebsocketCubit, WebsocketState>(
                listener: (context, state){
                  if(state.eventType == "GAME_RESTARTED"){
                    Navigator.pushNamedAndRemoveUntil(context,
                        AppRoutes.multiplayer,
                            (Route<dynamic> route) => false,
                        arguments: {
                          'selectedCategory': "Group Game"
                        }
                    );
                    showHostWaitingModal(context,
                        selectedGroupGame: widget.selectedGroupGame,
                        inviteCode: "${context.read<MultiplayerBloc>().state.createGameRoomResponse.inviteCode}",
                        questionType: "${context.read<WebsocketCubit>().state.playersJoined.gameMode}",
                        noOfQuestion: null
                    );
                    CustomToast.showInviteToast(context, isInviteSuccessful: true);
                  }
                },
                child: Container(),
              ),
              BlocConsumer<LightningModeBloc, LightningModeState>(
                listener: (context, state){
                },
                builder: (context, state) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: BlueButton(
                      onTap: () {
                        BlocProvider.of<LightningModeBloc>(context).add(GameRestart());
                      },
                      buttonText: 'Play another round',
                      buttonIsLoading: state.isLoadingGameRestart == true,
                      width: 280.w,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
