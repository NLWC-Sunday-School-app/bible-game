import 'package:another_flushbar/flushbar.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:bible_game/features/multi_player/widget/modal/invite_modal.dart';
import 'package:bible_game/shared/features/multiplayer/cubit/websocket_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/multi_player/widget/player_waiting_card.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';
import '../../../../shared/constants/app_routes.dart';
import '../../../../shared/constants/image_routes.dart';
import '../../../lightning_mode/bloc/lightning_mode_bloc.dart';

void showHostWaitingModal(BuildContext context, {required selectedGroupGame, required inviteCode, required questionType}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return PlayersWaitingModal(
          isWaitingForHost: false,
          selectedGroupGame: selectedGroupGame,
          inviteCode: inviteCode,
          questionType: questionType,

        );
      });
}

void showPlayersWaitingForHostModal(BuildContext context, {required selectedGroupName, required inviteCode, required questionType}) {

  //4DW7FP
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return PlayersWaitingModal(
          isWaitingForHost: true,
          selectedGroupGame: selectedGroupName,
          inviteCode: inviteCode,
          questionType: questionType,
        );
      });
}

class PlayersWaitingModal extends StatefulWidget {
  const PlayersWaitingModal({super.key, required this.isWaitingForHost, required this.selectedGroupGame, required this.inviteCode, required this.questionType});

  final bool isWaitingForHost;
  final String selectedGroupGame;
  final String questionType;
  final String inviteCode;

  @override
  State<PlayersWaitingModal> createState() => _PlayersWaitingModalState();
}

