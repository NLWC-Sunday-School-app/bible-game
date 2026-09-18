import 'dart:async';

import 'package:bible_game/features/multi_player/game_mode_codes.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:bible_game/features/multi_player/widget/modal/invite_modal.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/multiplayer/cubit/websocket_cubit.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/multi_player/widget/player_waiting_card.dart';
import '../../../../shared/constants/app_routes.dart';
import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/utils/custom_toast.dart';
import '../../../../shared/widgets/modal/network_modal.dart';
import '../../../lightning_mode/bloc/lightning_mode_bloc.dart';
import '../multiplayer_button.dart';

void showHostWaitingModal(BuildContext context, {required selectedGroupGame, required inviteCode, required questionType, required noOfQuestion}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return PlayersWaitingModal(
          isWaitingForHost: false,
          selectedGroupGame: selectedGroupGame,
          inviteCode: inviteCode,
          questionType: questionType,
          noOfQuestion: noOfQuestion,
        );
      });
}

void showPlayersWaitingForHostModal(BuildContext context, {required selectedGroupName, required inviteCode}) {

  //4DW7FP
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return PlayersWaitingModal(
          isWaitingForHost: true,
          selectedGroupGame: selectedGroupName,
          inviteCode: inviteCode,
          questionType: null,
          noOfQuestion: null,
        );
      });
}

class PlayersWaitingModal extends StatefulWidget {
  const PlayersWaitingModal({super.key, required this.isWaitingForHost, required this.selectedGroupGame, required this.inviteCode, required this.questionType, this.noOfQuestion});

  final bool isWaitingForHost;
  final String selectedGroupGame;
  final String? questionType;
  final String inviteCode;
  final int? noOfQuestion;

  @override
  State<PlayersWaitingModal> createState() => _PlayersWaitingModalState();
}

class _PlayersWaitingModalState extends State<PlayersWaitingModal> {
  WebsocketConnectionStatus _lastConnectionStatus = WebsocketConnectionStatus.disconnected;

  /// Presence for the invite button's count. The invite modal polls this too,
  /// but the count has to be on the button *before* it is tapped -- that is
  /// what makes it worth tapping.
  Timer? _onlineRefreshTimer;

  /// The invite modal runs its own 15s poll while it is open, so this one
  /// stands down rather than doubling the requests.
  bool _inviteModalOpen = false;

  /// Set once this room has routed into the game. One GAME_STARTED frame
  /// produces several emissions, all reading eventType GAME_STARTED, and each
  /// one ran the routing below: popped the top route, pushed the loading
  /// screen and showed "Game has started" again. Shown in the same frame, the
  /// toasts orphaned one another and sat invisibly over the screen for good.
  bool _routedIntoGame = false;

  static const _onlineRefreshInterval = Duration(seconds: 20);

  @override
  void initState() {
    super.initState();
    // Guests have no invite button, so nothing here to feed.
    if (widget.isWaitingForHost) return;
    context.read<MultiplayerBloc>().add(FetchOnlinePlayers());
    _onlineRefreshTimer = Timer.periodic(_onlineRefreshInterval, (_) {
      if (!mounted || _inviteModalOpen) return;
      context.read<MultiplayerBloc>().add(FetchOnlinePlayers());
    });
  }

  @override
  void dispose() {
    _onlineRefreshTimer?.cancel();
    super.dispose();
  }

  /// Everyone connected but you -- the endpoint includes the signed-in user,
  /// and you cannot invite yourself, so counting yourself would promise a row
  /// the invite list does not show.
  ///
  /// Reads the page's total rather than its length. The endpoint pages at 20,
  /// so counting the loaded list showed "19 online" from the twentieth
  /// concurrent player onwards, however many were really there.
  int _onlineCount(BuildContext context) {
    final total = context.watch<MultiplayerBloc>().state.onlinePlayersTotal;
    return total > 0 ? total - 1 : 0;
  }

  Future<void> _openInviteModal(String? roomGameMode) async {
    setState(() => _inviteModalOpen = true);
    await showInviteModal(
      context,
      gameMode: gameModeCode(
        widget.selectedGroupGame.isNotEmpty
            ? widget.selectedGroupGame
            : roomGameMode,
      ),
    );
    if (!mounted) return;
    setState(() => _inviteModalOpen = false);
    // Whoever was listed is 20s stale by now, and someone may have just been
    // invited out of the list.
    context.read<MultiplayerBloc>().add(FetchOnlinePlayers());
  }

