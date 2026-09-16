import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:bible_game/features/multi_player/widget/modal/players_waiting_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/multi_player/widget/sent_game_request_card.dart';

import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/features/multiplayer/cubit/websocket_cubit.dart';

void showGameRequestModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return GameRequestModal();
      });
}

class GameRequestModal extends StatefulWidget {
  const GameRequestModal({super.key});

  @override
  State<GameRequestModal> createState() => _GameRequestModalState();
}

class _GameRequestModalState extends State<GameRequestModal> {
  /// Which invite is waiting on a response. The bloc has one shared loading
  /// flag, so without this every card would spin when any one was actioned.
  String? _busyInviteId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<WebsocketCubit>().connect();
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
        child: BlocConsumer<MultiplayerBloc, MultiplayerState>(
          listener: (context, state) {
            // Release the card once the request settles, either way -- a
            // declined invite would otherwise spin until the modal was closed.
            if (_busyInviteId != null &&
                !state.isLoadingAcceptInvite &&
                !state.isLoadingRejectInvite) {
              setState(() => _busyInviteId = null);
            }
            // if(state.hasAcceptedInvite){
            //   Navigator.pop(context);
            //   showPlayersWaitingForHostModal(context,
            //       selectedGroupName: state.createGameRoomResponse.victoryCondition!.questionType!.toLowerCase() == "lightning"
            //       ?
            //       "lightning mode":"",
            //       inviteCode: state.createGameRoomResponse.inviteCode,
            //   );
            // }
            if(state.hasAcceptedInvite){
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
                    child: state.isFetchingListOfGameInvite &&
                            state.listOfInvite.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : state.listOfInvite.isEmpty
                            ? const _NoRequests()
                            // Scrolls: a Column overflowed once a few invites
                            // arrived, and the panel is a fixed 300h.
                            : ListView.builder(
                                padding: EdgeInsets.only(bottom: 12.h),
                                itemCount: state.listOfInvite.length,
                                itemBuilder: (context, index) {
                                  final invite = state.listOfInvite[index];
                                  final id = invite.id;
                                  return SentGameRequestCard(
                                    invite: invite,
                                    isBusy: id != null && id == _busyInviteId,
                                    onAccept: () {
                                      if (id == null) return;
                                      setState(() => _busyInviteId = id);
                                      context
                                          .read<MultiplayerBloc>()
                                          .add(AcceptAndJoin(id));
                                    },
                                    onReject: () {
                                      if (id == null) return;
                                      setState(() => _busyInviteId = id);
                                      context
                                          .read<MultiplayerBloc>()
                                          .add(Reject(id));
                                    },
                                  );
                                },
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

/// An empty panel previously just showed a blank white box.
class _NoRequests extends StatelessWidget {
  const _NoRequests();

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0A4B98);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58.w,
              height: 58.w,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2FC),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.mark_email_unread_outlined,
                  size: 28.sp, color: blue.withValues(alpha: 0.45)),
            ),
            SizedBox(height: 12.h),
            Text(
              'No game requests',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w900,
                color: blue,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Invites from other players will show up here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: blue.withValues(alpha: 0.6),
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
