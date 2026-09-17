import 'dart:async';
import 'package:bible_game_api/bible_game_api.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/utils/country_iso_3.dart';
import '../../../../shared/utils/custom_toast.dart';
import '../../../../shared/utils/formatter.dart';
import '../../../../shared/utils/user_badge.dart';
import '../../../../shared/widgets/multi_avatar.dart';

/// Returns when the sheet closes, so a caller can refresh presence it was
/// showing behind it.
///
/// A sheet rather than a dialog: it slides up from the bottom and takes most
/// of the screen, which at forty-odd players online fits roughly twice the
/// rows the old 400h dialog did.
Future<void> showInviteModal(BuildContext context, {required String gameMode}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Invite players',
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (_, __, ___) => InviteModal(gameMode: gameMode),
    transitionBuilder: (context, animation, _, child) {
      final curved =
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return SlideTransition(
        position:
            Tween(begin: const Offset(0, 1), end: Offset.zero).animate(curved),
        child: child,
      );
    },
  );
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

  /// Who has already been invited this session, so their row can say so
  /// instead of offering a second invite that the server would reject.
  final Set<String> _invited = {};

  /// The row currently waiting on a response. The bloc only carries a single
  /// isLoadingGameInvite flag, so without this every row would spin at once.
  String? _pendingInvite;

  /// Presence goes stale while the sheet sits open -- people connect and drop
  /// while you are reading the list. Cancelled in dispose, so it cannot
  /// outlive the sheet.
  Timer? _onlineRefreshTimer;

  /// Waits for a pause in typing before asking the server. Without it every
  /// keystroke is a request, and the answers race each other back.
  Timer? _searchDebounce;

  static const _onlineRefreshInterval = Duration(seconds: 15);
  static const _searchDebounceDelay = Duration(milliseconds: 300);

  static const _blue = Color(0xFF014CA3);
  static const _ink = Color(0xFF122F52);

  /// How far the sheet has been dragged down, in pixels. The grab handle
  /// implied this was possible while doing nothing, which is worse than not
  /// drawing one.
  double _dragOffset = 0;
  bool _dragging = false;

  /// A quarter of the sheet, or a downward fling, closes it. Below that it
  /// springs back -- a drag you did not mean should not lose your place.
  static const _dismissFraction = 0.25;
  static const _dismissVelocity = 700.0;

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragging = true;
      // Downward only. Dragging up would lift the sheet off the bottom of the
      // screen and show the backdrop beneath it.
      _dragOffset = (_dragOffset + details.delta.dy).clamp(0.0, 10000.0);
    });
  }

  void _onDragEnd(DragEndDetails details, double sheetHeight) {
    final flung = details.velocity.pixelsPerSecond.dy > _dismissVelocity;
    if (flung || _dragOffset > sheetHeight * _dismissFraction) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      _dragging = false;
      _dragOffset = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<MultiplayerBloc>().add(FetchOnlinePlayers());

    _onlineRefreshTimer = Timer.periodic(_onlineRefreshInterval, (_) {
      // A request in flight would only race the one we are waiting on, and
      // refreshing the browse list under a search would be answering a
      // question nobody asked.
      if (!mounted || _pendingInvite != null || _query.isNotEmpty) return;
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

  String get _query => textController.text.trim();

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    // Clearing the field should empty the results at once -- waiting 300ms to
    // drop them leaves stale names under an empty box.
    if (value.trim().isEmpty) {
      context.read<MultiplayerBloc>().add(SearchOnlinePlayers(''));
      setState(() {});
      return;
    }
    // Rebuild now so the clear button and the stale-results check see the new
    // text before the request goes out.
    setState(() {});
    _searchDebounce = Timer(_searchDebounceDelay, () {
      if (!mounted) return;
      context.read<MultiplayerBloc>().add(SearchOnlinePlayers(value));
    });
  }

  void _invite(String username) {
    setState(() => _pendingInvite = username);
    context.read<MultiplayerBloc>().add(GameInvites(username, widget.gameMode));
  }

  /// Everyone the endpoint returned except you. It does not exclude the
  /// caller, so without this searching your own name offers you an Invite
  /// button the server can only reject.
  List<OnlinePlayer> _withoutSelf(List<OnlinePlayer> players) {
    final currentUserId = context.read<AuthenticationBloc>().state.user.id;
    return players.where((p) => p.userId != currentUserId).toList();
  }

  @override
  Widget build(BuildContext context) {
    final sheetHeight = MediaQuery.of(context).size.height * 0.82;

    return Align(
      alignment: Alignment.bottomCenter,
      // Tracks the finger exactly while dragging, and eases back when the
      // drag was not far enough to close.
      child: AnimatedSlide(
        duration: _dragging ? Duration.zero : const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        offset: Offset(0, _dragOffset / sheetHeight),
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: sheetHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2EB),
              borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
            ),
            child: BlocListener<MultiplayerBloc, MultiplayerState>(
              // Only react to the moment an invite finishes -- keying off
              // hasInvitedUser alone would fire on every unrelated emission,
              // the online-players fetch included.
              listenWhen: (previous, current) =>
                  previous.isLoadingGameInvite && !current.isLoadingGameInvite,
              listener: (context, state) {
                final invitee = _pendingInvite;
                // "already been sent" means the row is, in fact, invited -- so
                // mark it rather than leaving a button that will fail again.
                final alreadyInvited = !state.hasInvitedUser &&
                    state.gameInviteError
                        .toLowerCase()
                        .contains('already been sent');
                setState(() {
                  _pendingInvite = null;
                  if ((state.hasInvitedUser || alreadyInvited) &&
                      invitee != null) {
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
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topBar(sheetHeight),
                  _header(),
                  SizedBox(height: 14.h),
                  _searchField(),
                  SizedBox(height: 16.h),
                  Expanded(child: _results()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// The handle and the close button, above the title.
  ///
  /// Only this strip takes the drag. Putting it on the whole sheet would have
  /// it fighting the roster's own scrolling, and the loser of that fight is
  /// whichever one the finger happened to start on.
  Widget _topBar(double sheetHeight) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: (details) => _onDragEnd(details, sheetHeight),
      child: SizedBox(
        height: 48.h,
        width: double.infinity,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 10.h),
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: _ink.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            Positioned(
              right: 12.w,
              top: 2.h,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Image.asset(IconImageRoutes.redCircleClose, width: 42.w),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Invite Players',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: _blue,
            ),
          ),
          SizedBox(height: 4.h),
          BlocBuilder<MultiplayerBloc, MultiplayerState>(
            buildWhen: (p, c) => p.onlinePlayersTotal != c.onlinePlayersTotal,
            builder: (context, state) {
              // The endpoint's total, not the page length: it pages at
              // 20, so counting the loaded list stopped at 20 forever.
              // Minus yourself, who it always includes.
              final total = state.onlinePlayersTotal;
              final others = total > 0 ? total - 1 : 0;
              return Row(
                children: [
                  Container(
                    width: 7.w,
                    height: 7.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF19A44B),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    others == 1 ? '1 player online' : '$others players online',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: _ink.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search by username',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              color: _ink,
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: textController,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.search,
            onChanged: _onSearchChanged,
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
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: textController,
                builder: (context, value, _) {
                  if (value.text.isEmpty) return const SizedBox.shrink();
                  return GestureDetector(
                    onTap: () {
                      textController.clear();
                      _onSearchChanged('');
                    },
                    child: Icon(Icons.close_rounded,
                        size: 17.sp, color: _blue.withValues(alpha: 0.45)),
                  );
                },
              ),
              suffixIconConstraints: BoxConstraints(minWidth: 34.w),
              // Left-aligned with the @ in front, so it reads as a prompt.
              // Centred hint text in a filled box reads as a value.
              hintText: 'Enter their username',
              hintStyle: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: _blue.withValues(alpha: 0.38),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: _blue, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// One list, not two tabs. The old split made you pick a method before you
  /// knew which you needed; now the roster is there to scroll and typing
  /// narrows it.
  Widget _results() {
    final query = _query;

    return BlocBuilder<MultiplayerBloc, MultiplayerState>(
      builder: (context, state) {
        final searching = query.isNotEmpty;

        // While the debounce is still pending the results belong to an older
        // prefix, so treat that gap as loading rather than as an answer.
        final isStale = searching && state.playerSearchQuery != query;
        final loading = searching
            ? (state.isSearchingPlayers || isStale)
            : (state.isFetchingOnlinePlayers && state.onlinePlayers.isEmpty);

        final players = _withoutSelf(
            searching ? state.playerSearchResults : state.onlinePlayers);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                searching ? 'Results' : 'Online Players',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: _ink,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: loading
                  ? const _LoadingRows()
                  : players.isEmpty
                      ? (searching
                          ? _NoSearchMatch(
                              query: query,
                              // Inviting yourself only ever comes back an
                              // error, so the row is not offered.
                              isSelf: query.toLowerCase() ==
                                  context
                                      .read<AuthenticationBloc>()
                                      .state
                                      .user
                                      .name
                                      .toLowerCase(),
                              isInvited: _invited.contains(query),
                              isPending: _pendingInvite == query,
                              anyPending: _pendingInvite != null,
                              onInvite: _invite,
                            )
                          : const _NoOneOnline())
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                          itemCount: players.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            final player = players[index];
                            return _PlayerRow(
                              player: player,
                              isInvited: _invited.contains(player.username),
                              isPending: _pendingInvite == player.username,
                              anyPending: _pendingInvite != null,
                              onInvite: _invite,
                            );
                          },
                        ),
            ),
          ],
        );
      },
    );
  }
}

/// One invitable player. Shared by the roster and the search results so a name
/// looks and behaves the same whichever way you arrived at it.
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
    final country = player.country.replaceAll('/', ' ');
    // Read once into a local so the null check promotes it for the badge.
    final level = player.level;

    // Only the pill invites. Tapping the card did too, which made an
    // irreversible action reachable by a stray tap anywhere in the row.
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: isTappable || isPending ? 1 : 0.55,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF4C8),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFD9CE7E)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFBFAE4E).withValues(alpha: 0.5),
              offset: const Offset(0, 3),
              blurRadius: 0,
              spreadRadius: -1,
            ),
          ],
        ),
        child: Row(
          children: [
            // Seeded on the user id like every other avatar in the app, so a
            // player looks the same here as on the leaderboard. profileUrl is
            // no good as a seed: most accounts share one default placeholder
            // URL, which gave them all one face.
            Stack(
              children: [
                AvatarWidget(
                    seed: player.userId.toString(), width: 38.w, height: 38.w),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF19A44B),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
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
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF014CA3),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      if (country.isNotEmpty) ...[
                        SvgPicture.asset(
                          'assets/images/flags/${country.toLowerCase()}.svg',
                          width: 15.w,
                          // A country the flag set does not cover should cost
                          // a flag, not the whole row.
                          placeholderBuilder: (_) => SizedBox(width: 15.w),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          getIso3Code(country),
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF082D5A),
                          ),
                        ),
                        SizedBox(width: 7.w),
                      ],
                      // Only when the endpoint sent one -- otherwise every
                      // player wears the default badge and it means nothing.
                      if (level != null && level.isNotEmpty) ...[
                        Image.asset(getBadgeUrl(level), width: 12.sp),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            capitalizeText(level),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF5047C4),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
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
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 7.h),
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
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: isInvited ? Colors.transparent : Colors.white,
        border: Border.all(color: blue, width: isInvited ? 1.5 : 1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isInvited ? Icons.check_rounded : Icons.add_rounded,
              size: 14.sp, color: blue),
          SizedBox(width: 4.w),
          Text(
            isInvited ? 'Invited' : 'Invite',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: blue,
            ),
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
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (_, index) => Opacity(
        // Fades down the list so it reads as loading rather than as content.
        opacity: 1 - (index * 0.22),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFF1E4B8)),
          ),
          child: Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1DCD1),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Bar(width: 86.w, height: 11.h),
                    SizedBox(height: 6.h),
                    _Bar(width: 54.w, height: 9.h),
                  ],
                ),
              ),
              _Bar(width: 62.w, height: 26.h, radius: 16),
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
                fontWeight: FontWeight.w800,
                color: blue,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Search a username above to invite someone anyway.',
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

/// Nobody online matches. The typed name is still sendable -- the endpoint
/// only searches players who are connected, and the invite endpoint does not
/// require them to be.
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
              fontSize: 13.sp,
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
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: _blue,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'They may be offline. Send it anyway and they will see it next time they open the app.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                height: 1.4,
                color: _blue.withValues(alpha: 0.55),
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: canInvite ? () => onInvite(query) : null,
              child: Opacity(
                opacity: canInvite || isPending ? 1 : 0.55,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 11.h),
                  decoration: BoxDecoration(
                    color: isInvited ? Colors.transparent : _blue,
                    border:
                        isInvited ? Border.all(color: _blue, width: 1.5) : null,
                    borderRadius: BorderRadius.circular(22.r),
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
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
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