  /// The four modes differ only by icon and label, which a lookup says more
  /// plainly than the chain of conditionals this replaced.
  Widget _modeHeader() {
    final String asset;
    final String label;
    switch (widget.selectedGroupGame) {
      case 'Lightning Mode':
        asset = ProductImageRoutes.lightningMode;
        label = 'Lightning Mode';
        break;
      case 'Time-based Mode':
        asset = ProductImageRoutes.timeBasedMode;
        label = 'Time-Based Mode';
        break;
      case 'First to X':
        asset = ProductImageRoutes.xMode;
        label = 'First to X Mode';
        break;
      default:
        asset = ProductImageRoutes.survivalMode;
        label = 'Survival Mode';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(asset, height: 34.h, width: 34.w),
        SizedBox(width: 5.w),
        Text(
          label,
          style: TextStyle(
              color: Color(0xFF014CA3),
              fontWeight: FontWeight.w700,
              fontSize: 16.sp),
        ),
      ],
    );
  }

  /// The settings the host picked seconds ago, on one line. They were a
  /// two-column block taking a third of the card to confirm a choice already
  /// made -- worth a glance, not the space.
  String _gameSummary(BuildContext context) {
    final parts = <String>[];

    final type = widget.questionType ??
        context.watch<WebsocketCubit>().state.waitingRoomInfo.gameMode;
    if (type != null && type.isNotEmpty) parts.add(type);

    if (widget.selectedGroupGame == 'Time-based Mode' ||
        widget.selectedGroupGame == 'Survival Mode') {
      parts.add('10 minutes');
    } else if (widget.selectedGroupGame == 'First to X') {
      final target = widget.noOfQuestion ??
          context
              .read<MultiplayerBloc>()
              .state
              .createGameRoomResponse
              .victoryCondition
              ?.value;
      parts.add('target ${target ?? 'N/A'}');
    } else {
      final count = widget.noOfQuestion ??
          context.watch<WebsocketCubit>().state.waitingRoomInfo.totalQuestions;
      if (count != null) parts.add('$count questions');
    }

    return parts.join('  ·  ');
  }

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
                    ),
                    // The glow used to be a screen-level Positioned sized to a
                    // card that filled half the screen. Now that the card is
                    // short it belongs inside it, clipped -- otherwise the
                    // bokeh spills onto the players panel below.
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 4,
                            left: 0,
                            right: 0,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Image.asset(
                                ProductImageRoutes.glowIcon,
                                fit: BoxFit.contain,
                                width: 273.w,
                                height: 130.h,
                              ),
                            ),
                          ),
                          Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: (){
                              if(widget.isWaitingForHost){
                                // Leave the room, keep the session. The server
                                // derives presence from live connections, so
                                // closing the socket here dropped the user off
                                // the online players list the moment they left
                                // a waiting room.
                                context.read<WebsocketCubit>().clearCurrentRoom();
                                final userId = context.read<AuthenticationBloc>().state.user.id.toString();
                                print(userId);
                                final player = context.read<WebsocketCubit>().state.waitingRoomInfo.players.firstWhereOrNull((element) => element.userId == userId);
                                print(player);
                                if (player?.id != null) {
                                  // print("wemoved");
                                  BlocProvider.of<MultiplayerBloc>(context).add(LeaveRoom(player!.id!));
                                }
                              }else{
                                final hostPlayerId = BlocProvider.of<MultiplayerBloc>(context).state.createGameRoomResponse.activePlayers[0];
                                print(hostPlayerId);
                                BlocProvider.of<MultiplayerBloc>(context).add(LeaveRoom(hostPlayerId));
                                BlocProvider.of<MultiplayerBloc>(context).add(CreateGameRoom());
                              }
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              IconImageRoutes.redCircleClose,
                              width: 40.w,
                            ),
                          ),
                        ),
                        _modeHeader(),
                        SizedBox(height: 6.h,),
                        Text(
                          _gameSummary(context),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withValues(alpha: 0.55),
                          ),
                        ),
                        SizedBox(height: 18.h,),
                        _ShareCodeRow(inviteCode: widget.inviteCode),
                        SizedBox(height: 16.h,),
                      ],
                    ),
                        ],
                      ),
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
                            // ========== CONNECTION STATUS MONITORING ==========
                            if(state.connectionStatus == WebsocketConnectionStatus.disconnected &&
                                _lastConnectionStatus == WebsocketConnectionStatus.connected) {
                              CustomToast.showStatus(context, "Connection lost. Reconnecting...",
                                  duration: Duration(seconds: 6));
                            }
                            if(state.connectionStatus == WebsocketConnectionStatus.connected &&
                                _lastConnectionStatus == WebsocketConnectionStatus.disconnected) {
                              CustomToast.showStatus(context, "Connection restored",
                                  duration: Duration(seconds: 2));
                            }
                            if(state.connectionStatus == WebsocketConnectionStatus.error) {
                              showNetworkModal(context, onRetry: () {
                                context.read<WebsocketCubit>().connect();
                              });
                            }
                            _lastConnectionStatus = state.connectionStatus;

                            if(state.eventType == "GAME_STARTED" &&
                                !_routedIntoGame){
                              _routedIntoGame = true;
                              // questionLoadingScreen shows the multiplayer Quick
                              // Tips and then routes to the mode's own screen.
                              // It matches on the display name, so fall back to
                              // the room's gameMode and normalise the server's
                              // enum -- the join modal passes an empty string
                              // when victoryCondition.type is neither LIGHTNING
                              // nor FIRST_TO_X, which would otherwise fall
                              // through to the Global Challenge branch.
                              var mode = widget.selectedGroupGame.isNotEmpty
                                  ? widget.selectedGroupGame
                                  : (state.waitingRoomInfo.gameMode ?? '');
                              if (mode == "LIGHTNING") mode = "Lightning Mode";
                              if (mode == "FIRST_TO_X") mode = "First to X";
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                  context,
                                  AppRoutes.questionLoadingScreen,
                                  arguments: {'gameType': mode});
                              CustomToast.showInviteToast(
                                  context,
                                  message: "Game has started",
                                  isInviteSuccessful: true
                              );
                            }
                            // Only while this sheet is on top. It stays mounted
                            // under the game, where every answer pulses
                            // newPlayerJoined and replayed the last join message
                            // over the round -- the game screen shows joins and
                            // leaves itself now.
                            if(state.newPlayerJoined == true &&
                                (ModalRoute.of(context)?.isCurrent ?? true)){
                              // Null for your own join -- the server writes this
                              // text for the *other* players -- and interpolating
                              // it into a string turned null into a toast reading
                              // "null". Nothing to say means no toast.
                              final joinMessage =
                                  state.waitingRoomInfo.toastNotificationMessage;
                              if (joinMessage != null &&
                                  joinMessage.trim().isNotEmpty) {
                                CustomToast.show(
                                    context,
                                    joinMessage,
                                    isTriggerFromWaitingRoom: true
                                );
                              }
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
                                Flexible(
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () => _openInviteModal(
                                            state.waitingRoomInfo.gameMode),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              height: 31.h,
                                              width: 31.w,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  // Was 0xFFD9D9D9 -- the grey
                                                  // the app uses for inert
                                                  // chrome, which read as a
                                                  // disabled control next to
                                                  // everything else in blue.
                                                  color: Color(0xFF014CA3),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.person_add_alt_1_rounded,
                                                  size: 16.sp,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 6.w,),
                                            Text(
                                              'Invite',
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF014CA3),
                                              ),
                                            ),
                                            if (_onlineCount(context) > 0) ...[
                                              SizedBox(width: 6.w,),
                                              Flexible(
                                                child: _OnlineChip(
                                                    count: _onlineCount(context)),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ):SizedBox.shrink(),
                                    Text(
                                      'No of Players: ${state.waitingRoomInfo.totalPlayers??0}',
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
                                child: state.waitingRoomInfo.players.isEmpty
                                    ? _EmptyRoom(
                                        isWaitingForHost:
                                            widget.isWaitingForHost,
                                        onlineCount: _onlineCount(context),
                                        onInvite: () => _openInviteModal(
                                            state.waitingRoomInfo.gameMode),
                                      )
                                    : ListView.builder(
                                        // Clear of the Start Game button, which
                                        // floats over the bottom of this panel.
                                        padding: EdgeInsets.only(bottom: 80.h),
                                        itemCount: state.waitingRoomInfo.players.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return PlayerWaitingCard(
                                            onTap: (){
                                              BlocProvider.of<MultiplayerBloc>(context).add(
                                                  KickOut(state.waitingRoomInfo.players[index].id!)
                                              );
                                            },
                                            position: index+1,
                                            userName: state.waitingRoomInfo.players[index].username??"",
                                            countryName: state.waitingRoomInfo.players[index].country??"N",
                                            userRank: state.waitingRoomInfo.players[index].level??"",
                                            userId: state.waitingRoomInfo.players[index].userId??"",
                                            isWaitingForHost: widget.isWaitingForHost,
                                            isHost:state.waitingRoomInfo.players[index].isHost??false,
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
                child: BlocBuilder<WebsocketCubit, WebsocketState>(
                  builder: (context, state) {
                    return MultiplayerButton(
                      onTap: () {
                        if(widget.isWaitingForHost == false){
                          BlocProvider.of<LightningModeBloc>(context).add(StartGame());
                        }
                      },
                      buttonText: widget.isWaitingForHost == false ?' Start Game':'Waiting for Host',
                      isActive: state.waitingRoomInfo.players.length <=0?false:widget.isWaitingForHost == false?true:false,
                      buttonIsLoading: false,
                      width: 280.w,
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The code, demoted. Sharing it is the slow path -- leave the app, pick a
/// channel, and the other person still has to open the app, find "join with
/// code" and type eight characters -- so it no longer outweighs the invite
/// button, which reaches people who are already connected.
class _ShareCodeRow extends StatelessWidget {
  const _ShareCodeRow({required this.inviteCode});

  final String inviteCode;

  static const _blue = Color(0xFF014CA3);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // The whole row copies now. The icon was the only target before, which
      // is a 24px hit area for the one thing this row exists to do.
      onTap: () {
        Clipboard.setData(ClipboardData(text: inviteCode));
        CustomToast.showBanner(context, 'Copied');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFD8B98C)),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Or share code',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              inviteCode,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                color: _blue,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(Icons.copy_rounded,
                size: 15.sp, color: _blue.withValues(alpha: 0.7)),
          ],
        ),
      ),
    );
  }
}

