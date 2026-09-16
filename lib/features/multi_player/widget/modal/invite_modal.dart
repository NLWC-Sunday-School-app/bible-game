import 'dart:async';
import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/multiplayer/cubit/websocket_cubit.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  /// Who has already been invited this session, so their row can say so
  /// instead of offering a second invite that the server would reject.
  final Set<String> _invited = {};

  /// The row currently waiting on a response. The bloc only carries a single
  /// isLoadingGameInvite flag, so without this every row would spin at once.
  String? _pendingInvite;

  /// Presence goes stale while the modal sits open -- people connect and drop
  /// while you are reading the list. Cancelled in dispose, so it cannot
  /// outlive the modal.
  Timer? _onlineRefreshTimer;

  static const _onlineRefreshInterval = Duration(seconds: 15);

  @override
  void initState() {
    super.initState();
    // Printed next to the fetch result so one line settles whether an empty
    // list means "nobody else is connected" or "we are not connected either".
    final ws = context.read<WebsocketCubit>();
    debugPrint('\u{1F50E} my socket: ${ws.state.connectionStatus} '
        '(isConnected: ${ws.isConnected})');
    context.read<MultiplayerBloc>().add(FetchOnlinePlayers());

    _onlineRefreshTimer = Timer.periodic(_onlineRefreshInterval, (_) {
      // Nothing to refresh behind the username tab, and a request in flight
      // would only race the one we are waiting on.
      if (!mounted || !_showOnline || _pendingInvite != null) return;
      context.read<MultiplayerBloc>().add(FetchOnlinePlayers());
    });
  }

  @override
  void dispose() {
    _onlineRefreshTimer?.cancel();
    textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      backgroundColor: Colors.transparent,
      // Dialog wraps its child in an AnimatedPadding driven by viewInsets.
      // The keyboard reports its inset frame by frame as it slides, so any
      // non-zero duration restarts an easing animation toward a target that
      // has already moved -- the modal ends up chasing the keyboard and
      // settling late. Zero makes it track the keyboard's own curve exactly.
      insetAnimationDuration: Duration.zero,
      child: SizedBox(
        height: 400.h,
        child: BlocListener<MultiplayerBloc, MultiplayerState>(
          // Both tabs invite through the same event, so the result is handled
          // here rather than inside either branch. Only react to the moment the
          // request finishes -- keying off hasInvitedUser alone would fire on
          // every unrelated emission, the online-players fetch included.
          listenWhen: (previous, current) =>
              previous.isLoadingGameInvite && !current.isLoadingGameInvite,
          listener: (context, state) {
            final invitee = _pendingInvite;
            setState(() {
              _pendingInvite = null;
              if (state.hasInvitedUser && invitee != null) _invited.add(invitee);
            });

            CustomToast.showInviteToast(context,
                isInviteSuccessful: state.hasInvitedUser);

            // The username tab is a one-shot, so closing is the right ending.
            // The online list is not -- you usually want to invite more than
            // one person, and the row now says "Invited" instead.
            if (state.hasInvitedUser && !_showOnline) Navigator.pop(context);
          },
          child: Column(
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
                  // Three Spacers against a 60w close button left the title a
                  // little off-centre. The close button still sets the header
                  // height; the title is now centred on the header itself.
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Image.asset(
                              IconImageRoutes.redCircleClose,
                              width: 60.w,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Add Friend',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF014CA3),
                          fontSize: 18.sp,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h),
                          _InviteTabs(
                            showOnline: _showOnline,
                            onChanged: (online) =>
                                setState(() => _showOnline = online),
                          ),
                          SizedBox(height: 12.h),
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              child: _showOnline
                                  ? _OnlinePlayersList(
                                      key: const ValueKey('online'),
                                      invited: _invited,
                                      pendingInvite: _pendingInvite,
                                      onInvite: (username) {
                                        setState(
                                            () => _pendingInvite = username);
                                        context.read<MultiplayerBloc>().add(
                                            GameInvites(
                                                username, widget.gameMode));
                                      },
                                    )
                                  : _ByUsernameForm(
                                      key: const ValueKey('username'),
                                      controller: textController,
                                      gameMode: widget.gameMode,
                                    ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      )
                  ),
                )
              ],
            ),
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
      // The selected pill slides between the two rather than blinking from one
      // to the other, so the eye follows the change instead of re-finding it.
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              alignment:
                  showOnline ? Alignment.centerLeft : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF014CA3),
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF014CA3).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              _tab('Online', showOnline, () => onChanged(true)),
              _tab('By username', !showOnline, () => onChanged(false)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tab(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: active ? Colors.white : const Color(0xFF014CA3),
            ),
            child: Text(label, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}

class _OnlinePlayersList extends StatelessWidget {
  const _OnlinePlayersList({
    super.key,
    required this.onInvite,
    required this.invited,
    required this.pendingInvite,
  });

  final ValueChanged<String> onInvite;
  final Set<String> invited;
  final String? pendingInvite;

  @override
  Widget build(BuildContext context) {
    // The endpoint returns everyone online, the signed-in user included. You
    // cannot invite yourself, so drop that row rather than showing a tap that
    // fails -- which is also why the empty copy below says "no one else".
    final currentUserId = context.read<AuthenticationBloc>().state.user.id;

    return BlocBuilder<MultiplayerBloc, MultiplayerState>(
      builder: (context, state) {
        final players = state.onlinePlayers
            .where((player) => player.userId != currentUserId)
            .toList();

        // Placeholder rows rather than a lone spinner: the list keeps its shape
        // while it loads, so arriving content does not shunt everything about.
        if (state.isFetchingOnlinePlayers && players.isEmpty) {
          return const _LoadingRows();
        }
        if (players.isEmpty) {
          return const _NoOneOnline();
        }
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: players.length,
          separatorBuilder: (_, __) => SizedBox(height: 8.h),
          itemBuilder: (context, index) {
            final player = players[index];
            final isInvited = invited.contains(player.username);
            final isPending = pendingInvite == player.username;
            final isTappable = !isInvited && pendingInvite == null;

            // Only the pill invites. Tapping the card did too, which made an
            // irreversible action reachable by a stray tap anywhere in the row.
            return AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: isTappable || isPending ? 1 : 0.55,
                child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFFF8E7DE), width: 2),
                ),
                child: Row(
                  children: [
                    // Seeded on the user id like every other avatar in the app,
                    // so a player looks the same here as on the leaderboard.
                    // profileUrl is no good as a seed: most accounts share one
                    // default placeholder URL, which gave them all one face.
                    AvatarWidget(
                        seed: player.userId.toString(),
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
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap:
                          isTappable ? () => onInvite(player.username) : null,
                      child: _InvitePill(
                          isInvited: isInvited, isPending: isPending),
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

/// The three states of an invite, in place, so the row itself answers "did
/// that work?" rather than leaving the toast to do it alone.
class _InvitePill extends StatelessWidget {
  const _InvitePill({required this.isInvited, required this.isPending});

  final bool isInvited;
  final bool isPending;

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF014CA3);

    if (isPending) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
        child: SizedBox(
          width: 16.w,
          height: 16.w,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(blue),
          ),
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isInvited ? Colors.transparent : blue,
        border: isInvited ? Border.all(color: blue, width: 1.5) : null,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isInvited) ...[
            Icon(Icons.check_rounded, size: 13.sp, color: blue),
            SizedBox(width: 3.w),
          ],
          Text(
            isInvited ? 'Invited' : 'Invite',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: isInvited ? blue : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// The typed-username fallback, as its own widget so both tabs are a single
/// child of the same Expanded. That is what keeps the tab row from moving:
/// previously the list filled the column and the form did not, so the column's
/// centring pulled the tabs down on this tab and not the other.
class _ByUsernameForm extends StatelessWidget {
  const _ByUsernameForm({
    super.key,
    required this.controller,
    required this.gameMode,
  });

  final TextEditingController controller;
  final String gameMode;

  static const _blue = Color(0xFF014CA3);

  void _send(BuildContext context) {
    final username = controller.text.trim();
    if (username.isEmpty) return;
    context.read<MultiplayerBloc>().add(GameInvites(username, gameMode));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Column(
        children: [
          SizedBox(height: 14.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Username',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: _blue.withValues(alpha: 0.65),
              ),
            ),
          ),
          SizedBox(height: 6.h),
          // Was a borderless field on a peach panel with a black26 shadow
          // bleeding out of it -- no edge to see, and the hint was the same
          // blue as typed text, so it read as a value rather than a prompt.
          TextField(
            controller: controller,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _send(context),
            style: TextStyle(
              color: _blue,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h),
              prefixIcon: Icon(Icons.alternate_email_rounded,
                  size: 17.sp, color: _blue.withValues(alpha: 0.45)),
              prefixIconConstraints: BoxConstraints(minWidth: 38.w),
              hintText: 'Enter their username',
              hintStyle: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: _blue.withValues(alpha: 0.38),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide:
                    const BorderSide(color: Color(0xFFE7CDBF), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: _blue, width: 2),
              ),
            ),
          ),
          SizedBox(height: 26.h),
          // Nothing to send until something is typed. A dimmed button says that
          // up front, rather than a request that comes back "user not found".
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              final canSend = value.text.trim().isNotEmpty;
              return BlocBuilder<MultiplayerBloc, MultiplayerState>(
                builder: (context, state) {
                  return BlueButton(
                    onTap: canSend ? () => _send(context) : null,
                    isActive: canSend,
                    buttonText: 'Send Invite',
                    buttonIsLoading: state.isLoadingGameInvite,
                    width: 280.w,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Skeleton rows matching the real ones, so the panel does not jump from an
/// empty box to a full list.
class _LoadingRows extends StatelessWidget {
  const _LoadingRows();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, __) => SizedBox(height: 8.h),
      itemBuilder: (_, index) => Opacity(
        // Fades down the list so it reads as loading rather than as content.
        opacity: 1 - (index * 0.28),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFF8E7DE), width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1DCD1),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Bar(width: 78.w, height: 10.h),
                    SizedBox(height: 5.h),
                    _Bar(width: 46.w, height: 8.h),
                  ],
                ),
              ),
              _Bar(width: 54.w, height: 24.h, radius: 14),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.width, required this.height, this.radius = 4});

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF1DCD1),
        borderRadius: BorderRadius.circular(radius.r),
      ),
    );
  }
}

/// Nobody to show. Says what to do next rather than only what is missing.
class _NoOneOnline extends StatelessWidget {
  const _NoOneOnline();

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF014CA3);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_search_rounded,
                  size: 28.sp, color: blue.withValues(alpha: 0.5)),
            ),
            SizedBox(height: 12.h),
            Text(
              'No one else is online',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: blue,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Try "By username" to invite someone directly.',
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
