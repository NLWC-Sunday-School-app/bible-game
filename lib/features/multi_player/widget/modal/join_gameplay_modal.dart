import 'package:another_flushbar/flushbar.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/multi_player/widget/modal/players_waiting_modal.dart';
import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/features/multiplayer/cubit/websocket_cubit.dart';
import '../../../../shared/widgets/blue_button.dart';
import '../../bloc/multiplayer_bloc.dart';

void showJoinGamePlayModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return JoinGamePlayModal();
      });
}

class JoinGamePlayModal extends StatefulWidget{
  JoinGamePlayModal({super.key});

  @override
  State<JoinGamePlayModal> createState() => _JoinGamePlayModalState();
}

class _JoinGamePlayModalState extends State<JoinGamePlayModal> {
  final textController = TextEditingController();
  String? savedInviteCode;

  @override
  void initState() {
    // TODO: implement initState
    context.read<WebsocketCubit>().connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      backgroundColor: Colors.transparent,
      insetAnimationCurve: Curves.bounceInOut,
      insetAnimationDuration: const Duration(milliseconds: 500),
      child: SizedBox(
        height: 400.h,
        child: Column(
          children: [
            Container(
              height: 64.h,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.joinModalTitleBg),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.white, width: 2.w),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF1E9DB5),
                    offset: Offset(1, 7),
                    blurRadius: 0,
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    ProductImageRoutes.joinSword,
                    width: 50.w,
                  ),
                  Text(
                    'Join gameplay',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF014CA3),
                        fontSize: 18.sp),
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
                  color: Color(0xFFF6FEFF),
                  border: Border(
                    left: BorderSide(width: 2.w, color: Color(0xFF1E9DB5)),
                    right: BorderSide(width: 2.w, color: Color(0xFF1E9DB5)),
                    bottom: BorderSide(width: 2.w, color: Color(0xFF1E9DB5)),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(16.r),
                    bottomLeft: Radius.circular(16.r),
                  ),
                ),
                child: BlocConsumer<MultiplayerBloc, MultiplayerState>(
                  listener: (context, state) {
                    if(state.hasJoinedRoom){
                      Navigator.pop(context);
                      context.read<WebsocketCubit>().subscribeToWaitingRoom();
                      showPlayersWaitingForHostModal(
                          context,
                          selectedGroupName: state.createGameRoomResponse.victoryCondition!.type == "LIGHTNING"
                              ?
                          "Lightning Mode"
                              :
                          state.createGameRoomResponse.victoryCondition!.type == "FIRST_TO_X"?
                          "First to X":
                          "",
                          inviteCode: state.createGameRoomResponse.inviteCode
                      );
                    }
                  },
                  builder: (context, state) {
                    if(state.isJoiningRoom){
                      return Center(child: CircularProgressIndicator(),);
                    }else{
                      return Column(
                        children: [
                          SizedBox(height: 20.h,),
                          Text(
                            'Input code to join gameplay',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 20.h,),
                          Container(
                            width: 255.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Color(0xFF1E9DB5)),
                              borderRadius: BorderRadius.circular(4.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                ),
                                BoxShadow(
                                  color: Color(0xFFC4F6FF),
                                  offset: Offset(0, 1),
                                  spreadRadius: 1.0,
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),
                            child: TextField(
                              textAlign: TextAlign.center,
                              controller: textController,
                              style: TextStyle(
                                  color: Color(0xFF014CA3),
                                  fontWeight: FontWeight.w900),
                              decoration: InputDecoration(
                                hintText: 'Type code here',
                                hintStyle:
                                TextStyle(color: Color(0xFF3ED0EB)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFF8E7DE), width: 0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10.r),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFF8E7DE), width: 0),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          BlueButton(
                            onTap: () {
                              validate(context);
                            },
                            buttonText: 'Join gameplay',
                            buttonIsLoading: false,
                            width: 250.w,
                          ),
                          SizedBox(height: 40.h,)
                        ],
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void validate(BuildContext context){
    if(textController.text.isEmpty){
      Flushbar(
        message: 'Fill up field',
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ).show(context);
    }else if(textController.text.length < 6 ){
      Flushbar(
        message: 'Invalid invite code',
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ).show(context);
    }else{
      //MOSA5A
      setState(() {
        savedInviteCode = textController.text;
      });
      BlocProvider.of<MultiplayerBloc>(context).add(JoinRoom(textController.text));
    }
  }
}
