import 'dart:async';

import 'package:bible_game/app.dart' show navigatorKey;
import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:bible_game/features/multi_player/widget/modal/game_request_modal.dart';
import 'package:bible_game/features/multi_player/widget/modal/players_waiting_modal.dart';
import 'package:bible_game/shared/features/multiplayer/cubit/websocket_cubit.dart';
import 'package:bible_game/shared/widgets/multi_avatar.dart';
import 'package:bible_game_api/model/game_invites_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Tracks whether a question screen is anywhere in the navigator stack.
///
/// A banner during a timed question is a distraction at best, and Accept next
/// to a running game is a way to lose it -- so the watcher stays quiet there.
/// Dialogs push unnamed routes, so this keeps the whole stack rather than just
/// the top route, which would read as "no game" the moment a modal opened.
class CurrentRouteObserver extends NavigatorObserver {
  static final ValueNotifier<bool> inQuestionScreen = ValueNotifier(false);

  final List<Route<dynamic>> _stack = [];

  void _sync() {
    inQuestionScreen.value = _stack
        .any((route) => (route.settings.name ?? '').contains('question_screen'));
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.add(route);
    _sync();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.remove(route);
    _sync();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _stack.remove(route);
    _sync();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) _stack.remove(oldRoute);
    if (newRoute != null) _stack.add(newRoute);
    _sync();
  }
}

/// Shows an invite banner over whatever the user is doing, anywhere in the app.
///
/// Sits in MaterialApp.builder so it outlives every route. The invite arrives
/// through the existing poll rather than the push notification, because the
/// backend's push carries only a title and body -- no type, no room id -- so
/// there is nothing in it to key off reliably.
class GameInviteWatcher extends StatefulWidget {
  const GameInviteWatcher({super.key, required this.child});

  final Widget child;

  @override
  State<GameInviteWatcher> createState() => _GameInviteWatcherState();
}

class _GameInviteWatcherState extends State<GameInviteWatcher> {
  /// Invites already shown, so a poll every ten seconds does not re-announce
  /// the same one until it is answered.
  final Set<String> _announced = {};

  /// Whether the first list has landed. Invites already waiting at login are
  /// recorded without a banner -- they are not news, and popping four at once
  /// on launch would be worse than the badge they already have.
  bool _primed = false;

  GameInviteModel? _banner;
  Timer? _dismissTimer;
  bool _accepting = false;

  static const _visibleFor = Duration(seconds: 8);

  @override
  void dispose() {
    _dismissTimer?.cancel();
    super.dispose();
  }

  void _onInvites(List<GameInviteModel> invites) {
    final live = invites
        .where((invite) =>
            invite.id != null &&
            (invite.pending ?? false) &&
            !(invite.expired ?? false))
        .toList();

    if (!_primed) {
      _primed = true;
      _announced.addAll(live.map((invite) => invite.id!));
      return;
    }

    GameInviteModel? fresh;
    for (final invite in live) {
      if (!_announced.contains(invite.id)) {
        fresh = invite;
        break;
      }
    }
    if (fresh == null) return;

    // Left unannounced on purpose while a game is running: the next poll after
    // they leave the question screen will surface it, as long as it is still
    // pending by then.
    if (CurrentRouteObserver.inQuestionScreen.value) return;

    _announced.add(fresh.id!);
    _show(fresh);
  }

  void _show(GameInviteModel invite) {
    _dismissTimer?.cancel();
    setState(() {
      _banner = invite;
      _accepting = false;
    });
    _dismissTimer = Timer(_visibleFor, _hide);
  }

  void _hide() {
    _dismissTimer?.cancel();
    if (!mounted) return;
    setState(() {
      _banner = null;
      _accepting = false;
    });
  }

  void _view() {
    final context = navigatorKey.currentContext;
    _hide();
    if (context != null) showGameRequestModal(context);
  }

  void _accept() {
    final invite = _banner;
    if (invite?.id == null) return;
    setState(() => _accepting = true);
    // Cancel the auto-dismiss: the banner has to stay put until the request
    // comes back, otherwise it vanishes mid-spin.
    _dismissTimer?.cancel();
    context.read<MultiplayerBloc>().add(AcceptAndJoin(invite!.id!));
  }

  /// Mirrors what the game request modal does on accept, since the banner is
  /// now a second door into the same flow.
  void _onAccepted(MultiplayerState state) {
    if (!_accepting) return;
    _hide();

    final navContext = navigatorKey.currentContext;
    if (navContext == null) return;

    navContext.read<WebsocketCubit>().subscribeToWaitingRoom();

    final type = state.createGameRoomResponse.victoryCondition?.type;
    showPlayersWaitingForHostModal(
      navContext,
      selectedGroupName: type == 'LIGHTNING'
          ? 'Lightning Mode'
          : type == 'FIRST_TO_X'
              ? 'First to X'
              : '',
      inviteCode: state.createGameRoomResponse.inviteCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MultiplayerBloc, MultiplayerState>(
          listenWhen: (previous, current) =>
              previous.listOfInvite != current.listOfInvite,
          listener: (_, state) => _onInvites(state.listOfInvite),
        ),
        BlocListener<MultiplayerBloc, MultiplayerState>(
          listenWhen: (previous, current) =>
              !previous.hasAcceptedInvite && current.hasAcceptedInvite,
          listener: (_, state) => _onAccepted(state),
        ),
        // A failed accept leaves the banner spinning forever otherwise.
        BlocListener<MultiplayerBloc, MultiplayerState>(
          listenWhen: (previous, current) =>
              previous.isLoadingAcceptInvite &&
              !current.isLoadingAcceptInvite &&
              !current.hasAcceptedInvite,
          listener: (_, __) {
            if (_accepting) _hide();
          },
        ),
      ],
      child: Stack(
        children: [
          widget.child,
          if (_banner != null)
            _InviteBanner(
              invite: _banner!,
              isAccepting: _accepting,
              onView: _view,
              onAccept: _accept,
              onDismiss: _hide,
            ),
        ],
      ),
    );
  }
}

class _InviteBanner extends StatelessWidget {
  const _InviteBanner({
    required this.invite,
    required this.isAccepting,
    required this.onView,
    required this.onAccept,
    required this.onDismiss,
  });

  final GameInviteModel invite;
  final bool isAccepting;
  final VoidCallback onView;
  final VoidCallback onAccept;
  final VoidCallback onDismiss;

  static const _blue = Color(0xFF014CA3);

  String get _modeLabel {
    switch (invite.gameMode) {
      case 'LIGHTNING':
      case 'LIGHTNING_MODE':
        return 'Lightning';
      case 'FIRST_TO_X':
        return 'First to X';
      default:
        return 'multiplayer';
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = invite.inviterUsername ?? 'Someone';

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          bottom: false,
          child: Dismissible(
            key: ValueKey(invite.id),
            direction: DismissDirection.up,
            onDismissed: (_) => onDismiss(),
            child: GestureDetector(
              onTap: isAccepting ? null : onView,
              child: Container(
                margin: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 0),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: const Color(0xFFF8E7DE), width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    AvatarWidget(
                        seed: invite.inviterId?.toString() ?? name,
                        width: 36.w,
                        height: 36.w),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: _blue,
                            ),
                          ),
                          Text(
                            'invited you to a $_modeLabel game',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withValues(alpha: 0.55),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    if (isAccepting)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(_blue),
                          ),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: onAccept,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 7.h),
                          decoration: BoxDecoration(
                            color: _blue,
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Text(
                            'Accept',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
