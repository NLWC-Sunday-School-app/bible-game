import 'dart:async';
import 'package:bible_game_api/bible_game_api.dart';
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
import '../../../../shared/widgets/multi_avatar.dart';

/// Returns when the modal closes, so a caller can refresh presence it was
/// showing behind the modal.
Future<void> showInviteModal(BuildContext context, {required String gameMode}) {
  return showDialog(
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

  /// Waits for a pause in typing before asking the server. Without it every
  /// keystroke is a request, and the answers race each other back.
  Timer? _searchDebounce;

  static const _onlineRefreshInterval = Duration(seconds: 15);
  static const _searchDebounceDelay = Duration(milliseconds: 300);

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
    _searchDebounce?.cancel();
    textController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    // Clearing the field should empty the results at once -- waiting 300ms to
    // drop them leaves stale names under an empty box.
    if (query.trim().isEmpty) {
      context.read<MultiplayerBloc>().add(SearchOnlinePlayers(''));
      setState(() {});
      return;
    }
    // Rebuild now so the field's clear button and the stale-results check see
    // the new text before the request goes out.
    setState(() {});
    _searchDebounce = Timer(_searchDebounceDelay, () {
      if (!mounted) return;
      context.read<MultiplayerBloc>().add(SearchOnlinePlayers(query));
    });
  }

  void _invite(String username) {
    setState(() => _pendingInvite = username);
    context.read<MultiplayerBloc>().add(GameInvites(username, widget.gameMode));
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
            // "already been sent" means the row is, in fact, invited -- so mark
            // it as such rather than leaving a button that will fail again.
            final alreadyInvited = !state.hasInvitedUser &&
                state.gameInviteError.toLowerCase().contains('already been sent');
            setState(() {
              _pendingInvite = null;
              if ((state.hasInvitedUser || alreadyInvited) && invitee != null) {
                _invited.add(invitee);
              }
            });

            CustomToast.showInviteToast(
              context,
              isInviteSuccessful: state.hasInvitedUser,
              // Say why. Re-inviting someone came back as a bare "ERROR!",
              // where the server had actually explained itself.
              message: state.hasInvitedUser || state.gameInviteError.isEmpty
                  ? null
                  : state.gameInviteError,
              duration: state.hasInvitedUser
                  ? const Duration(seconds: 2)
                  : const Duration(seconds: 4),
            );

            // Neither tab closes on success now. The username tab used to,
            // back when it was one blind field and one send -- but it lists
            // matches too, and closing the modal under someone about to invite
            // a second name is the wrong ending. Both tabs say "Invited".
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
                                      onInvite: _invite,
                                    )
                                  : _ByUsernameForm(
                                      key: const ValueKey('username'),
                                      controller: textController,
                                      invited: _invited,
                                      pendingInvite: _pendingInvite,
                                      onQueryChanged: _onSearchChanged,
                                      onInvite: _invite,
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
            return _PlayerRow(
              player: player,
              isInvited: invited.contains(player.username),
              isPending: pendingInvite == player.username,
              anyPending: pendingInvite != null,
              onInvite: onInvite,
            );
          },
        );
      },
    );
  }
}

/// One invitable player. Shared by the browse list and the search results so
/// a name looks and behaves the same whichever way you arrived at it.
class _PlayerRow extends StatelessWidget {
  const _PlayerRow({
    required this.player,
    required this.isInvited,
    required this.isPending,
    required this.anyPending,
    required this.onInvite,
  });

  final OnlinePlayer player;
  final bool isInvited;
  final bool isPending;
  final bool anyPending;
  final ValueChanged<String> onInvite;

  @override
  Widget build(BuildContext context) {
    final isTappable = !isInvited && !anyPending;

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
                seed: player.userId.toString(), width: 34.w, height: 34.w),
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
              onTap: isTappable ? () => onInvite(player.username) : null,
              child: _InvitePill(isInvited: isInvited, isPending: isPending),
            ),
          ],
        ),
      ),
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

/// Find-a-player-by-name, as its own widget so both tabs are a single child of
/// the same Expanded. That is what keeps the tab row from moving: previously
/// the list filled the column and the form did not, so the column's centring
/// pulled the tabs down on this tab and not the other.
///
/// The field searches as you type. It used to be a blind text box whose only
/// feedback was the invite coming back "user not found" -- you had to know the
/// username exactly, and a typo cost a round trip to find out.
///
/// The endpoint only searches players who are ONLINE, so a friend who is not
/// connected will never appear here however carefully you spell them. That is
/// why the typed name stays sendable: no match is a reason to offer the invite
/// anyway, not to block it.
class _ByUsernameForm extends StatelessWidget {
  const _ByUsernameForm({
    super.key,
    required this.controller,
    required this.invited,
    required this.pendingInvite,
    required this.onQueryChanged,
    required this.onInvite,
  });

