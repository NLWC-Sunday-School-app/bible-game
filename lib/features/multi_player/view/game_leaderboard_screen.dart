import 'package:bible_game_api/bible_game_api.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/features/multi_player/widget/modal/players_waiting_modal.dart';
import 'package:bible_game/features/multi_player/widget/multiplayer_leaderboard_card.dart';
import 'package:bible_game/shared/features/multiplayer/cubit/websocket_cubit.dart';
import 'package:bible_game/shared/widgets/multi_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stroke_text/stroke_text.dart';
import '../../../shared/constants/app_routes.dart';
import '../../../shared/constants/image_routes.dart';
import '../../../shared/utils/country_iso_3.dart';
import '../../lightning_mode/bloc/lightning_mode_bloc.dart';

class GameLeaderboardScreen extends StatefulWidget {
  const GameLeaderboardScreen({super.key, required this.selectedGroupGame});
  final String selectedGroupGame;

  @override
  State<GameLeaderboardScreen> createState() => _GameLeaderboardScreenState();
}

class _GameLeaderboardScreenState extends State<GameLeaderboardScreen> {

  /// The finished game's result, taken once when this screen opens.
  ///
  /// It is a snapshot of something that has already happened, so it does not
  /// belong to live socket state: a later frame replacing gameFinishedEvent
  /// used to pull the data out from under a screen still rendering it.
  GameFinishedData? _result;

  @override
  void initState() {
    super.initState();
    _result = context.read<WebsocketCubit>().state.gameFinishedEvent.data;
  }

  /// Whether the signed-in player is the one who opened this room.
  ///
  /// Read off the room itself rather than Player.isHost on the waiting-room
  /// roster: that list is filled only by join and leave frames, so by the time
  /// a game has finished it may hold no row for anyone. hostId is set when the
  /// room is created and comes back on join, so both sides of the room agree.
  bool _isHost(BuildContext context) {
    final hostId =
        context.read<MultiplayerBloc>().state.createGameRoomResponse.hostId;
    if (hostId == null || hostId.trim().isEmpty) return false;
    final userId = context.read<AuthenticationBloc>().state.user.id;
    return hostId.trim() == userId.toString();
  }

  @override
  Widget build(BuildContext context) {
    // Written as an overlay on the game, but showLeaderboardModal pushes it as
    // an opaque fullscreen route -- so the original 80% black sat over nothing
    // and rendered as flat black. Carry the question screen's own backdrop
    // through unmodified: no scrim, because the game screen has none either
    // and any darkening reads as a different screen rather than a continuation.
    // The cards supply their own contrast.
    return Scaffold(
      backgroundColor: const Color(0xFF998BBC),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ProductImageRoutes.questionScreenBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 30.h),
          child: Stack(
            children: [
              Builder(
                builder: (context) {
                  // Twelve `gameFinishedEvent.data!` used to read live socket
                  // state here. Restarting the round replaced that event, and
                  // every one of them threw on the next rebuild -- which is
                  // exactly what "Play another round" did.
                  final result = _result;
                  if (result == null || result.leaderboard.isEmpty) {
                    return const SizedBox.shrink();
                  }
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
                                    child: AvatarWidget(seed: result.leaderboard[0].userId!, width: 40.w, height: 40.h,),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: StrokeText(
                                        text: result.leaderboard[0].username ?? "",
                                        textStyle: TextStyle(
                                          color: Color(0xFF0D468A),
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                        strokeColor: Color(0xFFF4FFCE),
                                        strokeWidth: 4,
                                      ),
                                    ),
                                    SizedBox(
                                      width:5.w,
                                    ),
                                    result.leaderboard[0].country!= null
                                        ? SvgPicture.asset(
                                      'assets/images/flags/${result.leaderboard[0].country!.replaceAll('/', ' ').toLowerCase()}.svg',
                                      width: 16.w,
                                    )
                                        : SizedBox(
                                      width: 16.w,
                                    ),
                                    SizedBox(
                                      width:2.w,
                                    ),
                                    Text(
                                      result.leaderboard[0].country != null
                                          ? getIso3Code(result.leaderboard[0].country!.replaceAll('/', ' '))
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
                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                    // Finishing a game leaves the room, not the
                                    // session -- the connection is what makes
                                    // the user visible to others as online.
                                    context.read<WebsocketCubit>().clearCurrentRoom();
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
                              itemCount: result.leaderboard.length,
                              itemBuilder: (BuildContext context, int index){
                                return MultiplayerLeaderboardCard(
                                    position: (index+1),
                                    userName: result.leaderboard[index].username ??"",
                                    countryName: result.leaderboard[index].country??"Nigeria",
                                    userRank:result.leaderboard[index].level ?? "child",
                                    noOfCoins: result.leaderboard[index].score ??0,
                                    userId:result.leaderboard[index].userId
                                );
                              }
                          )
                      ),
                    ],
                  );
                  },
              ),
              BlocListener<WebsocketCubit, WebsocketState>(
                listener: (context, state){
                  if (state.eventType != "GAME_RESTARTED" ||
                      !state.newPlayerJoined) {
                    return;
                  }

                  // Everything below used to run on this screen's own context
                  // *after* popUntil had removed its route -- pushing a route
                  // and opening a dialog through a widget that had just been
                  // deactivated. Read what is needed and take the navigator
                  // first, then pop, then drive that navigator directly.
                  final navigator = Navigator.of(context);
                  final inviteCode = context
                          .read<MultiplayerBloc>()
                          .state
                          .createGameRoomResponse
                          .inviteCode ??
                      '';
                  final hosting = _isHost(context);

                  navigator.popUntil((route) => route.isFirst);
                  navigator.pushNamed(
                    AppRoutes.multiplayer,
                    arguments: {'selectedCategory': "Group Game"},
                  );

                  // A restart puts everyone back in the waiting room, but only
                  // one of them is the host. Showing the host's modal to all
                  // of them handed guests an Invite button, a live Start Game
                  // and a kick control on everyone else's row.
                  if (hosting) {
                    showHostWaitingModal(
                      navigator.context,
                      selectedGroupGame: widget.selectedGroupGame,
                      inviteCode: inviteCode,
                      // The room carries a game mode, not a question type, and
                      // passing one as the other only dressed it up as an
                      // answer. Null lets the waiting room fall back honestly.
                      questionType: null,
                      noOfQuestion: null,
                    );
                  } else {
                    showPlayersWaitingForHostModal(
                      navigator.context,
                      selectedGroupName: widget.selectedGroupGame,
                      inviteCode: inviteCode,
                    );
                  }

                  // No toast. This fired showInviteToast, whose success copy
                  // reads "Invite Sent Successfully! / Your Friend has been
                  // sent a Game Invite" -- nobody was invited; a round was
                  // restarted, and the waiting room says that by appearing.
                },
                child: const SizedBox.shrink(),
              ),
              BlocConsumer<LightningModeBloc, LightningModeState>(
                listener: (context, state){
                },
                builder: (context, state) {
                  // Restarting is the host's call: it pulls every player out
                  // of the leaderboard and back into the waiting room. Offered
                  // to everyone, a guest either hijacked the room or got a
                  // button that spun and silently failed, depending on whether
                  // the server accepted a restart from a non-host. Guests keep
                  // the close button in the header to leave.
                  if (!_isHost(context)) return const SizedBox.shrink();

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
      ),
    );
  }
}
