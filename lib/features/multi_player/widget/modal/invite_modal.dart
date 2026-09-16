import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:bible_game/features/multi_player/widget/modal/players_waiting_modal.dart';
import 'package:bible_game/shared/features/multiplayer/cubit/websocket_cubit.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/multi_player/widget/sent_game_request_card.dart';

import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/utils/custom_toast.dart';
import '../../../../shared/widgets/blue_button.dart';
import '../../../../shared/widgets/multi_avatar.dart';

void showInviteModal(BuildContext context, {required String gameMode}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return InviteModal(gameMode: gameMode);
      });
}

class InviteModal extends StatefulWidget {
  const InviteModal({super.key, required this.gameMode});

  /// Already an API code -- see gameModeCode(). Invites used to hardcode
  /// MULTIPLAYER_GROUP for every mode, which is why the push notification
  /// always read "multiplayer group game" whatever you were playing.
  final String gameMode;

  @override
  State<InviteModal> createState() => _InviteModalState();
}

class _InviteModalState extends State<InviteModal> {
  final textController = TextEditingController();

  /// Online first: tapping a name is the point of this screen, and typing a
  /// username you already know is the fallback.
  bool _showOnline = true;

  @override
  void initState() {
    super.initState();
    // Printed next to the fetch result so one line settles whether an empty
    // list means "nobody else is connected" or "we are not connected either".
    final ws = context.read<WebsocketCubit>();
    debugPrint('\u{1F50E} my socket: ${ws.state.connectionStatus} '
        '(isConnected: ${ws.isConnected})');
    context.read<MultiplayerBloc>().add(FetchOnlinePlayers());
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      backgroundColor: Colors.transparent,
      // Runs on every inset change, so a bouncing curve makes the modal
      // spring about whenever the keyboard opens.
      insetAnimationCurve: Curves.easeOut,
      insetAnimationDuration: const Duration(milliseconds: 220),
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
                          SizedBox(height: 10.h),
                          _InviteTabs(
                            showOnline: _showOnline,
                            onChanged: (online) =>
                                setState(() => _showOnline = online),
                          ),
                          SizedBox(height: 12.h),
                          if (_showOnline) ...[
                            Expanded(
                              child: _OnlinePlayersList(
                                onInvite: (username) {
                                  BlocProvider.of<MultiplayerBloc>(context)
                                      .add(GameInvites(
                                          username, widget.gameMode));
                                },
                              ),
                            ),
                            SizedBox(height: 10.h),
                          ] else ...[
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
                                    BlocProvider.of<MultiplayerBloc>(context).add(GameInvites(textController.text, widget.gameMode));
                                  },
                                  buttonText: 'Send Invite',
                                  buttonIsLoading: state.isLoadingGameInvite,
                                  width: 280.w,
                                ),
                              );
                            },
                          ),
                          ],
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


/// Online / By username. Online leads, because tapping a name is the point --
/// typing one you already know is the fallback for someone not currently on.
class _InviteTabs extends StatelessWidget {
  const _InviteTabs({required this.showOnline, required this.onChanged});

  final bool showOnline;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8E7DE),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          _tab(context, 'Online', showOnline, () => onChanged(true)),
          _tab(context, 'By username', !showOnline, () => onChanged(false)),
        ],
      ),
    );
  }

  Widget _tab(BuildContext context, String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF014CA3) : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: active ? Colors.white : const Color(0xFF014CA3),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnlinePlayersList extends StatelessWidget {
  const _OnlinePlayersList({required this.onInvite});

  final ValueChanged<String> onInvite;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MultiplayerBloc, MultiplayerState>(
      builder: (context, state) {
        if (state.isFetchingOnlinePlayers && state.onlinePlayers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.onlinePlayers.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'No one else is online right now.\nInvite by username instead.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF014CA3).withValues(alpha: 0.7),
                ),
              ),
            ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: state.onlinePlayers.length,
          separatorBuilder: (_, __) => SizedBox(height: 8.h),
          itemBuilder: (context, index) {
            final player = state.onlinePlayers[index];
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: state.isLoadingGameInvite
                  ? null
                  : () => onInvite(player.username),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFFF8E7DE), width: 2),
                ),
                child: Row(
                  children: [
                    AvatarWidget(
                        seed: player.profileUrl.isNotEmpty
                            ? player.profileUrl
                            : player.username,
                        width: 34.w,
                        height: 34.w),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            player.username,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF014CA3),
                            ),
                          ),
                          if (player.country.isNotEmpty)
                            Text(
                              player.country,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withValues(alpha: 0.45),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF014CA3),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Text(
                        'Invite',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
