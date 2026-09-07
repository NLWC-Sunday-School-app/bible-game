import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:bible_game/features/multi_player/widget/modal/players_waiting_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/multi_player/widget/sent_game_request_card.dart';

import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/utils/custom_toast.dart';
import '../../../../shared/widgets/blue_button.dart';

void showInviteModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return InviteModal();
      });
}

class InviteModal extends StatelessWidget {
  InviteModal({super.key});

  final textController = TextEditingController();


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

          },
          builder: (context, state) {
            return Column(
              children: [
                Container(
                  // height: 64.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          ProductImageRoutes.inviteBg),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
                      Spacer(),
                      Text(
                        'Add Friend',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF014CA3),
                          fontSize: 18.sp,
                        ),
                      ),
                      Spacer(),
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.w),
                  child: Container(
                      width: double.infinity,
                      height: 250.h,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFE7D9),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(16.r),
                          bottomLeft: Radius.circular(16.r),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Invite via username',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          SizedBox(
                            width: 255.w,
                            height: 50.h,
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                Border.all(color: Color(0xFFF8E7DE)),
                                borderRadius: BorderRadius.circular(4.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                  ),
                                  BoxShadow(
                                    color: Color(0xFFFEEDE4),
                                    offset: Offset(0, 1),
                                    spreadRadius: 1.0,
                                    blurRadius: 2.0,
                                  ),
                                ],
                              ),
                              child:
                              TextField(
                                textAlign: TextAlign.center,
                                controller: textController,
                                style: TextStyle(
                                    color: Color(0xFF014CA3),
                                    fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  hintText: 'username',
                                  hintStyle:
                                  TextStyle(color: Color(0xFF014CA3)),
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
                          ),
                          SizedBox(height: 32.h,),
                          BlocConsumer<MultiplayerBloc, MultiplayerState>(
                            listener: (context, state) {
                              // TODO: implement listener
                              if(state.hasInvitedUser){
                                Navigator.pop(context);
                                CustomToast.showInviteToast(context, isInviteSuccessful: true);
                              }else if(!state.hasInvitedUser && !state.isLoadingGameInvite){
                                CustomToast.showInviteToast(context, isInviteSuccessful: false);
                              }
                            },
                            builder: (context, state) {
                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: BlueButton(
                                  onTap: () {
                                    BlocProvider.of<MultiplayerBloc>(context).add(GameInvites(textController.text, "MULTIPLAYER_GROUP"));
                                  },
                                  buttonText: 'Send Invite',
                                  buttonIsLoading: state.isLoadingGameInvite,
                                  width: 280.w,
                                ),
                              );
                            },
                          ),
                        ],
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