  final TextEditingController controller;
  final Set<String> invited;
  final String? pendingInvite;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onInvite;

  static const _blue = Color(0xFF014CA3);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          // Was a borderless field on a peach panel with a black26 shadow
          // bleeding out of it -- no edge to see, and the hint was the same
          // blue as typed text, so it read as a value rather than a prompt.
          child: TextField(
            controller: controller,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.search,
            onChanged: onQueryChanged,
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
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
              prefixIcon: Icon(Icons.search_rounded,
                  size: 18.sp, color: _blue.withValues(alpha: 0.45)),
              prefixIconConstraints: BoxConstraints(minWidth: 38.w),
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, _) {
                  if (value.text.isEmpty) return const SizedBox.shrink();
                  return GestureDetector(
                    onTap: () {
                      controller.clear();
                      onQueryChanged('');
                    },
                    child: Icon(Icons.close_rounded,
                        size: 17.sp, color: _blue.withValues(alpha: 0.45)),
                  );
                },
              ),
              suffixIconConstraints: BoxConstraints(minWidth: 34.w),
              hintText: 'Search by username',
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
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: BlocBuilder<MultiplayerBloc, MultiplayerState>(
            builder: (context, state) {
              final typed = controller.text.trim();
              if (typed.isEmpty) return const _SearchPrompt();

              // The results belong to whatever was last typed; while the
              // debounce is still pending they are for an older prefix, so
              // treat that gap as loading rather than as an answer.
              final isStale = state.playerSearchQuery != typed;
              if (state.isSearchingPlayers || isStale) {
                return const _LoadingRows();
              }

              // Searching your own name matches you -- the endpoint does not
              // exclude the caller, and the browse list's filter does not
              // reach here. Without this, "tobi" offers Tobi1 an Invite
              // button that the server will only reject.
              final currentUserId =
                  context.read<AuthenticationBloc>().state.user.id;
              final results = state.playerSearchResults
                  .where((player) => player.userId != currentUserId)
                  .toList();

              if (results.isEmpty) {
                return _NoSearchMatch(
                  query: typed,
                  // Offering "invite anyway" on your own name would send an
                  // invite to yourself, which only comes back an error.
                  isSelf: typed.toLowerCase() ==
                      context
                          .read<AuthenticationBloc>()
                          .state
                          .user
                          .name
                          .toLowerCase(),
                  isInvited: invited.contains(typed),
                  isPending: pendingInvite == typed,
                  anyPending: pendingInvite != null,
                  onInvite: onInvite,
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: results.length,
                separatorBuilder: (_, __) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final player = results[index];
                  return _PlayerRow(
                    player: player,
                    isInvited: invited.contains(player.username),
                    isPending: pendingInvite == player.username,
                    anyPending: pendingInvite != null,
                    onInvite: onInvite,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Before anything is typed. Says what the field searches, since it only
/// reaches people who are connected right now.
class _SearchPrompt extends StatelessWidget {
  const _SearchPrompt();

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF014CA3);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Text(
          'Start typing to find a player.\nYou can invite someone who is offline too.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            height: 1.45,
            color: blue.withValues(alpha: 0.55),
          ),
        ),
      ),
    );
  }
}

/// Nobody online matches. The typed name is still sendable -- they may simply
/// be offline, and the invite endpoint does not require them to be connected.
class _NoSearchMatch extends StatelessWidget {
  const _NoSearchMatch({
    required this.query,
    required this.isSelf,
    required this.isInvited,
    required this.isPending,
    required this.anyPending,
    required this.onInvite,
  });

  final String query;
  final bool isSelf;
  final bool isInvited;
  final bool isPending;
  final bool anyPending;
  final ValueChanged<String> onInvite;

  static const _blue = Color(0xFF014CA3);

  @override
  Widget build(BuildContext context) {
    if (isSelf) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Text(
            "That's you.\nSearch for someone else to invite.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 1.45,
              color: _blue.withValues(alpha: 0.55),
            ),
          ),
        ),
      );
    }

    final canInvite = !isInvited && !anyPending;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No one online called "$query"',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: _blue,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'They may be offline. Send it anyway and they will see it next time they open the app.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                height: 1.4,
                color: _blue.withValues(alpha: 0.55),
              ),
            ),
            SizedBox(height: 14.h),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: canInvite ? () => onInvite(query) : null,
              child: Opacity(
                opacity: canInvite || isPending ? 1 : 0.55,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isInvited ? Colors.transparent : _blue,
                    border:
                        isInvited ? Border.all(color: _blue, width: 1.5) : null,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: isPending
                      ? SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text(
                          isInvited ? 'Invited' : 'Invite "$query" anyway',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: isInvited ? _blue : Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
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
