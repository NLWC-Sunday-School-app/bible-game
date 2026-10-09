import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:bible_game/app.dart' show navigatorKey;
import 'package:bible_game/features/arcade/cubit/arcade_tab_cubit.dart';
import 'package:bible_game/features/multi_player/active_room_store.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:bible_game/features/multi_player/invite_link.dart';
import 'package:bible_game/features/multi_player/widget/modal/join_gameplay_modal.dart';
import 'package:bible_game/navigation/cubit/navigation_cubit.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/multiplayer/game_invite_watcher.dart';
import 'package:bible_game/shared/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Opens the game an invite link points at.
///
/// Sits in MaterialApp.builder so it outlives every route. A link is held
/// until the app can act on it: the splash screen has handed over to home,
/// no question screen is running, and someone is signed in -- a signed-out
/// player is taken to the Multiplayer tab's sign-in and joined once they are.
class InviteLinkHandler extends StatefulWidget {
  InviteLinkHandler(
      {super.key,
      required this.child,
      this.links,
      ActiveRoomStore? activeRoomStore})
      : activeRoomStore = activeRoomStore ?? ActiveRoomStore();

  final Widget child;
  final ActiveRoomStore activeRoomStore;

  /// Incoming links. Defaults to the platform's; tests pass their own.
  final Stream<Uri>? links;

  @override
  State<InviteLinkHandler> createState() => _InviteLinkHandlerState();
}

class _InviteLinkHandlerState extends State<InviteLinkHandler> {
  StreamSubscription<Uri>? _linkSubscription;
  StreamSubscription<AuthenticationState>? _authSubscription;

  /// The code waiting to be joined.
  String? _pending;

  /// Set once a signed-out player has been shown where to sign in for the
  /// pending code, so every later route or auth change does not navigate
  /// them there again.
  bool _sentToSignIn = false;

  /// The last code handled and when. The platform hands the launch link over
  /// on the stream and some platforms repeat it on resume; one tap should be
  /// one join.
  String? _lastCode;
  DateTime? _lastAt;

  @override
  void initState() {
    super.initState();
    _linkSubscription =
        (widget.links ?? AppLinks().uriLinkStream).listen(_onLink);
    _authSubscription = context
        .read<AuthenticationBloc>()
        .stream
        .listen((_) => _tryJoinNextFrame());
    CurrentRouteObserver.homeInStack.addListener(_tryJoinNextFrame);
    CurrentRouteObserver.inQuestionScreen.addListener(_tryJoinNextFrame);
  }

  /// The route notifiers fire from inside the navigator's own push and pop,
  /// while it is locked against further navigation -- so act a frame later,
  /// once it has finished.
  void _tryJoinNextFrame() {
    if (_pending == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryJoin());
    WidgetsBinding.instance.scheduleFrame();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _authSubscription?.cancel();
    CurrentRouteObserver.homeInStack.removeListener(_tryJoinNextFrame);
    CurrentRouteObserver.inQuestionScreen.removeListener(_tryJoinNextFrame);
    super.dispose();
  }

  void _onLink(Uri uri) {
    final code = InviteLink.codeFrom(uri);
    if (code == null) return;

    final now = DateTime.now();
    if (code == _lastCode &&
        _lastAt != null &&
        now.difference(_lastAt!) < const Duration(seconds: 5)) {
      return;
    }
    _lastCode = code;
    _lastAt = now;

    _pending = code;
    _sentToSignIn = false;
    _tryJoin();
  }

  void _tryJoin() {
    final code = _pending;
    if (code == null || !mounted) return;
    // Still on the splash screen, or mid-game: both clear a listener above,
    // which brings this back round.
    if (!CurrentRouteObserver.homeInStack.value) return;
    if (CurrentRouteObserver.inQuestionScreen.value) return;
    final navigator = navigatorKey.currentState;
    if (navigator == null) return;

    final signedIn = context.read<AuthenticationBloc>().state.isLoggedIn;
    if (!signedIn && _sentToSignIn) return;

    // The Multiplayer tab either way: signed out, it is where the sign-in
    // for multiplayer is.
    navigator.popUntil((route) =>
        route.settings.name == AppRoutes.home || route.isFirst);
    context.read<ArcadeTabCubit>().showMultiplayer();
    context.read<NavigationCubit>().selectTab(3);

    if (!signedIn) {
      _sentToSignIn = true;
      CustomToast.showBanner(navigator.context, 'Sign in to join game $code',
          overlay: navigator.overlay);
      return;
    }

    _pending = null;
    final multiplayer = context.read<MultiplayerBloc>();
    // Our own game: joining it again would add a second player for us, so go
    // back into it the way the resume card does. Read from the saved room as
    // well as the bloc, which may not have loaded it yet straight after launch.
    final userId = context.read<AuthenticationBloc>().state.user.id.toString();
    final savedCode = widget.activeRoomStore.read(userId)?.inviteCode ??
        multiplayer.state.resumableRoom?.inviteCode;
    if (savedCode?.toUpperCase() == code) {
      multiplayer.add(const ResumeActiveRoom());
      return;
    }
    showJoinGamePlayModal(navigator.context, initialCode: code);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