/// How many people the invite list would show. A bare "Invite" promises
/// nothing; a number is the reason to tap.
class _OnlineChip extends StatelessWidget {
  const _OnlineChip({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: Color(0xFF1DB954).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF19A44B),
            ),
          ),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              '$count online',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xFF14803A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// An empty room is where the host actually looks, so it carries the ask
/// rather than narrating the problem. "Waiting for players" described the
/// situation and offered no way out of it.
class _EmptyRoom extends StatelessWidget {
  const _EmptyRoom({
    required this.isWaitingForHost,
    required this.onlineCount,
    required this.onInvite,
  });

  final bool isWaitingForHost;
  final int onlineCount;
  final VoidCallback onInvite;

  static const _blue = Color(0xFF014CA3);

  @override
  Widget build(BuildContext context) {
    // A guest has no invite button, so there is nothing to ask them for.
    if (isWaitingForHost) {
      return Center(
        child: Text(
          'Waiting for players',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xFF122F52),
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        // Clear of the Start Game button floating over the bottom of the panel.
        padding: EdgeInsets.only(left: 28.w, right: 28.w, bottom: 60.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No one here yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: Color(0xFF122F52),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              onlineCount > 0
                  ? 'Invite someone who is online right now, or share the code above.'
                  : 'Invite a friend by username, or share the code above.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                height: 1.4,
                color: Color(0xFF122F52).withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 18.h),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onInvite,
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: _blue,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: _blue.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_add_alt_1_rounded,
                        size: 16.sp, color: Colors.white),
                    SizedBox(width: 8.w),
                    Text(
                      onlineCount > 0
                          ? 'Invite  ·  $onlineCount online'
                          : 'Invite players',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