class _PlayersWaitingModalState extends State<PlayersWaitingModal> {

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
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8, left: 8, top: 25),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFDB0C34)
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF94142E),
                          offset: Offset(2, 4),
                          blurRadius: 0,
                          spreadRadius: -2,
                        ),
                      ],
                      color: Color(0xFFFFEED6),
                      image: DecorationImage(
                        image: AssetImage(ProductImageRoutes.glowIcon),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Image.asset(
                              IconImageRoutes.redCircleClose,
                              width: 40.w,
                            ),
                          ),
                        ),
                        widget.selectedGroupGame == "Lightning Mode"
                            ?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              ProductImageRoutes.lightningMode,
                              height: 40.h,
                              width: 40.w,
                            ),
                            SizedBox(width: 5,),
                            Text(
                              'Lightning Mode',
                              style: TextStyle(
                                  color: Color(0xFF014CA3),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp),
                            ),
                          ],
                        )
                            :
                        widget.selectedGroupGame == "Time-based Mode"?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              ProductImageRoutes.timeBasedMode,
                              height: 40.h,
                              width: 40.w,
                            ),
                            SizedBox(width: 5,),
                            Text(
                              'Time-Based Mode',
                              style: TextStyle(
                                  color: Color(0xFF014CA3),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp),
                            ),
                          ],
                        )
                            :
                        widget.selectedGroupGame == "First to X"?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              ProductImageRoutes.xMode,
                              height: 40.h,
                              width: 40.w,
                            ),
                            SizedBox(width: 5,),
                            Text(
                              'First to X Mode',
                              style: TextStyle(
                                  color: Color(0xFF014CA3),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp),
                            ),
                          ],
                        )
                            :
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              ProductImageRoutes.survivalMode,
                              height: 40.h,
                              width: 40.w,
                            ),
                            SizedBox(width: 5,),
                            Text(
                              'Survival Mode',
                              style: TextStyle(
                                  color: Color(0xFF014CA3),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Question type: ",
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400
                                    )
                                ),
                                SizedBox(height: 10.h,),
                                widget.selectedGroupGame == "Time-based Mode"||widget.selectedGroupGame == "Survival Mode"?
                                Text(
                                    "Duration: ",
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400
                                    )
                                )
                                    :
                                widget.selectedGroupGame == "First to X"?
                                Text(
                                    "Target Point X: ",
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400
                                    )
                                )
                                    :
                                SizedBox.shrink()
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    widget.questionType.isEmpty?"${context.read<WebsocketCubit>().state.playersJoined.gameMode}":widget.questionType,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500
                                    )
                                ),
                                SizedBox(height: 10.h,),
                                widget.selectedGroupGame == "Time-based Mode"||widget.selectedGroupGame == "Survival Mode"?
                                Text(
                                    "10 minutes",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                                    :
                                widget.selectedGroupGame == "First to X"?
                                Text(
                                    "100 pts",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                                    :
                                SizedBox.shrink()
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 36.h,),
                        Text(
                          'Code to join gameplay',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 13.sp),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          width: 260.w,
                          height: 48.h,
                          decoration: BoxDecoration(
                              border:
                              Border.all(color: Color(0xFFD8B98C)),
                              borderRadius: BorderRadius.circular(4.r)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Spacer(),
                                  Text(
                                    widget.inviteCode,
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF014CA3),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: (){
                                      Clipboard.setData(ClipboardData(text: widget.inviteCode));
                                      Flushbar(
                                        message: 'Copied',
                                        flushbarPosition: FlushbarPosition.TOP,
                                        flushbarStyle: FlushbarStyle.GROUNDED,
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 3),
                                      ).show(context);
                                    },
                                    icon: Icon(
                                      Icons.copy,
                                      color: Color(0xFF014CA3),
                                    ),
                                  ),
                                  Spacer()
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 36.h,),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h,),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 8, left: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF2EB),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: BlocConsumer<WebsocketCubit, WebsocketState>(
                        listener: (context, state){
                            if(state.eventType == "GAME_STARTED"){
                              Navigator.pop(context);
                              Navigator.pushNamed(context, AppRoutes.questionLoadingScreen, arguments:{ 'gameType': widget.selectedGroupGame});
                            }
                        },
                        builder: (context, state) {
                          return Column(
                            children: [
                              Container(
                                height: 55.h,
                                padding: EdgeInsets.only(left: 24, right: 24,),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFF2EB),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(8)
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF000000).withOpacity(0.1),
                                      offset: Offset(0, 4),
                                      blurRadius: 20,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    widget.isWaitingForHost == false
                                        ?
                                InkWell(
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              showInviteModal(context);
                                            },
                                            child: Container(
                                              height: 31.h,
                                              width: 31.w,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFFD9D9D9),
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 1
                                                  )
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.add
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 4.w,),
                                          Text(
                                            'Invite',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF122F52),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ):SizedBox.shrink(),
                                    Text(
                                      'No of Players: ${state.playersJoined.totalPlayers??0}',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF122F52),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: state.playersJoined.players.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return PlayerWaitingCard(
                                      position: index+1,
                                      userName: state.playersJoined.players[index].username??"",
                                      countryName: "NGA",
                                      countryLogo:
                                        'https://res.cloudinary.com/dd3hfa9ug/image/upload/v1714750941/Nigeria_NG_q4jizd.png',
                                      userLevel: 'Babe',
                                      userBadge: ProductImageRoutes.defaultBadge,
                                      noOfCoins: '100',
                                      userId: state.playersJoined.players[index].userId??"",
                                      isWaitingForHost: widget.isWaitingForHost,
                                      isHost:state.playersJoined.players[index].isHost??false,
                                      );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: BlueButton(
                  onTap: () {
                    if(widget.isWaitingForHost == false){
                      BlocProvider.of<LightningModeBloc>(context).add(StartGame());
                    }
                    // showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return GameSummaryModal(
                    //         onTap: () =>{},
                    //         pointsEarned: '230',
                    //         bonusPoint: '10',
                    //         noOfCorrectionQuestions: '10',
                    //         totalQuestions: '20',
                    //         averageTimePerQuestion: '5',
                    //       );
                    //     });
                  },
                  buttonText: widget.isWaitingForHost == false ?'Start Game':'Waiting for Host',
                  buttonIsLoading: false,
                  width: 280.w,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
