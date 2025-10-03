import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/widget/modal/players_waiting_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/multi_player/widget/sent_game_request_card.dart';

import '../../../../shared/constants/image_routes.dart';

void showGameRequestModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return GameRequestModal();
      });
}

class GameRequestModal extends StatelessWidget {
  const GameRequestModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      backgroundColor: Colors.transparent,
      insetAnimationCurve: Curves.bounceInOut,
      insetAnimationDuration: const Duration(milliseconds: 500),
      child: SizedBox(
        height: 400.h,
        child: BlocConsumer<MultiplayerBloc, MultiplayerState>(
          listener: (context, state) {
            if(state.hasAcceptedInvite){
              Navigator.pop(context);
              showPlayersWaitingForHostModal(context,
                  selectedGroupName: state.createGameRoomResponse.victoryCondition!.questionType!.toLowerCase() == "lightning"
                  ?
                  "lightning mode":"",
                  inviteCode: state.createGameRoomResponse.inviteCode,
                  questionType: ""
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Container(
                  height: 64.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          ProductImageRoutes.requestGameModalTitleBg),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.white, width: 2.w),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF0A4B98),
                        offset: Offset(1, 7),
                        blurRadius: 0,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          width: 40.w,
                          height: 40.w,
                          child: Center(
                              child: Text(
                                "${state.listOfInvite.length}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14.sp,
                                    color: Color(0xFF0E69D3)),
                              )),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 2, color: Color(0xFF116FDE)),
                          )),
                      Text(
                        'Game Request',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontSize: 18.sp,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          IconImageRoutes.redCircleClose,
                          width: 60.w,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Container(
                    width: double.infinity,
                    height: 300.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFF9FCFF),
                      border: Border(
                        left: BorderSide(width: 2.w, color: Color(0xFF0A4B98)),
                        right: BorderSide(width: 2.w, color: Color(0xFF0A4B98)),
                        bottom: BorderSide(width: 2.w, color: Color(
                            0xFF0A4B98)),
                      ),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(16.r),
                        bottomLeft: Radius.circular(16.r),
                      ),
                    ),
                    child: state.isFetchingListOfGameInvite?
                    Center(child: CircularProgressIndicator())
                        :
                    Column(
                      children: List.generate(
                          state.listOfInvite.length,
                              (index) =>  SentGameRequestCard(
                                userAvatar: '',
                                userName: state.listOfInvite[index].inviterUsername??"",
                                state: state,
                                inviteId: state.listOfInvite[index].id!,
                              )
                      )
                    )
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
